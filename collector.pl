#!/opt/local/bin/perl

use lib "/Users/tobe/Work/modules/Web-Collector/lib";
use strict;
use warnings;
use Web::Collector;
use YAML::Syck;

my $yaml = $ARGV[0] || die "Usage: collector.pl [config.yaml]\n";
my $c = new Web::Collector($yaml);
$c->run();
