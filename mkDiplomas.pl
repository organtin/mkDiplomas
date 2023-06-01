#!/usr/bin/perl

use Getopt::Long;
use File::Copy;

my $csvfile  = "recipients.csv";
my $template = "diploma.tex";
my $latexCmd = "pdflatex";
my $verbose;

GetOptions("csvfile=s" => \$csvfile,
	   "template=s" => \$template,	   
	   "latex=s" => \$latexCmd,	   
	   "verbose" => \$verbose)
    or die ("Cannot understand command line options");

open IN, $csvfile;
@rows = <IN>;
close IN;

$n = @rows;
$n--;
print("read $n lines from $csvfile\n");

$i = -1;
@header;
foreach $row (@rows) {
    # read each row and normalise it (removes all the unneded blanks)
    chomp $row;
    $row =~ s/ *,/,/g;
    $row =~ s/, */,/g;
    @tags = split/,/,$row;
    if ($i == -1) {
	# use the first row of the CSV file as the header
	@header = @tags;	
	if ($verbose) {
	    $hdr = "";
	    for $h (@header) {
		$hdr .= " $h,";
	    }
	    $hdr =~ s/.$//;
	    print("the header = [$hdr]\n");
	}
    } else {
	if ($i % 10 == 0) {
	    print($i/10);
	} else {
	    print(".");
	}
	# prepare the tex file using the first tag
	$filename = $tags[0] . ".pdf";
	$filename =~ s/ /_/g;
	$filename =~ s/'//g;
	$k = 0;
	if ($verbose) {
	    print("Preparing for file $filename\n");
	}
	# substitute each tag in the tex file
	copy($template, "step1.tex");
	$cat = `cat step1.tex`;
	foreach $tag (@tags) {
	    $cmd = "cat step1.tex | sed -e \"s/$header[$k]/$tag/\" > step2.tex\n";
	    `$cmd`;
	    $k += 1;
	    move("step2.tex", "step1.tex");
	}
	# run the latex command
	if ($verbose) {
	    print("Compiling $filename\n");
	}
	$cmd = "$latexCmd step1.tex";
	`$cmd`;
	# clean dir
	move("step1.pdf", $filename);
	unlink "step1.tex";
	unlink "step1.aux";
	unlink "step1.log";
	unlink "step1.out";
	$cmd = "mv $filename output/.";
	`$cmd`;
    }
    $i++;
}
print("\n");
