                ; opt habs
                ; section code
                ; org $10000

* This is the sample driver. Based on the example code provided
* with Replay but with a lot of hacks to make it faster. The
* main service routine is utterly changed from the original but
* now it only uses two registers.


mfp equ $fffa00
iera equ mfp+$07
ierb equ mfp+$09
ipra equ mfp+$0b
isra equ mfp+$0f
imra equ mfp+$13
imrb equ mfp+$15
vector equ mfp+$17
tacr equ mfp+$19
tadr equ mfp+$1f
isrvec equ $134
_reverse:       dc.w 0
*
* THE SOUND CHIP
*
screg equ $ff8800 ; chip register select
scdata equ $ff8802 ; register data

* bdos equates (trap #1)

p_term_old equ 0 
f_super  equ $20

* bios equates (trap #13)

getmpb  equ 0
bconstat equ 1
bconin  equ 2
bconout  equ 3

* cartridge port addresses

input equ $fb0001
output equ $fa0000

oh_goaty:       move.l #inull,$120
                bsr init_sample
oh_g2:          bsr play_sample
oh_g1:          tst.b inuse
                bne oh_g1
                bra oh_g2
                
play_sample:    move.l cursrlo,sa_pt ; PASS START OF REPLAY
                move.l cursrhi,d6 ; & end
                st inuse ;  flag ints in use
                sf option;   we are not sampling
                 tst _reverse  ;backsamples
                bne do_revr
                lea ireplay,a0;  set up the routine
                bra setint;   and do it


do_revr:        lea ireplayr,a0 ; set up the routine
                bra setint;   and do it

cursrlo:        dc.l sample
cursrhi:        dc.l samend
                ;sa_pt equ asap+2
init_sample:   
                move.l #sample,a0
                move.l #samend,d0
ayyak:          move.b (a0),d1
                add.b #$80,d1
                ; asr.b #1,d1
                move.b d1,(a0)+
                cmp.l a0,d0
                bne ayyak  ;prescan sample

isamp:          move.w sr,d1
                move d1,-(a7)
                and #%0101100011100000,d1
                or.W #$2700,d1
                move d1,sr
                lea inull,a0
                bsr setint;   set null interrupt address
                ; moveq #0,d0;   set initial frequency
                ; bsr setfreq
                bsr enabmfp ;  set the mfp running
                bsr setsnd ;  set up sound registers
                
                sf xternal ;  set the mode for internal atari use
                bsr intregs ;  set up internal registers
                ; MOVE.W #$3200,SR ENABLE THE INTERRUPTS
                move (a7)+,d1
                move d1,sr
                rts


****************************************
*   THE INTERRUPT SERVICE ROUTINES     *
****************************************
*
* A6 = POINTER TO BASE OF REPLAY RAM
* A5 = OUTPUT ROUTINE ADDR
* A4 = INT. SOUND REG / EXT. PORT ADDR
* A3 = EXT. SND LOOK UP TABLE
* A2 = NOT USED
* A1 = NOT USED
* A0 = RESERVED FOR MAIN PROG.
* D7 = BYTE FROM PORT /  OUT TO PORT
* D6 = POINTER TO END OF REPLAY RAM
* D5 = SOUND CHIP DATA
* D4 = SOUND CHIP DATA
* D3 = UNUSED
* D2 = UNUSED
* D1 = UNUSED
* D0 = RESERVED FOR MAIN PROG. 
*
****************************************
*     THE NULL INTERRUPT ROUTINE       *
****************************************

inull:          rte


****************************************
*       REPLAY FROM MEMORY             *
****************************************

*** As you can see it is self modifying. Turn off cache on a TT
*** to make it work properly.

ireplay:        movem.l d0/a0,-(a7) 
                clr d0
asap:           move.b ireplay,d0
sped:           addq.l #1,sa_pt
irep:           lea snd_out(pc),A0
                lsl #3,D0   ;DOUBLE LONG WORD OFFSET
                move 4(a0,d0.w),irek+2 ;was d4
                move.l 0(a0,D0.W),D0  ;GET DATA #1
                lea screg,a0 
                MOVEP.l D0,0(A0)  ;PLAY #1
irek:            move #0,d0
                MOVEP.W d0,0(A0)  ;PLAY #2
                movem.l (a7)+,d0/a0
                RTE

ireplayr:       movem.l d0/a0,-(a7) 
                move.l sa_pt(pc),a0
                clr d0
                move.b (a0),d0
                lea -1(a0),a0
                 move.l a0,sa_pt
                bra irep

trp:            dc.w 0
snd_out:        dc.w $80c,$90b,$a09,0,$80c,$90b,$a09,0
                dc.w $80d,$908,$a08,0,$80b,$90b,$a0b,0
                dc.w $80d,$909,$a05,0,$80c,$90b,$a08,0
                dc.w $80d,$909,$a02,0,$80d,$908,$a06,0
                dc.w $80c,$90b,$a07,0,$80d,$907,$a07,0
                dc.w $80c,$90b,$a06,0,$80c,$90a,$a09,0
                dc.w $80b,$90b,$a0a,0,$80c,$90b,$a02,0
                dc.w $80c,$90b,$a00,0,$80c,$90a,$a08,0

                dc.w $80d,$906,$a04,0,$80d,$905,$a05,0
                dc.w $80d,$905,$a04,0,$80c,$909,$a09,0
                dc.w $80d,$904,$a03,0,$80b,$90b,$a09,0
                dc.w $80c,$90a,$a05,0,$80b,$90a,$a0a,0
                dc.w $80c,$909,$a08,0,$80b,$90b,$a08,0
                dc.w $80c,$90a,$a00,0,$80c,$90a,$a00,0
                dc.w $80c,$909,$a07,0,$80b,$90b,$a07,0
                dc.w $80c,$909,$a06,0,$80b,$90b,$a06,0

                dc.w $80b,$90a,$a09,0,$80b,$90b,$a05,0
                dc.w $80a,$90a,$a0a,0,$80b,$90b,$a02,0
                dc.w $80b,$90a,$a08,0,$80c,$907,$a07,0
                dc.w $80c,$908,$a04,0,$80c,$907,$a06,0
                dc.w $80b,$909,$a09,0,$80c,$906,$a06,0
                dc.w $80a,$90a,$a09,0,$80c,$907,$a03,0
                dc.w $80b,$90a,$a05,0,$80b,$909,$a08,0
                dc.w $80b,$90a,$a03,0,$80a,$90a,$a08,0

                dc.w $80b,$90a,$a00,0,$80b,$909,$a07,0
                dc.w $80b,$908,$a08,0,$80a,$90a,$a07,0
                dc.w $80a,$909,$a09,0,$80c,$901,$a01,0
                dc.w $80a,$90a,$a06,0,$80b,$908,$a07,0
                dc.w $80a,$90a,$a05,0,$80a,$909,$a08,0
                dc.w $80a,$90a,$a02,0,$80a,$90a,$a01,0
                dc.w $80a,$90a,$a00,0,$809,$909,$a09,0
                dc.w $80a,$908,$a08,0,$80b,$908,$a01,0

                dc.w $80a,$909,$a06,0,$80b,$907,$a04,0
                dc.w $80a,$909,$a05,0,$809,$909,$a08,0
                dc.w $80a,$909,$a03,0,$80a,$908,$a06,0
                dc.w $80a,$909,$a00,0,$809,$909,$a07,0
                dc.w $809,$908,$a08,0,$80a,$908,$a04,0
                dc.w $809,$909,$a06,0,$80a,$908,$a01,0
                dc.w $809,$909,$a05,0,$809,$908,$a07,0
                dc.w $808,$908,$a08,0,$809,$909,$a02,0

                dc.w $809,$908,$a06,0,$809,$909,$a00,0
                dc.w $809,$907,$a07,0,$808,$908,$a07,0
                dc.w $809,$907,$a06,0,$809,$908,$a02,0
                dc.w $808,$908,$a06,0,$809,$906,$a06,0
                dc.w $808,$907,$a07,0,$808,$908,$a04,0
                dc.w $808,$907,$a06,0,$808,$908,$a02,0
                dc.w $807,$907,$a07,0,$808,$906,$a06,0
                dc.w $808,$907,$a04,0,$807,$907,$a06,0

                dc.w $808,$906,$a05,0,$808,$906,$a04,0
                dc.w $807,$906,$a06,0,$807,$907,$a04,0
                dc.w $808,$905,$a04,0,$806,$906,$a06,0
                dc.w $807,$906,$a04,0,$807,$905,$a05,0
                dc.w $806,$906,$a05,0,$806,$906,$a04,0
                dc.w $806,$905,$a05,0,$806,$906,$a02,0
                dc.w $806,$905,$a04,0,$805,$905,$a05,0
                dc.w $806,$905,$a02,0,$805,$905,$a04,0

                dc.w $805,$904,$a04,0,$805,$905,$a02,0
                dc.w $804,$904,$a04,0,$804,$904,$a03,0
                dc.w $804,$904,$a02,0,$804,$903,$a03,0
                dc.w $803,$903,$a03,0,$803,$903,$a02,0
                dc.w $803,$902,$a02,0,$802,$902,$a02,0
                dc.w $802,$902,$a01,0,$801,$901,$a01,0
                dc.w $802,$901,$a00,0,$801,$901,$a00,0
                dc.w $801,$900,$a00,0,$800,$900,$a00,0

                dc.w $80e,$90d,$a0c,0,$80f,$903,$a00,0
                dc.w $80f,$903,$a00,0,$80f,$903,$a00,0
                dc.w $80f,$903,$a00,0,$80f,$903,$a00,0
                dc.w $80f,$903,$a00,0,$80e,$90d,$a0b,0
                dc.w $80e,$90d,$a0b,0,$80e,$90d,$a0b,0
                dc.w $80e,$90d,$a0b,0,$80e,$90d,$a0b,0
                dc.w $80e,$90d,$a0b,0,$80e,$90d,$a0b,0
                dc.w $80e,$90d,$a0a,0,$80e,$90d,$a0a,0

                dc.w $80e,$90d,$a0a,0,$80e,$90d,$a0a,0
                dc.w $80e,$90c,$a0c,0,$80e,$90d,$a00,0
                dc.w $80d,$90d,$a0d,0,$80d,$90d,$a0d,0
                dc.w $80d,$90d,$a0d,0,$80d,$90d,$a0d,0
                dc.w $80d,$90d,$a0d,0,$80d,$90d,$a0d,0
                dc.w $80e,$90c,$a0b,0,$80e,$90c,$a0b,0
                dc.w $80e,$90c,$a0b,0,$80e,$90c,$a0b,0
                dc.w $80e,$90c,$a0b,0,$80e,$90c,$a0b,0

                dc.w $80e,$90c,$a0b,0,$80e,$90c,$a0b,0
                dc.w $80e,$90c,$a0a,0,$80e,$90c,$a0a,0
                dc.w $80e,$90c,$a0a,0,$80e,$90c,$a0a,0
                dc.w $80d,$90d,$a0c,0,$80d,$90d,$a0c,0
                dc.w $80e,$90c,$a09,0,$80e,$90c,$a09,0
                dc.w $80e,$90c,$a05,0,$80e,$90c,$a00,0
                dc.w $80e,$90c,$a00,0,$80e,$90b,$a0b,0
                dc.w $80e,$90b,$a0b,0,$80e,$90b,$a0b,0

                dc.w $80e,$90b,$a0b,0,$80e,$90b,$a0a,0
                dc.w $80e,$90b,$a0a,0,$80e,$90b,$a0a,0
                dc.w $80d,$90d,$a0b,0,$80d,$90d,$a0b,0
                dc.w $80d,$90d,$a0b,0,$80e,$90b,$a09,0
                dc.w $80e,$90b,$a09,0,$80e,$90b,$a09,0
                dc.w $80d,$90c,$a0c,0,$80d,$90d,$a0a,0
                dc.w $80e,$90b,$a07,0,$80e,$90b,$a00,0
                dc.w $80e,$90b,$a00,0,$80d,$90d,$a09,0

                dc.w $80d,$90d,$a09,0,$80e,$90a,$a09,0
                dc.w $80d,$90d,$a08,0,$80d,$90d,$a07,0
                dc.w $80d,$90d,$a04,0,$80d,$90d,$a00,0
                dc.w $80e,$90a,$a04,0,$80e,$909,$a09,0
                dc.w $80e,$909,$a09,0,$80d,$90c,$a0b,0
                dc.w $80e,$909,$a08,0,$80e,$909,$a08,0
                dc.w $80e,$909,$a07,0,$80e,$908,$a08,0
                dc.w $80e,$909,$a01,0,$80c,$90c,$a0c,0

                dc.w $80d,$90c,$a0a,0,$80e,$908,$a06,0
                dc.w $80e,$907,$a07,0,$80e,$908,$a00,0
                dc.w $80e,$907,$a05,0,$80e,$906,$a06,0
                dc.w $80d,$90c,$a09,0,$80e,$905,$a05,0
                dc.w $80e,$904,$a04,0,$80d,$90c,$a08,0
                dc.w $80d,$90b,$a0b,0,$80e,$900,$a00,0
                dc.w $80d,$90c,$a06,0,$80d,$90c,$a05,0
                dc.w $80d,$90c,$a02,0,$80c,$90c,$a0b,0

                dc.w $80c,$90c,$a0b,0,$80d,$90b,$a0a,0
                dc.w $80d,$90b,$a0a,0,$80d,$90b,$a0a,0
                dc.w $80d,$90b,$a0a,0,$80c,$90c,$a0a,0
                dc.w $80c,$90c,$a0a,0,$80c,$90c,$a0a,0
                dc.w $80d,$90b,$a09,0,$80d,$90b,$a09,0
                dc.w $80d,$90a,$a0a,0,$80d,$90a,$a0a,0
                dc.w $80d,$90a,$a0a,0,$80c,$90c,$a09,0
                dc.w $80c,$90c,$a09,0,$80c,$90c,$a09,0

                dc.w $80d,$90b,$a06,0,$80c,$90b,$a0b,0
                dc.w $80c,$90c,$a08,0,$80d,$90b,$a00,0
                dc.w $80d,$90b,$a00,0,$80c,$90c,$a07,0
                dc.w $80c,$90c,$a06,0,$80c,$90c,$a05,0
                dc.w $80c,$90c,$a03,0,$80c,$90c,$a01,0
                dc.w $80c,$90b,$a0a,0,$80d,$90a,$a05,0
                dc.w $80d,$90a,$a04,0,$80d,$90a,$a02,0
                dc.w $80d,$909,$a08,0,$80d,$909,$a08,0

haltrep:        move sr,d0
                move d0,-(a7)
                and #%0101100011100000,d0
                or.w #$2700,d0
                move d0,sr
                lea inull,a0; remove replay int.
                bsr setint
                sf inuse
                move (a7)+,d0
                move.w d0,sr
                movem.l (a7)+,d0-d1/a0
                RTE

****************************************
*       THE OUTPUT ROUTINES            *
****************************************
*
*  The following code plays the sounds out through the GI sound chip.
*  We use 'A3' as the base pointer to the look up table. This is easy
*  to use here since it is spare. Position independant writers may
*  replace 'A3' with 'PC'. This relieves an extra register but the
*  table must be located within 256 BYTES of the code for it to work.
*  Our Thanks to Andy Beveridge for the improved sound tables & code.
*
intoutp:        and.w #$00ff,d7 ; mask off rubbish
                add.b #$80,d7  ; complent value
                lsl.w #3,d7  ; double long word offset
                move.l 0(a3,d7.w),d5 ; get data #1
                move.w 4(a3,d7.w),d4  ;get data #2
                movep.l d5,0(a4)  ;play #1
                movep.w d4,0(a4)  ;play #2
                movem.l (a7)+,d0-d7/a0-a6
                rte
*
*  The following code plays the sounds out through the REPLAY port.
*  Simply get the byte, multiply by 2 and read from the output port
*  indexed by the WORD in D7. This actually places the data to be
*  written on the address bus of the 68000. Don't forget that the
*  68000 does not have an address line AD0 as such, hence the LSL
*  (we would lose the least significant BIT otherwise !!).
*
extoutp:        and.w #$00ff,d7 ; remove rubbish
                lsl.w #1,d7  ; preserve l.s.b.
                move.b 0(a4,d7.w),d7 ; play out by reading in !!
                rte


*****************************************
* CHOOSE INTERRUPT VECTOR         *
*****************************************
*
*   SET UP SELECTED INTERRUPT WITH A0.L
*   CONTAINING THE NEW ROUTINE VECTOR.
*
setint:          move.w sr,d0  ;save system status
                move d0,-(a7)
                and #%0101100011100000,d0
                or.w #$2700,d0
                move d0,sr
                ; move.w #$2700,sr interrupts off

                move.l a0,isrvec; install new routine
                move (a7)+,d0
                move.w d0,sr ; re-assert old status
                rts

*****************************************
*       SET UP MFP FREQUENCY            *
*****************************************
*
*   SET UP MFP TIMER A TO GENERATE INTERRUPTS
*   ENTER WITH D0.W SET WITH A FREQUENCY NUMBER 0 TO 7
*   E.G. D0.W = $0002 GETS 3RD MFP DATA FROM TABLE
*
setfreq:        
                move.b #0,tacr ; disable timer
                and.w #7,d0 ; ensure 0-7
                move.w d0,freqnum ;save for prosperity
                lea freqtab,a0 ;get the frequency xref addr
                lsl.w #1,d0 ; convert to word table offset
                move.w 0(a0,d0.w),d0 ; & get the mfp data
                move.b d0,tacr ;  lsb = control reg byte
                lsr.w #8,d0 ;  shift down next byte
                 move.b d0,tadr ; next = data reg byte
                rts

***********************************
*       ENABLE THE MFP            *
***********************************

enabmfp:       
                move.b #$20,imra
                ; move.b #0,imrb  ;comment these 2 lines out
                move.b #$20,iera 
                ; move.b #0,ierb  ;if you are running hbl
                bclr.b #3,vector
                rts

*****************************************
*    SET UP THE SOUND CHIP CHANNELS     *
*****************************************

setsnd:          move.b #0,screg; channel a
                move.b #0,scdata
                move.b #1,screg
                move.b #0,scdata

                move.b #2,screg ;channel b
                move.b #0,scdata
                move.b #3,screg
                move.b #0,scdata

                move.b #4,screg ;channel c
                move.b #0,scdata
                move.b #5,screg
                move.b #0,scdata

                move.b #7,screg ;set up channel mixing & port 'a' i/o
                move.b #$ff,scdata
                ; move.b #$cf,scdata
                move.b #8,screg ;set all volumes to zero
                move.b #0,scdata
                move.b #9,screg
                move.b #0,scdata
                move.b #10,screg
                move.b #0,scdata
                rts
                
***************************************
*    SET UP REGS. FOR INTERNAL        *
***************************************

intregs:        move.w sr,d0
                move d0,-(a7)
                and #%0101100011100000,d0
                or.w #$2700,d0
                move d0,sr
                ; move.w #$2700,sr
                sf xternal
                lea.l intoutp,a5; install output routine
                move.l #screg,a4; sound chip cntrl reg
                lea.l snd_out,a3; look up tables
                moveq #0,d7
                move (a7)+,d0
                move.w d0,sr
                rts

*****************************************
*     SET UP REGISTERS FOR EXTERNAL     *
*****************************************

extregs:       
                rts

*
* THE FOLLOWING NOT ALLOWED DURING INTERRUPTS
*
chkints:        tst.b inuse ; ints running ?
                bne decexit ; leave now if yes

* ETC...ETC

decexit:        rts


***********************************
* BLOCK STORAGE AREA        *
***************************************
*    Internal sound lookup table.     *
***************************************
even


**************************************
*       MFP/FREQUENCY TABLE          *
************************************** 0506  
even
freqtab:        dc.w $0507 ;real slow
                dc.w $0506; 4.9 khz
                dc.w $0505; 7.68 khz
                dc.w $0404; 9.6 khz
                dc.w $1f01; 19.8 khz
                dc.w $0802; 30.7 khz
                dc.w $0106 
                dc.w $0106

**************************************
* DEFINE PROGRAM STORAGE       *
**************************************
                EVEN
xternal:        ds.b 1 ; $ff ; = external o/p selected
inuse:          ds.b 1 ; interrupt in use flag
option:         ds.b 1 ; int. option  $ff = sample
                even
freqnum:        ds.w 1;  frequency selected
mfpmem:         ds.b 8 ; saved mfp data

**************************************
*      USER PROGRAM STACK HERE.      *
**************************************
                EVEN

**************************************
*       START OF REPLAY BUFFER       *
**************************************


sampri:         dc.w 0
rsonic:          cmp sampri,d2
                bmi arsse
                move #1,_reverse
                bra osonic
sonic:         
                ;
                ; pass d0=sample # (SAMTAB holds address and length data)
                ; and d1=replay speed 0=slowest (v. slow!); d2=priority (0 low)

                ; cmp #30,d0
                ; bne fix1m
                ; move #32,d0
fix1m:          cmp sampri,d2
                bmi arsse
                move #0,_reverse
osonic:        
                ; move #0,sampri
                ; rts

                ; sub #1,d1
                ; bpl fix1mo ;only for halfmeg
                ; move #0,d1
fix1mo:         tst sonon
                bne arsse
                move d2,sampri
                ; cmp #18,d0
                ; bne oso1
                ; move #15,d0
oso1:           lea samtab,a0
                asl #3,d0
                move.l 0(a0,d0.w),d2
                asr.l #1,d2  ;1 for 1meg
                add.l #sample,d2
                tst _reverse
                bne izzrev
                move.l d2,cursrlo 
                move.l 4(a0,d0.w),d0
                asr.l #1,d0  ;1 for 1meg
                add.l d0,d2
                move.l d2,cursrhi
izzia:          move.b #$52,sped ;default spd. =1 (52 for 1meg)
                move d1,d0
                cmp #5,d0 ;3 for 1meg
                blt izzia2   ;means is speed 0 or 1, leave it
                move #1,d1 ;1 for 1meg
                sub #1,d0  ;1 for 1meg (2)
                asl #1,d0
                or.b #$50,d0  ;make the addQ.l
                and.b #$5e,d0
                move.b d0,sped
izzia2:         move d1,d0
                jsr setfreq
                jmp play_sample
izzrev:         move.l d2,cursrhi
                move.l 4(a0,d0.w),d0
                asr.l #1,d0 ;#1 for 1meg
                add.l d0,d2
                move.l d2,cursrlo
                bra izzia
arsse:          rts


samtab:         
                ;
;table of samples:  asddress, then length

                dc.l 0,10602
                dc.l 11160,1116
                dc.l 12276,5580
                dc.l 17856,3069
                dc.l 20646,1953
                dc.l 22599,8091
                dc.l 30690,12555
                dc.l 43245,9207
                dc.l 52452,8928
                dc.l 61380,2511
                dc.l 63891,3906 ;10
                dc.l 67797,3627
                dc.l 71424,2232
                dc.l 73656,1116
                dc.l 75051,1116
                dc.l 76167,6417
                dc.l 82584,10044
                dc.l 92628,21483
                dc.l 114111,10323
                dc.l 124434,7812
                dc.l 132246,20367 ;20
                dc.l 152613,12276
                dc.l 164840,43058
                dc.l 82676*2,6329*2 ;baaa
                dc.l 103628*2,4788*2
                dc.l 89037*2,9589*2 ;25 ohyeah
                dc.l 99118*2,4510*2 ;ooOOoo
                dc.l 103628*2,4788*2 ;'mooOOoo'
                dc.l 108383*2,7703*2 ;'i love u'
                dc.l 116056*2,10679*2 ;'oh f*ck'
                dc.l 126639*2,30270*2 ;'aaaaagghh' 30
                dc.l 120297*2,6435*2 ;'f*ck'
                dc.l 116113*2,4155*2 ;oh

sa_pt equ asap+2

sample:         incbin "src/sonix2.spl"
                even
samend:         dc.w 0

