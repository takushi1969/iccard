#!/usr/bin/perl -w

use 5.14.0;
use strict;
use utf8;
use encoding "utf8";
use ICCard::CarLicenseCard;

our $VERSION = 0.01;

sub usage {
    say STDERR "";
    say STDERR "Usage: $0 datafile";
    say STDERR "";

    exit 1;
}

usage if scalar @ARGV != 1;

my $card = ICCard::CarLicenseCard->new($ARGV[0]);
$card->readFile;
