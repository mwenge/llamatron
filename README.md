# Llamatron:2112 by Jeff Minter
This is the 'rude' version of Llamatron by Jeff Minter for the Atari STE/TT.
It's a variant of the original
[Llamatron](https://en.wikipedia.org/wiki/Llamatron) with some quite explicit
swearing added by Minter and his friends. 'Rude Llamatron' was circulated
privately and on message boards in the early 1990s.

A comment in the [source code](src/LLATRON.S) provides more detail:

```
* (This version of the source was for a crazy TT remix I did
* one weekend when the posse came to visit and we were all
* out of it; it featured a 40-second bank of digitised
* swearing and would come up with a suitably fruity phrase
* when you got killed sometimes. Far too rude for me to
* release, but you could always make your own).
```

<img src="https://raw.githubusercontent.com/mwenge/llamatron/refs/heads/master/utils/llamatron.gif" height=600>

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
[LLATRON.S](src/LLATRON.S) | [LLATRON.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/LLATRON.s) | Main Game 6502 assembler source code |
[SASONIX.S](src/SASONIX.S) | [SASONIX.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/SASONIX.s) | Customized sound driver |
[SINE.IMG](src/SINE.IMG) | [SINE.IMG](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/SINE.IMG) | SINE Table |
[TENTACLE.S](src/TENTACLE.S) | [TENTACLE.S](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents/TENTACLE.S) | Pause Mode |
[fonte.s](src/fonte.s) | [Reworked](utils/Recreate%20fonte.s.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Font Sprites |
[sonix2.spl](src/sonix2.spl) |[Extracted](utils/Extract%20Assets.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Sound Samples |
[yakky2.neo](src/yakky2.neo) |[Extracted](utils/Extract%20Assets.ipynb) from [rude_llamatron.prg](orig/rude_llamatron.prg) | Splash Screen Graphic |


It was necessary to tweak the sources in order to assemble with `rmac`, these changes are visible in the [commit history](https://github.com/mwenge/llamatron/commits/master/).

It's possible to [extract the sound samples](utils/Extract%20Sound%20Samples.ipynb) and play them as [wav files](utils/samples).

## Thanks

[@gingerbeardman](https://github.com/gingerbeardman) for pointing me to [the sources](https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents) and a copy of the [rude binaries](orig/).
