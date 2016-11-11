#!/usr/bin/perl

use Win32::Console;
$OUT = Win32::Console->new(STD_OUTPUT_HANDLE);

my $player = "X";
my $winner = "";
my $nomoves = 0;
my $message = "";
my $a1, $a2, $a3, $b1, $b2, $b3, $c1, $c2, $c3;
my $temp = 0;
my $aiturn = 0;
my $with_ai = 0;

while(1){
	$OUT->Cls;
	print "Two Player? (y/n) : ";
	chomp($choice = <STDIN>);
	if($choice eq "y"){
		$with_ai = 0;
		last;
	}elsif($choice eq "n"){
		$with_ai = 1;
		last;
	}else{
		$OUT->Cls;
		print "Opps!! Invalid Input. Press any key to try again\n\n";
	}
	<STDIN>;
}

&reset_game();
&play_the_game();

sub reset_game{

	$a1 = " "; 
	$a2 = " "; 
	$a3 = " "; 
	$b1 = " "; 
	$b2 = " "; 
	$b3 = " "; 
	$c1 = " "; 
	$c2 = " "; 
	$c3 = " "; 
	
	$player = "X";
	$winner = "";
	$nomoves = 0; 
	$message = "";
	
}

sub game_finished{
	&display_game_board();
	print "\n Press any key: ";
	$reply = <STDIN>;
}

sub play_the_game{

	my $isfinished = 0;
	my $validmove = 0;
	my $reply = "";
  
	until($isfinished){
		if($winner eq "X"){
			$message = "GAME OVER: Player X has won!";
			&game_finished();
			return;
		}
	
		if($winner eq "O"){
			$message = "GAME OVER: Player O has won!";
			&game_finished();
			return;
		}

		if($winner eq "tie"){
			$message = "GAME OVER: Tie!";
			&game_finished();
			return;
		}
		
		if($with_ai eq 1 && $player eq "O"){
			#&display_game_board();
			$aiturn = 0;
	 
			if($aiturn eq 0){
				&checkatk();
			}
			if($aiturn eq 0){
				&checkdef();
			}
			if($aiturn eq 0){
				&aiplay();
				$temp = 0;
			}
	 
			$aiturn = 0;
			
		}else{
			$message = "Player $player" . "'s move";
			&display_game_board();
			print " Move: ";
			chomp($reply = <STDIN>);
			
			$validmove = &validate_selection($reply);

			if($validmove == 1){
				$nomoves = $nomoves + 1;
				&identify_selection($reply);
			}else{
				$OUT->Cls;
				print "Invalid move. Press Enter to try again.\n\n";
				$reply = <STDIN>;
			}
		}

		&look_for_winner();
		
		if(($with_ai eq 1 && $player eq "O") || $validmove eq 1){
			if($player eq "X"){
				$player = "O";
			}else{
				$player = "X";
			}
		}
	}

}

sub display_game_board{

	$OUT->Cls;
	print "\n";
	if($with_ai==0){
		print "                                  Two Player\n";
	}else{
		print "                               Playing with AI\n";
	}

	print "                                    \n\n\n";
	print "                                 1     2     3\n\n";
	print "                            a    $a1  |  $a2  |  $a3\n";
	print "                               -----|-----|-----\n";
	print "                            b    $b1  |  $b2  |  $b3\n";
	print "                               -----|-----|-----\n";
	print "                            c    $c1  |  $c2  |  $c3\n\n\n";
	print "                            $message\n\n"
	
}

sub validate_selection{

	my $move = $_[0];

	if($move =~ /a1|a2|a3|b1|b2|b3|c1|c2|c3/){
		if($move eq "a1" && $a1 ne " "){return 0;}
		if($move eq "a2" && $a2 ne " "){return 0;}
		if($move eq "a3" && $a3 ne " "){return 0;}
		if($move eq "b1" && $b1 ne " "){return 0;}
		if($move eq "b2" && $b2 ne " "){return 0;}
		if($move eq "b3" && $b3 ne " "){return 0;}
		if($move eq "c1" && $c1 ne " "){return 0;}
		if($move eq "c2" && $c2 ne " "){return 0;}
		if($move eq "c3" && $c3 ne " "){return 0;}
		return 1;
	}else{
		return 0;
	}

}

sub identify_selection{

	my $move = $_[0];

	if($move eq "a1"){$a1 = $player;}
	if($move eq "a2"){$a2 = $player;}
	if($move eq "a3"){$a3 = $player;}
	if($move eq "b1"){$b1 = $player;}
	if($move eq "b2"){$b2 = $player;}
	if($move eq "b3"){$b3 = $player;}
	if($move eq "c1"){$c1 = $player;}
	if($move eq "c2"){$c2 = $player;}
	if($move eq "c3"){$c3 = $player;}

}

