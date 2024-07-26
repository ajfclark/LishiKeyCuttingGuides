# Guide generation

Generates a set of guides using OpenSCAD.

Expects OpenSCAD to be installed in `C:\Program Files\OpenSCAD\openscad.exe`,
update that as you need. On Linux you'll need to do your own version of
generate.bat as a shell script.

Run it with arguments `generate.bat Schlage 8.509 0.381 5.86 10` where:

 - `Schlage` is the key name/label for output files etc.
 - `8.509` is the zero-cut height, in mm.
 - `0.381` is the size of each step in depth, in mm.
 - `5.86` is the distance from pin 1 to the shoulder, in mm.
 - `10` is the total number of possible depths.

The above numbers will generate a 10 guides for Schlage.
