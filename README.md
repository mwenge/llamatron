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

## Thanks
@gingerbeardman for providing [https://github.com/ggnkua/Atari_ST_Sources/tree/master/ASM/Llamasoft/Llamatron%20source%20disk%20contents](the sources) and a copy of the [rude binaries](orig/).
