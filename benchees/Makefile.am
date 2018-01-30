SUBDIRS = acml arprec bloodworth burrus cross cwplib dfftpack dsp dxml	\
emayer esrfft essl ffte fftpack fftreal fftw2 fftw3 glassman	\
goedecker gpfa gsl harm imsl intel-mkl intel-ipps jmfft	\
kissfft krukar mfft mixfft monnier morris mpfun77 mpfun90 nag napack	\
nr numutils ooura qft ransom rmayer sciport sgimath singleton sorensen	\
spiral-fft statlib sunperf temperton teneyck vbigdsp vdsp

EXTRA_DIST = Makefile.common

distclean-local:
	rm -f *.info *.speed *.accuracy *.sysinfo

# this is a hack
RECURSIVE_TARGETS =
RECURSIVE_TARGETS += benchmark-recursive accuracy-recursive fftinfo-recursive
benchmark: benchmark-recursive
benchmark-am:
accuracy: accuracy-recursive
accuracy-am:
fftinfo: fftinfo-recursive
fftinfo-am:


