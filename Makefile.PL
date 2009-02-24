use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Web::Collector',
    AUTHOR              => 'Junichiro Tobe <junichiro.tobe@gmail.com>',
    VERSION_FROM        => 'lib/Web/Collector.pm',
    ABSTRACT_FROM       => 'lib/Web/Collector.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'version'    => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Web-Collector-*' },
);
