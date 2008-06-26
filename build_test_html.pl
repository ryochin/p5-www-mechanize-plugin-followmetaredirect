#!/usr/bin/perl --
# 
# $Id$

use strict;
use File::Spec;
use IO::File;

# up to 20
my @t = (
  q|<meta http-equiv="Refresh" content="0;url=result.html" />|,
  q|<META HTTP-EQUIV="REFRESH" CONTENT="0;URL=result.html" />|,
  q|<meta http-equiv="Refresh" content="10;url=result.html" />|,
  q|<meta http-equiv="Refresh" content="10;    url=result.html" />|,
  q|<meta http-equiv="Refresh" content="url=result.html" />|,
  q|<meta http-equiv="Refresh" content="URL=result.html" />|,
  q|<meta http-equiv="Refresh" content="0;url=./result.html" />|,
  q|<meta http-equiv="Refresh" content="0;url=result.html?q=user%20example.com+perl&amp;foo=bar" />|,
);

my $html = do { local $/; <DATA> };

my $n = 0;
for my $t( @t ){
  $n++;
  next if $n == 1;    # for complicated html
  my $file = File::Spec->join("t", sprintf "meta_format_%02d.html", $n);

  my $fh = IO::File->new;
  $fh->open("> $file") or die $!;
  $fh->printf( $html, $t );
  $fh->close;
}

__DATA__
<html>
<head>
%s
<meta name="robots" content="noindex,nofollow" />
</head>
<body>
</body>
</html>

