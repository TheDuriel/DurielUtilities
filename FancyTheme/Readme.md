FancyTheme is a custom Theme Resource for Godot that will apply Materials to Control nodes.

To use it, follow these steps.

1. Create a Material you want to use.
2. Create a new FancyTheme, or apply the FancyTheme script to your existing Theme.
3. Find the material_associations property.
4. Add a String Key and Object Value pair.
5. The String Key will be the Class Name of your Node.
6. FancyTheme will try to find out the Class name of a node in several ways:
	a. Using get_class() for Godots built in nodes.
		a. You can also define get_class() in your own custom classes.
	c. Using the Object.scripts file name without extension, if it has a script.
	d. The name of the node in the scene tree.
7. The Object Value will be the Material you want to apply. (drag and drop it in.)

The materials will be applied to ALL nodes in your Game as they are created,
and which match the defined names.
Even if you have assigned a different Theme to that Node.
(There's no way for me to tell. Sorry.)

FancyContainer is a PanelContainer equivalent that allows,
using 3 different StyleBoxes with custom margins.

You can theme it by defining a StyleVariation for MarginContainer in your Theme or FancyTheme.
You will need to add the relevant custom constants manually.
They are found at the top of the FancyContainer File.
