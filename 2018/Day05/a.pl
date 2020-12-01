#!/usr/bin/perl

# $absolute_original = <STDIN>;
$absolute_original = 'dabAcCaCBAcCcaDA';
$modified = '';

$absolute_original .= ' '; # For the special case of the last character


foreach $ch ('a' .. 'z') {
  $original = $absolute_original =~ s/$ch//igr;

  $modified = '';
  @letters = split(//, $original);

  while($original ne $modified) {
    my @new_letters = ();
    my $omit = 0;
    for(my $i = 0; $i <= $#letters; $i++) {
      if((not $omit) and (abs(ord($letters[$i]) - ord($letters[$i+1])) != 32)) {
        $omit = 0;
        my $letter = $letters[$i];
        push(@new_letters, $letter);
      } elsif($omit) {
        $omit = 0;
      } else {
        $omit = 1;
      }
    }

    $original = join('', @letters);
    $modified = join('', @new_letters);
    @letters = @new_letters;
  }
  my $len = @letters;
  print "$ch -> $len\n";
  print "     $modified\n";
}
