################################################################################
#
# Perl module: XML::XSLT
#
# By Geert Josten, gjosten@sci.kun.nl
# and Egon Willighagen, egonw@sci.kun.nl
#
################################################################################

######################################################################
package XML::XSLT;
######################################################################

use strict;
use vars qw ( $VERSION @ISA @EXPORT_OK
              $ELEMENT_NODE $ATTRIBUTE_NODE $TEXT_NODE
	      $CDATA_SECTION_NODE $ENTITY_REFERENCE_NODE
              $ENTITY_NODE $PROCESSING_INSTRUCTION_NODE
	      $COMMENT_NODE $DOCUMENT_NODE $DOCUMENT_TYPE_NODE
	      $DOCUMENT_FRAGMENT_NODE $NOTATION_NODE
	      $AUTOLOAD
            );
#$UNKNOWN_NODE
#$ELEMENT_DECL_NODE $ATT_DEF_NODE
#$XML_DECL_NODE $ATTLIST_DECL_NODE

use LWP::UserAgent;
use XML::DOM 1.25;

BEGIN {

  $VERSION = '0.24';

  @ISA         = qw( Exporter );
  @EXPORT_OK   = qw( &transform &Server );

  # pretty print HTML tags (<BR /> etc...)
  XML::DOM::setTagCompression (\&__my_tag_compression__);

  ### added for efficiency reasons
  $ELEMENT_NODE 	       = XML::DOM::ELEMENT_NODE;
  $ATTRIBUTE_NODE	       = XML::DOM::ATTRIBUTE_NODE;
  $TEXT_NODE		       = XML::DOM::TEXT_NODE;
  $CDATA_SECTION_NODE	       = XML::DOM::CDATA_SECTION_NODE;
  $ENTITY_REFERENCE_NODE       = XML::DOM::ENTITY_REFERENCE_NODE;
  $ENTITY_NODE  	       = XML::DOM::ENTITY_NODE;
  $PROCESSING_INSTRUCTION_NODE = XML::DOM::PROCESSING_INSTRUCTION_NODE;
  $COMMENT_NODE 	       = XML::DOM::COMMENT_NODE;
  $DOCUMENT_NODE	       = XML::DOM::DOCUMENT_NODE;
  $DOCUMENT_TYPE_NODE	       = XML::DOM::DOCUMENT_TYPE_NODE;
  $DOCUMENT_FRAGMENT_NODE      = XML::DOM::DOCUMENT_FRAGMENT_NODE;
  $NOTATION_NODE	       = XML::DOM::NOTATION_NODE;
  ### these node ID's are not part of the Reccomendation
  #$UNKNOWN_NODE		= XML::DOM::UNKNOWN_NODE;
  #$ELEMENT_DECL_NODE  	 	= XML::DOM::ELEMENT_DECL_NODE;
  #$ATT_DEF_NODE		= XML::DOM::ATT_DEF_NODE;
  #$XML_DECL_NODE		= XML::DOM::XML_DECL_NODE;
  #$ATTLIST_DECL_NODE  	 	= XML::DOM::ATTLIST_DECL_NODE;
}

# private auxiliary function #
sub __my_tag_compression__ {
  my ($tag, $elem) = @_;

  # Print empty br, hr and img tags like this: <br />
  # also when preceded by a namespace: ([\w\.]+\:){0,1}
  return 2 if $tag =~ /^([\w\.\-]+\:){0,1}(br|p|hr|img|meta|base|link)$/i;

  # Print other empty tags like this: <empty></empty>
  return 1;
}


######################################################################
# PUBLIC DEFINITIONS


sub new {
  my ($class, $xsl, $xsl_flag, %args) = @_;
  my $self = {};

  print "creating parser object:$/" if $args{debug};

  if (!$xsl) {
    warn "No stylesheet was passed to new(), no parser object is created!";
    return undef;
  }

  my $Self = bless { DOMparser => XML::DOM::Parser->new (),
                       xml => undef, xml_flag => undef, xml_dir => undef,
	               xsl => undef, xsl_flag => undef, xsl_dir => undef,
	               result => undef, stylesheet => undef, templates => undef,
		       template_matches => undef, template_names => undef,
		       xsl_ns => "", xsl_version => undef,
		       namespaces => {()},

                       DOMparser_args => defined $args{DOMparser_args} ? $args{DOMparser_args} : {},
	               variables      => defined $args{variables}      ? $args{variables}      : {},
		       debug          => defined $args{debug}          ? $args{variables}      : "",
		       warnings       => defined $args{warnings}       ? $args{warnings}       : 0,
	               indent         => defined $args{indent}         ? $args{indent}         : 0,
		       indent_incr    => defined $args{indent_incr}    ? $args{indent_incr}    : 1,
		       use_deprecated => defined $args{use_deprecated} ? $args{use_deprecated} : 0,
		     }, $class;

  $Self->{indent} += $Self->{indent_incr};
  $Self->open_xsl ($xsl, $xsl_flag, %args);
  $Self->{indent} -= $Self->{indent_incr};

  return $Self;
}

sub open_xml {
  my ($Self, $xml, $xmlflag, %args) = @_;

  # clean up a little
  if ($Self->{xml_flag} && $Self->{xml_flag} !~ /^DOM/i) {  
    print " "x$Self->{indent},"disposing old xsl...$/" if $Self->{debug};
    $Self->{xml}->dispose ()     if (defined $Self->{xml});
  }
  if (defined $Self->{result}) {
    print " "x$Self->{indent},"flushing result...$/" if $Self->{debug};
    $Self->{result}->dispose ();
  }

  print " "x$Self->{indent},"opening xml...$/" if $Self->{debug};

  # open new document
  ($Self->{xml}, $Self->{xml_dir})
    = $Self->_open_document ($xml, $xmlflag, ".", %args);
  $Self->{xml_flag} = $xmlflag;

  $Self->{result} = $Self->{xml}->createDocumentFragment;
}

sub open_xsl {
  my $Self = shift;

  if (@_ == 1) {
    # Figure out argtype
  } elsif (@_ > 1) {
    %args = @_
      # deprecated: ($xsl, FILE|STRING|DOM, [%ARGS])
  }
  my ($Self, $xsl, $xslflag, %args) = @_;
  $xslflag ||= "FILE";

  if (ref $xsl) {
  }


  # clean up a little
  if ($Self->{xsl_flag} && $Self->{xsl_flag} !~ /^DOM/i) {
    print " "x$Self->{indent},"disposing old xsl...$/" if $Self->{debug};
    $Self->{xsl}->dispose ()     if (defined $Self->{xsl});
  }

  print " "x$Self->{indent},"opening xsl...$/" if $Self->{debug};

  # open new document
  ($Self->{xsl}, $Self->{xml_dir})
    = $Self->_open_document ($xsl, $xslflag, ".", %args);
  $Self->{xsl_flag} = $xslflag;

  $Self->__preprocess_stylesheet;
}

# private auxiliary function #
sub __preprocess_stylesheet {
  my $Self = $_[0];

  print " "x$Self->{indent},"preprocessing stylesheet...$/" if $Self->{debug};

  ($Self->{stylesheet}, $Self->{xsl_ns})
    = $Self->__get_stylesheet ($Self->{xsl});

  ($Self->{xsl_version})
    = $Self->__extract_namespaces ($Self->{stylesheet}, $Self->{xsl_ns});
  $Self->__expand_xsl_includes ($Self->{xsl}, $Self->{xsl_ns}, $Self->{xsl_dir});
  $Self->__extract_top_level_variables;

  $Self->__add_default_templates;
  $Self->__cache_templates;	# speed optim #
      
  $Self->__set_xsl_output;
}

# private auxiliary function #
sub __get_stylesheet {
  my ($Self, $xsl) = @_;
  my $stylesheet = "";
  my $xsl_ns = "";

  foreach my $child ($xsl->getElementsByTagName ('*', 0)) {
    if ($child->getTagName =~ /^(([\w\.\-]+)\:){0,1}(stylesheet|transform)$/i) {
      $stylesheet = $child;
      $xsl_ns = ($2 || "");
      last;
    }
  }

  if (! $stylesheet) {
    # stylesheet is actually one compleet template! #
    # put it in a template-element #
	    
    $stylesheet = $xsl->createElement ("$xsl_ns:stylesheet");
    my $template = $xsl->createElement ("$xsl_ns:template");
    $template->setAttribute ('match', "/");

    my $template_content = $xsl->getElementsByTagName ('*', 0)->item (0);
    $xsl->replaceChild ($stylesheet, $template_content);
    $stylesheet->appendChild ($template);
    $template->appendChild ($template_content);
  }
	  
  return ($stylesheet, "$xsl_ns:");
}

# private auxiliary function #
sub __extract_namespaces {
  my ($Self, $stylesheet, $xsl_ns) = @_;
  my $xsl_version = "";

  foreach my $attribute ($stylesheet->getAttributes->getValues) {
    my $name = $attribute->getName;
    my $value = $attribute->getValue;
    if ($value) {
      if ($name eq "version") {
	$xsl_version = $value;
      } elsif ($name =~ /^xmlns(\:([\w\.\-]+)){0,1}/i) {
	my $namespace = ($2 ? "$2:" : "");
	if (($namespace eq $xsl_ns)
	    && ($value !~ /^http\:\/\/www\.w3\.org\/1999\/XSL\/Transform/i)) {
	  warn "XML::XSLT implements the specs of http://www.w3.org/1999/XSL/Transform. URL $value might be depricated.$/"
	    if $Self->{warnings};
	}
	$Self->{namespaces} = {%{$Self->{namespaces}}, $namespace => $value};
      }
    } else {
      print " "x$Self->{indent},"attribute $name carries no value$/" if $Self->{debug};
    }
  }
	  
  if (! exists ${$Self->{namespaces}}{""}) {
    $Self->{namespaces} = {%{$Self->{namespaces}}, "" => 'http://www.w3.org/TR/xhtml1/strict'};
  }
}

