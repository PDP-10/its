/*
 *	C TTY Package
 *
 *	routines:
 *
 *	tyiopn		- open TTY input channel
 *	tyi		- read char from TTY (buffered)
 *	utyi		- read char from TTY (unbuffered)
 *	get_buf		- read string from TTY
 *	setprompt	- set default TYI prompt string
 *	tyoopn		- open TTY output channel
 *	tyo		- output char to TTY (buffered)
 *	utyo		- output char to TTY (unbuffered)
 *	spctty		- output display code (unbuffered)
 *	tyos		- output string to TTY (buffered)
 *	tyo_flush	- flush TTY output buffer
 *
 *	global variables:
 *
 *	ttynp		- ^L handler
 *
 *	internal routines:
 *
 *	ttyih		- TTY interrupt handler
 *	ctrlch		- return display width of char
 *
 */

# include "c.defs"

# define tty_input_buffer_size 120
# define tty_output_buffer_size 60

# rename tty_input_channel "TYICHN"
# rename tty_output_channel "TYOCHN"
# rename tty_device_code "TTYDEV"
# rename tty_input_buffer "TYIBUF"
# rename tty_input_ptr "TYIPTR"
# rename tty_input_count "TYICNT"
# rename tty_output_buffer "TYOBUF"
# rename tty_output_ptr "TYOPTR"
# rename tty_output_count "TYOCNT"
# rename tty_output_bptr "TYOBPT"
# rename tty_default_prompt "TTYDPR"

int	tty_input_channel -1;
int	tty_output_channel -1;
int	tty_device_code -1;
char	tty_input_buffer[tty_input_buffer_size];
char	*tty_input_ptr;
int	tty_input_count;
char	tty_output_buffer[tty_output_buffer_size];
char	*tty_output_ptr {tty_output_buffer};
int	tty_output_count;
int	tty_output_bptr;
char	*tty_default_prompt;

int	ttxnp();		/* default TTY ^L handler */
int	(*ttynp)() {ttxnp};	/* called on ^L */

/**********************************************************************

	TYI - Read Character From TTY (buffered)

**********************************************************************/

tyi ()

	{while (tty_input_count <= 0)
		{if (tty_input_channel < 0) tyiopn ();
		tty_input_count = get_buf (tty_input_buffer,
			tty_input_buffer_size, '\r', "");
		tty_input_ptr = tty_input_buffer;
		if (tty_input_count == 0) return (0);
		}
	--tty_input_count;
	return (*tty_input_ptr++);
	}

/**********************************************************************

	UTYO - output character to TTY (unbuffered)

**********************************************************************/

utyo (c)

	{if (tty_output_channel >= 0 || tyoopn() >= 0)
		{if (tty_output_count > 0) tyo_flush ();
		c =& 0177;
		if (c != 16) uoiot (tty_output_channel, c);
		else
			{uoiot (tty_output_channel, '^');
			uoiot (tty_output_channel, 'P');
			}
		}
	}

/**********************************************************************

	TYO - output character to TTY

**********************************************************************/

tyo (c)

	{c =& 0177;

	if (tty_output_channel >= 0 || tyoopn() >= 0)
		{if (c != 16) {*tty_output_ptr++ = c; ++tty_output_count;}
		else
			{*tty_output_ptr++ = '^';
			*tty_output_ptr++ = 'P';
			tty_output_count =+ 2;
			}
		if (c=='\r' || tty_output_count >= tty_output_buffer_size-2)
			tyo_flush ();
		}
	}

/**********************************************************************

	TYO_FLUSH - flush TTY output buffer

**********************************************************************/

tyo_flush ()

	{if (tty_output_channel >= 0 && tty_output_count > 0)
		{siot (tty_output_channel, tty_output_bptr,
			tty_output_count);
		tty_output_ptr = tty_output_buffer;
		tty_output_count = 0;
		}
	}

/**********************************************************************

	TYOS - Output String to TTY

**********************************************************************/

tyos (s) char s[];

	{int c;

	while (c = *s++) tyo (c=='\n' ? '\r' : c);
	}

/**********************************************************************

	SPCTTY - Send "special" display control character to TTY.

**********************************************************************/

spctty (c)

	{if (tty_output_channel >= 0 || tyoopn() >= 0)
		{if (tty_output_count > 0) tyo_flush ();
		uoiot (tty_output_channel, 16);
		uoiot (tty_output_channel, c);
		}
	}

/**********************************************************************

	UTYI - read character from TTY (unbuffered and unechoed)

**********************************************************************/

int utyi ()

	{if (tty_input_channel<0) tyiopn ();
	if (tty_output_count > 0) tyo_flush ();
	return (uiiot (tty_input_channel));
	}

