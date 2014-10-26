
use strict;
use warnings;
use lib 't/lib';
use Test::More;

subtest 'basic static API' => sub {
    subtest 'common imports' => sub {
        eval q{
            package no::strict;
            no strict;
            use MyStatic;
            $foo = 0;
        };

        like $@, qr/Global symbol "\$foo" requires explicit package name/;

        my $warn;
        local $SIG{__WARN__} = sub { $warn = $_[0] };
        eval q{
            package no::warnings;
            no warnings;
            use MyStatic;
            my $foo = 0 + "foo";
        };
        like $warn, qr/Argument "foo" isn't numeric in addition/;
    };

    subtest 'bundles' => sub {
        subtest 'no bundles are imported by default' => sub {
            eval q{
                package without::bundle;
                no strict; no warnings;
                use MyStatic;
                catdir( "", "foo" );
            };

            like $@, qr/\QUndefined subroutine &without::bundle::catdir called/;
        };

        eval q{
            package with::bundle;
            no strict; no warnings;
            use MyStatic 'Spec';
            catdir( "", "foo" );
        };

        unlike $@, qr/\QUndefined subroutine &with::bundle::catdir called/;
    };
};

subtest 'static inheritance' => sub {
    subtest 'common imports' => sub {
        eval q{
            package no::inherited::strict;
            no strict;
            use MyStaticInherits;
            $foo = 0;
            $bar = "foo";
            $$bar = 1;
        };

        unlike $@, qr/Global symbol "\$foo" requires explicit package name/;
        like $@, qr/\QCan't use string ("foo") as a SCALAR ref/;
    };

    subtest 'bundles' => sub {
        subtest 'no bundles are imported by default' => sub {
            eval q{
                package without::inherited::bundle;
                no strict; no warnings;
                use MyStaticInherits;
                catfile( "", "foo" );
            };

            like $@, qr/\QUndefined subroutine &without::inherited::bundle::catfile called/;
        };

        eval q{
            package with::inherited::bundle;
            no strict; no warnings;
            use MyStaticInherits 'Spec';
            catfile( "", "foo" );
            catdir( "", "foo" );
        };

        unlike $@, qr/\QUndefined subroutine &with::inherited::bundle::catdir called/;
        unlike $@, qr/\QUndefined subroutine &with::inherited::bundle::catfile called/;
    };
};

done_testing;
