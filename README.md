# VHDL Project for Papilio One VGA Wing Sanity Check

This project does the following:

* Generates horizontal and vertical synchronization signals for a 640x480 VGA display
* Uses the b/led wing to turn on the individual RGB channels either singly or in combination allowing for a total of 8 generated colors: red, green, blue, cyan, magenta, yellow, black, and white.
* Generates pixel coordinates and display flag which can be used to generate text and tiles. Note that the current code-base does not implement these features, but those are next on the list.
* Makes use of the DCM to generate a 50.35MHz clock used by the VGA synchronization component

## Links

* [Papilio One](http://www.gadgetfactory.net)
* [VGA Wing](http://www.gadgetfactory.net/index.php?main_page=product_info&cPath=4&products_id=40&zenid=13d207c03a00964cd22aba62b8d79b48)