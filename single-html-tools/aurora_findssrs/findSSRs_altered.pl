#!/usr/bin/env perl
################################################################################
# Author: Meg Staton & Stephen Ficklin
#
# DESCRIPTION
# -----------
# This script identifies simple sequence repeats (SSRs) and calls primers from
# the sequences in a fastq formatted file.
#
# Dependencies:
# ------------
# Perl must have access to the packages:
# Getopt::Long
# Bio::SeqIO
# Excel::Writer::XLSX
# All are available from CPAN.
#
# Also path to the primer3 executable and primer3 config files must be specified
# in the global variables section of the script.
#
# Usage:
# -----
# Usage: findSSRs.pl <arguments>
#
# The list of arguments includes:
#
# -f|--fasta_file <fasta_file>
# Required.  The file of the sequences to be searched.
#
# -m|--masked_file <masked_fasta_file>
# Required.  A soft-masked version of the fasta file (soft masked means low
# complexity sequences are in lower case bases.)
#
# Output:
# ------
# <input-file-name>.ssr.fasta
# A fasta file with sequences with a SSR. (Sequences with compound SSRs are included)
#
# <input-file-name>.ssr_stats.txt
# A text file of statistics about the SSRs discovered.
#
# <input-file-name>.ssr_report.txt
# A tab-delimited file with each SSR.  The columns are SSR ID,
# motif, number of repeats, start position, end position.
#
# <input-file-name>.ssr_report.xlsx
# A excel file with SSR results and stats
#
# <input-file-name>.di_primer_report.txt
# <input-file-name>.tri_primer_report.txt
# <input-file-name>.tetra_primer_report.txt
# Tab-delimited files with sequences with a specified SSR motif length.  Columns are
# SSR ID, motif, number of repeats, start position, end position, left primer,
# right primer, left primer Tm, right primer Tm, amplicon size
#
# Details:
# -------
# By default the script finds:
# 2 bp motifs repeated from 8 to 200 times,
# 3 bp motifs repeated from 7 to 133 times,
# 4 bp motifs repeated from 6 to 100 times,
#
# These parameters may be changed in the "GLOBAL PARAMETERS" part of
# the script.
#
# Compound SSRs are defined as any SSRs that abut or are less than 15 bases
# apart. These are essentially compound SSRs for the purposes of mapping
# because it is unlikely that primers can be designed between the repeat 
# segments.
#


use strict;

#-------------------------------------------------------------------------------
#  DEPENDENCIES
#-------------------------------------------------------------------------------

use Getopt::Long;
use Bio::SeqIO;
use Excel::Writer::XLSX;

#-------------------------------------------------------------------------------
# GLOBAL PARAMETERS
#-------------------------------------------------------------------------------

#--------------
# REPEAT IDENTIFICATION PARAMETERS
# Specify Motif Frequency
# Motifs that occur less frequently than indicated below will be ignored.
# A 0 indicates that this motif length will be ignored.

our $MIN_REPS_2bp = 6;
our $MIN_REPS_3bp = 6;
our $MIN_REPS_4bp = 4;

our $MAX_REPS_2bp = 20;
our $MAX_REPS_3bp = 20;
our $MAX_REPS_4bp = 20;

#------------
# PRIMER PARAMETERS

# my $PRIMER3 = "/staton/software/primer3-2.3.6/src/primer3_core";
# my $PRIMER3_CONFIG = "/staton/software/primer3-2.3.6/src/primer3_config/";

my $PRIMER_OPT_SIZE="21";  # default 20
my $PRIMER_MIN_SIZE="18";  # default 18
my $PRIMER_MAX_SIZE="27";  # default 27

my $PRIMER_NUM_NS_ACCEPTED = "0";  # default 0

my $PRIMER_PRODUCT_SIZE_RANGE = "100-400";

my $PRIMER_OPT_TM = "60.0";
my $PRIMER_MIN_TM = "55.0";
my $PRIMER_MAX_TM = "65.0";

my $PRIMER_MIN_GC = "40";
my $PRIMER_MAX_GC = "60";

my $PRIMER_MAX_POLY_X = "3";
my $PRIMER_GC_CLAMP = "2";

my $PRIMER_LOWERCASE_MASKING = 1;

#-------------------------------------------------------------------------------
# GLOBAL HASHES
#-------------------------------------------------------------------------------
# This makes life much easier than passing a bunch of hash refs all over the place.
#
#-------------------------------------------------------------------------------
# Data structures:

## CONTIG_SSR_STARTS structure:
## key: contig_name
##  value: array of starts of SSRs in that contig
my %CONTIG_SSR_STARTS = ();

## SSR_STATS structure:
## key: ssr_id
##  value -> keys: MOTIF START END MOTIF_LENGTH NO_REPEATS
my %SSR_STATS = ();
my $SEQ_COUNT = 0;

# Set up the Motif specifications, based on the chosen motif types:.
my @MOTIF_SPECS;
push(@MOTIF_SPECS,[2, $MIN_REPS_2bp, $MAX_REPS_2bp, 'dinucleotides']);
push(@MOTIF_SPECS,[3, $MIN_REPS_3bp, $MAX_REPS_3bp, 'trinucleotides']);
push(@MOTIF_SPECS,[4, $MIN_REPS_4bp, $MAX_REPS_4bp, 'tetranucleotides']);

