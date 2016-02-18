#Compiler Directives
PROG=prog # Name of generated code
CC=gcc # TODO: change to arm-elf-gcc
CFLAGS= -g -c -Wall

MAPFILE= $(PROG).map
LD=gcc # TODO: change to arm-elf-ld
LDFLAGS= -g -Wl -Map $(MAPFILE)
STRIP=strip # TODO: change to arm-elf-strip

LIBS=
#Directories
IDIR=include
LDIR=lib
ODIR=obj

#Paths
INCLUDE_PATHS= -I$(IDIR)

BINFILE= $(PROG).exe
BINFILE_DBG= $(PROG).dbg
SRC= main.c
_OBJ=$(SRC:.c=.o)
OBJ=$(patsubst %,$(ODIR)/%,$(_OBJ))
_DEPS= main.h
DEPS=$(patsubst %,$(IDIR)/%,$(_DEPS)) $(GEN_DEPS)

ifdef VERBOSE
        Q =
        E = @true 
else
        Q = @
        E = @echo 
endif

.PHONY: all help clean nuke generate test

all: $(BINFILE)
help:
	$(E)
	$(E)all			create executable
	$(E)clean		remove object files and executables
	$(E)help		show this display
	$(E)

$(ODIR)/%.o: $(LDIR)/%.cpp $(DEPS)
	$(E)C-compiling $<
	$(Q)if [ ! -d `dirname $@` ]; then mkdir -p `dirname $@`; fi
	$(Q)$(CC) -o $@ -c $< $(CFLAGS) $(INCLUDE_PATHS)

$(BINFILE_DBG):	$(OBJ) $(DEPS)
	$(E)Linking $@
	$(Q)$(LD) $(LDFLAGS) -o $@ $(INCLUDE_PATHS) $^ $(LIBS)

$(BINFILE): $(BINFILE_DBG)
	$(E) Stripping $^
	$(Q) $(STRIP) --remove-section=.comment $^ -o $@

clean:
	$(E)Removing Files
	$(Q)rm -f $(ODIR)/*.o $(BINFILE) $(BINFILE_DBG)
	$(Q)if [ -d $(ODIR) ]; then rmdir $(ODIR); fi
