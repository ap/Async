use strict; use warnings;

use Test::More tests => 26;

use Async;

my $proc = Async->new( sub { select undef, undef, undef, 0.5; 'Hello, world!' } );

my @global = qw( $. $@ $! $^E $? );
my %expect; @expect{ @global } = ( $., $@, $!, $^E, $? );

for ( 1 .. 10 ) {
	my $proc = do { local $!; Async->new( sub { '' } ) };
	isa_ok $proc, 'Async';
}

my %have; @have{ @global } = ( $., $@, $!, $^E, $? );
is $have{ $_ }, $expect{ $_ }, $_ for @global;

is $proc->result(1), 'Hello, world!', 'children do not kill their siblings';