#-------------------------------------------------------------------------------
# Generating statistics
my $TIME = scalar localtime;                   # Get the current time
my $SEQ_w_SSRS = 0;
my $SSR_COUNT = 0;
my $SSR_COUNT_COMPOUND = 0;
my $SSR_COUNT_PRIMER = 0;

my %MOTIFLEN = (2  => 0,
                3  => 0,
                4  => 0);

my %MOTIFLEN_w_PRIMERS = (2  => 0,
                          3  => 0,
                          4  => 0);
my %MOTIFS = ('|AT|TA|'                   => 0,
              '|AG|GA|CT|TC|'             => 0,
              '|AC|CA|TG|GT|'             => 0,
              '|GC|CG|'                   => 0,

              '|AAT|ATA|TAA|ATT|TTA|TAT|' => 0,
              '|AAG|AGA|GAA|CTT|TTC|TCT|' => 0,
              '|AAC|ACA|CAA|GTT|TTG|TGT|' => 0,

              '|CCA|CAC|ACC|TGG|GTG|GGT|' => 0,
              '|GGC|GCG|CGG|GCC|CCG|CGC|' => 0,
              '|AGG|GAG|GGA|CCT|CTC|TCC|' => 0,

              '|ATG|TGA|GAT|CAT|ATC|TCA|' => 0,
              '|AGT|GTA|TAG|ACT|CTA|TAC|' => 0,
              '|AGC|GCA|CAG|GCT|CTG|TGC|' => 0,
              '|ACG|CGA|GAC|CGT|GTC|TCG|' => 0);



#-------------------------------------------------------------------------------
#  EXECUTE
#-------------------------------------------------------------------------------
main();
#-------------------------------------------------------------------------------
#  PUBLIC SUBROUTINES
#-------------------------------------------------------------------------------
# Function Name:  main()

sub main{

	##---------------------------------------------------------------
	## Get input parameters
    my $fasta_file;
    my $masked_file;
    my $project;

    Getopt::Long::Configure ('bundling');
    GetOptions('f|fasta_file=s'  => \$fasta_file,
               'm|masked_file=s' => \$masked_file,
               'p|project=s'     => \$project);

    ## Check that all required parameters have been included
    if(!$fasta_file){ print "A fasta file is required.\n"; _printUsage(); exit;}
    if(!$masked_file){ print "A masked file is required.\n"; _printUsage(); exit;}

    ## Check that fasta file exists
    if(! -e $fasta_file) { print "Fasta file $fasta_file does not exist\n"; exit; }
    if(! -e $masked_file) { print "Masked file $masked_file does not exist\n"; exit; }

	##---------------------------------------------------------------
	## Set up output files
    my $p3_input         = "$fasta_file.p3in.txt";
    my $p3_output        = "$fasta_file.p3out.txt";
    my $ssr_out          = "$fasta_file.ssr_report.txt";
    my $fasta_out        = "$fasta_file.ssr.fasta";
    my $stats_out        = "$fasta_file.ssr_stats.txt";
    my $di_primer_out    = "$fasta_file.di_primer_report.txt";
    my $tri_primer_out   = "$fasta_file.tri_primer_report.txt";
    my $tetra_primer_out = "$fasta_file.tetra_primer_report.txt";
    my $ssr_xlsx         = "$fasta_file.ssr_report.xlsx";

	##---------------------------------------------------------------
    print "finding SSRs...\n";
    process_file($fasta_file, $masked_file);
	collapse_compound_ssrs();
    flag_multiSSRs();
    print "done.\n";

	##---------------------------------------------------------------
    print "running primer3...\n";
	addToPrimer3InputFile ($p3_input);
    print "primer3_core < $p3_input > $p3_output\n";
    my $status = system("primer3_core < $p3_input > $p3_output");
	print "$status\n";
    parseP3_output($p3_output);
    print "done.\n";

	##---------------------------------------------------------------
	## Producing output - Fasta files and flat files
	print "printing output files...";
	create_flat_files($ssr_out, $di_primer_out, $tri_primer_out, $tetra_primer_out);
	create_fasta_file($fasta_out);

	##---------------------------------------------------------------
	## Producing output - statistics

	calculate_stats();
	print_stats($stats_out);

	##---------------------------------------------------------------
	## Producing output - Excel
	create_excel_file($ssr_xlsx, $project);
    print "done.\n";

}

###############################################################

sub process_file{
    my $fasta_file  = $_[0]; # file name
    my $masked_file = $_[1]; # file name

    my $seqio = Bio::SeqIO->new('-format' => 'fasta', -file => $fasta_file);
    my $seqioM = Bio::SeqIO->new('-format' => 'fasta', -file => $masked_file);

    # Get seq obj from io stream
    while(my $seqobj = $seqio->next_seq){
        my $seqobjM = $seqioM->next_seq;

        $SEQ_COUNT++;

        my $seqname = $seqobj->id;        # get actual sequence as a string
        my $seqnameM = $seqobjM->id;        # get actual sequence as a string

        my $seqstr = $seqobj->seq();        # get actual sequence as a string
        my $seqstrM = $seqobjM->seq();        # get actual sequence as a string

        if($seqname ne $seqnameM){
            die "masked sequence $seqnameM not in same order as regular sequence $seqname\n";
        }

        process_seq($seqname, $seqstr, $seqstrM);
    }

}

