use XML::XSLT;

%t = ( 'apply-imports'   => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'apply-templates' => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'attribute'       => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'attribute-set'   => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'call-template'   => {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'choose'          => {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'comment'         => {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'copy'            => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'copy-of'         => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'decimal-format'  => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'element'         => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'fallback'        => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'for-each'        => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'if'              => {test => 0.5,   xsl => q{}, xml => q{}, out => q{}},
       'import'          => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'include'         => {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'key'             => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'message'         => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'namespace-alias' => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'number'          => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'otherwise'       => {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'output'          => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'param'           => {test => 0.2,   xsl => q{}, xml => q{}, out => q{}},
       'preserve-space'  => {test => undef, xsl => q{}, xml => q{}, out => q{}},
       'processing-instruction'  =>
                            {test => 1,     xsl => q{}, xml => q{}, out => q{}},
       'sort'            => {test => undef,   xsl => q{}, xml => q{}, out => q{}},
       'strip-space'     => {test => undef,   xsl => q{}, xml => q{}, out => q{}},
       'stylesheet'      => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'template'        => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'text'            => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'transform'       => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'value-of'        => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'when'            => {test => 0.5,     xsl => q{}, xml => q{}, out => q{}},
       'with-param'      => {test => 0.2,     xsl => q{}, xml => q{}, out => q{}},
     );


foreach(keys %t) {
  push @test, $_ if $t{$_}->{test} == 1;
}

print "1.." . scalar @test . "\n";

foreach (0..$#test) {
  $p = XML::XSLT->new($t{$test[$_]}->{xsl}, "STRING");
  my $r;
  eval {$p->transform_document ($t{$test[$_]}->{xml}, "STRING");
	$r = $p->result_string};
  print "not "
    if defined $@ or $r ne $t{$test[$_]}->{out};
  print "ok " . ($_ + 1) . "\n";
}

# minor change