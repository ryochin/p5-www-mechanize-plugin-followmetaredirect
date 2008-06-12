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
);

my $html = do { local $/; <DATA> };

my $n = 0;
for my $t( @t ){
  my $file = File::Spec->join("t", sprintf "meta_format_%02d.html", ++$n);

  my $fh = IO::File->new;
  $fh->open("> $file") or die $!;
  $fh->printf( $html, $t );
  $fh->close;
}

__DATA__
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="en-US" xml:lang="en-US" xmlns="http://www.w3.org/1999/xhtml">
<head>
<link rev="made" href="mailto:webmaster&#64;example.com" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
%s
<meta name="robots" content="noindex,nofollow" />
<title>test</title>
</head>
<body>
<p>
test.
</p>
</body>
</html>

