################################################################################
#
# Perl module: XML::XSLT
#
# By Geert Josten, gjosten@sci.kun.nl
# and Egon Willighagen, egonw@sci.kun.nl
#
# $Id: XSLT.pm,v 1.11 2000/07/13 23:18:07 hexmode Exp $
#
################################################################################

######################################################################
package XML::XSLT;
######################################################################

use strict;

use XML::DOM 1.25;
use LWP::Simple qw(get);
use URI;
use Cwd;
use File::Basename qw(dirname);
use Carp;

# Namespace constants
use constant NS_XSLT         => 'http://www.w3.org/1999/XSL/Transform';
use constant NS_XHTML        => 'http://www.w3.org/TR/xhtml1/strict';

# Offsets into the blessed arrayref
use constant DEBUG             => 0;
use constant PARSER            => 1;
use constant PARSER_ARGS       => 2;
use constant VARIABLES         => 3;
use constant WARNINGS          => 4;
use constant INDENT            => 5;
use constant INDENT_INCR       => 6;
use constant USE_DEPRECATED    => 7;
use constant XML_DOCUMENT      => 8;
use constant XSL_DOCUMENT      => 9;
use constant XML_PASSED_AS_DOM => 10;
use constant XSL_PASSED_AS_DOM => 11;
use constant RESULT_DOCUMENT   => 12;
use constant TOP_XSL_NODE      => 13;
use constant NAMESPACE         => 14;
use constant XSL_NS            => 15;
use constant TEMPLATE          => 16;
use constant TEMPLATE_MATCH    => 17;
use constant TEMPLATE_NAME     => 18;
use constant DOCTYPE_PUBLIC    => 19;
use constant DOCTYPE_SYSTEM    => 20;
use constant METHOD            => 21;
use constant MEDIA_TYPE        => 22;
use constant OMIT_XML_DECL     => 23;
use constant OUTPUT_VERSION    => 24;
use constant OUTPUT_ENCODING   => 25;
use constant BASENAME          => 26;
use constant DEFAULT_NS        => 27;

use vars qw ( $VERSION @ISA @EXPORT_OK $AUTOLOAD );

BEGIN {

  $VERSION = '0.30';

  @ISA         = qw( Exporter );
  @EXPORT_OK   = qw( &transform &Server );

  # pretty print HTML tags (<BR /> etc...)
  XML::DOM::setTagCompression (\&__my_tag_compression);
}

my %deprecation_used;


######################################################################
# PUBLIC DEFINITIONS

sub new {
  my $class = shift;
  my $Self = bless [], $class;
  my %args = $Self->__parse_args(@_);

  $Self->[DEBUG] = defined $args{debug} ? $args{debug} : "";
  $Self->[PARSER]      = XML::DOM::Parser->new;
  $Self->[PARSER_ARGS] = defined $args{DOMparser_args}
    ? $args{DOMparser_args} : {};
  $Self->[VARIABLES]       = defined $args{variables}
    ? $args{variables}      : {};
  $Self->[WARNINGS]        = defined $args{warnings}
    ? $args{warnings}       : 0;
  $Self->[INDENT]          = defined $args{indent}
    ? $args{indent}         : 0;
  $Self->[INDENT_INCR]     = defined $args{indent_incr}
    ? $args{indent_incr}    : 1;
  $Self->[BASENAME]        = defined $args{base}
    ? $args{base}    : 'file://' . cwd . '/';
  $Self->[USE_DEPRECATED]  = defined $args{use_deprecated}
    ? $args{use_deprecated} : 0;

  $Self->debug("creating parser object:");

  $Self->[INDENT] += $Self->[INDENT_INCR];
  $Self->open_xsl(%args);
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  return $Self;
}

sub DESTROY {}			# Cuts out random dies on includes

sub debug {
  my $Self = shift;
  my $arg = shift || "";

  print STDERR " "x$Self->[INDENT],"$arg$/"
    if $Self->[DEBUG];
}

sub warn {
  my $Self = shift;
  my $arg = shift || "";

  print STDERR " "x$Self->[INDENT],"$arg$/"
    if $Self->[DEBUG];
  print STDERR "$arg$/"
    if $Self->[WARNINGS] || ! $Self->[DEBUG];
}

sub open_xml {
  my $Self = shift;
  my $class = ref $Self || croak "Not a method call";
  my %args = $Self->__parse_args(@_);

  if(defined $Self->[XML_DOCUMENT] && not $Self->[XML_PASSED_AS_DOM]) {
    $Self->debug("flushing old XML::DOM::Document object...");
    $Self->[XML_DOCUMENT]->dispose;
  }

  $Self->[XML_PASSED_AS_DOM] = 1
    if ref $args{Source} eq 'XML::DOM::Document';

  if (defined $Self->[RESULT_DOCUMENT]) {
    $Self->debug("flushing result...");
    $Self->[RESULT_DOCUMENT]->dispose ();
  }

  $Self->debug("opening xml...");

  $Self->[XML_DOCUMENT] = $Self->__open_document (%args);

  $Self->[RESULT_DOCUMENT] = $Self->[XML_DOCUMENT]->createDocumentFragment;
}

sub open_xsl {
  my $Self = shift;
  my $class = ref $Self || croak "Not a method call";
  my %args = $Self->__parse_args(@_);

  $Self->[XSL_DOCUMENT]->dispose
    if not $Self->[XSL_PASSED_AS_DOM] and defined $Self->[XSL_DOCUMENT];

  $Self->[XSL_PASSED_AS_DOM] = 1
    if ref $args{Source} eq 'XML::DOM::Document';

  # open new document  # open new document
  $Self->debug("opening xsl...");
  $Self->[XSL_DOCUMENT] = $Self->__open_document (%args);
  $Self->[BASENAME] = 
    dirname(URI->new_abs($args{Source}, $Self->[BASENAME])->as_string) . '/';

  $Self->__preprocess_stylesheet;
}

# Argument parsing with backwards compatibility.
sub __parse_args {
  my $Self = shift;
  my %args;

  if(@_ % 2 == 1) {
    $args{Source} = shift;
    %args = (%args, @_);
  } else {
    %args = @_;
    if(not exists $args{Source}) {
      my $name = [caller(1)]->[3];
      carp "Argument syntax of call to $name deprecated.  See the documentation for $name"
	unless $Self->[USE_DEPRECATED]
	  or exists $deprecation_used{$name};
      $deprecation_used{$name} = 1;
      %args = ();
      $args{Source} = shift;
      shift;
      %args = (%args, @_);
    }
  }

  return %args;
}

# private auxiliary function #
sub __my_tag_compression {
  my ($tag, $elem) = @_;

  # Print all tags as <tagname />
  return 2;
}


# private auxiliary function #
sub __preprocess_stylesheet {
  my $Self = $_[0];

  $Self->debug("preprocessing stylesheet...");

  $Self->[TOP_XSL_NODE] = $Self->[XSL_DOCUMENT]->getFirstChild;
  $Self->__extract_namespaces;
#  $Self->__get_stylesheet;

  $Self->__expand_xsl_includes;
  $Self->__extract_top_level_variables;

# ** FIXME: this doesn't seem right.
#  $Self->__add_default_templates;
  $Self->__cache_templates;	# speed optim

  $Self->__set_xsl_output;
}

