package
    UseCase::Moo::ApplyRole;

use strict;
use warnings;
use Test::More;
use base 'Import::Base';

our %IMPORT_BUNDLES = (
    'Plugin' => [
        'Moo',
        sub {
            my ( $bundles, $args ) = @_;
            Moo::Role->apply_role_to_package( $args->{package}, 'UseCase::Moo::ApplyRole::Role' );
            ();
        },
    ],
);

package
    UseCase::Moo::ApplyRole::Role;
use Moo::Role;
around BUILDARGS => sub { };

1;
