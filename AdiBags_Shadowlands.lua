--[[
AdiBags - Shadowlands
by Zottelchen
version: @project-version@
Add various Shadowlands items to AdiBags filter groups
]]

local addonName, addon = ...
local AdiBags = LibStub("AceAddon-3.0"):GetAddon("AdiBags")

local L = addon.L
local MatchIDs
local Result = {}

local function AddToSet(List)
    local Set = {}
    for _, v in ipairs(List) do
        Set[v] = true
    end
    return Set
end

local function unescape(String)
    local unescaped = tostring(String)
    unescaped = gsub(unescaped, "|c........", "") -- Remove color start.
    unescaped = gsub(unescaped, "|r", "") -- Remove color end.
    -- Result = gsub(Result, "|H.-|h(.-)|h", "%1") -- Remove links.
    -- Result = gsub(Result, "|T.-|t", "") -- Remove textures.
    -- Result = gsub(Result, "{.-}", "") -- Remove raid target icons.
    return unescaped
end


 -- Food
local FoodIDs = {
172040, -- Butterscotch Marinated Ribs
172041, -- Spinefin Souffle and Fries
172042, -- Surprisingly Palatable Feast
172043, -- Feast of Gluttonous Hedonism
172044, -- Cinnamon Bonefish Stew
172045, -- Tenebrous Crown Roast Aspic
172046, -- Biscuits and Caviar
172047, -- Candied Amberjack Cakes
172048, -- Meaty Apple Dumplings
172049, -- Iridescent Ravioli with Apple Sauce
172050, -- Sweet Silvergill Sausages
172051, -- Steak a la Mode
172061, -- Seraph Tenders
172062, -- Smothered Shank
172063, -- Fried Bonefish
172068, -- Pickled Meat Smoothie
172069, -- Banana Beef Pudding
184624, -- Extra Sugary Fish Feast
184682, -- Extra Lemony Herb Filet
184690, -- Extra Fancy Darkmoon Feast
}

 -- Rings
local RingsIDs = {
173131, -- Versatile Solenium Ring
173132, -- Masterful Phaedrum Ring
173133, -- Quick Oxxein Ring
173134, -- Deadly Sinvyr Ring
173135, -- Versatile Laestrite Band
173136, -- Masterful Laestrite Band
173137, -- Quick Laestrite Band
173138, -- Deadly Laestrite Band
173344, -- Band of Chronicled Deeds
175244, -- Spider-Eye Ring
175703, -- Silverspire Signet
175704, -- Reverberating Silver Band
175706, -- Mind-Torn Band
175707, -- Signet of the Learned
175710, -- Night Courtier's Ring
175711, -- Slumberwood Band
175712, -- Shimmerbough Loop
175713, -- Sprigthistle Loop
175714, -- The Chamberlain's Tarnished Signet
175715, -- Gargon Eye Ring
175716, -- Emberscorched Band
175717, -- Inquisitor's Signet
175879, -- Sinful Aspirant's Ring
175916, -- Sinful Gladiator's Ring
177145, -- Sea Sapphire Band
177153, -- Beaten Copper Loop
177164, -- Sea Sapphire Band
177167, -- Beaten Copper Loop
177290, -- Heart-Lesion Ring of Might
177291, -- Heart-Lesion Band of Might
177297, -- Heart-Lesion Ring of Stoicism
177298, -- Heart-Lesion Band of Stoicism
177303, -- Springrain Ring of Onslaught
177304, -- Springrain Band of Onslaught
177309, -- Springrain Band of Destruction
177310, -- Springrain Ring of Destruction
177316, -- Springrain Band of Wisdom
177317, -- Springrain Ring of Wisdom
177323, -- Springrain Ring of Durability
177324, -- Springrain Band of Durability
177329, -- Trailseeker Band of Onslaught
177330, -- Trailseeker Ring of Onslaught
177336, -- Mountainsage Band of Destruction
177337, -- Mountainsage Ring of Destruction
177342, -- Mistdancer Band of Stoicism
177343, -- Mistdancer Ring of Stoicism
177350, -- Mistdancer Ring of Wisdom
177351, -- Mistdancer Band of Wisdom
177357, -- Mistdancer Band of Onslaught
177358, -- Mistdancer Ring of Onslaught
177364, -- Sunsoul Ring of Wisdom
177365, -- Sunsoul Band of Wisdom
177373, -- Sunsoul Ring of Might
177374, -- Sunsoul Band of Might
177380, -- Sunsoul Ring of Stoicism
177381, -- Sunsoul Band of Stoicism
177385, -- Communal Band of Destruction
177386, -- Communal Ring of Destruction
177391, -- Communal Band of Wisdom
177392, -- Communal Ring of Wisdom
177399, -- Lightdrinker Band of Onslaught
177400, -- Lightdrinker Ring of Onslaught
177408, -- Streamtalker Band of Onslaught
177409, -- Streamtalker Ring of Onslaught
177413, -- Streamtalker Ring of Destruction
177414, -- Streamtalker Band of Destruction
177422, -- Streamtalker Ring of Wisdom
177423, -- Streamtalker Band of Wisdom
177577, -- Illidari Band
177578, -- Illidari Ring
177585, -- Felsoul Band of Destruction
177586, -- Felsoul Ring of Destruction
177597, -- Oathsworn Band of Stoicism
177598, -- Oathsworn Ring of Stoicism
177600, -- Oathsworn Ring of Might
177601, -- Oathsworn Band of Might
177811, -- Depraved Tutor's Signet
177812, -- Redelv House Band
178077, -- Briarbane Signet
178171, -- Darkmaul Signet Ring
178293, -- Sinful Aspirant's Band
178329, -- Sinful Aspirant's Signet
178381, -- Sinful Gladiator's Band
178442, -- Sinful Gladiator's Signet
178736, -- Stitchflesh's Misplaced Signet
178781, -- Ritual Commander's Ring
178824, -- Signet of the False Accuser
178848, -- Entwined Gorger Tendril
178869, -- Fleshfused Circle
178870, -- Ritual Bone Band
178871, -- Bloodoath Signet
178872, -- Ring of Perpetual Conflict
178933, -- Arachnid Cipher Ring
179355, -- Death God's Signet
180349, -- Nethrezim Acolyte's Band
180855, -- Competitor's Signet
181217, -- Dominance Guard's Band
181218, -- Chalice Noble's Signet
181626, -- Gorewrought Loop
181702, -- Sanctified Guardian's Signet
181708, -- Leafed Banewood Band
181721, -- Ascendent Valor Signet
183035, -- Ardent Sunstar Signet
183036, -- Most Regal Signet of Sire Denathrius
183037, -- Ritualist's Treasured Ring
183038, -- Hyperlight Band
183631, -- Ring of Carnelian and Sinew
183659, -- Annhylde's Band
183673, -- Nerubian Aegis Ring
183676, -- Hailstone Loop
183685, -- Phantasmic Seal of the Prophet
184105, -- Gyre
184106, -- Gimble
184142, -- Twisted Witherroot Band
184143, -- Band of the Risen Bonelord
184165, -- Seal of Fordragon
184174, -- Clasp of Death
184744, -- Gnarled Boneloop
184756, -- Smoothed Loop of Contemplation
184783, -- Muirnne's Stormforged Signet
184784, -- Punishing Loop
185156, -- Unchained Aspirant's Ring
185192, -- Unchained Gladiator's Ring
185233, -- Unchained Aspirant's Band
185241, -- Unchained Aspirant's Signet
185273, -- Unchained Gladiator's Band
185281, -- Unchained Gladiator's Signet
185813, -- Signet of Collapsing Stars
185840, -- Seal of the Panoply
185894, -- Attendant's Loop
185895, -- Lost Wayfarer's Band
185903, -- Soul-Seeker's Ring
185941, -- Korthian Scholar's Signet
186145, -- Stygian Thorn Loop
186153, -- Foresworn Seal
186290, -- Sworn Oath of the Nine
186375, -- Miniature Breaking Wheel
186376, -- Oscillating Ouroboros
186377, -- Tarnished Insignia of Quel'Thalas
186450, -- Crude Stygian Fastener
186629, -- Sanngor's Spiked Band
186631, -- Emberfused Band
187401, -- Band of the Shaded Rift
187402, -- All-Consuming Loop
187406, -- Band of Blinding Shadows
}

 -- Trinkets