# private auxiliary function #
#  sub __get_stylesheet {
#    my ($Self, $xsl) = @_;
#    my $stylesheet;

#    foreach my $child ($xsl->getElementsByTagName ('*', 0)) {
#      my $tag = $child->getTagName;
#      if (substr($tag, -10) eq 'stylesheet' ||
#  	substr($tag, -8) eq 'transform') {
#        $stylesheet = $child;
#        $xsl_ns = substr($tag, 0, index($tag, ":"));
#        last;
#      }
#    }

#    if (! $stylesheet) {
#      # stylesheet is actually one complete template!
#      # put it in a template-element

#      $stylesheet = $xsl->createElement ("$xsl_ns:stylesheet");
#      my $template = $xsl->createElement ("$xsl_ns:template");
#      $template->setAttribute ('match', "/");

#      my $template_content = $xsl->getElementsByTagName ('*', 0)->item (0);
#      $xsl->replaceChild ($stylesheet, $template_content);
#      $stylesheet->appendChild ($template);
#      $template->appendChild ($template_content);
#    }

#    $Self->[XSL_DOCUMENT] = $stylesheet;
#  }

# private auxiliary function #
sub __extract_namespaces {
  my ($Self) = @_;

  ($Self->[DEFAULT_NS], my $dump) =
    split(':', $Self->[TOP_XSL_NODE]->getTagName);
  $Self->[DEFAULT_NS] = '' if not defined $dump;
  $Self->[DEFAULT_NS] &&=   $Self->[DEFAULT_NS] . ':';
  $Self->debug("Default Namespace: `" . $Self->[DEFAULT_NS] . "'");

  foreach my $attribute ($Self->[TOP_XSL_NODE]->getAttributes->getValues) {
    my ($pre, $post) = split(":", $attribute->getName, 2);
    my $value = $attribute->getValue;

    # Take care of namespaces
    if($pre eq 'xmlns' and not defined $post) {
      $Self->[NAMESPACE]->{$Self->[DEFAULT_NS]}->{namespace} = $value;
      $Self->[XSL_NS] = $Self->[DEFAULT_NS]
	if $value eq NS_XSLT;
      $Self->debug("Namespace `" . $Self->[DEFAULT_NS] . "' = `$value'");
    } elsif($pre eq 'xmlns') {
      $Self->[NAMESPACE]->{$post}->{namespace} = $value;
      $Self->[XSL_NS] = $post . ':'
	if $value eq NS_XSLT;
      $Self->debug("Namespace `$post:' = `$value'");
    }

    # Take care of versions
    if ($pre eq "version" and not defined $post) {
      $Self->[NAMESPACE]->{$Self->[DEFAULT_NS]}->{version} = $value;
      $Self->debug("Version for namespace `" . $Self->[DEFAULT_NS] .
		   "' = `$value'");
    } elsif ($pre eq "version") {
      $Self->[NAMESPACE]->{$post}->{version} = $value;
      $Self->debug("Version for namespace `$post:' = `$value'");
    }
  }

  # ** FIXME: is this right?
  $Self->[NAMESPACE]->{$Self->[DEFAULT_NS]}->{namespace} ||= NS_XHTML;
}

# private auxiliary function #
sub __expand_xsl_includes {
  my $Self = shift;

  foreach my $include_node
    ($Self->[TOP_XSL_NODE]->getElementsByTagName($Self->[XSL_NS] . "include"))
      {
    my $include_file = $include_node->getAttribute('href');

    die "include tag carries no selection!"
      unless defined $include_file;

    my $include_doc;
    eval {
      $include_doc = $Self->[XSL_DOCUMENT]->createDocumentFragment;
      my $doc =
	$Self->[PARSER]->parse($Self->__open_by_filename($include_file),
			       %{$Self->[PARSER_ARGS]});
      $include_doc->appendChild($doc);
    };
    die "parsing of $include_file failed: $@"
      if $@;

    $Self->debug("inserting `$include_file'");
    $Self->[TOP_XSL_NODE]->replaceChild($include_doc, $include_node);
  }
}

# private auxiliary function #
sub __extract_top_level_variables {
  my $Self = $_[0];

  $Self->debug("Extracting variables");
  foreach my $child ($Self->[TOP_XSL_NODE]->getElementsByTagName ('*',0)) {
    my ($ns, $tag) = split(':', $child);

    if(($tag eq '' && $Self->[XSL_NS] eq '') ||
       $Self->[XSL_NS] eq $ns) {
      $tag = $ns if $tag eq '';

      if ($tag eq 'variable' || $tag eq 'param') {

	my $name = $child->getAttribute("name");
	if ($name) {
	  my $value = $child->getAttribute("select");
	  if (!$value) {
	    my $result = $Self->[XML_DOCUMENT]->createDocumentFragment;
	    $Self->_evaluate_template ($child, $Self->[XML_DOCUMENT], '', $result);
	    $value = $Self->_string ($result);
	    $result->dispose();
	  }
	  $Self->debug("Setting $tag `$name' = `$value'");
	  $Self->[VARIABLES]->{$name} = $value;
	} else {
	  # Required, so we die (http://www.w3.org/TR/xslt#variables)
	  die "$tag tag carries no name!";
	}
      }
    }
  }
}

# private auxiliary function #
sub __add_default_templates {
  my $Self = $_[0];

  # create template for '*' and '/'
  my $elem_template =
    $Self->[XSL_DOCUMENT]->createElement
      ($Self->[XSL_NS] . "template");
  $elem_template->setAttribute('match','*|/');

  # <xsl:apply-templates />
  $elem_template->appendChild
    ($Self->[XSL_DOCUMENT]->createElement
     ($Self->[XSL_NS] . "apply-templates"));

  # create template for 'text()' and '@*'
  my $attr_template =
    $Self->[XSL_DOCUMENT]->createElement
      ($Self->[XSL_NS] . "template");
  $attr_template->setAttribute('match','text()|@*');

  # <xsl:value-of select="." />
  $attr_template->appendChild
    ($Self->[XSL_DOCUMENT]->createElement
     ($Self->[XSL_NS] . "value-of"));
  $attr_template->getFirstChild->setAttribute('select','.');

  # create template for 'processing-instruction()' and 'comment()'
  my $pi_template =
    $Self->[XSL_DOCUMENT]->createElement($Self->[XSL_NS] . "template");
  $pi_template->setAttribute('match','processing-instruction()|comment()');

  $Self->debug("adding default templates to stylesheet");
  # add them to the stylesheet
  $Self->[XSL_DOCUMENT]->insertBefore($pi_template,
				 $Self->[TOP_XSL_NODE]);
  $Self->[XSL_DOCUMENT]->insertBefore($attr_template,
				 $Self->[TOP_XSL_NODE]);
  $Self->[XSL_DOCUMENT]->insertBefore($elem_template,
				 $Self->[TOP_XSL_NODE]);
}

