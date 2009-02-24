use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Web::Collector',
    license             => 'perl',
    dist_author         => 'Junichiro Tobe <junichiro.tobe@gmail.com>',
    dist_version_from   => 'lib/Web/Collector.pm',
    requires => {
        'Test::More' => 0,
        'version'    => 0,
    },
    add_to_cleanup      => [ 'Web-Collector-*' ],
);

$builder->create_build_script();
