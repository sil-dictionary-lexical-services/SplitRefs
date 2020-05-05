# SplitRefs
Script for splitting compound references in SFM file into multiple single-value fields with the same marker.

REQUIRED MODULES: None

INPUT/OUTPUT FILES: specified on command line (STDIN/STDOUT)

USAGE:  perl ./SplitRefs.pl <  MyDatabase.db > MyDatabase-Split.db

LOGFILE: writes a logfile containing (a) fields with parentheses (so they can be checked 
manually), and (b) any lines that didn't match the expected pattern for an SFM field.

SAMPLE FILES:
  * Sample input:	SampleIndo-mod1-BeforeSplit.db
  * Sample output:	SampleIndo-mod2-AfterSplit.db

SAMPLE USAGE:
  * ./SplitRefs.pl < SampleIndo-BeforeSplit.db > SampleIndo-AfterSplit.db

----------
NOTES

There are two scripts here:

 * SplitRefs.pl  is a general script that is hardcoded to apply to most of the markers that might need splitting in a standard MDF file: re, rn, cf, va, sy, an

 * SplitRefs-re.pl  is hardcoded to only work on the markers \re and \rn

By comparing the files, one can see which line needs to be edited in order
to adjust which markers this script applies to, and how to edit that line.

Both of these scripts only split on semicolon.  If you want it to split on
either semicolon or comma, there is one more place the script can be adjusted
to do that.