# private auxiliary function #
sub __cache_templates {
  my $Self = $_[0];

  $Self->[TEMPLATE] = [$Self->[XSL_DOCUMENT]->getElementsByTagName ("$Self->[XSL_NS]template")];

  # pre-cache template names and matches #
  # reversing the template order is much more efficient #
  foreach my $template (reverse @{$Self->[TEMPLATE]}) {
    if ($template->getParentNode->getTagName =~
	/^([\w\.\-]+\:){0,1}(stylesheet|transform|include)/i) {
      my $match = $template->getAttribute ('match');
      my $name = $template->getAttribute ('name');
      if ($match && $name) {
	$Self->warn(qq{defining a template with both a "name" and a "match" attribute is not allowed!});
	push (@{$Self->[TEMPLATE_MATCH]}, "");
	push (@{$Self->[TEMPLATE_NAME]}, "");
      } elsif ($match) {
	push (@{$Self->[TEMPLATE_MATCH]}, $match);
	push (@{$Self->[TEMPLATE_NAME]}, "");
      } elsif ($name) {
	push (@{$Self->[TEMPLATE_MATCH]}, "");
	push (@{$Self->[TEMPLATE_NAME]}, $name);
      } else {
	push (@{$Self->[TEMPLATE_MATCH]}, "");
	push (@{$Self->[TEMPLATE_NAME]}, "");
      }
    }
  }
}

# private auxiliary function #
sub __set_xsl_output {
  my $Self = $_[0];

  # default settings
  $Self->[METHOD] = 'xml';
  $Self->[MEDIA_TYPE] = 'text/xml';
  $Self->[OMIT_XML_DECL] = 'yes';

  # extraction of top-level xsl:output tag
  my ($output) = 
    $Self->[XSL_DOCUMENT]->getElementsByTagName("$Self->[XSL_NS]output",0);

  if ($output) {
    # extraction and processing of the attributes
    my $attribs = $output->getAttributes;
    $Self->[MEDIA_TYPE] = $attribs->getNamedItem('media-type')->getNodeValue;
    $Self->[METHOD] = $attribs->getNamedItem('method')->getNodeValue;

    if ($Self->[METHOD] eq 'xml') {

      my $omit_xml_declaration = $attribs->getNamedItem('omit-xml-declaration')->getNodeValue;

      if ($omit_xml_declaration ne 'yes' && $omit_xml_declaration ne 'no') {
	$Self->warn(qq{Wrong value for attribute "omit-xml-declaration" in$/\t} .
		    $Self->[XSL_NS] . qq{output, should be "yes" or "no"});
      } else {
	$Self->[OMIT_XML_DECL] = $omit_xml_declaration;
      }

      if (! $Self->[OMIT_XML_DECL]) {
	$Self->[OUTPUT_VERSION] = $attribs->getNamedItem('version')->getNodeValue;
	$Self->[OUTPUT_ENCODING] = $attribs->getNamedItem('encoding')->getNodeValue;

	if (not $Self->[OUTPUT_VERSION] || not $Self->[OUTPUT_ENCODING]) {
	  $Self->warn(qq{Expected attributes "version" and "encoding" in$/\t} .
	    $Self->[XSL_NS] . "output");
	}
      }
    }
    $Self->[DOCTYPE_PUBLIC] = ($attribs->getNamedItem('doctype-public')->getNodeValue||'');
    $Self->[DOCTYPE_SYSTEM] = ($attribs->getNamedItem('doctype-system')->getNodeValue||'');
  }
}

