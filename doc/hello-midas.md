# Hello world in MIDAS

Step by step guide on how to create a hello world in MIDAS.

1. Login.

2. Start EMACS and enter this program.  You can skip the comments.

    ```
    title hello
    
    a==1                                ;Define two accumulators,
    b==2                                ;A and B.
    ch==1                               ;Output chanel number.
    
    start:  .open ch,[.uao,,'tty]       ;Open channel to TTY, for ASCII output.
             .lose
            move a,[440700,,hello]      ;Load A with byte poiter to string.
    loop:   ildb b,a                    ;Load B from string.
            jumpe b,[.logout 2,]        ;End on zero byte.
            .iot ch,b                   ;Print byte.
    	    jrst loop
    
    hello:  asciz /hello world/
    
    end start				  ;Specify entry point.
    ```

3. Save it as `hello 1` (<kbd>^X</kbd><kbd>^S</kbd>) and exit (<kbd>^X</kbd><kbd>^C</kbd>).

4. Assemble it with MIDAS.

       :midas ts hello_hello

5. Go back to EMACS with ◊P if you need to do edits.

6. Run the program.

       :hello
