## Usage help
In this section you'll learn how to use the items of this mod.
Note: If you have the `doc` and `doc_items` mods installed, you can also access the same help texts in-game (possibly translated).

### Schematic Creator
The schematic creator is used to save a region of the world into a schematic file (.mts).

#### Usage
To get started, place the block facing directly in front of any bottom left corner of the structure you want to save. This block can only be accessed by the placer or by anyone with the “`schematic_override`” privilege.
To save a region, use the block, enter the size and a schematic name and hit “Export schematic”. The file will always be saved in the world directory. Note you can use this name in the /placeschem command to place the schematic again.

Importing a schematic will load a schematic from the world directory, place it in front of the schematic creator and sets probability and force-place data accordingly.
The other features of the schematic creator are optional and are used to allow to add randomness and fine-tuning.

Y slices are used to remove entire slices based on chance. For each slice of the schematic region along the Y axis, you can specify that it occurs only with a certain chance. In the Y slice tab, you have to specify the Y slice height (0 = bottom) and a probability from 0 to 255 (255 is for 100%). By default, all Y slices occur always.

With a schematic node probability tool, you can set a probability for each node and enable them to overwrite all nodes when placed as schematic. This tool must be used prior to the file export.


### Schematic Node Probability Tool
This is an advanced tool which only makes sense when used together with a schematic creator. It is used to finetune the way how nodes from a schematic are placed.
It allows you to set two things:
1) Set probability: Chance for any particular node to be actually placed (default: always placed)
2) Enable force placement: These nodes replace node other than air and ignore when placed in a schematic (default: off)

#### Usage

BASIC USAGE:
Punch to configure the tool. Select a probability (0-255; 255 is for 100%) and enable or disable force placement. Now place the tool on any node to apply these values to the node. This information is preserved in the node until it is destroyed or changed by the tool again. This tool has no effect on schematic voids.
Now you can use a schematic creator to save a region as usual, the nodes will now be saved with the special node settings applied.

NODE HUD:
To help you remember the node values, the nodes with special values are labelled in the HUD. The first line shows probability and force placement (with “[F]”). The second line is the current distance to the node. Nodes with default settings and schematic voids are not labelled.
To disable the node HUD, unselect the tool or hit “place” while not pointing anything.

UPDATING THE NODE HUD:
The node HUD is not updated automatically and may be outdated. The node HUD only updates the HUD for nodes close to you whenever you place the tool or press the punch and sneak keys simultaneously. If you sneak-punch a schematic creator, then the node HUD is updated for all nodes within the schematic creator's region, even if this region is very big.


### Schematic Void
This is an utility block used in the creation of schematic files. It should be used together with a schematic creator. When saving a schematic, all nodes with a schematic void will be left unchanged when the schematic is placed again. Technically, this is equivalent to a block with the node probability set to 0.

#### Usage
Just place the schematic void like any other block and use the schematic creator to save a portion of the world.