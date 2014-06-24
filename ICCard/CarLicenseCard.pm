package ICCard::CarLicenseCard;
use base qw/ICCard/;

use 5.14.0;
use strict;
use utf8;
use encoding "utf8";
use Encode;

our $VERSION = 0.02;

my %tags = (
    0x11	=> \&raw2hex,
    0x12	=> \&rawJIS2UTF,
    0x13	=> \&rawJIS2UTF,
    0x14	=> \&rawJIS2UTF,
    0x15	=> \&rawJIS2UTF,
    0x16	=> \&raw,
    0x17	=> \&rawJIS2UTF,
    0x18	=> \&raw,
    0x19	=> \&raw,
    0x1a	=> \&rawJIS2UTF,
    0x1b	=> \&raw,
    0x1c	=> \&rawJIS2UTF,
    0x1d	=> \&rawJIS2UTF,
    0x1e	=> \&rawJIS2UTF,
    0x1f	=> \&rawJIS2UTF,
    0x20	=> \&rawJIS2UTF,
    0x21	=> \&raw,
    0x22	=> \&raw,
    0x23	=> \&raw,
    0x24	=> \&raw,
    0x25	=> \&raw,
    0x26	=> \&raw,
    0x27	=> \&raw,
    0x28	=> \&raw,
    0x29	=> \&raw,
    0x2a	=> \&raw,
    0x2b	=> \&raw,
    0x2c	=> \&raw,
    0x2d	=> \&raw,
    0x2e	=> \&raw,
    0x2f	=> \&raw,
    0x30	=> \&raw,
    0x31	=> \&raw,
    0x32	=> \&raw,

    # DF1/EF02
    0x41	=> \&rawJIS2UTF,
);

sub rawJIS2UTF {
    my $data = shift;

    # add control code for JIS
    $data = "\x1b\$B" . $data . "\x1b(B";

    return decode("iso-2022-jp", $data);
}

sub raw2hex {
    my $data = shift;
    unpack "H2", $data;
}

sub raw {
    my $data = shift;
    $data;
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
	  
          if ($data) {
              if (exists $tags{$tag}) {
                  printf "Tag:%02X : ", $tag;
                  say $tags{$tag}->($data);
              } else {
                  printf STDERR "There is no definition for tag: %02x\n", $tag;
              }
          }
      } while($tag);
    }
}

1;
