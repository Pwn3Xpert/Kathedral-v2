#!/usr/bin/perl

use Switch;
use lib "./lib/";
use Kathoxy::Stop;
use Kathoxy::Start;
use Kathoxy::CheckIp;
use Kathoxy::Functions;

sub main {
	my $command = $ARGV[0];

	switch ($command) {
		case "stop" {
			Kathoxy::Stop -> new();
		}

		case "start" {
			Kathoxy::Start -> new();
		}

		case "status" {
			Kathoxy::CheckIp -> new();
		}

		case "restart" {
			Kathoxy::Stop -> new();
			Kathoxy::Start -> new();
		}

		case "install" {
			Kathoxy::Functions -> install();
		}

		else {
			Kathoxy::Functions -> help();
		}
	}
}

main();
exit;

