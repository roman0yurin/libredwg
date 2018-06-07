#!/usr/bin/perl -n
=head1 USAGE

gmake -s -j4
for d in `find test/test-data/2* -name \*.dwg`; do
    dir=$(basename `dirname $d`)
    log=`basename $d .dwg`_$dir.log
    echo $d
    programs/dwgread -v5 $d 2>$log
done
mv examples/alldwg.inc examples/alldwg.inc~
for l in *.log; do b=`basename $l .log`; examples/log_unknown.pl $l >>examples/alldwg.inc; done

=cut

BEGIN {
  $file = $ARGV;
  $file =~ s{^(.*)_(20\d\d)\.log}{test/test-data/$2/$1.dwg};
}

if (/Offset: \d+ @(\d+)\n/) {
  $offset = $1; next;
}
if (/Warning: Unhandled Class (?:object|entity) \d+ (\w+) /) {
  $object = $1; next;
}
if (/Object UNKNOWN_OBJ bitsize: (.\d+) /) {
  $bitsize = $1; next;
}
if (/Object UNKNOWN_ENT Entity bitsize: (.\d+) /) {
  $bitsize = $1; next;
}
if (/ \(bitsize: (.\d+), hdlpos/) {
  $bitsize = $1; next;
}
if (/^([0-9a-f]+\n)/) {
  $b = $1;
  chomp $b; next;
}
if (/^bits\[\d\]: (\d)/) {
  $bits .= $1; next;
}
if (/Next object: /) {
  print "    { \"$object\", \"$b\", \"$bits\", \"$ARGV\", $offset, $bitsize },\n"
    if $object and $b and $offset && $bitsize;
  $object = $bitsize = $b = $bits = $offset = undef;
}
