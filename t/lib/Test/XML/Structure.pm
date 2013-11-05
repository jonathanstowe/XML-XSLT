package Test::XML::Structure;

use strict;
use warnings;

use XML::DOM;

sub compare_attributes
{
    my ( $self, $target, $expect, $element ) = @_;

    my $rc = 0;

    my $parser = XML::DOM::Parser->new();

    my $doc1 = $parser->parse($expect);
    my $doc2 = $parser->parse($target);

    my ($el1) = $doc1->getElementsByTagName($element);

    if ( $el1 )
    {
      my ($el2) = $doc2->getElementsByTagName($element);

      foreach my $attr ($el1->getAttributes()->getValues() )
      {
          if ( my $val = $el2->getAttribute($attr->getName()))
          {
              if ( $val eq $attr->getValue())
              {
                  $rc = 1;
              }
              else
              {
                  $rc = 0;
                  last;
              }
          }
          else
          {
              $rc = 0;
              last;
          }
      }
    }

    return $rc;
}

1;
 

