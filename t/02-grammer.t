use XML::XSLT;

print "1..1\n";

$xsl = q{<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match='/'>
    <HTML>
      <HEAD>
        <TITLE>Example application of XML::XSLT</TITLE>
      </HEAD>
      <BODY BGCOLOR="#EEEEEE" BACKGROUND="gifs/achtergrond.gif">
        <CENTER>
          <H1>Example application of XML::XSLT</H1>
          <I>Extraction of grammar rules from Recommendations</I>
        </CENTER>

        <xsl:for-each select=".//prod">
          [<xsl:value-of select="position()" />] <xsl:value-of select="lhs" /> ::= <xsl:apply-templates select=".//rhs" /> <BR />
        </xsl:for-each>

      </BODY>
    </HTML>
  </xsl:template>

  <xsl:template match='rhs'>
    <xsl:value-of select="." />
  </xsl:template>
</xsl:stylesheet>
};
$xml = q{<?xml version='1.0' encoding='ISO-8859-1' standalone='no'?>
<!DOCTYPE spec SYSTEM "spec.dtd" [

<!-- LAST TOUCHED BY: Tim Bray, 8 February 1997 -->

<!-- The words 'FINAL EDIT' in comments mark places where changes
need to be made after approval of the document by the ERB, before
publication.  -->

<!ENTITY XML.version "1.0">
<!ENTITY doc.date "10 February 1998">
<!ENTITY iso6.doc.date "19980210">
<!ENTITY w3c.doc.date "02-Feb-1998">
<!ENTITY draft.day '10'>
<!ENTITY draft.month 'February'>
<!ENTITY draft.year '1998'>

<!ENTITY WebSGML 
 'WebSGML Adaptations Annex to ISO 8879'>

<!ENTITY lt     "<"> 
<!ENTITY gt     ">"> 
<!ENTITY xmlpio "'&lt;?xml'">
<!ENTITY pic    "'?>'">
<!ENTITY br     "\n">
<!ENTITY cellback '#c0d9c0'>
<!ENTITY mdash  "--"> <!-- &#x2014, but nsgmls doesn't grok hex -->
<!ENTITY com    "--">
<!ENTITY como   "--">
<!ENTITY comc   "--">
<!ENTITY hcro   "&amp;#x">
<!-- <!ENTITY nbsp "�"> -->
<!ENTITY nbsp   "&#160;">
<!ENTITY magicents "<code>amp</code>,
<code>lt</code>,
<code>gt</code>,
<code>apos</code>,
<code>quot</code>">
 
<!-- audience and distribution status:  for use at publication time -->
<!ENTITY doc.audience "public review and discussion">
<!ENTITY doc.distribution "may be distributed freely, as long as
all text and legal notices remain intact">

]>

<!-- for Panorama *-->
<?VERBATIM "eg" ?>

<spec>
<header>
<title>Extensible Markup Language (XML) 1.0</title>
<version></version>
<w3c-designation>REC-xml-&iso6.doc.date;</w3c-designation>
<w3c-doctype>W3C Recommendation</w3c-doctype>
<pubdate><day>&draft.day;</day><month>&draft.month;</month><year>&draft.year;</year></pubdate>

<publoc>
<loc  href="http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;">
http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;</loc>
<loc  href="http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.xml">
http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.xml</loc>
<loc  href="http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.html">
http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.html</loc>
<loc  href="http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.pdf">
http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.pdf</loc>
<loc  href="http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.ps">
http://www.w3.org/TR/1998/REC-xml-&iso6.doc.date;.ps</loc>
</publoc>
<latestloc>
<loc  href="http://www.w3.org/TR/REC-xml">
http://www.w3.org/TR/REC-xml</loc>
</latestloc>
<prevlocs>
<loc  href="http://www.w3.org/TR/PR-xml-971208">
http://www.w3.org/TR/PR-xml-971208</loc>
<!--
<loc  href='http://www.w3.org/TR/WD-xml-961114'>
http://www.w3.org/TR/WD-xml-961114</loc>
<loc  href='http://www.w3.org/TR/WD-xml-lang-970331'>
http://www.w3.org/TR/WD-xml-lang-970331</loc>
<loc  href='http://www.w3.org/TR/WD-xml-lang-970630'>
http://www.w3.org/TR/WD-xml-lang-970630</loc>
<loc  href='http://www.w3.org/TR/WD-xml-970807'>
http://www.w3.org/TR/WD-xml-970807</loc>
<loc  href='http://www.w3.org/TR/WD-xml-971117'>
http://www.w3.org/TR/WD-xml-971117</loc>-->
</prevlocs>
<authlist>
<author><name>Tim Bray</name>
<affiliation>Textuality and Netscape</affiliation>
<email 
href="mailto:tbray@textuality.com">tbray@textuality.com</email></author>
<author><name>Jean Paoli</name>
<affiliation>Microsoft</affiliation>
<email href="mailto:jeanpa@microsoft.com">jeanpa@microsoft.com</email></author>
<author><name>C. M. Sperberg-McQueen</name>
<affiliation>University of Illinois at Chicago</affiliation>
<email href="mailto:cmsmcq@uic.edu">cmsmcq@uic.edu</email></author>
</authlist>
<abstract>
<p>The Extensible Markup Language (XML) is a subset of
SGML that is completely described in this document. Its goal is to
enable generic SGML to be served, received, and processed on the Web
in the way that is now possible with HTML. XML has been designed for
ease of implementation and for interoperability with both SGML and
HTML.</p>
</abstract>
<status>
<p>This document has been reviewed by W3C Members and
other interested parties and has been endorsed by the
Director as a W3C Recommendation. It is a stable
document and may be used as reference material or cited
as a normative reference from another document. W3C's
role in making the Recommendation is to draw attention
to the specification and to promote its widespread
deployment. This enhances the functionality and
interoperability of the Web.</p>
<p>
This document specifies a syntax created by subsetting an existing,
widely used international text processing standard (Standard
Generalized Markup Language, ISO 8879:1986(E) as amended and
corrected) for use on the World Wide Web.  It is a product of the W3C
XML Activity, details of which can be found at <loc
href='http://www.w3.org/XML'>http://www.w3.org/XML</loc>.  A list of
current W3C Recommendations and other technical documents can be found
at <loc href='http://www.w3.org/TR'>http://www.w3.org/TR</loc>.
</p>
<p>This specification uses the term URI, which is defined by <bibref
ref="Berners-Lee"/>, a work in progress expected to update <bibref
ref="RFC1738"/> and <bibref ref="RFC1808"/>. 
</p>
<p>The list of known errors in this specification is 
available at 
<loc href='http://www.w3.org/XML/xml-19980210-errata'>http://www.w3.org/XML/xml-19980210-errata</loc>.</p>
<p>Please report errors in this document to 
<loc href='mailto:xml-editor@w3.org'>xml-editor@w3.org</loc>.
</p>
</status>


<pubstmt>
<p>Chicago, Vancouver, Mountain View, et al.:
World-Wide Web Consortium, XML Working Group, 1996, 1997.</p>
</pubstmt>
<sourcedesc>
<p>Created in electronic form.</p>
</sourcedesc>
<langusage>
<language id='EN'>English</language>
<language id='ebnf'>Extended Backus-Naur Form (formal grammar)</language>
</langusage>
<revisiondesc>
<slist>
<sitem>1997-12-03 : CMSMcQ : yet further changes</sitem>
<sitem>1997-12-02 : TB : further changes (see TB to XML WG,
2 December 1997)</sitem>
<sitem>1997-12-02 : CMSMcQ : deal with as many corrections and
comments from the proofreaders as possible:
entify hard-coded document date in pubdate element,
change expansion of entity WebSGML,
update status description as per Dan Connolly (am not sure
about refernece to Berners-Lee et al.),
add 'The' to abstract as per WG decision,
move Relationship to Existing Standards to back matter and
combine with References,
re-order back matter so normative appendices come first,
re-tag back matter so informative appendices are tagged informdiv1,
remove XXX XXX from list of 'normative' specs in prose,
move some references from Other References to Normative References,
add RFC 1738, 1808, and 2141 to Other References (they are not
normative since we do not require the processor to enforce any 
rules based on them),
add reference to 'Fielding draft' (Berners-Lee et al.),
move notation section to end of body,
drop URIchar non-terminal and use SkipLit instead,
lose stray reference to defunct nonterminal 'markupdecls',
move reference to Aho et al. into appendix (Tim's right),
add prose note saying that hash marks and fragment identifiers are
NOT part of the URI formally speaking, and are NOT legal in 
system identifiers (processor 'may' signal an error).
Work through:
Tim Bray reacting to James Clark,
Tim Bray on his own,
Eve Maler,

NOT DONE YET:
change binary / text to unparsed / parsed.
handle James's suggestion about &lt; in attriubte values
uppercase hex characters,
namechar list,
</sitem>
<sitem>1997-12-01 : JB : add some column-width parameters</sitem>
<sitem>1997-12-01 : CMSMcQ : begin round of changes to incorporate
recent WG decisions and other corrections:
binding sources of character encoding info (27 Aug / 3 Sept),
correct wording of Faust quotation (restore dropped line),
drop SDD from EncodingDecl,
change text at version number 1.0,
drop misleading (wrong!) sentence about ignorables and extenders,
modify definition of PCData to make bar on msc grammatical,
change grammar's handling of internal subset (drop non-terminal markupdecls),
change definition of includeSect to allow conditional sections,
add integral-declaration constraint on internal subset,
drop misleading / dangerous sentence about relationship of
entities with system storage objects,
change table body tag to htbody as per EM change to DTD,
add rule about space normalization in public identifiers,
add description of how to generate our name-space rules from 
Unicode character database (needs further work!).
</sitem>
<sitem>1997-10-08 : TB : Removed %-constructs again, new rules
for PE appearance.</sitem>
<sitem>1997-10-01 : TB : Case-sensitive markup; cleaned up
element-type defs, lotsa little edits for style</sitem>
<sitem>1997-09-25 : TB : Change to elm's new DTD, with
substantial detail cleanup as a side-effect</sitem>
<sitem>1997-07-24 : CMSMcQ : correct error (lost *) in definition 
of ignoreSectContents (thanks to Makoto Murata)</sitem>
<sitem>Allow all empty elements to have end-tags, consistent with
SGML TC (as per JJC).</sitem>
<sitem>1997-07-23 : CMSMcQ : pre-emptive strike on pending corrections:
introduce the term 'empty-element tag', note that all empty elements
may use it, and elements declared EMPTY must use it.
Add WFC requiring encoding decl to come first in an entity.
Redefine notations to point to PIs as well as binary entities.
Change autodetection table by removing bytes 3 and 4 from 
examples with Byte Order Mark.
Add content model as a term and clarify that it applies to both
mixed and element content.
</sitem>
<sitem>1997-06-30 : CMSMcQ : change date, some cosmetic changes,
changes to productions for choice, seq, Mixed, NotationType,
Enumeration.  Follow James Clark's suggestion and prohibit 
conditional sections in internal subset.  TO DO:  simplify
production for ignored sections as a result, since we don't 
need to worry about parsers which don't expand PErefs finding
a conditional section.</sitem>
<sitem>1997-06-29 : TB : various edits</sitem>
<sitem>1997-06-29 : CMSMcQ : further changes:
Suppress old FINAL EDIT comments and some dead material.
Revise occurrences of % in grammar to exploit Henry Thompson's pun,
especially markupdecl and attdef.
Remove RMD requirement relating to element content (?).
</sitem>
<sitem>1997-06-28 : CMSMcQ : Various changes for 1 July draft:
Add text for draconian error handling (introduce
the term Fatal Error).
RE deleta est (changing wording from 
original announcement to restrict the requirement to validating
parsers).
Tag definition of validating processor and link to it.
Add colon as name character.
Change def of %operator.
Change standard definitions of lt, gt, amp.
Strip leading zeros from #x00nn forms.</sitem>
<sitem>1997-04-02 : CMSMcQ : final corrections of editorial errors
found in last night's proofreading.  Reverse course once more on
well-formed:   Webster's Second hyphenates it, and that's enough
for me.</sitem>
<sitem>1997-04-01 : CMSMcQ : corrections from JJC, EM, HT, and self</sitem>
<sitem>1997-03-31 : Tim Bray : many changes</sitem>
<sitem>1997-03-29 : CMSMcQ : some Henry Thompson (on entity handling),
some Charles Goldfarb, some ERB decisions (PE handling in miscellaneous
declarations.  Changed Ident element to accept def attribute.
Allow normalization of Unicode characters.  move def of systemliteral
into section on literals.</sitem>
<sitem>1997-03-28 : CMSMcQ : make as many corrections as possible, from
Terry Allen, Norbert Mikula, James Clark, Jon Bosak, Henry Thompson,
Paul Grosso, and self.  Among other things:  give in on "well formed"
(Terry is right), tentatively rename QuotedCData as AttValue
and Literal as EntityValue to be more informative, since attribute
values are the <emph>only</emph> place QuotedCData was used, and
vice versa for entity text and Literal. (I'd call it Entity Text, 
but 8879 uses that name for both internal and external entities.)</sitem>
<sitem>1997-03-26 : CMSMcQ : resynch the two forks of this draft, reapply
my changes dated 03-20 and 03-21.  Normalize old 'may not' to 'must not'
except in the one case where it meant 'may or may not'.</sitem>
<sitem>1997-03-21 : TB : massive changes on plane flight from Chicago
to Vancouver</sitem>
<sitem>1997-03-21 : CMSMcQ : correct as many reported errors as possible.
</sitem>
<sitem>1997-03-20 : CMSMcQ : correct typos listed in CMSMcQ hand copy of spec.</sitem>
<sitem>1997-03-20 : CMSMcQ : cosmetic changes preparatory to revision for
WWW conference April 1997:  restore some of the internal entity 
references (e.g. to docdate, etc.), change character xA0 to &amp;nbsp;
and define nbsp as &amp;#160;, and refill a lot of paragraphs for
legibility.</sitem>
<sitem>1996-11-12 : CMSMcQ : revise using Tim's edits:
Add list type of NUMBERED and change most lists either to
BULLETS or to NUMBERED.
Suppress QuotedNames, Names (not used).
Correct trivial-grammar doc type decl.
Rename 'marked section' as 'CDATA section' passim.
Also edits from James Clark:
Define the set of characters from which [^abc] subtracts.
Charref should use just [0-9] not Digit.
Location info needs cleaner treatment:  remove?  (ERB
question).
One example of a PI has wrong pic.
Clarify discussion of encoding names.
Encoding failure should lead to unspecified results; don't
prescribe error recovery.
Don't require exposure of entity boundaries.
Ignore white space in element content.
Reserve entity names of the form u-NNNN.
Clarify relative URLs.
And some of my own:
Correct productions for content model:  model cannot
consist of a name, so "elements ::= cp" is no good.
</sitem>
<sitem>1996-11-11 : CMSMcQ : revise for style.
Add new rhs to entity declaration, for parameter entities.</sitem>
<sitem>1996-11-10 : CMSMcQ : revise for style.
Fix / complete section on names, characters.
Add sections on parameter entities, conditional sections.
Still to do:  Add compatibility note on deterministic content models.
Finish stylistic revision.</sitem>
<sitem>1996-10-31 : TB : Add Entity Handling section</sitem>
<sitem>1996-10-30 : TB : Clean up term &amp; termdef.  Slip in
ERB decision re EMPTY.</sitem>
<sitem>1996-10-28 : TB : Change DTD.  Implement some of Michael's
suggestions.  Change comments back to //.  Introduce language for
XML namespace reservation.  Add section on white-space handling.
Lots more cleanup.</sitem>
<sitem>1996-10-24 : CMSMcQ : quick tweaks, implement some ERB
decisions.  Characters are not integers.  Comments are /* */ not //.
Add bibliographic refs to 10646, HyTime, Unicode.
Rename old Cdata as MsData since it's <emph>only</emph> seen
in marked sections.  Call them attribute-value pairs not
name-value pairs, except once.  Internal subset is optional, needs
'?'.  Implied attributes should be signaled to the app, not
have values supplied by processor.</sitem>
<sitem>1996-10-16 : TB : track down &amp; excise all DSD references;
introduce some EBNF for entity declarations.</sitem>
<sitem>1996-10-?? : TB : consistency check, fix up scraps so
they all parse, get formatter working, correct a few productions.</sitem>
<sitem>1996-10-10/11 : CMSMcQ : various maintenance, stylistic, and
organizational changes:
Replace a few literals with xmlpio and
pic entities, to make them consistent and ensure we can change pic
reliably when the ERB votes.
Drop paragraph on recognizers from notation section.
Add match, exact match to terminology.
Move old 2.2 XML Processors and Apps into intro.
Mention comments, PIs, and marked sections in discussion of
delimiter escaping.
Streamline discussion of doctype decl syntax.
Drop old section of 'PI syntax' for doctype decl, and add
section on partial-DTD summary PIs to end of Logical Structures
section.
Revise DSD syntax section to use Tim's subset-in-a-PI
mechanism.</sitem>
<sitem>1996-10-10 : TB : eliminate name recognizers (and more?)</sitem>
<sitem>1996-10-09 : CMSMcQ : revise for style, consistency through 2.3
(Characters)</sitem>
<sitem>1996-10-09 : CMSMcQ : re-unite everything for convenience,
at least temporarily, and revise quickly</sitem>
<sitem>1996-10-08 : TB : first major homogenization pass</sitem>
<sitem>1996-10-08 : TB : turn "current" attribute on div type into 
CDATA</sitem>
<sitem>1996-10-02 : TB : remould into skeleton + entities</sitem>
<sitem>1996-09-30 : CMSMcQ : add a few more sections prior to exchange
                            with Tim.</sitem>
<sitem>1996-09-20 : CMSMcQ : finish transcribing notes.</sitem>
<sitem>1996-09-19 : CMSMcQ : begin transcribing notes for draft.</sitem>
<sitem>1996-09-13 : CMSMcQ : made outline from notes of 09-06,
do some housekeeping</sitem>
</slist>
</revisiondesc>
</header>
<body> 
<div1 id='sec-intro'>
<head>Introduction</head>
<p>Extensible Markup Language, abbreviated XML, describes a class of
data objects called <termref def="dt-xml-doc">XML documents</termref> and
partially describes the behavior of 
computer programs which process them. XML is an application profile or
restricted form of SGML, the Standard Generalized Markup 
Language <bibref ref='ISO8879'/>.
By construction, XML documents 
are conforming SGML documents.
</p>
<p>XML documents are made up of storage units called <termref
def="dt-entity">entities</termref>, which contain either parsed
or unparsed data.
Parsed data is made up of <termref def="dt-character">characters</termref>,
some 
of which form <termref def="dt-chardata">character data</termref>, 
and some of which form <termref def="dt-markup">markup</termref>.
Markup encodes a description of the document's storage layout and
logical structure. XML provides a mechanism to impose constraints on
the storage layout and logical structure.</p>
<p><termdef id="dt-xml-proc" term="XML Processor">A software module
called an <term>XML processor</term> is used to read XML documents
and provide access to their content and structure.</termdef> <termdef
id="dt-app" term="Application">It is assumed that an XML processor is
doing its work on behalf of another module, called the
<term>application</term>.</termdef> This specification describes the
required behavior of an XML processor in terms of how it must read XML
data and the information it must provide to the application.</p>
 
<div2 id='sec-origin-goals'>
<head>Origin and Goals</head>
<p>XML was developed by an XML Working Group (originally known as the
SGML Editorial Review Board) formed under the auspices of the World
Wide Web Consortium (W3C) in 1996.
It was chaired by Jon Bosak of Sun
Microsystems with the active participation of an XML Special
Interest Group (previously known as the SGML Working Group) also
organized by the W3C. The membership of the XML Working Group is given
in an appendix. Dan Connolly served as the WG's contact with the W3C.
</p>
<p>The design goals for XML are:<olist>
<item><p>XML shall be straightforwardly usable over the
Internet.</p></item>
<item><p>XML shall support a wide variety of applications.</p></item>
<item><p>XML shall be compatible with SGML.</p></item>
<item><p>It shall be easy to write programs which process XML
documents.</p></item>
<item><p>The number of optional features in XML is to be kept to the
absolute minimum, ideally zero.</p></item>
<item><p>XML documents should be human-legible and reasonably
clear.</p></item>
<item><p>The XML design should be prepared quickly.</p></item>
<item><p>The design of XML shall be formal and concise.</p></item>
<item><p>XML documents shall be easy to create.</p></item>
<item><p>Terseness in XML markup is of minimal importance.</p></item></olist>
</p>
<p>This specification, 
together with associated standards
(Unicode and ISO/IEC 10646 for characters,
Internet RFC 1766 for language identification tags, 
ISO 639 for language name codes, and 
ISO 3166 for country name codes),
provides all the information necessary to understand 
XML Version &XML.version;
and construct computer programs to process it.</p>
<p>This version of the XML specification
<!-- is for &doc.audience;.-->
&doc.distribution;.</p>

</div2>
 


 
<div2 id='sec-terminology'>
<head>Terminology</head>
 
<p>The terminology used to describe XML documents is defined in the body of
this specification.
The terms defined in the following list are used in building those
definitions and in describing the actions of an XML processor:
<glist>
<gitem>
<label>may</label>
<def><p><termdef id="dt-may" term="May">Conforming documents and XML
processors are permitted to but need not behave as
described.</termdef></p></def>
</gitem>
<gitem>
<label>must</label>
<def><p>Conforming documents and XML processors 
are required to behave as described; otherwise they are in error.
<!-- do NOT change this! this is what defines a violation of
a 'must' clause as 'an error'. -MSM -->
</p></def>
</gitem>
<gitem>
<label>error</label>
<def><p><termdef id='dt-error' term='Error'
>A violation of the rules of this
specification; results are
undefined.  Conforming software may detect and report an error and may
recover from it.</termdef></p></def>
</gitem>
<gitem>
<label>fatal error</label>
<def><p><termdef id="dt-fatal" term="Fatal Error">An error
which a conforming <termref def="dt-xml-proc">XML processor</termref>
must detect and report to the application.
After encountering a fatal error, the
processor may continue
processing the data to search for further errors and may report such
errors to the application.  In order to support correction of errors,
the processor may make unprocessed data from the document (with
intermingled character data and markup) available to the application.
Once a fatal error is detected, however, the processor must not
continue normal processing (i.e., it must not
continue to pass character data and information about the document's
logical structure to the application in the normal way).
</termdef></p></def>
</gitem>
<gitem>
<label>at user option</label>
<def><p>Conforming software may or must (depending on the modal verb in the
sentence) behave as described; if it does, it must
provide users a means to enable or disable the behavior
 described.</p></def>
</gitem>
<gitem>
<label>validity constraint</label>
<def><p>A rule which applies to all 
<termref def="dt-valid">valid</termref> XML documents.
Violations of validity constraints are errors; they must, at user option, 
be reported by 
<termref def="dt-validating">validating XML processors</termref>.</p></def>
</gitem>
<gitem>
<label>well-formedness constraint</label>
<def><p>A rule which applies to all <termref
def="dt-wellformed">well-formed</termref> XML documents.
Violations of well-formedness constraints are 
<termref def="dt-fatal">fatal errors</termref>.</p></def>
</gitem>

<gitem>
<label>match</label>
<def><p><termdef id="dt-match" term="match">(Of strings or names:) 
Two strings or names being compared must be identical.
Characters with multiple possible representations in ISO/IEC 10646 (e.g.
characters with 
both precomposed and base+diacritic forms) match only if they have the
same representation in both strings.
At user option, processors may normalize such characters to
some canonical form.
No case folding is performed. 
(Of strings and rules in the grammar:)  
A string matches a grammatical production if it belongs to the
language generated by that production.
(Of content and content models:)
An element matches its declaration when it conforms
in the fashion described in the constraint
<specref ref='elementvalid'/>.
</termdef>
</p></def>
</gitem>
<gitem>
<label>for compatibility</label>
<def><p><termdef id="dt-compat" term="For Compatibility">A feature of
XML included solely to ensure that XML remains compatible with SGML.
</termdef></p></def>
</gitem>
<gitem>
<label>for interoperability</label>
<def><p><termdef id="dt-interop" term="For interoperability">A
non-binding recommendation included to increase the chances that XML
documents can be processed by the existing installed base of SGML
processors which predate the
&WebSGML;.</termdef></p></def>
</gitem>
</glist>
</p>
</div2>

 
</div1>
<!-- &Docs; -->
 
<div1 id='sec-documents'>
<head>Documents</head>
 
<p><termdef id="dt-xml-doc" term="XML Document">
A data object is an
<term>XML document</term> if it is
<termref def="dt-wellformed">well-formed</termref>, as
defined in this specification.
A well-formed XML document may in addition be
<termref def="dt-valid">valid</termref> if it meets certain further 
constraints.</termdef></p>
 
<p>Each XML document has both a logical and a physical structure.
Physically, the document is composed of units called <termref
def="dt-entity">entities</termref>.  An entity may <termref
def="dt-entref">refer</termref> to other entities to cause their
inclusion in the document. A document begins in a "root"  or <termref
def="dt-docent">document entity</termref>.
Logically, the document is composed of declarations, elements, 
comments,
character references, and
processing
instructions, all of which are indicated in the document by explicit
markup.
The logical and physical structures must nest properly, as described  
in <specref ref='wf-entities'/>.
</p>
 
<div2 id='sec-well-formed'>
<head>Well-Formed XML Documents</head>
 
<p><termdef id="dt-wellformed" term="Well-Formed">
A textual object is 
a well-formed XML document if:</termdef>
<olist>
<item><p>Taken as a whole, it
matches the production labeled <nt def='NT-document'>document</nt>.</p></item>
<item><p>It
meets all the well-formedness constraints given in this specification.</p>
</item>
<item><p>Each of the <termref def='dt-parsedent'>parsed entities</termref> 
which is referenced directly or indirectly within the document is
<titleref href='wf-entities'>well-formed</titleref>.</p></item>
</olist></p>
<p>
<scrap lang='ebnf' id='document'>
<head>Document</head>
<prod id='NT-document'><lhs>document</lhs>
<rhs><nt def='NT-prolog'>prolog</nt> 
<nt def='NT-element'>element</nt> 
<nt def='NT-Misc'>Misc</nt>*</rhs></prod>
</scrap>
</p>
<p>Matching the <nt def="NT-document">document</nt> production 
implies that:
<olist>
<item><p>It contains one or more
<termref def="dt-element">elements</termref>.</p>
</item>
<!--* N.B. some readers (notably JC) find the following
paragraph awkward and redundant.  I agree it's logically redundant:
it *says* it is summarizing the logical implications of
matching the grammar, and that means by definition it's
logically redundant.  I don't think it's rhetorically
redundant or unnecessary, though, so I'm keeping it.  It
could however use some recasting when the editors are feeling
stronger. -MSM *-->
<item><p><termdef id="dt-root" term="Root Element">There is  exactly
one element, called the <term>root</term>, or document element,  no
part of which appears in the <termref
def="dt-content">content</termref> of any other element.</termdef>
For all other elements, if the start-tag is in the content of another
element, the end-tag is in the content of the same element.  More
simply stated, the elements, delimited by start- and end-tags, nest
properly within each other.
</p></item>
</olist>
</p>
<p><termdef id="dt-parentchild" term="Parent/Child">As a consequence 
of this,
for each non-root element
<code>C</code> in the document, there is one other element <code>P</code>
in the document such that 
<code>C</code> is in the content of <code>P</code>, but is not in
the content of any other element that is in the content of
<code>P</code>.  
<code>P</code> is referred to as the
<term>parent</term> of <code>C</code>, and <code>C</code> as a
<term>child</term> of <code>P</code>.</termdef></p></div2>
 
<div2 id="charsets">
<head>Characters</head>
 
<p><termdef id="dt-text" term="Text">A parsed entity contains
<term>text</term>, a sequence of 
<termref def="dt-character">characters</termref>, 
which may represent markup or character data.</termdef> 
<termdef id="dt-character" term="Character">A <term>character</term> 
is an atomic unit of text as specified by
ISO/IEC 10646 <bibref ref="ISO10646"/>.
Legal characters are tab, carriage return, line feed, and the legal
graphic characters of Unicode and ISO/IEC 10646.
The use of "compatibility characters", as defined in section 6.8
of <bibref ref='Unicode'/>, is discouraged.
</termdef> 
<scrap lang="ebnf" id="char32">
<head>Character Range</head>
<prodgroup pcw2="4" pcw4="17.5" pcw5="11">
<prod id="NT-Char"><lhs>Char</lhs> 
<rhs>#x9 | #xA | #xD | [#x20-#xD7FF] | [#xE000-#xFFFD] 
| [#x10000-#x10FFFF]</rhs> 
<com>any Unicode character, excluding the
surrogate blocks, FFFE, and FFFF.</com> </prod>
</prodgroup>
</scrap>
</p>

<p>The mechanism for encoding character code points into bit patterns may
vary from entity to entity. All XML processors must accept the UTF-8
and UTF-16 encodings of 10646; the mechanisms for signaling which of
the two is in use, or for bringing other encodings into play, are
discussed later, in <specref ref='charencoding'/>.
</p>
<!--
<p>Regardless of the specific encoding used, any character in the ISO/IEC
10646 character set may be referred to by the decimal or hexadecimal
equivalent of its 
UCS-4 code value.
</p>-->
</div2>
 
<div2 id='sec-common-syn'>
<head>Common Syntactic Constructs</head>
 
<p>This section defines some symbols used widely in the grammar.</p>
<p><nt def="NT-S">S</nt> (white space) consists of one or more space (#x20)
characters, carriage returns, line feeds, or tabs.

<scrap lang="ebnf" id='white'>
<head>White Space</head>
<prodgroup pcw2="4" pcw4="17.5" pcw5="11">
<prod id='NT-S'><lhs>S</lhs>
<rhs>(#x20 | #x9 | #xD | #xA)+</rhs>
</prod>
</prodgroup>
</scrap></p>
<p>Characters are classified for convenience as letters, digits, or other
characters.  Letters consist of an alphabetic or syllabic 
base character possibly
followed by one or more combining characters, or of an ideographic
character.  
Full definitions of the specific characters in each class
are given in <specref ref='CharClasses'/>.</p>
<p><termdef id="dt-name" term="Name">A <term>Name</term> is a token
beginning with a letter or one of a few punctuation characters, and continuing
with letters, digits, hyphens, underscores, colons, or full stops, together
known as name characters.</termdef>
Names beginning with the string "<code>xml</code>", or any string
which would match <code>(('X'|'x') ('M'|'m') ('L'|'l'))</code>, are
reserved for standardization in this or future versions of this
specification.
</p>
<note>
<p>The colon character within XML names is reserved for experimentation with
name spaces.  
Its meaning is expected to be
standardized at some future point, at which point those documents 
using the colon for experimental purposes may need to be updated.
(There is no guarantee that any name-space mechanism
adopted for XML will in fact use the colon as a name-space delimiter.)
In practice, this means that authors should not use the colon in XML
names except as part of name-space experiments, but that XML processors
should accept the colon as a name character.</p>
</note>
<p>An
<nt def='NT-Nmtoken'>Nmtoken</nt> (name token) is any mixture of
name characters.
<scrap lang='ebnf'>
<head>Names and Tokens</head>
<prod id='NT-NameChar'><lhs>NameChar</lhs>
<rhs><nt def="NT-Letter">Letter</nt> 
| <nt def='NT-Digit'>Digit</nt> 
| '.' | '-' | '_' | ':'
| <nt def='NT-CombiningChar'>CombiningChar</nt> 
| <nt def='NT-Extender'>Extender</nt></rhs>
</prod>
<prod id='NT-Name'><lhs>Name</lhs>
<rhs>(<nt def='NT-Letter'>Letter</nt> | '_' | ':')
(<nt def='NT-NameChar'>NameChar</nt>)*</rhs></prod>
<prod id='NT-Names'><lhs>Names</lhs>
<rhs><nt def='NT-Name'>Name</nt> 
(<nt def='NT-S'>S</nt> <nt def='NT-Name'>Name</nt>)*</rhs></prod>
<prod id='NT-Nmtoken'><lhs>Nmtoken</lhs>
<rhs>(<nt def='NT-NameChar'>NameChar</nt>)+</rhs></prod>
<prod id='NT-Nmtokens'><lhs>Nmtokens</lhs>
<rhs><nt def='NT-Nmtoken'>Nmtoken</nt> (<nt def='NT-S'>S</nt> <nt def='NT-Nmtoken'>Nmtoken</nt>)*</rhs></prod>
</scrap>
</p>
<p>Literal data is any quoted string not containing
the quotation mark used as a delimiter for that string.
Literals are used
for specifying the content of internal entities
(<nt def='NT-EntityValue'>EntityValue</nt>),
the values of attributes (<nt def='NT-AttValue'>AttValue</nt>), 
and external identifiers 
(<nt def="NT-SystemLiteral">SystemLiteral</nt>).  
Note that a <nt def='NT-SystemLiteral'>SystemLiteral</nt>
can be parsed without scanning for markup.
<scrap lang='ebnf'>
<head>Literals</head>
<prod id='NT-EntityValue'><lhs>EntityValue</lhs>
<rhs>'"' 
([^%&amp;"] 
| <nt def='NT-PEReference'>PEReference</nt> 
| <nt def='NT-Reference'>Reference</nt>)*
'"' 
</rhs>
<rhs>|&nbsp; 
"'" 
([^%&amp;'] 
| <nt def='NT-PEReference'>PEReference</nt> 
| <nt def='NT-Reference'>Reference</nt>)* 
"'"</rhs>
</prod>
<prod id='NT-AttValue'><lhs>AttValue</lhs>
<rhs>'"' 
([^&lt;&amp;"] 
| <nt def='NT-Reference'>Reference</nt>)* 
'"' 
</rhs>
<rhs>|&nbsp; 
"'" 
([^&lt;&amp;'] 
| <nt def='NT-Reference'>Reference</nt>)* 
"'"</rhs>
</prod>
<prod id="NT-SystemLiteral"><lhs>SystemLiteral</lhs>
<rhs>('"' [^"]* '"') |&nbsp;("'" [^']* "'")
</rhs>
</prod>
<prod id="NT-PubidLiteral"><lhs>PubidLiteral</lhs>
<rhs>'"' <nt def='NT-PubidChar'>PubidChar</nt>* 
'"' 
| "'" (<nt def='NT-PubidChar'>PubidChar</nt> - "'")* "'"</rhs>
</prod>
<prod id="NT-PubidChar"><lhs>PubidChar</lhs>
<rhs>#x20 | #xD | #xA 
|&nbsp;[a-zA-Z0-9]
|&nbsp;[-'()+,./:=?;!*#@$_%]</rhs>
</prod>
</scrap>
</p>

</div2>

<div2 id='syntax'>
<head>Character Data and Markup</head>
 
<p><termref def='dt-text'>Text</termref> consists of intermingled 
<termref def="dt-chardata">character
data</termref> and markup.
<termdef id="dt-markup" term="Markup"><term>Markup</term> takes the form of
<termref def="dt-stag">start-tags</termref>,
<termref def="dt-etag">end-tags</termref>,
<termref def="dt-empty">empty-element tags</termref>,
<termref def="dt-entref">entity references</termref>,
<termref def="dt-charref">character references</termref>,
<termref def="dt-comment">comments</termref>,
<termref def="dt-cdsection">CDATA section</termref> delimiters,
<termref def="dt-doctype">document type declarations</termref>, and
<termref def="dt-pi">processing instructions</termref>.
</termdef>
</p>
<p><termdef id="dt-chardata" term="Character Data">All text that is not markup
constitutes the <term>character data</term> of
the document.</termdef></p>
<p>The ampersand character (&amp;) and the left angle bracket (&lt;)
may appear in their literal form <emph>only</emph> when used as markup
delimiters, or within a <termref def="dt-comment">comment</termref>, a
<termref def="dt-pi">processing instruction</termref>, 
or a <termref def="dt-cdsection">CDATA section</termref>.  

They are also legal within the <termref def='dt-litentval'>literal entity
value</termref> of an internal entity declaration; see
<specref ref='wf-entities'/>.
<!-- FINAL EDIT:  restore internal entity decl or leave it out. -->
If they are needed elsewhere,
they must be <termref def="dt-escape">escaped</termref>
using either <termref def='dt-charref'>numeric character references</termref>
or the strings
"<code>&amp;amp;</code>" and "<code>&amp;lt;</code>" respectively. 
The right angle
bracket (>) may be represented using the string
"<code>&amp;gt;</code>", and must, <termref def='dt-compat'>for
compatibility</termref>, 
be escaped using
"<code>&amp;gt;</code>" or a character reference 
when it appears in the string
"<code>]]&gt;</code>"
in content, 
when that string is not marking the end of 
a <termref def="dt-cdsection">CDATA section</termref>. 
</p>
<p>
In the content of elements, character data 
is any string of characters which does
not contain the start-delimiter of any markup.  
In a CDATA section, character data
is any string of characters not including the CDATA-section-close
delimiter, "<code>]]&gt;</code>".</p>
<p>
To allow attribute values to contain both single and double quotes, the
apostrophe or single-quote character (') may be represented as
"<code>&amp;apos;</code>", and the double-quote character (") as
"<code>&amp;quot;</code>".
<scrap lang="ebnf">
<head>Character Data</head>
<prod id='NT-CharData'>
<lhs>CharData</lhs>
<rhs>[^&lt;&amp;]* - ([^&lt;&amp;]* ']]&gt;' [^&lt;&amp;]*)</rhs>
</prod>
</scrap>
</p>
</div2>
 
<div2 id='sec-comments'>
<head>Comments</head>
 
<p><termdef id="dt-comment" term="Comment"><term>Comments</term> may 
appear anywhere in a document outside other 
<termref def='dt-markup'>markup</termref>; in addition,
they may appear within the document type declaration
at places allowed by the grammar.
They are not part of the document's <termref def="dt-chardata">character
data</termref>; an XML
processor may, but need not, make it possible for an application to
retrieve the text of comments.
<termref def="dt-compat">For compatibility</termref>, the string
"<code>--</code>" (double-hyphen) must not occur within
comments.
<scrap lang="ebnf">
<head>Comments</head>
<prod id='NT-Comment'><lhs>Comment</lhs>
<rhs>'&lt;!--'
((<nt def='NT-Char'>Char</nt> - '-') 
| ('-' (<nt def='NT-Char'>Char</nt> - '-')))* 
'-->'</rhs>
</prod>
</scrap>
</termdef></p>
<p>An example of a comment:
<eg>&lt;!&como; declarations for &lt;head> &amp; &lt;body> &comc;&gt;</eg>
</p>
</div2>
 
<div2 id='sec-pi'>
<head>Processing Instructions</head>
 
<p><termdef id="dt-pi" term="Processing instruction"><term>Processing
instructions</term> (PIs) allow documents to contain instructions
for applications.
 
<scrap lang="ebnf">
<head>Processing Instructions</head>
<prod id='NT-PI'><lhs>PI</lhs>
<rhs>'&lt;?' <nt def='NT-PITarget'>PITarget</nt> 
(<nt def='NT-S'>S</nt> 
(<nt def='NT-Char'>Char</nt>* - 
(<nt def='NT-Char'>Char</nt>* &pic; <nt def='NT-Char'>Char</nt>*)))?
&pic;</rhs></prod>
<prod id='NT-PITarget'><lhs>PITarget</lhs>
<rhs><nt def='NT-Name'>Name</nt> - 
(('X' | 'x') ('M' | 'm') ('L' | 'l'))</rhs>
</prod>
</scrap></termdef>
PIs are not part of the document's <termref def="dt-chardata">character
data</termref>, but must be passed through to the application. The
PI begins with a target (<nt def='NT-PITarget'>PITarget</nt>) used
to identify the application to which the instruction is directed.  
The target names "<code>XML</code>", "<code>xml</code>", and so on are
reserved for standardization in this or future versions of this
specification.
The 
XML <termref def='dt-notation'>Notation</termref> mechanism
may be used for
formal declaration of PI targets.
</p>
</div2>
 
<div2 id='sec-cdata-sect'>
<head>CDATA Sections</head>
 
<p><termdef id="dt-cdsection" term="CDATA Section"><term>CDATA sections</term>
may occur 
anywhere character data may occur; they are
used to escape blocks of text containing characters which would
otherwise be recognized as markup.  CDATA sections begin with the
string "<code>&lt;![CDATA[</code>" and end with the string
"<code>]]&gt;</code>":
<scrap lang="ebnf">
<head>CDATA Sections</head>
<prod id='NT-CDSect'><lhs>CDSect</lhs>
<rhs><nt def='NT-CDStart'>CDStart</nt> 
<nt def='NT-CData'>CData</nt> 
<nt def='NT-CDEnd'>CDEnd</nt></rhs></prod>
<prod id='NT-CDStart'><lhs>CDStart</lhs>
<rhs>'&lt;![CDATA['</rhs>
</prod>
<prod id='NT-CData'><lhs>CData</lhs>
<rhs>(<nt def='NT-Char'>Char</nt>* - 
(<nt def='NT-Char'>Char</nt>* ']]&gt;' <nt def='NT-Char'>Char</nt>*))
</rhs>
</prod>
<prod id='NT-CDEnd'><lhs>CDEnd</lhs>
<rhs>']]&gt;'</rhs>
</prod>
</scrap>

Within a CDATA section, only the <nt def='NT-CDEnd'>CDEnd</nt> string is
recognized as markup, so that left angle brackets and ampersands may occur in
their literal form; they need not (and cannot) be escaped using
"<code>&amp;lt;</code>" and "<code>&amp;amp;</code>".  CDATA sections
cannot nest.</termdef>
</p>

<p>An example of a CDATA section, in which "<code>&lt;greeting></code>" and 
"<code>&lt;/greeting></code>"
are recognized as <termref def='dt-chardata'>character data</termref>, not
<termref def='dt-markup'>markup</termref>:
<eg>&lt;![CDATA[&lt;greeting>Hello, world!&lt;/greeting>]]&gt;</eg>
</p>
</div2>
 
<div2 id='sec-prolog-dtd'>
<head>Prolog and Document Type Declaration</head>
 
<p><termdef id='dt-xmldecl' term='XML Declaration'>XML documents 
may, and should, 
begin with an <term>XML declaration</term> which specifies
the version of
XML being used.</termdef>
For example, the following is a complete XML document, <termref
def="dt-wellformed">well-formed</termref> but not
<termref def="dt-valid">valid</termref>:
<eg><![CDATA[<?xml version="1.0"?>
<greeting>Hello, world!</greeting>
]]></eg>
and so is this:
<eg><![CDATA[<greeting>Hello, world!</greeting>
]]></eg>
</p>

<p>The version number "<code>1.0</code>" should be used to indicate
conformance to this version of this specification; it is an error
for a document to use the value "<code>1.0</code>" 
if it does not conform to this version of this specification.
It is the intent
of the XML working group to give later versions of this specification
numbers other than "<code>1.0</code>", but this intent does not
indicate a
commitment to produce any future versions of XML, nor if any are produced, to
use any particular numbering scheme.
Since future versions are not ruled out, this construct is provided 
as a means to allow the possibility of automatic version recognition, should
it become necessary.
Processors may signal an error if they receive documents labeled with 
versions they do not support. 
</p>
<p>The function of the markup in an XML document is to describe its
storage and logical structure and to associate attribute-value pairs
with its logical structures.  XML provides a mechanism, the <termref
def="dt-doctype">document type declaration</termref>, to define
constraints on the logical structure and to support the use of
predefined storage units.

<termdef id="dt-valid" term="Validity">An XML document is 
<term>valid</term> if it has an associated document type
declaration and if the document
complies with the constraints expressed in it.</termdef></p>
<p>The document type declaration must appear before
the first <termref def="dt-element">element</termref> in the document.
<scrap lang="ebnf" id='xmldoc'>
<head>Prolog</head>
<prodgroup pcw2="6" pcw4="17.5" pcw5="9">
<prod id='NT-prolog'><lhs>prolog</lhs>
<rhs><nt def='NT-XMLDecl'>XMLDecl</nt>? 
<nt def='NT-Misc'>Misc</nt>* 
(<nt def='NT-doctypedecl'>doctypedecl</nt> 
<nt def='NT-Misc'>Misc</nt>*)?</rhs></prod>
<prod id='NT-XMLDecl'><lhs>XMLDecl</lhs>
<rhs>&xmlpio; 
<nt def='NT-VersionInfo'>VersionInfo</nt> 
<nt def='NT-EncodingDecl'>EncodingDecl</nt>? 
<nt def='NT-SDDecl'>SDDecl</nt>? 
<nt def="NT-S">S</nt>? 
&pic;</rhs>
</prod>
<prod id='NT-VersionInfo'><lhs>VersionInfo</lhs>
<rhs><nt def="NT-S">S</nt> 'version' <nt def='NT-Eq'>Eq</nt> 
(' <nt def="NT-VersionNum">VersionNum</nt> ' 
| " <nt def="NT-VersionNum">VersionNum</nt> ")</rhs>
</prod>
<prod id='NT-Eq'><lhs>Eq</lhs>
<rhs><nt def='NT-S'>S</nt>? '=' <nt def='NT-S'>S</nt>?</rhs></prod>
<prod id="NT-VersionNum">
<lhs>VersionNum</lhs>
<rhs>([a-zA-Z0-9_.:] | '-')+</rhs>
</prod>
<prod id='NT-Misc'><lhs>Misc</lhs>
<rhs><nt def='NT-Comment'>Comment</nt> | <nt def='NT-PI'>PI</nt> | 
<nt def='NT-S'>S</nt></rhs></prod>
</prodgroup>
</scrap></p>

<p><termdef id="dt-doctype" term="Document Type Declaration">The XML
<term>document type declaration</term> 
contains or points to 
<termref def='dt-markupdecl'>markup declarations</termref> 
that provide a grammar for a
class of documents.  
This grammar is known as a document type definition,
or <term>DTD</term>.  
The document type declaration can point to an external subset (a
special kind of 
<termref def='dt-extent'>external entity</termref>) containing markup
declarations, or can 
contain the markup declarations directly in an internal subset, or can do
both.   
The DTD for a document consists of both subsets taken
together.</termdef>
</p>
<p><termdef id="dt-markupdecl" term="markup declaration">
A <term>markup declaration</term> is 
an <termref def="dt-eldecl">element type declaration</termref>, 
an <termref def="dt-attdecl">attribute-list declaration</termref>, 
an <termref def="dt-entdecl">entity declaration</termref>, or
a <termref def="dt-notdecl">notation declaration</termref>.
</termdef>
These declarations may be contained in whole or in part
within <termref def='dt-PE'>parameter entities</termref>,
as described in the well-formedness and validity constraints below.
For fuller information, see
<specref ref="sec-physical-struct"/>.</p>
<scrap lang="ebnf" id='dtd'>
<head>Document Type Definition</head>
<prodgroup pcw2="6" pcw4="17.5" pcw5="9">
<prod id='NT-doctypedecl'><lhs>doctypedecl</lhs>
<rhs>'&lt;!DOCTYPE' <nt def='NT-S'>S</nt> 
<nt def='NT-Name'>Name</nt> (<nt def='NT-S'>S</nt> 
<nt def='NT-ExternalID'>ExternalID</nt>)? 
<nt def='NT-S'>S</nt>? ('[' 
(<nt def='NT-markupdecl'>markupdecl</nt> 
| <nt def='NT-PEReference'>PEReference</nt> 
| <nt def='NT-S'>S</nt>)*
']' 
<nt def='NT-S'>S</nt>?)? '>'</rhs>
<vc def="vc-roottype"/>
</prod>
<prod id='NT-markupdecl'><lhs>markupdecl</lhs>
<rhs><nt def='NT-elementdecl'>elementdecl</nt> 
| <nt def='NT-AttlistDecl'>AttlistDecl</nt> 
| <nt def='NT-EntityDecl'>EntityDecl</nt> 
| <nt def='NT-NotationDecl'>NotationDecl</nt> 
| <nt def='NT-PI'>PI</nt> 
| <nt def='NT-Comment'>Comment</nt>
</rhs>
<vc def='vc-PEinMarkupDecl'/>
<wfc def="wfc-PEinInternalSubset"/>
</prod>

</prodgroup>
</scrap>

<p>The markup declarations may be made up in whole or in part of
the <termref def='dt-repltext'>replacement text</termref> of 
<termref def='dt-PE'>parameter entities</termref>.
The productions later in this specification for
individual nonterminals (<nt def='NT-elementdecl'>elementdecl</nt>,
<nt def='NT-AttlistDecl'>AttlistDecl</nt>, and so on) describe 
the declarations <emph>after</emph> all the parameter entities have been 
<termref def='dt-include'>included</termref>.</p>

<vcnote id="vc-roottype">
<head>Root Element Type</head>
<p>
The <nt def='NT-Name'>Name</nt> in the document type declaration must
match the element type of the <termref def='dt-root'>root element</termref>.
</p>
</vcnote>

<vcnote id='vc-PEinMarkupDecl'>
<head>Proper Declaration/PE Nesting</head>
<p>Parameter-entity 
<termref def='dt-repltext'>replacement text</termref> must be properly nested
with markup declarations. 
That is to say, if either the first character
or the last character of a markup
declaration (<nt def='NT-markupdecl'>markupdecl</nt> above)
is contained in the replacement text for a 
<termref def='dt-PERef'>parameter-entity reference</termref>,
both must be contained in the same replacement text.</p>
</vcnote>
<wfcnote id="wfc-PEinInternalSubset">
<head>PEs in Internal Subset</head>
<p>In the internal DTD subset, 
<termref def='dt-PERef'>parameter-entity references</termref>
can occur only where markup declarations can occur, not
within markup declarations.  (This does not apply to
references that occur in
external parameter entities or to the external subset.)
</p>
</wfcnote>
<p>
Like the internal subset, the external subset and 
any external parameter entities referred to in the DTD 
must consist of a series of complete markup declarations of the types 
allowed by the non-terminal symbol
<nt def="NT-markupdecl">markupdecl</nt>, interspersed with white space
or <termref def="dt-PERef">parameter-entity references</termref>.
However, portions of the contents
of the 
external subset or of external parameter entities may conditionally be ignored
by using 
the <termref def="dt-cond-section">conditional section</termref>
construct; this is not allowed in the internal subset.

<scrap id="ext-Subset">
<head>External Subset</head>
<prodgroup pcw2="6" pcw4="17.5" pcw5="9">
<prod id='NT-extSubset'><lhs>extSubset</lhs>
<rhs><nt def='NT-TextDecl'>TextDecl</nt>?
<nt def='NT-extSubsetDecl'>extSubsetDecl</nt></rhs></prod>
<prod id='NT-extSubsetDecl'><lhs>extSubsetDecl</lhs>
<rhs>(
<nt def='NT-markupdecl'>markupdecl</nt> 
| <nt def='NT-conditionalSect'>conditionalSect</nt> 
| <nt def='NT-PEReference'>PEReference</nt> 
| <nt def='NT-S'>S</nt>
)*</rhs>
</prod>
</prodgroup>
</scrap></p>
<p>The external subset and external parameter entities also differ 
from the internal subset in that in them,
<termref def="dt-PERef">parameter-entity references</termref>
are permitted <emph>within</emph> markup declarations,
not only <emph>between</emph> markup declarations.</p>
<p>An example of an XML document with a document type declaration:
<eg><![CDATA[<?xml version="1.0"?>
<!DOCTYPE greeting SYSTEM "hello.dtd">
<greeting>Hello, world!</greeting>
]]></eg>
The <termref def="dt-sysid">system identifier</termref> 
"<code>hello.dtd</code>" gives the URI of a DTD for the document.</p>
<p>The declarations can also be given locally, as in this 
example:
<eg><![CDATA[<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE greeting [
  <!ELEMENT greeting (#PCDATA)>
]>
<greeting>Hello, world!</greeting>
]]></eg>
If both the external and internal subsets are used, the 
internal subset is considered to occur before the external subset.
<!-- 'is considered to'? boo. whazzat mean? -->
This has the effect that entity and attribute-list declarations in the
internal subset take precedence over those in the external subset.
</p>
</div2>
 
<div2 id='sec-rmd'>
<head>Standalone Document Declaration</head>
<p>Markup declarations can affect the content of the document,
as passed from an <termref def="dt-xml-proc">XML processor</termref> 
to an application; examples are attribute defaults and entity
declarations.
The standalone document declaration,
which may appear as a component of the XML declaration, signals
whether or not there are such declarations which appear external to 
the <termref def='dt-docent'>document entity</termref>.
<scrap lang="ebnf" id='fulldtd'>
<head>Standalone Document Declaration</head>
<prodgroup pcw2="4" pcw4="19.5" pcw5="9">
<prod id='NT-SDDecl'><lhs>SDDecl</lhs>
<rhs>
<nt def="NT-S">S</nt> 
'standalone' <nt def='NT-Eq'>Eq</nt> 
(("'" ('yes' | 'no') "'") | ('"' ('yes' | 'no') '"'))
</rhs>
<vc def='vc-check-rmd'/></prod>
</prodgroup>
</scrap></p>
<p>
In a standalone document declaration, the value "<code>yes</code>" indicates
that there 
are no markup declarations external to the <termref def='dt-docent'>document
entity</termref> (either in the DTD external subset, or in an
external parameter entity referenced from the internal subset)
which affect the information passed from the XML processor to
the application.  
The value "<code>no</code>" indicates that there are or may be such
external markup declarations.
Note that the standalone document declaration only 
denotes the presence of external <emph>declarations</emph>; the presence, in a
document, of 
references to external <emph>entities</emph>, when those entities are
internally declared, 
does not change its standalone status.</p>
<p>If there are no external markup declarations, the standalone document
declaration has no meaning. 
If there are external markup declarations but there is no standalone
document declaration, the value "<code>no</code>" is assumed.</p>
<p>Any XML document for which <code>standalone="no"</code> holds can 
be converted algorithmically to a standalone document, 
which may be desirable for some network delivery applications.</p>
<vcnote id='vc-check-rmd'>
<head>Standalone Document Declaration</head>
<p>The standalone document declaration must have
the value "<code>no</code>" if any external markup declarations
contain declarations of:</p><ulist>
<item><p>attributes with <termref def="dt-default">default</termref> values, if
elements to which
these attributes apply appear in the document without
specifications of values for these attributes, or</p></item>
<item><p>entities (other than &magicents;), 
if <termref def="dt-entref">references</termref> to those
entities appear in the document, or</p>
</item>
<item><p>attributes with values subject to
<titleref href='AVNormalize'>normalization</titleref>, where the
attribute appears in the document with a value which will
change as a result of normalization, or</p>
</item>
<item>
<p>element types with <termref def="dt-elemcontent">element content</termref>, 
if white space occurs
directly within any instance of those types.
</p></item>
</ulist>

</vcnote>
<p>An example XML declaration with a standalone document declaration:<eg
>&lt;?xml version="&XML.version;" standalone='yes'?></eg></p>
</div2>
<div2 id='sec-white-space'>
<head>White Space Handling</head>

<p>In editing XML documents, it is often convenient to use "white space"
(spaces, tabs, and blank lines, denoted by the nonterminal 
<nt def='NT-S'>S</nt> in this specification) to
set apart the markup for greater readability.  Such white space is typically
not intended for inclusion in the delivered version of the document.
On the other hand, "significant" white space that should be preserved in the
delivered version is common, for example in poetry and
source code.</p>
<p>An <termref def='dt-xml-proc'>XML processor</termref> 
must always pass all characters in a document that are not
markup through to the application.   A <termref def='dt-validating'>
validating XML processor</termref> must also inform the application
which  of these characters constitute white space appearing
in <termref def="dt-elemcontent">element content</termref>.
</p>
<p>A special <termref def='dt-attr'>attribute</termref> 
named <kw>xml:space</kw> may be attached to an element
to signal an intention that in that element,
white space should be preserved by applications.
In valid documents, this attribute, like any other, must be 
<termref def="dt-attdecl">declared</termref> if it is used.
When declared, it must be given as an 
<termref def='dt-enumerated'>enumerated type</termref> whose only
possible values are "<code>default</code>" and "<code>preserve</code>".
For example:<eg><![CDATA[    <!ATTLIST poem   xml:space (default|preserve) 'preserve'>]]></eg></p>
<p>The value "<code>default</code>" signals that applications'
default white-space processing modes are acceptable for this element; the
value "<code>preserve</code>" indicates the intent that applications preserve
all the white space.
This declared intent is considered to apply to all elements within the content
of the element where it is specified, unless overriden with another instance
of the <kw>xml:space</kw> attribute.
</p>
<p>The <termref def='dt-root'>root element</termref> of any document
is considered to have signaled no intentions as regards application space
handling, unless it provides a value for 
this attribute or the attribute is declared with a default value.
</p>

</div2>
<div2 id='sec-line-ends'>
<head>End-of-Line Handling</head>
<p>XML <termref def='dt-parsedent'>parsed entities</termref> are often stored in
computer files which, for editing convenience, are organized into lines.
These lines are typically separated by some combination of the characters
carriage-return (#xD) and line-feed (#xA).</p>
<p>To simplify the tasks of <termref def='dt-app'>applications</termref>,
wherever an external parsed entity or the literal entity value
of an internal parsed entity contains either the literal 
two-character sequence "#xD#xA" or a standalone literal
#xD, an <termref def='dt-xml-proc'>XML processor</termref> must 
pass to the application the single character #xA.
(This behavior can 
conveniently be produced by normalizing all 
line breaks to #xA on input, before parsing.)
</p>
</div2>
<div2 id='sec-lang-tag'>
<head>Language Identification</head>
<p>In document processing, it is often useful to
identify the natural or formal language 
in which the content is 
written.
A special <termref def="dt-attr">attribute</termref> named
<kw>xml:lang</kw> may be inserted in
documents to specify the 
language used in the contents and attribute values 
of any element in an XML document.
In valid documents, this attribute, like any other, must be 
<termref def="dt-attdecl">declared</termref> if it is used.
The values of the attribute are language identifiers as defined
by <bibref ref="RFC1766"/>, "Tags for the Identification of Languages":
<scrap lang='ebnf'>
<head>Language Identification</head>
<prod id='NT-LanguageID'><lhs>LanguageID</lhs>
<rhs><nt def='NT-Langcode'>Langcode</nt> 
('-' <nt def='NT-Subcode'>Subcode</nt>)*</rhs></prod>
<prod id='NT-Langcode'><lhs>Langcode</lhs>
<rhs><nt def='NT-ISO639Code'>ISO639Code</nt> | 
<nt def='NT-IanaCode'>IanaCode</nt> | 
<nt def='NT-UserCode'>UserCode</nt></rhs>
</prod>
<prod id='NT-ISO639Code'><lhs>ISO639Code</lhs>
<rhs>([a-z] | [A-Z]) ([a-z] | [A-Z])</rhs></prod>
<prod id='NT-IanaCode'><lhs>IanaCode</lhs>
<rhs>('i' | 'I') '-' ([a-z] | [A-Z])+</rhs></prod>
<prod id='NT-UserCode'><lhs>UserCode</lhs>
<rhs>('x' | 'X') '-' ([a-z] | [A-Z])+</rhs></prod>
<prod id='NT-Subcode'><lhs>Subcode</lhs>
<rhs>([a-z] | [A-Z])+</rhs></prod>
</scrap>
The <nt def='NT-Langcode'>Langcode</nt> may be any of the following:
<ulist>
<item><p>a two-letter language code as defined by 
<bibref ref="ISO639"/>, "Codes
for the representation of names of languages"</p></item>
<item><p>a language identifier registered with the Internet
Assigned Numbers Authority <bibref ref='IANA'/>; these begin with the 
prefix "<code>i-</code>" (or "<code>I-</code>")</p></item>
<item><p>a language identifier assigned by the user, or agreed on
between parties in private use; these must begin with the
prefix "<code>x-</code>" or "<code>X-</code>" in order to ensure that they do not conflict 
with names later standardized or registered with IANA</p></item>
</ulist></p>
<p>There may be any number of <nt def='NT-Subcode'>Subcode</nt> segments; if
the first 
subcode segment exists and the Subcode consists of two 
letters, then it must be a country code from 
<bibref ref="ISO3166"/>, "Codes 
for the representation of names of countries."
If the first 
subcode consists of more than two letters, it must be
a subcode for the language in question registered with IANA,
unless the <nt def='NT-Langcode'>Langcode</nt> begins with the prefix 
"<code>x-</code>" or
"<code>X-</code>". </p>
<p>It is customary to give the language code in lower case, and
the country code (if any) in upper case.
Note that these values, unlike other names in XML documents,
are case insensitive.</p>
<p>For example:
<eg><![CDATA[<p xml:lang="en">The quick brown fox jumps over the lazy dog.</p>
<p xml:lang="en-GB">What colour is it?</p>
<p xml:lang="en-US">What color is it?</p>
<sp who="Faust" desc='leise' xml:lang="de">
  <l>Habe nun, ach! Philosophie,</l>
  <l>Juristerei, und Medizin</l>
  <l>und leider auch Theologie</l>
  <l>durchaus studiert mit hei�em Bem�h'n.</l>
  </sp>]]></eg></p>
<!--<p>The xml:lang value is considered to apply both to the contents of an
element and 
(unless otherwise via attribute default values) to the
values of all of its attributes with free-text (CDATA) values.  -->
<p>The intent declared with <kw>xml:lang</kw> is considered to apply to
all attributes and content of the element where it is specified,
unless overridden with an instance of <kw>xml:lang</kw>
on another element within that content.</p>
<!--
If no
value is specified for xml:lang on an element, and no default value is
defined for it in the DTD, then the xml:lang attribute of any element
takes the same value it has in the parent element, if any.  The two
technical terms in the following example both have the same effective
value for xml:lang:

  <p xml:lang="en">Here the keywords are
  <term xml:lang="en">shift</term> and
  <term>reduce</term>. ...</p>

The application, not the XML processor, is responsible for this '
inheritance' of attribute values.
-->
<p>A simple declaration for <kw>xml:lang</kw> might take
the form
<eg>xml:lang  NMTOKEN  #IMPLIED</eg>
but specific default values may also be given, if appropriate.  In a
collection of French poems for English students, with glosses and
notes in English, the xml:lang attribute might be declared this way:
<eg><![CDATA[    <!ATTLIST poem   xml:lang NMTOKEN 'fr'>
    <!ATTLIST gloss  xml:lang NMTOKEN 'en'>
    <!ATTLIST note   xml:lang NMTOKEN 'en'>]]></eg>
</p>

</div2>
</div1>
<!-- &Elements; -->
 
<div1 id='sec-logical-struct'>
<head>Logical Structures</head>
 
<p><termdef id="dt-element" term="Element">Each <termref
def="dt-xml-doc">XML document</termref> contains one or more
<term>elements</term>, the boundaries of which are 
either delimited by <termref def="dt-stag">start-tags</termref> 
and <termref def="dt-etag">end-tags</termref>, or, for <termref
def="dt-empty">empty</termref> elements, by an <termref
def="dt-eetag">empty-element tag</termref>. Each element has a type,
identified by name, sometimes called its "generic
identifier" (GI), and may have a set of
attribute specifications.</termdef>  Each attribute specification 
has a <termref
def="dt-attrname">name</termref> and a <termref
def="dt-attrval">value</termref>.
</p>
<scrap lang='ebnf'><head>Element</head>
<prod id='NT-element'><lhs>element</lhs>
<rhs><nt def='NT-EmptyElemTag'>EmptyElemTag</nt></rhs>
<rhs>| <nt def='NT-STag'>STag</nt> <nt def='NT-content'>content</nt> 
<nt def='NT-ETag'>ETag</nt></rhs>
<wfc def='GIMatch'/>
<vc def='elementvalid'/>
</prod>
</scrap>
<p>This specification does not constrain the semantics, use, or (beyond
syntax) names of the element types and attributes, except that names
beginning with a match to <code>(('X'|'x')('M'|'m')('L'|'l'))</code>
are reserved for standardization in this or future versions of this
specification.
</p>
<wfcnote id='GIMatch'>
<head>Element Type Match</head>
<p>
The <nt def='NT-Name'>Name</nt> in an element's end-tag must match 
the element type in
the start-tag.
</p>
</wfcnote>
<vcnote id='elementvalid'>
<head>Element Valid</head>
<p>An element is
valid if
there is a declaration matching 
<nt def='NT-elementdecl'>elementdecl</nt> where the
<nt def='NT-Name'>Name</nt> matches the element type, and
one of the following holds:</p>
<olist>
<item><p>The declaration matches <kw>EMPTY</kw> and the element has no 
<termref def='dt-content'>content</termref>.</p></item>
<item><p>The declaration matches <nt def='NT-children'>children</nt> and
the sequence of 
<termref def="dt-parentchild">child elements</termref>
belongs to the language generated by the regular expression in
the content model, with optional white space (characters 
matching the nonterminal <nt def='NT-S'>S</nt>) between each pair
of child elements.</p></item>
<item><p>The declaration matches <nt def='NT-Mixed'>Mixed</nt> and 
the content consists of <termref def='dt-chardata'>character 
data</termref> and <termref def='dt-parentchild'>child elements</termref>
whose types match names in the content model.</p></item>
<item><p>The declaration matches <kw>ANY</kw>, and the types
of any <termref def='dt-parentchild'>child elements</termref> have
been declared.</p></item>
</olist>
</vcnote>

<div2 id='sec-starttags'>
<head>Start-Tags, End-Tags, and Empty-Element Tags</head>
 
<p><termdef id="dt-stag" term="Start-Tag">The beginning of every
non-empty XML element is marked by a <term>start-tag</term>.
<scrap lang='ebnf'>
<head>Start-tag</head>
<prodgroup pcw2="6" pcw4="15" pcw5="11.5">
<prod id='NT-STag'><lhs>STag</lhs>
<rhs>'&lt;' <nt def='NT-Name'>Name</nt> 
(<nt def='NT-S'>S</nt> <nt def='NT-Attribute'>Attribute</nt>)* 
<nt def='NT-S'>S</nt>? '>'</rhs>
<wfc def="uniqattspec"/>
</prod>
<prod id='NT-Attribute'><lhs>Attribute</lhs>
<rhs><nt def='NT-Name'>Name</nt> <nt def='NT-Eq'>Eq</nt> 
<nt def='NT-AttValue'>AttValue</nt></rhs>
<vc def='ValueType'/>
<wfc def='NoExternalRefs'/>
<wfc def='CleanAttrVals'/></prod>
</prodgroup>
</scrap>
The <nt def='NT-Name'>Name</nt> in
the start- and end-tags gives the 
element's <term>type</term>.</termdef>
<termdef id="dt-attr" term="Attribute">
The <nt def='NT-Name'>Name</nt>-<nt def='NT-AttValue'>AttValue</nt> pairs are
referred to as 
the <term>attribute specifications</term> of the element</termdef>,
<termdef id="dt-attrname" term="Attribute Name">with the 
<nt def='NT-Name'>Name</nt> in each pair
referred to as the <term>attribute name</term></termdef> and
<termdef id="dt-attrval" term="Attribute Value">the content of the
<nt def='NT-AttValue'>AttValue</nt> (the text between the
<code>'</code> or <code>"</code> delimiters)
as the <term>attribute value</term>.</termdef>
</p>
<wfcnote id='uniqattspec'>
<head>Unique Att Spec</head>
<p>
No attribute name may appear more than once in the same start-tag
or empty-element tag.
</p>
</wfcnote>
<vcnote id='ValueType'>
<head>Attribute Value Type</head>
<p>
The attribute must have been declared; the value must be of the type 
declared for it.
(For attribute types, see <specref ref='attdecls'/>.)
</p>
</vcnote>
<wfcnote id='NoExternalRefs'>
<head>No External Entity References</head>
<p>
Attribute values cannot contain direct or indirect entity references 
to external entities.
</p>
</wfcnote>
<wfcnote id='CleanAttrVals'>
<head>No <code>&lt;</code> in Attribute Values</head>
<p>The <termref def='dt-repltext'>replacement text</termref> of any entity
referred to directly or indirectly in an attribute
value (other than "<code>&amp;lt;</code>") must not contain
a <code>&lt;</code>.
</p></wfcnote>
<p>An example of a start-tag:
<eg>&lt;termdef id="dt-dog" term="dog"></eg></p>
<p><termdef id="dt-etag" term="End Tag">The end of every element 
that begins with a start-tag must
be marked by an <term>end-tag</term>
containing a name that echoes the element's type as given in the
start-tag:
<scrap lang='ebnf'>
<head>End-tag</head>
<prodgroup pcw2="6" pcw4="15" pcw5="11.5">
<prod id='NT-ETag'><lhs>ETag</lhs>
<rhs>'&lt;/' <nt def='NT-Name'>Name</nt> 
<nt def='NT-S'>S</nt>? '>'</rhs></prod>
</prodgroup>
</scrap>
</termdef></p>
<p>An example of an end-tag:<eg>&lt;/termdef></eg></p>
<p><termdef id="dt-content" term="Content">The 
<termref def='dt-text'>text</termref> between the start-tag and
end-tag is called the element's
<term>content</term>:
<scrap lang='ebnf'>
<head>Content of Elements</head>
<prodgroup pcw2="6" pcw4="15" pcw5="11.5">
<prod id='NT-content'><lhs>content</lhs>
<rhs>(<nt def='NT-element'>element</nt> | <nt def='NT-CharData'>CharData</nt> 
| <nt def='NT-Reference'>Reference</nt> | <nt def='NT-CDSect'>CDSect</nt> 
| <nt def='NT-PI'>PI</nt> | <nt def='NT-Comment'>Comment</nt>)*</rhs>
</prod>
</prodgroup>
</scrap>
</termdef></p>
<p><termdef id="dt-empty" term="Empty">If an element is <term>empty</term>,
it must be represented either by a start-tag immediately followed
by an end-tag or by an empty-element tag.</termdef>
<termdef id="dt-eetag" term="empty-element tag">An 
<term>empty-element tag</term> takes a special form:
<scrap lang='ebnf'>
<head>Tags for Empty Elements</head>
<prodgroup pcw2="6" pcw4="15" pcw5="11.5">
<prod id='NT-EmptyElemTag'><lhs>EmptyElemTag</lhs>
<rhs>'&lt;' <nt def='NT-Name'>Name</nt> (<nt def='NT-S'>S</nt> 
<nt def='NT-Attribute'>Attribute</nt>)* <nt def='NT-S'>S</nt>? 
'/&gt;'</rhs>
<wfc def="uniqattspec"/>
</prod>
</prodgroup>
</scrap>
</termdef></p>
<p>Empty-element tags may be used for any element which has no
content, whether or not it is declared using the keyword
<kw>EMPTY</kw>.
<termref def='dt-interop'>For interoperability</termref>, the empty-element
tag must be used, and can only be used, for elements which are
<termref def='dt-eldecl'>declared</termref> <kw>EMPTY</kw>.</p>
<p>Examples of empty elements:
<eg>&lt;IMG align="left"
 src="http://www.w3.org/Icons/WWW/w3c_home" />
&lt;br>&lt;/br>
&lt;br/></eg></p>
</div2>
 
<div2 id='elemdecls'>
<head>Element Type Declarations</head>
 
<p>The <termref def="dt-element">element</termref> structure of an
<termref def="dt-xml-doc">XML document</termref> may, for 
<termref def="dt-valid">validation</termref> purposes, 
be constrained
using element type and attribute-list declarations.
An element type declaration constrains the element's
<termref def="dt-content">content</termref>.
</p>

<p>Element type declarations often constrain which element types can
appear as <termref def="dt-parentchild">children</termref> of the element.
At user option, an XML processor may issue a warning
when a declaration mentions an element type for which no declaration
is provided, but this is not an error.</p>
<p><termdef id="dt-eldecl" term="Element Type declaration">An <term>element
type declaration</term> takes the form:
<scrap lang='ebnf'>
<head>Element Type Declaration</head>
<prodgroup pcw2="5.5" pcw4="18" pcw5="9">
<prod id='NT-elementdecl'><lhs>elementdecl</lhs>
<rhs>'&lt;!ELEMENT' <nt def='NT-S'>S</nt> 
<nt def='NT-Name'>Name</nt> 
<nt def='NT-S'>S</nt> 
<nt def='NT-contentspec'>contentspec</nt>
<nt def='NT-S'>S</nt>? '>'</rhs>
<vc def='EDUnique'/></prod>
<prod id='NT-contentspec'><lhs>contentspec</lhs>
<rhs>'EMPTY' 
| 'ANY' 
| <nt def='NT-Mixed'>Mixed</nt> 
| <nt def='NT-children'>children</nt>
</rhs>
</prod>
</prodgroup>
</scrap>
where the <nt def='NT-Name'>Name</nt> gives the element type 
being declared.</termdef>
</p>

<vcnote id='EDUnique'>
<head>Unique Element Type Declaration</head>
<p>
No element type may be declared more than once.
</p>
</vcnote>

<p>Examples of element type declarations:
<eg>&lt;!ELEMENT br EMPTY>
&lt;!ELEMENT p (#PCDATA|emph)* >
&lt;!ELEMENT %name.para; %content.para; >
&lt;!ELEMENT container ANY></eg></p>
 
<div3 id='sec-element-content'>
<head>Element Content</head>
 
<p><termdef id='dt-elemcontent' term='Element content'>An element <termref
def="dt-stag">type</termref> has
<term>element content</term> when elements of that
type must contain only <termref def='dt-parentchild'>child</termref> 
elements (no character data), optionally separated by 
white space (characters matching the nonterminal 
<nt def='NT-S'>S</nt>).
</termdef>
In this case, the
constraint includes a content model, a simple grammar governing
the allowed types of the child
elements and the order in which they are allowed to appear.  
The grammar is built on
content particles (<nt def='NT-cp'>cp</nt>s), which consist of names, 
choice lists of content particles, or
sequence lists of content particles:
<scrap lang='ebnf'>
<head>Element-content Models</head>
<prodgroup pcw2="5.5" pcw4="16" pcw5="11">
<prod id='NT-children'><lhs>children</lhs>
<rhs>(<nt def='NT-choice'>choice</nt> 
| <nt def='NT-seq'>seq</nt>) 
('?' | '*' | '+')?</rhs></prod>
<prod id='NT-cp'><lhs>cp</lhs>
<rhs>(<nt def='NT-Name'>Name</nt> 
| <nt def='NT-choice'>choice</nt> 
| <nt def='NT-seq'>seq</nt>) 
('?' | '*' | '+')?</rhs></prod>
<prod id='NT-choice'><lhs>choice</lhs>
<rhs>'(' <nt def='NT-S'>S</nt>? cp 
( <nt def='NT-S'>S</nt>? '|' <nt def='NT-S'>S</nt>? <nt def='NT-cp'>cp</nt> )*
<nt def='NT-S'>S</nt>? ')'</rhs>
<vc def='vc-PEinGroup'/></prod>
<prod id='NT-seq'><lhs>seq</lhs>
<rhs>'(' <nt def='NT-S'>S</nt>? cp 
( <nt def='NT-S'>S</nt>? ',' <nt def='NT-S'>S</nt>? <nt def='NT-cp'>cp</nt> )*
<nt def='NT-S'>S</nt>? ')'</rhs>
<vc def='vc-PEinGroup'/></prod>

</prodgroup>
</scrap>
where each <nt def='NT-Name'>Name</nt> is the type of an element which may
appear as a <termref def="dt-parentchild">child</termref>.  
Any content
particle in a choice list may appear in the <termref
def="dt-elemcontent">element content</termref> at the location where
the choice list appears in the grammar;
content particles occurring in a sequence list must each
appear in the <termref def="dt-elemcontent">element content</termref> in the
order given in the list.  
The optional character following a name or list governs
whether the element or the content particles in the list may occur one
or more (<code>+</code>), zero or more (<code>*</code>), or zero or 
one times (<code>?</code>).  
The absence of such an operator means that the element or content particle
must appear exactly once.
This syntax
and meaning are identical to those used in the productions in this
specification.</p>
<p>
The content of an element matches a content model if and only if it is
possible to trace out a path through the content model, obeying the
sequence, choice, and repetition operators and matching each element in
the content against an element type in the content model.  <termref
def='dt-compat'>For compatibility</termref>, it is an error
if an element in the document can
match more than one occurrence of an element type in the content model.
For more information, see <specref ref="determinism"/>.
<!-- appendix <specref ref="determinism"/>. -->
<!-- appendix on deterministic content models. -->
</p>
<vcnote id='vc-PEinGroup'>
<head>Proper Group/PE Nesting</head>
<p>Parameter-entity 
<termref def='dt-repltext'>replacement text</termref> must be properly nested
with parenthetized groups.
That is to say, if either of the opening or closing parentheses
in a <nt def='NT-choice'>choice</nt>, <nt def='NT-seq'>seq</nt>, or
<nt def='NT-Mixed'>Mixed</nt> construct 
is contained in the replacement text for a 
<termref def='dt-PERef'>parameter entity</termref>,
both must be contained in the same replacement text.</p>
<p><termref def='dt-interop'>For interoperability</termref>, 
if a parameter-entity reference appears in a 
<nt def='NT-choice'>choice</nt>, <nt def='NT-seq'>seq</nt>, or
<nt def='NT-Mixed'>Mixed</nt> construct, its replacement text
should not be empty, and 
neither the first nor last non-blank
character of the replacement text should be a connector 
(<code>|</code> or <code>,</code>).
</p>
</vcnote>
<p>Examples of element-content models:
<eg>&lt;!ELEMENT spec (front, body, back?)>
&lt;!ELEMENT div1 (head, (p | list | note)*, div2*)>
&lt;!ELEMENT dictionary-body (%div.mix; | %dict.mix;)*></eg></p>
</div3>

<div3 id='sec-mixed-content'>
<head>Mixed Content</head>
 
<p><termdef id='dt-mixed' term='Mixed Content'>An element 
<termref def='dt-stag'>type</termref> has 
<term>mixed content</term> when elements of that type may contain
character data, optionally interspersed with
<termref def="dt-parentchild">child</termref> elements.</termdef>
In this case, the types of the child elements
may be constrained, but not their order or their number of occurrences:
<scrap lang='ebnf'>
<head>Mixed-content Declaration</head>
<prodgroup pcw2="5.5" pcw4="16" pcw5="11">
<prod id='NT-Mixed'><lhs>Mixed</lhs>
<rhs>'(' <nt def='NT-S'>S</nt>? 
'#PCDATA'
(<nt def='NT-S'>S</nt>? 
'|' 
<nt def='NT-S'>S</nt>? 
<nt def='NT-Name'>Name</nt>)* 
<nt def='NT-S'>S</nt>? 
')*' </rhs>
<rhs>| '(' <nt def='NT-S'>S</nt>? '#PCDATA' <nt def='NT-S'>S</nt>? ')'
</rhs><vc def='vc-PEinGroup'/>
<vc def='vc-MixedChildrenUnique'/>
</prod>

</prodgroup>
</scrap>
where the <nt def='NT-Name'>Name</nt>s give the types of elements
that may appear as children.
</p>
<vcnote id='vc-MixedChildrenUnique'>
<head>No Duplicate Types</head>
<p>The same name must not appear more than once in a single mixed-content
declaration.
</p></vcnote>
<p>Examples of mixed content declarations:
<eg>&lt;!ELEMENT p (#PCDATA|a|ul|b|i|em)*>
&lt;!ELEMENT p (#PCDATA | %font; | %phrase; | %special; | %form;)* >
&lt;!ELEMENT b (#PCDATA)></eg></p>
</div3>
</div2>
 
<div2 id='attdecls'>
<head>Attribute-List Declarations</head>
 
<p><termref def="dt-attr">Attributes</termref> are used to associate
name-value pairs with <termref def="dt-element">elements</termref>.
Attribute specifications may appear only within <termref
def="dt-stag">start-tags</termref>
and <termref def="dt-eetag">empty-element tags</termref>; 
thus, the productions used to
recognize them appear in <specref ref='sec-starttags'/>.  
Attribute-list
declarations may be used:
<ulist>
<item><p>To define the set of attributes pertaining to a given
element type.</p></item>
<item><p>To establish type constraints for these
attributes.</p></item>
<item><p>To provide <termref def="dt-default">default values</termref>
for attributes.</p></item>
</ulist>
</p>
<p><termdef id="dt-attdecl" term="Attribute-List Declaration">
<term>Attribute-list declarations</term> specify the name, data type, and default
value (if any) of each attribute associated with a given element type:
<scrap lang='ebnf'>
<head>Attribute-list Declaration</head>
<prod id='NT-AttlistDecl'><lhs>AttlistDecl</lhs>
<rhs>'&lt;!ATTLIST' <nt def='NT-S'>S</nt> 
<nt def='NT-Name'>Name</nt> 
<nt def='NT-AttDef'>AttDef</nt>*
<nt def='NT-S'>S</nt>? '&gt;'</rhs>
</prod>
<prod id='NT-AttDef'><lhs>AttDef</lhs>
<rhs><nt def='NT-S'>S</nt> <nt def='NT-Name'>Name</nt> 
<nt def='NT-S'>S</nt> <nt def='NT-AttType'>AttType</nt> 
<nt def='NT-S'>S</nt> <nt def='NT-DefaultDecl'>DefaultDecl</nt></rhs>
</prod>
</scrap>
The <nt def="NT-Name">Name</nt> in the
<nt def='NT-AttlistDecl'>AttlistDecl</nt> rule is the type of an element.  At
user option, an XML processor may issue a warning if attributes are
declared for an element type not itself declared, but this is not an
error.  The <nt def='NT-Name'>Name</nt> in the 
<nt def='NT-AttDef'>AttDef</nt> rule is
the name of the attribute.</termdef></p>
<p>
When more than one <nt def='NT-AttlistDecl'>AttlistDecl</nt> is provided for a
given element type, the contents of all those provided are merged.  When
more than one definition is provided for the same attribute of a
given element type, the first declaration is binding and later
declarations are ignored.  
<termref def='dt-interop'>For interoperability,</termref> writers of DTDs
may choose to provide at most one attribute-list declaration
for a given element type, at most one attribute definition
for a given attribute name, and at least one attribute definition
in each attribute-list declaration.
For interoperability, an XML processor may at user option
issue a warning when more than one attribute-list declaration is
provided for a given element type, or more than one attribute definition
is provided 
for a given attribute, but this is not an error.
</p>

<div3 id='sec-attribute-types'>
<head>Attribute Types</head>
 
<p>XML attribute types are of three kinds:  a string type, a
set of tokenized types, and enumerated types.  The string type may take
any literal string as a value; the tokenized types have varying lexical
and semantic constraints, as noted:
<scrap lang='ebnf'>
<head>Attribute Types</head>
<prodgroup pcw4="14" pcw5="11.5">
<prod id='NT-AttType'><lhs>AttType</lhs>
<rhs><nt def='NT-StringType'>StringType</nt> 
| <nt def='NT-TokenizedType'>TokenizedType</nt> 
| <nt def='NT-EnumeratedType'>EnumeratedType</nt>
</rhs>
</prod>
<prod id='NT-StringType'><lhs>StringType</lhs>
<rhs>'CDATA'</rhs>
</prod>
<prod id='NT-TokenizedType'><lhs>TokenizedType</lhs>
<rhs>'ID'</rhs>
<vc def='id'/>
<vc def='one-id-per-el'/>
<vc def='id-default'/>
<rhs>| 'IDREF'</rhs>
<vc def='idref'/>
<rhs>| 'IDREFS'</rhs>
<vc def='idref'/>
<rhs>| 'ENTITY'</rhs>
<vc def='entname'/>
<rhs>| 'ENTITIES'</rhs>
<vc def='entname'/>
<rhs>| 'NMTOKEN'</rhs>
<vc def='nmtok'/>
<rhs>| 'NMTOKENS'</rhs>
<vc def='nmtok'/></prod>
</prodgroup>
</scrap>
</p>
<vcnote id='id' >
<head>ID</head>
<p>
Values of type <kw>ID</kw> must match the 
<nt def='NT-Name'>Name</nt> production.  
A name must not appear more than once in
an XML document as a value of this type; i.e., ID values must uniquely
identify the elements which bear them.   
</p>
</vcnote>
<vcnote id='one-id-per-el'>
<head>One ID per Element Type</head>
<p>No element type may have more than one ID attribute specified.</p>
</vcnote>
<vcnote id='id-default'>
<head>ID Attribute Default</head>
<p>An ID attribute must have a declared default of <kw>#IMPLIED</kw> or
<kw>#REQUIRED</kw>.</p>
</vcnote>
<vcnote id='idref'>
<head>IDREF</head>
<p>
Values of type <kw>IDREF</kw> must match
the <nt def="NT-Name">Name</nt> production, and
values of type <kw>IDREFS</kw> must match
<nt def="NT-Names">Names</nt>; 
each <nt def='NT-Name'>Name</nt> must match the value of an ID attribute on 
some element in the XML document; i.e. <kw>IDREF</kw> values must 
match the value of some ID attribute. 
</p>
</vcnote>
<vcnote id='entname'>
<head>Entity Name</head>
<p>
Values of type <kw>ENTITY</kw> 
must match the <nt def="NT-Name">Name</nt> production,
values of type <kw>ENTITIES</kw> must match
<nt def="NT-Names">Names</nt>;
each <nt def="NT-Name">Name</nt> must 
match the
name of an <termref def="dt-unparsed">unparsed entity</termref> declared in the
<termref def="dt-doctype">DTD</termref>.
</p>
</vcnote>
<vcnote id='nmtok'>
<head>Name Token</head>
<p>
Values of type <kw>NMTOKEN</kw> must match the
<nt def="NT-Nmtoken">Nmtoken</nt> production;
values of type <kw>NMTOKENS</kw> must 
match <termref def="NT-Nmtokens">Nmtokens</termref>.
</p>
</vcnote>
<!-- why?
<p>The XML processor must normalize attribute values before
passing them to the application, as described in 
<specref ref="AVNormalize"/>.</p>-->
<p><termdef id='dt-enumerated' term='Enumerated Attribute
Values'><term>Enumerated attributes</term> can take one 
of a list of values provided in the declaration</termdef>. There are two
kinds of enumerated types:
<scrap lang='ebnf'>
<head>Enumerated Attribute Types</head>
<prod id='NT-EnumeratedType'><lhs>EnumeratedType</lhs> 
<rhs><nt def='NT-NotationType'>NotationType</nt> 
| <nt def='NT-Enumeration'>Enumeration</nt>
</rhs></prod>
<prod id='NT-NotationType'><lhs>NotationType</lhs> 
<rhs>'NOTATION' 
<nt def='NT-S'>S</nt> 
'(' 
<nt def='NT-S'>S</nt>?  
<nt def='NT-Name'>Name</nt> 
(<nt def='NT-S'>S</nt>? '|' <nt def='NT-S'>S</nt>?  
<nt def='NT-Name'>Name</nt>)*
<nt def='NT-S'>S</nt>? ')'
</rhs>
<vc def='notatn' /></prod>
<prod id='NT-Enumeration'><lhs>Enumeration</lhs> 
<rhs>'(' <nt def='NT-S'>S</nt>?
<nt def='NT-Nmtoken'>Nmtoken</nt> 
(<nt def='NT-S'>S</nt>? '|' 
<nt def='NT-S'>S</nt>?  
<nt def='NT-Nmtoken'>Nmtoken</nt>)* 
<nt def='NT-S'>S</nt>? 
')'</rhs> 
<vc def='enum'/></prod>
</scrap>
A <kw>NOTATION</kw> attribute identifies a 
<termref def='dt-notation'>notation</termref>, declared in the 
DTD with associated system and/or public identifiers, to
be used in interpreting the element to which the attribute
is attached.
</p>

<vcnote id='notatn'>
<head>Notation Attributes</head>
<p>
Values of this type must match
one of the <titleref href='Notations'>notation</titleref> names included in
the declaration; all notation names in the declaration must
be declared.
</p>
</vcnote>
<vcnote id='enum'>
<head>Enumeration</head>
<p>
Values of this type
must match one of the <nt def='NT-Nmtoken'>Nmtoken</nt> tokens in the
declaration. 
</p>
</vcnote>
<p><termref def='dt-interop'>For interoperability,</termref> the same
<nt def='NT-Nmtoken'>Nmtoken</nt> should not occur more than once in the
enumerated attribute types of a single element type.
</p>
</div3>

<div3 id='sec-attr-defaults'>
<head>Attribute Defaults</head>
 
<p>An <termref def="dt-attdecl">attribute declaration</termref> provides
information on whether
the attribute's presence is required, and if not, how an XML processor should
react if a declared attribute is absent in a document.
<scrap lang='ebnf'>
<head>Attribute Defaults</head>
<prodgroup pcw4="14" pcw5="11.5">
<prod id='NT-DefaultDecl'><lhs>DefaultDecl</lhs>
<rhs>'#REQUIRED' 
|&nbsp;'#IMPLIED' </rhs>
<rhs>| (('#FIXED' S)? <nt def='NT-AttValue'>AttValue</nt>)</rhs>
<vc def='RequiredAttr'/>
<vc def='defattrvalid'/>
<wfc def="CleanAttrVals"/>
<vc def='FixedAttr'/>
</prod>
</prodgroup>
</scrap>

</p>
<p>In an attribute declaration, <kw>#REQUIRED</kw> means that the
attribute must always be provided, <kw>#IMPLIED</kw> that no default 
value is provided.
<!-- not any more!!
<kw>#IMPLIED</kw> means that if the attribute is omitted
from an element of this type,
the XML processor must inform the application
that no value was specified; no constraint is placed on the behavior
of the application. -->
<termdef id="dt-default" term="Attribute Default">If the 
declaration
is neither <kw>#REQUIRED</kw> nor <kw>#IMPLIED</kw>, then the
<nt def='NT-AttValue'>AttValue</nt> value contains the declared
<term>default</term> value; the <kw>#FIXED</kw> keyword states that
the attribute must always have the default value.
If a default value
is declared, when an XML processor encounters an omitted attribute, it
is to behave as though the attribute were present with 
the declared default value.</termdef></p>
<vcnote id='RequiredAttr'>
<head>Required Attribute</head>
<p>If the default declaration is the keyword <kw>#REQUIRED</kw>, then
the attribute must be specified for
all elements of the type in the attribute-list declaration.
</p></vcnote>
<vcnote id='defattrvalid'>
<head>Attribute Default Legal</head>
<p>
The declared
default value must meet the lexical constraints of the declared attribute type.
</p>
</vcnote>
<vcnote id='FixedAttr'>
<head>Fixed Attribute Default</head>
<p>If an attribute has a default value declared with the 
<kw>#FIXED</kw> keyword, instances of that attribute must
match the default value.
</p></vcnote>

<p>Examples of attribute-list declarations:
<eg>&lt;!ATTLIST termdef
          id      ID      #REQUIRED
          name    CDATA   #IMPLIED>
&lt;!ATTLIST list
          type    (bullets|ordered|glossary)  "ordered">
&lt;!ATTLIST form
          method  CDATA   #FIXED "POST"></eg></p>
</div3>
<div3 id='AVNormalize'>
<head>Attribute-Value Normalization</head>
<p>Before the value of an attribute is passed to the application
or checked for validity, the
XML processor must normalize it as follows:
<ulist>
<item><p>a character reference is processed by appending the referenced    
character to the attribute value</p></item>
<item><p>an entity reference is processed by recursively processing the
replacement text of the entity</p></item>
<item><p>a whitespace character (#x20, #xD, #xA, #x9) is processed by
appending #x20 to the normalized value, except that only a single #x20
is appended for a "#xD#xA" sequence that is part of an external
parsed entity or the literal entity value of an internal parsed
entity</p></item>
<item><p>other characters are processed by appending them to the normalized
value</p>
</item></ulist>
</p>
<p>If the declared value is not CDATA, then the XML processor must
further process the normalized attribute value by discarding any
leading and trailing space (#x20) characters, and by replacing
sequences of space (#x20) characters by a single space (#x20)
character.</p>
<p>
All attributes for which no declaration has been read should be treated
by a non-validating parser as if declared
<kw>CDATA</kw>.
</p>
</div3>
</div2>
<div2 id='sec-condition-sect'>
<head>Conditional Sections</head>
<p><termdef id='dt-cond-section' term='conditional section'>
<term>Conditional sections</term> are portions of the
<termref def='dt-doctype'>document type declaration external subset</termref>
which are 
included in, or excluded from, the logical structure of the DTD based on
the keyword which governs them.</termdef>
<scrap lang='ebnf'>
<head>Conditional Section</head>
<prodgroup pcw2="9" pcw4="14.5">
<prod id='NT-conditionalSect'><lhs>conditionalSect</lhs>
<rhs><nt def='NT-includeSect'>includeSect</nt>
| <nt def='NT-ignoreSect'>ignoreSect</nt>
</rhs>
</prod>
<prod id='NT-includeSect'><lhs>includeSect</lhs>
<rhs>'&lt;![' S? 'INCLUDE' S? '[' 

<nt def="NT-extSubsetDecl">extSubsetDecl</nt>
']]&gt;'
</rhs>
</prod>
<prod id='NT-ignoreSect'><lhs>ignoreSect</lhs>
<rhs>'&lt;![' S? 'IGNORE' S? '[' 
<nt def="NT-ignoreSectContents">ignoreSectContents</nt>*
']]&gt;'</rhs>
</prod>

<prod id='NT-ignoreSectContents'><lhs>ignoreSectContents</lhs>
<rhs><nt def='NT-Ignore'>Ignore</nt>
('&lt;![' <nt def='NT-ignoreSectContents'>ignoreSectContents</nt> ']]&gt;' 
<nt def='NT-Ignore'>Ignore</nt>)*</rhs></prod>
<prod id='NT-Ignore'><lhs>Ignore</lhs>
<rhs><nt def='NT-Char'>Char</nt>* - 
(<nt def='NT-Char'>Char</nt>* ('&lt;![' | ']]&gt;') 
<nt def='NT-Char'>Char</nt>*)
</rhs></prod>

</prodgroup>
</scrap>
</p>
<p>Like the internal and external DTD subsets, a conditional section
may contain one or more complete declarations,
comments, processing instructions, 
or nested conditional sections, intermingled with white space.
</p>
<p>If the keyword of the
conditional section is <kw>INCLUDE</kw>, then the contents of the conditional
section are part of the DTD.
If the keyword of the conditional
section is <kw>IGNORE</kw>, then the contents of the conditional section are
not logically part of the DTD.
Note that for reliable parsing, the contents of even ignored
conditional sections must be read in order to
detect nested conditional sections and ensure that the end of the
outermost (ignored) conditional section is properly detected.
If a conditional section with a
keyword of <kw>INCLUDE</kw> occurs within a larger conditional
section with a keyword of <kw>IGNORE</kw>, both the outer and the
inner conditional sections are ignored.</p>
<p>If the keyword of the conditional section is a 
parameter-entity reference, the parameter entity must be replaced by its
content before the processor decides whether to
include or ignore the conditional section.</p>
<p>An example:
<eg>&lt;!ENTITY % draft 'INCLUDE' >
&lt;!ENTITY % final 'IGNORE' >
 
&lt;![%draft;[
&lt;!ELEMENT book (comments*, title, body, supplements?)>
]]&gt;
&lt;![%final;[
&lt;!ELEMENT book (title, body, supplements?)>
]]&gt;
</eg>
</p>
</div2>


<!-- 
<div2 id='sec-pass-to-app'>
<head>XML Processor Treatment of Logical Structure</head>
<p>When an XML processor encounters a start-tag, it must make
at least the following information available to the application:
<ulist>
<item>
<p>the element type's generic identifier</p>
</item>
<item>
<p>the names of attributes known to apply to this element type
(validating processors must make available names of all attributes
declared for the element type; non-validating processors must
make available at least the names of the attributes for which
values are specified.
</p>
</item>
</ulist>
</p>
</div2>
--> 

</div1>
<!-- &Entities; -->
 
<div1 id='sec-physical-struct'>
<head>Physical Structures</head>
 
<p><termdef id="dt-entity" term="Entity">An XML document may consist
of one or many storage units.   These are called
<term>entities</term>; they all have <term>content</term> and are all
(except for the document entity, see below, and 
the <termref def='dt-doctype'>external DTD subset</termref>) 
identified by <term>name</term>.
</termdef>
Each XML document has one entity
called the <termref def="dt-docent">document entity</termref>, which serves
as the starting point for the <termref def="dt-xml-proc">XML
processor</termref> and may contain the whole document.</p>
<p>Entities may be either parsed or unparsed.
<termdef id="dt-parsedent" term="Text Entity">A <term>parsed entity's</term>
contents are referred to as its 
<termref def='dt-repltext'>replacement text</termref>;
this <termref def="dt-text">text</termref> is considered an
integral part of the document.</termdef></p>

<p><termdef id="dt-unparsed" term="Unparsed Entity">An 
<term>unparsed entity</term> 
is a resource whose contents may or may not be
<termref def='dt-text'>text</termref>, and if text, may not be XML.
Each unparsed entity
has an associated <termref
def="dt-notation">notation</termref>, identified by name.
Beyond a requirement
that an XML processor make the identifiers for the entity and 
notation available to the application,
XML places no constraints on the contents of unparsed entities.</termdef> 
</p>
<p>
Parsed entities are invoked by name using entity references;
unparsed entities by name, given in the value of <kw>ENTITY</kw>
or <kw>ENTITIES</kw>
attributes.</p>
<p><termdef id='gen-entity' term='general entity'
><term>General entities</term>
are entities for use within the document content.
In this specification, general entities are sometimes referred 
to with the unqualified term <emph>entity</emph> when this leads
to no ambiguity.</termdef> 
<termdef id='dt-PE' term='Parameter entity'>Parameter entities 
are parsed entities for use within the DTD.</termdef>
These two types of entities use different forms of reference and
are recognized in different contexts.
Furthermore, they occupy different namespaces; a parameter entity and
a general entity with the same name are two distinct entities.
</p>

<div2 id='sec-references'>
<head>Character and Entity References</head>
<p><termdef id="dt-charref" term="Character Reference">
A <term>character reference</term> refers to a specific character in the
ISO/IEC 10646 character set, for example one not directly accessible from
available input devices.
<scrap lang='ebnf'>
<head>Character Reference</head>
<prod id='NT-CharRef'><lhs>CharRef</lhs>
<rhs>'&amp;#' [0-9]+ ';' </rhs>
<rhs>| '&hcro;' [0-9a-fA-F]+ ';'</rhs>
<wfc def="wf-Legalchar"/>
</prod>
</scrap>
<wfcnote id="wf-Legalchar">
<head>Legal Character</head>
<p>Characters referred to using character references must
match the production for
<termref def="NT-Char">Char</termref>.</p>
</wfcnote>
If the character reference begins with "<code>&amp;#x</code>", the digits and
letters up to the terminating <code>;</code> provide a hexadecimal
representation of the character's code point in ISO/IEC 10646.
If it begins just with "<code>&amp;#</code>", the digits up to the terminating
<code>;</code> provide a decimal representation of the character's 
code point.
</termdef>
</p>
<p><termdef id="dt-entref" term="Entity Reference">An <term>entity
reference</term> refers to the content of a named entity.</termdef>
<termdef id='dt-GERef' term='General Entity Reference'>References to 
parsed general entities
use ampersand (<code>&amp;</code>) and semicolon (<code>;</code>) as
delimiters.</termdef>
<termdef id='dt-PERef' term='Parameter-entity reference'>
<term>Parameter-entity references</term> use percent-sign (<code>%</code>) and
semicolon 
(<code>;</code>) as delimiters.</termdef>
</p>
<scrap lang="ebnf">
<head>Entity Reference</head>
<prod id='NT-Reference'><lhs>Reference</lhs>
<rhs><nt def='NT-EntityRef'>EntityRef</nt> 
| <nt def='NT-CharRef'>CharRef</nt></rhs></prod>
<prod id='NT-EntityRef'><lhs>EntityRef</lhs>
<rhs>'&amp;' <nt def='NT-Name'>Name</nt> ';'</rhs>
<wfc def='wf-entdeclared'/>
<vc def='vc-entdeclared'/>
<wfc def='textent'/>
<wfc def='norecursion'/>
</prod>
<prod id='NT-PEReference'><lhs>PEReference</lhs>
<rhs>'%' <nt def='NT-Name'>Name</nt> ';'</rhs>
<vc def='vc-entdeclared'/>
<wfc def='norecursion'/>
<wfc def='indtd'/>
</prod>
</scrap>

<wfcnote id='wf-entdeclared'>
<head>Entity Declared</head>
<p>In a document without any DTD, a document with only an internal
DTD subset which contains no parameter entity references, or a document with
"<code>standalone='yes'</code>", 
the <nt def='NT-Name'>Name</nt> given in the entity reference must 
<termref def="dt-match">match</termref> that in an 
<titleref href='sec-entity-decl'>entity declaration</titleref>, except that
well-formed documents need not declare 
any of the following entities: &magicents;.  
The declaration of a parameter entity must precede any reference to it.
Similarly, the declaration of a general entity must precede any
reference to it which appears in a default value in an attribute-list
declaration.</p>
<p>Note that if entities are declared in the external subset or in 
external parameter entities, a non-validating processor is 
<titleref href='include-if-valid'>not obligated to</titleref> read
and process their declarations; for such documents, the rule that
an entity must be declared is a well-formedness constraint only
if <titleref href='sec-rmd'>standalone='yes'</titleref>.</p>
</wfcnote>
<vcnote id="vc-entdeclared">
<head>Entity Declared</head>
<p>In a document with an external subset or external parameter
entities with "<code>standalone='no'</code>",
the <nt def='NT-Name'>Name</nt> given in the entity reference must <termref
def="dt-match">match</termref> that in an 
<titleref href='sec-entity-decl'>entity declaration</titleref>.
For interoperability, valid documents should declare the entities 
&magicents;, in the form
specified in <specref ref="sec-predefined-ent"/>.
The declaration of a parameter entity must precede any reference to it.
Similarly, the declaration of a general entity must precede any
reference to it which appears in a default value in an attribute-list
declaration.</p>
</vcnote>
<!-- FINAL EDIT:  is this duplication too clumsy? -->
<wfcnote id='textent'>
<head>Parsed Entity</head>
<p>
An entity reference must not contain the name of an <termref
def="dt-unparsed">unparsed entity</termref>. Unparsed entities may be referred
to only in <termref def="dt-attrval">attribute values</termref> declared to
be of type <kw>ENTITY</kw> or <kw>ENTITIES</kw>.
</p>
</wfcnote>
<wfcnote id='norecursion'>
<head>No Recursion</head>
<p>
A parsed entity must not contain a recursive reference to itself,
either directly or indirectly.
</p>
</wfcnote>
<wfcnote id='indtd'>
<head>In DTD</head>
<p>
Parameter-entity references may only appear in the 
<termref def='dt-doctype'>DTD</termref>.
</p>
</wfcnote>
<p>Examples of character and entity references:
<eg>Type &lt;key>less-than&lt;/key> (&hcro;3C;) to save options.
This document was prepared on &amp;docdate; and
is classified &amp;security-level;.</eg></p>
<p>Example of a parameter-entity reference:
<eg><![CDATA[<!-- declare the parameter entity "ISOLat2"... -->
<!ENTITY % ISOLat2
         SYSTEM "http://www.xml.com/iso/isolat2-xml.entities" >
<!-- ... now reference it. -->
%ISOLat2;]]></eg></p>
</div2>
 
<div2 id='sec-entity-decl'>
<head>Entity Declarations</head>
 
<p><termdef id="dt-entdecl" term="entity declaration">
Entities are declared thus:
<scrap lang='ebnf'>
<head>Entity Declaration</head>
<prodgroup pcw2="5" pcw4="18.5">
<prod id='NT-EntityDecl'><lhs>EntityDecl</lhs>
<rhs><nt def="NT-GEDecl">GEDecl</nt><!--</rhs><com>General entities</com>
<rhs>--> | <nt def="NT-PEDecl">PEDecl</nt></rhs>
<!--<com>Parameter entities</com>-->
</prod>
<prod id='NT-GEDecl'><lhs>GEDecl</lhs>
<rhs>'&lt;!ENTITY' <nt def='NT-S'>S</nt> <nt def='NT-Name'>Name</nt> 
<nt def='NT-S'>S</nt> <nt def='NT-EntityDef'>EntityDef</nt> 
<nt def='NT-S'>S</nt>? '&gt;'</rhs>
</prod>
<prod id='NT-PEDecl'><lhs>PEDecl</lhs>
<rhs>'&lt;!ENTITY' <nt def='NT-S'>S</nt> '%' <nt def='NT-S'>S</nt> 
<nt def='NT-Name'>Name</nt> <nt def='NT-S'>S</nt> 
<nt def='NT-PEDef'>PEDef</nt> <nt def='NT-S'>S</nt>? '&gt;'</rhs>
<!--<com>Parameter entities</com>-->
</prod>
<prod id='NT-EntityDef'><lhs>EntityDef</lhs>
<rhs><nt def='NT-EntityValue'>EntityValue</nt>
<!--</rhs>
<rhs>-->| (<nt def='NT-ExternalID'>ExternalID</nt> 
<nt def='NT-NDataDecl'>NDataDecl</nt>?)</rhs>
<!-- <nt def='NT-ExternalDef'>ExternalDef</nt></rhs> -->
</prod>
<!-- FINAL EDIT: what happened to WFs here? -->
<prod id='NT-PEDef'><lhs>PEDef</lhs>
<rhs><nt def='NT-EntityValue'>EntityValue</nt> 
| <nt def='NT-ExternalID'>ExternalID</nt></rhs></prod>
</prodgroup>
</scrap>
The <nt def='NT-Name'>Name</nt> identifies the entity in an
<termref def="dt-entref">entity reference</termref> or, in the case of an
unparsed entity, in the value of an <kw>ENTITY</kw> or <kw>ENTITIES</kw>
attribute.
If the same entity is declared more than once, the first declaration
encountered is binding; at user option, an XML processor may issue a
warning if entities are declared multiple times.</termdef>
</p>

<div3 id='sec-internal-ent'>
<head>Internal Entities</head>
 
<p><termdef id='dt-internent' term="Internal Entity Replacement Text">If 
the entity definition is an 
<nt def='NT-EntityValue'>EntityValue</nt>,  
the defined entity is called an <term>internal entity</term>.  
There is no separate physical
storage object, and the content of the entity is given in the
declaration. </termdef>
Note that some processing of entity and character references in the
<termref def='dt-litentval'>literal entity value</termref> may be required to
produce the correct <termref def='dt-repltext'>replacement 
text</termref>: see <specref ref='intern-replacement'/>.
</p>
<p>An internal entity is a <termref def="dt-parsedent">parsed
entity</termref>.</p>
<p>Example of an internal entity declaration:
<eg>&lt;!ENTITY Pub-Status "This is a pre-release of the
 specification."></eg></p>
</div3>
 
<div3 id='sec-external-ent'>
<head>External Entities</head>
 
<p><termdef id="dt-extent" term="External Entity">If the entity is not
internal, it is an <term>external
entity</term>, declared as follows:
<scrap lang='ebnf'>
<head>External Entity Declaration</head>
<!--
<prod id='NT-ExternalDef'><lhs>ExternalDef</lhs>
<rhs></prod> -->
<prod id='NT-ExternalID'><lhs>ExternalID</lhs>
<rhs>'SYSTEM' <nt def='NT-S'>S</nt> 
<nt def='NT-SystemLiteral'>SystemLiteral</nt></rhs>
<rhs>| 'PUBLIC' <nt def='NT-S'>S</nt> 
<nt def='NT-PubidLiteral'>PubidLiteral</nt> 
<nt def='NT-S'>S</nt> 
<nt def='NT-SystemLiteral'>SystemLiteral</nt>
</rhs>
</prod>
<prod id='NT-NDataDecl'><lhs>NDataDecl</lhs>
<rhs><nt def='NT-S'>S</nt> 'NDATA' <nt def='NT-S'>S</nt> 
<nt def='NT-Name'>Name</nt></rhs>
<vc def='not-declared'/></prod>
</scrap>
If the <nt def='NT-NDataDecl'>NDataDecl</nt> is present, this is a
general <termref def="dt-unparsed">unparsed
entity</termref>; otherwise it is a parsed entity.</termdef></p>
<vcnote id='not-declared'>
<head>Notation Declared</head>
<p>
The <nt def='NT-Name'>Name</nt> must match the declared name of a
<termref def="dt-notation">notation</termref>.
</p>
</vcnote>
<p><termdef id="dt-sysid" term="System Identifier">The
<nt def='NT-SystemLiteral'>SystemLiteral</nt> 
is called the entity's <term>system identifier</term>. It is a URI,
which may be used to retrieve the entity.</termdef>
Note that the hash mark (<code>#</code>) and fragment identifier 
frequently used with URIs are not, formally, part of the URI itself; 
an XML processor may signal an error if a fragment identifier is 
given as part of a system identifier.
Unless otherwise provided by information outside the scope of this
specification (e.g. a special XML element type defined by a particular
DTD, or a processing instruction defined by a particular application
specification), relative URIs are relative to the location of the
resource within which the entity declaration occurs.
A URI might thus be relative to the 
<termref def='dt-docent'>document entity</termref>, to the entity
containing the <termref def='dt-doctype'>external DTD subset</termref>, 
or to some other <termref def='dt-extent'>external parameter entity</termref>.
</p>
<p>An XML processor should handle a non-ASCII character in a URI by
representing the character in UTF-8 as one or more bytes, and then 
escaping these bytes with the URI escaping mechanism (i.e., by
converting each byte to %HH, where HH is the hexadecimal notation of the
byte value).</p>
<p><termdef id="dt-pubid" term="Public identifier">
In addition to a system identifier, an external identifier may
include a <term>public identifier</term>.</termdef>  
An XML processor attempting to retrieve the entity's content may use the public
identifier to try to generate an alternative URI.  If the processor
is unable to do so, it must use the URI specified in the system
literal.  Before a match is attempted, all strings
of white space in the public identifier must be normalized to single space characters (#x20),
and leading and trailing white space must be removed.</p>
<p>Examples of external entity declarations:
<eg>&lt;!ENTITY open-hatch
         SYSTEM "http://www.textuality.com/boilerplate/OpenHatch.xml">
&lt;!ENTITY open-hatch
         PUBLIC "-//Textuality//TEXT Standard open-hatch boilerplate//EN"
         "http://www.textuality.com/boilerplate/OpenHatch.xml">
&lt;!ENTITY hatch-pic
         SYSTEM "../grafix/OpenHatch.gif"
         NDATA gif ></eg></p>
</div3>
 
</div2>

<div2 id='TextEntities'>
<head>Parsed Entities</head>
<div3 id='sec-TextDecl'>
<head>The Text Declaration</head>
<p>External parsed entities may each begin with a <term>text
declaration</term>. 
<scrap lang='ebnf'>
<head>Text Declaration</head>
<prodgroup pcw4="12.5" pcw5="13">
<prod id='NT-TextDecl'><lhs>TextDecl</lhs>
<rhs>&xmlpio; 
<nt def='NT-VersionInfo'>VersionInfo</nt>?
<nt def='NT-EncodingDecl'>EncodingDecl</nt>
<nt def='NT-S'>S</nt>? &pic;</rhs>
</prod>
</prodgroup>
</scrap>
</p>
<p>The text declaration must be provided literally, not
by reference to a parsed entity.
No text declaration may appear at any position other than the beginning of
an external parsed entity.</p>
</div3>
<div3 id='wf-entities'>
<head>Well-Formed Parsed Entities</head>
<p>The document entity is well-formed if it matches the production labeled
<nt def='NT-document'>document</nt>.
An external general 
parsed entity is well-formed if it matches the production labeled
<nt def='NT-extParsedEnt'>extParsedEnt</nt>.
An external parameter
entity is well-formed if it matches the production labeled
<nt def='NT-extPE'>extPE</nt>.
<scrap lang='ebnf'>
<head>Well-Formed External Parsed Entity</head>
<prod id='NT-extParsedEnt'><lhs>extParsedEnt</lhs>
<rhs><nt def='NT-TextDecl'>TextDecl</nt>? 
<nt def='NT-content'>content</nt></rhs>
</prod>
<prod id='NT-extPE'><lhs>extPE</lhs>
<rhs><nt def='NT-TextDecl'>TextDecl</nt>? 
<nt def='NT-extSubsetDecl'>extSubsetDecl</nt></rhs>
</prod>
</scrap>
An internal general parsed entity is well-formed if its replacement text 
matches the production labeled
<nt def='NT-content'>content</nt>.
All internal parameter entities are well-formed by definition.
</p>
<p>A consequence of well-formedness in entities is that the logical 
and physical structures in an XML document are properly nested; no 
<termref def='dt-stag'>start-tag</termref>,
<termref def='dt-etag'>end-tag</termref>,
<termref def="dt-empty">empty-element tag</termref>,
<termref def='dt-element'>element</termref>, 
<termref def='dt-comment'>comment</termref>, 
<termref def='dt-pi'>processing instruction</termref>, 
<termref def='dt-charref'>character
reference</termref>, or
<termref def='dt-entref'>entity reference</termref> 
can begin in one entity and end in another.</p>
</div3>
<div3 id='charencoding'>
<head>Character Encoding in Entities</head>
 
<p>Each external parsed entity in an XML document may use a different
encoding for its characters. All XML processors must be able to read
entities in either UTF-8 or UTF-16. 

</p>
<p>Entities encoded in UTF-16 must
begin with the Byte Order Mark described by ISO/IEC 10646 Annex E and
Unicode Appendix B (the ZERO WIDTH NO-BREAK SPACE character, #xFEFF).
This is an encoding signature, not part of either the markup or the
character data of the XML document.
XML processors must be able to use this character to
differentiate between UTF-8 and UTF-16 encoded documents.</p>
<p>Although an XML processor is required to read only entities in
the UTF-8 and UTF-16 encodings, it is recognized that other encodings are
used around the world, and it may be desired for XML processors
to read entities that use them.
Parsed entities which are stored in an encoding other than
UTF-8 or UTF-16 must begin with a <titleref href='TextDecl'>text
declaration</titleref> containing an encoding declaration:
<scrap lang='ebnf'>
<head>Encoding Declaration</head>
<prod id='NT-EncodingDecl'><lhs>EncodingDecl</lhs>
<rhs><nt def="NT-S">S</nt>
'encoding' <nt def='NT-Eq'>Eq</nt> 
('"' <nt def='NT-EncName'>EncName</nt> '"' | 
"'" <nt def='NT-EncName'>EncName</nt> "'" )
</rhs>
</prod>
<prod id='NT-EncName'><lhs>EncName</lhs>
<rhs>[A-Za-z] ([A-Za-z0-9._] | '-')*</rhs>
<com>Encoding name contains only Latin characters</com>
</prod>
</scrap>
In the <termref def='dt-docent'>document entity</termref>, the encoding
declaration is part of the <termref def="dt-xmldecl">XML declaration</termref>.
The <nt def="NT-EncName">EncName</nt> is the name of the encoding used.
</p>
<!-- FINAL EDIT:  check name of IANA and charset names -->
<p>In an encoding declaration, the values
"<code>UTF-8</code>",
"<code>UTF-16</code>",
"<code>ISO-10646-UCS-2</code>", and
"<code>ISO-10646-UCS-4</code>" should be 
used for the various encodings and transformations of Unicode /
ISO/IEC 10646, the values
"<code>ISO-8859-1</code>",
"<code>ISO-8859-2</code>", ...
"<code>ISO-8859-9</code>" should be used for the parts of ISO 8859, and
the values
"<code>ISO-2022-JP</code>",
"<code>Shift_JIS</code>", and
"<code>EUC-JP</code>"
should be used for the various encoded forms of JIS X-0208-1997.  XML
processors may recognize other encodings; it is recommended that
character encodings registered (as <emph>charset</emph>s) 
with the Internet Assigned Numbers
Authority <bibref ref='IANA'/>, other than those just listed, should be
referred to
using their registered names.
Note that these registered names are defined to be 
case-insensitive, so processors wishing to match against them 
should do so in a case-insensitive
way.</p>
<p>In the absence of information provided by an external
transport protocol (e.g. HTTP or MIME), 
it is an <termref def="dt-error">error</termref> for an entity including
an encoding declaration to be presented to the XML processor 
in an encoding other than that named in the declaration, 
for an encoding declaration to occur other than at the beginning 
of an external entity, or for
an entity which begins with neither a Byte Order Mark nor an encoding
declaration to use an encoding other than UTF-8.
Note that since ASCII
is a subset of UTF-8, ordinary ASCII entities do not strictly need
an encoding declaration.</p>

<p>It is a <termref def='dt-fatal'>fatal error</termref> when an XML processor
encounters an entity with an encoding that it is unable to process.</p>
<p>Examples of encoding declarations:
<eg>&lt;?xml encoding='UTF-8'?>
&lt;?xml encoding='EUC-JP'?></eg></p>
</div3>
</div2>
<div2 id='entproc'>
<head>XML Processor Treatment of Entities and References</head>
<p>The table below summarizes the contexts in which character references,
entity references, and invocations of unparsed entities might appear and the
required behavior of an <termref def='dt-xml-proc'>XML processor</termref> in
each case.  
The labels in the leftmost column describe the recognition context:
<glist>
<gitem><label>Reference in Content</label>
<def><p>as a reference
anywhere after the <termref def='dt-stag'>start-tag</termref> and
before the <termref def='dt-etag'>end-tag</termref> of an element; corresponds
to the nonterminal <nt def='NT-content'>content</nt>.</p></def>
</gitem>
<gitem>
<label>Reference in Attribute Value</label>
<def><p>as a reference within either the value of an attribute in a 
<termref def='dt-stag'>start-tag</termref>, or a default
value in an <termref def='dt-attdecl'>attribute declaration</termref>;
corresponds to the nonterminal
<nt def='NT-AttValue'>AttValue</nt>.</p></def></gitem>
<gitem>
<label>Occurs as Attribute Value</label>
<def><p>as a <nt def='NT-Name'>Name</nt>, not a reference, appearing either as
the value of an 
attribute which has been declared as type <kw>ENTITY</kw>, or as one of
the space-separated tokens in the value of an attribute which has been
declared as type <kw>ENTITIES</kw>.</p>
</def></gitem>
<gitem><label>Reference in Entity Value</label>
<def><p>as a reference
within a parameter or internal entity's 
<termref def='dt-litentval'>literal entity value</termref> in
the entity's declaration; corresponds to the nonterminal 
<nt def='NT-EntityValue'>EntityValue</nt>.</p></def></gitem>
<gitem><label>Reference in DTD</label>
<def><p>as a reference within either the internal or external subsets of the 
<termref def='dt-doctype'>DTD</termref>, but outside
of an <nt def='NT-EntityValue'>EntityValue</nt> or
<nt def="NT-AttValue">AttValue</nt>.</p></def>
</gitem>
</glist></p>
<htable border='1' cellpadding='7' align='center'>
<htbody>
<tr><td bgcolor='&cellback;' rowspan='2' colspan='1'></td>
<td bgcolor='&cellback;' align='center' valign='bottom' colspan='4'>Entity Type</td>
<td bgcolor='&cellback;' rowspan='2' align='center'>Character</td>
</tr>
<tr align='center' valign='bottom'>
<td bgcolor='&cellback;'>Parameter</td>
<td bgcolor='&cellback;'>Internal
General</td>
<td bgcolor='&cellback;'>External Parsed
General</td>
<td bgcolor='&cellback;'>Unparsed</td>
</tr>
<tr align='center' valign='middle'>

<td bgcolor='&cellback;' align='right'>Reference
in Content</td>
<td bgcolor='&cellback;'><titleref href='not-recognized'>Not recognized</titleref></td>
<td bgcolor='&cellback;'><titleref href='included'>Included</titleref></td>
<td bgcolor='&cellback;'><titleref href='include-if-valid'>Included if validating</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='included'>Included</titleref></td>
</tr>
<tr align='center' valign='middle'>
<td bgcolor='&cellback;' align='right'>Reference
in Attribute Value</td>
<td bgcolor='&cellback;'><titleref href='not-recognized'>Not recognized</titleref></td>
<td bgcolor='&cellback;'><titleref href='inliteral'>Included in literal</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='included'>Included</titleref></td>
</tr>
<tr align='center' valign='middle'>
<td bgcolor='&cellback;' align='right'>Occurs as
Attribute Value</td>
<td bgcolor='&cellback;'><titleref href='not-recognized'>Not recognized</titleref></td>
<td bgcolor='&cellback;'><titleref href='not-recognized'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='not-recognized'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='notify'>Notify</titleref></td>
<td bgcolor='&cellback;'><titleref href='not recognized'>Not recognized</titleref></td>
</tr>
<tr align='center' valign='middle'>
<td bgcolor='&cellback;' align='right'>Reference
in EntityValue</td>
<td bgcolor='&cellback;'><titleref href='inliteral'>Included in literal</titleref></td>
<td bgcolor='&cellback;'><titleref href='bypass'>Bypassed</titleref></td>
<td bgcolor='&cellback;'><titleref href='bypass'>Bypassed</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='included'>Included</titleref></td>
</tr>
<tr align='center' valign='middle'>
<td bgcolor='&cellback;' align='right'>Reference
in DTD</td>
<td bgcolor='&cellback;'><titleref href='as-PE'>Included as PE</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
<td bgcolor='&cellback;'><titleref href='forbidden'>Forbidden</titleref></td>
</tr>
</htbody>
</htable>
<div3 id='not-recognized'>
<head>Not Recognized</head>
<p>Outside the DTD, the <code>%</code> character has no
special significance; thus, what would be parameter entity references in the
DTD are not recognized as markup in <nt def='NT-content'>content</nt>.
Similarly, the names of unparsed entities are not recognized except
when they appear in the value of an appropriately declared attribute.
</p>
</div3>
<div3 id='included'>
<head>Included</head>
<p><termdef id="dt-include" term="Include">An entity is 
<term>included</term> when its 
<termref def='dt-repltext'>replacement text</termref> is retrieved 
and processed, in place of the reference itself,
as though it were part of the document at the location the
reference was recognized.
The replacement text may contain both 
<termref def='dt-chardata'>character data</termref>
and (except for parameter entities) <termref def="dt-markup">markup</termref>,
which must be recognized in
the usual way, except that the replacement text of entities used to escape
markup delimiters (the entities &magicents;) is always treated as
data.  (The string "<code>AT&amp;amp;T;</code>" expands to
"<code>AT&amp;T;</code>" and the remaining ampersand is not recognized
as an entity-reference delimiter.) 
A character reference is <term>included</term> when the indicated
character is processed in place of the reference itself.
</termdef></p>
</div3>
<div3 id='include-if-valid'>
<head>Included If Validating</head>
<p>When an XML processor recognizes a reference to a parsed entity, in order
to <termref def="dt-valid">validate</termref>
the document, the processor must 
<termref def="dt-include">include</termref> its
replacement text.
If the entity is external, and the processor is not
attempting to validate the XML document, the
processor <termref def="dt-may">may</termref>, but need not, 
include the entity's replacement text.
If a non-validating parser does not include the replacement text,
it must inform the application that it recognized, but did not
read, the entity.</p>
<p>This rule is based on the recognition that the automatic inclusion
provided by the SGML and XML entity mechanism, primarily designed
to support modularity in authoring, is not necessarily 
appropriate for other applications, in particular document browsing.
Browsers, for example, when encountering an external parsed entity reference,
might choose to provide a visual indication of the entity's
presence and retrieve it for display only on demand.
</p>
</div3>
<div3 id='forbidden'>
<head>Forbidden</head>
<p>The following are forbidden, and constitute
<termref def='dt-fatal'>fatal</termref> errors:
<ulist>
<item><p>the appearance of a reference to an
<termref def='dt-unparsed'>unparsed entity</termref>.
</p></item>
<item><p>the appearance of any character or general-entity reference in the
DTD except within an <nt def='NT-EntityValue'>EntityValue</nt> or 
<nt def="NT-AttValue">AttValue</nt>.</p></item>
<item><p>a reference to an external entity in an attribute value.</p>
</item>
</ulist>
</p>
</div3>
<div3 id='inliteral'>
<head>Included in Literal</head>
<p>When an <termref def='dt-entref'>entity reference</termref> appears in an
attribute value, or a parameter entity reference appears in a literal entity
value, its <termref def='dt-repltext'>replacement text</termref> is
processed in place of the reference itself as though it
were part of the document at the location the reference was recognized,
except that a single or double quote character in the replacement text
is always treated as a normal data character and will not terminate the
literal. 
For example, this is well-formed:
<eg><![CDATA[<!ENTITY % YN '"Yes"' >
<!ENTITY WhatHeSaid "He said &YN;" >]]></eg>
while this is not:
<eg>&lt;!ENTITY EndAttr "27'" >
&lt;element attribute='a-&amp;EndAttr;></eg>
</p></div3>
<div3 id='notify'>
<head>Notify</head>
<p>When the name of an <termref def='dt-unparsed'>unparsed
entity</termref> appears as a token in the
value of an attribute of declared type <kw>ENTITY</kw> or <kw>ENTITIES</kw>,
a validating processor must inform the
application of the <termref def='dt-sysid'>system</termref> 
and <termref def='dt-pubid'>public</termref> (if any)
identifiers for both the entity and its associated
<termref def="dt-notation">notation</termref>.</p>
</div3>
<div3 id='bypass'>
<head>Bypassed</head>
<p>When a general entity reference appears in the
<nt def='NT-EntityValue'>EntityValue</nt> in an entity declaration,
it is bypassed and left as is.</p>
</div3>
<div3 id='as-PE'>
<head>Included as PE</head>
<p>Just as with external parsed entities, parameter entities
need only be <titleref href='include-if-valid'>included if
validating</titleref>. 
When a parameter-entity reference is recognized in the DTD
and included, its 
<termref def='dt-repltext'>replacement
text</termref> is enlarged by the attachment of one leading and one following
space (#x20) character; the intent is to constrain the replacement
text of parameter 
entities to contain an integral number of grammatical tokens in the DTD.
</p>
</div3>

</div2>
<div2 id='intern-replacement'>
<head>Construction of Internal Entity Replacement Text</head>
<p>In discussing the treatment
of internal entities, it is  
useful to distinguish two forms of the entity's value.
<termdef id="dt-litentval" term='Literal Entity Value'>The <term>literal
entity value</term> is the quoted string actually
present in the entity declaration, corresponding to the
non-terminal <nt def='NT-EntityValue'>EntityValue</nt>.</termdef>
<termdef id='dt-repltext' term='Replacement Text'>The <term>replacement
text</term> is the content of the entity, after
replacement of character references and parameter-entity
references.
</termdef></p>

<p>The literal entity value 
as given in an internal entity declaration
(<nt def='NT-EntityValue'>EntityValue</nt>) may contain character,
parameter-entity, and general-entity references.
Such references must be contained entirely within the
literal entity value.
The actual replacement text that is 
<termref def='dt-include'>included</termref> as described above
must contain the <emph>replacement text</emph> of any 
parameter entities referred to, and must contain the character
referred to, in place of any character references in the
literal entity value; however,
general-entity references must be left as-is, unexpanded.
For example, given the following declarations:

<eg><![CDATA[<!ENTITY % pub    "&#xc9;ditions Gallimard" >
<!ENTITY   rights "All rights reserved" >
<!ENTITY   book   "La Peste: Albert Camus, 
&#xA9; 1947 %pub;. &rights;" >]]></eg>
then the replacement text for the entity "<code>book</code>" is:
<eg>La Peste: Albert Camus, 
&#169; 1947 &#201;ditions Gallimard. &amp;rights;</eg>
The general-entity reference "<code>&amp;rights;</code>" would be expanded
should the reference "<code>&amp;book;</code>" appear in the document's
content or an attribute value.</p>
<p>These simple rules may have complex interactions; for a detailed
discussion of a difficult example, see
<specref ref='sec-entexpand'/>.
</p>

</div2>
<div2 id='sec-predefined-ent'>
<head>Predefined Entities</head>
<p><termdef id="dt-escape" term="escape">Entity and character
references can both be used to <term>escape</term> the left angle bracket,
ampersand, and other delimiters.   A set of general entities
(&magicents;) is specified for this purpose.
Numeric character references may also be used; they are
expanded immediately when recognized and must be treated as
character data, so the numeric character references
"<code>&amp;#60;</code>" and "<code>&amp;#38;</code>" may be used to 
escape <code>&lt;</code> and <code>&amp;</code> when they occur
in character data.</termdef></p>
<p>All XML processors must recognize these entities whether they
are declared or not.  
<termref def='dt-interop'>For interoperability</termref>,
valid XML documents should declare these
entities, like any others, before using them.
If the entities in question are declared, they must be declared
as internal entities whose replacement text is the single
character being escaped or a character reference to
that character, as shown below.
<eg><![CDATA[<!ENTITY lt     "&#38;#60;"> 
<!ENTITY gt     "&#62;"> 
<!ENTITY amp    "&#38;#38;"> 
<!ENTITY apos   "&#39;"> 
<!ENTITY quot   "&#34;"> 
]]></eg>
Note that the <code>&lt;</code> and <code>&amp;</code> characters
in the declarations of "<code>lt</code>" and "<code>amp</code>"
are doubly escaped to meet the requirement that entity replacement
be well-formed.
</p>
</div2>

<div2 id='Notations'>
<head>Notation Declarations</head>
 
<p><termdef id="dt-notation" term="Notation"><term>Notations</term> identify by
name the format of <termref def="dt-extent">unparsed
entities</termref>, the
format of elements which bear a notation attribute, 
or the application to which  
a <termref def="dt-pi">processing instruction</termref> is
addressed.</termdef></p>
<p><termdef id="dt-notdecl" term="Notation Declaration">
<term>Notation declarations</term>
provide a name for the notation, for use in
entity and attribute-list declarations and in attribute specifications,
and an external identifier for the notation which may allow an XML
processor or its client application to locate a helper application
capable of processing data in the given notation.
<scrap lang='ebnf'>
<head>Notation Declarations</head>
<prod id='NT-NotationDecl'><lhs>NotationDecl</lhs>
<rhs>'&lt;!NOTATION' <nt def='NT-S'>S</nt> <nt def='NT-Name'>Name</nt> 
<nt def='NT-S'>S</nt> 
(<nt def='NT-ExternalID'>ExternalID</nt> | 
<nt def='NT-PublicID'>PublicID</nt>)
<nt def='NT-S'>S</nt>? '>'</rhs></prod>
<prod id='NT-PublicID'><lhs>PublicID</lhs>
<rhs>'PUBLIC' <nt def='NT-S'>S</nt> 
<nt def='NT-PubidLiteral'>PubidLiteral</nt> 
</rhs></prod>
</scrap>
</termdef></p>
<p>XML processors must provide applications with the name and external
identifier(s) of any notation declared and referred to in an attribute
value, attribute definition, or entity declaration.  They may
additionally resolve the external identifier into the
<termref def="dt-sysid">system identifier</termref>,
file name, or other information needed to allow the
application to call a processor for data in the notation described.  (It
is not an error, however, for XML documents to declare and refer to
notations for which notation-specific applications are not available on
the system where the XML processor or application is running.)</p>
</div2>

 
<div2 id='sec-doc-entity'>
<head>Document Entity</head>
 
<p><termdef id="dt-docent" term="Document Entity">The <term>document
entity</term> serves as the root of the entity
tree and a starting-point for an <termref def="dt-xml-proc">XML
processor</termref>.</termdef>
This specification does
not specify how the document entity is to be located by an XML
processor; unlike other entities, the document entity has no name and might
well appear on a processor input stream 
without any identification at all.</p>
</div2>


</div1>
<!-- &Conformance; -->
 
<div1 id='sec-conformance'>
<head>Conformance</head>
 
<div2 id='proc-types'>
<head>Validating and Non-Validating Processors</head>
<p>Conforming <termref def="dt-xml-proc">XML processors</termref> fall into two
classes: validating and non-validating.</p>
<p>Validating and non-validating processors alike must report
violations of this specification's well-formedness constraints
in the content of the
<termref def='dt-docent'>document entity</termref> and any 
other <termref def='dt-parsedent'>parsed entities</termref> that 
they read.</p>
<p><termdef id="dt-validating" term="Validating Processor">
<term>Validating processors</term> must report
violations of the constraints expressed by the declarations in the
<termref def="dt-doctype">DTD</termref>, and
failures to fulfill the validity constraints given
in this specification.
</termdef>
To accomplish this, validating XML processors must read and process the entire
DTD and all external parsed entities referenced in the document.
</p>
<p>Non-validating processors are required to check only the 
<termref def='dt-docent'>document entity</termref>, including
the entire internal DTD subset, for well-formedness.
<termdef id='dt-use-mdecl' term='Process Declarations'>
While they are not required to check the document for validity,
they are required to 
<term>process</term> all the declarations they read in the
internal DTD subset and in any parameter entity that they
read, up to the first reference
to a parameter entity that they do <emph>not</emph> read; that is to 
say, they must
use the information in those declarations to
<titleref href='AVNormalize'>normalize</titleref> attribute values,
<titleref href='included'>include</titleref> the replacement text of 
internal entities, and supply 
<titleref href='sec-attr-defaults'>default attribute values</titleref>.
</termdef>
They must not <termref def='dt-use-mdecl'>process</termref>
<termref def='dt-entdecl'>entity declarations</termref> or 
<termref def='dt-attdecl'>attribute-list declarations</termref> 
encountered after a reference to a parameter entity that is not
read, since the entity may have contained overriding declarations.
</p>
</div2>
<div2 id='safe-behavior'>
<head>Using XML Processors</head>
<p>The behavior of a validating XML processor is highly predictable; it
must read every piece of a document and report all well-formedness and
validity violations.
Less is required of a non-validating processor; it need not read any
part of the document other than the document entity.
This has two effects that may be important to users of XML processors:
<ulist>
<item><p>Certain well-formedness errors, specifically those that require
reading external entities, may not be detected by a non-validating processor.
Examples include the constraints entitled 
<titleref href='wf-entdeclared'>Entity Declared</titleref>, 
<titleref href='wf-textent'>Parsed Entity</titleref>, and
<titleref href='wf-norecursion'>No Recursion</titleref>, as well
as some of the cases described as
<titleref href='forbidden'>forbidden</titleref> in 
<specref ref='entproc'/>.</p></item>
<item><p>The information passed from the processor to the application may
vary, depending on whether the processor reads
parameter and external entities.
For example, a non-validating processor may not 
<titleref href='AVNormalize'>normalize</titleref> attribute values,
<titleref href='included'>include</titleref> the replacement text of 
internal entities, or supply 
<titleref href='sec-attr-defaults'>default attribute values</titleref>,
where doing so depends on having read declarations in 
external or parameter entities.</p></item>
</ulist>
</p>
<p>For maximum reliability in interoperating between different XML
processors, applications which use non-validating processors should not 
rely on any behaviors not required of such processors.
Applications which require facilities such as the use of default
attributes or internal entities which are declared in external
entities should use validating XML processors.</p>
</div2>
</div1>

<div1 id='sec-notation'>
<head>Notation</head>
 
<p>The formal grammar of XML is given in this specification using a simple
Extended Backus-Naur Form (EBNF) notation.  Each rule in the grammar defines
one symbol, in the form
<eg>symbol ::= expression</eg></p>
<p>Symbols are written with an initial capital letter if they are
defined by a regular expression, or with an initial lower case letter 
otherwise.
Literal strings are quoted.

</p>

<p>Within the expression on the right-hand side of a rule, the following
expressions are used to match strings of one or more characters:
<glist>
<gitem>
<label><code>#xN</code></label>
<def><p>where <code>N</code> is a hexadecimal integer, the
expression matches the character in ISO/IEC 10646 whose canonical
(UCS-4) 
code value, when interpreted as an unsigned binary number, has
the value indicated.  The number of leading zeros in the
<code>#xN</code> form is insignificant; the number of leading
zeros in the corresponding code value 
is governed by the character
encoding in use and is not significant for XML.</p></def>
</gitem>
<gitem>
<label><code>[a-zA-Z]</code>, <code>[#xN-#xN]</code></label>
<def><p>matches any <termref def='dt-character'>character</termref> 
with a value in the range(s) indicated (inclusive).</p></def>
</gitem>
<gitem>
<label><code>[^a-z]</code>, <code>[^#xN-#xN]</code></label>
<def><p>matches any <termref def='dt-character'>character</termref> 
with a value <emph>outside</emph> the
range indicated.</p></def>
</gitem>
<gitem>
<label><code>[^abc]</code>, <code>[^#xN#xN#xN]</code></label>
<def><p>matches any <termref def='dt-character'>character</termref>
with a value not among the characters given.</p></def>
</gitem>
<gitem>
<label><code>"string"</code></label>
<def><p>matches a literal string <termref def="dt-match">matching</termref>
that given inside the double quotes.</p></def>
</gitem>
<gitem>
<label><code>'string'</code></label>
<def><p>matches a literal string <termref def="dt-match">matching</termref>
that given inside the single quotes.</p></def>
</gitem>
</glist>
These symbols may be combined to match more complex patterns as follows,
where <code>A</code> and <code>B</code> represent simple expressions:
<glist>
<gitem>
<label>(<code>expression</code>)</label>
<def><p><code>expression</code> is treated as a unit 
and may be combined as described in this list.</p></def>
</gitem>
<gitem>
<label><code>A?</code></label>
<def><p>matches <code>A</code> or nothing; optional <code>A</code>.</p></def>
</gitem>
<gitem>
<label><code>A B</code></label>
<def><p>matches <code>A</code> followed by <code>B</code>.</p></def>
</gitem>
<gitem>
<label><code>A | B</code></label>
<def><p>matches <code>A</code> or <code>B</code> but not both.</p></def>
</gitem>
<gitem>
<label><code>A - B</code></label>
<def><p>matches any string that matches <code>A</code> but does not match
<code>B</code>.
</p></def>
</gitem>
<gitem>
<label><code>A+</code></label>
<def><p>matches one or more occurrences of <code>A</code>.</p></def>
</gitem>
<gitem>
<label><code>A*</code></label>
<def><p>matches zero or more occurrences of <code>A</code>.</p></def>
</gitem>

</glist>
Other notations used in the productions are:
<glist>
<gitem>
<label><code>/* ... */</code></label>
<def><p>comment.</p></def>
</gitem>
<gitem>
<label><code>[ wfc: ... ]</code></label>
<def><p>well-formedness constraint; this identifies by name a 
constraint on 
<termref def="dt-wellformed">well-formed</termref> documents
associated with a production.</p></def>
</gitem>
<gitem>
<label><code>[ vc: ... ]</code></label>
<def><p>validity constraint; this identifies by name a constraint on
<termref def="dt-valid">valid</termref> documents associated with
a production.</p></def>
</gitem>
</glist>
</p></div1>

</body>
<back>
<!-- &SGML; -->
 

<!-- &Biblio; -->
<div1 id='sec-bibliography'>

<head>References</head>
<div2 id='sec-existing-stds'>
<head>Normative References</head>

<blist>
<bibl id='IANA' key='IANA'>
(Internet Assigned Numbers Authority) <emph>Official Names for 
Character Sets</emph>,
ed. Keld Simonsen et al.
See <loc href='ftp://ftp.isi.edu/in-notes/iana/assignments/character-sets'>ftp://ftp.isi.edu/in-notes/iana/assignments/character-sets</loc>.
</bibl>

<bibl id='RFC1766' key='IETF RFC 1766'>
IETF (Internet Engineering Task Force).
<emph>RFC 1766:  Tags for the Identification of Languages</emph>,
ed. H. Alvestrand.
1995.
</bibl>

<bibl id='ISO639' key='ISO 639'>
(International Organization for Standardization).
<emph>ISO 639:1988 (E).
Code for the representation of names of languages.</emph>
[Geneva]:  International Organization for
Standardization, 1988.</bibl>

<bibl id='ISO3166' key='ISO 3166'>
(International Organization for Standardization).
<emph>ISO 3166-1:1997 (E).
Codes for the representation of names of countries and their subdivisions 
&mdash; Part 1: Country codes</emph>
[Geneva]:  International Organization for
Standardization, 1997.</bibl>

<bibl id='ISO10646' key='ISO/IEC 10646'>ISO
(International Organization for Standardization).
<emph>ISO/IEC 10646-1993 (E).  Information technology &mdash; Universal
Multiple-Octet Coded Character Set (UCS) &mdash; Part 1:
Architecture and Basic Multilingual Plane.</emph>
[Geneva]:  International Organization for
Standardization, 1993 (plus amendments AM 1 through AM 7).
</bibl>

<bibl id='Unicode' key='Unicode'>The Unicode Consortium.
<emph>The Unicode Standard, Version 2.0.</emph>
Reading, Mass.:  Addison-Wesley Developers Press, 1996.</bibl>

</blist>

</div2>

<div2><head>Other References</head> 

<blist>

<bibl id='Aho' key='Aho/Ullman'>Aho, Alfred V., 
Ravi Sethi, and Jeffrey D. Ullman.
<emph>Compilers:  Principles, Techniques, and Tools</emph>.
Reading:  Addison-Wesley, 1986, rpt. corr. 1988.</bibl>

<bibl id="Berners-Lee" xml-link="simple" key="Berners-Lee et al.">
Berners-Lee, T., R. Fielding, and L. Masinter.
<emph>Uniform Resource Identifiers (URI):  Generic Syntax and
Semantics</emph>.
1997.
(Work in progress; see updates to RFC1738.)</bibl>

<bibl id='ABK' key='Br�ggemann-Klein'>Br�ggemann-Klein, Anne.
<emph>Regular Expressions into Finite Automata</emph>.
Extended abstract in I. Simon, Hrsg., LATIN 1992, 
S. 97-98. Springer-Verlag, Berlin 1992. 
Full Version in Theoretical Computer Science 120: 197-213, 1993.

</bibl>

<bibl id='ABKDW' key='Br�ggemann-Klein and Wood'>Br�ggemann-Klein, Anne,
and Derick Wood.
<emph>Deterministic Regular Languages</emph>.
Universit�t Freiburg, Institut f�r Informatik,
Bericht 38, Oktober 1991.
</bibl>

<bibl id='Clark' key='Clark'>James Clark.
Comparison of SGML and XML. See
<loc href='http://www.w3.org/TR/NOTE-sgml-xml-971215'>http://www.w3.org/TR/NOTE-sgml-xml-971215</loc>.
</bibl>
<bibl id="RFC1738" xml-link="simple" key="IETF RFC1738">
IETF (Internet Engineering Task Force).
<emph>RFC 1738:  Uniform Resource Locators (URL)</emph>, 
ed. T. Berners-Lee, L. Masinter, M. McCahill.
1994.
</bibl>

<bibl id="RFC1808" xml-link="simple" key="IETF RFC1808">
IETF (Internet Engineering Task Force).
<emph>RFC 1808:  Relative Uniform Resource Locators</emph>, 
ed. R. Fielding.
1995.
</bibl>

<bibl id="RFC2141" xml-link="simple" key="IETF RFC2141">
IETF (Internet Engineering Task Force).
<emph>RFC 2141:  URN Syntax</emph>, 
ed. R. Moats.
1997.
</bibl>

<bibl id='ISO8879' key='ISO 8879'>ISO
(International Organization for Standardization).
<emph>ISO 8879:1986(E).  Information processing &mdash; Text and Office
Systems &mdash; Standard Generalized Markup Language (SGML).</emph>  First
edition &mdash; 1986-10-15.  [Geneva]:  International Organization for
Standardization, 1986.
</bibl>


<bibl id='ISO10744' key='ISO/IEC 10744'>ISO
(International Organization for Standardization).
<emph>ISO/IEC 10744-1992 (E).  Information technology &mdash;
Hypermedia/Time-based Structuring Language (HyTime).
</emph>
[Geneva]:  International Organization for
Standardization, 1992.
<emph>Extended Facilities Annexe.</emph>
[Geneva]:  International Organization for
Standardization, 1996. 
</bibl>



</blist>
</div2>
</div1>
<div1 id='CharClasses'>
<head>Character Classes</head>
<p>Following the characteristics defined in the Unicode standard,
characters are classed as base characters (among others, these
contain the alphabetic characters of the Latin alphabet, without
diacritics), ideographic characters, and combining characters (among
others, this class contains most diacritics); these classes combine
to form the class of letters.  Digits and extenders are
also distinguished.
<scrap lang="ebnf" id="CHARACTERS">
<head>Characters</head>
<prodgroup pcw3="3" pcw4="15">
<prod id="NT-Letter"><lhs>Letter</lhs>
<rhs><nt def="NT-BaseChar">BaseChar</nt> 
| <nt def="NT-Ideographic">Ideographic</nt></rhs> </prod>
<prod id='NT-BaseChar'><lhs>BaseChar</lhs>
<rhs>[#x0041-#x005A]
|&nbsp;[#x0061-#x007A]
|&nbsp;[#x00C0-#x00D6]
|&nbsp;[#x00D8-#x00F6]
|&nbsp;[#x00F8-#x00FF]
|&nbsp;[#x0100-#x0131]
|&nbsp;[#x0134-#x013E]
|&nbsp;[#x0141-#x0148]
|&nbsp;[#x014A-#x017E]
|&nbsp;[#x0180-#x01C3]
|&nbsp;[#x01CD-#x01F0]
|&nbsp;[#x01F4-#x01F5]
|&nbsp;[#x01FA-#x0217]
|&nbsp;[#x0250-#x02A8]
|&nbsp;[#x02BB-#x02C1]
|&nbsp;#x0386
|&nbsp;[#x0388-#x038A]
|&nbsp;#x038C
|&nbsp;[#x038E-#x03A1]
|&nbsp;[#x03A3-#x03CE]
|&nbsp;[#x03D0-#x03D6]
|&nbsp;#x03DA
|&nbsp;#x03DC
|&nbsp;#x03DE
|&nbsp;#x03E0
|&nbsp;[#x03E2-#x03F3]
|&nbsp;[#x0401-#x040C]
|&nbsp;[#x040E-#x044F]
|&nbsp;[#x0451-#x045C]
|&nbsp;[#x045E-#x0481]
|&nbsp;[#x0490-#x04C4]
|&nbsp;[#x04C7-#x04C8]
|&nbsp;[#x04CB-#x04CC]
|&nbsp;[#x04D0-#x04EB]
|&nbsp;[#x04EE-#x04F5]
|&nbsp;[#x04F8-#x04F9]
|&nbsp;[#x0531-#x0556]
|&nbsp;#x0559
|&nbsp;[#x0561-#x0586]
|&nbsp;[#x05D0-#x05EA]
|&nbsp;[#x05F0-#x05F2]
|&nbsp;[#x0621-#x063A]
|&nbsp;[#x0641-#x064A]
|&nbsp;[#x0671-#x06B7]
|&nbsp;[#x06BA-#x06BE]
|&nbsp;[#x06C0-#x06CE]
|&nbsp;[#x06D0-#x06D3]
|&nbsp;#x06D5
|&nbsp;[#x06E5-#x06E6]
|&nbsp;[#x0905-#x0939]
|&nbsp;#x093D
|&nbsp;[#x0958-#x0961]
|&nbsp;[#x0985-#x098C]
|&nbsp;[#x098F-#x0990]
|&nbsp;[#x0993-#x09A8]
|&nbsp;[#x09AA-#x09B0]
|&nbsp;#x09B2
|&nbsp;[#x09B6-#x09B9]
|&nbsp;[#x09DC-#x09DD]
|&nbsp;[#x09DF-#x09E1]
|&nbsp;[#x09F0-#x09F1]
|&nbsp;[#x0A05-#x0A0A]
|&nbsp;[#x0A0F-#x0A10]
|&nbsp;[#x0A13-#x0A28]
|&nbsp;[#x0A2A-#x0A30]
|&nbsp;[#x0A32-#x0A33]
|&nbsp;[#x0A35-#x0A36]
|&nbsp;[#x0A38-#x0A39]
|&nbsp;[#x0A59-#x0A5C]
|&nbsp;#x0A5E
|&nbsp;[#x0A72-#x0A74]
|&nbsp;[#x0A85-#x0A8B]
|&nbsp;#x0A8D
|&nbsp;[#x0A8F-#x0A91]
|&nbsp;[#x0A93-#x0AA8]
|&nbsp;[#x0AAA-#x0AB0]
|&nbsp;[#x0AB2-#x0AB3]
|&nbsp;[#x0AB5-#x0AB9]
|&nbsp;#x0ABD
|&nbsp;#x0AE0
|&nbsp;[#x0B05-#x0B0C]
|&nbsp;[#x0B0F-#x0B10]
|&nbsp;[#x0B13-#x0B28]
|&nbsp;[#x0B2A-#x0B30]
|&nbsp;[#x0B32-#x0B33]
|&nbsp;[#x0B36-#x0B39]
|&nbsp;#x0B3D
|&nbsp;[#x0B5C-#x0B5D]
|&nbsp;[#x0B5F-#x0B61]
|&nbsp;[#x0B85-#x0B8A]
|&nbsp;[#x0B8E-#x0B90]
|&nbsp;[#x0B92-#x0B95]
|&nbsp;[#x0B99-#x0B9A]
|&nbsp;#x0B9C
|&nbsp;[#x0B9E-#x0B9F]
|&nbsp;[#x0BA3-#x0BA4]
|&nbsp;[#x0BA8-#x0BAA]
|&nbsp;[#x0BAE-#x0BB5]
|&nbsp;[#x0BB7-#x0BB9]
|&nbsp;[#x0C05-#x0C0C]
|&nbsp;[#x0C0E-#x0C10]
|&nbsp;[#x0C12-#x0C28]
|&nbsp;[#x0C2A-#x0C33]
|&nbsp;[#x0C35-#x0C39]
|&nbsp;[#x0C60-#x0C61]
|&nbsp;[#x0C85-#x0C8C]
|&nbsp;[#x0C8E-#x0C90]
|&nbsp;[#x0C92-#x0CA8]
|&nbsp;[#x0CAA-#x0CB3]
|&nbsp;[#x0CB5-#x0CB9]
|&nbsp;#x0CDE
|&nbsp;[#x0CE0-#x0CE1]
|&nbsp;[#x0D05-#x0D0C]
|&nbsp;[#x0D0E-#x0D10]
|&nbsp;[#x0D12-#x0D28]
|&nbsp;[#x0D2A-#x0D39]
|&nbsp;[#x0D60-#x0D61]
|&nbsp;[#x0E01-#x0E2E]
|&nbsp;#x0E30
|&nbsp;[#x0E32-#x0E33]
|&nbsp;[#x0E40-#x0E45]
|&nbsp;[#x0E81-#x0E82]
|&nbsp;#x0E84
|&nbsp;[#x0E87-#x0E88]
|&nbsp;#x0E8A
|&nbsp;#x0E8D
|&nbsp;[#x0E94-#x0E97]
|&nbsp;[#x0E99-#x0E9F]
|&nbsp;[#x0EA1-#x0EA3]
|&nbsp;#x0EA5
|&nbsp;#x0EA7
|&nbsp;[#x0EAA-#x0EAB]
|&nbsp;[#x0EAD-#x0EAE]
|&nbsp;#x0EB0
|&nbsp;[#x0EB2-#x0EB3]
|&nbsp;#x0EBD
|&nbsp;[#x0EC0-#x0EC4]
|&nbsp;[#x0F40-#x0F47]
|&nbsp;[#x0F49-#x0F69]
|&nbsp;[#x10A0-#x10C5]
|&nbsp;[#x10D0-#x10F6]
|&nbsp;#x1100
|&nbsp;[#x1102-#x1103]
|&nbsp;[#x1105-#x1107]
|&nbsp;#x1109
|&nbsp;[#x110B-#x110C]
|&nbsp;[#x110E-#x1112]
|&nbsp;#x113C
|&nbsp;#x113E
|&nbsp;#x1140
|&nbsp;#x114C
|&nbsp;#x114E
|&nbsp;#x1150
|&nbsp;[#x1154-#x1155]
|&nbsp;#x1159
|&nbsp;[#x115F-#x1161]
|&nbsp;#x1163
|&nbsp;#x1165
|&nbsp;#x1167
|&nbsp;#x1169
|&nbsp;[#x116D-#x116E]
|&nbsp;[#x1172-#x1173]
|&nbsp;#x1175
|&nbsp;#x119E
|&nbsp;#x11A8
|&nbsp;#x11AB
|&nbsp;[#x11AE-#x11AF]
|&nbsp;[#x11B7-#x11B8]
|&nbsp;#x11BA
|&nbsp;[#x11BC-#x11C2]
|&nbsp;#x11EB
|&nbsp;#x11F0
|&nbsp;#x11F9
|&nbsp;[#x1E00-#x1E9B]
|&nbsp;[#x1EA0-#x1EF9]
|&nbsp;[#x1F00-#x1F15]
|&nbsp;[#x1F18-#x1F1D]
|&nbsp;[#x1F20-#x1F45]
|&nbsp;[#x1F48-#x1F4D]
|&nbsp;[#x1F50-#x1F57]
|&nbsp;#x1F59
|&nbsp;#x1F5B
|&nbsp;#x1F5D
|&nbsp;[#x1F5F-#x1F7D]
|&nbsp;[#x1F80-#x1FB4]
|&nbsp;[#x1FB6-#x1FBC]
|&nbsp;#x1FBE
|&nbsp;[#x1FC2-#x1FC4]
|&nbsp;[#x1FC6-#x1FCC]
|&nbsp;[#x1FD0-#x1FD3]
|&nbsp;[#x1FD6-#x1FDB]
|&nbsp;[#x1FE0-#x1FEC]
|&nbsp;[#x1FF2-#x1FF4]
|&nbsp;[#x1FF6-#x1FFC]
|&nbsp;#x2126
|&nbsp;[#x212A-#x212B]
|&nbsp;#x212E
|&nbsp;[#x2180-#x2182]
|&nbsp;[#x3041-#x3094]
|&nbsp;[#x30A1-#x30FA]
|&nbsp;[#x3105-#x312C]
|&nbsp;[#xAC00-#xD7A3]
</rhs></prod>
<prod id='NT-Ideographic'><lhs>Ideographic</lhs>
<rhs>[#x4E00-#x9FA5]
|&nbsp;#x3007
|&nbsp;[#x3021-#x3029]
</rhs></prod>
<prod id='NT-CombiningChar'><lhs>CombiningChar</lhs>
<rhs>[#x0300-#x0345]
|&nbsp;[#x0360-#x0361]
|&nbsp;[#x0483-#x0486]
|&nbsp;[#x0591-#x05A1]
|&nbsp;[#x05A3-#x05B9]
|&nbsp;[#x05BB-#x05BD]
|&nbsp;#x05BF
|&nbsp;[#x05C1-#x05C2]
|&nbsp;#x05C4
|&nbsp;[#x064B-#x0652]
|&nbsp;#x0670
|&nbsp;[#x06D6-#x06DC]
|&nbsp;[#x06DD-#x06DF]
|&nbsp;[#x06E0-#x06E4]
|&nbsp;[#x06E7-#x06E8]
|&nbsp;[#x06EA-#x06ED]
|&nbsp;[#x0901-#x0903]
|&nbsp;#x093C
|&nbsp;[#x093E-#x094C]
|&nbsp;#x094D
|&nbsp;[#x0951-#x0954]
|&nbsp;[#x0962-#x0963]
|&nbsp;[#x0981-#x0983]
|&nbsp;#x09BC
|&nbsp;#x09BE
|&nbsp;#x09BF
|&nbsp;[#x09C0-#x09C4]
|&nbsp;[#x09C7-#x09C8]
|&nbsp;[#x09CB-#x09CD]
|&nbsp;#x09D7
|&nbsp;[#x09E2-#x09E3]
|&nbsp;#x0A02
|&nbsp;#x0A3C
|&nbsp;#x0A3E
|&nbsp;#x0A3F
|&nbsp;[#x0A40-#x0A42]
|&nbsp;[#x0A47-#x0A48]
|&nbsp;[#x0A4B-#x0A4D]
|&nbsp;[#x0A70-#x0A71]
|&nbsp;[#x0A81-#x0A83]
|&nbsp;#x0ABC
|&nbsp;[#x0ABE-#x0AC5]
|&nbsp;[#x0AC7-#x0AC9]
|&nbsp;[#x0ACB-#x0ACD]
|&nbsp;[#x0B01-#x0B03]
|&nbsp;#x0B3C
|&nbsp;[#x0B3E-#x0B43]
|&nbsp;[#x0B47-#x0B48]
|&nbsp;[#x0B4B-#x0B4D]
|&nbsp;[#x0B56-#x0B57]
|&nbsp;[#x0B82-#x0B83]
|&nbsp;[#x0BBE-#x0BC2]
|&nbsp;[#x0BC6-#x0BC8]
|&nbsp;[#x0BCA-#x0BCD]
|&nbsp;#x0BD7
|&nbsp;[#x0C01-#x0C03]
|&nbsp;[#x0C3E-#x0C44]
|&nbsp;[#x0C46-#x0C48]
|&nbsp;[#x0C4A-#x0C4D]
|&nbsp;[#x0C55-#x0C56]
|&nbsp;[#x0C82-#x0C83]
|&nbsp;[#x0CBE-#x0CC4]
|&nbsp;[#x0CC6-#x0CC8]
|&nbsp;[#x0CCA-#x0CCD]
|&nbsp;[#x0CD5-#x0CD6]
|&nbsp;[#x0D02-#x0D03]
|&nbsp;[#x0D3E-#x0D43]
|&nbsp;[#x0D46-#x0D48]
|&nbsp;[#x0D4A-#x0D4D]
|&nbsp;#x0D57
|&nbsp;#x0E31
|&nbsp;[#x0E34-#x0E3A]
|&nbsp;[#x0E47-#x0E4E]
|&nbsp;#x0EB1
|&nbsp;[#x0EB4-#x0EB9]
|&nbsp;[#x0EBB-#x0EBC]
|&nbsp;[#x0EC8-#x0ECD]
|&nbsp;[#x0F18-#x0F19]
|&nbsp;#x0F35
|&nbsp;#x0F37
|&nbsp;#x0F39
|&nbsp;#x0F3E
|&nbsp;#x0F3F
|&nbsp;[#x0F71-#x0F84]
|&nbsp;[#x0F86-#x0F8B]
|&nbsp;[#x0F90-#x0F95]
|&nbsp;#x0F97
|&nbsp;[#x0F99-#x0FAD]
|&nbsp;[#x0FB1-#x0FB7]
|&nbsp;#x0FB9
|&nbsp;[#x20D0-#x20DC]
|&nbsp;#x20E1
|&nbsp;[#x302A-#x302F]
|&nbsp;#x3099
|&nbsp;#x309A
</rhs></prod>
<prod id='NT-Digit'><lhs>Digit</lhs>
<rhs>[#x0030-#x0039]
|&nbsp;[#x0660-#x0669]
|&nbsp;[#x06F0-#x06F9]
|&nbsp;[#x0966-#x096F]
|&nbsp;[#x09E6-#x09EF]
|&nbsp;[#x0A66-#x0A6F]
|&nbsp;[#x0AE6-#x0AEF]
|&nbsp;[#x0B66-#x0B6F]
|&nbsp;[#x0BE7-#x0BEF]
|&nbsp;[#x0C66-#x0C6F]
|&nbsp;[#x0CE6-#x0CEF]
|&nbsp;[#x0D66-#x0D6F]
|&nbsp;[#x0E50-#x0E59]
|&nbsp;[#x0ED0-#x0ED9]
|&nbsp;[#x0F20-#x0F29]
</rhs></prod>
<prod id='NT-Extender'><lhs>Extender</lhs>
<rhs>#x00B7
|&nbsp;#x02D0
|&nbsp;#x02D1
|&nbsp;#x0387
|&nbsp;#x0640
|&nbsp;#x0E46
|&nbsp;#x0EC6
|&nbsp;#x3005
|&nbsp;[#x3031-#x3035]
|&nbsp;[#x309D-#x309E]
|&nbsp;[#x30FC-#x30FE]
</rhs></prod>

</prodgroup>
</scrap>
</p>
<p>The character classes defined here can be derived from the
Unicode character database as follows:
<ulist>
<item>
<p>Name start characters must have one of the categories Ll, Lu,
Lo, Lt, Nl.</p>
</item>
<item>
<p>Name characters other than Name-start characters 
must have one of the categories Mc, Me, Mn, Lm, or Nd.</p>
</item>
<item>
<p>Characters in the compatibility area (i.e. with character code
greater than #xF900 and less than #xFFFE) are not allowed in XML
names.</p>
</item>
<item>
<p>Characters which have a font or compatibility decomposition (i.e. those
with a "compatibility formatting tag" in field 5 of the database --
marked by field 5 beginning with a "&lt;") are not allowed.</p>
</item>
<item>
<p>The following characters are treated as name-start characters
rather than name characters, because the property file classifies
them as Alphabetic:  [#x02BB-#x02C1], #x0559, #x06E5, #x06E6.</p>
</item>
<item>
<p>Characters #x20DD-#x20E0 are excluded (in accordance with 
Unicode, section 5.14).</p>
</item>
<item>
<p>Character #x00B7 is classified as an extender, because the
property list so identifies it.</p>
</item>
<item>
<p>Character #x0387 is added as a name character, because #x00B7
is its canonical equivalent.</p>
</item>
<item>
<p>Characters ':' and '_' are allowed as name-start characters.</p>
</item>
<item>
<p>Characters '-' and '.' are allowed as name characters.</p>
</item>
</ulist>
</p>
</div1>
<inform-div1 id="sec-xml-and-sgml">
<head>XML and SGML</head>
 
<p>XML is designed to be a subset of SGML, in that every
<termref def="dt-valid">valid</termref> XML document should also be a
conformant SGML document.
For a detailed comparison of the additional restrictions that XML places on
documents beyond those of SGML, see <bibref ref='Clark'/>.
</p>
</inform-div1>
<inform-div1 id="sec-entexpand">
<head>Expansion of Entity and Character References</head>
<p>This appendix contains some examples illustrating the
sequence of entity- and character-reference recognition and
expansion, as specified in <specref ref='entproc'/>.</p>
<p>
If the DTD contains the declaration 
<eg><![CDATA[<!ENTITY example "<p>An ampersand (&#38;#38;) may be escaped
numerically (&#38;#38;#38;) or with a general entity
(&amp;amp;).</p>" >
]]></eg>
then the XML processor will recognize the character references 
when it parses the entity declaration, and resolve them before 
storing the following string as the
value of the entity "<code>example</code>":
<eg><![CDATA[<p>An ampersand (&#38;) may be escaped
numerically (&#38;#38;) or with a general entity
(&amp;amp;).</p>
]]></eg>
A reference in the document to "<code>&amp;example;</code>" 
will cause the text to be reparsed, at which time the 
start- and end-tags of the "<code>p</code>" element will be recognized 
and the three references will be recognized and expanded, 
resulting in a "<code>p</code>" element with the following content
(all data, no delimiters or markup):
<eg><![CDATA[An ampersand (&) may be escaped
numerically (&#38;) or with a general entity
(&amp;).
]]></eg>
</p>
<p>A more complex example will illustrate the rules and their
effects fully.  In the following example, the line numbers are
solely for reference.
<eg><![CDATA[1 <?xml version='1.0'?>
2 <!DOCTYPE test [
3 <!ELEMENT test (#PCDATA) >
4 <!ENTITY % xx '&#37;zz;'>
5 <!ENTITY % zz '&#60;!ENTITY tricky "error-prone" >' >
6 %xx;
7 ]>
8 <test>This sample shows a &tricky; method.</test>
]]></eg>
This produces the following:
<ulist spacing="compact">
<item><p>in line 4, the reference to character 37 is expanded immediately,
and the parameter entity "<code>xx</code>" is stored in the symbol
table with the value "<code>%zz;</code>".  Since the replacement text
is not rescanned, the reference to parameter entity "<code>zz</code>"
is not recognized.  (And it would be an error if it were, since
"<code>zz</code>" is not yet declared.)</p></item>
<item><p>in line 5, the character reference "<code>&amp;#60;</code>" is
expanded immediately and the parameter entity "<code>zz</code>" is
stored with the replacement text 
"<code>&lt;!ENTITY tricky "error-prone" ></code>",
which is a well-formed entity declaration.</p></item>
<item><p>in line 6, the reference to "<code>xx</code>" is recognized,
and the replacement text of "<code>xx</code>" (namely 
"<code>%zz;</code>") is parsed.  The reference to "<code>zz</code>"
is recognized in its turn, and its replacement text 
("<code>&lt;!ENTITY tricky "error-prone" ></code>") is parsed.
The general entity "<code>tricky</code>" has now been
declared, with the replacement text "<code>error-prone</code>".</p></item>
<item><p>
in line 8, the reference to the general entity "<code>tricky</code>" is
recognized, and it is expanded, so the full content of the
"<code>test</code>" element is the self-describing (and ungrammatical) string
<emph>This sample shows a error-prone method.</emph>
</p></item>
</ulist>
</p>
</inform-div1> 
<inform-div1 id="determinism">
<head>Deterministic Content Models</head>
<p><termref def='dt-compat'>For compatibility</termref>, it is
required
that content models in element type declarations be deterministic.  
</p>
<!-- FINAL EDIT:  WebSGML allows ambiguity? -->
<p>SGML
requires deterministic content models (it calls them
"unambiguous"); XML processors built using SGML systems may
flag non-deterministic content models as errors.</p>
<p>For example, the content model <code>((b, c) | (b, d))</code> is
non-deterministic, because given an initial <code>b</code> the parser
cannot know which <code>b</code> in the model is being matched without
looking ahead to see which element follows the <code>b</code>.
In this case, the two references to
<code>b</code> can be collapsed 
into a single reference, making the model read
<code>(b, (c | d))</code>.  An initial <code>b</code> now clearly
matches only a single name in the content model.  The parser doesn't
need to look ahead to see what follows; either <code>c</code> or
<code>d</code> would be accepted.</p>
<p>More formally:  a finite state automaton may be constructed from the
content model using the standard algorithms, e.g. algorithm 3.5 
in section 3.9
of Aho, Sethi, and Ullman <bibref ref='Aho'/>.
In many such algorithms, a follow set is constructed for each 
position in the regular expression (i.e., each leaf 
node in the 
syntax tree for the regular expression);
if any position has a follow set in which 
more than one following position is 
labeled with the same element type name, 
then the content model is in error
and may be reported as an error.
</p>
<p>Algorithms exist which allow many but not all non-deterministic
content models to be reduced automatically to equivalent deterministic
models; see Br�ggemann-Klein 1991 <bibref ref='ABK'/>.</p>
</inform-div1>
<inform-div1 id="sec-guessing">
<head>Autodetection of Character Encodings</head>
<p>The XML encoding declaration functions as an internal label on each
entity, indicating which character encoding is in use.  Before an XML
processor can read the internal label, however, it apparently has to
know what character encoding is in use&mdash;which is what the internal label
is trying to indicate.  In the general case, this is a hopeless
situation. It is not entirely hopeless in XML, however, because XML
limits the general case in two ways:  each implementation is assumed
to support only a  finite set of character encodings, and the XML
encoding declaration is restricted in position and content in order to
make it feasible to autodetect the character encoding in use in each
entity in normal cases.  Also, in many cases other sources of information
are available in addition to the XML data stream itself.  
Two cases may be distinguished, 
depending on whether the XML entity is presented to the
processor without, or with, any accompanying
(external) information.  We consider the first case first.
</p>
<p>
Because each XML entity not in UTF-8 or UTF-16 format <emph>must</emph>
begin with an XML encoding declaration, in which the first  characters
must be '<code>&lt;?xml</code>', any conforming processor can detect,
after two to four octets of input, which of the following cases apply. 
In reading this list, it may help to know that in UCS-4, '&lt;' is
"<code>#x0000003C</code>" and '?' is "<code>#x0000003F</code>", and the Byte
Order Mark required of UTF-16 data streams is "<code>#xFEFF</code>".</p>
<p>
<ulist>
<item>
<p><code>00 00 00 3C</code>: UCS-4, big-endian machine (1234 order)</p>
</item>
<item>
<p><code>3C 00 00 00</code>: UCS-4, little-endian machine (4321 order)</p>
</item>
<item>
<p><code>00 00 3C 00</code>: UCS-4, unusual octet order (2143)</p>
</item>
<item>
<p><code>00 3C 00 00</code>: UCS-4, unusual octet order (3412)</p>
</item>
<item>
<p><code>FE FF</code>: UTF-16, big-endian</p>
</item>
<item>
<p><code>FF FE</code>: UTF-16, little-endian</p>
</item>
<item>
<p><code>00 3C 00 3F</code>: UTF-16, big-endian, no Byte Order Mark
(and thus, strictly speaking, in error)</p>
</item>
<item>
<p><code>3C 00 3F 00</code>: UTF-16, little-endian, no Byte Order Mark
(and thus, strictly speaking, in error)</p>
</item>
<item>
<p><code>3C 3F 78 6D</code>: UTF-8, ISO 646, ASCII, some part of ISO 8859, 
Shift-JIS, EUC, or any other 7-bit, 8-bit, or mixed-width encoding
which ensures that the characters of ASCII have their normal positions,
width,
and values; the actual encoding declaration must be read to 
detect which of these applies, but since all of these encodings
use the same bit patterns for the ASCII characters, the encoding 
declaration itself may be read reliably
</p>
</item>
<item>
<p><code>4C 6F A7 94</code>: EBCDIC (in some flavor; the full
encoding declaration must be read to tell which code page is in 
use)</p>
</item>
<item>
<p>other: UTF-8 without an encoding declaration, or else 
the data stream is corrupt, fragmentary, or enclosed in
a wrapper of some kind</p>
</item>
</ulist>
</p>
<p>
This level of autodetection is enough to read the XML encoding
declaration and parse the character-encoding identifier, which is
still necessary to distinguish the individual members of each family
of encodings (e.g. to tell  UTF-8 from 8859, and the parts of 8859
from each other, or to distinguish the specific EBCDIC code page in
use, and so on).
</p>
<p>
Because the contents of the encoding declaration are restricted to
ASCII characters, a processor can reliably read the entire encoding
declaration as soon as it has detected which family of encodings is in
use.  Since in practice, all widely used character encodings fall into
one of the categories above, the XML encoding declaration allows
reasonably reliable in-band labeling of character encodings, even when
external sources of information at the operating-system or
transport-protocol level are unreliable.
</p>
<p>
Once the processor has detected the character encoding in use, it can
act appropriately, whether by invoking a separate input routine for
each case, or by calling the proper conversion function on each
character of input. 
</p>
<p>
Like any self-labeling system, the XML encoding declaration will not
work if any software changes the entity's character set or encoding
without updating the encoding declaration.  Implementors of
character-encoding routines should be careful to ensure the accuracy
of the internal and external information used to label the entity.
</p>
<p>The second possible case occurs when the XML entity is accompanied
by encoding information, as in some file systems and some network
protocols.
When multiple sources of information are available,

their relative
priority and the preferred method of handling conflict should be
specified as part of the higher-level protocol used to deliver XML.
Rules for the relative priority of the internal label and the
MIME-type label in an external header, for example, should be part of the
RFC document defining the text/xml and application/xml MIME types. In
the interests of interoperability, however, the following rules
are recommended.
<ulist>
<item><p>If an XML entity is in a file, the Byte-Order Mark
and encoding-declaration PI are used (if present) to determine the
character encoding.  All other heuristics and sources of information
are solely for error recovery.
</p></item>
<item><p>If an XML entity is delivered with a
MIME type of text/xml, then the <code>charset</code> parameter
on the MIME type determines the
character encoding method; all other heuristics and sources of
information are solely for error recovery.
</p></item>
<item><p>If an XML entity is delivered 
with a
MIME type of application/xml, then the Byte-Order Mark and
encoding-declaration PI are used (if present) to determine the
character encoding.  All other heuristics and sources of
information are solely for error recovery.
</p></item>
</ulist>
These rules apply only in the absence of protocol-level documentation;
in particular, when the MIME types text/xml and application/xml are
defined, the recommendations of the relevant RFC will supersede
these rules.
</p>

</inform-div1>

<inform-div1 id="sec-xml-wg">
<head>W3C XML Working Group</head>
 
<p>This specification was prepared and approved for publication by the
W3C XML Working Group (WG).  WG approval of this specification does
not necessarily imply that all WG members voted for its approval.  
The current and former members of the XML WG are:</p>
 
<orglist>
<member><name>Jon Bosak, Sun</name><role>Chair</role></member>
<member><name>James Clark</name><role>Technical Lead</role></member>
<member><name>Tim Bray, Textuality and Netscape</name><role>XML Co-editor</role></member>
<member><name>Jean Paoli, Microsoft</name><role>XML Co-editor</role></member>
<member><name>C. M. Sperberg-McQueen, U. of Ill.</name><role>XML
Co-editor</role></member>
<member><name>Dan Connolly, W3C</name><role>W3C Liaison</role></member>
<member><name>Paula Angerstein, Texcel</name></member>
<member><name>Steve DeRose, INSO</name></member>
<member><name>Dave Hollander, HP</name></member>
<member><name>Eliot Kimber, ISOGEN</name></member>
<member><name>Eve Maler, ArborText</name></member>
<member><name>Tom Magliery, NCSA</name></member>
<member><name>Murray Maloney, Muzmo and Grif</name></member>
<member><name>Makoto Murata, Fuji Xerox Information Systems</name></member>
<member><name>Joel Nava, Adobe</name></member>
<member><name>Conleth O'Connell, Vignette</name></member>
<member><name>Peter Sharpe, SoftQuad</name></member>
<member><name>John Tigue, DataChannel</name></member>
</orglist>

</inform-div1>
</back>
</spec>
<!-- Keep this comment at the end of the file
Local variables:
mode: sgml
sgml-default-dtd-file:"~/sgml/spec.ced"
sgml-omittag:t
sgml-shorttag:t
End:
-->
};
$expected = q{};

$p = XML::XSLT->new($xsl, "STRING");
$p->transform_document ($xml, "STRING");
$r = $p->result_string;

print "not "
  unless $r eq $expected;
print "ok 1\n";
