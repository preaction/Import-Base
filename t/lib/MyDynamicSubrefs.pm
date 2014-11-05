package
    MyDynamicSubrefs;

use strict;
use warnings;
use base 'MyDynamic';

sub modules {
    my ( $class, $bundles, $args ) = @_;
    my @modules = (
        '-strict' => sub { return [ 'vars' ] },
        sub { return -warnings => [qw( uninitialized )] },
    );
    my %bundles = (
        'Spec' => [
            'File::Spec::Functions' => [qw( catfile )],
        ],
        Lax => [
            '-strict',
            sub {
                my ( $bundles, $args ) = @_;
                return '-warnings';
            },
        ],
        Inherit => [
            sub {
                my ( $bundles, $args ) = @_;
                no strict 'refs';
                my $class = caller 1;
                push @{ "${class}::ISA" }, 'inherited';
                return;
            },
        ],
    );
    return $class->SUPER::modules( $bundles, $args ),
        @modules,
        map { @{ $bundles{ $_ } } } grep { exists $bundles{ $_ } } @$bundles;
}

package
    inherited; # dummy package to inherit from

1;