sub open_project {
  my $Self = shift;
  my $xml  = shift;
  my $xsl  = shift;
  my ($xmlflag, $xslflag, %args) = @_;

  carp "open_project is deprecated."
    unless $Self->[USE_DEPRECATED]
      or exists $deprecation_used{open_project};
  $deprecation_used{open_project} = 1;

  $Self->debug("opening project:");
  $Self->[INDENT] += $Self->[INDENT_INCR];

  $Self->open_xml ($xml, %args);
  $Self->open_xsl ($xsl, %args);

  $Self->debug("done...");
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub transform {
  my $Self = shift;
  my %topvariables = $Self->__parse_args(@_);

  $Self->debug("transforming document:");
  $Self->[INDENT] += $Self->[INDENT_INCR];

  $Self->open_xml (%topvariables);

  $Self->debug("done...");
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  $Self->debug("processing project:");
  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $root_template = $Self->_match_template ("match", '/', 1, '');

  %topvariables = (%{$Self->[VARIABLES]}, %topvariables);

  $Self->_evaluate_template (
			       $root_template, # starting template: the root template
			       $Self->[XML_DOCUMENT], # current XML node: the root
			       '', # current XML selection path: the root
			       $Self->[RESULT_DOCUMENT], # current result tree node: the root
			       {
				()}, # current known variables: none
			       \%topvariables # previously known variables: top level variables
			      );

  $Self->debug("done!");
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub process {
  my ($Self, %topvariables) = @_;

  print " "x$Self->[INDENT],"processing project:$/" if $Self->[DEBUG];
  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $root_template = $Self->_match_template ("match", '/', 1, '');

  %topvariables = (%{$Self->[VARIABLES]}, %topvariables);

  $Self->_evaluate_template (
			       $root_template, # starting template: the root template
			       $Self->[XML_DOCUMENT], # current XML node: the root
			       '', # current XML selection path: the root
			       $Self->[RESULT_DOCUMENT], # current result tree node: the root
			       {
				()}, # current known variables: none
			       \%topvariables # previously known variables: top level variables
			      );

  print " "x$Self->[INDENT],"done!$/" if $Self->[DEBUG];
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

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
		     'output_mime_type'   => 'media_type',
		     'result_tree'        => 'to_dom',
		     'output_tree'        => 'to_dom',
		     'transform_document' => 'transform',
		     'process_project'    => 'process'
		    );

  if (exists $deprecation{$name}) {
    carp "$name is deprecated.  Use $deprecation{$name}"
      unless $Self->[USE_DEPRECATED]
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

  my $string = $Self->[RESULT_DOCUMENT]->toString;
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

  return $Self->[RESULT_DOCUMENT];
}

sub media_type {
  return ($_[0]->[MEDIA_TYPE]);
}

sub print_output {
  my ($Self, $file, $mime) = @_;
  $file ||= '';			# print to STDOUT by default
  $mime = 1 unless defined $mime;

  # print mime-type header etc by default

  #  $Self->[RESULT_DOCUMENT]->printToFileHandle (\*STDOUT);
  #  or $Self->[RESULT_DOCUMENT]->print (\*STDOUT); ???
  #  exit;

  carp "print_output is deprecated.  Use serve."
    unless $Self->[USE_DEPRECATED]
      or exists $deprecation_used{print_output};
  $deprecation_used{print_output} = 1;

  if ($mime) {
    print "Content-type: $Self->[MEDIA_TYPE]\n\n";

    if ($Self->[METHOD] eq 'xml') {
      if (($Self->[OMIT_XML_DECL] eq 'no') && $Self->[OUTPUT_VERSION]
	  && $Self->[OUTPUT_ENCODING]) {
	print "<?xml version=\"$Self->[OUTPUT_VERSION]\" encoding=\"$Self->[OUTPUT_ENCODING]\"?>\n";
      }
    }
    if ($Self->[DOCTYPE_SYSTEM]) {
      my $root_name = $Self->[RESULT_DOCUMENT]->getElementsByTagName('*',0)->item(0)->getTagName;
      if ($Self->[DOCTYPE_PUBLIC]) {
	print qq{<!DOCTYPE $root_name PUBLIC "} . $Self->[DOCTYPE_PUBLIC] .
	  qq{" "} . $Self->[DOCTYPE_SYSTEM] . qq{">\n};
      } else {
	print qq{<!DOCTYPE $root_name SYSTEM "} . $Self->[DOCTYPE_SYSTEM] . qq{">\n};
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

  #$_[0]->[PARSER] = undef if (defined $_[0]->[PARSER]);
  $_[0]->[RESULT_DOCUMENT]->dispose ()    if (defined $_[0]->[RESULT_DOCUMENT]);

  # only dispose xml and xsl when they were not passed as DOM
  if (not defined $_[0]->[XML_PASSED_AS_DOM] && defined $_-[0]->[XML_DOCUMENT]) {
    $_[0]->[XML_DOCUMENT]->dispose;
  }
  if (not defined $_[0]->[XSL_PASSED_AS_DOM] && defined $_-[0]->[XSL_DOCUMENT]) {
    $_[0]->[XSL_DOCUMENT]->dispose;
  }

  $_[0] = undef;
}


######################################################################
# PRIVATE DEFINITIONS

sub __open_document {
  my $Self = shift;
  my %args = @_;
  %args = (%{$Self->[PARSER_ARGS]}, %args);
  my $doc;

  $Self->debug("opening document");

  eval {
    if(length $args{Source} < 255 &&
       (-f $args{Source} ||
	lc(substr($args{Source}, 0, 5)) eq 'http:' ||
	lc(substr($args{Source}, 0, 6)) eq 'https:' ||
	lc(substr($args{Source}, 0, 4)) eq 'ftp:' ||
	lc(substr($args{Source}, 0, 5)) eq 'file:')) { 
				# Filename
      $doc = $Self->[PARSER]->parse($Self->__open_by_filename($args{Source}),
				    %{$Self->[PARSER_ARGS]});
    } elsif(!ref $args{Source}) {
				# String
      $doc = $Self->[PARSER]->parse ($args{Source});
    } elsif(ref $args{Source} eq "SCALAR") {
				# Stringref
      $doc = $Self->[PARSER]->parse (${$args{Source}});
    } elsif(ref $args{Source} eq "XML::DOM::Document") {
				# DOM object
      $doc = $args{Source};
    } else {
      $doc = undef;
    }
  };
  die "Error in parsing: $@" if $@;

  return $doc;
}

# private auxiliary function #
sub __open_by_filename {
  my ($Self, $filename) = @_;
  my $doc;

  # ** FIXME: currently reads the whole document into memory
  #           might not be avoidable

  # LWP should be able to deal with files as well as links
  $ENV{DOMAIN} ||= "example.com"; # hide complaints from Net::Domain
  $filename = URI->new_abs($filename, $Self->[BASENAME])->as_string;
  my $result = get($filename);

  return $result
    if defined $result;
  die qq{Cannot open document from URL "$filename"$/};
}

sub _match_template {
  my ($Self, $attribute_name, $select_value, $xml_count, $xml_selection_path,
      $mode) = @_;
  $mode ||= "";

  my $template = "";
  my @template_matches = ();

  $Self->debug(qq{matching template for "$select_value" with count $xml_count$/\t} .
    qq{and path "$xml_selection_path":});

  if ($attribute_name eq "match") {
    @template_matches = @{$Self->[TEMPLATE_MATCH]};
  } elsif ($attribute_name eq "name") {
    @template_matches = @{$Self->[TEMPLATE_NAME]};
  }

  # note that the order of @template_matches is the reverse of $Self->[TEMPLATE]
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
	  print " "x$Self->[INDENT],"  found #$count with \"$match\" in \"$original_match\" $/" if $Self->[DEBUG];
	  $template = ${$Self->[TEMPLATE]}[$count-1];
	  return $template;
	  #	  last;
	}
      }

      # last match?
      if (!$template) {
	if (&__template_matches__ ($full_match, $select_value, $xml_count,
				   $xml_selection_path)) {
	  print " "x$Self->[INDENT],"  found #$count with \"$full_match\" in \"$original_match\"$/" if $Self->[DEBUG];
	  $template = ${$Self->[TEMPLATE]}[$count-1];
	  return $template;
	  #          last;
	} else {
	  print " "x$Self->[INDENT],"  #$count \"$original_match\" did not match$/" if $Self->[DEBUG];
	}
      }
    }
    $count--;
  }

  if (! $template) {
    $Self->warn("No template matching $xml_selection_path found !!");
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

  $Self->debug(qq{evaluating template content with current path }
	       . qq{"$current_xml_selection_path": });
  $Self->[INDENT] += $Self->[INDENT_INCR];

  $template->normalize();
  foreach my $child ($template->getChildNodes) {
    my $ref = ref $child;

    print " "x$Self->[INDENT],"$ref$/" if $Self->[DEBUG];
    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $node_type = $child->getNodeType;
    if ($node_type == ELEMENT_NODE) {
      $Self->_evaluate_element ($child, $current_xml_node,
				$current_xml_selection_path,
				$current_result_node, $variables,
				$oldvariables);
    } elsif ($node_type == TEXT_NODE) {
      # strip whitespace here?
      $Self->_add_node ($child, $current_result_node);
    } elsif ($node_type == CDATA_SECTION_NODE) {
      my $text = $Self->[XML_DOCUMENT]->createTextNode ($child->getData);
      $Self->_add_node($text, $current_result_node);

#      $current_result_node->getLastChild->{_disable_output_escaping} = 1;
      #$Self->_add_node($child, $current_result_node);
    } elsif ($node_type == ENTITY_REFERENCE_NODE) {
      $Self->_add_node($child, $current_result_node);
    } elsif ($node_type == DOCUMENT_TYPE_NODE) {
      # skip #
      $Self->debug("Skipping Document Type node...");
    } elsif ($node_type == COMMENT_NODE) {
      # skip #
      $Self->debug("Skipping Comment node...");
    } else {
      $Self->warn("evaluate-template: Dunno what to do with node of type $ref !!!\n\t" .
		  "($current_xml_selection_path)");
    }

    $Self->[INDENT] -= $Self->[INDENT_INCR];
  }

  $Self->debug("done!");
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _add_node {
  my ($Self, $node, $parent, $deep, $owner) = @_;
  $deep ||= "";			# False #
  $owner ||= $Self->[XML_DOCUMENT];

  print " "x$Self->[INDENT],"adding node (deep)..$/" if $Self->[DEBUG] && $deep;
  print " "x$Self->[INDENT],"adding node (non-deep)..$/" if $Self->[DEBUG] && !$deep;

  $node = $node->cloneNode($deep);
  $node->setOwnerDocument($owner);
  if ($node->getNodeType == ATTRIBUTE_NODE) {
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
    $Self->debug(qq{applying templates on children $select of "$current_xml_selection_path":});
    $children = $Self->_get_node_set ($select, $Self->[XML_DOCUMENT],
					$current_xml_selection_path,
					$current_xml_node, $variables);
  } else {
    $Self->debug(qq{applying templates on all children of "$current_xml_selection_path":});
    my @children = $current_xml_node->getChildNodes;
    $children = \@children;
  }

  $Self->_process_with_params ($xsl_node, $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $variables, $oldvariables);

  # process xsl:sort here

  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $count = 1;
  foreach my $child (@$children) {
    my $node_type = $child->getNodeType;
    
    if ($node_type == DOCUMENT_TYPE_NODE) {
      # skip #
      print " "x$Self->[INDENT],"Skipping Document Type node...$/" if $Self->[DEBUG];
    } elsif ($node_type == DOCUMENT_FRAGMENT_NODE) {
      # skip #
      print " "x$Self->[INDENT],"Skipping Document Fragment node...$/" if $Self->[DEBUG];
    } elsif ($node_type == NOTATION_NODE) {
      # skip #
      print " "x$Self->[INDENT],"Skipping Notation node...$/" if $Self->[DEBUG];
    } else {

      my $newselect = "";
      my $newcount = $count;
      if (!$select || ($select eq '.')) {
	if ($node_type == ELEMENT_NODE) {
	  $newselect = $child->getTagName;
	} elsif ($node_type == ATTRIBUTE_NODE) {
	  $newselect = "@$child->getName";
	} elsif (($node_type == TEXT_NODE) || ($node_type == ENTITY_REFERENCE_NODE)) {
	  $newselect = "text()";
	} elsif ($node_type == PROCESSING_INSTRUCTION_NODE) {
	  $newselect = "processing-instruction()";
	} elsif ($node_type == COMMENT_NODE) {
	  $newselect = "comment()";
	} else {
	  my $ref = ref $child;
	  print " "x$Self->[INDENT],"Unknown node encountered: $ref$/" if $Self->[DEBUG];
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

  $Self->[INDENT] -= $Self->[INDENT_INCR];
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
    print " "x$Self->[INDENT],"applying template for each child $select of \"$current_xml_selection_path\":$/" if $Self->[DEBUG];
    my $children = $Self->_get_node_set ($select, $Self->[XML_DOCUMENT],
					   $current_xml_selection_path,
					   $current_xml_node, $variables);
    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $count = 1;
    foreach my $child (@$children) {
      my $node_type = $child->getNodeType;

      if ($node_type == DOCUMENT_TYPE_NODE) {
	# skip #
	print " "x$Self->[INDENT],"Skipping Document Type node...$/" if $Self->[DEBUG];
      } elsif ($node_type == DOCUMENT_FRAGMENT_NODE) {
	# skip #
	print " "x$Self->[INDENT],"Skipping Document Fragment node...$/" if $Self->[DEBUG];
      } elsif ($node_type == NOTATION_NODE) {
	# skip #
	print " "x$Self->[INDENT],"Skipping Notation node...$/" if $Self->[DEBUG];
      } else {

	$Self->_evaluate_template ($xsl_node, $child,
				     "$current_xml_selection_path/$select\[$count\]",
				     $current_result_node, $variables, $oldvariables);
      }
      $count++;
    }

    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    $Self->warn("expected attribute \"select\" in <$Self->[XSL_NS]for-each>");
  }

}

sub _select_template {
  my ($Self, $child, $select, $count, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $ref = ref $child if $Self->[DEBUG];
  $Self->debug(qq{selecting template $select for child type $ref of "$current_xml_selection_path":});

  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $child_xml_selection_path = "$current_xml_selection_path/$select";
  my $template = $Self->_match_template ("match", $select, $count,
					   $child_xml_selection_path);

  if ($template) {

    $Self->_evaluate_template ($template,
				 $child,
				 "$child_xml_selection_path\[$count\]",
				 $current_result_node, $variables, $oldvariables);
  } else {
    print " "x$Self->[INDENT],"skipping template selection...$/" if $Self->[DEBUG];
  }

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _evaluate_element {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $xsl_tag = $xsl_node->getTagName;
  print " "x$Self->[INDENT],"evaluating element $xsl_tag from \"$current_xml_selection_path\": $/" if $Self->[DEBUG];
  $Self->[INDENT] += $Self->[INDENT_INCR];

  if ($xsl_tag =~ /^$Self->[XSL_NS]/i) {
    if ($xsl_tag =~ /^$Self->[XSL_NS]apply-templates$/i) {
      $Self->_apply_templates ($xsl_node, $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]attribute$/i) {
      $Self->_attribute ($xsl_node, $current_xml_node,
			   $current_xml_selection_path,
			   $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]call-template$/i) {
      $Self->_call_template ($xsl_node, $current_xml_node,
			       $current_xml_selection_path,
			       $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]choose$/i) {
      $Self->_choose ($xsl_node, $current_xml_node,
			$current_xml_selection_path,
			$current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]comment$/i) {
      $Self->_comment ($xsl_node, $current_xml_node,
			 $current_xml_selection_path,
			 $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]copy$/i) {
      $Self->_copy ($xsl_node, $current_xml_node,
		      $current_xml_selection_path,
		      $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]copy-of$/i) {
      $Self->_copy_of ($xsl_node, $current_xml_node,
			 $current_xml_selection_path,
			 $current_result_node, $variables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]for-each$/i) {
      $Self->_for_each ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]if$/i) {
      $Self->_if ($xsl_node, $current_xml_node,
		    $current_xml_selection_path,
		    $current_result_node, $variables, $oldvariables);

      #      } elsif ($xsl_tag =~ /^$Self->[XSL_NS]output$/i) {

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]param$/i) {
      $Self->_variable ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables, $oldvariables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]processing-instruction$/i) {
      $Self->_processing_instruction ($xsl_node, $current_result_node);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]text$/i) {
      $Self->_text ($xsl_node, $current_result_node);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]value-of$/i) {
      $Self->_value_of ($xsl_node, $current_xml_node,
			  $current_xml_selection_path,
			  $current_result_node, $variables);

    } elsif ($xsl_tag =~ /^$Self->[XSL_NS]variable$/i) {
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

  $Self->[INDENT] -= $Self->[INDENT_INCR];
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
  
    $xml_node = $Self->_get_node_set ($select, $Self->[XML_DOCUMENT],
					$current_xml_selection_path,
					$current_xml_node, $variables);

    print " "x$Self->[INDENT],"stripping node to text:$/" if $Self->[DEBUG];

    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $text = "";
    $text = $Self->__string__ ($$xml_node[0]) if @$xml_node;
    $Self->[INDENT] -= $Self->[INDENT_INCR];

    if ($text) {
      $Self->_add_node ($Self->[XML_DOCUMENT]->createTextNode($text), $current_result_node);
    } else {
      $Self->debug("nothing left..");
    }
  } else {
    $Self->warn(qq{expected attribute "select" in <} .
		$Self->[XSL_NS] . q{value-of>});
  }
}

sub __strip_node_to_text__ {
  my ($Self, $node) = @_;
    
  my $result = "";

  my $node_type = $node->getNodeType;
  if ($node_type == TEXT_NODE) {
    $result = $node->getData;
  } elsif (($node_type == ELEMENT_NODE)
	   || ($node_type == DOCUMENT_FRAGMENT_NODE)) {
    $Self->[INDENT] += $Self->[INDENT_INCR];
    foreach my $child ($node->getChildNodes) {
      $result .= &__strip_node_to_text__ ($Self, $child);
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  }
  return $result;
}

sub __string__ {
  my ($Self, $node) = @_;
    
  my $result = "";

  if ($node) {
    my $ref = (ref ($node) || "ARRAY") if $Self->[DEBUG];
    print " "x$Self->[INDENT],"stripping child nodes ($ref):$/" if $Self->[DEBUG];

    $Self->[INDENT] += $Self->[INDENT_INCR];

    if ($node eq "ARRAY") {
      return $Self->__string__ ($$node[0]);
    } else {
      my $node_type = $node->getNodeType;

      if (($node_type == ELEMENT_NODE)
	  || ($node_type == DOCUMENT_FRAGMENT_NODE)
	  || ($node_type == DOCUMENT_NODE)) {
	foreach my $child ($node->getChildNodes) {
	  $result .= &__string__ ($Self, $child);
	}
      } elsif ($node_type == ATTRIBUTE_NODE) {
	$result .= $node->getValue;
      } elsif (($node_type == TEXT_NODE)
	       || ($node_type == ENTITY_REFERENCE_NODE)) {
	$result .= $node->getData;
      }
    }

    print " "x$Self->[INDENT],"  \"$result\"$/" if $Self->[DEBUG];
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    print " "x$Self->[INDENT]," no result$/" if $Self->[DEBUG];
  }
 
  return $result;
}

sub _move_node {
  my ($Self, $node, $parent) = @_;

  print " "x$Self->[INDENT],"moving node..$/" if $Self->[DEBUG];

  $parent->appendChild($node);
}

sub _get_node_set {
  my ($Self, $path, $root_node, $current_path, $current_node, $variables,
      $silent) = @_;
  $current_path ||= "/";
  $current_node ||= $root_node;
  $silent ||= 0;
  
  print " "x$Self->[INDENT],"getting node-set \"$path\" from \"$current_path\":$/" if $Self->[DEBUG];

  $Self->[INDENT] += $Self->[INDENT_INCR];

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
	return [$Self->[XML_DOCUMENT]->createTextNode ($$variables{$varname})];
      }
    } else {
      # var does not exist
      return [];
    }
  } elsif ($path eq $current_path || $path eq 'self::node()') {
    print " "x$Self->[INDENT],"direct hit!$/" if $Self->[DEBUG];
    return [$current_node];
  } else {
    # open external documents first #
    if ($path =~ /^\s*document\s*\(["'](.*?)["']\s*(,\s*(.*)\s*){0,1}\)\s*(.*)$/i) {
      my $filename = $1;
      my $sec_arg = $3;
      $path = ($4 || "");

      $Self->debug(qq{external selection ("$filename")!});

      if ($sec_arg) {
	$Self->warn("Ignoring second argument of $path");
      }

      ($root_node) = $Self->[PARSER]->parse
	($Self->__open_by_filename ($filename), %{$Self->[PARSER_ARGS]});
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

    print " "x$Self->[INDENT],"using \"$path\": $/" if $Self->[DEBUG];

    if ($path eq '/') {
      $current_node = [$current_node];
    } else {
      $current_node = &__get_node_set__ ($Self, $path, [$current_node], $silent);
    }

    $Self->[INDENT] -= $Self->[INDENT_INCR];
    
    return $current_node;
  }
}


# auxiliary function #
sub __get_node_set__ {
  my ($Self, $path, $node, $silent) = @_;

  # a Qname (?) should actually be: [a-Z_][\w\.\-]*\:[a-Z_][\w\.\-]*

  if ($path eq "") {

    print " "x$Self->[INDENT],"node found!$/" if $Self->[DEBUG];
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
    print " "x$Self->[INDENT],"getting parent (\"$path\")$/" if $Self->[DEBUG];
    return &__parent__ ($Self, $path, $node, $silent);

  } elsif ($path =~ s/^\/attribute\:\:(\*|[\w\.\:\-]+)//) {
    # /@attr #
    print " "x$Self->[INDENT],"getting attribute $1 (\"$path\")$/" if $Self->[DEBUG];
    return &__attribute__ ($Self, $1, $path, $node, $silent);

  } elsif ($path =~ s/^\/descendant\-or\-self\:\:node\(\)\/(child\:\:|)(\*|[\w\.\:\-]+)\[(\S+?)\]//) {
    # //elem[n] #
    print " "x$Self->[INDENT],"getting deep indexed element $1 $2 (\"$path\")$/" if $Self->[DEBUG];
    return &__indexed_element__ ($Self, $1, $2, $path, $node, $silent, "deep");

  } elsif ($path =~ s/^\/descendant\-or\-self\:\:node\(\)\/(\*|[\w\.\:\-]+)//) {
    # //elem #
    print " "x$Self->[INDENT],"getting deep element $1 (\"$path\")$/" if $Self->[DEBUG];
    return &__element__ ($Self, $1, $path, $node, $silent, "deep");

  } elsif ($path =~ s/^\/(child\:\:|)(\*|[\w\.\:\-]+)\[(\S+?)\]//) {
    # /elem[n] #
    print " "x$Self->[INDENT],"getting indexed element $2 $3 (\"$path\")$/" if $Self->[DEBUG];
    return &__indexed_element__ ($Self, $2, $3, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)(\*|[\w\.\:\-]+)//) {
    # /elem #
    print " "x$Self->[INDENT],"getting element $2 (\"$path\")$/" if $Self->[DEBUG];
    return &__element__ ($Self, $2, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)text\(\)//) {
    # /text() #
    print " "x$Self->[INDENT],"getting text (\"$path\")$/" if $Self->[DEBUG];
    return &__get_nodes__ ($Self, TEXT_NODE, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)processing-instruction\(\)//) {
    # /processing-instruction() #
    print " "x$Self->[INDENT],"getting processing instruction (\"$path\")$/" if $Self->[DEBUG];
    return &__get_nodes__ ($Self, PROCESSING_INSTRUCTION_NODE, $path, $node, $silent);

  } elsif ($path =~ s/^\/(child\:\:|)comment\(\)//) {
    # /comment() #
    $Self->debug(qq{getting comment ("$path")});
    return &__get_nodes__ ($Self, COMMENT_NODE, $path, $node, $silent);

  } else {
    $Self->warn("get-node-from-path: Don't know what to do with path $path !!!");
    return [];
  }
}

sub __parent__ {
  my ($Self, $path, $node, $silent) = @_;

  $Self->[INDENT] += $Self->[INDENT_INCR];
  if (($node->getNodeType == DOCUMENT_NODE)
      || ($node->getNodeType == DOCUMENT_FRAGMENT_NODE)) {
    print " "x$Self->[INDENT],"no parent!$/" if $Self->[DEBUG];
    $node = [];
  } else {
    $node = $node->getParentNode;

    $node = &__get_node_set__ ($Self, $path, [$node], $silent);
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];

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

  $Self->[INDENT] += $Self->[INDENT_INCR];
  if ($node) {
    $node = &__get_node_set__ ($Self, $path, [$node], $silent);
  } else {
    print " "x$Self->[INDENT],"failed!$/" if $Self->[DEBUG];
    $node = [];
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  return $node;
}

sub __element__ {
  my ($Self, $element, $path, $node, $silent, $deep) = @_;
  $deep ||= "";			# False #

  $node = [$node->getElementsByTagName($element, $deep)];

  $Self->[INDENT] += $Self->[INDENT_INCR];
  if (@$node) {
    $node = &__get_node_set__($Self, $path, $node, $silent);
  } else {
    print " "x$Self->[INDENT],"failed!$/" if $Self->[DEBUG];
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  return $node;
}

sub __attribute__ {
  my ($Self, $attribute, $path, $node, $silent) = @_;

  if ($attribute eq '*') {
    $node = [$node->getAttributes->getValues];
        
    $Self->[INDENT] += $Self->[INDENT_INCR];
    if ($node) {
      $node = &__get_node_set__ ($Self, $path, $node, $silent);
    } else {
      print " "x$Self->[INDENT],"failed!$/" if $Self->[DEBUG];
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    $node = $node->getAttributeNode($attribute);
        
    $Self->[INDENT] += $Self->[INDENT_INCR];
    if ($node) {
      $node = &__get_node_set__ ($Self, $path, [$node], $silent);
    } else {
      print " "x$Self->[INDENT],"failed!$/" if $Self->[DEBUG];
      $node = [];
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  }

  return $node;
}

sub __get_nodes__ {
  my ($Self, $node_type, $path, $node, $silent) = @_;

  my $result = [];

  $Self->[INDENT] += $Self->[INDENT_INCR];
  foreach my $child ($node->getChildNodes) {
    if ($child->getNodeType == $node_type) {
      $result = [@$result, &__get_node_set__ ($Self, $path, [$child], $silent)];
    }
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];
	
  if (! @$result) {
    print " "x$Self->[INDENT],"failed!$/" if $Self->[DEBUG];
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
      my $node = $Self->_get_node_set ($1, $Self->[XML_DOCUMENT],
					 $current_xml_selection_path,
					 $current_xml_node, $variables);
      if (@$node) {
	$Self->[INDENT] += $Self->[INDENT_INCR];
	my $text = $Self->__string__ ($$node[0]);
	$Self->[INDENT] -= $Self->[INDENT_INCR];
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
    $Self->warn("<" . $Self->[XSL_NS] . "processing-instruction> may not be used to create XML");
    $Self->warn("declaration. Use <" . $Self->[XSL_NS] . "output> instead...");
  } elsif ($new_PI_name) {
    my $text = $Self->__string__ ($xsl_node);
    my $new_PI = $Self->[XML_DOCUMENT]->createProcessingInstruction($new_PI_name, $text);

    if ($new_PI) {
      $Self->_move_node ($new_PI, $current_result_node);
    }
  } else {
    $Self->warn(q{Expected attribute "name" in <} .
		$Self->[XSL_NS] . "processing-instruction> !");
  }
}

sub _process_with_params {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $variables, $oldvariables) = @_;

  my @params = $xsl_node->getElementsByTagName("$Self->[XSL_NS]with-param");
  foreach my $param (@params) {
    my $varname = $param->getAttribute('name');

    if ($varname) {
      if ($$oldvariables{$varname}) {
	$$variables{$varname} = $$oldvariables{$varname};
      } else {
	my $value = $param->getAttribute('select');
        
	if (!$value) {
	  # process content as template
	  my $result = $Self->[XML_DOCUMENT]->createDocumentFragment;

	  $Self->_evaluate_template ($param,
				       $current_xml_node,
				       $current_xml_selection_path,
				       $result, $variables, $oldvariables);

	  $Self->[INDENT] += $Self->[INDENT_INCR];
	  $value = $Self->__string__ ($result);
	  $Self->[INDENT] -= $Self->[INDENT_INCR];

	  $result->dispose();
	}

	$$variables{$varname} = $value;
      }
    } else {
      $Self->warn(q{Expected attribute "name" in <} .
		  $Self->[XSL_NS] . q{with-param> !});
    }
  }

}

sub _call_template {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  my $newvariables = {()};

  my $name = $xsl_node->getAttribute('name');
  
  if ($name) {
    print " "x$Self->[INDENT],"calling template named \"$name\"$/" if $Self->[DEBUG];

    $Self->_process_with_params ($xsl_node, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);

    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $template = $Self->_match_template ("name", $name, 0, '');

    if ($template) {
      $Self->_evaluate_template ($template, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);
    } else {
      $Self->warn("no template named $name found!");
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    $Self->warn(q{Expected attribute "name" in <} .
		$Self->[XSL_NS] . q{call-template/>});
  }
}

sub _choose {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  print " "x$Self->[INDENT],"evaluating choose:$/" if $Self->[DEBUG];

  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $notdone = "true";
  my $testwhen = "active";
  foreach my $child ($xsl_node->getElementsByTagName ('*', 0)) {
    if ($notdone && $testwhen && ($child->getTagName eq "$Self->[XSL_NS]when")) {
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
	$Self->warn(q{expected attribute "test" in <} .
		    $Self->[XSL_NS] . q{when>});
      }
    } elsif ($notdone && ($child->getTagName eq "$Self->[XSL_NS]otherwise")) {
      $Self->_evaluate_template ($child, $current_xml_node,
				   $current_xml_selection_path,
				   $current_result_node, $variables, $oldvariables);
      $notdone = "";
    }
  }
  
  if ($notdone) {
    print " "x$Self->[INDENT],"nothing done!$/" if $Self->[DEBUG];
  }

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _if {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  print " "x$Self->[INDENT],"evaluating if:$/" if $Self->[DEBUG];

  $Self->[INDENT] += $Self->[INDENT_INCR];

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
    $Self->warn(q{expected attribute "test" in <} .
		$Self->[XSL_NS] . q{if>});
  }

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _evaluate_test {
  my ($Self, $test, $current_xml_node, $current_xml_selection_path,
      $variables) = @_;

  if ($test =~ /^(.+)\/\[(.+)\]$/) {
    my $path = $1;
    $test = $2;
    
    print " "x$Self->[INDENT],"evaluating test $test at path $path:$/" if $Self->[DEBUG];

    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $node = $Self->_get_node_set ($path, $Self->[XML_DOCUMENT],
				       $current_xml_selection_path,
				       $current_xml_node, $variables);
    if (@$node) {
      $current_xml_node = $$node[0];
    } else {
      return "";
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    print " "x$Self->[INDENT],"evaluating path or test $test:$/" if $Self->[DEBUG];
    my $node = $Self->_get_node_set ($test, $Self->[XML_DOCUMENT],
				       $current_xml_selection_path,
				       $current_xml_node, $variables, "silent");
    $Self->[INDENT] += $Self->[INDENT_INCR];
    if (@$node) {
      print " "x$Self->[INDENT],"path exists!$/" if $Self->[DEBUG];
      return "true";
    } else {
      print " "x$Self->[INDENT],"not a valid path, evaluating as test$/" if $Self->[DEBUG];
    }
    $Self->[INDENT] -= $Self->[INDENT_INCR];
  }

  $Self->[INDENT] += $Self->[INDENT_INCR];
  my $result = &__evaluate_test__ ($test, $current_xml_node);
  if ($result) {
    print " "x$Self->[INDENT],"test evaluates true..$/" if $Self->[DEBUG];
  } else {
    print " "x$Self->[INDENT],"test evaluates false..$/" if $Self->[DEBUG];
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];
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
  print " "x$Self->[INDENT],"evaluating copy-of with select \"$select\":$/" if $Self->[DEBUG];
  
  $Self->[INDENT] += $Self->[INDENT_INCR];
  if ($select) {
    $nodelist = $Self->_get_node_set ($select, $Self->[XML_DOCUMENT],
					$current_xml_selection_path,
					$current_xml_node, $variables);
  } else {
    $Self->warn(q{expected attribute "select" in <} .
		$Self->[XSL_NS] . q{copy-of>});
  }
  foreach my $node (@$nodelist) {
    $Self->_add_node ($node, $current_result_node, "deep");
  }

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _copy {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;


  print " "x$Self->[INDENT],"evaluating copy:$/" if $Self->[DEBUG];

  $Self->[INDENT] += $Self->[INDENT_INCR];
  if ($current_xml_node->getNodeType == ATTRIBUTE_NODE) {
    my $attribute = $current_xml_node->cloneNode(0);
    $current_result_node->setAttributeNode($attribute);
  } elsif (($current_xml_node->getNodeType == COMMENT_NODE)
	   || ($current_xml_node->getNodeType == PROCESSING_INSTRUCTION_NODE)) {
    $Self->_add_node ($current_xml_node, $current_result_node);
  } else {
    $Self->_add_node ($current_xml_node, $current_result_node);
    $Self->_evaluate_template ($xsl_node,
				 $current_xml_node,
				 $current_xml_selection_path,
				 $current_result_node->getLastChild,
				 $variables, $oldvariables);
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _text {
  #=item addText (text)
  #
  #Appends the specified string to the last child if it is a Text node, or else 
  #appends a new Text node (with the specified text.)
  #
  #Return Value: the last child if it was a Text node or else the new Text node.
  my ($Self, $xsl_node, $current_result_node) = @_;

  $Self->debug("inserting text:");

  $Self->[INDENT] += $Self->[INDENT_INCR];

  $Self->debug("stripping node to text:");

  $Self->[INDENT] += $Self->[INDENT_INCR];
  my $text = $Self->__string__ ($xsl_node);
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  if ($text) {
    $Self->_move_node ($Self->[XML_DOCUMENT]->createTextNode ($text), $current_result_node);
  } else {
    $Self->debug("nothing left..");
  }

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _attribute {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  
  my $name = $xsl_node->getAttribute ('name');
  print " "x$Self->[INDENT],"inserting attribute named \"$name\":$/" if $Self->[DEBUG];

  $Self->[INDENT] += $Self->[INDENT_INCR];
  if ($name) {
    my $result = $Self->[XML_DOCUMENT]->createDocumentFragment;

    $Self->_evaluate_template ($xsl_node,
				 $current_xml_node,
				 $current_xml_selection_path,
				 $result, $variables, $oldvariables);

    $Self->[INDENT] += $Self->[INDENT_INCR];
    my $text = $Self->__string__ ($result);
    $Self->[INDENT] -= $Self->[INDENT_INCR];

    $current_result_node->setAttribute($name, $text);
    $result->dispose();
  } else {
    $Self->warn(q{expected attribute "name" in <} .
		$Self->[XSL_NS] . q{attribute>});
  }
  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _comment {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;

  $Self->debug("inserting comment:");

  $Self->[INDENT] += $Self->[INDENT_INCR];

  my $result = $Self->[XML_DOCUMENT]->createDocumentFragment;

  $Self->_evaluate_template ($xsl_node,
			       $current_xml_node,
			       $current_xml_selection_path,
			       $result, $variables, $oldvariables);

  $Self->[INDENT] += $Self->[INDENT_INCR];
  my $text = $Self->__string__ ($result);
  $Self->[INDENT] -= $Self->[INDENT_INCR];

  $Self->_move_node ($Self->[XML_DOCUMENT]->createComment ($text), $current_result_node);
  $result->dispose();

  $Self->[INDENT] -= $Self->[INDENT_INCR];
}

sub _variable {
  my ($Self, $xsl_node, $current_xml_node, $current_xml_selection_path,
      $current_result_node, $variables, $oldvariables) = @_;
  
  my $varname = $xsl_node->getAttribute ('name');
  
  if ($varname) {
    print " "x$Self->[INDENT],"definition of variable \$$varname:$/" if $Self->[DEBUG];

    $Self->[INDENT] += $Self->[INDENT_INCR];

    if ($$oldvariables{$varname}) {
      # copy from parent-template

      $$variables{$varname} = $$oldvariables{$varname};

    } else {
      # new variable definition

      my $value = $xsl_node->getAttribute ('select');

      if (! $value) {
	#tough case, evaluate content as template

	$value = $Self->[XML_DOCUMENT]->createDocumentFragment;

	$Self->_evaluate_template ($xsl_node,
				   $current_xml_node,
				   $current_xml_selection_path,
				   $value, $variables, $oldvariables);
      }

      $$variables{$varname} = $value;
    }

    $Self->[INDENT] -= $Self->[INDENT_INCR];
  } else {
    $Self->warn(q{expected attribute "name" in <} .
		$Self->[XSL_NS] . q{param> or <} .
		$Self->[XSL_NS] . q{variable>});
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

XML::XSLT makes use of XML::DOM and LWP::Simple, while XML::DOM
uses XML::Parser.  Therefore XML::Parser, XML::DOM and LWP::Simple
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

=item variables

Hashref of variables and their values for the stylesheet.

=item base

Base of URL for file inclusion.

=item debug

Turn on debugging messages.

=item warnings

Turn on warning messages.

=item indent

Starting amount of indention for debug messages.  Defaults to 0.

=item indent_incr

Amount to indent each level of debug message.  Defaults to 1.

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
Egon Willighagen <egonw@sci.kun.nl>,
Mark A. Hershberger <mah@everybody.org>
Bron Gondwana <perlcode@brong.net>,

=head1 SEE ALSO

L<XML::DOM>, L<LWP::Simple>, L<XML::Parser>

=cut
