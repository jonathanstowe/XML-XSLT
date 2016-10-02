

use Test::More;

use XML::XSLT;

use FindBin qw($Bin);

use lib "$Bin/lib";

use Test::XML::Structure;

my $DEBUG = 0;

  
eval
{


my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset01.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset01.xml");
ok(my $out = $xslt->toString(),q~Set attribute of a LRE from single attribute set. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset01.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset02.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset02.xml");
ok(my $out = $xslt->toString(),q~Set attributes of a LRE from multiple attribute sets. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset02.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset03.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset03.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with multiple attribute sets. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset03.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{
    my $DEBUG = 1;

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset04.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset04.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with multiple attribute sets, no conflicts. ~);

if ( $out =~ /^\s*(.*?)\s*/sm )
{
    $out = $1;
}

is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset04.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset05.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset05.xml");
ok(my $out = $xslt->toString(),q~Set attributes of a LRE using attribute sets that inherit. ~);
ok(Test::XML::Structure->compare_attributes($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset05.out"),"test1"),"output is as expected");


};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset06.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset06.xml");
ok(my $out = $xslt->toString(),q~Set attributes of a LRE using attribute sets that inherit, plus add overlapping attribute with xsl:attribute. ~);
ok(Test::XML::Structure->compare_attributes($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset06.out"),"test1"), "output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset07.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset07.xml");
ok(my $out = $xslt->toString(),q~Set attributes of a LRE using attribute sets that inherit, but have overlapping attributes. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset07.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset08.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset08.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with attribute sets that inherit, plus add overlapping attribute with xsl:attribute. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset08.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset09.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset09.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with attribute sets that inherit, plus add overlapping attribute with xsl:attribute. ~);
ok(Test::XML::Structure->compare_attributes($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset09.out"),"foo"), "output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset10.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset10.xml");
ok(my $out = $xslt->toString(),q~Set attributes of an LRE, using attribute sets whose names overlap, plus add overlapping attribute with xsl:attribute. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset10.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset11.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset11.xml");
ok(my $out = $xslt->toString(),q~ ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset11.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset12.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset12.xml");
ok(my $out = $xslt->toString(),q~Set attributes of an LRE, using one attribute set with multiple attributes, and one overriding LRE attribute, and one overriding xsl:attribute attribute. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset12.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset13.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset13.xml");
ok(my $out = $xslt->toString(),q~Creating attribute for Literal Result Element. The expanded-name of the attribute to be created is specified by a required name attribute and an optional namespace attribute ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset13.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset14.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset14.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with attribute having a namespace. The expanded-name of the attribute to be created is specified by a required name attribute and an optional namespace attribute ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset14.out"),"output is as expected");

};
if($@)
{
fail($@)}

SKIP:
eval
{
my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset15.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset15.xml");
ok(my $out = $xslt->toString(),q~The name attribute is interpreted as an attribute value template. It is an error if the value of the AVT is not a QNAME or the string "xmlns". (Last two xsl:attributes test this) ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset15.out"),"output is as expected");

};
if($@)
{
fail($@)}

SKIP:
eval
{
my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset16.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset16.xml");
ok(my $out = $xslt->toString(),q~The namespace attribute is interpreted as an attribute value template. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset16.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset17.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset17.xml");
ok(my $out = $xslt->toString(),q~Verify that 'checked' attribute of HTML element input is correctly set. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset17.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset18.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset18.xml");
ok(my $out = $xslt->toString(),q~Verify adding an attribute to an element replaces any existing attribute of that element with the same expanded name. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset18.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset19.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset19.xml");
ok(my $out = $xslt->toString(),q~Verify adding an attribute to an element after children have been added to it is an error. The attributes can be ignored. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset19.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset20.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset20.xml");
ok(my $out = $xslt->toString(),q~Test for selecting attributes with xml namespace prefix. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset20.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset21.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset21.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with a single attribute set. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset21.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset22.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset22.xml");
ok(my $out = $xslt->toString(),q~Verify that attributes that contain text nodes with a newline, the output must contain a character reference. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset22.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset23.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset23.xml");
ok(my $out = $xslt->toString(),q~XSLT processors may make use of the prefix of the QNAME specified in the name attribute ... however they are not required to do so and, if the prefix is xmlns, they must not do so ... this will not result in a namespace declaration being output. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset23.out"),"output is as expected");

};
if($@)
{
fail($@)}

SKIP:
eval
{
my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset24.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset24.xml");
ok(my $out = $xslt->toString(),q~The attribute must be in the designated namespace, even if the prefix has to be reset or ignored. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset24.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset25.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset25.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with for-each inside xsl:attribute ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset25.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset26.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset26.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with multiple attribute sets that inherit, but have conflicts. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset26.out"),"output is as expected");

};
if($@)
{
fail($@)}

SKIP:
eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset27.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset27.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with multiple attribute sets with conflicting set name, then reset one attribute with xsl:attribute. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset27.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset28.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset28.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with multiple attribute sets in a list that have conflicts. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset28.out"),"output is as expected");

};
if($@)
{
fail($@)}

SKIP:
eval
{
my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset29.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset29.xml");
ok(my $out = $xslt->toString(),q~Use xsl:copy with multiple attribute sets in "merge" scenario. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset29.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset30.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset30.xml");
ok(my $out = $xslt->toString(),q~Set attributes of an element created with xsl:element from single attribute set. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset30.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset31.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset31.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with multiple attribute sets with conflicting names (merge scenario), plus local override with xsl:attribute. ~);
ok(Test::XML::Structure->compare_attributes($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset31.out"),"element1"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset32.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset32.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with multiple attribute sets with conflicting set names. ~);
ok(Test::XML::Structure->compare_attributes($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset32.out"),"test1"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset33.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset33.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with multiple attribute sets that inherit. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset33.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset34.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset34.xml");
ok(my $out = $xslt->toString(),q~Use xsl:element with multiple attribute sets that inherit, but have overlapping attributes. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset34.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset35.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset35.xml");
ok(my $out = $xslt->toString(),q~Verify adding an attribute to an element after a PI has been added to it is an error. The attributes can be ignored. The spec doesn't explicitly say this is disallowed, as it does for child elements, but it makes sense to have the same treatment. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset35.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset36.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset36.xml");
ok(my $out = $xslt->toString(),q~Verify adding an attribute to an element after a comment has been added to it is an error. The attributes can be ignored. The spec doesn't explicitly say this is disallowed, as it does for child elements, but it makes sense to have the same treatment. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset36.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset37.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset37.xml");
ok(my $out = $xslt->toString(),q~Set some attributes from an imported definition. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset37.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset38.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset38.xml");
ok(my $out = $xslt->toString(),q~Set some attributes from an imported definition. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset38.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset39.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset39.xml");
ok(my $out = $xslt->toString(),q~Test use of leading underscore in names. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset39.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset40.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset40.xml");
ok(my $out = $xslt->toString(),q~The attribute must be in the designated namespace, even if the prefix has to be reset or ignored. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset40.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset41.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset41.xml");
ok(my $out = $xslt->toString(),q~Test inheritance of attribute sets. A literal result element is referring an attribute set that is defined by two separate <xsl:attribute-set.../> elements with the same name. Both these elements have a use-attribute-sets attribute, which means that we have a single attribute set that inherits from two other attribute sets. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset41.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset42.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset42.xml");
ok(my $out = $xslt->toString(),q~Test inheritance of attribute sets. A literal result element is referring an attribute set that is defined by two separate <xsl:attribute-set.../> elements with the same name. Both these elements have a use-attribute-sets attribute, which means that we have a single attribute set that inherits from two other attribute sets. Both parents attribute sets have attributes that are overridden by the child. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset42.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset43.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset43.xml");
ok(my $out = $xslt->toString(),q~Test inheritance of attribute sets. A xsl:element instruction is referring an attribute set that is defined by two separate xsl:attribute-set elements with the same name. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset43.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset44.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset44.xml");
ok(my $out = $xslt->toString(),q~Only top-level variables and params are visible within the declaration of an attribute set. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset44.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset45.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset45.xml");
ok(my $out = $xslt->toString(),q~Basic test of import precedence with attribute sets ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset45.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset46.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset46.xml");
ok(my $out = $xslt->toString(),q~Basic test of import precedence based on Richard Titmuss's test with attribute sets. Here the imported attribute sets have additional non- conflicting attributes as well. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset46.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset47.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset47.xml");
ok(my $out = $xslt->toString(),q~Test attribute set with a qualified name. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset47.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{
  my $DEBUG=1;
my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset48.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset48.xml");
ok(my $out = $xslt->toString(),q~Test attribute set with a qualified name, different prefix. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset48.out"),"output is as expected");

};
if($@)
{
fail($@)}

eval
{

my $xslt = XML::XSLT->new(Source =>  "$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset49.xsl", debug => $DEBUG);
$xslt->transform("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/attribset/attribset49.xml");
ok(my $out = $xslt->toString(),q~Attempt to set an empty or null attribute in various ways. ~);
is($out, slurp_file("$Bin/test_data/testsuite/TESTS/Xalan_Conformance_Tests/REF_OUT/attribset/attribset49.out"),"output is as expected");

};
if($@)
{
fail($@)}

done_testing();

sub slurp_file
 {
    my ( $file_name ) = @_;
    local $/;
    open my $FILE, '<', $file_name;
    my $string = <$FILE>;
    $string =~ s/<\?xml version="1.0" encoding="UTF-8"\?>\s*\n//sm;    

    if ($string =~ /^\s*(.*?)\s*$/sm )
    {
        $string = $1;
    }
    return $string;
 }

