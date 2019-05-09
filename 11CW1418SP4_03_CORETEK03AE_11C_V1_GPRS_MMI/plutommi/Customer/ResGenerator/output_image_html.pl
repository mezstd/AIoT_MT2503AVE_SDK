#*****************************************************************************
#
#  Copyright Statement:
#  --------------------
#  This software is protected by Copyright and the information contained
#  herein is confidential. The software may not be copied and the information
#  contained herein may not be used or disclosed except with the written
#  permission of MediaTek Inc. (C) 2005
#
#  BY OPENING THIS FILE, BUYER HEREBY UNEQUIVOCALLY ACKNOWLEDGES AND AGREES
#  THAT THE SOFTWARE/FIRMWARE AND ITS DOCUMENTATIONS ("MEDIATEK SOFTWARE")
#  RECEIVED FROM MEDIATEK AND/OR ITS REPRESENTATIVES ARE PROVIDED TO BUYER ON
#  AN "AS-IS" BASIS ONLY. MEDIATEK EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES,
#  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE OR NONINFRINGEMENT.
#  NEITHER DOES MEDIATEK PROVIDE ANY WARRANTY WHATSOEVER WITH RESPECT TO THE
#  SOFTWARE OF ANY THIRD PARTY WHICH MAY BE USED BY, INCORPORATED IN, OR
#  SUPPLIED WITH THE MEDIATEK SOFTWARE, AND BUYER AGREES TO LOOK ONLY TO SUCH
#  THIRD PARTY FOR ANY WARRANTY CLAIM RELATING THERETO. MEDIATEK SHALL ALSO
#  NOT BE RESPONSIBLE FOR ANY MEDIATEK SOFTWARE RELEASES MADE TO BUYER'S
#  SPECIFICATION OR TO CONFORM TO A PARTICULAR STANDARD OR OPEN FORUM.
#
#  BUYER'S SOLE AND EXCLUSIVE REMEDY AND MEDIATEK'S ENTIRE AND CUMULATIVE
#  LIABILITY WITH RESPECT TO THE MEDIATEK SOFTWARE RELEASED HEREUNDER WILL BE,
#  AT MEDIATEK'S OPTION, TO REVISE OR REPLACE THE MEDIATEK SOFTWARE AT ISSUE,
#  OR REFUND ANY SOFTWARE LICENSE FEES OR SERVICE CHARGE PAID BY BUYER TO
#  MEDIATEK FOR SUCH MEDIATEK SOFTWARE AT ISSUE.
#
#  THE TRANSACTION CONTEMPLATED HEREUNDER SHALL BE CONSTRUED IN ACCORDANCE
#  WITH THE LAWS OF THE STATE OF CALIFORNIA, USA, EXCLUDING ITS CONFLICT OF
#  LAWS PRINCIPLES.  ANY DISPUTES, CONTROVERSIES OR CLAIMS ARISING THEREOF AND
#  RELATED THERETO SHALL BE SETTLED BY ARBITRATION IN SAN FRANCISCO, CA, UNDER
#  THE RULES OF THE INTERNATIONAL CHAMBER OF COMMERCE (ICC).
#
#*****************************************************************************
#
# Filename: 
# ---------
#   output_image_html.pl
#
# Description: 
# ------------
#   Parse image_resource_usage.txt and output image_resource_usage.htm
#       [usage] output_image_html.pl
#
# Auther: 
# -------
#   Fred
# 
# Note:
# -----
#
# Log: 
# -----
#
#*****************************************************************************

#!/usr/bin/perl

# open files
open(HTMFILE, ">Debug\\image_resource_usage.htm") or die "Cannot open image_resource_usage.htm";

print STDOUT "Output image_resource_usage.htm...";

#output html
select HTMFILE;

