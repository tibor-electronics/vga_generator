# VGA Text

This project builds upon work in the VGA Background project and does the following:

* Uses Classic Computing shield for VGA output (3x4 bits colors)
* This is actually a hack, given that the Classic Computing shield is designed for the Papilio Duo
* But it actually works, by plugging part of the whole shield pinout on the W1A/B 32 bit connector of the papilio One
* You must connect shield ports DL/DH,CL/CH to Papilio One ports AL/AH,BL/BH (that is, the shield is mostly on the right of the papilio)
* Generates horizontal and vertical synchronization signals for a 640x480 VGA display
* Defines a 8x16 font ROM for ASCII characters 0 to 127
* Defines a buffer of 7-bit values use to represent the 80x30 characters on the screen
* Currently, all text is white, but any of the 4096 available colors could be used.

## Links

* [Papilio One](http://papilio.cc/index.php?n=Papilio.PapilioOne)
* [Classic Computing Shield (VGA)](http://papilio.cc/index.php?n=Papilio.ClassicComputingShield#vga)
