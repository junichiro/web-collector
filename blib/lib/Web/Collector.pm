package Web::Collector;

use warnings;
use strict;
use Carp;
use YAML::Syck;
use File::Spec;
use File::Basename;
use LWP::Simple;
use URI;
use Web::Scraper;

use version;
our $VERSION  = qv('0.0.1');

use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw(conf already uri have_files exists skip_cnt max_cnt));

sub new {
    my ( $class, $yaml_file ) = @_;
    my $conf = LoadFile($yaml_file);
    my $already = File::Spec->catfile( $conf->{'img_dir'}, '.already.yml' );
    unless ( -e $already ) {
        open my $fh, ">", $already;
        print $fh "---\n";
        close $fh;
    }
    my $have_files = LoadFile($already);
    $have_files = [] unless ( ref $have_files );
    my $self = {
        'conf'       => $conf,
        'already'    => $already,
        'uri'        => $conf->{'uri'},
        'have_files' => $have_files,
        'exists'     => {},
        'skip_cnt'   => 0,
        'max_cnt'    => $conf->{'max_cnt'},
    };
    bless $self, $class;
}

sub run {
    my $self = shift;
    $self->_init();
    foreach ( 1 .. 2 ) {
        my $baseuri = $self->uri . $_;
        my $uris    = $self->get_uris($baseuri);
        $self->get_images($uris);
    }
    $self->_end();
}

sub _init {
    my $self = shift;
    $self->_cache;
}

sub _end {
    my $self = shift;
    DumpFile( $self->already, $self->have_files );
}

sub _cache {
    my $self  = shift;
    if ( ref $self->have_files ) {
        foreach ( @{ $self->have_files } ) {
            $self->exists->{$_}++;
        }
    }
}

sub get_uris {
    my ($self, $baseuri) = @_;
    my $uri     = URI->new($baseuri);
    my $scraper = scraper {
        eval $self->conf->{'process'};
    };
    my $result = $scraper->scrape($uri);
    return $result->{img_uri};
}

sub get_images {
    my ($self, $uris) = @_;
    foreach (@$uris) {
        $self->get_image($_);
        last if ( $self->skip_cnt >= $self->max_cnt );
    }
}

sub get_image {
    my ($self, $u) = @_;
    $u = URI->new($u) unless (ref $u);
    my $basename = basename( $u->path );
    my $file     = File::Spec->catfile( $self->conf->{'img_dir'}, $basename );
    if ( $self->exists->{$basename} ) {
        print "Skip: $file";
        $self->{skip_cnt}++;
    }
    else {
        print "Get:  $file";
        getstore( $u, $file );
        $self->add_have_file($basename);
    }
    print "\n";
}

sub add_have_file {
    my ($self, $file) = @_;
    push( @{$self->have_files}, $file );
}

1;    # Magic true value required at end of module
__END__

=head1 NAME

Web::Collector - Collect images or any other media files from internet.


=head1 VERSION

This document describes Web::Collector version 0.0.1


=head1 SYNOPSIS

    use Web::Collector;
    my $c = new Web::Collector();

=head1 DESCRIPTION

This modules gets any kind of files from internet automatically.

=head2 Methods
=over
=item new
new Constructor of Collector.


=head1 AUTHOR

Junichiro Tobe  C<< <junichiro.tobe@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2007, Junichiro Tobe C<< <junichiro.tobe@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.