# private auxiliary function #
sub __expand_xsl_includes {
  my ($Self, $xsl, $xsl_ns, $xsl_dir) = @_;

  foreach my $include_node ($xsl->getElementsByTagName("{$xsl_ns}include")) {
    my $include_file = $include_node->getAttribute('href');

    if ($include_file) {
      my ($include_doc, $dir);
      eval {
	($include_doc, $dir) = $Self->_open_by_filename ($include_file, $xsl_dir);
      };
	      
      if ($@) {
	chomp ($@);
	print " "x$Self->{indent},"inclusion of $include_file failed! ($@)$/" if $Self->{debug};
	warn "inclusion of $include_file failed! ($@)$/" if $Self->{warnings};
      } else {
	my ($stylesheet, $ns) = $Self->__get_stylesheet ($include_doc);
	my $version = $Self->__extract_namespaces ($stylesheet, $ns);
	$Self->__expand_xsl_includes ($include_doc, $ns, $dir);

	foreach my $child ($stylesheet->getChildNodes) {
	  $include_node->appendChild($child);
	}
      }

    } else {
      print " "x$Self->{indent},"$Self->{xsl_ns}include tag carries no selection!$/" if $Self->{debug};
      warn "$Self->{xsl_ns}include tag carries no selection!$/" if $Self->{warnings};
    }
  }
}

# private auxiliary function #
sub __extract_top_level_variables {
  my $Self = $_[0];

  foreach my $child ($Self->{stylesheet}->getElementsByTagName ('*',0)) {
    if ($child =~ /^$Self->{xsl_ns}(variable|param)/i) {
      my $vartag = $1;

      my $name = $child->getAttribute("name");
      if ($name) {
	my $value = $child->getAttribute("select");
	if (!$value) {
	  my $result = $Self->{xml}->createDocumentFragment;
	  $Self->_evaluate_template ($child, $Self->{xml}, '', $result);
	  $value = $Self->_string ($result);
	  $result->dispose();
	}
	%{$Self->{variables}} = (%{$Self->{variables}}, $name => $value);
      } else {
	print " "x$Self->{indent},"$Self->{xsl_ns}$vartag tag carries no name!$/" if $Self->{debug};
	warn "$Self->{xsl_ns}include tag carries no name!$/" if $Self->{warnings};
      }

    }
  }
}

# private auxiliary function #
sub __add_default_templates {
  my $Self = $_[0];

  # create template for '*' and '/' #
  my $elem_template = $Self->{xsl}->createElement ("$Self->{xsl_ns}template");
  $elem_template->setAttribute('match','*|/');
  # <xsl:apply-templates />
  $elem_template->appendChild ($Self->{xsl}->createElement ("$Self->{xsl_ns}apply-templates"));

  # create template for 'text()' and '@*' #
  my $attr_template = $Self->{xsl}->createElement ("$Self->{xsl_ns}template");
  $attr_template->setAttribute('match','text()|@*');
  # <xsl:value-of select="." />
  $attr_template->appendChild ($Self->{xsl}->createElement ("$Self->{xsl_ns}value-of"));
  $attr_template->getFirstChild->setAttribute('select','.');

  # create template for 'processing-instruction()' and 'comment()' #
  my $pi_template = $Self->{xsl}->createElement ("$Self->{xsl_ns}template");
  $pi_template->setAttribute('match','processing-instruction()|comment()');
  # do nothing :-)

  # add them to the stylesheet #
  my $first_child = $Self->{stylesheet}->getFirstChild ();
  $Self->{stylesheet}->insertBefore ($pi_template, $first_child);
  $Self->{stylesheet}->insertBefore ($attr_template, $first_child);
  $Self->{stylesheet}->insertBefore ($elem_template, $first_child);
}

# private auxiliary function #
sub __cache_templates {
  my $Self = $_[0];

  $Self->{templates} = [$Self->{xsl}->getElementsByTagName ("$Self->{xsl_ns}template")];

  # pre-cache template names and matches #
  # reversing the template order is much more efficient #
  foreach my $template (reverse @{$Self->{templates}}) {
    if ($template->getParentNode->getTagName =~
	/^([\w\.\-]+\:){0,1}(stylesheet|transform|include)/i) {
      my $match = $template->getAttribute ('match');
      my $name = $template->getAttribute ('name');
      if ($match && $name) {
	print " "x$Self->{indent},"defining a template with both a \"name\" and a \"match\" attribute is not allowed!$/" if $Self->{debug};
	warn "defining a template with both a \"name\" and a \"match\" attribute is not allowed!$/" if $Self->{warnings};
	push (@{$Self->{template_matches}}, "");
	push (@{$Self->{template_names}}, "");
      } elsif ($match) {
	push (@{$Self->{template_matches}}, $match);
	push (@{$Self->{template_names}}, "");
      } elsif ($name) {
	push (@{$Self->{template_matches}}, "");
	push (@{$Self->{template_names}}, $name);
      } else {
	push (@{$Self->{template_matches}}, "");
	push (@{$Self->{template_names}}, "");
      }
    }
  }
}

# private auxiliary function #
sub __set_xsl_output {
  my $Self = $_[0];

  # default settings
  $Self->{method} = 'xml';
  $Self->{media_type} = 'text/xml';
  $Self->{omit_xml_declaration} = 'yes';

  # extraction of top-level xsl:output tag
  my ($output) = $Self->{stylesheet}->getElementsByTagName("$Self->{xsl_ns}output",0);
          
  if ($output) {
    # extraction and processing of the attributes
    my $attribs = $output->getAttributes;
    $Self->{media_type} = $attribs->getNamedItem('media-type')->getNodeValue;
    $Self->{method} = $attribs->getNamedItem('method')->getNodeValue;

    if ($Self->{method} eq 'xml') {

      my $omit_xml_declaration = $attribs->getNamedItem('omit-xml-declaration')->getNodeValue;

      if (($omit_xml_declaration ne 'yes') && ($omit_xml_declaration ne 'no')) {
	print " "x$Self->{indent},"wrong value for attribute \"omit-xml-declaration\" in <$Self->{xsl_ns}output>, should be \"yes\" or \"no\"\n" if ($Self->{debug});
	warn "Wrong value for attribute \"omit-xml-declaration\" in $Self->{xsl_ns}output, should be \"yes\" or \"no\"\n" if $Self->{warnings};
      } else {
	$Self->{omit_xml_declaration} = $omit_xml_declaration;
      }

      if (! $Self->{omit_xml_declaration}) {
	$Self->{output_version} = $attribs->getNamedItem('version')->getNodeValue;
	$Self->{output_encoding} = $attribs->getNamedItem('encoding')->getNodeValue;

	if ((! $Self->{output_version}) || (! $Self->{output_encoding})) {
	  print " "x$Self->{indent},"expected attributes \"version\" and \"encoding\" in <$Self->{xsl_ns}output>\n" if ($Self->{debug});
	  warn "Expected attributes \"version\" and \"encoding\" in $Self->{xsl_ns}output\n" if $Self->{warnings};
	}
      }
    }
    $Self->{doctype_public} = ($attribs->getNamedItem('doctype-public')->getNodeValue||'');
    $Self->{doctype_system} = ($attribs->getNamedItem('doctype-system')->getNodeValue||'');
  }
}  


sub open_project {
  my ($Self, $xml, $xsl, $xmlflag, $xslflag, %args) = @_;

  print " "x$Self->{indent},"opening project:$/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  $Self->open_xml ($xml, $xmlflag, %args);
  $Self->open_xsl ($xsl, $xslflag, %args);

  print " "x$Self->{indent},"done...$/" if $Self->{debug};
  $Self->{indent} -= $Self->{indent_incr};
}

sub transform {
  my ($Self, $xml, $xmlflag, %topvariables) = @_;

  print " "x$Self->{indent},"transforming document:$/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  $Self->open_xml ($xml, $xmlflag, %topvariables);

  print " "x$Self->{indent},"done...$/" if $Self->{debug};
  $Self->{indent} -= $Self->{indent_incr};
  print " "x$Self->{indent},"processing project:$/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  my $root_template = $Self->_match_template ("match", '/', 1, '');

  %topvariables = (%{$Self->{variables}}, %topvariables);

  $Self->_evaluate_template (
			       $root_template, # starting template: the root template
			       $Self->{xml}, # current XML node: the root
			       '', # current XML selection path: the root
			       $Self->{result}, # current result tree node: the root
			       {
				()}, # current known variables: none
			       \%topvariables # previously known variables: top level variables
			      );

  print " "x$Self->{indent},"done!$/" if $Self->{debug};
  $Self->{indent} -= $Self->{indent_incr};
}

sub process {
  my ($Self, %topvariables) = @_;

  print " "x$Self->{indent},"processing project:$/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  my $root_template = $Self->_match_template ("match", '/', 1, '');

  %topvariables = (%{$Self->{variables}}, %topvariables);

  $Self->_evaluate_template (
			       $root_template, # starting template: the root template
			       $Self->{xml}, # current XML node: the root
			       '', # current XML selection path: the root
			       $Self->{result}, # current result tree node: the root
			       {
				()}, # current known variables: none
			       \%topvariables # previously known variables: top level variables
			      );

  print " "x$Self->{indent},"done!$/" if $Self->{debug};
  $Self->{indent} -= $Self->{indent_incr};
}

my %deprecation_used;

