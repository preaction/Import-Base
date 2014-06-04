package Import::Base;
# ABSTRACT: Import a set of modules into the calling module

use strict;
use warnings;
use Import::Into;
use Module::Runtime qw( use_module );

sub modules {
    return ();
}

sub import {
    my ( $class, %args ) = @_;

    die "Argument to -exclude must be arrayref"
        if $args{-exclude} && ref $args{-exclude} ne 'ARRAY';
    my $exclude = {};
    if ( $args{-exclude} ) {
        while ( @{ $args{-exclude} } ) {
            my $module = shift @{ $args{-exclude} };
            my $subs = ref $args{-exclude}[0] eq 'ARRAY' ? shift @{ $args{-exclude} } : undef;
            $exclude->{ $module } = $subs;
        }
    }

    my $caller = caller;
    my @modules = $class->modules( %args );
    while ( @modules ) {
        my $module = shift @modules;
        my $imports = ref $modules[0] eq 'ARRAY' ? shift @modules : [];

        if ( exists $exclude->{ $module } ) {
            if ( defined $exclude->{ $module } ) {
                my @left;
                for my $import ( @$imports ) {
                    push @left, $import
                        unless grep { $_ eq $import } @{ $exclude->{ $module } };
                }
                $imports = \@left;
            }
            else {
                next;
            }
        }

        use_module( $module )->import::into( $caller, @{ $imports } );
    }
}

1;
__END__

=head1 SYNOPSIS

    package My::Base;
    use base 'Import::Base';
    sub modules {
        my ( $class, %args ) = @_;
        return (
            strict => [],
            warnings => [],
            'My::Exporter' => [ 'foo', 'bar', 'baz' ],
        );
    }
    1;

    package My::Module;
    use My::Base;

    package My::Other;
    use My::Base -exclude => [ 'warnings', 'My::Exporter' => [ 'bar' ] ];

=head1 DESCRIPTION

This module makes it easier to build and manage a base set of imports. Rather
than importing a dozen modules in each of your project's modules, you simply
import one module and get all the other modules you want. This reduces your
module boilerplate from 12 lines to 1.

=head1 USAGE

=head2 -exclude

When importing a base module, you can use C<-exclude> to prevent certain things
from being imported (if, for example, they would conflict with existing
things).

    # Prevent the "warnings" module from being imported
    use My::Base -exclude => [ 'warnings' ];

    # Prevent the "bar" sub from My::Exporter from being imported
    use My::Base -exclude => [ 'My::Exporter' => [ 'bar' ] ];

NOTE: If you find yourself using C<-exclude> often, you would be better off
removing the module or sub and only including it in those modules that need it.

=head1 METHODS

=head2 modules( %args )

Prepare the list of modules to import. %args comes from the caller's C<use> line.
Returns a list of MODULE => [ import() args ]. MODULE may appear multiple times.

=head1 SEE ALSO

=over

=item L<ToolSet|ToolSet>

This is very similar, but does not appear to allow subclasses to remove imports from
the list of things to be imported. By having the module list be a static array, we
can modify it further in more levels of subclasses.

=item L<Toolkit|Toolkit>

This one requires configuration files in a home directory, so is not shippable.

=item L<rig|rig>

This one also requires configuration files in a home directory, so is not shippable.

=back

