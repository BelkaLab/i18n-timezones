import sys

if __name__ == '__main__':
    print 'Reading pg_timezone file'

    pg_file = 'pg_timezone'
    pg_file_output = 'pg_timezone_ouput'
    output = open(pg_file_output, 'w')
    lines = open(pg_file).read().split('\n')

    output.write('''
                     <?xml version="1.0"?>
                        <xliff version="1.2" xmlns="urn:oasis:names:tc:xliff:document:1.2">
                            <file source-language="it-IT" datatype="plaintext" original="file.ext">
                                <body>
                 ''')

    for line in lines:
        line = line[1:-1]
        output.write('''<trans-unit id="timezone_{}">
                            <source>{}</source>
                            <target>{}</target>
                            </trans-unit>
                    '''.format(line, line, line))

    output.write('''
                                </body>
                             </file>
                     </xliff>
                 ''')
    output.close()
