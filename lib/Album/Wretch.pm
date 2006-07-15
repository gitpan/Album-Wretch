package Album::Wretch;

=head1 NAME

Album::Wretch - Grub Lists for www.wretch.cc

=head1 VERSION

Version 0.01

=head1 DESCRIPTION

Album::Wretch can grub the public part list of album on www.wretch.cc.

=cut

our $VERSION = '0.01';

use strict;
use warnings;

use WWW::Mechanize;

=head1 SYNOPSIS

  use Album::Wretch;

  # get album list
  $album_list = $t->get('username');

=cut

sub new
{
    my $self = shift();

    my $bot = WWW::Mechanize->new('keep_alive' => 1);
    $bot->agent_alias('Windows IE 6');

    my %h = {'bot' => $bot};

    return bless(\%h, $self);
}

sub get
{
    my $self = shift();
    my $username = shift();

    my $bot = $self->[0]{'bot'};
    my $baseurl = sprintf('http://www.wretch.cc/album/%s');

    my $pagemax = 1;
    my %albums;

    for (my $pagenum = 1; $pagenum <= $pagemax; $pagenum++) {
	my $url = "${baseurl}&page=${pagenum}";
	$bot->get($url) or return undef;

	foreach ($bot->links()) {
	    my $url = $_->url_abs();

	    if ($url =~ /^\Q${baseurl}\E\/.*&book=(\d+)$/) {
		$albums{$1} = 1;
	    }

	    if ($url =~ /^\Q${baseurl}\E\/.*&page=(\d+)$/) {
		next if ($1 <= $pagemax);
		$pagemax = $1;
	    }
	}
    }

    my @albums = keys(%albums);
    return \@albums;
}

1;
__END__

=head1 AUTHOR

Gea-Suan Lin, E<lt>gslin@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Gea-Suan Lin

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