local TrinketsIDs = {
171323, -- Spiritual Alchemy Stone
173069, -- Darkmoon Deck: Putrescence
173078, -- Darkmoon Deck: Repose
173087, -- Darkmoon Deck: Voracity
173096, -- Darkmoon Deck: Indomitable
173349, -- Misfiring Centurion Controller
175718, -- Ascended Defender's Crest
175719, -- Agitha's Void-Tinged Speartip
175722, -- Vial of Caustic Liquid
175723, -- Rejuvenating Serum
175725, -- Newcomer's Gladiatorial Badge
175726, -- Primalist's Kelpling
175727, -- Elder's Stormseed
175728, -- Soulsifter Root
175729, -- Rotbriar Sprout
175730, -- Master Duelist's Chit
175731, -- Stolen Maw Badge
175732, -- Tablet of Despair
175733, -- Brimming Ember Shard
175884, -- Sinful Aspirant's Badge of Ferocity
175921, -- Sinful Gladiator's Badge of Ferocity
175941, -- Spiritual Alchemy Stone
175942, -- Spiritual Alchemy Stone
175943, -- Spiritual Alchemy Stone
177147, -- Seabeast Tusk
177148, -- Lucky Braid
177149, -- Shimmering Rune
177150, -- Petrified Basilisk Scale
177151, -- Oceanographer's Weather Log
177152, -- Privateer's Spyglass
177154, -- Seabeast Tusk
177155, -- Shimmering Rune
177156, -- Petrified Basilisk Scale
177157, -- Bijou of the Golden City
177158, -- Enchanted Devilsaur Claw
177166, -- Lucky Braid
177292, -- Heart-Lesion Stone of Battle
177293, -- Heart-Lesion Idol of Battle
177296, -- Heart-Lesion Defender Idol
177299, -- Heart-Lesion Defender Stone
177302, -- Springrain Idol of Rage
177305, -- Springrain Stone of Rage
177308, -- Springrain Idol of Destruction
177311, -- Springrain Stone of Destruction
177315, -- Springrain Idol of Wisdom
177318, -- Springrain Stone of Wisdom
177322, -- Springrain Idol of Durability
177325, -- Springrain Stone of Durability
177328, -- Trailseeker Idol of Rage
177331, -- Trailseeker Stone of Rage
177335, -- Mountainsage Idol of Destruction
177338, -- Mountainsage Stone of Destruction
177344, -- Mistdancer Defender Stone
177346, -- Mistdancer Defender Idol
177348, -- Mistdancer Idol of Wisdom
177352, -- Mistdancer Stone of Wisdom
177355, -- Mistdancer Idol of Rage
177359, -- Mistdancer Stone of Rage
177363, -- Sunsoul Idol of Wisdom
177366, -- Sunsoul Stone of Wisdom
177375, -- Sunsoul Stone of Battle
177376, -- Sunsoul Idol of Battle
177379, -- Sunsoul Defender Idol
177382, -- Sunsoul Defender Stone
177384, -- Communal Idol of Destruction
177387, -- Communal Stone of Destruction
177390, -- Communal Idol of Wisdom
177393, -- Communal Stone of Wisdom
177398, -- Lightdrinker Idol of Rage
177401, -- Lightdrinker Stone of Rage
177407, -- Streamtalker Idol of Rage
177410, -- Streamtalker Stone of Rage
177412, -- Streamtalker Idol of Destruction
177415, -- Streamtalker Stone of Destruction
177421, -- Streamtalker Idol of Wisdom
177424, -- Streamtalker Stone of Wisdom
177575, -- Demon Trophy
177576, -- Charm of Demonic Fire
177584, -- Felsoul Idol of Destruction
177587, -- Felsoul Stone of Destruction
177596, -- Oathsworn Defender Idol
177599, -- Oathsworn Defender Stone
177602, -- Oathsworn Idol of Battle
177603, -- Oathsworn Stone of Battle
177657, -- Overflowing Ember Mirror
177813, -- Hopebreaker's Badge
178168, -- Darkmaul Ritual Stone
178298, -- Sinful Aspirant's Insignia of Alacrity
178334, -- Sinful Aspirant's Emblem
178386, -- Sinful Gladiator's Insignia of Alacrity
178447, -- Sinful Gladiator's Emblem
178708, -- Unbound Changeling
178715, -- Mistcaller Ocarina
178742, -- Bottled Flayedwing Toxin
178751, -- Spare Meat Hook
178769, -- Infinitely Divisible Ooze
178770, -- Slimy Consumptive Organ
178771, -- Phial of Putrefaction
178772, -- Satchel of Misbegotten Minions
178783, -- Siphoning Phylactery Shard
178808, -- Viscera of Coalesced Hatred
178809, -- Soulletting Ruby
178810, -- Vial of Spectral Essence
178811, -- Grim Codex
178825, -- Pulsating Stoneheart
178826, -- Sunblood Amethyst
178849, -- Overflowing Anima Cage
178850, -- Lingering Sunmote
178861, -- Decanter of Anima-Charged Winds
178862, -- Bladedancer's Armor Kit
179331, -- Blood-Spattered Scale
179342, -- Overwhelming Power Crystal
179350, -- Inscrutable Quantum Device
179356, -- Shadowgrasp Totem
179927, -- Glowing Endmire Stinger
180116, -- Overcharged Anima Battery
180117, -- Empyreal Ordnance
180118, -- Anima Field Emitter
180119, -- Boon of the Archon
180827, -- Maldraxxian Warhorn
181333, -- Sinful Gladiator's Medallion
181334, -- Essence Extractor
181335, -- Sinful Gladiator's Relentless Brooch
181357, -- Tablet of Despair
181358, -- Master Duelist's Chit
181359, -- Overflowing Ember Mirror
181360, -- Brimming Ember Shard
181457, -- Wakener's Frond
181458, -- Queensguard's Vigil
181459, -- Withergrove Shardling
181501, -- Flame of Battle
181502, -- Rejuvenating Serum
181503, -- Vial of Caustic Liquid
181507, -- Beating Abomination Core
181816, -- Sinful Gladiator's Sigil of Adaptation
182451, -- Glimmerdust's Grand Design
182452, -- Everchill Brambles
182453, -- Twilight Bloom
182454, -- Murmurs in the Dark
182455, -- Dreamer's Mending
182682, -- Book-Borrower Identification
183650, -- Miniscule Abomination in a Jar
183849, -- Soulsifter Root
183850, -- Wakener's Frond
183851, -- Withergrove Shardling
184016, -- Skulker's Wing
184017, -- Bargast's Leash
184018, -- Splintered Heart of Al'ar
184019, -- Soul Igniter
184020, -- Tuft of Smoldering Plumage
184021, -- Glyph of Assimilation
184022, -- Consumptive Infusion
184023, -- Gluttonous Spike
184024, -- Macabre Sheet Music
184025, -- Memory of Past Sins
184026, -- Hateful Chain
184027, -- Stone Legion Heraldry
184028, -- Cabalist's Hymnal
184029, -- Manabound Mirror
184030, -- Dreadfire Vessel
184031, -- Sanguine Vintage
184052, -- Sinful Aspirant's Medallion
184053, -- Sinful Aspirant's Relentless Brooch
184054, -- Sinful Aspirant's Sigil of Adaptation
184055, -- Corrupted Gladiator's Medallion
184056, -- Corrupted Gladiator's Relentless Brooch
184057, -- Corrupted Gladiator's Sigil of Adaptation
184058, -- Corrupted Aspirant's Medallion
184059, -- Corrupted Aspirant's Relentless Brooch
184060, -- Corrupted Aspirant's Sigil of Adaptation
184279, -- Siphoning Blood-Drinker
184807, -- Relic of the First Ones
184839, -- Misfiring Centurion Controller
184840, -- Hymnal of the Path
184841, -- Lyre of Sacred Purpose
184842, -- Instructor's Divine Bell
184873, -- Soul Igniter (Test)
185161, -- Unchained Aspirant's Badge of Ferocity
185197, -- Unchained Gladiator's Badge of Ferocity
185238, -- Unchained Aspirant's Insignia of Alacrity
185242, -- Unchained Aspirant's Emblem
185278, -- Unchained Gladiator's Insignia of Alacrity
185282, -- Unchained Gladiator's Emblem
185304, -- Unchained Gladiator's Medallion
185305, -- Unchained Gladiator's Relentless Brooch
185306, -- Unchained Gladiator's Sigil of Adaptation
185309, -- Unchained Aspirant's Medallion
185310, -- Unchained Aspirant's Relentless Brooch
185311, -- Unchained Aspirant's Sigil of Adaptation
185818, -- So'leah's Secret Technique
185836, -- Codex of the First Technique
185844, -- Ticking Sack of Terror
185845, -- First Class Healing Distributor
185846, -- Miniscule Mailemental in an Envelope
185902, -- Iron Maiden's Toolkit
186155, -- Harmonic Crowd Breaker
186156, -- Tome of Insight
186421, -- Forbidden Necromantic Tome
186422, -- Tome of Monstrous Constructions
186423, -- Titanic Ocular Gland
186424, -- Shard of Annhylde's Aegis
186425, -- Scrawled Word of Recall
186427, -- Whispering Shard of Power
186428, -- Shadowed Orb of Torment
186429, -- Decanter of Endless Howling
186430, -- Tormented Rack Fragment
186431, -- Ebonsoul Vise
186432, -- Salvaged Fusion Amplifier
186433, -- Reactive Defense Matrix
186434, -- Weave of Warped Fates
186435, -- Carved Ivory Keepsake
186436, -- Resonant Silver Bell
186437, -- Relic of the Frozen Wastes
186438, -- Old Warrior's Soul
186976, -- Fine Razorwing Quill
186980, -- Unchained Gladiator's Shackles
187447, -- Soul Cage Fragment
}

 -- Upgradeable Items
local UpgradeableItemsIDs = {
}

 -- Abominable Stitching
