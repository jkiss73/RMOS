# ******************************************************************************************************************
# Description: Take a CC65 linker listing and generate assembly or C header header files 
#        from a template file.
#
# Author(s) : John Kiss
#
# Copyright (c) 2026-Present, John Kiss All rights reserved.
# This source code is licensed under the BSD-style license found in the LICENSE file 
# in the root directory of this source tree.
# ******************************************************************************************************************
import sys
from datetime import datetime

SCRIPT_NAME="list2def"
VERSION="0.1"

def show_help():
    print ("-l <file>               Listing file (input)")
    print ("-o <file>               Generated file name (output)")
    print ("-t <file>               Template file (input)")
    print ("-ch                     C header style")
    print ("-sv <version>          RM OS version")
    print ("-kv <version>           RM kernel version")

listing_array = []
listing_filename = "project.lst"
header_filename  = "header.inc"
template_filename  = "api.tpl"
os_version = "0.0.0"
kernel_version = "0.0.0"
c_header_style = False 

if len(sys.argv) > 1:
    a = 1
    while (a < len(sys.argv)):
        match sys.argv[a]:
            case '?':
                show_help()
                sys.exit(1)
            case '-ch':
                c_header_style = True
            case '-l':
                a = a + 1
                if ( a < len(sys.argv)):
                    listing_filename = sys.argv[a]
                else:
                    print ("Missing filename")
                    sys.exit(1)
            case '-o':
                a = a + 1
                if ( a < len(sys.argv)):
                    header_filename = sys.argv[a]
                else:
                    print ("Missing filename")
                    sys.exit(1)
            case '-t':
                a = a + 1
                if ( a < len(sys.argv)):
                    template_filename = sys.argv[a]
                else:
                    print ("Missing filename")
                    sys.exit(1)
            case '-sv':
                a = a + 1
                if ( a < len(sys.argv)):
                    os_version = sys.argv[a]
                else:
                    print ("Missing OS version")
                    sys.exit(1)
            case '-kv':
                a = a + 1
                if ( a < len(sys.argv)):
                    kernel_version = sys.argv[a]
                else:
                    print ("Missing kernel build version")
                    sys.exit(1)
            case _:
                print ("Invalid argument " + sys.argv[a])
                sys.exit(1)

        a = a + 1
else:
    print("Missing arguments - " + sys.argv[0] )
    show_help()
    sys.exit(1)

timestamp = datetime.now()

formatted_time  = timestamp.strftime("%B %d, %Y, %I:%M:%S %p")


with open(header_filename, 'w') as header_file:

    print ("RMOS Listing to Define file generation v" + VERSION)
    print ("RMOS OS : v" + os_version)
    print ("RMOS kernel  : v" + kernel_version)
    print ("Generating " + header_filename)
    print ("from : " + listing_filename)
    print ("using template : " + template_filename)
    print (formatted_time)
    print ("*****************************************************************************************")

    if (c_header_style):
        header_file.write ("/* **************************************************************************************** \n")
        header_file.write ("RMOS Listing to Define file generation v" + VERSION + "\n")
        header_file.write ("RMOS OS v" + os_version + "\n")
        header_file.write ("RMOS kernel v" + kernel_version + "\n")
        header_file.write ("Generating " + header_filename + "\n")
        header_file.write ("from : " + listing_filename + "\n")
        header_file.write ("using template : " + template_filename +"\n")
        header_file.write (formatted_time + "\n")
        header_file.write ("**************************************************************************************** */\n")
    else:
        header_file.write ("; **************************************************************************************** \n")
        header_file.write ("; RMOS Listing to Define file generation v" + VERSION + "\n")
        header_file.write ("; RMOS OS v" + os_version + "\n")
        header_file.write ("; RMOS kernel v" + kernel_version + "\n")
        header_file.write ("; Generating " + header_filename + "\n")
        header_file.write ("; from : " + listing_filename + "\n")
        header_file.write ("; using template :" + template_filename +"\n")
        header_file.write ("; " + formatted_time + "\n")
        header_file.write ("; ****************************************************************************************\n")

    with open(listing_filename, 'r') as listing_file:
        for line in listing_file:
            line = line.strip()
            al,spc,data = line.partition(' ')
            label = data.partition(' ')
            listing_array.append(label)

    with open(template_filename, 'r') as template_file:
        for line in template_file:
            line = line.strip()
            tmpl = line.partition(' ')
        
            if (len(tmpl[0]) > 0) :
                
                found = False

                for l in listing_array:
                    if l[2].strip() == tmpl[2].strip():
                        if (c_header_style):
                            header_file.write("#define " + tmpl[0] + "\t\t".expandtabs(4) + "0x" + l[0][2:] +"\n")
                        else :
                            header_file.write(".define " + tmpl[0] + "\t\t".expandtabs(4) + "$" + l[0][2:]+"\n")
                        found = True
                
                if (found == False):
                    print ("No listing found for " + tmpl[2].strip() + " for define " + tmpl[0].strip())
                    sys.exit(1)