###############################################################

sub process_seq{
    my $contig_name = shift;
    my $seq         = shift;
    my $seq_masked  = shift;


    my %seen;     # used to keep track of start positions we've already seen
    my $index;    # used to iterate through the 2D motif specs array

    ## LOOPB
    # iterate through the motif specifications
    for $index (0 .. (scalar @MOTIF_SPECS - 1)) {

        # holds the motif size (1,2,3,4,5 or 6)
        my $motifLength = $MOTIF_SPECS[$index][0];
        # holds the minimum number of repeats
        my $min_number_of_repeats = $MOTIF_SPECS[$index][1]-1;
        # holds the maximum number of repeats
        my $max_number_of_repeats = $MOTIF_SPECS[$index][2]-1;
        # the regular expression for looking for SSRs
        my $regex = "(([gatc]{$motifLength})\\2{$min_number_of_repeats,$max_number_of_repeats})";

        # run through the sequence and check for this motif spec
        while ($seq =~ /$regex/ig) {
            # Get the ssr and motif that were found
            my $ssr = $1;
            my $motif = lc $2;
			my $start_index = $-[0];
			my $end_index = $+[0];

			if(quality_check_ssr($contig_name, $ssr, $motif, $start_index, $end_index, $seq)){
				process_ssr($contig_name, $ssr, $motif, $start_index, $end_index, $seq, $seq_masked);

			}

		}
	}
}



###############################################################
sub quality_check_ssr{
	my $contig_name = shift;
	my $ssr = shift;
 	my $motif = shift;
 	my $start_index = shift;
 	my $end_index = shift;
	my $seq = shift;

	##-------------------------------------
	## CHECKS to see if this is a good ssr
	my $flag_same_base = 0;
	my $flag_already_seen = 0;

	## Check #1
	## ignore SSRs that are the same base repeated
	if ($ssr !~ /^g+$/i &&
	    $ssr !~ /^a+$/i &&
	    $ssr !~ /^c+$/i &&
	    $ssr !~ /^t+$/i ) {
		$flag_same_base = 1;
	}

	# Check #2
	# Make sure this isn't an already called SSR in disguise
	# (a dinucleotide repeat posing as a tetranucleotide repeat, for instance)
	if (!exists $SSR_STATS{$contig_name."_ssr".$start_index} &&
	    !exists $SSR_STATS{$contig_name."_ssr".($start_index-1)} &&
	    !exists $SSR_STATS{$contig_name."_ssr".($start_index-2)} &&
	    !exists $SSR_STATS{$contig_name."_ssr".($start_index+1)} &&
	    !exists $SSR_STATS{$contig_name."_ssr".($start_index+2)}
	) {
		$flag_already_seen = 1;
	}

	if($flag_same_base && $flag_already_seen){
		return 1;
	}
	else{
		return 0;
	}

}



######################################################
sub process_ssr{
	my $contig_name = shift;
	my $ssr = shift;
 	my $motif = shift;
 	my $start_index = shift;
 	my $end_index = shift;
	my $seq = shift;
	my $seq_masked = shift;

	##-------------------------------------
	## generate a few more stats and variables
	my $motif_len = length $motif;
	my $num_of_repeats = ($end_index-$start_index)/$motif_len;
    my $ssr_id = $contig_name."_ssr".$start_index;

	##-------------------------------------
	## store in data structures

    if(exists $CONTIG_SSR_STARTS{$contig_name}){
        push @{ $CONTIG_SSR_STARTS{$contig_name} }, $start_index;
    }
    else{
       $CONTIG_SSR_STARTS{$contig_name} = [$start_index];
    }

	$SSR_STATS{$ssr_id}{MOTIF}        = $motif;
	$SSR_STATS{$ssr_id}{START}        = $start_index;
	$SSR_STATS{$ssr_id}{END}          = $end_index;
	$SSR_STATS{$ssr_id}{MOTIF_LENGTH} = $motif_len;
	$SSR_STATS{$ssr_id}{NO_REPEATS}   = $num_of_repeats;
	$SSR_STATS{$ssr_id}{SEQ}          = $seq;
	$SSR_STATS{$ssr_id}{SEQM}         = $seq_masked;
	$SSR_STATS{$ssr_id}{COMPOUND}     = 0; #assume its not until proven otherwise


}

#######################################################
sub collapse_compound_ssrs{
	foreach my $contig (keys %CONTIG_SSR_STARTS){
		my @starts = @{ $CONTIG_SSR_STARTS{$contig}};
		if(@starts > 1){
			## this contig has multiple ssrs
			my $previous_start = -1;
			my $previous_end = -1;
			my $previous_ssr_id = "";

			foreach my $current_start (sort {$a <=> $b} @starts){
				my $current_ssr_id = $contig."_ssr".$current_start;
				my $current_end = $SSR_STATS{$current_ssr_id}{END};

				if(too_close($previous_start, $previous_end, $current_start, $current_end)){
						collapse($contig, $previous_ssr_id, $current_ssr_id);
				}

				$previous_start = $current_start;
				$previous_end = $current_end;
				$previous_ssr_id = $current_ssr_id;
			}
		}
	}
}

