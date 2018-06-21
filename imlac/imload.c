#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <Windows32/Base.h>
#include <Windows32/Defines.h>
#include <Windows32/Structures.h>
#include <Windows32/Functions.h>

typedef enum { False, True } Bool;

#define	RCV_TIMEOUT		200	// in milli-seconds (XXX)
#define	SERIAL_TIMEOUT		-2
#define	BUF_SIZE		512
#define	DEFAULT_BAUDRATE	9600
#define	WIN95_DEFAULT_BAUDRATE	CBR_9600

#define	MAX_PORTS	4
#define	COM_BUF_SZ	1024

#define	WIN95_DEBUG	0

struct com_info {
    HANDLE fd;
    HANDLE mutex;
    volatile DWORD rxbuf_max;
    BYTE rxbuf[COM_BUF_SZ];
    HANDLE th;
} com_ports[MAX_PORTS];

static volatile int waiting = 0;

static void
init_ports()
{
    int i;

    for (i = 0; i < MAX_PORTS; i++)
	com_ports[i].fd = (HANDLE) -1;
}

static int
get_port()
{
    int i;

    for (i = 0; i < MAX_PORTS; i++) {
	if (com_ports[i].fd == (HANDLE) -1) {
	    com_ports[i].fd = 0;
	    return (i);
	}
    }
    return (-1);
}

static void
free_port(int port)
{
    if (port >= 0 && port < MAX_PORTS)
	com_ports[port].fd = (HANDLE) -1;
}

static DWORD
com_rx_thread(void *arg)
{
    DWORD bytes_read = 0;
    LPBYTE new_bytes_posn;
    struct com_info *cip;
    int port;

    port = (int) arg;
    if (port < 0 || port >= MAX_PORTS) {
	printf("com_rx_thread: bad port %d\n", port);
	return (0);
    }
    cip = &com_ports[port];
    while (1) {
	WaitCommEvent(cip->fd, NULL, NULL);

#if WIN95_DEBUG > 0
	if (waiting && cip->rxbuf_max > 0)
	    printf("com_rx_thread() rxbuf_max %d and waiting\n",
		   cip->rxbuf_max);
#endif

	WaitForSingleObject(cip->mutex, INFINITE);
	new_bytes_posn = cip->rxbuf + cip->rxbuf_max;
	if (ReadFile(cip->fd, new_bytes_posn, COM_BUF_SZ - cip->rxbuf_max,
		     &bytes_read, NULL) == TRUE) {
	    if (bytes_read)
		cip->rxbuf_max += bytes_read;
	} else
	    printf("com_rx_thread() ReadFile failed\n");
	ReleaseMutex(cip->mutex);

#if WIN95_DEBUG > 0
	if (bytes_read)
	    printf("com_rx_thread() bytes %d\n", bytes_read);
#endif
    }
}

