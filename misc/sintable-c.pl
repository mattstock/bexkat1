#!/usr/bin/perl

print "static const short sintable[] = {\n";
for ($i=0; $i < 256; $i++) {
  $val = int(sin(2*3.14159*$i/256)*2048)+2048;
  print "$val, ";
  print "\n" if (($i+1 % 8) == 0);
}
print "};\n";
