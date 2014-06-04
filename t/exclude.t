
use strict;
use warnings;
use lib 't/lib';
use Test::More;

subtest 'Exclude an entire module' => sub {
    eval q{
        package exclude::strict;
        no strict;
        use MyImporter -exclude => [ "strict" ];
        $foo = 0;
    };
    unlike $@, qr/Global symbol "\$foo" requires explicit package name/;
};

subtest 'Exclude a single sub from a module' => sub {
    eval q{
        package exclude::single;
        use MyImporter -exclude => [ "Module::Runtime" => [ "is_module_name" ] ];
        is_module_name();
    };
    like $@, qr/Undefined subroutine \&exclude::single::is_module_name called/;
};

subtest '-exclude must be an arrayref' => sub {
    eval q{
        package exclude::error;
        use MyImporter -exclude => 'strict';
    };
    like $@, qr/Argument to -exclude must be arrayref/;
};

done_testing;