local AbominableStitchingIDs = {
178061, -- Malleable Flesh
178594, -- Anima-bound Wraps
181371, -- Spare Head
181797, -- Strange Cloth
181798, -- Stuffed Construct
181799, -- Extra Large Hat
183519, -- Necromantic Oil
183743, -- Malleable Flesh
183744, -- Superior Parts
183752, -- Empty Nightcap Cask
183754, -- Stitchflesh's Design Notes
183755, -- Ardenweald Wreath
183756, -- Floating Circlet
183759, -- Unusually Large Cranium
183760, -- Venthyr Spectacles
183786, -- Happiness Bird
183789, -- Six-League Pack
183824, -- Cache of Spare Weapons
183825, -- Oversized Monocle
183826, -- Big Floppy Hat
183827, -- Blacksteel Backplate
183828, -- Friendly Bugs
183829, -- Slime Cat
183830, -- Do It Yourself Flag Kit
183831, -- Safe Fall Kit
183833, -- Kash's Bag of Junk
183873, -- Otherworldy Tea Set
184036, -- Dundae's Hat
184037, -- Maldraxxus Candles
184038, -- Trained Corpselice
184039, -- Clean White Hat
184040, -- Broken Egg Shells
184041, -- Festive Umbrella
184203, -- Fungal Hair Tonic
184204, -- Otherworld Hat
184205, -- Long Lost Crown
184224, -- Dapperling Seeds
184225, -- Small Posable Skeleton
}

 -- Anima
local AnimaIDs = {
181368, -- Centurion Power Core
181377, -- Illustrated Combat Meditation Aid
181477, -- Ardendew Pearl
181478, -- Cornucopia of the Winter Court
181479, -- Starlight Catcher
181540, -- Animaflower Bud
181541, -- Celestial Acorn
181544, -- Confessions of Misdeed
181545, -- Bloodbound Globule
181546, -- Mature Cryptbloom
181547, -- Noble's Draught
181548, -- Darkhaven Soul Lantern
181549, -- Timeworn Sinstone
181550, -- Hopebreaker's Field Injector
181551, -- Depleted Stoneborn Heart
181552, -- Collected Tithe
181642, -- Novice Principles of Plaguistry
181643, -- Weeping Corpseshroom
181644, -- Unlabled Culture Jars
181645, -- Engorged Monstrosity's Heart
181646, -- Bound Failsafe Phylactery
181647, -- Stabilized Plague Strain
181648, -- Ziggurat Focusing Crystal
181649, -- Preserved Preternatural Braincase
181650, -- Spellwarded Dissertation
181743, -- Plume of the Archon
181744, -- Forgelite Ember
181745, -- Forgesmith's Coal
183723, -- Brimming Anima Orb
183727, -- Resonance of Conflict
184146, -- Singed Soul Shackles
184147, -- Agony Enrichment Device
184148, -- Concealed Sinvyr Flask
184149, -- Widowbloom-Infused Fragrance
184150, -- Bonded Tallow Candles
184151, -- Counterfeit Ruby Brooch
184152, -- Bottle of Diluted Anima-Wine
184286, -- Extinguished Soul Anima
184293, -- Sanctified Skylight Leaf
184294, -- Ethereal Ambrosia
184305, -- Maldraxxi Champion's Armaments
184306, -- Soulcatching Sludge
184307, -- Maldraxxi Armor Scraps
184315, -- Multi-Modal Anima Container
184360, -- Musings on Repetition
184362, -- Reflections on Purity
184363, -- Considerations on Courage
184371, -- Vivacity of Collaboration
184373, -- Small Anima Globe
184374, -- Cartel Exchange Vessel
184378, -- Faeweald Amber
184379, -- Queen's Frozen Tear
184380, -- Starblossom Nectar
184381, -- Astral Sapwood
184382, -- Luminous Sylberry
184383, -- Duskfall Tuber
184384, -- Hibernal Sproutling
184385, -- Fossilized Heartwood
184386, -- Nascent Sporepod
184387, -- Misty Shimmerleaf
184388, -- Plump Glitterroot
184389, -- Slumbering Starseed
184519, -- Totem of Stolen Mojo
184763, -- Mnemis Neural Network
184764, -- Colossus Actuator
184765, -- Vesper Strikehammer
184766, -- Chronicles of the Paragons
184767, -- Handheld Soul Mirror
184768, -- Censer of Dried Gracepetals
184769, -- Pressed Torchlily Blossom
184770, -- Roster of the Forgotten
184771, -- Remembrance Parchment Ash
184772, -- Ritual Maldracite Crystal
184773, -- Battle-Tested Armor Component
184774, -- Juvenile Sporespindle
184775, -- Necromancy for the Practical Ritualist
184776, -- Urn of Arena Soil
184777, -- Gravedredger's Shovel
186200, -- Infused Dendrite
186201, -- Ancient Anima Vessel
186202, -- Wafting Koricone
186203, -- Glowing Devourer Stomach
186204, -- Anima-Stained Glass Shards
186205, -- Scholarly Attendant's Bangle
186206, -- Vault Emberstone
186519, -- Compressed Anima Bubble
187175, -- Runekeeper's Ingot
187347, -- Concentrated Anima
187349, -- Anima Laden Egg
187432, -- Magifocus Heartwood
187433, -- Windcrystal Chimes
187434, -- Lightseed Sapling
187517, -- Animaswell Prism
}

 -- Ascended Crafting
local AscendedCraftingIDs = {
178995, -- Soul Mirror Shard
179008, -- Depleted Goliath Core
179009, -- Tampered Anima Charger
179378, -- Soul Mirror
180477, -- Elysian Feathers
180478, -- Champion's Pelt
180594, -- Calloused Bone
180595, -- Nightforged Steel
}

 -- Cataloged Research
local CatalogedResearchIDs = {
186685, -- Relic Fragment
187311, -- Azgoth's Tattered Maps
187322, -- Crumbling Stone Tablet
187323, -- Runic Diagram
187324, -- Gnawed Ancient Idol
187325, -- Faded Razorwing Anatomy Illustration
187326, -- Half-Completed Runeforge Pattern
187327, -- Encrypted Korthian Journal
187328, -- Ripped Cosmology Chart
187329, -- Old God Specimen Jar
187330, -- Naaru Shard Fragment
187331, -- Tattered Fae Designs
187332, -- Recovered Page of Voices
187333, -- Core of an Unknown Titan
187334, -- Shattered Void Tablet
187335, -- Maldraxxus Larva Shell
187336, -- Forbidden Weapon Schematics
187350, -- Displaced Relic
187457, -- Engraved Glass Pane
187458, -- Unearthed Teleporter Sigil
187459, -- Vial of Mysterious Liquid
187460, -- Strangely Intricate Key
187462, -- Scroll of Shadowlands Fables
187463, -- Enigmatic Map Fragments
187465, -- Complicated Organism Harmonizer
187466, -- Korthian Cypher Book
187467, -- Perplexing Rune-Cube
187478, -- White Razorwing Talon
}

 -- Conduits
