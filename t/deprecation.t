#!/usr/nin/perl

use strict;
use warnings;

use Test::Most tests => 3;

our $DEBUGGING = 0;

use_ok('XML::XSLT');

my $foo;

warning_like
{
    my $parser = XML::XSLT->new( '<xml />', $DEBUGGING );
}

qr/new deprecated/, "warns about deprecation";

warning_is
{
    my $parser = XML::XSLT->new( '<xml />', use_deprecated => 1, debug => $DEBUGGING );
}
[], "switched deprecations off";