int
win95_open (const char *name, long baudrate)
{
    struct com_info *cip;
    DCB dcb;
    COMMTIMEOUTS cto;
    DWORD tid;
    int fd;
    static int initialized = 0;

    if (initialized == 0) {
	initialized = 1;
	init_ports();
    }

#if WIN95_DEBUG > 0
    printf("win95_open(%s, %d)\n", name, baudrate);
#endif

    if ((fd = get_port()) < 0) {
	printf("win95_open(%s): all ports in use\n", name);
	return (-1);
    }
    cip = &com_ports[fd];

    /*
     * Claim the specified port.
     */
    cip->fd = CreateFile(name, GENERIC_READ|GENERIC_WRITE, 0, NULL,
			 OPEN_EXISTING, 0, NULL);
    SetCommMask(cip->fd, EV_RXCHAR);

    /*
     * Set the port to 8N1 w/ no timeouts, 9600 baud,
     * and COM_BUF_SZ bytes input/output buffers.
     */
    GetCommState(cip->fd, &dcb);
#if 0
    DWORD DCBlength;
*   DWORD BaudRate;
    DWORD fBinary: 1;
    DWORD fParity: 1;
*   DWORD fOutxCtsFlow:1;
*   DWORD fOutxDsrFlow:1;
*   DWORD fDtrControl:2;
*   DWORD fDsrSensitivity:1;
    DWORD fTXContinueOnXoff:1;
*   DWORD fOutX: 1;
*   DWORD fInX: 1;
    DWORD fErrorChar: 1;
    DWORD fNull: 1;
*   DWORD fRtsControl:2;
    DWORD fAbortOnError:1;
    DWORD fDummy2:17;
    WORD wReserved;
    WORD XonLim;
    WORD XoffLim;
*   BYTE ByteSize;
*   BYTE Parity;
*   BYTE StopBits;
    char XonChar;
    char XoffChar;         
    char ErrorChar;
    char EofChar;
    char EvtChar;
    WORD wReserved1;
#endif
//XXX    dcb.fBinary = TRUE;

    dcb.BaudRate = (DWORD) baudrate;
    dcb.ByteSize = 8;
    dcb.Parity = NOPARITY;
    dcb.StopBits = ONESTOPBIT;
//    dcb.StopBits = TWOSTOPBITS;
    dcb.fOutxCtsFlow = FALSE;
    dcb.fOutxDsrFlow = FALSE;
    dcb.fDtrControl = DTR_CONTROL_DISABLE;
    dcb.fDsrSensitivity = FALSE;
    dcb.fOutX = FALSE;
    dcb.fInX = FALSE;
    dcb.fRtsControl = RTS_CONTROL_DISABLE;
    SetCommState(cip->fd, &dcb);
    GetCommTimeouts(cip->fd, &cto);
    cto.ReadIntervalTimeout = MAXDWORD;
    cto.ReadTotalTimeoutMultiplier = cto.ReadTotalTimeoutConstant = 0;
    cto.WriteTotalTimeoutMultiplier = cto.WriteTotalTimeoutConstant = 0;
    SetCommTimeouts(cip->fd, &cto);
    SetupComm(cip->fd, COM_BUF_SZ, COM_BUF_SZ);

    /*
     * Set up the comms receive buffer, create a mutex so we can
     * receive from the buffer without getting the background thread
     * bent out of shape and then kick off the background thread that
     * polls the serial port for us and stuffs the receive buffer.
     */
    cip->rxbuf_max = 0;
    cip->mutex = CreateMutex(NULL, FALSE, NULL);
    cip->th = CreateThread(NULL, 0, com_rx_thread, (void *) 0, 0, &tid);

    return (fd);
}

void
win95_close (int fd)
{
    struct com_info *cip;

#if WIN95_DEBUG > 0
    printf("win95_close(%d)\n", fd);
#endif

    if (fd < 0 || fd >= MAX_PORTS)
	return;

    cip = &com_ports[fd];

    WaitForSingleObject(cip->mutex, INFINITE);
    TerminateThread(cip->th, 0);
    ReleaseMutex(cip->mutex);
    WaitForSingleObject(cip->mutex, INFINITE);
    CloseHandle(cip->fd);
    ReleaseMutex(cip->mutex);
    free_port(fd);
}

int
win95_readchar (int fd, BYTE *ch, int timeout)
{
    struct com_info *cip;
    DWORD i;
    int timer;

    cip = &com_ports[fd];

#if WIN95_DEBUG > 0
    if (timeout == -1)
    printf("win95_readchar() timeout %d max %d\n", timeout, cip->rxbuf_max);
#endif

    /*
     * The timeout parameter is as follows:
     *	0  = try once (poll)
     *	>0 = try for timeout milli-seconds
     *  <0 = try forever
     */
    timer = 0;
    while (1) {
	if (cip->rxbuf_max == 0) {
	    waiting = 1;
	    if (timeout == 0) {
#if WIN95_DEBUG > 0
		printf("win95_readchar(): SERIAL_TIMEOUT\n");
#endif
		return (SERIAL_TIMEOUT);
	    }

	    if (timeout > 0 && timer++ >= timeout) {
#if WIN95_DEBUG > 0
		printf("win95_readchar(): SERIAL_TIMEOUT\n");
#endif
		return (SERIAL_TIMEOUT);
	    }

	    Sleep(1);	/* Sleep time is in milli-seconds */
	    continue;
	}

	waiting = 0;
	WaitForSingleObject(cip->mutex, INFINITE);
	if (cip->rxbuf_max == 0) {
	    ReleaseMutex(cip->mutex);
	    continue;	/* this should not happen */
	}

	/*
	 * XXX - this is ugly, but it came from some working code
	 * XXX - and I don't want to mess with it at the moment.
	 */
	*ch = cip->rxbuf[0];
	for (i = 1; i < cip->rxbuf_max; i++)
	    cip->rxbuf[i - 1] = cip->rxbuf[i];
	cip->rxbuf_max--;
	ReleaseMutex(cip->mutex);
	break;
    }

#if WIN95_DEBUG > 0
    printf("win95_readchar(): ch 0x%x\n", ch);
#endif

    return (0);
}