local ConduitsIDs = {
180842, -- Stalwart Guardian
180843, -- Template Conduit
180844, -- Brutal Vitality
180847, -- Inspiring Presence
180896, -- Safeguard
180932, -- Fueled by Violence
180933, -- Ashen Juggernaut
180935, -- Crash the Ramparts
180943, -- Cacophonous Roar
180944, -- Merciless Bonegrinder
181373, -- Harm Denial
181376, -- Inner Fury
181383, -- Unrelenting Cold
181389, -- Shivering Core
181435, -- Calculated Strikes
181455, -- Icy Propulsion
181461, -- Ice Bite
181462, -- Coordinated Offensive
181464, -- Winter's Protection
181465, -- Xuen's Bond
181466, -- Grounding Breath
181467, -- Flow of Time
181469, -- Indelible Victory
181495, -- Jade Bond
181498, -- Grounding Surge
181504, -- Infernal Cascade
181505, -- Resplendent Mist
181506, -- Master Flame
181508, -- Fortifying Ingredients
181509, -- Arcane Prodigy
181510, -- Lingering Numbness
181511, -- Nether Precision
181512, -- Dizzying Tumble
181539, -- Discipline of the Grove
181553, -- Gift of the Lich
181600, -- Ire of the Ascended
181624, -- Swift Transference
181639, -- Siphoned Malice
181640, -- Tumbling Technique
181641, -- Rising Sun Revival
181698, -- Cryo-Freeze
181700, -- Scalding Brew
181705, -- Celestial Effervescence
181707, -- Diverted Energy
181709, -- Unnerving Focus
181712, -- Depths of Insanity
181734, -- Magi's Brand
181735, -- Hack and Slash
181736, -- Flame Accretion
181737, -- Nourishing Chi
181738, -- Artifice of the Archmage
181740, -- Evasive Stride
181742, -- Walk with the Ox
181756, -- Incantation of Swiftness
181759, -- Strike with Clarity
181769, -- Tempest Barrier
181770, -- Bone Marrow Hops
181774, -- Imbued Reflections
181775, -- Way of the Fae
181776, -- Vicious Contempt
181786, -- Eternal Hunger
181826, -- Translucent Image
181827, -- Move with Grace
181834, -- Chilled Resilience
181836, -- Spirit Drain
181837, -- Clear Mind
181838, -- Charitable Soul
181840, -- Light's Inspiration
181841, -- Reinforced Shell
181842, -- Power Unto Others
181843, -- Shining Radiance
181844, -- Pain Transformation
181845, -- Exaltation
181847, -- Lasting Spirit
181848, -- Accelerated Cold
181866, -- Withering Plague
181867, -- Swift Penitence
181942, -- Focused Mending
181943, -- Eradicating Blow
181944, -- Resonant Words
181962, -- Mental Recovery
181963, -- Blood Bond
181974, -- Courageous Ascension
181975, -- Hardened Bones
181980, -- Embrace Death
181981, -- Festering Transfusion
181982, -- Everfrost
182105, -- Astral Protection
182106, -- Refreshing Waters
182107, -- Vital Accretion
182108, -- Thunderous Paws
182109, -- Totemic Surge
182110, -- Crippling Hex
182111, -- Spiritual Resonance
182113, -- Fleeting Wind
182125, -- Pyroclastic Shock
182126, -- High Voltage
182127, -- Shake the Foundations
182128, -- Call of Flame
182129, -- Fae Fermata
182130, -- Shattered Perceptions
182131, -- Haunting Apparitions
182132, -- Unending Grip
182133, -- Insatiable Appetite
182134, -- Unruly Winds
182135, -- Focused Lightning
182136, -- Chilled to the Core
182137, -- Magma Fist
182138, -- Mind Devourer
182139, -- Rabid Shadows
182140, -- Dissonant Echoes
182141, -- Holy Oration
182142, -- Embrace of Earth
182143, -- Swirling Currents
182144, -- Nature's Reach
182145, -- Heavy Rainfall
182187, -- Meat Shield
182201, -- Unleashed Frenzy
182203, -- Debilitating Malady
182206, -- Convocation of the Dead
182208, -- Lingering Plague
182288, -- Impenetrable Gloom
182292, -- Brutal Grasp
182295, -- Proliferation
182304, -- Divine Call
182307, -- Shielding Words
182316, -- Fel Defender
182317, -- Shattered Restoration
182318, -- Viscous Ink
182321, -- Enfeebled Mark
182324, -- Felfire Haste
182325, -- Ravenous Consumption
182330, -- Demonic Parole
182331, -- Empowered Release
182335, -- Spirit Attunement
182336, -- Golden Path
182338, -- Pure Concentration
182339, -- Necrotic Barrage
182340, -- Fel Celerity
182344, -- Lost in Darkness
182345, -- Elysian Dirge
182346, -- Tumbling Waves
182347, -- Essential Extraction
182348, -- Lavish Harvest
182368, -- Relentless Onslaught
182383, -- Dancing with Fate
182384, -- Serrated Glaive
182385, -- Growing Inferno
182440, -- Piercing Verdict
182441, -- Markman's Advantage
182442, -- Veteran's Repute
182448, -- Light's Barding
182449, -- Resolute Barrier
182456, -- Wrench Evil
182460, -- Accrued Vitality
182461, -- Echoing Blessings
182462, -- Expurgation
182463, -- Harrowing Punishment
182464, -- Harmony of the Tortollan
182465, -- Truth's Wake
182466, -- Shade of Terror
182468, -- Mortal Combo
182469, -- Rejuvenating Wind
182470, -- Demonic Momentum
182471, -- Soul Furnace
182476, -- Resilience of the Hunter
182478, -- Corrupting Leer
182480, -- Reversal of Fortune
182559, -- Templar's Vindication
182582, -- Enkindled Spirit
182584, -- Cheetah's Vigor
182598, -- Demon Muzzle
182604, -- Roaring Fire
182605, -- Tactical Retreat
182608, -- Virtuous Command
182610, -- Ferocious Appetite
182621, -- One With the Beast
182622, -- Resplendent Light
182624, -- Show of Force
182646, -- Repeat Decree
182648, -- Sharpshooter's Focus
182649, -- Brutal Projectiles
182651, -- Destructive Reverberations
182656, -- Disturb the Peace
182657, -- Deadly Chain
182667, -- Focused Light
182675, -- Untempered Dedication
182677, -- Punish the Guilty
182681, -- Vengeful Shock
182684, -- Resolute Defender
182685, -- Increased Scrutiny
182686, -- Powerful Precision
182706, -- Brooding Pool
182736, -- Rolling Agony
182743, -- Focused Malignancy
182747, -- Cold Embrace
182748, -- Borne of Blood
182750, -- Carnivorous Stalkers
182751, -- Tyrant's Soul
182752, -- Fel Commando
182753, -- Royal Decree
182754, -- Duplicitous Havoc
182755, -- Ashen Remains
182767, -- The Long Summer
182769, -- Combusting Engine
182770, -- Righteous Might
182772, -- Infernal Brand
182777, -- Hallowed Discernment
182778, -- Ringing Clarity
182960, -- Soul Tithe
182961, -- Fatal Decimation
182962, -- Catastrophic Origin
182964, -- Soul Eater
183044, -- Kilrogg's Cunning
183076, -- Diabolic Bloodstone
183132, -- Echoing Call
183167, -- Strength of the Pack
183184, -- Stinging Strike
183197, -- Controlled Destruction
183199, -- Withering Ground
183202, -- Deadly Tandem
183396, -- Flame Infusion
183402, -- Bloodletting
183463, -- Unnatural Malice
183464, -- Tough as Bark
183465, -- Ursine Vigor
183466, -- Innate Resolve
183467, -- Tireless Pursuit
183468, -- Born Anew
183469, -- Front of the Pack
183470, -- Born of the Wilds
183471, -- Deep Allegiance
183472, -- Evolved Swarm
183473, -- Conflux of Elements
183474, -- Endless Thirst
183476, -- Stellar Inspiration
183477, -- Precise Alignment
183478, -- Fury of the Skies
183479, -- Umbral Intensity
183480, -- Taste for Blood
183481, -- Incessant Hunter
183482, -- Sudden Ambush
183483, -- Carnivorous Instinct
183484, -- Unchecked Aggression
183485, -- Savage Combatant
183486, -- Well-Honed Instincts
183487, -- Layered Mane
183488, -- Unstoppable Growth
183489, -- Flash of Clarity
183490, -- Floral Recycling
183491, -- Ready for Anything
183492, -- Reverberation
183493, -- Sudden Fractures
183494, -- Septic Shock
183495, -- Lashing Scars
183496, -- Nimble Fingers
183497, -- Recuperator
183498, -- Cloaked in Shadows
183499, -- Quick Decisions
183500, -- Fade to Nothing
183501, -- Rushed Setup
183502, -- Prepared for All
183503, -- Poisoned Katar
183504, -- Well-Placed Steel
183505, -- Maim, Mangle
183506, -- Lethal Poisons
183507, -- Triple Threat
183508, -- Ambidexterity
183509, -- Sleight of Hand
183510, -- Count the Odds
183511, -- Deeper Daggers
183512, -- Planned Execution
183513, -- Stiletto Staccato
183514, -- Perforated Veins
184359, -- Unbound Reality Fragment
184587, -- Ambuscade
187148, -- Death-Bound Shard
187216, -- Soultwining Crescent
187506, -- Condensed Anima Sphere
187507, -- Adaptive Armor Fragment
}

 -- Ember Court
