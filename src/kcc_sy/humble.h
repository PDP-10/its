/*								-*-C-*-
 *	HUMBLE header file
 */

extern int j_create(), j_kill();
extern int j_read(), j_write();
extern int j_dump(), j_load();
extern int j_vread(), j_vwrite();
extern int j_atty(), j_dtty();

#define SIXBIT(name) (* ((int *) ((_KCCtype_char6 *) name)))
