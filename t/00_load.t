#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'WWW::Mechanize::Plugin::FollowMetaRedirect' );
}

diag( "Testing WWW::Mechanize::Plugin::FollowMetaRedirect $WWW::Mechanize::Plugin::FollowMetaRedirect::VERSION, Perl $], $^X" );
