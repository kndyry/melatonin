#Melatonin

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