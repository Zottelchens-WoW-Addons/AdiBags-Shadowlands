import os
import sqlite3
from glob import glob
from pathlib import Path

import requests

import blizzauth


# OUTDIR = 'out/'
OUTDIR = str(Path(os.path.dirname(os.path.realpath(__file__))).parent) + "/"


def main():
    all_item_dict = {}

    access_token = blizzauth.get_access()
    for idfile in glob('items/*.txt'):
        sort_file(idfile)
        groupname = Path(idfile).stem
        disabled = False
        if "#" in groupname:
            disabled = True
            groupname = groupname.replace('#', '')
        group = {'disabled_by_default': disabled, 'comment': '', 'adibagsdesc': '', 'adibagscolor': ''}
        items = []
        with open(idfile, 'r') as f:
            print('Getting Names for:', groupname)
            for line in f:
                if '#' in line:
                    group['comment'] = line.strip().replace('#', '')
                    print("\tFound Markdown Comment:", group['comment'])
                elif '!' in line:
                    group['adibagsdesc'] = line.strip().replace('!', '')
                    print("\tFound AdiBags Description:", group['adibagsdesc'])
                elif '$' in line:
                    group['adibagscolor'] = 'ff' + line.strip().replace('$', '').lower()
                    print("\tFound AdiBags Color:", group['adibagscolor'])
                else:
                    items.append({'id': line.strip(), 'name': get_item_name(line.strip(), access_token)})
        group['items'] = items
        all_item_dict[groupname] = group

    create_markdown(all_item_dict)
    create_lua(all_item_dict)
    create_toc()


def get_item_name(itemid, access_token):
    c.execute("SELECT EXISTS(SELECT 1 FROM itemnames WHERE id=?)", (itemid,))
    record = c.fetchone()
    if record[0] == 1:
        c.execute("SELECT * FROM itemnames WHERE id=?", (itemid,))
        record = c.fetchone()
        item_name = record[1]
    else:
        # https://eu.api.blizzard.com/data/wow/item/19019?namespace=static-us&locale=en_GB&access_token=USPG9Vwd4iFxbiybTTrHhVa1r437EXYESp
        r = requests.get("https://us.api.blizzard.com/data/wow/item/" + itemid + "?namespace=static-us&locale=en_us&access_token=" + access_token)
        try:
            item_name = r.json()["name"]
            c.execute("INSERT INTO itemnames (id, name) VALUES (?, ?);", (itemid, item_name))
            db.commit()
        except KeyError as e:
            print("Error at ID", itemid, ":", str(e), '\nJSON:', r.text)
            item_name = 'ERROR'
    return item_name


def create_markdown(itemdict):
    print("Creating Markdown file.")
    str_markdown = "# How to Read this\n\nAll items are broken down into categories, with itemID followed by the Item name.\nLatest version: @project-version@\n\n"
    for key in itemdict:
        post_title = ''
        if itemdict[key]['disabled_by_default']:
            post_title = "(Disabled by default)"
        str_markdown += "## {} {}\n\n".format(key, post_title)
        if itemdict[key]['comment'] != '':
            str_markdown += itemdict[key]['comment'] + "\n\n"
        for i in itemdict[key]['items']:
            str_markdown += " * {} - {}\n".format(i['id'], i['name'])
        str_markdown += "\n"
        with open(OUTDIR + 'addon_supported_items.md', 'w', encoding='utf8') as f:
            f.write(str_markdown)


def create_lua(itemdict):
    print("Creating LUA file.")
    itemlist, profiledefaults, filters, settings = "", "", "", ""
    order_counter = 0
    for key in itemdict:
        key_clean = key.replace(' ', '').replace("'", "")
        # ITEM LISTE
        itemlist += "\n -- {}\nlocal {} = 🍗".format(key, key_clean + 'IDs')
        for i in itemdict[key]['items']:
            itemlist += "\n{}, -- {}".format(i['id'], i['name'])
        itemlist += '\n}\n'
        enabled = 'true'
        # DEFAULT PROFIL
        if itemdict[key]['disabled_by_default']:
            enabled = 'false'
        profiledefaults += '\n            {} = {},'.format('move' + key_clean, enabled)
        # ADD TO FILTERS (MatchIDs)
        colorkey = key
        if itemdict[key]['adibagscolor'] != '':
            colorkey = "|c" + itemdict[key]['adibagscolor'] + key + '|r'
        filters += '\tif self.db.profile.{0} then\n\t\tif self.db.profile.showcoloredCategories then\n\t\t\tResult["{1}"] = AddToSet({2})\n\t\telse\n\t\t\tResult[unescape("{1}")] = AddToSet({2})\n\t\tend\n\tend\n\n'.format(
            'move' + key_clean, colorkey, key_clean + 'IDs')
        # SETTINGS SCREEN
        order_counter += 10
        settings += '\t\t{} = 🍗\n\t\t\tname = "{}",\n\t\t\tdesc = "{}",\n\t\t\ttype = "toggle",\n\t\t\torder = {}\n\t\t🍖,\n\n'.format('move' + key_clean, key, itemdict[key]['adibagsdesc'], order_counter)

    # CATEGORYCOLOR SETTING
    settings += '\t\t{} = 🍗\n\t\t\tname = "{}",\n\t\t\tdesc = "{}",\n\t\t\ttype = "toggle",\n\t\t\torder = {}\n\t\t🍖,\n\n'.format('showcoloredCategories',
                                                                                                                                    r'|cffff98abC|cffffa094o|cffffa77el|cffffaf67o|cfffebf71r|cfffecf7be|cfffddf85d|cffe0d988 |cffc3d38bC|cffa6cd8ea|cff9bccaet|cff8fcbcde|cff95bad2g|cff9aa9d7o|cffa098dcr|cffae98dci|cffbd98dce|cffcb98dcs|r',
                                                                                                                                    'Should Categories be colored?', order_counter + 10)
    profiledefaults += '\n            {} = {},'.format('showcoloredCategories', 'true')
    # putting it all together
    str_lua = get_form("lua.lua")
    str_lua = str_lua.format(itemlist, filters, profiledefaults, settings)
    str_lua = str_lua.replace('🍤', '{}').replace('🍗', '{').replace('🍖', '}').replace('\t', '    ')
    with open(OUTDIR + 'AdiBags_Shadowlands.lua', 'w', encoding='utf8') as f:
        f.write(str_lua)


def create_toc():
    print("Creating TOC file.")
    str_toc = get_form("toc.toc")
    with open(OUTDIR + 'AdiBags_Shadowlands.toc', 'w', encoding='utf8') as f:
        f.write(str_toc)


def sort_file(file):
    with open(file, 'r') as r:
        uniq = sorted(set(r.readlines()))
    with open(file, 'w') as w:
        w.writelines(uniq)


def get_form(form):
    content = Path("forms/"+form).read_text(encoding='utf-8')
    if form == "lua.lua":
        content = content.replace('{}', '🍤').replace('{', '🍗').replace('}', '🍖')
        content = content.replace('--!!PH', '{}')
    return content



#########################################################################################
db = sqlite3.connect("itemname.cache.sqlite")
c = db.cursor()
c.execute("CREATE TABLE IF NOT EXISTS itemnames (id INTEGER PRIMARY KEY, name TEXT)")

get_form("lua.lua")
main()

c.close()
#########################################################################################