# Handles deprecations.
sub AUTOLOAD {
  my $Self = shift;
  my $type = ref($Self) || croak "Not a method call";
  my $name = $AUTOLOAD;
  $name =~ s/.*://;

  my %deprecation = ('output_string'      => 'asString',
		     'result_string'      => 'asString',
		     'output'             => 'asString',
		     'result'             => 'asString',
		     'result_mime_type'   => 'media_type',
		     'output_mime_type'   => 'media_type'
		     'result_tree'        => 'to_dom',
		     'output_tree'        => 'to_dom',
		     'transform_document' => 'transform',
		     'process_project'    => 'process'
		    );

  if (exists $deprecation{$name}) {
    carp "$name is deprecated.  Use $deprecation{$name}"
      unless $Self->{use_deprecated}
	or exists $deprecation_used{$name};
    $deprecation_used{$name} = 1;
    eval qq{return \$Self->$deprecation{$name}(\@_)};
  } else {
    croak "$name: No such method name";
  }
}

sub _my_print_text {
  my ($self, $FILE) = @_;

  # This should work with either XML::DOM 1.25 or XML::DOM 1.27
  if (UNIVERSAL::isa($self, "XML::DOM::CDATASection")) {
    $FILE->print ($self->getData);
  } else {
    $FILE->print (XML::DOM::encodeText($self->getData, "<&"));
  }
}

sub toString {
  my $Self = $_[0];

  local *XML::DOM::Text::print = \&_my_print_text;

  my $string = $Self->{result}->toString;
  #  $string =~ s/\n\s*\n(\s*)\n/\n$1\n/g;  # Substitute multiple empty lines by one
  #  $string =~ s/\/\>/ \/\>/g;            # Insert a space before every />
        
  # get rid of CDATA wrappers
  #  if (! $Self->{printCDATA}) {
  #    $string =~ s/\<\!\[CDATA\[//g;
  #    $string =~ s/\]\]>//g;
  #  }

  return $string;
}

sub to_dom {
  my $Self = shift;

  return $Self->{result};
}

sub media_type {
  return ($_[0]->{media_type});
}

sub print_output {
  my ($Self, $file, $mime) = @_;
  $file ||= '';			# print to STDOUT by default
  $mime = 1 unless defined $mime;

  # print mime-type header etc by default

  #  $Self->{result}->printToFileHandle (\*STDOUT);
  #  or $Self->{result}->print (\*STDOUT); ???
  #  exit;

  if ($mime) {
    print "Content-type: $Self->{media_type}\n\n";

    if ($Self->{method} eq 'xml') {
      if (($Self->{omit_xml_declaration} eq 'no') && $Self->{output_version}
	  && $Self->{output_encoding}) {
	print "<?xml version=\"$Self->{output_version}\" encoding=\"$Self->{output_encoding}\"?>\n";
      }
    }
    if ($Self->{doctype_system}) {
      my $root_name = $Self->{result}->getElementsByTagName('*',0)->item(0)->getTagName;
      if ($Self->{doctype_public}) {
	print "<!DOCTYPE $root_name PUBLIC \"$Self->{doctype_public}\" \"$Self->{doctype_system}\">\n";
      } else {
	print "<!DOCTYPE $root_name SYSTEM \"$Self->{doctype_system}\">\n";
      }
    }
  }

  if ($file) {
    if (ref (\$file) !~ /^SCALAR/i) {
      print $file $Self->output_string,$/;
    } else {
      if (open (FILE, ">$file")) {
	print FILE $Self->output_string,$/;
	if (! close (FILE)) {
	  die ("Error writing $file: $!. Nothing written...$/");
	}
      } else {
	die ("Error opening $file: $!. Nothing done...$/");
      }
    }
  } else {
    print $Self->output_string,$/;
  }
}
*print_result = *print_output;

sub dispose {
  #my $Self = $_[0];

  #$_[0]->{DOMparser} = undef if (defined $_[0]->{DOMparser});
  $_[0]->to_dom->dispose ()    if (defined $_[0]->{result});

  # only dispose xml and xsl when they were not passed as DOM
  if ($_[0]->{xml_flag} && $_[0]->{xml_flag} !~ /^DOM/i) {  
    $_[0]->{xml}->dispose ()     if (defined $_[0]->{xml});
  }
  if ($_[0]->{xsl_flag} && $_[0]->{xsl_flag} !~ /^DOM/i) {  
    $_[0]->{xsl}->dispose ()     if (defined $_[0]->{xsl});
  }

  $_[0] = undef;
}


######################################################################
# PRIVATE DEFINITIONS


sub _open_document {
  my ($Self, $parse_object, $object_type, $dir, %args) = @_;
  $object_type ||= "FILENAME";
  %args = (%{$Self->{DOMparser_args}}, %args);
  my $doc;

  print " "x$Self->{indent},"opening document of type $object_type...$/" if $Self->{debug};

  # A filename or a filehandle/stream could be passed
  if ($object_type =~ /^FILE/i) {
    if (ref (\$parse_object) ne 'SCALAR') {
      # it is not a filename, let XML::Parser take care of it
      $doc = $Self->{DOMparser}->parse ($parse_object, %args);
    } else {
      # it is a filename. http:? file:? relative path?
      ($doc, $dir) = $Self->_open_by_filename ($parse_object, $dir, %args);
    }

    # but a DOM tree could be passed as well    
  } elsif ($object_type =~ /^DOM/i) {
    if (ref ($parse_object) eq 'XML::DOM::Document') {
      $doc = $parse_object;
    } else {
      die ("Error: pass a DOM Document node to open_project when passing a DOM tree$/");
    }

    # or a scalar or even a scalar ref!
  } elsif ($object_type =~ /^STRING/i) {
    if (ref ($parse_object) eq 'SCALAR') {
      $doc = $Self->{DOMparser}->parse ($$parse_object, %args);
    } else {
      $doc = $Self->{DOMparser}->parse ($parse_object, %args);
    }

    # I don't know, it's not FILE, STRING nor DOM
  } else {
    die ("Error: cannot open documents of type \"$object_type\"$/");
  }

  return ($doc, $dir);
}

# private auxiliary function #
sub _open_by_filename {
  my ($Self, $filename, $dir, %args) = @_;
  my $doc;

  # it's a http link!
  if ($filename =~ /^http:/i) {
    my $request = HTTP::Request->new (GET => $filename);
    my $result = LWP::UserAgent->new()->request($request);

    if ($result->is_success) {
      $doc = $Self->{DOMparser}->parse ($result->content, %args);
    } else {
      die ("Error: cannot open document from URL \"$filename\"$/");
    }

    $dir = $filename;
    $dir =~ s/\/[^\/]+$//i;

    # no? then it must be a file path...
  } else {
    $filename =~ s/^file://i;

    if ($filename =~ /^\//i) {
      $dir = $filename;
      $dir =~ s/\/[^\/]+$//i;
    } else {
      $filename = "$dir/$filename";
    }

    if (-f $filename) {
      $doc = $Self->{DOMparser}->parsefile ($filename, %args);
    } else {
      die ("Error: cannot open document from path \"$filename\"$/");
    }
  }

  return ($doc, $dir);
}

sub _match_template {
  my ($Self, $attribute_name, $select_value, $xml_count, $xml_selection_path,
      $mode) = @_;
  $mode ||= "";
  
  my $template = "";
  my @template_matches = ();

  print " "x$Self->{indent},"matching template for \"$select_value\" with count $xml_count and path \"$xml_selection_path\":$/" if $Self->{debug};
  
  if ($attribute_name eq "match") {
    @template_matches = @{$Self->{template_matches}};
  } elsif ($attribute_name eq "name") {
    @template_matches = @{$Self->{template_names}};
  }

  # note that the order of @template_matches is the reverse of $Self->{templates}
  my $count = @template_matches;
  foreach my $original_match (@template_matches) {
    # templates with no match or name or with both simultaniuously
    # have no $template_match value
    if ($original_match) {
      my $full_match = $original_match;

      # multipe match? (for example: match="*|/")
      while ($full_match =~ s/^(.+?)\|//i) {
	my $match = $1;
	if (&__template_matches__ ($match, $select_value, $xml_count,
				   $xml_selection_path)) {
	  print " "x$Self->{indent},"  found #$count with \"$match\" in \"$original_match\" $/" if $Self->{debug};
	  $template = ${$Self->{templates}}[$count-1];
	  return $template;
	  #	  last;
	}
      }

      # last match?
      if (!$template) {
	if (&__template_matches__ ($full_match, $select_value, $xml_count,
				   $xml_selection_path)) {
	  print " "x$Self->{indent},"  found #$count with \"$full_match\" in \"$original_match\"$/" if $Self->{debug};
	  $template = ${$Self->{templates}}[$count-1];
	  return $template;
	  #          last;
	} else {
	  print " "x$Self->{indent},"  #$count \"$original_match\" did not match$/" if $Self->{debug};
	}
      }
    }
    $count--;
  }

  if (! $template) {
    print "no template found! $/" if $Self->{debug};
    warn "No template matching $xml_selection_path found !!$/" if $Self->{warnings};
  }

  return $template;
}

