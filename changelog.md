# Changelog

## 0.331

### Additions

* Added entity specific getter iterator functions for better performance if only iterating over entities.
    * `TSIL.EntitySpecific.GetBombsIter(bombVariant: BombVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetEffectsIter(effectVariant: EffectVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetFamiliarsIter(familiarVariant: FamiliarVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetKnivesIter(knifeVariant: KnifeVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetLasersIter(laserVariant: LaserVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetNPCs(entityType: EntityType, variant: integer, subType: integer, ignoreFriendly: boolean)`
    * `TSIL.EntitySpecific.GetPickupsIter(pickupVariant: PickupVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetProjectilesIter(projectileVariant: ProjectileVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetSlotsIter(slotVariant: SlotVariant, subType: integer)`
    * `TSIL.EntitySpecific.GetTearsIter(tearVariant: TearVariant, subType: integer)`
    * Sample of usage:
        ```lua
        -- Destroys every projectile in the room
        for projectile in TSIL.EntitySpecific.GetProjectilesIter() do
            projectile:Kill()
        end
        ```

### Changes

* `TSIL.EntitySpecific.SpawnSlot()` and `TSIL.EntitySpecific.GetSlots()` now properly return slot entities.

### Fixes

* Serializing colors now properly saves the colorize values.

### Removed

* Removed some grid entity callbacks in favor of Repentogon specific ones.
    * The removed callbacks were `POST_GRID_ENTITY_INIT`, `POST_GRID_ENTITY_UPDATE`, `POST_GRID_ENTITY_RENDER` and `POST_GRID_COLLISION`.
    * Also all the specific grid entity update and render callbacks.
* `TSIL.Run.CanRunUnlockAchievements()` has been replaced by `Game:AchievementUnlocksDisallowed()`

---

## 0.330

### Fixes

* Fixed typos in enums in `TSIL.Players.GetPlayerMaxHeartContainers(player: EntityPlayer)`.
* Fixed internal callbacks not overridinig version.
* Save Manager doesn't spam errors when using a non rgon version of the library.

---

## 0.329

### Additions

* Added `TSIL.Pause.PausePlayer` and related functions.
    * `TSIL.Pause.PausePlayer(player: EntityPlayer)`: Completely stops the player, removing its controls and making it intangible. Keep in mind that this only lasts for the current room.
    * `TSIL.Pause.UnpausePlayer(player: EntityPlayer)`: Restores the player that was paused before.
    * `TSIL.Pause.IsPlayerPaused(player: EntityPlayer)`: Checks if a player has been paused.
    * `TSIL.Pause.PauseAllPlayers()`: Pauses all players.
    * `TSIL.Pause.UnpauseAllPlayers()`: Unpauses all players.

* Added per-player persistent variables to Save Manager.
    * `TSIL.SaveManager.AddPersistentPlayerVariable(mod: ModReference, variableName: string, defaultValue: any, persistenceMode: VariablePersistenceMode, differentiateSoulAndForgotten: boolean?, ignoreGlowingHourglass: boolean?, conditionalSave: fun(): boolean?)`: Adds a new per-player persistent variable to the Save Manager. 
    * `TSIL.SaveManager.GetPersistentPlayerVariable(mod: ModReference, variableName: string, player: EntityPlayer)`: Returns the current value of a per-player persistent variable for the given player.
    * `TSIL.SaveManager.SetPersistentPlayerVariable(mod: ModReference, variableName: string, player: EntityPlayer, newValue: any)`: Sets the current value of a per-player persitent variable for the given player.

* Added appropiate lua annotations to `TSIL.Utils.Math.Lerp` so it now also accepts `Vector` parameters.

### Changes

* Save Manager uses the Repentogon Glowing Hourglass callbacks to ensure mod persistent data works the same as vanilla data when using Glowing Hourglass.

### Fixes

* Save Manager now restores run persistent variables when using Glowing Hourglass.
* Pickup Index persists correctly on boss rooms during ascent.
* Save Manager keeps working even after using the `luamod` command. Previously it would still work, but it wouldn't be able to load/save the file when exiting/countinuing the run.
* Fixed an error that could happen with version persistent data when loading old versions of the library.

### Removed

* `CustomItemPool` module has been removed since Repentogon allows modders to add item pools using the `itempools.xml` file.
* For the same reason, `POST_GET_COLLECTIBLE_CUSTOM_ITEM_POOL` has been removed.

---

## 0.328

### Changes

* `TSIL.Sprites.GetLastFrameOfAnimation` now returns -1 if the animation doesn't exist.

### Fixes

* Internal callbacks update their version when overriden.
* Updated lua annotation types to match with Filloax's extension.
* Fixed `WillMysteriousPaperRevive` calling `player:GetDeathAnimationName()` instead of `player:GetDeathAnimName()`.
* Fixed `IsDamageToPlayerFatal` typo for Tainted Samson's player type enum.
* `TSIL.Sprites.GetLastFrameOfAnimation` now checks if the animation data is nil.