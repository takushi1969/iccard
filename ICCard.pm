package ICCard;
use 5.14.0;
use strict;
use utf8;
use encoding "utf8";

our $VERSION = 0.01;


sub new {
    my ($class, $file) = @_;

    my $self;
    open($self->{fh}, "<", $file) or die "Can't open $file";

    bless $self, ref $class || $class;
}

sub DESTROY {
    my $self = shift;

    close($self->{fh}) if exists $self->{fh};
}

sub readTLV {
    my $self = shift;
    my $fh = $self->{fh};
    my $tag;
    my $data;
    my $len;

    # read a tag;
    read $fh, $tag, 1 or die "There is no tag.";
    $tag = unpack "C", $tag;
    return (undef, undef) if $tag == 0xff;

    # read the length of data.
    read $fh, $len, 1 or die "There is no length.";
    $len = unpack "C", $len;
    
    # read all data at once.
    read $fh, $data, $len or die "There is no data to be read.";
    length($data) == $len or die "The lenght of read data is too short.";
    
    return ($tag, $data);
}

1;
