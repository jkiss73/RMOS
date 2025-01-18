# e**X**treme **T**erminal **C**ommunication for 8 bit retro computers
 
My first home computer was a Commodore 64 and when it came to programming it I was basically self taught. I was 12 with no access to online forums or local clubs, the 1980s was not as connected as we are today.  Books and magazines were limited to me so word of mouth through friends and school mates plus trial and error was all I had. However the doors really kicked open when I got a 300 baud modem for Christmas in 1986.   

Four decades later I aked myself a question. "If I knew then what I know now what would I do?"

# Project Goals

1. Develop a communication system to interface with today's world.
2. Create a multi-tasking operating system.
3. Separate releases as re-useable modules.
4. Supports several 65xx based computers.
5. Teach about the good old days of 8 bit home computers.                 

Q. Who are the target users for this software.   
A. Retro 8-bit computer enthusiasts, old and new.   

## Develop a communication system to interface with today's world
 
*Lets get real!*. These 8-bit retro computers primarily had serial interfaces to access the outside world and XTC will be limited to this perhipheral type. Over long distances modems, 300/1200 baud, was the only way to connect with each other and the primary reason was to to "share" ;) files. **Bullentin Board Systems** (BBS) was the best way to automate the hosting end but at the end of the day these were only single user access. I will never forget dialing over and over again and getting nothing but the dreaded "busy tone". Supporting a multi-user access system is a worthy goal.  

I don't envision the final solution as hosting a simple HTTP server. This has probably already been done and doesn't add anything special to honor these 8-bit work horses. Text and Command Line Interfaces (CLI) was the only interface unless you were lucky enough to have something like GEOS. Unless you are in IT, especially engaged with server management, CLI is a foreign concept and most users will shy away from it. However these machines were built with text in mind and should stick with and is acceptable since the target users are other 8-bit retro enthusiasts. To truely interface to todays "text" world supporting Standard ASCII is a must and potentially leaving behind CBM ASCII, aka PETSCII, and any other proprietary character set.

## Create a multi-tasking operating system

Wouldn't it be cool to save a file while processing the next incomming connection?

The 65xx processor is capable in supporting multi-tasking with the resoltuion of the context switch dependant on the main system interrupt. A challenge will be in managing the stack for rentrant code. Note, the 65xx does not have a Memory Management Unit (MMU) meaning all applications including the operating system will be under a flat memory model. This means application will have to ensure they stay within it's own execution memory segment.  To support multi-tasking all OS system calls (SYSCALLS) will need to be protected against multiple entries.       

Including a kernel timer subsystem with a callback to the application on expiry would be a worthy feature and resolution will be dependant on the main system interrupt.    

## Separate releases as re-useable modules
**Under Construction**

## Supports several 65xx based computers
**Under Construction**

## Teach about the good old days of 8 bit home computers
**Under Construction**
Imagine a world where you bought your computer and never had to upgrade the operating system again. It used to be like that. 

# Development Roadmap
**Under Construction**

# Development Tools and Hosts

*Compiler Toolchain* - **CC65 & GNU Make**
*Emulator* : **VICE**

*Not necessary but ***C64 Studio*** is a great tool to assist debugging bits of assembly code*  

Host development system: MS-Windows (10/11) , comming soon Linux (Ubuntu)  

# How to build

Currently only the C64 is supported. 

## Windows 10/11

### Building
Install the toolchain, add the directory to your   
Checkout the code
Change directory to the project and go into the "kernel" folder.
Type make. 

### Execute on VICE 
GTK3VICE-3.8-win64\bin\x64sc.exe -kernal kernel.bin

### Execute on Target


utilizing as much of the computers resources and
