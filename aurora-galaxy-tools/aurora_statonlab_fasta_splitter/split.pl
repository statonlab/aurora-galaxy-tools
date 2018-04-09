#!/usr/bin/perl


 if($ARGV[0] eq "" || $ARGV[1] eq ""){
	die "\n\t Usage : perl <thisScript.pl> <file to be split> <number of partitions> \n\n";
 }


 $homfile = $ARGV[0];
 $numOfFiles = $ARGV[1];


 system("grep -c '^>' $homfile > out");
 open IN, "out" || die "File not found - 2\n";
 $numOfSeqs = <IN>;
 close IN; 

 print "Number of seqs is $numOfSeqs\n";
 my $numPerFile = $numOfSeqs/$numOfFiles;
 print "Num per File is $numPerFile\n";

 open IN, $homfile || die "File not found - 1\n";
 $lineIn = <IN>; 

 for($i = 1; $i <= $numOfFiles; $i++){
	print "$i\n";
	open FILE, ">".$homfile.".".$i.".fasta" || die "Can't open file";
	print FILE $lineIn;
	$seqs = 1;
        $lineIn = <IN>;
	while(defined $lineIn && $seqs < $numPerFile){
 		print FILE $lineIn;
		if ($lineIn =~ /^>/) { $seqs++; }
		$lineIn = <IN>;
	}
	while(defined $lineIn && $lineIn !~ /^>/){
		print FILE $lineIn;
		$lineIn = <IN>;
	}
	close FILE;
 }
 $i = $i -1;
 open FILE, ">>".$homfile.".".$i.".fasta";
 while ($lineIn = <IN>){
	print FILE $lineIn;
 }
 close FILE;

 close IN;


 
