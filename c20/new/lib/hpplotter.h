/* Header file for HPPLOTTER package */

/* This file renames most functions to avoid conflicts */

#define hp_open			_hopn
#define hp_close		_hcls
#define hp_flush		_hfls
#define hp_set_color		_hsec
#define hp_set_page_size	_hsps
#define hp_get_page_size	_hgps
#define hp_set_char_size	_hscc
#define hp_set_char_slant	_hscs
#define hp_set_print_space	_hspp

#define hp_set_solid_line	_hssl
#define	hp_set_dash_line	_hsdl
#define hp_set_dot_line		_hsdd

#define hp_set_scale		_hsca
#define hp_set_offset		_hsof
#define hp_increment_scale	_hisc

#define hp_printc		_hprc
#define hp_prints		_hprs

#define hp_draw_to		_hdr2
#define hp_draw_by		_hdby
#define hp_move_to		_hmo2
#define hp_move_by		_hmby

#define hp_box			_hbox
#define hp_square		_hsqr
#define hp_circle		_hcrc
#define hp_line			_hlin
#define hp_text			_htxt