################################################################
sub too_close{
	my $previous_start = shift;
	my $previous_end = shift;
	my $current_start = shift;
	my $current_end  = shift;

	# if start is a -1, then go ahead and return ok
	if($previous_start == -1){
		return 0;
	}
	# we want to know if they overlap, abut or are less than 15 bases apart
	elsif($previous_end >= $current_start ||
		($current_start - $previous_end) < 15){
		#print "$previous_start - $previous_end, $current_start - $current_end\n";
		return 1;
	}
	else{
		return 0;
	}
}
################################################################
sub collapse{
	my $contig = shift;
	my $first_ssr_id = shift;
	my $second_ssr_id = shift;
	my $second_ssr_start = $SSR_STATS{$second_ssr_id}{START};

	##fix SSR_STATS
	$SSR_STATS{$first_ssr_id}{MOTIF}        = "COMPOUND";
	$SSR_STATS{$first_ssr_id}{END}          = $SSR_STATS{$second_ssr_id}{END};
	$SSR_STATS{$first_ssr_id}{MOTIF_LENGTH} = "COMPOUND";
	$SSR_STATS{$first_ssr_id}{NO_REPEATS}   = "COMPOUND";
	$SSR_STATS{$first_ssr_id}{COMPOUND}     = 1; #assume its not until proven otherwise

	delete $SSR_STATS{$second_ssr_id}{MOTIF};
	delete $SSR_STATS{$second_ssr_id}{START};
	delete $SSR_STATS{$second_ssr_id}{END};
	delete $SSR_STATS{$second_ssr_id}{MOTIF_LENGTH};
	delete $SSR_STATS{$second_ssr_id}{NO_REPEATS};
	delete $SSR_STATS{$second_ssr_id}{SEQ};
	delete $SSR_STATS{$second_ssr_id}{SEQM};
	delete $SSR_STATS{$second_ssr_id}{COMPOUND};
	undef %{$SSR_STATS{$second_ssr_id}};
	delete $SSR_STATS{$second_ssr_id};

	print "\tdeleting $second_ssr_id, part of compound ssr\n";

	if(exists $SSR_STATS{$second_ssr_id}){ print "\t still exists\n";}

	##fix CONTIG_SSR_STARTS
	# get rid of the start index for the second ssr (it is now part of the
	# first ssr)

	my $index = 0;
	$index++ until $CONTIG_SSR_STARTS{$contig}[$index] == $second_ssr_start;
	splice(@{$CONTIG_SSR_STARTS{$contig}}, $index, 1);

}


################################################################
sub flag_multiSSRs{
	# adds a MULTI flag to the data hash indicating if the
	# ssr is the only one in the sequence or one of many

	foreach my $contig (keys %CONTIG_SSR_STARTS){
		my @starts = @{ $CONTIG_SSR_STARTS{$contig}};
		if(@starts == 1){
			## this contig has only one ssr
			my $start_index = $starts[0];
			my $ssr_id = $contig."_ssr".$start_index;
			$SSR_STATS{$ssr_id}{MULTI} = 0;
		}
		else{
			## this contig has multiple ssrs
			foreach my $start_index (@starts){
				my $ssr_id = $contig."_ssr".$start_index;
				$SSR_STATS{$ssr_id}{MULTI} = 1;
			}
		}
	}
	close FASTA;

}

