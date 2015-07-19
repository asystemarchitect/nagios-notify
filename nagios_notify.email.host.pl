#!/usr/bin/perl
################################################################################
#
#	Program:	nagios_notify.email.host.pl
#	Author:		Tim Schaefer, tim@asystemarchitect.com
#	Latest:		July 2009
#	Description:	Formats Nagios email with HTML or ASCII
#	Usage:		nagios_notify.cgi.host.pl 
#
################################################################################

        use POSIX ;
        use CGI ;

	my $co = new CGI ;

        my $contactemail = $co->param("contactemail");
           $contactemail = ($contactemail)?"$contactemail" : "NULL" ;

        my $hostaddress = $co->param("hostaddress");
           $hostaddress = ($hostaddress)?"$hostaddress" : "NULL" ;

        my $host = $co->param("host");
           $host = ($host)?"$host" : "NULL" ;

        my $hostname = $co->param("hostname");
           $hostname = ($hostname)?"$hostname" : "NULL" ;

        my $hostoutput = $co->param("hostoutput");
           $hostoutput = ($hostoutput)?"$hostoutput" : "NULL" ;

        my $hostalias = $co->param("hostalias");
           $hostalias = ($hostalias)?"$hostalias" : "NULL" ;

        my $hostgroupname = $co->param("hostgroupname");
           $hostgroupname = ($hostgroupname)?"$hostgroupname" : "NULL" ;

        my $hoststate = $co->param("hoststate");
           $hoststate = ($hoststate)?"$hoststate" : "NULL" ;

        my $longdatetime = $co->param("longdatetime");
           $longdatetime = ($longdatetime)?"$longdatetime" : "NULL" ;

        my $nagtype = $co->param("nagtype");
           $nagtype = ($nagtype)?"$nagtype" : "NULL" ;

        my $notificationtype = $co->param("notificationtype");
           $notificationtype = ($notificationtype)?"$notificationtype" : "NULL" ;

        my $notificationcomment = $co->param("notificationcomment");
           $notificationcomment = ($notificationcomment)?"$notificationcomment" : "NULL" ;

        my $serviceoutput = $co->param("serviceoutput");
           $serviceoutput = ($serviceoutput)?"$serviceoutput" : "NULL" ;

        my $service = $co->param("service");
           $service = ($service)?"$service" : "NULL" ;

        my $servicestate = $co->param("servicestate");
           $servicestate = ($servicestate)?"$servicestate" : "NULL" ;

	my $mime = $co->param("mime");
	   $mime = ($mime)?"$mime" : "H" ;

	my $recipient        = $contactemail ;
        my $subject          = "HOST $notificationtype : $hostalias :$hoststate" ;

        if ( $recipient eq "NULL" )
                {
                exit ;
                }

	my $svc_font_color = "black" ;
	my $svc_bkgd       = "white" ;

	if( $hoststate eq 'OK'       ) { $svc_font_color = 'black' ; $svc_bkgd = 'lime' ; }
	if( $hoststate eq 'RECOVERY' ) { $svc_font_color = 'black' ; $svc_bkgd = 'lime'   ; }
	if( $hoststate eq 'WARNING'  ) { $svc_font_color = 'black' ; $svc_bkgd = 'yellow' ; }
	if( $hoststate eq 'UNKNOWN'  ) { $svc_font_color = 'black' ; $svc_bkgd = 'orange' ; }
	if( $hoststate eq 'DOWN'     ) { $svc_font_color = 'white' ; $svc_bkgd = 'red' ; }
	if( $hoststate eq 'CRITICAL' ) { $svc_font_color = 'white' ; $svc_bkgd = 'red'    ; }

        my $email_program = '/usr/sbin/sendmail' ;
	my $to ;
	my $from ;

        my $smtp_hostname = `hostname` ;
           chomp $smtp_hostname ;

	$from = "Nagios < nagios\@${smtp_hostname} > " ;
	$to   = $recipient ;

	$nagios_url = "<a href=http://" . $smtp_hostname . "/nagios/cgi-bin/status.cgi?host=" . $hostname . ">Nagios</a>"  ;

	my $subject_url         = "$hostname" . "%20:%20" . $hoststate ;

        open( OUT, "|$email_program -i -t" ) ;

