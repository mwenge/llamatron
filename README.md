# Llamatron:2112 by Jeff Minter


## Requirements

### Install the Hatari emulator
```sh
sudo apt install hatari
```

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

