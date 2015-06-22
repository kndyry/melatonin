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
use HTTP::Request::Common;
use Term::ANSIColor qw(:constants);
   $Term::ANSIColor::AUTORESET = 1;

my $help_text = <<EOS
  Run this as:
    'perl melatonin.pl method url data'

  where:
    method = an HTTP verb; i.e. GET, POST, PUT
    url    = where to send the request
    data   = inline data or a filename

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
EOS
;

sub main {
  my ($method, $url, $content) = @ARGV;

  $method  ||= 0;
  $url     ||= 0;
  $content ||= 0;

  die $help_text
    if ($method eq 0 || $url eq 0 || $content eq 0);

  if (index($content, '=') < 0) {
    local $/ = undef; # Slurp the whole file.
    open (my $file, "<", $content)
      or die "Can't open $content: $!";
    $content = <$file>;
    $content =~ s/(\r)?\n/&/g;
  }

  my $ua       = LWP::UserAgent->new;
  my $request  = &$method($url, Content => $content);
  my $response = $ua->request($request)->content();

  # Display request
  print "\n method:   ", CYAN  $request->method();
  print "\n url:      ", BLUE  $request->url();
  print "\n data:     ", WHITE $request->content();

  # Assuming a JSON response, format it.
  $response =~ s/{/{\n  /g;
  $response =~ s/,/,\n  /g;
  $response =~ s/}/\n } /g;

  # Display response
  print BOLD  "\n\n Response";
  print WHITE "\n $response\n";
}

main();
exit 0;