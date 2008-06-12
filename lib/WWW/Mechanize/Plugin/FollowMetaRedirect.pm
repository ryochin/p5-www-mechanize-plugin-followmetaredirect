# 
# $Id$

package WWW::Mechanize::Plugin::FollowMetaRedirect;

use strict;
use warnings "all";
use vars qw($VERSION);
use HTML::TokeParser;

$VERSION = '0.01';

sub init {
   no strict 'refs';    ## no critic
   *{caller(). '::follow_meta_redirect'} = \&follow_meta_redirect;
}

sub follow_meta_redirect {
    my ($mech, %args) = @_;
    my $waiting = ( defined $args{ignore_waiting} and $args{ignore_waiting} ) ? 0 : 1;

    my $p = HTML::TokeParser->new( \ $mech->content )
	or return;

    while( my $token = $p->get_token ){
	# for tiny optimization
	return if $token->[0] eq 'E' && $token->[1] eq 'head';
	
	my ($url, $sec) = &_extract( $token );
	next if ! defined $url || $url eq '';
	
	if( $waiting and defined $sec ){
	    sleep int $sec;
	}
	
	return $mech->get( $url );
    }

    return;
}

sub _extract {
    my $token = shift;

    if( $token->[0] eq 'S' and $token->[1] eq 'meta' ){
	if( defined $token->[2] and ref $token->[2] eq 'HASH' ){
	    if( defined $token->[2]->{'http-equiv'} and $token->[2]->{'http-equiv'} =~ /^refresh$/io ){
		if( defined $token->[2]->{'content'} and $token->[2]->{'content'} =~ m|^(([0-9]+);\s*)*url\=(.+)$|io ){
		    return ($3, $2);
		}
	    }
	}
    }

    return;
}

1;

__END__

=head1 NAME

WWW::Mechanize::Plugin::FollowMetaRedirect - Follows 'meta refresh' link

=head1 SYNOPSIS

  use WWW::Mechanize::Pluggable;

  my $mech = WWW::Mechanize::Pluggable->new;
  $mech->get( $url );
  $mech->follow_meta_redirect;

  $mech->follow_meta_redirect( ignore_waiting => 1 );

=head1 DESCRIPTION

WWW::Mechanize doesn't follow so-called 'meta refresh' link.
This module automatically find the link and follow.

=head1 METHODS

=head2 follow_meta_redirect

If $mech->content() has meta refresh element like this,

  <head>
    <meta http-equiv="refresh" content="5; URL=/docs/hello.html" />
  </head>

the code below will try to find and follow the link set on url=.

  $mech->follow_meta_redirect;

In this case, the above code is entirely equivalent to:

  sleep 5;
  $mech->get("/docs/hello.html");

When a refresh link found and successfully followed, HTTP::Response object will be returned (see WWW::Mechanize::follow_link() ), 
otherwise nothing returned.

To sleep specified seconds is default when 'waiting second' found. You can ignore this by setting ignore_waiting true.

  $mech->follow_meta_redirect( ignore_waiting => 1 );

=head1 BUGS

Only first link is picked up when the HTML document has more than one 'meta refresh' links (but I think it should be so).

=head1 TODO

A bit more efficient optimization to suppress extra parsing by limiting job range within <head></head> region.

=head1 DEPENDENCIES

WWW::Mechanize, WWW::Mechanize::Pluggable

=head1 AUTHOR

Ryo Okamoto C<< <ryo at aquahill dot net> >>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Ryo Okamoto, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