# auxiliary function #
sub __template_matches__ {
  my ($template, $select, $count, $path) = @_;
    
  my $nocount_path = $path;
  $nocount_path =~ s/\[.*?\]//ig;

  if (($template eq $select) || ($template eq $path)
      || ($template eq "$select\[$count\]") || ($template eq "$path\[$count\]")) {
    # perfect match or path ends with templates match
    #print "perfect match",$/;
    return "True";
  } elsif ( ($template eq substr ($path, - length ($template)))
	    || ($template eq substr ($nocount_path, - length ($template)))
	    || ("$template\[$count\]" eq substr ($path, - length ($template)))
	    || ("$template\[$count\]" eq substr ($nocount_path, - length ($template)))
	  ) {
    # template matches tail of path matches perfectly
    #print "perfect tail match",$/;
    return "True";
  } elsif ($select =~ /\[\s*(\@.*?)\s*=\s*(.*?)\s*\]$/i) {
    # match attribute test
    my $attribute = $1;
    my $value = $2;
    return "";			# False, no test evaluation yet #
  } elsif ($select =~ /\[\s*(.*?)\s*=\s*(.*?)\s*\]$/i) {
    # match test
    my $element = $1;
    my $value = $2;
    return "";			# False, no test evaluation yet #
  } elsif ($select =~ /(\@\*|\@[\w\.\-\:]+)$/i) {
    # match attribute
    my $attribute = $1;
    #print "attribute match?",$/;
    return (($template eq '@*') || ($template eq $attribute)
	    || ($template eq "\@*\[$count\]") || ($template eq "$attribute\[$count\]"));
  } elsif ($select =~ /(\*|[\w\.\-\:]+)$/) {
    # match element
    my $element = $1;
    #print "element match?",$/;
    return (($template eq "*") || ($template eq $element)
	    || ($template eq "*\[$count\]") || ($template eq "$element\[$count\]"));
  } else {
    return "";			# False #
  }
}

sub _evaluate_template {
  my ($Self, $template, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  print " "x$Self->{indent},"evaluating template content with current path \"$current_xml_selection_path\": $/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  $template->normalize();
  foreach my $child ($template->getChildNodes) {
    my $ref = ref $child;

    print " "x$Self->{indent},"$ref$/" if $Self->{debug};
    $Self->{indent} += $Self->{indent_incr};
    my $node_type = $child->getNodeType;
    if ($node_type == $ELEMENT_NODE) {
      $Self->_evaluate_element ($child, $current_xml_node,
				  $current_xml_selection_path,
				  $current_result_node, $variables, $oldvariables);
    } elsif ($node_type == $TEXT_NODE) {
      # strip whitespace here?
      $Self->_add_node ($child, $current_result_node);
    } elsif ($node_type == $CDATA_SECTION_NODE) {
      my $text = $Self->{xml}->createTextNode ($child->getData);
      $Self->_add_node($text, $current_result_node);
      #print "disabling output escaping$/";
      $current_result_node->getLastChild->{_disable_output_escaping} = 1;
      #$Self->_add_node($child, $current_result_node);
    } elsif ($node_type == $ENTITY_REFERENCE_NODE) {
      $Self->_add_node($child, $current_result_node);
    } elsif ($node_type == $DOCUMENT_TYPE_NODE) {
      # skip #
      print " "x$Self->{indent},"Skipping Document Type node...$/" if $Self->{debug};
    } elsif ($node_type == $COMMENT_NODE) {
      # skip #
      print " "x$Self->{indent},"Skipping Comment node...$/" if $Self->{debug};
    } else {
      print " "x$Self->{indent},"Cannot evaluate node of type $ref !$/" if $Self->{debug};
      warn ("evaluate-template: Dunno what to do with node of type $ref !!! ($current_xml_selection_path)$/") if $Self->{warnings};
    }

    $Self->{indent} -= $Self->{indent_incr};
  }

  print " "x$Self->{indent},"done!$/" if $Self->{debug};
  $Self->{indent} -= $Self->{indent_incr};
}

sub _add_node {
  my ($Self, $node, $parent, $deep, $owner) = @_;
  $deep ||= "";			# False #
  $owner ||= $Self->{xml};

  print " "x$Self->{indent},"adding node (deep)..$/" if $Self->{debug} && $deep;
  print " "x$Self->{indent},"adding node (non-deep)..$/" if $Self->{debug} && !$deep;

  $node = $node->cloneNode($deep);
  $node->setOwnerDocument($owner);
  if ($node->getNodeType == $ATTRIBUTE_NODE) {
    $parent->setAttributeNode($node);
  } else {
    $parent->appendChild($node);
  }
}

sub _apply_templates {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  my $children;
  my $newvariables = {()};
  
  my $select = $xsl_node->getAttribute ('select');
  
  if ($select =~ /\$/) {
    # replacing occurences of variables:
    foreach my $varname (keys (%$variables)) {
      $select =~ s/[^\\]\$$varname/$$variables{$varname}/g;
    }
  }
  
  if ($select) {
    print " "x$Self->{indent},"applying templates on children $select of \"$current_xml_selection_path\":$/" if $Self->{debug};
    $children = $Self->_get_node_set ($select, $Self->{xml},
					$current_xml_selection_path,
					$current_xml_node, $variables);
  } else {
    print " "x$Self->{indent},"applying templates on all children of \"$current_xml_selection_path\":$/" if $Self->{debug};
    my @children = $current_xml_node->getChildNodes;
    $children = \@children;
  }

  $Self->_process_with_params ($xsl_node, $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $variables, $oldvariables);

  # process xsl:sort here

  $Self->{indent} += $Self->{indent_incr};

  my $count = 1;
  foreach my $child (@$children) {
    my $node_type = $child->getNodeType;
    
    if ($node_type == $DOCUMENT_TYPE_NODE) {
      # skip #
      print " "x$Self->{indent},"Skipping Document Type node...$/" if $Self->{debug};
    } elsif ($node_type == $DOCUMENT_FRAGMENT_NODE) {
      # skip #
      print " "x$Self->{indent},"Skipping Document Fragment node...$/" if $Self->{debug};
    } elsif ($node_type == $NOTATION_NODE) {
      # skip #
      print " "x$Self->{indent},"Skipping Notation node...$/" if $Self->{debug};
    } else {

      my $newselect = "";
      my $newcount = $count;
      if (!$select || ($select eq '.')) {
	if ($node_type == $ELEMENT_NODE) {
	  $newselect = $child->getTagName;
	} elsif ($node_type == $ATTRIBUTE_NODE) {
	  $newselect = "@$child->getName";
	} elsif (($node_type == $TEXT_NODE) || ($node_type == $ENTITY_REFERENCE_NODE)) {
	  $newselect = "text()";
	} elsif ($node_type == $PROCESSING_INSTRUCTION_NODE) {
	  $newselect = "processing-instruction()";
	} elsif ($node_type == $COMMENT_NODE) {
	  $newselect = "comment()";
	} else {
	  my $ref = ref $child;
	  print " "x$Self->{indent},"Unknown node encountered: $ref$/" if $Self->{debug};
	}
      } else {
	$newselect = $select;
	if ($newselect =~ s/\[(\d+)\]$//) {
	  $newcount = $1;
	}
      }

      $Self->_select_template ($child, $newselect, $newcount,
				 $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $newvariables, $variables);
    }
    $count++;
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _for_each {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $select = $xsl_node->getAttribute ('select');
  
  if ($select =~ /\$/) {
    # replacing occurences of variables:
    foreach my $varname (keys (%$variables)) {
      $select =~ s/[^\\]\$$varname/$$variables{$varname}/g;
    }
  }
  
  if ($select) {
    print " "x$Self->{indent},"applying template for each child $select of \"$current_xml_selection_path\":$/" if $Self->{debug};
    my $children = $Self->_get_node_set ($select, $Self->{xml},
					   $current_xml_selection_path,
					   $current_xml_node, $variables);
    $Self->{indent} += $Self->{indent_incr};
    my $count = 1;
    foreach my $child (@$children) {
      my $node_type = $child->getNodeType;

      if ($node_type == $DOCUMENT_TYPE_NODE) {
	# skip #
	print " "x$Self->{indent},"Skipping Document Type node...$/" if $Self->{debug};
      } elsif ($node_type == $DOCUMENT_FRAGMENT_NODE) {
	# skip #
	print " "x$Self->{indent},"Skipping Document Fragment node...$/" if $Self->{debug};
      } elsif ($node_type == $NOTATION_NODE) {
	# skip #
	print " "x$Self->{indent},"Skipping Notation node...$/" if $Self->{debug};
      } else {

	$Self->_evaluate_template ($xsl_node, $child,
				     "$current_xml_selection_path/$select\[$count\]",
				     $current_result_node, $variables, $oldvariables);
      }
      $count++;
    }

    $Self->{indent} -= $Self->{indent_incr};
  } else {
    print " "x$Self->{indent},"expected attribute \"select\" in <$Self->{xsl_ns}for-each>$/" if $Self->{debug};
    warn "expected attribute \"select\" in <$Self->{xsl_ns}for-each>$/" if $Self->{warnings};
  }

}

sub _select_template {
  my ($Self, $child, $select, $count, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $ref = ref $child if $Self->{debug};
  print " "x$Self->{indent},"selecting template $select for child type $ref of \"$current_xml_selection_path\":$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  my $child_xml_selection_path = "$current_xml_selection_path/$select";
  my $template = $Self->_match_template ("match", $select, $count,
					   $child_xml_selection_path);

  if ($template) {

    $Self->_evaluate_template ($template,
				 $child,
				 "$child_xml_selection_path\[$count\]",
				 $current_result_node, $variables, $oldvariables);
  } else {
    print " "x$Self->{indent},"skipping template selection...$/" if $Self->{debug};
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _evaluate_element {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $xsl_tag = $xsl_node->getTagName;
  print " "x$Self->{indent},"evaluating element $xsl_tag from \"$current_xml_selection_path\": $/" if $Self->{debug};
  $Self->{indent} += $Self->{indent_incr};

  if ($xsl_tag =~ /^$Self->{xsl_ns}/i) {
    if ($xsl_tag =~ /^$Self->{xsl_ns}apply-templates$/i) {
      $Self->_apply_templates ($xsl_node, $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}attribute$/i) {
      $Self->_attribute ($xsl_node, $current_xml_node,
			   $current_xml_selection_path,
			   $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}call-template$/i) {
      $Self->_call_template ($xsl_node, $current_xml_node,
			       $current_xml_selection_path,
			       $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}choose$/i) {
      $Self->_choose ($xsl_node, $current_xml_node,
			$current_xml_selection_path,
			$current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}comment$/i) {
      $Self->_comment ($xsl_node, $current_xml_node,
			 $current_xml_selection_path,
			 $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}copy$/i) {
      $Self->_copy ($xsl_node, $current_xml_node,
		      $current_xml_selection_path,
		      $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}copy-of$/i) {
      $Self->_copy_of ($xsl_node, $current_xml_node,
			 $current_xml_selection_path,
			 $current_result_node, $variables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}for-each$/i) {
      $Self->_for_each ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}if$/i) {
      $Self->_if ($xsl_node, $current_xml_node,
		    $current_xml_selection_path,
		    $current_result_node, $variables, $oldvariables);

      #      } elsif ($xsl_tag =~ /^$Self->{xsl_ns}output$/i) {

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}param$/i) {
      $Self->_variable ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}processing-instruction$/i) {
      $Self->_processing_instruction ($xsl_node, $current_result_node);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}text$/i) {
      $Self->_text ($xsl_node, $current_result_node);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}value-of$/i) {
      $Self->_value_of ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables);

    } elsif ($xsl_tag =~ /^$Self->{xsl_ns}variable$/i) {
      $Self->_variable ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables, $oldvariables);

    } else {
      $Self->_add_and_recurse ($xsl_node, $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $variables, $oldvariables);
    }
  } else {

    $Self->_check_attributes_and_recurse ($xsl_node, $current_xml_node,
					    $current_xml_selection_path,
					    $current_result_node, $variables, $oldvariables);
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _add_and_recurse {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  # the addition is commented out to prevent unknown xsl: commands to be printed in the result
  #$Self->_add_node ($xsl_node, $current_result_node);
  $Self->_evaluate_template ($xsl_node, $current_xml_node,
			       $current_xml_selection_path,
			       $current_result_node, $variables, $oldvariables); #->getLastChild);
}

sub _check_attributes_and_recurse {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  $Self->_add_node ($xsl_node, $current_result_node);
  $Self->_attribute_value_of ($current_result_node->getLastChild,
				$current_xml_node,
				$current_xml_selection_path, $variables);
  $Self->_evaluate_template ($xsl_node, $current_xml_node,
			       $current_xml_selection_path,
			       $current_result_node->getLastChild, $variables, $oldvariables);
}

sub _value_of {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables) = @_;

  my $select = $xsl_node->getAttribute('select');
  my $xml_node;

  if ($select) {
  
    $xml_node = $Self->_get_node_set ($select, $Self->{xml},
					$current_xml_selection_path,
					$current_xml_node, $variables);

    print " "x$Self->{indent},"stripping node to text:$/" if $Self->{debug};

    $Self->{indent} += $Self->{indent_incr};
    my $text = "";
    $text = $Self->__string__ ($$xml_node[0]) if @$xml_node;
    $Self->{indent} -= $Self->{indent_incr};

    if ($text) {
      $Self->_add_node ($Self->{xml}->createTextNode($text), $current_result_node);
    } else {
      print " "x$Self->{indent},"nothing left..$/" if $Self->{debug};
    }
  } else {
    print " "x$Self->{indent},"expected attribute \"select\" in <$Self->{xsl_ns}value-of>$/" if $Self->{debug};
    warn "expected attribute \"select\" in <$Self->{xsl_ns}value-of>$/" if $Self->{warnings};
  }
}

