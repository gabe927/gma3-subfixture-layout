# GrandMA3 Subfixture Layout Builder

This plugin for GrandMA3 takes the main fixture instances in a layout view and replaces (by creating a new layout view) those elements with a provided subfixture template.

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/overview.png)

## Change Log

V 1.1 - January 17, 2021 - Added Subfix Groups
V 1.0 - January 4, 2021

## Usage Instructions

### Step 1: Setup Layout Views
---
Start by setting up 2 layout views, one with the main fixture instances and their positions, another with the template layout with the subfixture elements you want to replace the main ones with.

Here I have an example with 2 JDC1s:

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/JDC1-3D.png)JDC1 3D View

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/JDC1-Base-Layout.png)JDC1 Base Layout

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/JDC1-Template-Layout.png)JDC1 Template Layout

### Step 2: Select Elements
---
The plugin will only use the selected elements in both the main and template layouts. NOTE that this does NOT mean selected in the programmer, it means the selected elements in the layout view. You can see which elements are selected in the Edit sheet for the layout.

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/Layout-Selected-Elements.png "Selected Layout Elements")

You can also select the elements while in "Setup" mode on the layout view and using the Select Tool. (Hold control while lassoing to add elements to the selection)

This allows for control over which elements you wish to have processed by the plugin at a given time.

For instance, you may wish to have one run of the plugin with horizontal fixtures and another run with vertical. In this case, you would run the plugin twice, once for each direction. After the first run, the plugin will merge any new elements onto the existing destination layout ONLY if overwrite_enabled=false (see parameter options below).

### Step 3: Adjust Plugin Parameters
---
At the top of the plugin, there are some parameters that are user-editable. These are the settings for the plugin. Change these parameters BEFORE you run the plugin. The parameters are detailed below.

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/Plugin-Parameters.png "Plugin Parameters")

| Parameter | Description |
| --- | --- |
| source_layout | Layout pool number with the main fixture elements |
| template_layout | Layout pool number with the template elements |
| dest_layout | Destination layout pool number for the new elements |
| groups_pool_start | Groups pool number to start storing subfix groups (one per element in template, will overwrite existing!) |
| groups_layout | Layout to store the subfix group elements |
| groups_prefix | Prefix to go at the beginning of each group |
| scaling_factor | A multiplyer for the start position of the new elements. This is useful when the template is larger than the space between multiple main elements. |
| mirror_xy | mirrors the template along the y=x axis |
| mirror_x | mirrors the template along the x axis |
| mirror_y | mirrors the template along the y axis |

Don't edit anything except these settings as it may break the plugin! 

Unless of course, if you know what you're doing :)

### Step 4: Run the Plugin
---
Run the plugin to process the new layout view.

Note that the plugin uses the regular "Assign" keyword when creating the elements so it respects your default settings. If you want the elements to look different, then you may want to change these defaults before you run the plugin.

![alt text](https://raw.githubusercontent.com/gabe927/gma3-subfixture-layout/master/images/JDC1-Destination-Layout.png "JDC Destination Layout")

## Video Instructions
All of those instructions from above in video format:

<a href="http://www.youtube.com/watch?feature=player_embedded&v=wX8inv88hkk
" target="_blank"><img src="http://img.youtube.com/vi/wX8inv88hkk/0.jpg" 
alt="GrandMA3 Subfixture Layout View Builder" width="240" height="180" border="10" /></a>

## Other Notes
This project is open source. Feel free to fork the project, try your own stuff, and add a pull request. Your changes might get added!

As always, please don't be a dick. If you use any of this code in your own projects, please credit the source.

If you have any issues, feel free to raise them in the "Issues" tab.