# 
# $Id$

use strict;
use warnings;
use Test::More tests => 17;
use URI::file;
use Time::HiRes qw(time);

BEGIN {
    use_ok( 'WWW::Mechanize::Pluggable' );
    use_ok( 'WWW::Mechanize::Plugin::FollowMetaRedirect' );
}

# active check 1
{
  my $mech = WWW::Mechanize::Pluggable->new;
  my $uri = URI::file->new_abs("t/waiting_01.html")->as_string;

  # load initial page
  $mech->get( $uri );
  ok( $mech->success, "Fetched: $uri" ) or die "cannot load test html!";

  # follow
  my $start = time;
  ok( $mech->follow_meta_redirect, "follow meta refresh link" );
  ok( time - $start >= 2.00, "waiting sec" );

  # check
  ok( $mech->is_html, "is html" );
  ok( $mech->content =~ /test ok\./, "result html" );
}

# active check 2
{
  my $mech = WWW::Mechanize::Pluggable->new;
  my $uri = URI::file->new_abs("t/waiting_01.html")->as_string;

  # load initial page
  $mech->get( $uri );
  ok( $mech->success, "Fetched: $uri" ) or die "cannot load test html!";

  # follow
  my $start = time;
  ok( $mech->follow_meta_redirect( ignore_waiting => 0 ), "follow meta refresh link" );
  ok( time - $start >= 2.00, "waiting sec" );

  # check
  ok( $mech->is_html, "is html" );
  ok( $mech->content =~ /test ok\./, "result html" );
}

# negative check 1
{
  my $mech = WWW::Mechanize::Pluggable->new;
  my $uri = URI::file->new_abs("t/waiting_01.html")->as_string;

  # load initial page
  $mech->get( $uri );
  ok( $mech->success, "Fetched: $uri" ) or die "cannot load test html!";

  # follow
  my $start = time;
  ok( $mech->follow_meta_redirect( ignore_waiting => 1 ), "follow meta refresh link" );
  ok( time - $start < 1.00, "waiting sec" );

  # check
  ok( $mech->is_html, "is html" );
  ok( $mech->content =~ /test ok\./, "result html" );
}

