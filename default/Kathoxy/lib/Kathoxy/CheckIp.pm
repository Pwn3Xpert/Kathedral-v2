#!/usr/bin/perl

package Kathoxy::CheckIp;

use JSON;
use LWP::UserAgent;

sub new {
	my $apiCheck  = "https://check.torproject.org/api/ip";
	my $userAgent = LWP::UserAgent -> new();
	my $request   = $userAgent -> get($apiCheck);
	my $httpCode  = $request -> code();

	if ($httpCode == "200") {
		my $data = decode_json ($request -> content);

		my $checkIp  = $data -> {'IP'};
		my $checkTor = $data -> {'IsTor'};

		if ($checkTor) {
			$checkTor = "activated";
		}

		else {
			$checkTor = "disabled";
		}

		print "
			\r\033[1;32m[+]\033[1;37m  $checkTor.
			\r\033[1;32m[+]\033[1;37m  $checkIp\n\n";
	}

	else {
		print "\n\033[31m[!]\033[1;37m სერვერთან დაკავშირება ვერ მოხერხდა.\n\n";
	}
}

1;
