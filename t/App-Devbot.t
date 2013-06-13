#!/usr/bin/perl -w
use v5.14;
use warnings;
no warnings 'redefine';

use Test::More tests => 9;
BEGIN { use_ok('App::Devbot') };

use List::MoreUtils qw/natatime/;
use POE;

sub call_poe{
  my ($func, @args)=@_;
  my (@arglist, @values);

  my $it=natatime 2, @args;
  $arglist[$values[0]]=$values[1] while (@values = $it->());
  $func->(@arglist)
}

*App::Devbot::mode_char = sub { ' ' };

*App::Devbot::log_event = sub { shift; is "@_", '< nick> Hello, world!', 'public' };
call_poe \&App::Devbot::on_public, ARG0, 'nick!user@host', ARG1, ['#channel'], ARG2, 'Hello, world!';

*App::Devbot::log_event = sub { shift; is "@_", '* nick nicked', 'action'};
call_poe \&App::Devbot::on_ctcp_action, ARG0, 'nick!user@host', ARG1, ['#channel'], ARG2, 'nicked';

*App::Devbot::log_event = sub { shift; is "@_", '-!- nick [user@host] has joined #channel', 'join' };
call_poe \&App::Devbot::on_join, ARG0, 'nick!user@host', ARG1, '#channel';

*App::Devbot::log_event = sub { shift; is "@_", '-!- nick [user@host] has left #channel [Leaving!]', 'part'};
call_poe \&App::Devbot::on_part, ARG0, 'nick!user@host', ARG1, '#channel', ARG2, 'Leaving!';

*App::Devbot::log_event = sub { shift; is "@_", '-!- idiot was kicked from #channel by nick [no reason]', 'kick'};
call_poe \&App::Devbot::on_kick, ARG0, 'nick!user@host', ARG1, '#channel', ARG2, 'idiot', ARG3, 'no reason';

*App::Devbot::log_event = sub { shift; is "@_", '-!- mode/#channel [+oo mgv mgvx] by ChanServ', 'mode'};
call_poe \&App::Devbot::on_mode, ARG0, 'ChanServ!user@host', ARG1, '#channel', ARG2, '+oo', ARG3, 'mgv', ARG4, 'mgvx';

*App::Devbot::log_event = sub { shift; is "@_", '-!- nick changed the topic of #channel to: Go away!', 'topic set'};
call_poe \&App::Devbot::on_topic, ARG0, 'nick!user@host', ARG1, '#channel', ARG2, 'Go away!';

*App::Devbot::log_event = sub { shift; is "@_", '-!- Topic unset by nick on #channel', 'topic unset'};
call_poe \&App::Devbot::on_topic, ARG0, 'nick!user@host', ARG1, '#channel', ARG2, '';

