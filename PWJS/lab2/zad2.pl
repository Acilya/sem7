#!/usr/bin/perl

@all_lines = <STDIN>;    # wczytywanie z inputfile przy wywolaniu: perl program.pl < inputfile
#foreach $line (@all_lines) 
#{
#    chomp($line);    # usuwanie \n na koncu linii
#}
$calendar = join('', @all_lines);    # laczenie calosci w 1 stringa
#@matches = $calendar =~ /(DTSTART;TZID=Europe\/Warsaw:\d+T\d+\s.+?SUMMARY:.+?LOCATION)/g;    # regex dla wersji bez \n
#@matches = $calendar =~ /(DTSTART;TZID=Europe\/Warsaw:\d+T\d+\n.+\n.+\n.+\nSUMMARY:.+)/g;
@matches = $calendar =~ /BEGIN.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\nEND/g;
$hours = 0;
%przedmioty;
foreach $n (@matches)
{
	if ($n =~ /DTSTART;TZID=Europe\/Warsaw:\d+T(\d{2})(\d{2})\d{2}\nDTEND;TZID=Europe\/Warsaw:\d+T(\d{2})(\d{2})\d{2}\n.+\n.+\nSUMMARY:(.+) - Nazwa sem.: .+, Nr sem.: \d, Grupa: ([A-Z0-9]+)_.+_([A-Z])/g)
	{
		# przedmiot - grupa 5; forma studiow - grupa 6; forma zajec - grupa 7
		$time = ($3 * 60 + $4) - ($1 * 60 + $2);
		if ($1 le 12 and $3 ge 14)
		{
			$time -= 30;   # przerwa obiadowa
		}
		$time = sprintf("%d", $time / 45);   # zaokraglenie w dol
		$hours += $time;
		$przedmioty{$5}{$6}{$7} += $time;
	}
}
print "Razem godzin: $hours\n\n";
foreach $przedmiot (sort keys %przedmioty)
{
	$counter = 0;
	print "$przedmiot:\n";
	foreach $forma_st (sort keys %{$przedmioty{$przedmiot}})
	{
		print "   $forma_st:\n";
		$counter2 = 0;
		foreach $forma_zaj (sort keys %{$przedmioty{$przedmiot}->{$forma_st}})
		{
			print "      $forma_zaj: $przedmioty{$przedmiot}{$forma_st}{$forma_zaj}\n";
			$counter += $przedmioty{$przedmiot}{$forma_st}{$forma_zaj};
			$counter2 += $przedmioty{$przedmiot}{$forma_st}{$forma_zaj};
		}
		print "      Razem na studiach $forma_st: $counter2\n";
	}
	print "   Razem z przedmiotu: $counter\n\n";
}

# zapisywanie danych do pliku csv:
$file = "plan.csv";
open($file_handler, ">", $file) or die "Nie mozna otworzyc pliku";
@matches = $calendar =~ /BEGIN.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\n.+\nEND/g;
print $file_handler "Przedmiot;Semestr;Grupa;Sala;Data;Od;Do;Czas\n";
foreach $m (@matches)
{
	if ($m =~ /DTSTART;TZID=Europe\/Warsaw:(\d{4})(\d{2})(\d{2})T(\d{2})(\d{2})\d{2}\nDTEND;TZID=Europe\/Warsaw:\d+T(\d{2})(\d{2})\d{2}\n.+\n.+\nSUMMARY:(.+) - Nazwa sem.: (.+), Nr sem.: \d, Grupa: (.+), Sala: (.+)/g)
	{
		$czas = ($6 * 60 + $7) - ($4 * 60 + $5);
		$godziny = sprintf("%02d", $czas/60);
		$minuty = sprintf("%02d", $czas - $godziny * 60);
		print $file_handler "$8;$9;$10;$11;$3.$2.$1;$4:$5;$6:$7;$godziny:$minuty\n";
	}
}
close $file_handler;