local EmberCourtIDs = {
176058, -- RSVP: Baroness Vashj
176081, -- Temel's Party Planning Book
176090, -- RSVP: Lady Moonberry
176091, -- RSVP: The Countess
176092, -- RSVP: Mikanikos
176093, -- RSVP: Alexandros Mograine
176094, -- RSVP: Honor 6
176097, -- RSVP: Baroness Vashj
176112, -- RSVP: Lady Moonberry
176113, -- RSVP: Mikanikos
176114, -- RSVP: The Countess
176115, -- RSVP: Alexandros Mograine
176116, -- RSVP: Hunt-Captain Korayn
176117, -- RSVP: Polemarch Adrestes
176118, -- RSVP: Rendle and Cudgelface
176119, -- RSVP: Choofa
176120, -- RSVP: Cryptkeeper Kassir
176121, -- RSVP: Droman Aliothe
176122, -- RSVP: Grandmaster Vole
176123, -- RSVP: Kleia and Pelagos
176124, -- RSVP: Plague Deviser Marileth
176125, -- RSVP: Sika
176126, -- Contract: Traditional Theme
176127, -- Contract: Mystery Mirrors
176128, -- Contract: Mortal Reminders
176129, -- Contract: Decoration 4
176130, -- Contract: Atoning Rituals
176131, -- Contract: Glimpse of the Wilds
176132, -- Contract: Lost Chalice Band
176133, -- Contract: Entertainment 4
176134, -- Contract: Tubbins's Tea Party
176135, -- Contract: Divine Desserts
176136, -- Contract: Mushroom Surprise!
176137, -- Contract: Refreshment 4
176138, -- Contract: Venthyr Volunteers
176139, -- Contract: Stoneborn Reserves
176140, -- Contract: Maldraxxian Army
176141, -- Contract: Security 4
176850, -- Blank Invitation
177230, -- Anima-Infused Water
177231, -- Crown of Honor
177232, -- Bewitched Wardrobe
177233, -- Bounding Shroom Seeds
177234, -- Rally Bell
177235, -- Tubbins's Lucky Teapot
177236, -- Dog Bone's Bone
177237, -- Dredger Party Supplies
177238, -- Generous Gift
177239, -- Racing Permit
177241, -- Necrolord Arsenal
177242, -- Venthyr Arsenal
177243, -- Kyrian Arsenal
177244, -- Night Fae Arsenal
177245, -- Maldraxxi Challenge Banner
178686, -- RSVP: Stonehead
178687, -- RSVP: VIP 17
178688, -- RSVP: VIP 18
178689, -- RSVP: VIP 19
178690, -- RSVP: VIP 20
179958, -- Ember Court Guest List
180248, -- Ambassador's Reserve
181436, -- Vanity Mirror
181437, -- Training Dummies
181438, -- The Wild Drum
181439, -- Protective Braziers
181440, -- Slippery Muck
181441, -- Altar of Accomplishment
181442, -- Perk 22
181443, -- Perk 23
181444, -- Perk 24
181445, -- Perk 25
181446, -- Perk 26
181447, -- Perk 27
181448, -- Perk 28
181449, -- Perk 29
181451, -- Perk 30
181517, -- Building: Dredger Pool
181518, -- Building: Guardhouse
181519, -- Staff: Dredger Decorators
181520, -- Staff: Stage Crew
181521, -- Staff: Ambassador
181522, -- Staff: Waiters
181523, -- Staff: Bouncers
181524, -- Staff: Ambassador
181530, -- Stock: Greeting Kits
181532, -- Stock: Appetizers
181533, -- Stock: Anima Samples
181535, -- Stock: Comfy Chairs
181536, -- Guest List Page
181537, -- Guest List Page
181538, -- Guest List Page
181715, -- Temel's Certificate of Completion
182296, -- Letter of Note, Premier Party Planner
182342, -- Staff: Ambassador
182343, -- Staff: Ambassador
183876, -- Quill of Correspondence
183956, -- Invitation: Choofa
183957, -- Invitation: Grandmaster Vole
184626, -- Winter Veil Caroling Book
184628, -- Elder's Sacrificial Moonstone
184663, -- Building: Guardhouse
}

 -- Legendary Items
local LegendaryItemsIDs = {
}

 -- Legendary Powers
local LegendaryPowersIDs = {
182617, -- Memory of Death's Embrace
182625, -- Memory of an Everlasting Grip
182626, -- Memory of the Phearomones
182627, -- Memory of Superstrain
182628, -- Memory of Bryndaor
182629, -- Memory of the Crimson Runes
182630, -- Memory of Gorefiend's Domination
182631, -- Memory of a Vampiric Aura
182632, -- Memory of Absolute Zero
182633, -- Memory of the Biting Cold
182634, -- Memory of a Frozen Champion's Rage
182635, -- Memory of Koltira
182636, -- Memory of the Deadliest Coil
182637, -- Memory of Death's Certainty
182638, -- Memory of a Frenzied Monstrosity
182640, -- Memory of a Reanimated Shambler
183210, -- Memory of a Fel Bombardment
183211, -- Memory of the Hour of Darkness
183212, -- Memory of a Darkglare Medallion
183213, -- Memory of the Anguish of the Collective
183214, -- Memory of the Chaos Theory
183215, -- Memory of an Erratic Fel Core
183216, -- Memory of a Burning Wound
183217, -- Memory of my Darker Nature
183218, -- Memory of a Fortified Fel Flame
183219, -- Memory of Soul of Fire
183220, -- Memory of Razelikh's Defilement
183221, -- Memory of the Dark Flame Spirit
183222, -- Memory of the Elder Druid
183223, -- Memory of the Circle of Life and Death
183224, -- Memory of a Deep Focus Draught
183225, -- Memory of Lycara
183226, -- Memory of the Balance of All Things
183227, -- Memory of Oneth
183228, -- Memory of Arcane Pulsars
183229, -- Memory of a Timeworn Dreambinder
183230, -- Memory of the Apex Predator
183231, -- Memory of a Cat-eye Curio
183232, -- Memory of a Symmetrical Eye
183233, -- Memory of the Frenzyband
183234, -- Memory of a Luffa-Infused Embrace
183235, -- Memory of the Natural Order
183236, -- Memory of Ursoc
183237, -- Memory of the Sleeper
183238, -- Memory of the Verdant Infusion
183239, -- Memory of an Unending Growth
183240, -- Memory of the Mother Tree
183241, -- Memory of the Dark Titan
183242, -- Memory of Eonar
183243, -- Memory of the Arbiter's Judgment
183244, -- Memory of the Rattle of the Maw
183245, -- Memory of Norgannon
183246, -- Memory of Sephuz
183247, -- Memory of a Stable Phantasma Lure
183248, -- Memory of Jailer's Eye
183249, -- Memory of a Vital Sacrifice
183250, -- Memory of the Wild Call
183251, -- Memory of a Craven Strategem
183252, -- Memory of a Trapping Apparatus
183253, -- Memory of the Soulforge Embers
183254, -- Memory of a Dire Command
183255, -- Memory of the Flamewaker
183256, -- Memory of the Eredun War Order
183257, -- Memory of the Rylakstalker's Fangs
183258, -- Memory of Eagletalon's True Focus
183259, -- Memory of the Unblinking Vigil
183260, -- Memory of the Serpentstalker's Trickery
183261, -- Memory of Surging Shots
183262, -- Memory of the Butcher's Bone Fragments
183263, -- Memory of Poisonous Injectors
183264, -- Memory of the Rylakstalker's Strikes
183265, -- Memory of a Wildfire Cluster
183266, -- Memory of the Disciplinary Command
183267, -- Memory of an Expanded Potential
183268, -- Memory of a Grisly Icicle
183269, -- Memory of the Triune Ward
183270, -- Memory of an Arcane Bombardment
183271, -- Memory of the Infinite Arcane
183272, -- Memory of a Siphoning Storm
183273, -- Memory of a Temporal Warp
183274, -- Memory of a Fevered Incantation
183275, -- Memory of the Firestorm
183276, -- Memory of the Molten Sky
183277, -- Memory of the Sun King
183278, -- Memory of the Cold Front
183279, -- Memory of the Freezing Winds
183280, -- Memory of Fragments of Ice
183281, -- Memory of Slick Ice
183282, -- Memory of the Fatal Touch
183283, -- Memory of the Invoker
183284, -- Memory of Escaping from Reality
183285, -- Memory of the Swiftsure Wraps
183286, -- Memory of Shaohao
183287, -- Memory of Charred Passions
183288, -- Memory of a Celestial Infusion
183289, -- Memory of Stormstout
183290, -- Memory of Ancient Teachings
183291, -- Memory of Yu'lon
183292, -- Memory of Clouded Focus
183293, -- Memory of the Morning's Tear
183294, -- Memory of the Jade Ignition
183295, -- Memory of Keefer
183296, -- Memory of the Last Emperor
183297, -- Memory of Xuen
183298, -- Memory of the Mad Paragon
183299, -- Memory of the Sun's Cycles
183300, -- Memory of the Magistrate's Judgment
183301, -- Memory of Uther
183302, -- Memory of the Sunwell's Bloom
183303, -- Memory of Maraad's Dying Breath
183304, -- Memory of the Shadowbreaker
183305, -- Memory of the Shock Barrier
183306, -- Memory of the Righteous Bulwark
183307, -- Memory of a Holy Sigil
183308, -- Memory of the Endless Kings
183309, -- Memory of the Ardent Protector
183310, -- Memory of the Vanguard's Momentum
183311, -- Memory of the Final Verdict
183312, -- Memory of a Relentless Inquisitor
183313, -- Memory of the Lightbringer's Tempest
183314, -- Memory of Cauterizing Shadows
183315, -- Memory of Measured Contemplation
183316, -- Memory of the Twins of the Sun Priestess
183317, -- Memory of a Heavenly Vault
183318, -- Memory of a Clear Mind
183319, -- Memory of my Crystalline Reflection
183320, -- Memory of the Kiss of Death
183321, -- Memory of the Penitent One
183322, -- Memory of a Divine Image
183323, -- Memory of Flash Concentration
183324, -- Memory of a Harmonious Apparatus
183325, -- Memory of Archbishop Benedictus
183326, -- Memory of the Void's Eternal Call
183327, -- Memory of the Painbreaker Psalm
183328, -- Memory of Talbadar
183329, -- Memory of a Prism of Shadow and Fire
183330, -- Memory of Bloodfang's Essence
183331, -- Memory of Invigorating Shadowdust
183332, -- Memory of the Master Assassin's Mark
183333, -- Memory of Tiny Toxic Blade
183334, -- Memory of the Dashing Scoundrel
183335, -- Memory of the Doomblade
183336, -- Memory of the Duskwalker's Patch
183337, -- Memory of the Zoldyck Insignia
183338, -- Memory of Celerity
183339, -- Memory of a Concealed Blunderbuss
183340, -- Memory of Greenskin
183341, -- Memory of a Guile Charm
183342, -- Memory of Akaari's Soul Fragment
183343, -- Memory of the Deathly Shadows
183344, -- Memory of Finality
183345, -- Memory of the Rotten
183346, -- Memory of an Ancestral Reminder
183347, -- Memory of Devastating Chains
183348, -- Memory of Deeply Rooted Elements
183349, -- Memory of the Deeptremor Stone
183350, -- Memory of the Great Sundering
183351, -- Memory of an Elemental Equilibrium
183352, -- Memory of the Demise of Skybreaker
183353, -- Memory of the Windspeaker's Lava Resurgence
183354, -- Memory of the Doom Winds
183355, -- Memory of the Frost Witch
183356, -- Memory of the Primal Lava Actuators
183357, -- Memory of the Witch Doctor
183358, -- Memory of an Earthen Harmony
183359, -- Memory of Jonat
183360, -- Memory of the Primal Tide Core
183361, -- Memory of the Spiritwalker's Tidal Totem
183362, -- Memory of a Malefic Wrath
183363, -- Memory of Azj'Aqir's Agony
183364, -- Memory of Sacrolash's Dark Strike
183365, -- Memory of the Consuming Wrath
183366, -- Memory of the Claw of Endereth
183367, -- Memory of Demonic Synergy
183368, -- Memory of the Dark Portal
183369, -- Memory of Wilfred's Sigil of Superior Summoning
183370, -- Memory of the Core of the Balespider
183371, -- Memory of the Horned Nightmare
183372, -- Memory of the Grim Inquisitor
183373, -- Memory of an Implosive Potential
183374, -- Memory of Azj'Aqir's Cinders
183375, -- Memory of the Diabolic Raiment
183376, -- Memory of Azj'Aqir's Madness
183377, -- Memory of the Ymirjar
183378, -- Memory of the Leaper
183379, -- Memory of the Misshapen Mirror
183380, -- Memory of a Seismic Reverberation
183381, -- Memory of the Tormented Kings
183382, -- Memory of a Battlelord
183383, -- Memory of an Enduring Blow
183384, -- Memory of the Exploiter
183385, -- Memory of the Unhinged
183386, -- Memory of Fujieda
183387, -- Memory of the Deathmaker
183388, -- Memory of a Reckless Defense
183389, -- Memory of the Berserker's Will
183390, -- Memory of a Reprisal
183391, -- Memory of the Wall
183392, -- Memory of the Thunderlord
183393, -- Memory of an Unbreakable Will
184665, -- Chronicle of Lost Memories
186565, -- Memory of Rampant Transference
186566, -- Memory of the Final Sentence
186567, -- Memory of Insatiable Hunger
186568, -- Memory of an Abomination's Frenzy
186570, -- Memory of Glory
186572, -- Memory of the Sinful Surge
186576, -- Memory of Nature's Fury
186577, -- Memory of the Unbridled Swarm
186591, -- Memory of the Harmonic Echo
186609, -- Memory of Sinful Hysteria
186621, -- Memory of Death's Fathom
186635, -- Memory of Sinful Delight
186673, -- Memory of Kindred Affinity
186676, -- Memory of the Toxic Onslaught
186687, -- Memory of Celestial Spirits
186689, -- Memory of the Splintered Elements
186710, -- Memory of the Obedient
186712, -- Memory of the Deathspike
186775, -- Memory of Resounding Clarity
187105, -- Memory of the Agonizing Gaze
187106, -- Memory of Divine Resonance
187107, -- Memory of the Duty-Bound Gavel
187109, -- Memory of a Blazing Slaughter
187111, -- Memory of Blind Faith
187118, -- Memory of the Demonic Oath
187127, -- Memory of Radiant Embers
187132, -- Memory of the Seasons of Plenty
187160, -- Memory of Pallid Command
187161, -- Memory of Bwonsamdi's Pact
187162, -- Memory of Shadow Word: Manipulation
187163, -- Memory of the Spheres' Harmony
187217, -- Memory of the Bountiful Brew
187223, -- Memory of the Seeds of Rampant Growth
187224, -- Memory of the Elemental Conduit
187225, -- Memory of the Languishing Soul Detritus
187226, -- Memory of the Shards of Annihilation
187227, -- Memory of the Decaying Soul Satchel
187228, -- Memory of the Contained Perpetual Explosion
187229, -- Memory of the Pact of the Soulstalkers
187230, -- Memory of the Bag of Munitions
187231, -- Memory of the Fragments of the Elder Antlers
187232, -- Memory of the Pouch of Razor Fragments
187237, -- Memory of a Call to Arms
187258, -- Memory of the Faeline Harmony
187259, -- Memory of the Raging Vesper Vortex
187277, -- Memory of Sinister Teachings
187280, -- Memory of the Fae Heart
187511, -- Memory of Elysian Might
}

 -- Outdoor Items
