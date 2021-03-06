#!/usr/bin/env perl -w
# Melatonin - Send HTTP requests to RESTful APIs
# Copyright (c) 2015 Ryan Kennedy <ry@nkennedy.net>
#
# Permission to use, copy, modify, distribute, and sell this software and its
# documentation for any purpose is hereby granted without fee, provided that
# the above copyright notice appear in all copies and that both that
# copyright notice and this permission notice appear in supporting
# documentation. No representations are made about the suitability of this
# software for any purpose. It is provided "as is" without express or 
# implied warranty.
#
# Created: 18-Jun-2015

use LWP;
use Mozilla::CA;
use HTTP::Request::Common qw(GET HEAD POST PUT DELETE);
use Term::ANSIColor qw(:constants);
   $Term::ANSIColor::AUTORESET = 1;

my $help_text = <<EOS
 Run this as:
   'perl melatonin.pl method url data output'

 where:
   method = an HTTP verb; GET, HEAD, POST, PUT, DELETE
   url    = where to send the request
   data   = optional; inline data or a filename
   output = optional; data output format

 data:
   When passing inline data, use the following format:
     "data1=value&data2=value"

   For requests with larger amounts of data, you'll
   perhaps find it preferable to instead pass the name
   of a plain text file containing 'key=value' pairs.
   Such files may be formatted in one of two ways:
     Single line format:
       identical to the inline data format shown
       above, but without the need for quotes.

     Multiple line format:
       data1=value
       data2=value
       ...

 output:
   If no type is specified, response data will be
   formatted and echoed to the terminal along with
   the request parameters.
     Valid types are:
       rich = default; formatted, shows request params
       raw  = output unformatted response data only
EOS
;

sub main {
  my ($method, $url, $content, $format) = @ARGV;

  $method  ||=  0;
  $url     ||=  0;
  $content ||= '';
  $format  ||=  0;

  die $help_text
    if ($method eq 0 || $url eq 0);

  if ($content eq 'rich' || $content eq 'raw') {
    $format  = $content;
    $content = '';
  } elsif ($content && index($content, '=') < 0) {
    local $/ = undef; # Slurp the whole file.
    open (my $file, "<", $content)
      or die "Can't open $content: $!";
    $content = <$file>;
    $content =~ s/(\r)?\n/&/g;
  }

  my $ua       = LWP::UserAgent->new;
  my $request  = &$method($url, Content => $content);
  my $response = $ua->request($request)->content();

  if (!$format || $format eq 'rich') {
    # Display request
    print "\n method:   ", CYAN  $request->method();
    print "\n url:      ", BLUE  $request->url();
    print "\n data:     ", WHITE $request->content()
      if ($request->content());

    # Format JSON responses
    $response =~ s/{/{\n  /g;
    $response =~ s/,/,\n  /g;
    $response =~ s/}/\n } /g;

    # Format XML responses
    $response =~ s/<(?!\/|\?)/\n   </g;
    $response =~ s/></>\n</g;

    # Format PHP responses
    $response =~ s/;(?!\Z)/;\n  /g;

    # Display response
    print BOLD  "\n\n Response";
    print WHITE "\n $response\n";
  } elsif ($format && $format eq 'raw') {
    print $response;
  }
}

main();
exit 0;