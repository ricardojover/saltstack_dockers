#!/usr/bin/python
# vi: syntax=python ts=4
try:
    import ConfigParser
except ImportError:
    import configparser as ConfigParser
try:
    import StringIO
except ImportError:
    import io as StringIO

import sys
import glob
import os
from jinja2 import Environment, FileSystemLoader, StrictUndefined

partNumber = 0
config = ConfigParser.SafeConfigParser()
errorParsing = False

def substOne(infile,outfile,conf, env):
    try:
        print("Template:  should create {0} from {1}".format(outfile, infile))
        template = env.get_template(infile)
        f = open(outfile, 'w')
        f.write(template.render(dict(conf.items('main'))))
        f.close

    except Exception as e:
        print("FAILED to {0} from {1}".format(outfile,infile))
        print(e)
        return False

    print("Template creation of {0} from {1} worked ok".format(outfile, infile))
    return True

def substAll(config):
    print("Starting sustAll....")
    env = Environment(loader=FileSystemLoader(searchpath="/"), undefined = StrictUndefined, keep_trailing_newline = True)
    generated = []
    for ifile in glob.iglob('/usr/local/etc/templates/*.tmpl'):
        ofile=ifile[:-5]
        generated.append(ofile)
        if not substOne(ifile, ofile, config, env):
            print("Template generation failed; removing previously generated file")
            for f in generated:
                try:
                    os.remove(f)
                except Exception as e:
                    pass
            return False
    print("Ending substAll...")
    return True

def list_types():
    return(["text/x-my-config"])

def handle_part(data,ctype,filename,payload):
    # data: the cloudinit object
    # ctype: '__begin__', '__end__', or the specific mime-type of the part
    # filename: the filename for the part, or dynamically generated part if
    #           no filename is given attribute is present
    # payload: the content of the part (empty for begin or end)
    global partNumber
    global config
    global errorParsing
    if ctype == "__begin__":
       print("x-my-config is beginning")
       return

    if ctype == "__end__":
       print("x-my-config is ending")
       if errorParsing:
           print("errorParsing userdata; doing no work")
       elif partNumber == 0:
           print("No config; doing no work")
       else:
           if substAll(config):
               print("All templates generated OK")
           else:
               print("Errors generating templates")
       return
 
    partNumber = partNumber + 1
    print("parsing config part {0}".format(partNumber))

    if errorParsing:
        print("Error parsing previous userdata; aborting")
        return

    sio = StringIO.StringIO(payload)
    try:
        config.readfp(sio, filename)
    except Exception as e:
        print("Caught exception:")
        print(e)
        print("Abandoning all hope")
        errorParsing = True


if __name__ == "__main__":
    import sys
    handle_part(None, '__begin__', None, '')
    for arg in sys.argv[1:]:
      with open(arg, 'r') as f:
        data = f.read()
        handle_part(None, 'text/x-my-config', arg, data)
    handle_part(None, '__end__', None, '')