print qq{
<HTML>
  <HEAD>
  <style TYPE="text/css"> 
      .report_head {font-family: arial; font-size:x-large; color: #879311}
      .report_desc {font-family: arial; font-size:x-small;color: #808080}
      .report_subtitle {font-family: arial; font-weight: bold; color: #879311}
      table.resList {font-family: arial; font-size:x-small }
      .resList {font-family: arial; font-size:x-small }
      .resList_header {background-color:#e0e0e0}
      a.nodec {color: #808080}
      a.nodec:hover	{color: #808080}
      td.resList_header {text-align:right}
      .selection_title {font-family: arial; font-weight: bold; font-size:x-small}
      .selection_sub_title {font-family: arial; font-size:x-small;font-style: italic}
      .resList_common {font-style: italic;font-size:x-small}
  </style> 
  </HEAD>
<BODY>

<script type="text/javascript"> 
function hideImage (forminput)
{
	var table = document.getElementById('mytable');
	for (var i = 0; i < table.rows.length; i++)
	{
	    if (forminput.checked)
	    {
	        table.rows[i].cells[2].style.display = 'none';
	    }
	    else
      {
          table.rows[i].cells[2].style.display = '';
      }
	}
}

function filter (forminput)
{
	var filtername = forminput.value.toUpperCase();
	var table = document.getElementById('mytable');
	for (var i = 1; i < table.rows.length; i++)
	{
	    var r = table.rows[i];
	      if (r.innerHTML.toUpperCase().indexOf(filtername) >= 0 || filtername == '--ALL--')
	    {
	        r.style.display = '';
	    }
	    else
	    {
	        r.style.display = 'none';
	    }
	}
}
</script>
  <center><h2 class ="report_head">Image Resource Usage Report</h2>
  <p class = "report_desc"> This report is generated by MAUI Resgen Tool 
};

# Show report generation time
my $rightnow = time();
my $time_stamp_str = scalar localtime $rightnow;
print "( $time_stamp_str ) ";

# Show RES slection list
print qq{
    </p></center>
    <BR>
    <span class = "report_subtitle">Image Resource List</span>
    <hr/>
    <span class = "selection_title">APP .RES/.C File: </span>
    <select onchange="filter(this)">     
};


open(LOGFILE, "<Debug\\image_resource_usage_ext.txt") or die "Cannot open image_resource_usage.txt";
while (<LOGFILE>)
{
    split(/\t/);

    $_ = uc(@_[5]);
    $respath{$_} = 1;

    $_ = uc(@_[6]);
    $_ =~s/\\/\//g;
    ($path, $name) = /(.*)\/+(.*?)$/;

    if($_ eq "RES_FILENAME"){
        $name = '--ALL--';
    };
   
    if($name eq ""){
        $name = $_;
    }
       
    $resfile{$name} = 1;
}
close(LOGFILE);

print "<option value=\"$_\">$_</option>\n" foreach sort keys(%resfile);

print qq{
    </select>
    <input type="checkbox" title="enable/disable image display" onclick="hideImage(this)">
    <span class = "selection_sub_title">Hide Image</span> 

    <TABLE border=2, id="mytable" class="resList">
    <TR>
        <TD align="center"><B>Index</B></TD>
        <TD align="center"><B>APP Name</B></TD>
        <TD align="center"><B>Image</B></TD>
        <TD align="center"><B>Image ID</B></TD>
        <TD align="center"><B>Size</B></TD>
        <TD align="center"><B>Real Size</B></TD>
        <TD align="center"><B>Color Number</B></TD>
        <TD align="center"><B>ABM\/ABM2 Converted</B></TD>
        <TD align="center"><B>File Path</B></TD>
        <TD align="center"><B>Resource file</B></TD>
    </TR>

};

open(LOGFILE, "<Debug\\image_resource_usage_ext.txt") or die "Cannot open image_resource_usage.txt";
$idx = 0;
$dir = "..\\..\\Images";
<LOGFILE>;
while (<LOGFILE>)
{
    $idx = $idx + 1;
    split(/\t/);
    $_ = uc(@_[5]);
    $rpath = $_;

    if (/(\\+IMAGES)(.*?)$/){
	    $_ = $2 ;
	    $dir = "..\\..\\Images";
    }
    if (/(\\VENDOR+)(.*?)$/){
#	    print STDOUT "VENDOR PATH-->$_\n";
	    $dir = "..\\..\\..\\";
    }


    if (-d "$dir$_")
    {
        if (-e "$dir$_"."\\0.bmp")
        {
            $_ = $_."\\0.bmp";
        }
        if (-e "$dir$_"."\\0.pbm")
        {
            $_ = $_."\\0.bmp";
        }
        if (-e "$dir$_"."\\0.png")
        {
            $_ = $_."\\0.pnb";
        }
    }

    my $str = "<TR>";

    $str = $str."<TD><A class=\"nodec\" href=\"$dir$_\">$idx</A></TD>";
    $str = $str."<TD>@_[0]</TD>";
    $str = $str."<TD><A href=\"$dir$_\"><img src=\"$dir$_\"/></A></TD>";
    $str = $str."<TD>@_[3]</TD>";

    if (exists $respath{$rpath})
    {
        $str = $str."<TD>@_[4]</TD><TD>@_[4]</TD>";
        delete $respath{$rpath};
    }
    else
    {
        $str = $str."<TD>@_[4]</TD><TD>0</TD>";
    }

    # Color Number and ABM/ABM converted
    $str = $str."<TD>@_[7]</TD><TD>@_[8]</TD>";
    
    # Image Path
    $str = $str."<TD class =\"resList_common\">$_</TD>";
    
    $_ = uc(@_[6]);
    $_ =~s/\\/\//g;
    ($path, $name) = /(.*)\/+(.*?)$/;

   
    # Put complete Res file path here
    # $str = $str."<TD>$name</TD>";
    $str = $str."<TD class =\"resList_common\">$_</TD>";    

    
    $str = $str."</TR>\n";
    #print "$str\n";

    $str_list{$str} = $rpath;
}
close(LOGFILE);

sub tableValueSorting {
   $str_list{$a} cmp $str_list{$b};
}

print "$_" foreach (sort tableValueSorting (keys %str_list));

print qq{
</TABLE>

</BODY>
</HTML>
};

print STDOUT "done.\n";

# close files
close(HTMFILE);