int
win95_write (int fd, const char *str, int len)
{
    struct com_info *cip;
    DWORD chars_written, total_written;

#if WIN95_DEBUG > 0
    printf("win95_write()\n");
#endif

    cip = &com_ports[fd];
    total_written = 0;
    while (len > 0) {
	if (WriteFile(cip->fd, str, len, &chars_written, NULL) == TRUE) {
	    if (chars_written < 0)
		return (total_written);

	    len -= chars_written;
	    str += chars_written;
	    total_written += chars_written;
	} else
	    printf("win95_write() WriteFile failed\n");
    }

    return (total_written);
}

void
win95_flush_input (int fd)
{
    struct com_info *cip;

#if WIN95_DEBUG > 0
    printf("win95_flush_input()\n");
#endif

    cip = &com_ports[fd];

    WaitForSingleObject(cip->mutex, INFINITE);
    cip->rxbuf_max = 0;
    ReleaseMutex(cip->mutex);
}

char *progname;
unsigned char buffer[BUF_SIZE];
extern char *sys_errlist[];

static void
usage()
{
    fprintf(stderr, "usage: %s [-COM2] image\n"
	    "    -?        this help message\n"
	    "    -bBAUD    set the transfer baudrate to BAUD where BAUD is\n"
	    "              one of: 300, 1200, 2400, 4800, or 9600\n"
	    "              (default is 9600 baud)\n"
	    "    -COM2     specifiy the COM2 serial port (COM1 is default)\n"
	    "    -force8   force an 8bit (binary) load\n"
	    "    -info     show file info, do not load\n"
	    "    -pause    pause for CR before each byte\n"
	    "    -type4    send a mazewar type 4 message to the serial port\n"
	    "    -verify   verify each character written\n",
	    progname);
}

static unsigned char type4_msg[] = {
    0x04, 0x01, 0x54, 0x4f, 0x4d, 0x20, 0x20, 0x20, 0x40, 0x40, 0x40, 0x40
};

