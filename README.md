README
=================

About
-----

Often when I need a solution for a specific task I do a google search to find out what command I can use. Before I made this script I had a text file with commands saved that I wanted to rember. 
This script makes it easier to fetch and organize my favourite commands.

Installing
----------

 * Clone or download the files.
 * Install the required gems.
 * chmod u+x mycommands
 * Symlink mycommands to some directory in your path.
 * Linux users have to install xclip as well (you might have to install it from source).

Usage
-----

    $ mycommands
    
Use "0" (zero) to go back to the previous listing of categories and commands.
"q" will quit the script while browsing for commands.

Choose the command you need and fill in the parameters if there are any.
You can use tab expansion while filling in the parameters.

Parameters can have a default value in (). If you press just press enter the default value will be used.

About the yml files
-------------------

If the script finds categories.yml or commands.yml in ~/Mycommands
those files will be used instead of the default ones.

Categories in categories.yml that has no subcategories has to end with a trailing blank space.

The format of commands in commands.yml:
    Command description:
      - Category
      - command PARAM1 PARAM2
      - Example param1: PARAM1
      - Example param2 (default value): PARAM2