local OutdoorItemsIDs = {
173939, -- Enticing Anima
178602, -- Thorny Loop
178658, -- Restore Construct
179392, -- Orb of Burgeoning Ambition
179535, -- Crumbling Pride Extractors
179613, -- Extra Sticky Spidey Webs
179937, -- Sliver of Burgeoning Ambition
179938, -- Crumbling Pride Extractors
179939, -- Wriggling Spider Sac
179977, -- Benevolent Gong
179982, -- Kyrian Bell
180008, -- Resonating Anima Core
180009, -- Resonating Anima Mote
180062, -- Heavenly Drum
180063, -- Unearthly Chime
180064, -- Ascended Flute
180264, -- Abominable Backup
180660, -- Darktower Parchments: Instant Polymorphist
180661, -- Darktower Parchments: Affliction Most Foul
180678, -- Peck Acorn
180688, -- Infused Remnant of Light
180689, -- Pocket Embers
180690, -- Bottled Ash Cloud
180692, -- Box of Stalker Traps
180704, -- Infused Pet Biscuit
180707, -- Sticky Muck
180708, -- Mirror of Despair
180713, -- Shrieker's Voicebox
180874, -- Gargon Whistle
182160, -- Bag of Twigin Treats
182653, -- Larion Treats
182749, -- Regurgitated Kyrian Wings
183122, -- Death's Cloak
183131, -- Stygic Grapnel
183135, -- Summon the Fallen
183136, -- Incendiary Mawrat
183141, -- Stygic Magma
183165, -- Mawsworn Crossbow
183187, -- Shadeweaver Incantation
183602, -- Sticky Webbing
183718, -- Extra Gooey Gorm Gunk
183787, -- Stygic Dampener
183799, -- Shifting Catalyst
183807, -- Stygic Coercion
183811, -- Construct's Best Friend
183902, -- A Faintly Glowing Seed
184485, -- Mawforged Key
184586, -- Sky Chain
184719, -- Enchanted Map of Infused Ruby Network
}

 -- Queen's Conservatory
local QueensConservatoryIDs = {
176832, -- Wildseed Root Grain
176921, -- Temporal Leaves
176922, -- Wild Nightbloom
177698, -- Untamed Spirit
177699, -- Greater Untamed Spirit
177700, -- Divine Untamed Spirit
177953, -- Untamed Spirit
178874, -- Martial Spirit
178877, -- Greater Martial Spirit
178878, -- Divine Martial Spirit
178879, -- Divine Dutiful Spirit
178880, -- Greater Dutiful Spirit
178881, -- Dutiful Spirit
178882, -- Prideful Spirit
178883, -- Greater Prideful Spirit
178884, -- Divine Prideful Spirit
183520, -- Wild Nightbloom Seeds
183521, -- Temporal Leaf Seeds
183522, -- Wildseed Root Grain Seeds
183704, -- Shifting Spirit of Knowledge
183805, -- Tranquil Spirit of the Cosmos
183806, -- Energetic Spirit of Curiosity
184779, -- Temporal Leaves
}

 -- Roh-Suir
local RohSuirIDs = {
185636, -- The Archivists' Codex
186648, -- Soaring Razorwing
186714, -- Research Report: All-Seeing Crystal
186716, -- Research Report: Ancient Shrines
186717, -- Research Report: Adaptive Alloys
186718, -- Teleporter Repair Kit
186721, -- Treatise: Relics Abound in the Shadowlands
186722, -- Treatise: The Study of Anima and Harnessing Every Drop
186731, -- Repaired Riftkey
186984, -- Korthite Crystal Key
187134, -- Alloy-Warping Facetor
187138, -- Research Report: First Alloys
187145, -- Treatise: Recognizing Stygia and its Uses
187148, -- Death-Bound Shard
187508, -- Trained Gromit Carrier
187612, -- Key of Flowing Waters
187613, -- Key of the Inner Chambers
187614, -- Key of Many Thoughts
}

 -- Rune Vessel
