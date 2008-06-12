#
# $Id$

use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'WWW::Mechanize::Plugin::FollowMetaRedirect',
    license             => 'perl',
    dist_author         => 'Ryo Okamoto <ryo at aquahill dot net>',
    dist_version_from   => 'lib/WWW/Mechanize/Plugin/FollowMetaRedirect.pm',
    build_requires => {
        'Test::More' => 0,
	'Time::HiRes' => 0,
	'URI' => 0,
    },
    requires => {
	'HTML::TokeParser' => 0,
	'WWW::Mechanize' => 0,
    },
    add_to_cleanup      => [ 'WWW-Mechanize-Plugin-FollowMetaRedirect-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
