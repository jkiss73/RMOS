# e**X**treme **T**erminal **C**ommunication for 8 bit retro computers
 
**Table of Contents**\
[Project Status](#Project-Status)\
[Project Goals](#Project-Goals)\
[License](#License)\
[Development Roadmap](#Development-Roadmap)\
[Highlevel Design](#Highlevel-Design)\
[Development Tools](#Development-Tools)\
[Building and Executing](#Building-and-Executing)\
[Resources](#Resources)


# Project Status

**Under Construction**

# Project Overview

My first home computer was a Commodore 64 and when it came to programming I was basically self taught. I was 12 with no access to online forums or local clubs, the 1980s was not as connected as we are today.  Books and magazines were limited to me so word of mouth through friends and school mates plus trial and error was all I had. However the doors really kicked open when I got a 300 baud modem for Christmas in 1986.   

Four decades later I aked myself a question. "If I knew then what I know now what would I do?"

# Project Goals

1. Develop a communication system.
2. Create a multi-tasking operating system.
3. Separate releases as re-useable modules.
4. Supports several 65xx based computers.
5. Teach about the good old days of 8 bit home computers.                 

Q. Who are the target users for this software.   
A. Retro 8-bit computer enthusiasts, old and new.   

## Develop a communication system
 
*Lets get real!*. These 8-bit retro computers primarily had serial interfaces to access the outside world and XTC will be limited to this perhipheral type. Over long distances modems, 300/1200 baud, was the only way to connect with each other and the primary reason was to "share" ;) files. **Bullentin Board Systems** (BBS) was the best way to automate the hosting end but at the end of the day these were only single user access systems. I will never forget dialing my favorite BBS over and over again for hours and getting nothing but the dreaded "busy tone". Supporting a multi-user access system is a worthy goal for this project.  

I don't envision the final solution as hosting a simple HTTP or FTP server. This has probably already been done and doesn't add anything special to honor these 8-bit work horses. Command Line Interfaces (CLI) was the only way to interact except if you were lucky enough to have something like GEOS. Unless you are in IT, especially engaged with server management, CLI is a foreign concept to most users. However these machines were built with text in mind and should stick to it. This is acceptable since this project's target users are other 8-bit retro enthusiasts. Also, to interface to non Commodore computers we should leave behind the CBM ASCII, aka PETSCII, and any other proprietary character and use Standard ASCII.

## Create a multi-tasking operating system

Wouldn't it be cool to save a file while processing the next incoming connection?

The 65xx processor and if the soltuion is coded corrected will support multi-tasking with context switch resolution dependant on the main system interrupt. A challenge will be managing the tasks stack for for rentrant code on the available 255 bytes. Note, the 65xx does not have a Memory Management Unit (MMU) meaning all applications including the operating system will be under a flat unprotected memory model. This means application will have to ensure they stay within it's own execution memory segment.  To support multi-tasking all OS system calls (SYSCALLS) will need to be protected against multiple entries.       

Including a kernel timer subsystem with a callback to applications on expiry would be another worthy feature. Timer resolution will be dependant on the main system interrupt which is roughly 16ms.     

## Separate releases as re-useable modules
**Under Construction**

## Supports several 65xx based computers
**Under Construction**

## Teach about the good old days of 8 bit home computers
**Under Construction**
Imagine a computer where you never had to upgrade the operating system again. It used to be like that. 

# License
The license for this project is the BSD 3-clause license. See the LICENSE file in the projects root directory.

Sticking to one of the goals for this project is to teach those that want to learn about these amazing machines from the 1980s. Nobody is going to get rich on releaseing new software for a 40+ years old 8-bit personal computer. Learn and just have fun!

# Development Roadmap
**Under Construction**

# Highlevel Design
**Under Construction**


# Development Tools
*Compiler Toolchain* - **CC65 & GNU Make**
*Emulator* : **VICE**

*Not necessary but ***C64 Studio*** is a great tool to assist debugging bits of assembly code*  

Host development system: MS-Windows (10/11) , comming soon Linux (Ubuntu)  

# Building and Executing


## How to build

Currently only the C64 is supported. 

## Windows 10/11

### Building
Install the toolchain, add the directory to your   
Checkout the code
Change directory to the project and go into the "kernel" folder.
Type make. 

### Execute on VICE 
GTK3VICE-3.8-win64\bin\x64sc.exe -kernal kernel.bin

## Execute on Target

# Resources
**Under Construction**