sub __strip_node_to_text__ {
  my ($Self, $node) = @_;
    
  my $result = "";

  my $node_type = $node->getNodeType;
  if ($node_type == $TEXT_NODE) {
    $result = $node->getData;
  } elsif (($node_type == $ELEMENT_NODE)
	   || ($node_type == $DOCUMENT_FRAGMENT_NODE)) {
    $Self->{indent} += $Self->{indent_incr};
    foreach my $child ($node->getChildNodes) {
      $result .= &__strip_node_to_text__ ($Self, $child);
    }
    $Self->{indent} -= $Self->{indent_incr};
  }
  return $result;
}

sub __string__ {
  my ($Self, $node) = @_;
    
  my $result = "";

  if ($node) {
    my $ref = (ref ($node) || "ARRAY") if $Self->{debug};
    print " "x$Self->{indent},"stripping child nodes ($ref):$/" if $Self->{debug};

    $Self->{indent} += $Self->{indent_incr};

    if ($node eq "ARRAY") {
      return $Self->__string__ ($$node[0]);
    } else {
      my $node_type = $node->getNodeType;

      if (($node_type == $ELEMENT_NODE)
	  || ($node_type == $DOCUMENT_FRAGMENT_NODE)
	  || ($node_type == $DOCUMENT_NODE)) {
	foreach my $child ($node->getChildNodes) {
	  $result .= &__string__ ($Self, $child);
	}
      } elsif ($node_type == $ATTRIBUTE_NODE) {
	$result .= $node->getValue;
      } elsif (($node_type == $TEXT_NODE)
	       || ($node_type == $ENTITY_REFERENCE_NODE)) {
	$result .= $node->getData;
      }
    }

    print " "x$Self->{indent},"  \"$result\"$/" if $Self->{debug};
    $Self->{indent} -= $Self->{indent_incr};
  } else {
    print " "x$Self->{indent}," no result$/" if $Self->{debug};
  }
 
  return $result;
}

sub _move_node {
  my ($Self, $node, $parent) = @_;

  print " "x$Self->{indent},"moving node..$/" if $Self->{debug};

  $parent->appendChild($node);
}

