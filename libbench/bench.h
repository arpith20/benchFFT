/*
 * Copyright (c) 2001 Matteo Frigo
 * Copyright (c) 2001 Steven G. Johnson
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 */

/* $Id: bench.h,v 1.14 2003/05/01 10:50:34 athena Exp $ */

/* benchmark program definitions */
#include "config.h"
#include "bench-user.h"

extern double time_min;
extern int time_repeat;
extern int verbose;

extern void timer_init(double tmin, int repeat);
extern void timer_start(void);
extern double timer_stop(void);

/* report functions */
extern void (*report)(const struct problem *p, double *t, int st);

void report_mflops(const struct problem *p, double *t, int st);
void report_time(const struct problem *p, double *t, int st);
void report_benchmark(const struct problem *p, double *t, int st);
void report_verbose(const struct problem *p, double *t, int st);

void report_can_do(const char *param);
void report_info(const char *param);
void report_info_all(void);

extern int bench_main(int argc, char *argv[]);

extern void speed(const char *param);
extern void verify(const char *param, int rounds, double tol);
extern void accuracy(const char *param, int rounds);

extern double mflops(const struct problem *p, double t);

extern double bench_drand(void);
extern void bench_srand(int seed);

struct option; /* opaque */
extern char *make_short_options(const struct option *opt);
extern void usage(const char *progname, const struct option *opt);

extern struct problem *problem_parse(const char *desc);
extern void problem_destroy(struct problem *p);

extern void ovtpvt(const char *format, ...);