################################################################
sub addToPrimer3InputFile{
    my $p3_file = shift;

	open OUT, ">$p3_file";

	foreach my $ssr_id (keys %SSR_STATS){
		#skip compound SSRS
		if($SSR_STATS{$ssr_id}{COMPOUND} == 0){
			my $ssrStart   = $SSR_STATS{$ssr_id}{START};
			my $ssrEnd     = $SSR_STATS{$ssr_id}{END};
			my $seq        = $SSR_STATS{$ssr_id}{SEQM};

			# change from soft mask to hard mask
			$seq =~ s/[actg]/N/g;

			my $len         = $ssrEnd-$ssrStart;

			printf OUT ("SEQUENCE_ID=$ssr_id\n");
    		printf OUT ("SEQUENCE_TEMPLATE=$seq\n");
    		printf OUT ("SEQUENCE_TARGET=$ssrStart,$len\n");
    		printf OUT ("PRIMER_TASK=generic\n");
    		printf OUT ("PRIMER_PICK_LEFT_PRIMER=1\n");
    		printf OUT ("PRIMER_PICK_INTERNAL_OLIGO=0\n");
    		printf OUT ("PRIMER_PICK_RIGHT_PRIMER=1\n");
    		printf OUT ("PRIMER_OPT_SIZE=$PRIMER_OPT_SIZE\n");
    		printf OUT ("PRIMER_MIN_SIZE=$PRIMER_MIN_SIZE\n");
    		printf OUT ("PRIMER_MAX_SIZE=$PRIMER_MAX_SIZE\n");
    		printf OUT ("PRIMER_NUM_NS_ACCEPTED=$PRIMER_NUM_NS_ACCEPTED\n");
    		printf OUT ("PRIMER_PRODUCT_SIZE_RANGE=$PRIMER_PRODUCT_SIZE_RANGE\n");
    		printf OUT ("PRIMER_OPT_TM=$PRIMER_OPT_TM\n");
    		printf OUT ("PRIMER_MIN_TM=$PRIMER_MIN_TM\n");
    		printf OUT ("PRIMER_MAX_TM=$PRIMER_MAX_TM\n");
    		printf OUT ("PRIMER_MIN_GC=$PRIMER_MIN_GC\n");
    		printf OUT ("PRIMER_MAX_GC=$PRIMER_MAX_GC\n");
    		printf OUT ("PRIMER_MAX_POLY_X=$PRIMER_MAX_POLY_X\n");
    		printf OUT ("PRIMER_GC_CLAMP=$PRIMER_GC_CLAMP\n");
    		# printf OUT ("PRIMER_THERMODYNAMIC_PARAMETERS_PATH=$PRIMER3_CONFIG\n");
    		printf OUT ("PRIMER_LOWERCASE_MASKING=$PRIMER_LOWERCASE_MASKING\n");
    		printf OUT ("=\n");
		}
	}
	close OUT;
}
################################################################
sub parseP3_output{
    my $p3_output = $_[0]; # file name

	# We are going to keep track of a weird phenomenon only seen in one
	# project - the generation of identical forward and reverse primers. The
	# sequences from this project were overlapping paired ends that were joined.
	# Apparently something went wrong and weird sequences were obtained, all of
	# which yield the identical primers.
	# This is not reported in the final stats, just as part of the standard output.
    my $identical_primer_cnt = 0;

    # The primers output file separates information about different sequences
    # with an equal sign on a single line. So, we want to set the file line
    # delimiter (for looping on the input file below) to a single equal sign
    # followed by a line feed.  This way were guranteed to have all the primer
    # information together per line
    local $/ = "=\n";

    open (P3O, $p3_output) || die "could not open $_\n";

    # Read in all of the lines of the input file
	my $primer_record;
    while ($primer_record = <P3O>) {
        my $start = "";
        my $seq_id = "";
        my $ssr_id = "";
        my $forward = "";
        my $reverse = "";
        my $product_size = "";
        my $left_tm = "";
        my $right_tm = "";

		if ($primer_record =~ /SEQUENCE_ID=(\S+)/) {
		    $ssr_id = $1;
		}
		# get the primary primers only
		if ($primer_record =~ /PRIMER_LEFT_0_SEQUENCE=(\S+)/) {
		    $forward = $1;
		}
		if ($primer_record =~ /PRIMER_RIGHT_0_SEQUENCE=(\S+)/) {
		    $reverse = $1;
		}
		if ($primer_record =~ /PRIMER_LEFT_0_TM=(\S+)/) {
		    $left_tm = $1;
		}
		if ($primer_record =~ /PRIMER_RIGHT_0_TM=(\S+)/) {
		    $right_tm = $1;
		}
		if ($primer_record =~ /PRIMER_PAIR_0_PRODUCT_SIZE=(\S+)/) {
		    $product_size = $1;
		}

		if(length $forward > 1){
			if($forward eq $reverse){
				print "\tFLAG: identical primer problem with $ssr_id\n";
				$identical_primer_cnt++;
			}
			else{
				$SSR_STATS{$ssr_id}{FORWARD} = $forward;
				$SSR_STATS{$ssr_id}{REVERSE} = $reverse;
				$SSR_STATS{$ssr_id}{PRODUCT_SIZE} = $product_size;
				$SSR_STATS{$ssr_id}{LEFT_TM} = $left_tm;
				$SSR_STATS{$ssr_id}{RIGHT_TM} = $right_tm;

			}
		}
	}

    print "\ttotal identical primers: $identical_primer_cnt\n";
}

###################################################
sub create_flat_files{
	my $ssr_out = shift;
	my $di_primer_out = shift;
	my $tri_primer_out = shift;
	my $tetra_primer_out = shift;

	open OUTS, ">$ssr_out";
	open OUT2, ">$di_primer_out";
	open OUT3, ">$tri_primer_out";
	open OUT4, ">$tetra_primer_out";

	my $di_fh = *OUT2;
	my $tri_fh = *OUT3;
	my $tetra_fh = *OUT4;

	##printer headers
	print OUTS join("\t", "SSR ID",
				"motif", "number of repeats", "start position", "end position");
	print OUTS "\n";

	print OUT2 join("\t", "SSR ID",
				"motif", "number of repeats", "start position", 
				"end position", "forward primer", "reverse primer",
				"forward Tm", "reverse Tm","product size" );
	print OUT2  "\n";

	print OUT3 join("\t", "SSR ID",
				"motif", "number of repeats", "start position", 
				"end position", "forward primer", "reverse primer",
				"forward Tm", "reverse Tm","product size" );
	print OUT3  "\n";

	print OUT4 join("\t", "SSR ID",
				"motif", "number of repeats", "start position", 
				"end position", "forward primer", "reverse primer",
				"forward Tm", "reverse Tm","product size" );
	print OUT4  "\n";

	foreach my $ssr_id (keys %SSR_STATS){
		## all ssrs including compound go in main ssr file
		print OUTS join("\t",
			$ssr_id,
			$SSR_STATS{$ssr_id}{MOTIF},
			$SSR_STATS{$ssr_id}{NO_REPEATS},
			$SSR_STATS{$ssr_id}{START},
			$SSR_STATS{$ssr_id}{END},
		);
		print OUTS "\n";

		# for primer flat files, only print SSRs with 
		# that have primers
		if($SSR_STATS{$ssr_id}{COMPOUND} == 0 &&
			$SSR_STATS{$ssr_id}{FORWARD} =~ /\S/
		){
			if($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 2){
				_print_primer_flat_file_line($di_fh, $ssr_id);
			}
			elsif($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 3){
				_print_primer_flat_file_line($tri_fh, $ssr_id);
			}
			elsif($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 4){
				_print_primer_flat_file_line($tetra_fh, $ssr_id);
			}
		}
	}
	close OUTS;
	close OUT2;
	close OUT3;
	close OUT4;

}
###################################################
sub _print_primer_flat_file_line{
	my $fh = shift;
	my $ssr_id = shift;

	print $fh join("\t", $ssr_id,
		$SSR_STATS{$ssr_id}{MOTIF},
		$SSR_STATS{$ssr_id}{NO_REPEATS},
		$SSR_STATS{$ssr_id}{START},
		$SSR_STATS{$ssr_id}{END},
		$SSR_STATS{$ssr_id}{FORWARD},
		$SSR_STATS{$ssr_id}{REVERSE},
		$SSR_STATS{$ssr_id}{LEFT_TM},
		$SSR_STATS{$ssr_id}{RIGHT_TM},
		$SSR_STATS{$ssr_id}{PRODUCT_SIZE},
	);
	print $fh "\n";

}

