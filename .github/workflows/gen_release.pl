#!/usr/bin/perl

# This script came from Text::Lorem extension:
# https://fastapi.metacpan.org/source/BLAINEM/Text-Lorem-0.31/lib/Text/Lorem.pm
# Opted to use here directly just to avoid the need of installing it at
# the workflow VM
#
package Lorem;

use strict;
use warnings;
use vars qw($VERSION);

$VERSION = "0.31";

my $lorem_singleton;

sub new {
  my $class = shift;
  $lorem_singleton ||= bless {},$class;
  return $lorem_singleton;
}

sub generate_wordlist {
  my $self = shift;
  [ map { s/\W//; lc($_) }split(/\s+/, <DATA>) ];
}

sub wordlist {
  my $self = shift;
  $self->{ wordlist } ||= $self->generate_wordlist();
}

sub wordcount {
  my $self = shift;
  return scalar(@{$self->{ wordlist }});
}

sub get_word {
  my $self = shift;
  return $self->wordlist->[ int( rand( $self->wordcount ) ) ];
}

sub words {
  my $self = shift;
  my $num  = shift;
  my @words;
  push @words, $self->get_word() for (1..$num);
  return join(' ', @words);
}

sub get_sentence {
  my $self = shift;
  my $words = $self->words( 4 + int( rand( 6 ) ) );
  ucfirst( $words );
}

sub sentences {
  my $self = shift;
  my $num = shift;
  my @sentences;
  push @sentences, $self->get_sentence for (1..$num);
  join( '. ', @sentences ) . '.';
}

sub get_paragraph {
  my $self = shift;
  my $sentences = $self->sentences(3 + int( rand( 4 ) ) );

}

sub paragraphs {
  my $self = shift;
  my $num = shift;
  my @paragraphs;
  push @paragraphs, $self->get_paragraph for (1..$num);
  join( "\n\n", @paragraphs );
}

#
# MAIN
#

my $body_path = shift or die "Need a file name to store the release body";

my $text = Lorem->new();

# Generate 3 paragraphs
my $txt = $text->paragraphs(3);

open OUT, ">$body_path" or die("error creating $body_path");
print OUT $txt or die("error writing to $body_path");
close OUT or die("error closing $body_path");


# From https://fastapi.metacpan.org/source/BLAINEM/Text-Lorem-0.31/lib/Text/Lorem.pm

__DATA__
alias consequatur aut perferendis sit voluptatem accusantium doloremque aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis Nemo enim ipsam voluptatem quia voluptas sit suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae  et iusto odio dignissimos ducimus qui blanditiis praesentium laudantium, totam rem voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, Sed ut perspiciatis unde omnis iste natus error similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo porro quisquam est, qui minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur? At vero eos et accusamus officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores doloribus asperiores repellat.