sub look_for_winner{

	if($a1 eq $player && $a2 eq $player && $a3 eq $player){
		$winner = $player;
	}elsif($b1 eq $player && $b2 eq $player && $b3 eq $player){
		$winner = $player;
	}elsif($c1 eq $player && $c2 eq $player && $c3 eq $player){
		$winner = $player;
	}elsif($a1 eq $player && $b1 eq $player && $c1 eq $player){
		$winner = $player;
	}elsif($a2 eq $player && $b2 eq $player && $c2 eq $player){
		$winner = $player;
	}elsif($a3 eq $player && $b3 eq $player && $c3 eq $player){
		$winner = $player;
	}elsif($a1 eq $player && $b2 eq $player && $c3 eq $player){
		$winner = $player;
	}elsif($c1 eq $player && $b2 eq $player && $a3 eq $player){
		$winner = $player;
	}elsif($nomoves eq 9){
		$winner = "tie";
	}

}

sub aiplay{
	my $rand = int rand(9);
	
	if(&get_var_val($rand) ne "O" && &get_var_val($rand) ne "X"){
		&change_char_single($rand, "O");
		$aiturn = 1;
		$temp = 1;
		return;
	}
	
	if($temp ne 1){
		&aiplay();
	}
}

sub get_var_val{
	my $a = $_[0];
	if($a eq 0){ return $a1; }
	if($a eq 1){ return $a2; }
	if($a eq 2){ return $a3; }
	if($a eq 3){ return $b1; }
	if($a eq 4){ return $b2; }
	if($a eq 5){ return $b3; }
	if($a eq 6){ return $c1; }
	if($a eq 7){ return $c2; }
	if($a eq 8){ return $c3; }
}

sub change_char_single{
	my $a = $_[0];
	my $b = $_[1];
	if($a eq 0){ $a1 = $b; }
	if($a eq 1){ $a2 = $b; }
	if($a eq 2){ $a3 = $b; }
	if($a eq 3){ $b1 = $b; }
	if($a eq 4){ $b2 = $b; }
	if($a eq 5){ $b3 = $b; }
	if($a eq 6){ $c1 = $b; }
	if($a eq 7){ $c2 = $b; }
	if($a eq 8){ $c3 = $b; }
}

sub check_char{
	my $a = $_[0];
	my $b = $_[1];
	if($a eq 0){
		if($b eq 0){
			return $a1;
		}elsif($b eq 1){
			return $a2;
		}elsif($b eq 2){
			return $a3;
		}
	}elsif($a eq 1){
		if($b eq 0){
			return $b1;
		}elsif($b eq 1){
			return $b2;
		}elsif($b eq 2){
			return $b3;
		}
	}elsif($a eq 2){
		if($b eq 0){
			return $c1;
		}elsif($b eq 1){
			return $c2;
		}elsif($b eq 2){
			return $c3;
		}
	}
}

sub change_char{
	my $a = $_[0];
	my $b = $_[1];
	my $c = $_[2];
	if($a eq 0){
		if($b eq 0){
			$a1 = $c;
		}elsif($b eq 1){
			$a2 = $c;
		}elsif($b eq 2){
			$a3 = $c;
		}
	}elsif($a eq 1){
		if($b eq 0){
			$b1 = $c;
		}elsif($b eq 1){
			$b2 = $c;
		}elsif($b eq 2){
			$b3 = $c;
		}
	}elsif($a eq 2){
		if($b eq 0){
			$c1 = $c;
		}elsif($b eq 1){
			$c2 = $c;
		}elsif($b eq 2){
			$c3 = $c;
		}
	}
}