###################################################
sub create_fasta_file{
	my $fasta_out = shift;
	open FASTA, ">$fasta_out";

	foreach my $contig (keys %CONTIG_SSR_STARTS){
		my @starts = @{ $CONTIG_SSR_STARTS{$contig}};
		my $seq = "";
		print FASTA ">$contig (";
		foreach my $start_index (sort {$a <=> $b} @starts){
			my $ssr_id = $contig."_ssr".$start_index;

			#if($SSR_STATS{$ssr_id}{START} >= 0){
			$seq = $SSR_STATS{$ssr_id}{SEQ};
			print FASTA "$SSR_STATS{$ssr_id}{START}-$SSR_STATS{$ssr_id}{END} ";
			if($SSR_STATS{$ssr_id}{COMPOUND} == 1){ 
				print FASTA "*Compound ";
			}
		}
		#get the first ssr index just so we can get the sequence
		print FASTA ")\n";
		print FASTA "$seq\n";

	}
	close FASTA;

}
################################################################
sub calculate_stats{

	$SEQ_w_SSRS = keys %CONTIG_SSR_STARTS;

	foreach my $ssr_id (keys %SSR_STATS){
		$SSR_COUNT++;

		if($SSR_STATS{$ssr_id}{COMPOUND} == 1){
			$SSR_COUNT_COMPOUND++;
		}
		else{
			my $motif_len = $SSR_STATS{$ssr_id}{MOTIF_LENGTH} ;
			#print "motif length is $motif_len\n";
			$MOTIFLEN{$motif_len}++;

			my $motifUC = uc($SSR_STATS{$ssr_id}{MOTIF});
			foreach my $group (keys %MOTIFS) {
				if($group =~ /\|$motifUC\|/){
					#print "Incrementing $group for $motifUC\n";
					$MOTIFS{$group}++;
				}
			}

			if($SSR_STATS{$ssr_id}{FORWARD} =~ /\S/){
				$SSR_COUNT_PRIMER++;
				$MOTIFLEN_w_PRIMERS{$motif_len}++;
			}
		}
	}

}
sub print_stats{
    my $stats_out = $_[0]; # file name

    open (OUTS, ">".$stats_out) || die "ERROR cannot open $stats_out\n";

    print OUTS 'SSR Summary Report\n';
    print OUTS "Analysis of $SEQ_COUNT sequences\n";
    print OUTS "$TIME\n";
	print OUTS "\n";
    print OUTS "Number of sequences with at least one SSR\t$SEQ_w_SSRS\n";
    print OUTS "Number of SSRs identified\t$SSR_COUNT\n";
	print OUTS "\n";
    print OUTS "Number of compound SSRs*: $SSR_COUNT_COMPOUND\n";
    print OUTS "Number of SSRs with primers**: $SSR_COUNT_PRIMER\n";
	print OUTS "\n";
	print OUTS "*Compound SSRs are defined as any SSRs next to each or separated by less than 15 bases\n";
    print OUTS "**No primers are designed for compound SSRs\n";
    print OUTS "\n";
	print OUTS "Parameters used for identifying SSRS:\n";
    print OUTS "Base Pairs in Motif\tMin # Reps\tMax # Reps\n";
    print OUTS "--------------------------------------\n";
    print OUTS "2 (Dinucleotides)\t$MIN_REPS_2bp\t$MAX_REPS_2bp\n";
    print OUTS "3 (Trinucleotides)\t$MIN_REPS_3bp\t$MAX_REPS_3bp\n";
    print OUTS "4 (Tetranucleotides)\t$MIN_REPS_4bp\t$MAX_REPS_4bp\n";
    print OUTS "\n";
	print OUTS "Chart of motif pattern frequence (compound SSRs excluded)\n";
    print OUTS "Motif Patterns\tNumber of SSRs Found\n";
    print OUTS "--------------------------------------\n";
    my $group;
    foreach $group (sort {length $a <=> length $b} keys %MOTIFS){
        $group =~ s/^|//;
        $group =~ s/|$//;
        print OUTS "$group\t$MOTIFS{$group}\n";
    }
    print OUTS "\n";
	print OUTS "Chart of motif pattern length frequence (compound SSRs excluded)\n";
    print OUTS "Motif Pattern Length\tNumber of SSRs\n";
    print OUTS "--------------------------------------\n";

    foreach $group (sort keys %MOTIFLEN){
        print OUTS "$group\t$MOTIFLEN{$group}\n";
    }

    print OUTS "\n";
    print OUTS "SSRS with Primers \n";
	print OUTS "Chart of motif pattern length frequence (compound SSRs excluded)\n";
    print OUTS "Motif Pattern Length\tNumber of SSRs\n";
    print OUTS "--------------------------------------\n";

    foreach $group (sort keys %MOTIFLEN_w_PRIMERS){
        print OUTS "$group\t$MOTIFLEN_w_PRIMERS{$group}\n";
    }


    close OUTS;

}