/**********************************************************************

	GET_BUF - Read characters from TTY until end-of-file
		simulated or given break character seen.
		Read characters into given buffer, including
		the terminating break character (if any).
		Return a count of the number of characters
		placed in the buffer.  The given prompt string
		will be printed first; it will be reprinted
		when ^L is typed.

**********************************************************************/

int get_buf (buf, buf_size, break_ch, prompt)	char buf[], prompt[];

	{char *p, *q, pbuf[tty_output_buffer_size];
	int i, c, j;

	if (tty_input_channel<0) tyiopn ();
	if (!prompt[0])	/* no explicit prompt */
		{if (tty_output_count > 0) /* use partial output line */
			{tty_output_buffer[tty_output_count] = 0;
			stcpy (tty_output_buffer, pbuf);
			prompt = pbuf;
			}
		else if (tty_default_prompt)	/* use default */
			prompt = tty_default_prompt;
		}
	if (prompt != pbuf) tyos (prompt);
	if (tty_output_count > 0) tyo_flush ();
	p = buf;
	i = 0;	/* number of chars in buffer */

	while (TRUE)
		{c = uiiot (tty_input_channel);
		if (c != break_ch) switch (c) {

case 0177:	/* rubout - delete prev char */

		if (i>0)
			{c = *--p;
			--i;
			if (tty_device_code==2)	/* display */
				{if (c=='\r')
					{spctty ('U');
					q = p;
					while ((c = *--q) != '\r' &&
							q>=buf)
						{j = ctrlch(c);
						while (--j>=0) spctty ('F');	
						}
					if (q<buf)
						{q = prompt;
						while (*q) ++q;
						while ((c = *--q) != '\n' &&
							q>=prompt)
							{j = ctrlch(c);
							while (--j>=0) spctty ('F');
							}
						}
					}
				else
					{j = ctrlch(c);
					while (--j>=0) spctty ('X');
					}
				}
			else utyo (c);
			}
		continue;

case '\p':	/* redisplay buffer */

		*p = 0;
		(*ttynp) (tty_device_code==2, prompt, buf);
		continue;

case 0:		/* simulate end-of-file */

		q = buf;
		while (q < p) {if (*q == '\r') *q = '\n'; ++q;}
		return (i);

case '\n':	/* ignore - dont want to echo it */

		continue;

default:	if (i <= buf_size - 2)
			{++i;
			utyo (*p++ = c);
			}
		else utyo (07);	/* beep */
		continue;
		}

		break;
		}

	utyo ('\r');
	*p++ = c;
	q = buf;
	while (q < p) {if (*q == '\r') *q = '\n'; ++q;}
	return (i+1);
	}

/**********************************************************************

	TTXNP - Default TTY ^L handler

**********************************************************************/

ttxnp (display, prompt, buf)
	int display;
	char *prompt, *buf;

	{if (display) spctty ('C'); else tyo ('\r');
	tyos (prompt);
	tyos (buf);
	tyo_flush ();
	}

/**********************************************************************

	TTYIH - TTY Input Interrupt Handler

**********************************************************************/

ttyih ()

	{int c;

	c = ityic (tty_input_channel);
	if (c == 023) signal (ctrls_interrupt);
	else if (c == 007) signal (ctrlg_interrupt);
	}

/**********************************************************************

	TYIOPN - Open TTY for INPUT.

**********************************************************************/

channel tyiopn()

	{int block[3];
	if (tty_input_channel < 0)
		tty_input_channel = fopen ("/tty", 0);
	on (ttyi_interrupt, ttyih);
	ttyget (tty_input_channel, block);
	block[0] = 020202020202;
	block[1] = 030202020202;
	ttyset (tty_input_channel, block);
	tty_device_code = status (tty_input_channel) & 077;
	return (tty_input_channel);
	}

/**********************************************************************

	TYOOPN - Open TTY for OUTPUT.

**********************************************************************/

channel tyoopn()

	{int i;
	if (tty_output_channel < 0)
		{tty_output_channel = fopen ("/tty", 021);
		i = tty_output_buffer;
		i =| 0444400000000;
		tty_output_bptr = i;
		}
	return (tty_output_channel);
	}

/**********************************************************************

	CTRLCH - Return the number of characters a character
	prints as.

**********************************************************************/

int ctrlch (c)

	{if (c==0177) return (2);
	if (c>=' ' || c==033 || c=='\t') return (1);
	if (c=='\b' || c==07) return (0);
	return (2);
	}

/**********************************************************************

	SETPROMPT - Set Default Input Prompt String

**********************************************************************/

setprompt (s)
	char *s;

	{tty_default_prompt = s;}
