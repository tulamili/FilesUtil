#!/usr/bin/perl
use 5.008 ; use strict ; use warnings ;
use Getopt::Std ; getopts '12l:n' , \my%o ;

$o{l} //= 7 ; #最大何文字に制限するか
my @X = split //,"rwxoRWXOezsfdlpSbctugkTBMAC", 0 ;
my %a  ; # 返答の格納


sub lcut ( $ ) { substr $_[0] , 0 , $o{l} } ;
sub trans ( $ ) {
	my $t = ! defined $_[0] ? "undef" : $o{1} ? qq['$_[0]'] : $o{2} ? qq["$_[0]"] : $_[0] ;
	#$t = qq["$t"] if $o{'.'} ;
	return $t ;
}

push @ARGV , '.' if ! @ARGV ;
my @prtF = ! $o{n} ? @ARGV : map { "file$_" } 1 .. @ARGV ;
print join ( "\t" , @prtF , "The written definition from perldoc -f -X.") , "\n" ;

for ( @ARGV ) {
	my $file = $_ ;
	grep { $a{$_} .=  lcut ( trans ( eval qq[-$_ "$file"]  ) )  . "\t"} @X ;
}
#print "\n\n\n" ,scalar @ARGV , "\n\n\n" ;


#print map{"[$_]"} keys %a ;
print
<<END ;
$a{r}: -r  File is readable by effective uid/gid.
$a{w}: -w  File is writable by effective uid/gid.
$a{x}: -x  File is executable by effective uid/gid.
$a{o}: -o  File is owned by effective uid.

$a{R}: -R  File is readable by real uid/gid.
$a{W}: -W  File is writable by real uid/gid.
$a{X}: -X  File is executable by real uid/gid.
$a{O}: -O  File is owned by real uid.

$a{e}: -e  File exists.
$a{z}: -z  File has zero size (is empty).
$a{s}: -s  File has nonzero size (returns size in bytes).

$a{f}: -f  File is a plain file.
$a{d}: -d  File is a directory.
$a{l}: -l  File is a symbolic link.
$a{p}: -p  File is a named pipe (FIFO), or Filehandle is a pipe.
$a{S}: -S  File is a socket.
$a{b}: -b  File is a block special file.
$a{c}: -c  File is a character special file.
$a{t}: -t  Filehandle is opened to a tty.

$a{u}: -u  File has setuid bit set.
$a{g}: -g  File has setgid bit set.
$a{k}: -k  File has sticky bit set.

$a{T}: -T  File is an ASCII text file (heuristic guess).
$a{B}: -B  File is a "binary" file (opposite of -T).

$a{M}: -M  Script start time minus file modification time, in days.
$a{A}: -A  Same for access time.
$a{C}: -C  Same for inode change time (Unix, may differ for otherplatforms)
END


sub VERSION_MESSAGE {}
sub HELP_MESSAGE {
  use FindBin qw[ $Script ] ;
  $ARGV[1] //= '' ;
  open my $FH , '<' , $0 ;
  while(<$FH>){
    s/\$0/$Script/g ;
    print $_ if $ARGV[1] eq 'opt' ? m/^\ +\-/ : s/^=head1// .. s/^=cut// ;
  }
  close $FH ;
  exit 0 ;
}

=encoding utf8

=head1

 $0 FILE [FILE] [FILE] ..

   Perl言語で提供されているファイルテスト関数を、引数に示された各ファイルに対して実行した結果を示す。

 オプション:

   -l N : 値を先頭(左)から N文字に制限する。
   -n : (ファイル名を隠すなどの目的で) 与えたファイル名を出力するときには file1, file2, .. と出力する。
   -1 : 結果をシングルクオーテーションで囲う。
   -2 : 結果をダブルクオーテーションで囲う。

  開発上のメモ:
    * システムコールを節約するために、stat や lstat を使うと _ でここでやったような処理が出来るようだ。試したい。

=cut
