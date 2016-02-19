#Compiler Directives
# Name of generated code
PROG=bin
ifndef CC_PATH
$(error "CC_PATH not set, can't find cross compiler")
endif
# Prefix to compiler tools
CC_TYPE=arm-none-eabi
CC=$(CC_PATH)/$(CC_TYPE)-gcc
CFLAGS=-g -c -Wall

MAPFILE=$(PROG).map
LD=$(CC)  # Use compiler to link
LDFLAGS=-g -Wl,-Map=$(MAPFILE) --specs=nosys.specs
STRIP=$(CC_PATH)/$(CC_TYPE)-strip

LIBS=
#Directories
IDIR=include
LDIR=lib
ODIR=obj

TIDIR=test_include
TDIR=tests

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

# Test Variables

TCC=gcc
TCFLAGS=-g -c -Wall
TLD=gcc
TLDFLAGS=-g
TBINFILE=test.exe
_TSRC= main_test.c
TSRC=$(patsubst %,$(TDIR)/%,$(_TSRC))
_TOBJ=$(_TSRC:.c=.o)
TOBJ=$(patsubst %,$(ODIR)/%,$(_TOBJ))
_TDEPS=main_test.h
TDEPS=$(patsubst %,$(TIDIR)/%,$(_TDEPS))

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
	$(E)test        run local tests with non-cross compiler
	$(E)clean		remove object files and executables
	$(E)help		show this display
	$(E)

# Cross-compiling

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

# Testing
#
$(ODIR)/%.o: $(TDIR)/%.c $(TDEPS)
	$(E)C-compiling $<
	$(Q)if [ ! -d `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(Q)$(TCC) -o $@ -c $< $(TCFLAGS) $(INCLUDE_PATHS)

$(TBINFILE): $(TOBJ)
	$(E)Linking $@
	$(Q)$(TLD) $(TLDFLAGS) -o $@ $(INCLUDE_PATHS) $^ $(LIBS)

test: $(TBINFILE)
	$(Q)./$(TBINFILE)

lint: $(SRC) $(DEPS)
	$(E) Linting $^
	$(Q) splint $^

clean:
	$(E)Removing Files
	$(Q)rm -f $(ODIR)/*.o $(BINFILE) $(BINFILE_DBG) $(MAPFILE)
	$(Q)rm -f $(TBINFILE)
	$(Q)if [ -d $(ODIR) ]; then rmdir $(ODIR); fi
