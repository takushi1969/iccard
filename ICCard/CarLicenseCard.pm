package ICCard::CarLicenseCard;
use base qw/ICCard/;

use 5.14.0;
use strict;
use utf8;
use encoding "utf8";
use Encode;

our $VERSION = 0.01;

my %tags = (
    0x41	=> \&rawJIS2UTF,
);

sub rawJIS2UTF {
    my $data = shift;

    # add control code for JIS
    $data = "\x1b\$B" . $data . "\x1b(B";

    return decode("iso-2022-jp", $data);
}

sub new {
    my ($class, $file) = @_;
    $class->SUPER::new($file);
}

sub DESTROY {
    my $self = shift;

    $self->SUPER::DESTROY;
}

sub readFile {
    my $self = shift;

  LOOP: {
      my ($tag, $data);
      do {
	  ($tag, $data) = $self->SUPER::readTLV;
	  last unless $tag;
	  
	  if (exists $tags{$tag}) {
	      say $tags{$tag}->($data);
	  } else {
	      printf STDERR "There is no definition for tag: %d", $tag;
	  }
      } while($tag);
    }
}

1;