main (int argc, char *argv[], char *env[])
{
    long win95_baudrate;
    int arg_baudrate, serial_fd, image_fd, rom3_fd, len, i;
    const char *port;
    unsigned short sbuf[100], word;
    unsigned char *image, *cp, c;
    Bool bit4, force8, info, pause, type4, verify;

    if ((cp = (char *) rindex(argv[0], '/')) ||
	(cp = (char *) rindex(argv[0], '\\')))
	progname = cp + 1;
    else
	progname = argv[0];

    if ((cp = (char *) rindex(argv[0], '.')))
	*cp = 0;

    bit4 = False;
    force8 = False;
    info = False;
    pause = False;
    type4 = False;
    verify = False;
    port = "COM1";
    arg_baudrate = DEFAULT_BAUDRATE;
    win95_baudrate = WIN95_DEFAULT_BAUDRATE;

    argv++;
    while (--argc > 0) {
	if ((*argv)[0] != '-' && (*argv)[0] != '/')
	    break;

	switch (c = (*argv)[1]) {
	case '?':
	    usage();
	    exit(0);
	    break;
	case 'b':
	    arg_baudrate = atoi(&(*argv)[2]);
	    switch (arg_baudrate) {
	    case 300:
		win95_baudrate = CBR_300;
		break;
	    case 1200:
		win95_baudrate = CBR_1200;
		break;
	    case 2400:
		win95_baudrate = CBR_2400;
		break;
	    case 4800:
		win95_baudrate = CBR_4800;
		break;
	    case 9600:
		win95_baudrate = CBR_9600;
		break;
	    default:
		fprintf(stderr,
			"%s: baudrate (%d) should be <300 | 1200 | 2400 | "
			"4800 | 9600>\n", progname, arg_baudrate);
		usage();
		exit(1);
	    }
	    break;
	case 'c':
	case 'C':
	    if (strcmp(&(*argv)[2], "om2") == 0 ||
		strcmp(&(*argv)[2], "OM2") == 0) {
		port = "COM2";
	    } else {
		usage();
		exit(1);
	    }
	    break;
	case 'f':
	    if (strcmp(&(*argv)[2], "orce8") == 0) {
		force8 = True;
	    } else {
		usage();
		exit(1);
	    }
	    break;
	case 'i':
	    if (strcmp(&(*argv)[2], "nfo") == 0) {
		info = True;
	    } else {
		usage();
		exit(1);
	    }
	    break;
	case 'p':
	    if (strcmp(&(*argv)[2], "ause") == 0) {
		pause = True;
	    } else {
		usage();
		exit(1);
	    }
	    break;
	case 't':
	    if (strcmp(&(*argv)[2], "ype4") == 0) {
		type4 = True;
	    } else {
		usage();
		exit(1);
	    }
	    break;
	case 'v':
	    if (strcmp(&(*argv)[2], "erify") == 0) {
		verify = True;
	    } else {
		usage();
		exit(1);
	    }
	    break;
	default:
	    fprintf(stderr, "%s: invalid option '%s'\n", progname, *argv);
	    usage();
	    exit(1);
	}
	argv++;
    }

    if (argc != 1) {
	usage();
	exit(1);
    }
    image = *argv;

    /*
     * Open the image file, read a few bytes, and rewind the fd.
     */
    if ((image_fd = open(image, O_RDONLY | O_BINARY)) < 0) {
	fprintf(stderr, "%s: unable to open file (%s) - %s\n",
		progname, image, sys_errlist[errno]);
	exit(1);
    }
    if ((len = read(image_fd, buffer, 10)) <= 0) {
	fprintf(stderr, "%s: unable to read file (%s) - %s\n",
		progname, image, sys_errlist[errno]);
	close(image_fd);
	exit(1);
    }
    if (lseek(image_fd, 0, SEEK_SET) == -1) {
	fprintf(stderr, "%s: unable to lseek file (%s) - %s\n",
		progname, image, sys_errlist[errno]);
	close(image_fd);
	exit(1);
    }

    /*
     * Determine if the image is 4 or 8 bit.
     */
    if (buffer[0] & 0140)		/* 4 bit file */
	bit4 = True;

    if (force8 == True)
	bit4 = False;

    /*
     * Open the serial port at the specified baudrate.
     */
    if (info == False) {
	if ((serial_fd = win95_open(port, win95_baudrate)) < 0) {
	    fprintf(stderr, "%s: unable to open serial port (%s)\n",
		    progname, port);
	    close(image_fd);
	    exit(1);
	}

	printf("Start TTY boot loader and press return when ready...");
	fflush(stdout);
	getchar();

	if (force8 == False) {
	    buffer[0] = '\1';
	    for (i = 0; i < 10; i++) {
		if (verify == False) {
		    word = ((unsigned short) buffer[0] << 8) | buffer[0];
		    if ((i & 1) == 0)
			printf("0%-6.6o  0x%02x 0x%02x\n",
			       word, buffer[0], buffer[0]);
		}

		if (win95_write(serial_fd, buffer, 1) < 0) {
		    fprintf(stderr,
			    "%s: unable to write to serial port (%s)\n",
			    progname, port);
		    close(image_fd);
		    win95_close(serial_fd);
		    exit(1);
		}
		if (pause == True) {
		    printf("Pausing output, press return when ready...");
		    fflush(stdout);
		    getchar();
		}
		if (verify == True) {
		    if (win95_readchar(serial_fd, &c, RCV_TIMEOUT) < 0) {
			fprintf(stderr,
				"%s: unable to read from serial port (%s)\n",
				progname, port);
			close(image_fd);
			win95_close(serial_fd);
			exit(1);
		    }
		    if (c != buffer[0])
			printf(">>> sent 0x%02x got 0x%02x\n", buffer[i], c);
		}
	    }
	}
    }

    /*
     * Determine if the image is 4 or 8 bit.
     */
    if (bit4 == True) {		/* 4 bit file */
	printf("4 bit file:\n");
	if (info == True) {
	    close(image_fd);
	    exit(0);
	}
	if ((rom3_fd = open("rom3", O_RDONLY | O_BINARY)) < 0) {
	    fprintf(stderr, "%s: unable to open file (%s) - %s\n",
		    progname, "rom3", sys_errlist[errno]);
	    close(image_fd);
	    if (info == False)
		win95_close(serial_fd);
	    exit(1);
	}
	printf("Sending rom3\n");
	while ((len = read(rom3_fd, buffer, BUF_SIZE)) > 0) {
	    putchar('.');

	    if (pause == True || verify == True) {
		for (i = 0; i < len; i++) {
		    if (verify == False) {
			word = ((unsigned short) buffer[i] << 8) |
			    buffer[i + 1];
			if ((i & 1) == 0)
			    printf("0%-6.6o  0x%02x 0x%02x\n",
				   word, buffer[i], buffer[i + 1]);
		    }

		    if (win95_write(serial_fd, &buffer[i], 1) < 0) {
			fprintf(stderr,
				"%s: unable to write to serial port (%s)\n",
				progname, port);
			close(rom3_fd);
			close(image_fd);
			win95_close(serial_fd);
			exit(1);
		    }
		    if (pause == True) {
			printf("Pausing output, press return when ready...");
			fflush(stdout);
			getchar();
		    }
		    if (verify == True) {
			if (win95_readchar(serial_fd, &c, RCV_TIMEOUT) < 0) {
			    fprintf(stderr,
				    "%s: unable to read from serial "
				    "port (%s)\n",
				    progname, port);
			    close(rom3_fd);
			    close(image_fd);
			    win95_close(serial_fd);
			    exit(1);
			}
			if (c != buffer[i])
			    printf(">>> sent 0x%02x got 0x%02x\n",
				   buffer[i], c);
		    }
		}
	    } else {
		if (win95_write(serial_fd, buffer, len) < 0) {
		    fprintf(stderr,
			    "%s: unable to write to serial port (%s)\n",
			    progname, port);
		    close(rom3_fd);
		    close(image_fd);
		    win95_close(serial_fd);
		    exit(1);
		}
	    }
	}
	if (len < 0) {
	    fprintf(stderr, "%s: unable to read file (%s) - %s\n",
		    progname, "rom3", sys_errlist[errno]);
	    close(rom3_fd);
	    close(image_fd);
	    win95_close(serial_fd);
	    exit(1);
	}

	putchar('\n');
	close(rom3_fd);
    } else {				/* 8 bit file */
	printf("8 bit file:\n");
	if (info == True) {
	    close(image_fd);
	    exit(0);
	}
    }

    printf("Sending %s\n", image);
    while ((len = read(image_fd, buffer, BUF_SIZE)) > 0) {
	putchar('+');

	if (pause == True || verify == True) {
	    for (i = 0; i < len; i++) {
		if (verify == False) {
		    word = ((unsigned short) buffer[i] << 8) | buffer[i + 1];
		    if ((i & 1) == 0)
			printf("0%-6.6o  0x%02x 0x%02x\n",
			       word, buffer[i], buffer[i + 1]);
		}

		if (win95_write(serial_fd, &buffer[i], 1) < 0) {
		    fprintf(stderr,
			    "%s: unable to write to serial port (%s)\n",
			    progname, port);
		    close(rom3_fd);
		    close(image_fd);
		    win95_close(serial_fd);
		    exit(1);
		}
		if (pause == True) {
		    printf("Pausing output, press return when ready...");
		    fflush(stdout);
		    getchar();
		}
		if (verify == True) {
		    if (win95_readchar(serial_fd, &c, RCV_TIMEOUT) < 0) {
			fprintf(stderr,
				"%s: unable to read from serial port (%s)\n",
				progname, port);
			close(rom3_fd);
			close(image_fd);
			win95_close(serial_fd);
			exit(1);
		    }
		    if (c != buffer[i])
			printf(">>> sent 0x%02x got 0x%02x\n", buffer[i], c);
		}
	    }
	} else {
	    if (win95_write(serial_fd, buffer, len) < 0) {
		fprintf(stderr, "%s: unable to write to serial port (%s)\n",
			progname, port);
		close(rom3_fd);
		close(image_fd);
		win95_close(serial_fd);
		exit(1);
	    }
	}
    }
    if (len < 0) {
	fprintf(stderr, "%s: unable to read file (%s) - %s\n",
		progname, image, sys_errlist[errno]);
	close(image_fd);
	win95_close(serial_fd);
	exit(1);
    }
    putchar('\n');
    fflush(stdout);

    if (type4) {
	printf("Press return to send type 4 message...");
	fflush(stdout);
	getchar();

	if (win95_write(serial_fd, type4_msg, sizeof(type4_msg)) < 0) {
	    fprintf(stderr, "%s: unable to write to serial port (%s)\n",
		    progname, port);
	    close(rom3_fd);
	    close(image_fd);
	    win95_close(serial_fd);
	    exit(1);
	}
    }

    exit(0);
}