sub _get_node_set {
  my ($Self, $path, $root_node, $current_path, $current_node, $variables,
      $silent) = @_;
  $current_path ||= "/";
  $current_node ||= $root_node;
  $silent ||= 0;
  
  print " "x$Self->{indent},"getting node-set \"$path\" from \"$current_path\":$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  # expand abbriviated syntax
  $path =~ s/\@/attribute\:\:/g;
  $path =~ s/\.\./parent\:\:node\(\)/g;
  $path =~ s/\./self\:\:node\(\)/g;
  $path =~ s/\/\//\/descendant\-or\-self\:\:node\(\)\//g;
  #$path =~ s/\/[^\:\/]*?\//attribute::/g;
    
  if ($path =~ /^\$([\w\.\-]+)$/) {
    my $varname = $1;
    my $var = $$variables{$varname};
    if ($var) {
      if (ref ($$variables{$varname}) eq 'ARRAY') {
	# node-set array-ref
	return $$variables{$varname};
      } elsif (ref ($$variables{$varname}) eq 'XML::DOM::NodeList') {
	# node-set nodelist
	return [@{$$variables{$varname}}];
      } elsif (ref ($$variables{$varname}) eq 'XML::DOM::DocumentFragment') {
	# node-set documentfragment
	return [$$variables{$varname}->getChildNodes];
      } else {
	# string or number?
	return [$Self->{xml}->createTextNode ($$variables{$varname})];
      }
    } else {
      # var does not exist
      return [];
    }
  } elsif ($path eq $current_path || $path eq 'self::node()') {
    print " "x$Self->{indent},"direct hit!$/" if $Self->{debug};
    return [$current_node];
  } else {
    # open external documents first #
    if ($path =~ /^\s*document\s*\(["'](.*?)["']\s*(,\s*(.*)\s*){0,1}\)\s*(.*)$/i) {
      my $filename = $1;
      my $sec_arg = $3;
      $path = ($4 || "");

      print " "x$Self->{indent},"external selection (\"$filename\")!$/" if $Self->{debug};

      if ($sec_arg) {
	print " "x$Self->{indent}," Ignoring second argument of $path$/" if $Self->{debug};
	warn "Ignoring second argument of $path$/" if $Self->{warnings} && !$silent;
      }

      ($root_node) = $Self->_open_by_filename ($Self, $filename, $Self->{xsl_dir});
    }

    if ($path =~ /^\//) {
      # start from the root #
      $current_node = $root_node;
    } elsif ($path =~ /^self\:\:node\(\)\//) { #'#"#'#"
      # remove preceding dot from './etc', which is expanded to 'self::node()'
      # at the top of this subroutine #
      $path =~ s/^self\:\:node\(\)//;
    } else {
      # to facilitate parsing, precede path with a '/' #
      $path = "/$path";
    }

    print " "x$Self->{indent},"using \"$path\": $/" if $Self->{debug};

    if ($path eq '/') {
      $current_node = [$current_node];
    } else {
      $current_node = &__get_node_set__ ($Self, $path, [$current_node], $silent);
    }

    $Self->{indent} -= $Self->{indent_incr};
    
    return $current_node;
  }
}


# auxiliary function #
sub __get_node_set__ {
  my ($Self, $path, $node, $silent) = @_;

  # a Qname (?) should actually be: [a-Z_][\w\.\-]*\:[a-Z_][\w\.\-]*

  if ($path eq "") {

    print " "x$Self->{indent},"node found!$/" if $Self->{debug};
    return $node;

  } else {
    my $list = [];
    foreach my $item (@$node) {
      my $sublist = &__try_a_step__ ($Self, $path, $item, $silent);
      push (@$list, @$sublist);
    }
    return $list;
  }
}

sub __try_a_step__ {
  my ($Self, $path, $node, $silent) = @_;

  study ($path);
  if ($path =~ s/^\/parent\:\:node\(\)//) {
    # /.. #
    print " "x$Self->{indent},"getting parent (\"$path\")$/" if $Self->{debug};
    return &__parent__ ($Self, $path, $node, $silent);

  } elsif ($path =~ s/^\/attribute\:\:(\*|[\w\.\:\-]+)//) {
    # /@attr #
    print " "x$Self->{indent},"getting attribute $1 (\"$path\")$/" if $Self->{debug};
    return &__attribute__ ($Self, $1, $path, $node, $silent);

  } elsif ($path =~ s/^\/descendant\-or\-self\:\:node\(\)\/(child\:\:|)(\*|[\w\.\:\-]+)\[(\S+?)\]//) {
    # //elem[n] #
    print " "x$Self->{indent},"getting deep indexed element $1 $2 (\"$path\")$/" if $Self->{debug};
    return &__indexed_element__ ($Self, $1, $2, $path, $node, $silent, "deep");

  } elsif ($path =~ s/^\/descendant\-or\-self\:\:node\(\)\/(\*|[\w\.\:\-]+)//) {
    # //elem #
    print " "x$Self->{indent},"getting deep element $1 (\"$path\")$/" if $Self->{debug};
    return &__element__ ($Self, $1, $path, $node, $silent, "deep");

  } elsif ($path =~ s/^\/(child\:\:|)(\*|[\w\.\:\-]+)\[(\S+?)\]//) {
    # /elem[n] #
    print " "x$Self->{indent},"getting indexed element $2 $3 (\"$path\")$/" if $Self->{debug};
    return &__indexed_element__ ($Self, $2, $3, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)(\*|[\w\.\:\-]+)//) {
    # /elem #
    print " "x$Self->{indent},"getting element $2 (\"$path\")$/" if $Self->{debug};
    return &__element__ ($Self, $2, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)text\(\)//) {
    # /text() #
    print " "x$Self->{indent},"getting text (\"$path\")$/" if $Self->{debug};
    return &__get_nodes__ ($Self, $TEXT_NODE, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)processing-instruction\(\)//) {
    # /processing-instruction() #
    print " "x$Self->{indent},"getting processing instruction (\"$path\")$/" if $Self->{debug};
    return &__get_nodes__ ($Self, $PROCESSING_INSTRUCTION_NODE, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)comment\(\)//) {
    # /comment() #
    print " "x$Self->{indent},"getting comment (\"$path\")$/" if $Self->{debug};
    return &__get_nodes__ ($Self, $COMMENT_NODE, $path, $node, $silent);

  } else {
    print " "x$Self->{indent},"dunno what to do with path $path !!!$/" if $Self->{debug};
    warn ("get-node-from-path: Dunno what to do with path $path !!!$/") if $Self->{warnings} && !$silent;
    return [];
  }
}

sub __parent__ {
  my ($Self, $path, $node, $silent) = @_;

  $Self->{indent} += $Self->{indent_incr};
  if (($node->getNodeType == $DOCUMENT_NODE)
      || ($node->getNodeType == $DOCUMENT_FRAGMENT_NODE)) {
    print " "x$Self->{indent},"no parent!$/" if $Self->{debug};
    $node = [];
  } else {
    $node = $node->getParentNode;

    $node = &__get_node_set__ ($Self, $path, [$node], $silent);
  }
  $Self->{indent} -= $Self->{indent_incr};

  return $node;
}

sub __indexed_element__ {
  my ($Self, $element, $index, $path, $node, $silent, $deep) = @_;
  $index ||= 0;
  $deep ||= "";			# False #

  if ($index =~ /^first\s*\(\)/i) {
    $index = 0;
  } elsif ($index =~ /^last\s*\(\)/i) {
    $index = -1;
  } else {
    $index--;
  }

  my @list = $node->getElementsByTagName($element, $deep);
        
  if (@list) {
    $node = $list[$index];
  } else {
    $node = "";
  }

  $Self->{indent} += $Self->{indent_incr};
  if ($node) {
    $node = &__get_node_set__ ($Self, $path, [$node], $silent);
  } else {
    print " "x$Self->{indent},"failed!$/" if $Self->{debug};
    $node = [];
  }
  $Self->{indent} -= $Self->{indent_incr};

  return $node;
}

sub __element__ {
  my ($Self, $element, $path, $node, $silent, $deep) = @_;
  $deep ||= "";			# False #

  $node = [$node->getElementsByTagName($element, $deep)];

  $Self->{indent} += $Self->{indent_incr};
  if (@$node) {
    $node = &__get_node_set__($Self, $path, $node, $silent);
  } else {
    print " "x$Self->{indent},"failed!$/" if $Self->{debug};
  }
  $Self->{indent} -= $Self->{indent_incr};

  return $node;
}

sub __attribute__ {
  my ($Self, $attribute, $path, $node, $silent) = @_;

  if ($attribute eq '*') {
    $node = [$node->getAttributes->getValues];
        
    $Self->{indent} += $Self->{indent_incr};
    if ($node) {
      $node = &__get_node_set__ ($Self, $path, $node, $silent);
    } else {
      print " "x$Self->{indent},"failed!$/" if $Self->{debug};
    }
    $Self->{indent} -= $Self->{indent_incr};
  } else {
    $node = $node->getAttributeNode($attribute);
        
    $Self->{indent} += $Self->{indent_incr};
    if ($node) {
      $node = &__get_node_set__ ($Self, $path, [$node], $silent);
    } else {
      print " "x$Self->{indent},"failed!$/" if $Self->{debug};
      $node = [];
    }
    $Self->{indent} -= $Self->{indent_incr};
  }

  return $node;
}

sub __get_nodes__ {
  my ($Self, $node_type, $path, $node, $silent) = @_;

  my $result = [];

  $Self->{indent} += $Self->{indent_incr};
  foreach my $child ($node->getChildNodes) {
    if ($child->getNodeType == $node_type) {
      $result = [@$result, &__get_node_set__ ($Self, $path, [$child], $silent)];
    }
  }
  $Self->{indent} -= $Self->{indent_incr};
	
  if (! @$result) {
    print " "x$Self->{indent},"failed!$/" if $Self->{debug};
  }
        
  return $result;
}


sub _attribute_value_of {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $variables) = @_;

  foreach my $attribute ($xsl_node->getAttributes->getValues) {
    my $value = $attribute->getValue;
    study ($value);
    #$value =~ s/(\*|\$|\@|\&|\?|\+|\\)/\\$1/g;
    $value =~ s/(\*|\?|\+)/\\$1/g;
    study ($value);
    while ($value =~ /\G[^\\]?\{(.*?[^\\]?)\}/) {
      my $node = $Self->_get_node_set ($1, $Self->{xml},
					 $current_xml_selection_path,
					 $current_xml_node, $variables);
      if (@$node) {
	$Self->{indent} += $Self->{indent_incr};
	my $text = $Self->__string__ ($$node[0]);
	$Self->{indent} -= $Self->{indent_incr};
	$value =~ s/(\G[^\\]?)\{(.*?)[^\\]?\}/$1$text/;
      } else {
	$value =~ s/(\G[^\\]?)\{(.*?)[^\\]?\}/$1/;
      }
    }
    #$value =~ s/\\(\*|\$|\@|\&|\?|\+|\\)/$1/g;
    $value =~ s/\\(\*|\?|\+)/$1/g;
    $value =~ s/\\(\{|\})/$1/g;
    $attribute->setValue ($value);
  }
}

sub _processing_instruction {
  my ($Self, $xsl_node, $current_result_node, $variables, $oldvariables) = @_;

  my $new_PI_name = $xsl_node->getAttribute('name');

  if ($new_PI_name eq "xml") {
    print " "x$Self->{indent},"<$Self->{xsl_ns}processing-instruction> may not be used to create XML$/" if $Self->{debug};
    print " "x$Self->{indent},"declaration. Use <$Self->{xsl_ns}output> instead...$/" if $Self->{debug};
    warn "<$Self->{xsl_ns}processing-instruction> may not be used to create XML$/" if $Self->{warnings};
    warn "declaration. Use <$Self->{xsl_ns}output> instead...$/" if $Self->{warnings};
  } elsif ($new_PI_name) {
    my $text = $Self->__string__ ($xsl_node);
    my $new_PI = $Self->{xml}->createProcessingInstruction($new_PI_name, $text);

    if ($new_PI) {
      $Self->_move_node ($new_PI, $current_result_node);
    }
  } else {
    print " "x$Self->{indent},"expected attribute \"name\" in <$Self->{xsl_ns}processing-instruction> !$/" if $Self->{debug};
    warn "Expected attribute \"name\" in <$Self->{xsl_ns}processing-instruction> !$/" if $Self->{warnings};
  }
}

sub _process_with_params {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $variables, $oldvariables) = @_;

  my @params = $xsl_node->getElementsByTagName("$Self->{xsl_ns}with-param");
  foreach my $param (@params) {
    my $varname = $param->getAttribute('name');

    if ($varname) {
      if ($$oldvariables{$varname}) {
	$$variables{$varname} = $$oldvariables{$varname};
      } else {
	my $value = $param->getAttribute('select');
        
	if (!$value) {
	  # process content as template
	  my $result = $Self->{xml}->createDocumentFragment;

	  $Self->_evaluate_template ($param,
				       $current_xml_node,
				       $current_xml_selection_path,
				       $result, $variables, $oldvariables);

	  $Self->{indent} += $Self->{indent_incr};
	  $value = $Self->__string__ ($result);
	  $Self->{indent} -= $Self->{indent_incr};

	  $result->dispose();
	}
        
	$$variables{$varname} = $value;
      }
    } else {
      print " "x$Self->{indent},"expected attribute \"name\" in <$Self->{xsl_ns}with-param> !$/" if $Self->{debug};
      warn "Expected attribute \"name\" in <$Self->{xsl_ns}with-param> !$/" if $Self->{warnings};
    }

  }

}