local RuneVesselIDs = {
171412, -- Shadowghast Breastplate
171413, -- Shadowghast Sabatons
171414, -- Shadowghast Gauntlets
171415, -- Shadowghast Helm
171416, -- Shadowghast Greaves
171417, -- Shadowghast Pauldrons
171418, -- Shadowghast Waistguard
171419, -- Shadowghast Armguards
172314, -- Umbrahide Vest
172315, -- Umbrahide Treads
172316, -- Umbrahide Gauntlets
172317, -- Umbrahide Helm
172318, -- Umbrahide Leggings
172319, -- Umbrahide Pauldrons
172320, -- Umbrahide Waistguard
172321, -- Umbrahide Armguards
172322, -- Boneshatter Vest
172323, -- Boneshatter Treads
172324, -- Boneshatter Gauntlets
172325, -- Boneshatter Helm
172326, -- Boneshatter Greaves
172327, -- Boneshatter Pauldrons
172328, -- Boneshatter Waistguard
172329, -- Boneshatter Armguards
173241, -- Grim-Veiled Robe
173242, -- Grim-Veiled Cape
173243, -- Grim-Veiled Sandals
173244, -- Grim-Veiled Mittens
173245, -- Grim-Veiled Hood
173246, -- Grim-Veiled Pants
173247, -- Grim-Veiled Spaulders
173248, -- Grim-Veiled Belt
173249, -- Grim-Veiled Bracers
178926, -- Shadowghast Ring
178927, -- Shadowghast Necklace
}

 -- Shards of Domination
local ShardsofDominationIDs = {
187057, -- Shard of Bek
187059, -- Shard of Jas
187061, -- Shard of Rev
187063, -- Shard of Cor
187065, -- Shard of Kyr
187071, -- Shard of Tel
187073, -- Shard of Dyz
187076, -- Shard of Oth
187079, -- Shard of Zed
187120, -- Blood Healing Shard 1 - Rank 5
187284, -- Ominous Shard of Bek
187285, -- Ominous Shard of Jas
187286, -- Ominous Shard of Rev
187287, -- Ominous Shard of Cor
187288, -- Ominous Shard of Kyr
187289, -- Ominous Shard of Tel
187290, -- Ominous Shard of Dyz
187291, -- Ominous Shard of Oth
187292, -- Ominous Shard of Zed
187293, -- Desolate Shard of Bek
187294, -- Desolate Shard of Jas
187295, -- Desolate Shard of Rev
187296, -- Desolate Shard of Cor
187297, -- Desolate Shard of Kyr
187298, -- Desolate Shard of Tel
187299, -- Desolate Shard of Dyz
187300, -- Desolate Shard of Oth
187301, -- Desolate Shard of Zed
187302, -- Foreboding Shard of Bek
187303, -- Foreboding Shard of Jas
187304, -- Foreboding Shard of Rev
187305, -- Foreboding Shard of Cor
187306, -- Foreboding Shard of Kyr
187307, -- Foreboding Shard of Tel
187308, -- Foreboding Shard of Dyz
187309, -- Foreboding Shard of Oth
187310, -- Foreboding Shard of Zed
187312, -- Portentous Shard of Bek
187313, -- Portentous Shard of Jas
187314, -- Portentous Shard of Rev
187315, -- Portentous Shard of Cor
187316, -- Portentous Shard of Kyr
187317, -- Portentous Shard of Tel
187318, -- Portentous Shard of Dyz
187319, -- Portentous Shard of Oth
187320, -- Portentous Shard of Zed
187532, -- Soulfire Chisel
}

 -- Sinstones
local SinstonesIDs = {
172996, -- Inquisitor Sorin's Sinstone
172997, -- Inquisitor Petre's Sinstone
172998, -- Inquisitor Otilia's Sinstone
172999, -- Inquisitor Traian's Sinstone
173000, -- High Inquisitor Gabi's Sinstone
173001, -- High Inquisitor Radu's Sinstone
173005, -- High Inquisitor Magda's Sinstone
173006, -- High Inquisitor Dacian's Sinstone
173007, -- Grand Inquisitor Nicu's Sinstone
173008, -- Grand Inquisitor Aurica's Sinstone
180451, -- Grand Inquisitor's Sinstone Fragment
}

 -- Ve'nari
local VenariIDs = {
180817, -- Cypher of Relocation
180949, -- Animaflow Stabilizer
180952, -- Possibility Matrix
180953, -- Soultwinning Scepter
181245, -- Oil of Ethereal Force
184361, -- Spatial Realignment Apparatus
184588, -- Soul-Stabilizing Talisman
184605, -- Sigil of the Unseen
184613, -- Encased Riftwalker Essence
184615, -- Extradimensional Pockets
184617, -- Bangle of Seniority
184618, -- Rank Insignia: Acquisitionist
184619, -- Loupe of Unusual Charm
184620, -- Vessel of Unfortunate Spirits
184621, -- Ritual Prism of Fortune
184651, -- Maw-Touched Miasma
184652, -- Phantasmic Infuser
184653, -- Animated Levitating Chain
184664, -- Sticky-Fingered Skeletal Hand
}



local function MatchIDs_Init(self)
    wipe(Result)
    
    if self.db.profile.moveFood then
        if self.db.profile.showcoloredCategories then
            Result["|cff34eb9eFood|r"] = AddToSet(FoodIDs)
        else
            Result[unescape("|cff34eb9eFood|r")] = AddToSet(FoodIDs)
        end
    end

    if self.db.profile.moveRings then
        if self.db.profile.showcoloredCategories then
            Result["|cff0070ffRings|r"] = AddToSet(RingsIDs)
        else
            Result[unescape("|cff0070ffRings|r")] = AddToSet(RingsIDs)
        end
    end

    if self.db.profile.moveTrinkets then
        if self.db.profile.showcoloredCategories then
            Result["|cff0070ffTrinkets|r"] = AddToSet(TrinketsIDs)
        else
            Result[unescape("|cff0070ffTrinkets|r")] = AddToSet(TrinketsIDs)
        end
    end

    if self.db.profile.moveUpgradeableItems then
        if self.db.profile.showcoloredCategories then
            Result["|cffa335eeUpgradeable Items|r"] = AddToSet(UpgradeableItemsIDs)
            Result["|cffa335eeUpgradeable Items|r"]["override"] = true
            Result["|cffa335eeUpgradeable Items|r"]["override_method"] = C_ItemUpgrade.CanUpgradeItem
        else
            Result[unescape("|cffa335eeUpgradeable Items|r")] = AddToSet(UpgradeableItemsIDs)
            Result[unescape("|cffa335eeUpgradeable Items|r")]["override"] = true
            Result[unescape("|cffa335eeUpgradeable Items|r")]["override_method"] = C_ItemUpgrade.CanUpgradeItem
        end
    end

    if self.db.profile.moveAbominableStitching then
        if self.db.profile.showcoloredCategories then
            Result["|cff37b2ffAbominable Stitching|r"] = AddToSet(AbominableStitchingIDs)
        else
            Result[unescape("|cff37b2ffAbominable Stitching|r")] = AddToSet(AbominableStitchingIDs)
        end
    end

    if self.db.profile.moveAnima then
        if self.db.profile.showcoloredCategories then
            Result["|cff00afbfAnima|r"] = AddToSet(AnimaIDs)
        else
            Result[unescape("|cff00afbfAnima|r")] = AddToSet(AnimaIDs)
        end
    end

    if self.db.profile.moveAscendedCrafting then
        if self.db.profile.showcoloredCategories then
            Result["|cff37b2ffAscended Crafting|r"] = AddToSet(AscendedCraftingIDs)
        else
            Result[unescape("|cff37b2ffAscended Crafting|r")] = AddToSet(AscendedCraftingIDs)
        end
    end

    if self.db.profile.moveCatalogedResearch then
        if self.db.profile.showcoloredCategories then
            Result["|cff8fbc8fCataloged Research|r"] = AddToSet(CatalogedResearchIDs)
        else
            Result[unescape("|cff8fbc8fCataloged Research|r")] = AddToSet(CatalogedResearchIDs)
        end
    end

    if self.db.profile.moveConduits then
        if self.db.profile.showcoloredCategories then
            Result["|cff1d9e00Conduits|r"] = AddToSet(ConduitsIDs)
        else
            Result[unescape("|cff1d9e00Conduits|r")] = AddToSet(ConduitsIDs)
        end
    end

    if self.db.profile.moveEmberCourt then
        if self.db.profile.showcoloredCategories then
            Result["|cff37b2ffEmber Court|r"] = AddToSet(EmberCourtIDs)
        else
            Result[unescape("|cff37b2ffEmber Court|r")] = AddToSet(EmberCourtIDs)
        end
    end

    if self.db.profile.moveLegendaryItems then
        if self.db.profile.showcoloredCategories then
            Result["|cffff8000Legendary Items|r"] = AddToSet(LegendaryItemsIDs)
            Result["|cffff8000Legendary Items|r"]["override"] = true
            Result["|cffff8000Legendary Items|r"]["override_method"] = C_LegendaryCrafting.IsRuneforgeLegendary
        else
            Result[unescape("|cffff8000Legendary Items|r")] = AddToSet(LegendaryItemsIDs)
            Result[unescape("|cffff8000Legendary Items|r")]["override"] = true
            Result[unescape("|cffff8000Legendary Items|r")]["override_method"] = C_LegendaryCrafting.IsRuneforgeLegendary
        end
    end

    if self.db.profile.moveLegendaryPowers then
        if self.db.profile.showcoloredCategories then
            Result["|cffff8000Legendary Powers|r"] = AddToSet(LegendaryPowersIDs)
        else
            Result[unescape("|cffff8000Legendary Powers|r")] = AddToSet(LegendaryPowersIDs)
        end
    end

    if self.db.profile.moveOutdoorItems then
        if self.db.profile.showcoloredCategories then
            Result["|cffd900d2Outdoor Items|r"] = AddToSet(OutdoorItemsIDs)
        else
            Result[unescape("|cffd900d2Outdoor Items|r")] = AddToSet(OutdoorItemsIDs)
        end
    end

    if self.db.profile.moveQueensConservatory then
        if self.db.profile.showcoloredCategories then
            Result["|cff37b2ffQueen's Conservatory|r"] = AddToSet(QueensConservatoryIDs)
        else
            Result[unescape("|cff37b2ffQueen's Conservatory|r")] = AddToSet(QueensConservatoryIDs)
        end
    end

    if self.db.profile.moveRohSuir then
        if self.db.profile.showcoloredCategories then
            Result["|cff780075Roh-Suir|r"] = AddToSet(RohSuirIDs)
        else
            Result[unescape("|cff780075Roh-Suir|r")] = AddToSet(RohSuirIDs)
        end
    end

    if self.db.profile.moveRuneVessel then
        if self.db.profile.showcoloredCategories then
            Result["|cffff8000Rune Vessel|r"] = AddToSet(RuneVesselIDs)
            Result["|cffff8000Rune Vessel|r"]["bonus_condition"] = true
            Result["|cffff8000Rune Vessel|r"]["bonus_condition_method"] = C_LegendaryCrafting.IsRuneforgeLegendary
        else
            Result[unescape("|cffff8000Rune Vessel|r")] = AddToSet(RuneVesselIDs)
            Result[unescape("|cffff8000Rune Vessel|r")]["bonus_condition"] = true
            Result[unescape("|cffff8000Rune Vessel|r")]["bonus_condition_method"] = C_LegendaryCrafting.IsRuneforgeLegendary
        end
    end

    if self.db.profile.moveShardsofDomination then
        if self.db.profile.showcoloredCategories then
            Result["|cffab1100Shards of Domination|r"] = AddToSet(ShardsofDominationIDs)
        else
            Result[unescape("|cffab1100Shards of Domination|r")] = AddToSet(ShardsofDominationIDs)
        end
    end

    if self.db.profile.moveSinstones then
        if self.db.profile.showcoloredCategories then
            Result["|cff37b2ffSinstones|r"] = AddToSet(SinstonesIDs)
        else
            Result[unescape("|cff37b2ffSinstones|r")] = AddToSet(SinstonesIDs)
        end
    end

    if self.db.profile.moveVenari then
        if self.db.profile.showcoloredCategories then
            Result["|cffd900d2Ve'nari|r"] = AddToSet(VenariIDs)
        else
            Result[unescape("|cffd900d2Ve'nari|r")] = AddToSet(VenariIDs)
        end
    end



    return Result
