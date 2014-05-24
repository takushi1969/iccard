#!/usr/bin/perl -w

use 5.14.0;
use strict;
use utf8;
use encoding "utf8";
use Encode;

sub usage {
    say STDERR "";
    say STDERR "Usage: $0 datafile";
    say STDERR "";

    exit 1;
}

sub parseFile {
    my $file = shift;
    my $data;
    my $len;

    open my $fh, "<", $file or die "Can't open $file";

    # read the first character and check if the value is \x41.
    read $fh, $data, 1 or die "There is no tag.";
    ord($data) == 0x41 or die "Data is invalid.";

    # read the length of data.
    read $fh, $len, 1 or die "There is no length.";
    $len = ord($len);
    
    # read all data at once.
    read $fh, $data, $len or die "There is no data to be read.";
    length($data) == $len or die "The lenght of read data is too short.";
    
    close $fh;

    return $data;
}

sub rawJIS2UTF {
    my $data = shift;

    # add control code for JIS
    $data = "\x1b\$B" . $data . "\x1b(B";

    return decode("iso-2022-jp", $data);
}

scalar @ARGV == 1 or usage;

say rawJIS2UTF parseFile $ARGV[0];

__END__
=head1 Syntax

decRawJIS.pl I<data-file>

=head1 Feature

This program encodes content of I<data-file> storing RAW JIS data
into utf8, and puts it to I<STDOUT>.
The content of I<data-file> should be formatted as TLV, and its tag
should be 0x41.

=cut
