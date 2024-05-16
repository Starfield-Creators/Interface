# Starfield Interface
This repository provides user interface source files for Starfield mod authors.
These source files are edited by Adobe Flash software to publish swf files used by the game.
Though the sources have been reconstructed in certain areas, the files here are intended to represent the vanilla interface as closely as possible, **including the vanilla bugs**!

Game Version `F06997E0 1.10.32.0`


# Fonts
The fonts used by Starfield.

| Class                          | Font                            |
|--------------------------------|---------------------------------|
| `$DebugTextFont`               | Consolas                        |
| `$ConsoleFont`                 | Arial                           |
| `$MAIN_Font`                   | NB Architekt Light              |
| `$MAIN_Font_Bold`              | NB Architekt                    |
| `$NB_Grotesk_Bold`             | NB Grotesk R Bold               |
| `$NB_Grotesk_Semibold`         | NB Grotesk R Semibold           |
| `$HandwrittenFont`             | Handwritten_Institute           |
| `$Controller_Buttons_thin`     | Genesis Controller Buttons thin |
| `$Controller_Buttons_inverted` | Genesis Controller  Buttons inv |
| `$Controller_Buttons`          | Genesis Controller  Buttons     |

![English Font Library](fonts_en.png)


### Localized Libraries
- `Fonts_en.swf`: English
- `Fonts_ja.swf`: Japanese
- `Fonts_zhcn.swf`: Simplified Chinese



# Shared
These are the shared code imports for Starfield.

## Shared.Components.ButtonControls
- ButtonBar

## Shared.Components.ContentLoaders


# Components
The top level UI components used by Starfield.

## PlanetInfoCard
The planet info card.


# Menus
The UI menus used by Starfield.

## Console

## ButtonClips

## Galaxy2DMap

## GalaxyStarmapMenu
- Components: `Icons`
- Components: `PlanetInfoCard`
- Components: `StarMapWidgets`

## GalaxyStarmapMarkers
- Components: `Icons`

## SystemView
- Components: `StarMapWidgets`

## SystemInfoPanel
- Components: `StarMapWidgets`

## SurfaceMap
- Components: `Icons`
- Components: `PlanetInfoCard`

## HUDMenu
- Components: `Icons`

## TestMenu
- Components: `ComponentResourceIcon`
- Components: `ImageFixture`

## TextInputMenu

## WidgetOverlay

## ASL: `LevelUpIcons`
The level up icons are used by these menus and components.
- DataMenu
- DataMenuSharedComponents
- InventoryMenu
- LoadingMenu
- StatusMenu
