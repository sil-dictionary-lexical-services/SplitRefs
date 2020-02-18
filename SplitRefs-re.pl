#!/usr/bin/perl

use 5.020;
use utf8;
use open qw/:std :utf8/;

use strict;
use warnings;
use English;

# SplitRefs-re.pl < infile.db > outfile.db

# For reference fields with more than one target
# (separated by semicolons), split the field into
# multiple fields, each with only one target.

# This version is customized for reversals and
# works for these fields:
# re, rn


# Currently treats comma and semicolon differently, 
# (only splits on semicolon, not comma) but
# this would need to be reviewed on a
# per-project basis.

# Doesn't do anything with parentheses or slashes.
# For now, just prints those to LOGFILE so they can
# be looked at and adjusted manually if needed.

# Created:	BB	25 Apr 2018
# Modified:	BB	28 Apr 2018 Convert to SplitRefs-re.pl
# Modified:	WLP	18 Feb 2020
#	Standard uses
#	Better chomp

$logfile = "splitrefs-re-log.txt";
open(LOGFILE, ">$logfile");

$linecount = 0;

# iterate through the file, reading one line each time through the loop,
# until there are no more lines
while ($line = <>) {
	# remove the end-of-line character, whatever it is
	# (This assumes Unix line endings.)
	s/\R//g; # chomp that doesn't care about Linux & Windows
	#perhaps s/\R*$//; if we want to leave in \r characters in the middle of a line 
	$linecount++;
	#print STDERR "[$line]\n";
	# Check for the ref fields we are interested in
	if ($line =~ /^\\re/ || $line =~ /^\\rn/) {
		# And we only care about the ones with semicolons
		# For now we are not searching for commas,
		# but that won't be appropriate for all db's.
		if ($line =~ /[;]/) {
			# Parse the line
			if ($line =~ /^\\([a-z]+) (.+)$/) {
				$mkr = $1;
				$fullcontents = $2;
				
				# First remove any spaces around semicolons,
				# since it could be inconsistent
				$fullcontents =~ s/ +;/;/g;
				$fullcontents =~ s/; +/;/g;
				
				# Now split the contents on the semicolons
				@targets = split(/;/, $fullcontents);
				foreach $target (@targets) {
					print STDOUT "\\$mkr $target\n";
					# If there are any parentheses or slashes, print
					# to LOGFILE so they can be checked manually
					if ($target =~ /[\(\)\{\}\/]/) {
						print LOGFILE "Check parens in \\$mkr $target\n";
						}
					}
				# Reset values
				$mkr = $fullcontents = "";
				}
			else {
				# Presumably we won't ever get here, but
				# if we do, something unexpected is happening
				# with how the line is structured.
				print LOGFILE "Unexpected line structure $linecount [$line]\n";
				}
			}
		# lines without semicolons just get printed
		else {
			print STDOUT "$line\n";
			# If there are any parentheses, print
			# to LOGFILE so they can be checked manually
			if ($line =~ /[\(\)\{\}\/]/) {
				print LOGFILE "Check parens in $line\n";
				}
			}
		}
	# All other lines should be printed as is
	else {
		print STDOUT "$line\n";
		}
	
	}
	