################################################################

sub create_excel_file{
	my $ssr_xlsx = shift;
	my $project = shift;

    # Create an excel workbook
    my $workbook = Excel::Writer::XLSX->new("$ssr_xlsx");

    # Setup the formats that will be necessary for the excel spreadsheet
    my %header = (font         => 'Calibri',
                size         => 12,
                bold         => 1,
                color        => 'black',
                align        => 'left',
                text_wrap    => 1);

    my %text = (font         => 'Calibri',
                size         => 12,
                color        => 'black',
                align        => 'left',
                text_wrap    => 1);

    #add the formats to the workbook
    my $header_format = $workbook->add_format(%header);
    my $text_format = $workbook->add_format(%text);

	my $worksheet_stats = create_stats_worksheet($workbook, $header_format, $text_format, $project);

	build_data_worksheets($workbook, $header_format, $text_format);

	$worksheet_stats->activate();
	$worksheet_stats->select();
	$workbook->close();


}

sub create_stats_worksheet{
    my $workbook      = shift;
    my $header_format = shift;
    my $text_format   = shift;
    my $project       = shift;

    my $worksheet = $workbook->add_worksheet("Summary");

	## set all cells to text format
	## only cells that need the header format will need to specify the format during write
	## set column widths
    $worksheet->set_column('A:A', 75, $text_format);
    $worksheet->set_column('B:B', 30, $text_format);
    $worksheet->set_column('C:C', 30, $text_format);

    $worksheet->write('A1', "SSR Summary Report for $project", $header_format);
    $worksheet->write('A2', "Analysis of $SEQ_COUNT sequences");
    $worksheet->write('A3', "$TIME");

    $worksheet->write('A5', "Number of sequences with at least one SSR");
	$worksheet->write('B5', "$SEQ_w_SSRS");

    $worksheet->write('A6', "Number of SSRs identified");
	$worksheet->write('B6', "$SSR_COUNT");

    $worksheet->write('A8', "Number of compound SSRs*:");
	$worksheet->write('B8', "$SSR_COUNT_COMPOUND");

    $worksheet->write('A9', "Number of SSRs with primers**");
	$worksheet->write('B9', "$SSR_COUNT_PRIMER");

    $worksheet->write('A11', "*Compound SSRs are defined as any SSRs next to each or separated by less than 15 bases\n");

    $worksheet->write('A12', "**No primers are designed for compound SSRs\n");

    $worksheet->write('A14', "Parameters used for identifying SSRS:\n", $header_format);

    $worksheet->write('A15','Base Pairs in Motif', $header_format);
    $worksheet->write('B15','Min # Reps', $header_format);
    $worksheet->write('C15','Max # Reps', $header_format);

    $worksheet->write('A16','2 (Dinucleotides)');
    $worksheet->write('B16',"$MIN_REPS_2bp");
    $worksheet->write('C16',"$MAX_REPS_2bp");

    $worksheet->write('A17','3 (Trinucleotides)');
    $worksheet->write('B17',"$MIN_REPS_3bp");
    $worksheet->write('C17',"$MAX_REPS_3bp");

    $worksheet->write('A18','4 (Tetranucleotides)');
    $worksheet->write('B18',"$MIN_REPS_4bp");
    $worksheet->write('C18',"$MAX_REPS_4bp");

	##----------------------------------------------------------
	##Chart of motif pattern frequence (compound SSRs excluded)

    $worksheet->write('A20','Chart of motif pattern frequence (compound SSRs excluded)', $header_format);
    $worksheet->write('A21','Motif Patterns', $header_format);
    $worksheet->write('B21','Number of SSRs Found', $header_format);
    my $group;
    my $i = 21;
    foreach $group (sort {length $a <=> length $b} keys %MOTIFS){
        $group =~ s/^|//;
        $group =~ s/|$//;
        $i++;
        $worksheet->write("A$i", $group);
        $worksheet->write("B$i", $MOTIFS{$group});
    }

	##----------------------------------------------------------
	## Chart of motif pattern length frequence (compound SSRs excluded)
    $i++;
    $i++;
	$worksheet->write("A$i", "Chart of motif pattern length frequence (compound SSRs excluded)", $header_format);
    $i++;
    $worksheet->write("A$i",'Motif Pattern Length', $header_format);
    $worksheet->write("B$i",'Number of SSRs Found', $header_format);
    foreach $group (sort keys %MOTIFLEN){
        $i++;
        $worksheet->write("A$i", "$group bp");
        $worksheet->write("B$i", $MOTIFLEN{$group});
    }

	##----------------------------------------------------------
	## SSRs w primers:
	## Chart of motif pattern length frequence (compound SSRs excluded)
    $i++;
    $i++;
    $worksheet->write("A$i",'SSRs with Primers', $header_format);
    $i++;
    $worksheet->write("A$i",'Chart of motif pattern length frequence (compound SSRs excluded)', $header_format);
    $i++;
    $worksheet->write("A$i",'Motif Pattern Length', $header_format);
        $worksheet->write("B$i",'Number of SSRs Found', $header_format);
    foreach $group (sort keys %MOTIFLEN_w_PRIMERS){
        $i++;
        $worksheet->write("A$i", "$group bp");
        $worksheet->write("B$i", $MOTIFLEN_w_PRIMERS{$group});
    }

	return $worksheet;
}

