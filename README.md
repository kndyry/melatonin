<<<<<<< HEAD
#Melatonin

=======
>>>>>>> a1eb054ed3e2d93204671e8c16bccc34c52a6ae3
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