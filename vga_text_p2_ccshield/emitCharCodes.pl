#!/usr/bin/perl

my @lines = (
	"01 =============================================================================",
	"02 | This is a test of the VGA Text Generator                                  |",
	"03 | Written by Kevin Lindsey <kevin@kevlindev.com>                            |",
	"04 | https://github.com/thelonious/vga_generator                               |",
	"05 |                                                                           |",
	"06 | Running on the Papilio Duo (s6lx9)                                        |",
	"07 | Using the VGA output of the Classic Computing shield                      |",
	"08 | Both available at http://www.gadgetfactory.net                            |",
	"09 =============================================================================",
    "10",
    "11 Column count",
    "12 ------------",
	"13       1         2         3         4         5         6         7         8",
	"14 45678901234567890123456789012345678901234567890123456789012345678901234567890",
	"15",
	"16 All 127 Character Codes, 16 characters per row",
    "17 ----------------------------------------------",
	"18 \x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
	"19 \x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1A\x1B\x1C\x1D\x1E\x1F",
	"20 \x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F",
	"21 \x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F",
	"22 \x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F",
	"23 \x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F",
	"24 \x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F",
	"25 \x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F",
	"26",
	"27",
	"28",
	"29",
	"30"
);
my $first = 0;

print "memory_initialization_radix = 16;\n";
print "memory_initialization_vector = ";

foreach my $line (@lines) {
	my @chars = split(//, $line);
	my $length = $#chars;
	
	$length = ($length < 80) ? $length : 79;
	
	for (my $i = 0; $i <= $length; $i++) {
		emitChar(ord($chars[$i]));
	}

	for (my $i = $length + 1; $i < 128; $i++) {
		emitChar(0);
	}
}

print ";\n";

##
#	emitChar
##
sub emitChar {
	my $num = shift;

	if ($first == 0) {
		$first = 1;
	} else {
		print ", ";
	}

	printf "%02x", $num;
}