##############################################################
sub build_data_worksheets{
    my $workbook      = shift;
    my $header_format = shift;
    my $text_format   = shift;

	my $di_worksheet  =  _initiate_worksheet($workbook, $header_format, $text_format, "Dinucleotides");
	my $tri_worksheet  =  _initiate_worksheet($workbook, $header_format, $text_format, "Trinucleotides");
	my $tetra_worksheet  =  _initiate_worksheet($workbook, $header_format, $text_format, "Tetranucleotides");

	my $di_index = 3;
	my $tri_index = 3;
	my $tetra_index = 3;

	foreach my $ssr_id (keys %SSR_STATS){
		# for excel data files, only print SSRs 
		# that have primers
		if($SSR_STATS{$ssr_id}{COMPOUND} == 0 &&
			$SSR_STATS{$ssr_id}{FORWARD} =~ /\S/
		){
			if($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 2){
				_print_excel_file_line($di_worksheet, $di_index, $ssr_id);
				$di_index++;
			}
			elsif($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 3){
				_print_excel_file_line($tri_worksheet, $tri_index, $ssr_id);
				$tri_index++;
			}
			elsif($SSR_STATS{$ssr_id}{MOTIF_LENGTH} == 4){
				_print_excel_file_line($tetra_worksheet, $tetra_index, $ssr_id);
				$tetra_index++;
			}
		}
	}


}

##############################################################
sub _initiate_worksheet{
    my $workbook      = $_[0];
    my $header_format = $_[1];
    my $text_format   = $_[2];
	my $name          = $_[3];

    my $worksheet = $workbook->add_worksheet($name);
    $worksheet->set_column('A:A', 60, $text_format);
    $worksheet->set_column('B:E', 10, $text_format);
    $worksheet->set_column('F:G', 30, $text_format);
    $worksheet->set_column('H:J', 10, $text_format);

    $worksheet->write('A1', "$name with primers", $header_format);
    $worksheet->write('A2', 'SSR ID', $header_format);
	$worksheet->write('B2', 'Motif', $header_format);
    $worksheet->write('C2', '# Repeats', $header_format);
    $worksheet->write('D2', 'Start', $header_format);
    $worksheet->write('E2', 'End', $header_format);
    $worksheet->write('F2', 'Forward Primer', $header_format);
    $worksheet->write('G2', 'Reverse Primer', $header_format);
    $worksheet->write('H2', 'Forward Tm', $header_format);
    $worksheet->write('I2', 'Reverse Tm', $header_format);
    $worksheet->write('J2', 'Fragment Size', $header_format);

	return $worksheet;
}


################################################################
sub _print_excel_file_line{
	my $worksheet = shift;
	my $index = shift;
	my $ssr_id = shift;

	$worksheet->write("A$index", $ssr_id);
	$worksheet->write("B$index", $SSR_STATS{$ssr_id}{MOTIF});
	$worksheet->write("C$index", $SSR_STATS{$ssr_id}{NO_REPEATS});
	$worksheet->write("D$index", $SSR_STATS{$ssr_id}{START});
	$worksheet->write("E$index", $SSR_STATS{$ssr_id}{END});
	$worksheet->write("F$index", $SSR_STATS{$ssr_id}{FORWARD});
	$worksheet->write("G$index", $SSR_STATS{$ssr_id}{REVERSE});
	$worksheet->write("H$index", $SSR_STATS{$ssr_id}{LEFT_TM});
	$worksheet->write("I$index", $SSR_STATS{$ssr_id}{RIGHT_TM});
	$worksheet->write("J$index", $SSR_STATS{$ssr_id}{PRODUCT_SIZE});

}

###############################################################
sub _printUsage {
    print "Usage: $0.pl <arguments>";
    print qq(
    The list of arguments includes:

    -f|--fasta_file <fasta_file>
        Required.  The file of the sequences to be searched. 

    -m|--masked_file <masked_fasta_file>
        Required.  A soft-masked version of the fasta file (soft masked means low
        complexity sequences are in lower case bases.)

    -p|--project "project name"
        Optional.  A project name for use in the Excel output.

    );
    print "\n";
    return;
}


1;
