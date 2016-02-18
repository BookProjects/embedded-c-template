#Compiler Directives
PROG=bin # Name of generated code
CC=gcc # TODO: change to arm-elf-gcc
CFLAGS= -g -c -Wall

MAPFILE=$(PROG).map
LD=gcc # TODO: change to arm-elf-ld
LDFLAGS=-g # -Wl -Map $(MAPFILE)
STRIP=strip # TODO: change to arm-elf-strip

LIBS=
#Directories
IDIR=include
LDIR=lib
ODIR=obj

#Paths
INCLUDE_PATHS= -I$(IDIR)

BINFILE=$(addsuffix .exe,$(PROG))
BINFILE_DBG=$(addsuffix .dbg,$(PROG))
_SRC= main.c
SRC=$(patsubst %,$(LDIR)/%,$(_SRC))
_OBJ=$(_SRC:.c=.o)
OBJ=$(patsubst %,$(ODIR)/%,$(_OBJ))
_DEPS=main.h
DEPS=$(patsubst %,$(IDIR)/%,$(_DEPS))

ifdef VERBOSE
        Q =
        E = @true 
else
        Q = @
        E = @echo 
endif

.PHONY: all lint test help clean

all: $(BINFILE)
help:
	$(E)
	$(E)all			create executable
	$(E)lint        syntax check all source and header files
	$(E)clean		remove object files and executables
	$(E)help		show this display
	$(E)

$(ODIR)/%.o: $(LDIR)/%.c $(DEPS)
	$(E)C-compiling $<
	$(Q)if [ ! -d `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDE_PATHS)

$(BINFILE_DBG):	$(OBJ) $(DEPS)
	$(E)Linking $@
	$(Q)$(LD) $(LDFLAGS) -o $@ $(INCLUDE_PATHS) $^ $(LIBS)

$(BINFILE): $(BINFILE_DBG)
	$(E) Stripping $^
	$(Q) $(STRIP) --remove-section=.comment $^ -o $@

lint: $(SRC) $(DEPS)
	$(E) Linting $^
	$(Q) splint $^

clean:
	$(E)Removing Files
	$(Q)rm -f $(ODIR)/*.o $(BINFILE) $(BINFILE_DBG)
	$(Q)if [ -d $(ODIR) ]; then rmdir $(ODIR); fi
