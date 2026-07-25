.PHONY: all clean

DIRS=src/bin

all: clean llamatron.prg

llamatron.prg: sources 
	./rmac/rmac -p -l src/LLATRON.S -o llamatron.prg
	echo "2c74b63032ad7ff34af0c10ad4531d4f  llamatron.prg" | md5sum -c

clean_build: llamatron.prg 
	echo "2c74b63032ad7ff34af0c10ad4531d4f  llamatron.prg" | md5sum -c

sources: src/*.s src/*.S


run: llamatron.prg
	hatari --tos utils/etos1024k.img --machine ste --memsize 14 --cpuclock 32 llamatron.prg 

clean:
	-rm -f llamatron.prg