print OUT <<ENDOFMESSAGE;
From: $from
To: $to
Subject: $subject
Mime-Version: 1.0
Content-type: text/html; charset="iso-8859-1"




<style type=text/css>
a           	{ text-decoration: none; color: #63309C ; font-size:9px; font-weight:bold; font-family:arial,helvetica,sans-serif;  }
a:link      	{ text-decoration: none; color: #63309C ; font-size:9px; font-weight:bold; font-family:arial,helvetica,sans-serif;  }
a:visited   	{ text-decoration: none; color: #63309C ; font-size:9px; font-weight:bold; font-family:arial,helvetica,sans-serif;  }
a:hover     	{ text-decoration: none; color: #63309C ; font-size:9px; font-weight:bold; font-family:arial,helvetica,sans-serif;  }
a:active    	{ text-decoration: none; color: blue    ; font-size:9px; font-weight:bold; font-family:arial,helvetica,sans-serif;  }

td	{
	empty-cells: show ;
	border-radius:4px; border:1px solid #cfcfcf;
	padding:1px;
	margin:1px;
	font-family:arial,sans-serif;
	font-size:9px;
	font-weight:normal;
	}

td#titlecell	{
	padding:1px;
	margin:1px;
	border-radius:4px; border:1px solid #cfcfcf;
	background-color:#efefef;
	text-align:right;
	width:100px;
	max-width:100px;
	font-family:arial,sans-serif;
	font-size:9px;
	font-weight:normal;
	empty-cells: show ;
}

.hoststate	{
		font-family:arial,sans-serif;
		font-size:10px;
		color:$svc_font_color ;
		background-color:$svc_bkgd ;
		}

</style>

<center>
<font style='font-family: arial,helvetica; font-size: 10px;' >
<table width=90% style='border-radius:4px; border:4px solid black; border-radius:6px; padding:0px; margin:0px;' >
<tr > 
<td bgcolor=black style='padding:3px;margin:1px;text-align:left; vertical-align:middle; height:50px; border-radius:4px; border:1px solid #cfcfcf;' colspan=2 > 
<!-- add your logo URL Here and remove this comment
<img src=http://images/logos/logo.png >
-->
<font style='color:black;font-family:arial,sans-serif;font-size:18px;' ><b>Nagios Host Notification</td></tr>

<tr><td id=titlecell ><b>TO</td>     <td><a href=mailto:$contactemail?subject=$subject_url >$contactemail</a></td></tr>
<tr><td id=titlecell ><b>HOST NAME</td>         <td>$hostname</td></tr>
<tr><td id=titlecell ><b>STATUS</td> <td class=statustype ><b>$notificationtype</td></tr>
<tr><td id=titlecell ><b>TIME</td>   <td>$longdatetime</td></tr>

<tr><td style='border-radius:4px; border:1px solid #cfcfcf;' colspan=2 bgcolor=#cfcfcf >
<font style='color:black' ><b>Host Information</td></tr>

<tr><td id=titlecell ><b>Host Address</td>      <td>$hostaddress</td></tr>
<tr><td id=titlecell ><b>Host Group</td>        <td>$hostgroupname</td></tr>
<tr><td id=titlecell ><b>Host Alias</td>        <td>$hostalias</td></tr>
<tr><td id=titlecell ><b>Host Output</td>       <td>$hostoutput</td></tr>
<tr><td id=titlecell ><b>Host State</td>        <td class=hoststate ><b>$hoststate</b></td></tr>
ENDOFMESSAGE

	if ( $notificationcomment ne 'NULL' )
		{
print OUT <<ENDOFMESSAGE;
<tr><td id=titlecell ><b>Comment</td>         <td>$notificationcomment</td></tr>
ENDOFMESSAGE
		}

print OUT <<ENDOFMESSAGE;
<tr><td bgcolor=#efefef align=center valign=center colspan=2 >
&nbsp; &nbsp; &nbsp; $nagios_url &nbsp; &nbsp; &nbsp; 
</td>
</tr>


</table>
</center>
ENDOFMESSAGE

close( OUT ) ;

exit ;
