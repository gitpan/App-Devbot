use 5.014002;
use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'App::Devbot',
  VERSION_FROM  => 'lib/App/Devbot.pm',
  EXE_FILES     => [ 'devbot' ],
  ABSTRACT_FROM => 'lib/App/Devbot.pm',
  AUTHOR        => 'Marius Gavrilescu <marius@ieval.ro>',
  LICENSE       => 'perl',
  PREREQ_PM     => {
	'POE::Component::IRC' => 6.37, #6.37 is the version in Debian squeeze. Hope devbot works with 6.37 :-).
	'IRC::Utils'          => 0,
	'File::Slurp'         => 0,
  },
);
