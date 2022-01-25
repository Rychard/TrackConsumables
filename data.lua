local ADDON, TC = ...

TC.DEBUG = false

-- Every entry in this table is a spellId, NOT an itemId.
-- We're checking for the presence of a buff (the spellId) on each player
-- e.g. Flask of the Titans
--      SpellId: 17626  https://tbc.wowhead.com/spell=17626
--      ItemId: 13510   https://tbc.wowhead.com/item=13510
TC.Data = {
    Food = {
        33254, -- Well Fed (20 Stamina / 20 Spirit)
        33256, -- Well Fed (20 Strength / 20 Spirit)
        33257, -- Well Fed (30 Stamina / 30 Spirit)
        33261, -- Well Fed (20 Agility / 20 Spirit)
        33263, -- Well Fed (23 Spell Damage / 20 Spirit)
        33265, -- Well Fed (8 MP5 / 20 Stamina)
        33268, -- Well Fed (44 Healing / 20 Spirit)
        35272, -- Well Fed (20 Stamina / 20 Spirit)
        43722, -- Enlightened (20 Spell Crit / 20 Spirit)
        43764, -- Well Fed (20 Hit Rating / 20 Spirit)
    },

    Flask = {
        -- Classic Alchemy
        17626, -- Flask of the Titans
        17627, -- Flask of Distilled Wisdom
        17637, -- Flask of Supreme Power

        -- TBC Alchemy
        28518, -- Flask of Fortification
        28519, -- Flask of Mighty Restoration
        28520, -- Flask of Relentless Assault
        28521, -- Flask of Blinding Light
        28540, -- Flask of Pure Death
        42735, -- (Phase 3) Flask of Chromatic Wonder

        -- TBC Ogri'la (Only works in Gruul/Magtheridon)
        40572, -- Unstable Flask of the Beast
        40573, -- Unstable Flask of the Physician
        40575, -- Unstable Flask of the Soldier
        40576, -- Unstable Flask of the Sorcerer
        40567, -- Unstable Flask of the Bandit
        40568, -- Unstable Flask of the Elder

        -- TBC Aldor/Scryer (Only works in TK/SSC/Hyjal/BT/Sunwell)
        41608, -- Shattrath Flask of Relentless Assault
        41609, -- Shattrath Flask of Fortification
        41610, -- Shattrath Flask of Mighty Restoration
        41611, -- Shattrath Flask of Supreme Power
        46837, -- Shattrath Flask of Pure Death
        46839, -- Shattrath Flask of Blinding Light
    },

    Battle = {
        17538, -- Elixir of the Mongoose
        28501, -- Elixir of Major Firepower
        28503, -- Elixir of Major Shadow Power
        28490, -- Elixir of Major Strength
        28491, -- Elixir of Healing Power
        28493, -- Elixir of Major Frost Power
        28497, -- Elixir of Major Agility
        33720, -- Onslaught Elixir
        33721, -- Adept's Elixir
        33726, -- Elixir of Mastery
        38954, -- Fel Strength Elixir
        45373, -- Bloodberry Elixir (Sunwell Plateau)
    },

    Guardian = {
        11371, -- Gift of Arthas
        28502, -- Elixir of Major Defense
        28509, -- Elixir of Major Mageblood
        28514, -- Elixir of Empowerment
        39625, -- Elixir of Major Fortitude
        39626, -- Earthen Elixir
        39627, -- Elixir of Draenic Wisdom
        39628, -- Elixir of Ironskin
    },
}