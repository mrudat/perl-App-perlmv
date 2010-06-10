use strict;
use warnings;
use FindBin '$Bin';
use File::Temp qw(tempdir);

our $Perl;
our $Bin;
our $Dir;

sub prepare_for_testing {
    # clean for -T
    ($Perl) = $^X =~ /(.+)/;
    $ENV{PATH} = "/usr/bin:/bin";
    $ENV{ENV} = "";

    my $Dir = tempdir(CLEANUP=>1);
    $ENV{TESTING_HOME} = $Dir;
    chdir $Dir or die "Can't chdir to $Dir: $!";
}

sub create_files {
    do {open F, ">$_"; close F} for @_;
}

sub remove_files {
    for (<*>) { my ($f) = /(.+)/; unlink $f }
}
sub files {
    my @res = sort map { lc } <*>;
    #print "DEBUG: files() = ", join(", ", @res), "\n";
    @res;
}

sub files_are {
    my ($tname, $files) = @_;
    my @rfiles = files();
    is_deeply(\@rfiles, $files, $tname);
}

sub _perlmv {
    my $cmd = shift;
    my @args;
    do { /(.*)/; push @args, $1 } for @_;
    my @cmd =($Perl, "$Bin/../bin/$cmd", @args);
    system @cmd;
    #print "DEBUG: system(", join(", ", @cmd), ")\n";
    die "Can't system(", join(" ", @cmd), "): $?" if $?;
}

sub perlmv   { _perlmv("perlmv",   @_) }
sub perlcp   { _perlmv("perlcp",   @_) }
sub perlln   { _perlmv("perlln",   @_) }
sub perlln_s { _perlmv("perlln_s", @_) }

1;