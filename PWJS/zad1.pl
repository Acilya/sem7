#!/usr/bin/perl

if(@ARGV[0] && @ARGV[0] ne "-l" && @ARGV[0] ne "-L")
{
	$dirname = @ARGV[0];
}
else
{
	$dirname = ".";
}

opendir $dir, $dirname or die "Nie ma takiego katalogu.\n";   # $dir - uchwyt
@files = sort(readdir($dir));   # @ - tablica
closedir $dir;

for $n (@files) 
{
	if (@ARGV[1] eq "-l" or @ARGV[0] eq "-l")
	{
		($mode, $uid, $size, $mtime) = (stat $dirname.'/'.$n)[2,4,7,9];   # wycinek tablicy
		($sec, $min, $hour, $day, $month, $year) = localtime $mtime;
		$time = sprintf "%02d:%02d:%02d %04d-%02d-%02d", $hour, $min, $sec, ($year+1900), ($mon+1), $day;
		$bytes = sprintf "%08d", $size;
		$rights = -d $dirname.'/'.$n ? 'd' : '-';
		@letters = ("x", "w", "r");
		for($i = 8; $i >= 0; $i--)
		{
			$rights .= $mode & (1 << $i) ? @letters[$i % 3] : '-';
		}
		if (@ARGV[1] eq "-L" or @ARGV[1] eq "-L" or @ARGV[0] eq "-L")
		{
			$name  = sprintf "%10s", getpwuid($uid);
			print "$rights $time $bytes $name $n\n";
		}
		else
		{
			print "$rights $time $bytes $n\n";
		}
	}
	else
	{
		print "$n\n";
	}
}