sub checkatk{
    my $danger = 0;
    my $danger2 = 0;
    my $danger3 = 0;
    my $danger4 = 0;
	my $ttp1 = 0;
	my $ttp2 = 0;
 
    for($ttp1=0; $ttp1<3; $ttp1++){
        for($ttp2=0; $ttp2<3; $ttp2++){
            if($ttp2 eq 0){
                $danger = 0;
			}
			if(&check_char($ttp1, $ttp2) eq "O"){
				$danger += 1;
			}
		}
 
        if($danger eq 2){
            for($ttp2=0; $ttp2<3; $ttp2++){
				if(&check_char($ttp1, $ttp2) ne "O" && &check_char($ttp1, $ttp2) ne "X" and $aiturn eq 0){
                    #print "Ai played";
                    &change_char($ttp1, $ttp2, "O");
                    $danger = 0;
                    $aiturn = 1;
				}
			}
		}
		
		for($ttp2=0; $ttp2<3; $ttp2++){
			if($ttp2 eq 0){
				$danger2 = 0;
			}
			if(&check_char($ttp2, $ttp1) eq "0"){
				$danger2 += 1;
			}
		}
		
		if($danger2 eq 2){
			for($ttp2=0; $ttp2<3; $ttp2++){
				if(&check_char($ttp2, $ttp1) ne "O" && &check_char($ttp2, $ttp1) ne "X" and $aiturn eq 0){
					#print "Ai played";
                    &change_char($ttp2, $ttp1, "O");
                    $danger2 = 0;
                    $aiturn = 1;
				}
			}
		}
		
	}
		
	if(&check_char(1, 1) eq "O"){
		$danger3 += 1;
		$danger4 += 1;
	}
	if(&check_char(0, 0) eq "O"){
		$danger3 += 1;
	}
	if(&check_char(2, 2) eq "O"){
		$danger3 += 1;
	}
	if(&check_char(2, 0) eq "O"){
		$danger4 += 1;
	}
	if(&check_char(0, 2) eq "O"){
		$danger4 += 1;
	}
	
	if($danger3 eq 2 && $aiturn eq 0){
		if(&check_char(0, 0) ne "O" && &check_char(0, 0) ne "X"){
			#print "Ai played";
            &change_char(0, 0, "O");
            $aiturn = 1;
		}
		
		if(&check_char(1, 1) ne "O" && &check_char(1, 1) ne "X"){
			#print "Ai played";
            &change_char(1, 1, "O");
            $aiturn = 1;
		}
		
		if(&check_char(2, 2) ne "O" && &check_char(2, 2) ne "X"){
			#print "Ai played";
            &change_char(2, 2, "O");
            $aiturn = 1;
		}
	}
	
	if($danger4 eq 2 && $aiturn eq 0){
		if(&check_char(0, 2) ne "O" && &check_char(0, 2) ne "X"){
			#print "Ai played";
            &change_char(0, 2, "O");
            $aiturn = 1;
		}
		
		if(&check_char(1, 1) ne "O" && &check_char(1, 1) ne "X"){
			#print "Ai played";
            &change_char(1, 1, "O");
            $aiturn = 1;
		}
		
		if(&check_char(2, 0) ne "O" && &check_char(2, 0) ne "X"){
			#print "Ai played";
            &change_char(2, 0, "O");
            $aiturn = 1;
		}
	}
}



sub checkdef{
    my $danger = 0;
    my $danger2 = 0;
    my $danger3 = 0;
    my $danger4 = 0;
	my $tp1 = 0;
	my $tp2 = 0;
 
    for($tp1=0; $tp1<3; $tp1++){
        for($tp2=0; $tp2<3; $tp2++){
            if($tp2 eq 0){
                $danger = 0;
			}
			if(&check_char($tp1, $tp2) eq "X"){
				$danger += 1;
			}
		}
 
        if($danger eq 2){
            for($tp2=0; $tp2<3; $tp2++){
				if(&check_char($tp1, $tp2) ne "O" && &check_char($tp1, $tp2) ne "X" and $aiturn eq 0){
                    #print "Ai played";
                    &change_char($tp1, $tp2, "O");
                    $danger = 0;
                    $aiturn = 1;
				}
			}
		}
		
		for($tp2=0; $tp2<3; $tp2++){
			if($tp2 eq 0){
				$danger2 = 0;
			}
			if(&check_char($tp2, $tp1) eq "X"){
				$danger2 += 1;
			}
		}
		
		if($danger2 eq 2){
			for($tp2=0; $tp2<3; $tp2++){
				if(&check_char($tp2, $tp1) ne "O" && &check_char($tp2, $tp1) ne "X" and $aiturn eq 0){
					#print "Ai played";
                    &change_char($tp2, $tp1, "O");
                    $danger2 = 0;
                    $aiturn = 1;
				}
			}
		}
		
	}
		
	if(&check_char(1, 1) eq "X"){
		$danger3 += 1;
		$danger4 += 1;
	}
	if(&check_char(0, 0) eq "X"){
		$danger3 += 1;
	}
	if(&check_char(2, 2) eq "X"){
		$danger3 += 1;
	}
	if(&check_char(2, 0) eq "X"){
		$danger4 += 1;
	}
	if(&check_char(0, 2) eq "X"){
		$danger4 += 1;
	}
	
	if($danger3 eq 2 && $aiturn eq 0){
		if(&check_char(0, 0) ne "O" && &check_char(0, 0) ne "X"){
			#print "Ai played";
            &change_char(0, 0, "O");
            $aiturn = 1;
		}
		
		if(&check_char(1, 1) ne "O" && &check_char(1, 1) ne "X"){
			#print "Ai played";
            &change_char(1, 1, "O");
            $aiturn = 1;
		}
		
		if(&check_char(2, 2) ne "O" && &check_char(2, 2) ne "X"){
			#print "Ai played";
            &change_char(2, 2, "O");
            $aiturn = 1;
		}
	}
	
	if($danger4 eq 2 && $aiturn eq 0){
		if(&check_char(0, 2) ne "O" && &check_char(0, 2) ne "X"){
			#print "Ai played";
            &change_char(0, 2, "O");
            $aiturn = 1;
		}
		
		if(&check_char(1, 1) ne "O" && &check_char(1, 1) ne "X"){
			#print "Ai played";
            &change_char(1, 1, "O");
            $aiturn = 1;
		}
		
		if(&check_char(2, 0) ne "O" && &check_char(2, 0) ne "X"){
			#print "Ai played";
            &change_char(2, 0, "O");
            $aiturn = 1;
		}
	}
}