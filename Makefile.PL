

use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME         => 'MooseX::Role::Timer',
    VERSION_FROM => 'lib/MooseX/Role/Timer.pm', # finds \$VERSION
    AUTHOR       => 'Michael Langner (mila@cpan.org)',
    ABSTRACT     => 'Role for measuring elapsed Time',
    PREREQ_PM    => {
                     'Test::More'   => 0.80,
		     'Moose'        => 1.00,
                     'Time::HiRes'  => 1.00
                    },
);
