# Llamatron:2112 by Jeff Minter

This is the 'rude' version of Llamatron by Jeff Minter.


## To Just Play It

### Install the Hatari emulator
```sh
sudo apt install hatari
```

### Play the Game

```sh
hatari --tos utils/etos1024k.img --machine ste --memsize 14 --cpuclock 32 llamatron.prg 
```

## To Build the Sources

### Build the assembler toolchain

First clone this repository:

```sh
git clone https://github.com/mwenge/llamatron.git
```
Next run the following commands to enter the repository and downoad the assembler toolchain:

```sh
cd llamatron
git clone http://tiddly.mooo.com:5000/rmac/rmac.git
```

Now you can build the toolchain, as follows:

```sh
cd rmac
make
cd ..
```

### Build the game

To compile and run it do:

```sh
$ make run
```

To just compile the game and get a binary (`llamatron.prg`) do:

```sh
$ make 
```

## Notes on the Sources

Jeff Minter [released the
sources](https://toot.wales/@llamasoft_ox/112091038601382684), but not the
assets, for Llamatron so I've had to extract them from [a binary of 'rude'
Llamatron](orig/FILTH.PRG) that is still in circulation but not widely available.
The first step [was to decompress this binary](utils/Unpack FILTH.prg.ipynb) so that we can get
at [the raw data](orig/rude_llamatron.prg). 

File | Source | Description |
 --- | --- | --- |
[LLATRON.S](src/LLATRON.s) | [LLATRON.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/LLATRON.s) | Main Game 6502 assembler source code |
[SASONIX.S](src/SASONIX.s) | [SASONIX.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/SASONIX.s) | Customized sound driver |
[SINE.IMG](src/SINE.IMG) | [SINE.IMG](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/SINE.IMG) | SINE Table |
[TENTACLE.S](src/TENTACLE.S) | [TENTACLE.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/TENTACLE.S) | Pause Mode |
[fonte.s](src/fonte.s) | [Reworked](src/utils/Recreate fonte.s.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Font Sprites |
[sonix2.spl](src/sonix2.spl) |[Extracted](utils/Extract Assets.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Sound Samples |
[yakky2.neo](src/yakky2.neo) |[Extracted](utils/Extract Assets.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Splash Screen Graphic |

It was necessary to tweak the sources in order to assemble with `rmac`, these changes are visible in the [commit history](https://github.com/mwenge/llamatron/commits/master/).

It's possible to [extract the sound samples](utils/Extract Sound Samples.ipynb) and play them as [wav files](utils/samples).

## Thanks

@gingerbeardman for pointing me to [the sources](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents) and a copy of the [rude binaries](orig/).
