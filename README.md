# embedded-c-template

Initial setup for compiling, loading, linking, uploading and debugging embedded programs

## Embedded Toolchain

### Cross Compilers

If you look at the [Makefile](/Makefile), you can see the `CC` variable get set,
this will be set to a particular cross-compiler, the `LD` variable will often
get set to the same compiler since most compilers allow linking as well. This
section highlights different cross compilers that are available, what they are
for, and how to install them.

* [GCC ARM Embedded](https://launchpad.net/gcc-arm-embedded), aka
  `gcc-arm-none-eabi`. This is a "GNU toolchain with a GCC source branch
   targeted at Embedded ARM processors. I first heard of it when trying to setup
   a [STM32F4 Discovery Board](http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/PF252419), I found
   a very helpful [article about setting it up](https://liviube.wordpress.com/2013/04/22/blink-for-stm32f4-discovery-board-on-linux-with-makefile/)
   that showed me how to install it and also informed me of
   [stlink](https://github.com/texane/stlink) which I discuss in the [Flashing &
   Debugging Tools](#flashing--debugging-tools) section.

### Flashing & Debugging Tools
* [stlink](https://github.com/texane/stlink) contains st-util to use gdb on the
  Discovery, and st-flash to write / read the flash memory on the Discovery.