sub _call_template {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $newvariables = {()};

  my $name = $xsl_node->getAttribute('name');
  
  if ($name) {
    print " "x$Self->{indent},"calling template named \"$name\"$/" if $Self->{debug};

    $Self->_process_with_params ($xsl_node, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);

    $Self->{indent} += $Self->{indent_incr};
    my $template = $Self->_match_template ("name", $name, 0, '');

    if ($template) {
      $Self->_evaluate_template ($template, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);
    } else {
      print " "x$Self->{indent},"no template found!$/" if $Self->{debug};
      warn "no template named $name found!$/" if $Self->{warnings};
    }
    $Self->{indent} -= $Self->{indent_incr};
  } else {
    print " "x$Self->{indent},"expected attribute \"name\" in <$Self->{xsl_ns}call-template/>$/" if $Self->{debug};
    warn "Expected attribute \"name\" in <$Self->{xsl_ns}call-template/>$/" if $Self->{warnings};
  }
}

sub _choose {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  print " "x$Self->{indent},"evaluating choose:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  my $notdone = "true";
  my $testwhen = "active";
  foreach my $child ($xsl_node->getElementsByTagName ('*', 0)) {
    if ($notdone && $testwhen && ($child->getTagName eq "$Self->{xsl_ns}when")) {
      my $test = $child->getAttribute ('test');

      if ($test) {
	my $test_succeeds = $Self->_evaluate_test ($test, $current_xml_node,
						     $current_xml_selection_path,
						     $variables);
	if ($test_succeeds) {
	  $Self->_evaluate_template ($child, $current_xml_node,
				       $current_xml_selection_path,
				       $current_result_node, $variables, $oldvariables);
	  $testwhen = "";
	  $notdone = "";
	}
      } else {
	print " "x$Self->{indent},"expected attribute \"test\" in <$Self->{xsl_ns}when>$/" if $Self->{debug};
	warn "expected attribute \"test\" in <$Self->{xsl_ns}when>$/" if $Self->{warnings};
      }
    } elsif ($notdone && ($child->getTagName eq "$Self->{xsl_ns}otherwise")) {
      $Self->_evaluate_template ($child, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);
      $notdone = "";
    }
  }
  
  if ($notdone) {
    print " "x$Self->{indent},"nothing done!$/" if $Self->{debug};
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _if {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  print " "x$Self->{indent},"evaluating if:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  my $test = $xsl_node->getAttribute ('test');

  if ($test) {
    my $test_succeeds = $Self->_evaluate_test ($test, $current_xml_node,
						 $current_xml_selection_path,
						 $variables);
    if ($test_succeeds) {
      $Self->_evaluate_template ($xsl_node, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);
    }
  } else {
    print " "x$Self->{indent},"expected attribute \"test\" in <$Self->{xsl_ns}if>$/" if $Self->{debug};
    warn "expected attribute \"test\" in <$Self->{xsl_ns}if>$/" if $Self->{warnings};
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _evaluate_test {
  my ($Self, $test, $current_xml_node, $current_xml_selection_path,
      $variables) = @_;

  if ($test =~ /^(.+)\/\[(.+)\]$/) {
    my $path = $1;
    $test = $2;
    
    print " "x$Self->{indent},"evaluating test $test at path $path:$/" if $Self->{debug};

    $Self->{indent} += $Self->{indent_incr};
    my $node = $Self->_get_node_set ($path, $Self->{xml},
				       $current_xml_selection_path,
				       $current_xml_node, $variables);
    if (@$node) {
      $current_xml_node = $$node[0];
    } else {
      return "";
    }
    $Self->{indent} -= $Self->{indent_incr};
  } else {
    print " "x$Self->{indent},"evaluating path or test $test:$/" if $Self->{debug};
    my $node = $Self->_get_node_set ($test, $Self->{xml},
				       $current_xml_selection_path,
				       $current_xml_node, $variables, "silent");
    $Self->{indent} += $Self->{indent_incr};
    if (@$node) {
      print " "x$Self->{indent},"path exists!$/" if $Self->{debug};
      return "true";
    } else {
      print " "x$Self->{indent},"not a valid path, evaluating as test$/" if $Self->{debug};
    }
    $Self->{indent} -= $Self->{indent_incr};
  }

  $Self->{indent} += $Self->{indent_incr};
  my $result = &__evaluate_test__ ($test, $current_xml_node);
  if ($result) {
    print " "x$Self->{indent},"test evaluates true..$/" if $Self->{debug};
  } else {
    print " "x$Self->{indent},"test evaluates false..$/" if $Self->{debug};
  }
  $Self->{indent} -= $Self->{indent_incr};
  return $result;
}

sub __evaluate_test__ {
  my ($test, $node) = @_;

  #print "testing with \"$test\" and ", ref $node,$/;
  if ($test =~ /^\s*\@([\w\.\:\-]+)\s*!=\s*['"](.*)['"]\s*$/) {
    my $attr = $node->getAttribute($1);
    return ($attr ne $2);
  } elsif ($test =~ /^\s*\@([\w\.\:\-]+)\s*=\s*['"](.*)['"]\s*$/) {
    my $attr = $node->getAttribute($1);
    return ($attr eq $2);
  } elsif ($test =~ /^\s*([\w\.\:\-]+)\s*!=\s*['"](.*)['"]\s*$/) {
    $node->normalize;
    my $content = $node->getFirstChild->getValue;
    return ($content !~ /$2/m);
  } elsif ($test =~ /^\s*([\w\.\:\-]+)\s*=\s*['"](.*)['"]\s*$/) {
    $node->normalize;
    my $content = $node->getFirstChild->getValue;
    return ($content =~ /^\s*$2\s*/m);
  } else {
    return "";
  }
}

sub _copy_of {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables) = @_;

  my $nodelist;
  my $select = $xsl_node->getAttribute('select');
  print " "x$Self->{indent},"evaluating copy-of with select \"$select\":$/" if $Self->{debug};
  
  $Self->{indent} += $Self->{indent_incr};
  if ($select) {
    $nodelist = $Self->_get_node_set ($select, $Self->{xml},
					$current_xml_selection_path,
					$current_xml_node, $variables);
  } else {
    print " "x$Self->{indent},"expected attribute \"select\" in <$Self->{xsl_ns}copy-of>$/" if $Self->{debug};
    warn "expected attribute \"select\" in <$Self->{xsl_ns}copy-of>$/" if $Self->{warnings};
  }
  foreach my $node (@$nodelist) {
    $Self->_add_node ($node, $current_result_node, "deep");
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _copy {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;


  print " "x$Self->{indent},"evaluating copy:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};
  if ($current_xml_node->getNodeType == $ATTRIBUTE_NODE) {
    my $attribute = $current_xml_node->cloneNode(0);
    $current_result_node->setAttributeNode($attribute);
  } elsif (($current_xml_node->getNodeType == $COMMENT_NODE)
	   || ($current_xml_node->getNodeType == $PROCESSING_INSTRUCTION_NODE)) {
    $Self->_add_node ($current_xml_node, $current_result_node);
  } else {
    $Self->_add_node ($current_xml_node, $current_result_node);
    $Self->_evaluate_template ($xsl_node,
				 $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node->getLastChild,
				 $variables, $oldvariables);
  }
  $Self->{indent} -= $Self->{indent_incr};
}

sub _text {
  #=item addText (text)
  #
  #Appends the specified string to the last child if it is a Text node, or else 
  #appends a new Text node (with the specified text.)
  #
  #Return Value: the last child if it was a Text node or else the new Text node.
  my ($Self, $xsl_node, $current_result_node) = @_;

  print " "x$Self->{indent},"inserting text:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  print " "x$Self->{indent},"stripping node to text:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};
  my $text = $Self->__string__ ($xsl_node);
  $Self->{indent} -= $Self->{indent_incr};

  if ($text) {
    $Self->_move_node ($Self->{xml}->createTextNode ($text), $current_result_node);
  } else {
    print " "x$Self->{indent},"nothing left..$/" if $Self->{debug};
  }

  $Self->{indent} -= $Self->{indent_incr};
}

sub _attribute {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  
  my $name = $xsl_node->getAttribute ('name');
  print " "x$Self->{indent},"inserting attribute named \"$name\":$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};
  if ($name) {
    my $result = $Self->{xml}->createDocumentFragment;

    $Self->_evaluate_template ($xsl_node,
				 $current_xml_node,
				 $current_xml_selection_path,
				 $result, $variables, $oldvariables);

    $Self->{indent} += $Self->{indent_incr};
    my $text = $Self->__string__ ($result);
    $Self->{indent} -= $Self->{indent_incr};

    $current_result_node->setAttribute($name, $text);
    $result->dispose();
  } else {
    print " "x$Self->{indent},"expected attribute \"name\" in <$Self->{xsl_ns}attribute>$/" if $Self->{debug};
    warn "expected attribute \"name\" in <$Self->{xsl_ns}attribute>$/" if $Self->{warnings};
  }
  $Self->{indent} -= $Self->{indent_incr};
}

sub _comment {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  
  print " "x$Self->{indent},"inserting comment:$/" if $Self->{debug};

  $Self->{indent} += $Self->{indent_incr};

  my $result = $Self->{xml}->createDocumentFragment;

  $Self->_evaluate_template ($xsl_node,
			       $current_xml_node,
			       $current_xml_selection_path,
			       $result, $variables, $oldvariables);

  $Self->{indent} += $Self->{indent_incr};
  my $text = $Self->__string__ ($result);
  $Self->{indent} -= $Self->{indent_incr};

  $Self->_move_node ($Self->{xml}->createComment ($text), $current_result_node);
  $result->dispose();

  $Self->{indent} -= $Self->{indent_incr};
}

sub _variable {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  
  my $varname = $xsl_node->getAttribute ('name');
  
  if ($varname) {
    print " "x$Self->{indent},"definition of variable \$$varname:$/" if $Self->{debug};

    $Self->{indent} += $Self->{indent_incr};

    if ($$oldvariables{$varname}) {
      # copy from parent-template
        
      $$variables{$varname} = $$oldvariables{$varname};
        
    } else {
      # new variable definition
        
      my $value = $xsl_node->getAttribute ('select');

      if (! $value) {
	#tough case, evaluate content as template

	$value = $Self->{xml}->createDocumentFragment;

	$Self->_evaluate_template ($xsl_node,
				     $current_xml_node,
				     $current_xml_selection_path,
				     $value, $variables, $oldvariables);
      }
        
      $$variables{$varname} = $value;
    }

    $Self->{indent} -= $Self->{indent_incr};
  } else {
    print " "x$Self->{indent},"expected attribute \"name\" in <$Self->{xsl_ns}param> or <$Self->{xsl_ns}variable>$/" if $Self->{debug};
    warn "expected attribute \"name\" in <$Self->{xsl_ns}param> or <$Self->{xsl_ns}variable>$/" if $Self->{warnings};
  }
}

1;

__END__


=head1 NAME

XML::XSLT - A perl module for processing XSLT

=head1 SYNOPSIS

 use XML::XSLT;

 my $xslt = XML::XSLT->new ($xsl, warnings => 1);

 $xslt->transform ($xmlfile)
 print $xslt->asString

 $xslt->dispose ();

=head1 DESCRIPTION

This module implements the W3C's XSLT specification. The goal is full
implementation of this spec, but we have not yet achieved
that. However, it already works well.  See L<XML::XSLT Commands> for
the current status of each command.

XML::XSLT makes use of XML::DOM and LWP::UserAgent, while XML::DOM
uses XML::Parser.  Therefore XML::Parser, XML::DOM and LWP::UserAgent
have to be installed properly for XML::XSLT to run.

=head1 Specifying Sources

The stylesheets and the documents may be passed as filenames, file
handles regular strings, string references or DOM-trees.  Functions
that require sources (e.g. new), will accept either a named parameter
or simply the argument.

Either of the following are allowed:

 my $xslt = XML::XSLT->new($xsl);
 my $xslt = XML::XSLT->new(Source => $xsl);

In documentation, the named parameter `Source' is always shown, but it
is never required.

=head1 METHODS

=head2 new(Source => $xml [, %args])

Returns a new XSLT parser object.  Valid flags are:

=over 4

=item DOMparser_args

Hashref of arguments to pass to the XML::DOM::Parser object's parse
method.

=item debug

Turn on debugging messages.

=item warnings

Turn on warning messages.

=item variables

Hashref of variables and their values for the stylesheet.

=item indent

Starting amount of indention.  Defaults to 0.

=item indent_incr

Amount to indent each level.  Defaults to 1.

=back

=head2 open_xml(Source => $xml [, %args])

Gives the XSLT object new XML to process.  Returns an XML::DOM object
corresponding to the XML.  Any arguments present are passed to the
XML::DOM::Parser.

=head2 open_xsl(Source => $xml [, %args])

Gives the XSLT object a new stylesheet to use in processing XML.
Returns an XML::DOM object corresponding to the stylesheet.  Any
arguments present are passed to the XML::DOM::Parser.

=head2 process(%variables)

Processes the previously loaded XML through the stylesheet using the
variables set in the argument.

=head2 transform(Source => $xml [, %args])

Processes the given XML through the stylesheet.  Returns an XML::DOM
object corresponding to the transformed XML.  Any arguments present
are passed to the XML::DOM::Parser.

=head2 Server(Source => $xml [, %args])

Processes the given XML through the stylesheet.  Returns a string
containg the result.  Example:

  use XML::XSLT qw(Server);

  $xslt = XML::XSLT->new($xsl);
  print $xslt->Server $xml;

=over 4

=item http_headers

If true, then prints the appropriate HTTP headers (e.g. Content-Type,
Content-Length);

Defaults to true.

=item xml_declaration

If true, then prints the appropriate <?xml?> header.

Defaults to true.

=item xml_version

The version of the XML.

Defaults to 1.0.

=item doctype

The type of DOCTYPE this document is.  Defaults to SYSTEM.

=back

=head2 toString

Returns the result of transforming the XML with the stylesheet as a
string.

=head2 to_dom

Returns the result of transforming the XML with the stylesheet as an
XML::DOM object.

=head2 media_type

Returns the media type (aka mime type) of the object.

=head2 dispose

Executes the C<dispose> method on each XML::DOM object.

=head1 XML::XSLT Commands

=head2 xsl:apply-imports		no

Not supported yet.

=head2 xsl:apply-templates		limited

Attribute 'select' is supported to the same extent as xsl:value-of
supports path selections.

Not supported yet:
- attribute 'mode'
- xsl:sort and xsl:with-param in content

=head2 xsl:attribute			partially

Adds an attribute named to the value of the attribute 'name' and as value
the stringified content-template.

Not supported yet:
- attribute 'namespace'

=head2 xsl:attribute-set		no

Not supported yet.

=head2 xsl:call-template		yes

Takes attribute 'name' which selects xsl:template's by name.

Not supported yet:
- xsl:sort and xsl:with-param in content

=head2 xsl:choose			yes

Tests sequentially all xsl:whens until one succeeds or
until an xsl:otherwise is found. Limited test support, see xsl:when

=head2 xsl:comment			yes

Supported.

=head2 xsl:copy				partially

Not supported yet:
- attribute 'use-attribute-sets'

=head2 xsl:copy-of			limited

Attribute 'select' functions as well as with
xsl:value-of

=head2 xsl:decimal-format		no

Not supported yet.

=head2 xsl:element			no

Not supported yet.

=head2 xsl:fallback			no

Not supported yet.

=head2 xsl:for-each			limited

Attribute 'select' functions as well as with
xsl:value-of

Not supported yet:
- xsl:sort in content

=head2 xsl:if				limited

Identical to xsl:when, but outside xsl:choose context.

=head2 xsl:import			no

Not supported yet.

=head2 xsl:include			yes

Takes attribute href, which can be relative-local, 
absolute-local as well as an URL (preceded by
identifier http:).

=head2 xsl:key				no

Not supported yet.

=head2 xsl:message			no

Not supported yet.

=head2 xsl:namespace-alias		no

Not supported yet.

=head2 xsl:number			no

Not supported yet.

=head2 xsl:otherwise			yes

Supported.

=head2 xsl:output			no

Not supported yet.

=head2 xsl:param			experimental

Synonym for xsl:variable (currently). See xsl:variable for support.

=head2 xsl:preserve-space		no

Not supported yet. Whitespace is always preserved.

=head2 xsl:processing-instruction	yes

Supported.

=head2 xsl:sort				no

Not supported yet.

=head2 xsl:strip-space			no

Not supported yet. No whitespace is stripped.

=head2 xsl:stylesheet			limited

Minor namespace support: other namespace than 'xsl:' for xsl-commands
is allowed if xmlns-attribute is present. xmlns URL is verified.
Other attributes are ignored.

=head2 xsl:template			limited

Attribute 'name' and 'match' are supported to minor extend.
('name' must match exactly and 'match' must match with full
path or no path)

Not supported yet:
- attributes 'priority' and 'mode'

=head2 xsl:text				partially

Not supported yet:
- attribute 'disable-output-escaping'

=head2 xsl:transform			limited

Synonym for xsl:stylesheet

=head2 xsl:value-of			limited

Inserts attribute or element values. Limited support:

<xsl:value-of select="."/>

<xsl:value-of select="/root-elem"/>

<xsl:value-of select="elem"/>

<xsl:value-of select="//elem"/>

<xsl:value-of select="elem[n]"/>

<xsl:value-of select="//elem[n]"/>

<xsl:value-of select="@attr"/>

<xsl:value-of select="text()"/>

<xsl:value-of select="processing-instruction()"/>

<xsl:value-of select="comment()"/>

and combinations of these;

Not supported yet:
- attribute 'disable-output-escaping'

=head2 xsl:variable			experimental

Very limited. It should be possible to define a variable and use it with
&lt;xsl:value select="$varname" /&gt; within the same template.

=head2 xsl:when				limited

Only inside xsl:choose. Limited test support:

<xsl:when test="@attr='value'">

<xsl:when test="elem='value'">

<xsl:when test="path/[@attr='value']">

<xsl:when test="path/[elem='value']">

<xsl:when test="path">

path is supported to the same extend as with xsl:value-of

=head2 xsl:with-param			experimental

It is currently not functioning. (or is it?)

=head1 SUPPORT

General information, bug reporting tools, the latest version, mailing
lists, etc. can be found at the XML::XSLT homepage:

  http://xmlxslt.sourceforge.net/

=head1 DEPRECATIONS

Methods and interfaces from previous versions that are not documented in this
version are deprecated.  Each of these deprecations can still be used
but will produce a warning when the deprecation is first used.  You
can use the old interfaces without warnings by passing C<new()> the
flag C<use_deprecated>.  Example:

 $parser = XML::XSLT->new($xsl, "FILE",
                          use_deprecated => 1);

The deprecations will disappear by the time a 1.0 release is made.

=head1 BUGS

Yes.

=head1 HISTORY

Geert Josten and Egon Willighagen developed and maintained XML::XSLT
up to version 0.22.  At that point, Mark Hershberger started moving
the project to Sourceforge and began working on it with Bron Gondwana.

=head1 LICENCE

Copyright (c) 1999 Geert Josten & Egon Willighagen. All Rights
Reserverd.  This module is free software, and may be distributed under
the same terms and conditions as Perl.

=head1 AUTHORS

Geert Josten <gjosten@sci.kun.nl>,
Egon Willighagen <egonw@catv6142.extern.kun.nl>,
Mark A. Hershberger <mah@everybody.org>
Bron Gondwana <perlcode@brong.net>,

=head1 SEE ALSO

L<XML::DOM>

=cut