end

local setFilter = AdiBags:RegisterFilter("Shadowlands", 98, "ABEvent-1.0")
setFilter.uiName = "|cff008a57Shadowlands|r"
setFilter.uiDesc = "Items from the Shadowlands\n|cff50C878Filter version: @project-version@|r"

function setFilter:OnInitialize()
    self.db = AdiBags.db:RegisterNamespace("Shadowlands", {
        profile = {
            
            moveFood = false,
            moveRings = false,
            moveTrinkets = false,
            moveUpgradeableItems = false,
            moveAbominableStitching = true,
            moveAnima = true,
            moveAscendedCrafting = true,
            moveCatalogedResearch = true,
            moveConduits = true,
            moveEmberCourt = true,
            moveLegendaryItems = true,
            moveLegendaryPowers = true,
            moveOutdoorItems = true,
            moveQueensConservatory = true,
            moveRohSuir = true,
            moveRuneVessel = true,
            moveShardsofDomination = true,
            moveSinstones = true,
            moveVenari = true,
            showcoloredCategories = true,
        }
    })
end

function setFilter:Update()
    MatchIDs = nil
    self:SendMessage("AdiBags_FiltersChanged")
end

function setFilter:OnEnable()
    AdiBags:UpdateFilters()
end

function setFilter:OnDisable()
    AdiBags:UpdateFilters()
end

function setFilter:Filter(slotData)
    MatchIDs = MatchIDs or MatchIDs_Init(self)
    for i, name in pairs(MatchIDs) do
        -- Override Method
        if MatchIDs[i]['override'] then
            slotData['loc'] = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
            if slotData['loc']  and slotData['loc']:IsValid() then
                if MatchIDs[i]['override_method'](slotData.loc) then
                    return i
                end
            end

        -- Bonus Condition (triggers when bonus condition is not fulfilled)
        elseif MatchIDs[i]['bonus_condition'] then
            if name[slotData.itemId] then
                slotData['loc'] = ItemLocation:CreateFromBagAndSlot(slotData.bag, slotData.slot)
                if slotData['loc'] and slotData['loc']:IsValid() then
                    if not MatchIDs[i]['bonus_condition_method'](slotData.loc) then -- THERE IS A NOT HERE!
                        return i
                    end
                end
            end

        -- Standard ID Matching
        elseif name[slotData.itemId] then
            return i
        end
    end

end

function setFilter:GetOptions()
    return {
        moveFood = {
            name = "Food",
            desc = "Food made by Cooks in the Shadowlands",
            type = "toggle",
            order = 10
        },

        moveRings = {
            name = "Rings",
            desc = "All Shadowlands Rings",
            type = "toggle",
            order = 20
        },

        moveTrinkets = {
            name = "Trinkets",
            desc = "All Shadowland Trinkets",
            type = "toggle",
            order = 30
        },

        moveUpgradeableItems = {
            name = "Upgradeable Items",
            desc = "Items which can be upgraded (for example: Valor/Korthian/Covenant Armor). \n|cffffd300This might not be specific to Shadowlands.|r",
            type = "toggle",
            order = 40
        },

        moveAbominableStitching = {
            name = "Abominable Stitching",
            desc = "Items used for Abominable Stitching (Necrolord Covenant)",
            type = "toggle",
            order = 50
        },

        moveAnima = {
            name = "Anima",
            desc = "Items used to gain Anima",
            type = "toggle",
            order = 60
        },

        moveAscendedCrafting = {
            name = "Ascended Crafting",
            desc = "Items used for Ascended Crafting (Kyrian Covenant)",
            type = "toggle",
            order = 70
        },

        moveCatalogedResearch = {
            name = "Cataloged Research",
            desc = "Items used to generate Cataloged Research",
            type = "toggle",
            order = 80
        },

        moveConduits = {
            name = "Conduits",
            desc = "Items used to unlock Conduits",
            type = "toggle",
            order = 90
        },

        moveEmberCourt = {
            name = "Ember Court",
            desc = "Items used for the Ember Court (Venthyr)",
            type = "toggle",
            order = 100
        },

        moveLegendaryItems = {
            name = "Legendary Items",
            desc = "Runeforged Legendaries",
            type = "toggle",
            order = 110
        },

        moveLegendaryPowers = {
            name = "Legendary Powers",
            desc = "Items used to unlock Legendary Powers at the Runecarver",
            type = "toggle",
            order = 120
        },

        moveOutdoorItems = {
            name = "Outdoor Items",
            desc = "Items that can be found and used in Outdoor Shadowlands",
            type = "toggle",
            order = 130
        },

        moveQueensConservatory = {
            name = "Queen's Conservatory",
            desc = "Items used in the Queen's Conservatory (Night Fae Covenant)",
            type = "toggle",
            order = 140
        },

        moveRohSuir = {
            name = "Roh-Suir",
            desc = "Items that are sold by Archivist Roh-Suir",
            type = "toggle",
            order = 150
        },

        moveRuneVessel = {
            name = "Rune Vessel",
            desc = "Items used to craft Legendaries",
            type = "toggle",
            order = 160
        },

        moveShardsofDomination = {
            name = "Shards of Domination",
            desc = "Shards of Domination are special upgradable gems with unique bonuses",
            type = "toggle",
            order = 170
        },

        moveSinstones = {
            name = "Sinstones",
            desc = "Sinstones used by the Avowed faction",
            type = "toggle",
            order = 180
        },

        moveVenari = {
            name = "Ve'nari",
            desc = "Items that are sold by Ve'nari",
            type = "toggle",
            order = 190
        },

        showcoloredCategories = {
            name = "|cffff98abC|cffffa094o|cffffa77el|cffffaf67o|cfffebf71r|cfffecf7be|cfffddf85d|cffe0d988 |cffc3d38bC|cffa6cd8ea|cff9bccaet|cff8fcbcde|cff95bad2g|cff9aa9d7o|cffa098dcr|cffae98dci|cffbd98dce|cffcb98dcs|r",
            desc = "Should Categories be colored?",
            type = "toggle",
            order = 200
        },


    },
    AdiBags:GetOptionHandler(self, false, function ()
        return self:Update()
    end)
end
