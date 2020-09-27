;************************************************************************
;
;
;************************************************************************

	.include	"geosSym.inc"		;get GEOS definitions
	.include	"geosmac.ca65.inc"		;get GEOS macro definitions

GAMECORE	=	$7F40

COLOURCLEAR	=	$BF

TOPPILES_Y	=	$10

CARDWIDTH	=	4 * 8
CARDHEIGHT	=	6 * 8

CARDKINGD	=	13
CARDKINGC	=	26
CARDKINGH	=	39
CARDKINGS	=	52

CARDPILE_Y	=	$48
CARDPLE0_X	=	$00
CARDPLE0_TOP	=	CARDPILE_Y
CARDPLE0_BOTTOM	=	$C7
CARDPLE0_LEFT	=	CARDPLE0_X * 8
CARDPLE0_RIGHT	=	CARDPLE0_LEFT + CARDWIDTH - 1
CARDPLE1_LEFT	=	CARDPLE0_LEFT + CARDWIDTH + 8
CARDPLE1_RIGHT	=	CARDPLE1_LEFT + CARDWIDTH - 1
CARDPLE2_LEFT	=	CARDPLE1_LEFT + CARDWIDTH + 8
CARDPLE2_RIGHT	=	CARDPLE2_LEFT + CARDWIDTH - 1
CARDPLE3_LEFT	=	CARDPLE2_LEFT + CARDWIDTH + 8
CARDPLE3_RIGHT	=	CARDPLE3_LEFT + CARDWIDTH - 1
CARDPLE4_LEFT	=	CARDPLE3_LEFT + CARDWIDTH + 8
CARDPLE4_RIGHT	=	CARDPLE4_LEFT + CARDWIDTH - 1
CARDPLE5_LEFT	=	CARDPLE4_LEFT + CARDWIDTH + 8
CARDPLE5_RIGHT	=	CARDPLE5_LEFT + CARDWIDTH - 1
CARDPLE6_LEFT	=	CARDPLE5_LEFT + CARDWIDTH + 8
CARDPLE6_RIGHT	=	CARDPLE6_LEFT + CARDWIDTH - 1
CARDPLE7_LEFT	=	CARDPLE6_LEFT + CARDWIDTH + 8
CARDPLE7_RIGHT	=	CARDPLE7_LEFT + CARDWIDTH - 1

SOLVPILE_Y	=	TOPPILES_Y
SOLVPLE0_X	=	$14
SOLVPLE0_TOP	=	SOLVPILE_Y
SOLVPLE0_BOTTOM	=	SOLVPILE_Y + CARDHEIGHT - 1
SOLVPLE0_LEFT	=	SOLVPLE0_X * 8
SOLVPLE0_RIGHT 	=	SOLVPLE0_LEFT + CARDWIDTH - 1
SOLVPLE1_LEFT	=	SOLVPLE0_LEFT + CARDWIDTH + 8
SOLVPLE1_RIGHT 	=	SOLVPLE1_LEFT + CARDWIDTH - 1
SOLVPLE2_LEFT	=	SOLVPLE1_LEFT + CARDWIDTH + 8
SOLVPLE2_RIGHT 	=	SOLVPLE2_LEFT + CARDWIDTH - 1
SOLVPLE3_LEFT	=	SOLVPLE2_LEFT + CARDWIDTH + 8
SOLVPLE3_RIGHT 	=	SOLVPLE3_LEFT + CARDWIDTH - 1

SPARPILE_Y	=	TOPPILES_Y
SPARPLE0_X	=	$00
SPARPLE0_TOP	=	SPARPILE_Y
SPARPLE0_BOTTOM	=	SPARPILE_Y + CARDHEIGHT - 1
SPARPLE0_LEFT	=	SPARPLE0_X * 8
SPARPLE0_RIGHT 	=	SPARPLE0_LEFT + CARDWIDTH - 1
SPARPLE1_LEFT	=	SPARPLE0_LEFT + CARDWIDTH + 8
SPARPLE1_RIGHT 	=	SPARPLE1_LEFT + CARDWIDTH - 1
SPARPLE2_LEFT	=	SPARPLE1_LEFT + CARDWIDTH + 8
SPARPLE2_RIGHT 	=	SPARPLE2_LEFT + CARDWIDTH - 1
SPARPLE3_LEFT	=	SPARPLE2_LEFT + CARDWIDTH + 8
SPARPLE3_RIGHT 	=	SPARPLE3_LEFT + CARDWIDTH - 1


	.struct		CARDPILE
		Length	.byte
		_00	.byte
		_01	.byte
		_02	.byte
		_03	.byte
		_04	.byte
		_05	.byte
		_06	.byte
		_07	.byte
		_08	.byte
		_09	.byte
		_0A	.byte
		_0B	.byte
		_0C	.byte
		_0D	.byte
		_0E	.byte
		_0F	.byte
		_10	.byte
		_11	.byte
		_12	.byte
		_13	.byte
		_14	.byte
	.endstruct
	
	.struct		SOLVEPILE
		_0	.byte
		_1	.byte
		_2	.byte
		_3	.byte
	.endstruct
	
	.struct		SPAREPILE
		_0	.byte
		_1	.byte
		_2	.byte
		_3	.byte
	.endstruct

	.struct		DIRTYPILES
		_0	.byte
		_1	.byte
		_2	.byte
		_3	.byte
		_4	.byte
		_5	.byte
		_6	.byte
		_7	.byte
		_8	.byte
		_9	.byte
		_A	.byte
		_B	.byte
		_C	.byte
		_D	.byte
		_E	.byte
		_F	.byte
	.endstruct
	
	.struct		LASTLENPILES
		_0	.byte
		_1	.byte
		_2	.byte
		_3	.byte
		_4	.byte
		_5	.byte
		_6	.byte
		_7	.byte
	.endstruct
	
	.struct		CARDPILECOMP
		_0	.byte
		_1	.byte
		_2	.byte
		_3	.byte
		_4	.byte
		_5	.byte
		_6	.byte
		_7	.byte
	.endstruct
	
	.struct		CSELECT
		length	.byte
		pile	.byte
		index	.byte
		card	.byte
		top	.byte
		bottom	.byte
		left	.word
		right	.word
	.endstruct

	.struct		GAMEDATA
		SparPl0 .tag	SPAREPILE
		SolvPl0	.tag	SOLVEPILE
		DirtyPl	.tag	DIRTYPILES
		LastLns	.tag	LASTLENPILES
		CrdCmp0 .tag	CARDPILECOMP
		CSelect	.tag	CSELECT
		SparCnt .byte
		AutoCan	.byte
		AutoEnb	.byte
	.endstruct

	.assert .sizeof(GAMEDATA) < 193, error, "GANEDATA too large!"
;	.out	.concat("- sizeof GAMEDATA:  ", .string(.sizeof(GAMEDATA)))

	.SEGMENT	"DIRENTRY"
	.SEGMENT	"FILEINFO"
	.SEGMENT	"STARTUP"

	.CODE				
	.ORG	 $0400			
	
;-------------------------------------------------------------------------------
Main:
;-------------------------------------------------------------------------------
	LoadB	dispBufferOn, ST_WR_FORE
					

	LoadW	r0, ClearScreen0	;point to graphics string to clear screen
	JSR	GraphicsString

	LoadW	r0, MainMenu		;point to menu definition table
	LDA	#0			;place cursor on first menu item when done
	JSR	DoMenu			;have GEOS draw the menus on the screen

	LDA	#TRUE
	STA	GAMECORE + GAMEDATA::AutoEnb

	LoadW	r0, ProcessData0
	LDA	#$02
	JSR	InitProcesses

	LDA	COLOR_MATRIX
	STA	ColourOrg0
	
	LDA	#COLOURCLEAR
	JSR	MainFillColour

	JSR	GameInit

	LDA	#<HookPressVec
	STA	otherPressVec
	LDA	#>HookPressVec
	STA	otherPressVec + 1

	LDA	#<HookRecoverVec
	STA	RecoverVector
	LDA	#>HookRecoverVec
	STA	RecoverVector + 1
	
	RTS


;-------------------------------------------------------------------------------
MainFillColour:
;-------------------------------------------------------------------------------
	LDX	#$00
@loop0:
	STA	COLOR_MATRIX, X
	STA	COLOR_MATRIX + 256, X
	STA	COLOR_MATRIX + 512, X
	INX
	BNE	@loop0
	
	LDX	#$00
@loop1:
	STA	COLOR_MATRIX + 768, X
	INX
	CPX	#$E8
	BNE	@loop1
	
	RTS
	
	
;-------------------------------------------------------------------------------
HookRecoverVec:
;-------------------------------------------------------------------------------
	LDA	#$02
	JSR	SetPattern
	
	JSR	Rectangle

	LDA	RecoverFlags0
	BEQ	@exit

@top:
	JSR	SparDrawAll
	
	LDA	RecoverFlags0
	
	LDA	#$00
	STA	RecoverFlags0

	LDX	#$01
	JSR	UnBlockProcess
	
@exit:
	RTS
	

;-------------------------------------------------------------------------------
HookPressVec:
;-------------------------------------------------------------------------------
;	Not working as documented
;	LDA	pressFlag
;	AND	#MOUSE_BIT
;	BNE	@test0
;	
;	RTS
;	
;@test0:
	LDA	mouseData
	BPL	@begin
	
	RTS
	
@begin:
	LDA	GAMECORE + GAMEDATA::CSelect
	BNE	@target

	JSR	GameMakeSelect

	RTS

@target:
	JSR	GameMakeTarget
	
@exit:
	RTS


;-------------------------------------------------------------------------------
DeckShuffle:
;-------------------------------------------------------------------------------
	LDX	#$00
	LDA	#$01
	
@loop0:
	STA	DeckData0, X
	TAY
	INY
	TYA
	INX
	CPX	#$34
	BNE	@loop0
	
	LDA	#$00
	STA	r15L
		
@loop1:
	JSR	GetRandom
	
;	GetRandom returns 0 - 65521.  Need 0 to 51
	LDA	#$FE
	STA	r2L
	LDA	#$04
	STA	r2H

	LDA	random
	STA	r1L
	LDA	random + 1
	STA	r1H
	
	LDX	#r1
	LDY	#r2
	
	JSR	Ddiv
	
	LDA	r1L
	CMP	#$34
	BCS	@loop1		;>= 52 redo
	
	TAY
	LDX	r15L
	LDA	DeckData0, X
	STA	r15H
	LDA	DeckData0, Y
	STA	DeckData0, X
	LDA	r15H
	STA	DeckData0, Y
	
	INC	r15L
	LDA	r15L
	
	CMP	#$34
	BNE	@loop1	

	RTS

;-------------------------------------------------------------------------------
DeckDeal:
;-------------------------------------------------------------------------------
	LDA	#$00
	STA	r13L		;Deck card index
	STA	r15H		;card pile index
	
@loop0:
	ASL
	TAX
	LDA	CardData0, X
	STA	a1L		;Card pile data
	LDA	CardData0 + 1, X
	STA	a1H		

;	Init  card pile len, dirty
	LDA	#$00
	LDY	r15H
	STA	GAMECORE + GAMEDATA::DirtyPl, Y
	STA	GAMECORE + GAMEDATA::LastLns, Y

	LDA	#$07
	STA	r13H
	
	LDA	r15H
	CMP	#$04
	BCC	@cont0
	
	DEC	r13H
	
@cont0:
	LDY	#$00
	LDA	r13H
	STA	(a1), Y

	INY
@loop1:
	LDX	r13L		;Get card
	LDA	DeckData0, X
	
	STA	(a1), Y
	INC	r13L
	INY
	
	DEC	r13H
	BNE	@loop1

	LDX	r15H
	LDA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	INC	r15H

	LDA	r15H
	CMP	#$08
	BNE	@loop0
	
	LDA	#$00
	LDY	#$00
	STA	GAMECORE + GAMEDATA::SparPl0, Y
	INY
	STA	GAMECORE + GAMEDATA::SparPl0, Y
	INY
	STA	GAMECORE + GAMEDATA::SparPl0, Y
	INY
	STA	GAMECORE + GAMEDATA::SparPl0, Y

	LDY	#$00
	LDA	#$36
	STA	r13L
@loop2:
	STA	GAMECORE + GAMEDATA::SolvPl0, Y
	INC	r13L
	LDA	r13L
	INY
	CPY	#$04
	BNE	@loop2

	LDY	#$08
	LDA	#$80
@loop3:
	STA	GAMECORE + GAMEDATA::DirtyPl, Y
	INY
	CPY	#$10
	BNE	@loop3

	RTS


;-------------------------------------------------------------------------------
CardCheckContig:
;	IN	r15H	pile index
;		r15L	pile card index
;		r13H	pile length
;		a1	card pile
;	USES	r8L	next index
;		r8H	face value
;		r7L	suit value
;		r7H	test suit
;-------------------------------------------------------------------------------
	LDX	r15L			;Index + 1 for prev
	INX	
	TXA
	
	CMP	r13H			;If at end (1 card) then contiguous
	BCC	@begin
	
	SEC
	RTS
	
@begin:	
	INX				;Set next index
	STX	r8L
	
	TAY				;Prev card
	LDA	(a1), Y
	ASL
	TAX
	LDA	Cards0 + 1, X
	STA	r8H			;Prev face value
	
	LDA	Cards0, X
	STA	r7L			;Prev suit value
	
@loop0:
	LDY	r8L			;Next card
	LDA	(a1), Y
	ASL
	TAX
	LDA	Cards0 + 1, X
	DEC	r8H			;Check expected face value
	CMP	r8H
	BNE	@noncontig

	LDA	#$01			;Begin test suit w- Diamonds
	STA	r7H

	LDA	Cards0, X		;.A is next suit
	
	LDY	r7L			;.Y is prev suit
	CPY	#$01			;Prev is Diamonds?
	BNE	@testhearts
	
@wantblack:
	INC	r7H			;Prev Hearts/Diamonds so start w- Clubs

@testsuit0:
	CMP	r7H			;Next is first suit?
	BNE	@testsuit1
	
@suitfound:
	STA	r7L			;Store suit and test next card
	JMP	@next0
	
@testsuit1:
	INC	r7H			;Next is second suit?
	INC	r7H
	
	CMP	r7H
	BNE	@noncontig		;Still no?  Not contiguous
	
	JMP	@suitfound
	
@testhearts:
	CPY	#$03			;Prev is Hearts?
	BEQ	@wantblack

	JMP	@testsuit0
		
@next0:
	LDA	r8L
	INC	r8L			;Move to next card
	CMP	r13H
	BNE	@loop0

	SEC
	RTS
	
@noncontig:
	CLC
	RTS


;-------------------------------------------------------------------------------
CardCheckMove:
;	IN	r15H	pile index
;		a1	card pile
;	USES	r8L	test face
;		r8H	face value
;		r7L	suit value
;		r7H	test suit
;-------------------------------------------------------------------------------
	LDY	#$00
	LDA	(a1), Y
	
	BNE	@begin
	
	SEC
	RTS
	
@begin:
	TAY
	LDA	(a1), Y
	ASL
	TAX
	LDA	Cards0, X
	STA	r7L
	LDA	Cards0 + 1, X
	STA	r8H
	
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::card
	ASL
	TAX
	LDA	Cards0 + 1, X
	TAY
	INY
	CPY	r8H
	BNE	@nomove
	
	LDA	#$01
	STA	r7H
	
	LDA	Cards0, X
	LDY	r7L
	
	CPY	#$01			;Prev is Diamonds?
	BNE	@testhearts
	
@wantblack:
	INC	r7H			;Prev Hearts/Diamonds so start w- Clubs

@testsuit0:
	CMP	r7H			;Next is first suit?
	BNE	@testsuit1
	
@suitfound:
	SEC				;Found, can move
	RTS
	
@testsuit1:
	INC	r7H			;Next is second suit?
	INC	r7H
	
	CMP	r7H
	BNE	@nomove			;Still no?  No move
	
	JMP	@suitfound
	
@testhearts:
	CPY	#$03			;Prev is Hearts?
	BEQ	@wantblack

	JMP	@testsuit0
	
@nomove:
	CLC
	RTS


;-------------------------------------------------------------------------------
CardMoveSelect:
;	IN	r15H	dest pile index
;		a1	dest card pile
;-------------------------------------------------------------------------------
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	STA	r9L
	
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	CMP	#$08
	BCC	@begin

	TAX
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDX	r15H
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	LDY	#$00
	LDA	(a1), Y
	STA	GAMECORE + GAMEDATA::LastLns, X

	TAX
	INX
	TXA
	STA	(a1), Y
	TAY
	
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	CMP	#$0C
	BCS	@solve

	SEC
	SBC	#$08
	TAX
	
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	STA	(a1), Y
	
	LDA	#$00
	STA	GAMECORE + GAMEDATA::SparPl0, X
	
	INC	GAMECORE + GAMEDATA::SparCnt
	
	RTS

@solve:
;	TODO
	RTS
	
@begin:
	TAX
	ASL
	TAY
	LDA	CardData0, Y
	STA	a0L
	LDA	CardData0 + 1, Y
	STA	a0H
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDY	#$00
	LDA	(a0), Y
	STA	GAMECORE + GAMEDATA::LastLns, X
	
	SEC
	SBC	r9L
	STA	(a0), Y

	LDX	r15H
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	LDA	(a1), Y
	STA	GAMECORE + GAMEDATA::LastLns, X
	TAX
	INX
	STX	r8H
		
	CLC
	ADC	r9L
	STA	(a1), Y
	
	LDY	GAMECORE + GAMEDATA::CSelect + CSELECT::index
	INY
	STY	r8L
	
@loop0:
	LDA	(a0), Y
	LDY	r8H
	STA	(a1), Y
	INC	r8L
	INC	r8H
	LDY	r8L
	DEC	r9L
	BNE	@loop0
	
	RTS


;-------------------------------------------------------------------------------
CardFindMseCard:
;	IN	r15H	pile index
;		a1	card pile
;	OUT	r13L	card 
;		r13H	length card pile
;		r15L	index
;		r2L	rect top
;		r2H	rect bottom
;-------------------------------------------------------------------------------
	LDY	#$00
	LDA	(a1), Y
	BNE	@begin
	
	CLC
	RTS
	
@begin:
	STY	r14L			;not found
	STY	r15L
	STY	r12H
	
	STA	r13H			;pile card count
	LDX	r15H			
	LDA	GAMECORE + GAMEDATA::CrdCmp0, X
	TAY
	STY	r12L			;prev index
	
	ASL				;compressed offest
	CLC
	ADC	#CARDPILE_Y		
	STA	r2L			;calc rect top

@loop0:
	INY
	CPY	r13H			;is last card?
	BCS	@last0
	
	CLC				;no so tile
	ADC	#$07
	STA	r2H
	
@test0:
	LDA	r14L			;is already found?
	BNE	@move0
	
	JSR	IsMseInRegion		;no, test if has mouse
	CMP	#TRUE
	BNE	@move0
	
	LDA	#$01			;found
	STA	r14L
	
	LDA	r12L			
	STA	r15L	
	
@move0:
	INC	r12L			;next index
	
	LDA	r14L			;was found already?
	BEQ	@offset0
	
	CLC				;yes, need bottom offset
	LDA	r12H
	ADC	#$08
	STA	r12H
	
	JMP	@next0
		
@offset0:
	LDX	r2H			;no, next rect top
	INX
	STX	r2L

@next0:
	LDY	r12L			;move to test next
	LDA	r2L
	JMP	@loop0

@last0:
	CLC				;at last card
	ADC	#(CARDHEIGHT - 1)
	
	CLC				;include bottom offset
	ADC	r12H
	
	CMP	#$C8			;check screen limit
	BCC	@test1
	
	LDA	#$C7
	
@test1:
	STA	r2H			;rect bottom
	
	LDA	r14L			;is already found?
	BNE	@found1
	
	JSR	IsMseInRegion		;no, test if has mouse
	CMP	#TRUE
	BNE	@notfound1
	
	LDY	r12L
	STY	r15L
	
	INY
	LDA	(a1), Y
	STA	r13L			;this card
	
	SEC
	RTS
	
@notfound1:
	CLC				;not found at all
	RTS
	
@found1:
	LDY	r15L
	INY
	LDA	(a1), Y
	STA	r13L			;this card
	
	SEC				;was found
	RTS
	

;-------------------------------------------------------------------------------
CardDraw:
;	IN:	r12H	Card index * 2
;		r14L	x cell
;		r14H	y co-ord
;-------------------------------------------------------------------------------
;	Draw top
	LDX	r12H
	LDA	CardTops0, X
	STA	r0L
	LDA	CardTops0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$0A
	STA	r2H
	
	JSR	BitmapUp
	
;	Draw suit
	LDA	r14H
	CLC
	ADC	#$0A
	STA	r14H
	
	LDX	r12H
;	LDA	Cards0, X
;	ASL
;	TAX

	LDA	CardSuits0, X
	STA	r0L
	LDA	CardSuits0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$1C
	STA	r2H
	
	JSR	BitmapUp
	
;	Draw bottom
	LDA	r14H
	CLC
	ADC	#$1C
	STA	r14H

	LDX 	r12H
	LDA	CardBots0, X
	STA	r0L
	LDA	CardBots0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$0A
	STA	r2H
	
	JSR	BitmapUp

	RTS


;-------------------------------------------------------------------------------
CardDrawClip:
;	IN:	r12H	Card index * 2
;		r14L	x cell
;		r14H	y co-ord
;-------------------------------------------------------------------------------
;	Draw top
	LDX	r12H
	LDA	CardTops0, X
	STA	r0L
	LDA	CardTops0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$0A
	STA	r2H
	
	JSR	BitmapUp
	
;	Draw suit
	LDA	#$1C
	STA	r2H
	
	LDA	r14H
	CLC
	ADC	#$0A
	STA	r14H
	
	CLC
	ADC	#$1B
	CMP	#$C8
	BCC	@cont0

	SEC
	LDA	#$C8
	SBC	r14H
	
	STA	r2H

@cont0:
	LDX	r12H
;	LDA	Cards0, X
;	ASL
;	TAX

	LDA	CardSuits0, X
	STA	r0L
	LDA	CardSuits0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	
	JSR	BitmapUp
	
;	Draw bottom
	LDA	#$0A
	STA	r2H

	LDA	r14H
	CLC
	ADC	#$1C
	STA	r14H

	CMP	#$C7
	BCS	@exit

	CLC
	ADC	#$0A	
	CMP	#$C8		
	BCC	@cont1

	SEC
	LDA	#$C8		
	SBC	r14H
	
	BCC	@exit		;Do it anyway
	BEQ	@exit
	
	STA	r2H

@cont1:
	LDX 	r12H
	LDA	CardBots0, X
	STA	r0L
	LDA	CardBots0 + 1, X
	STA	r0H

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
;	LDA	#$0A
;	STA	r2H
	
	JSR	BitmapUp

@exit:
	RTS


;-------------------------------------------------------------------------------
CardLoadPileRect:
;-------------------------------------------------------------------------------
	LDA	#CARDPILE_Y
	STA	r2L		;Card pile y co-ord

	LDA	r15H
	ASL
	TAX
	
	LDA	CardPileLeft0, X
	STA	r3L
	LDA	CardPileLeft0 + 1, X
	STA	r3H

	LDA	CardPileRight0, X
	STA	r4L
	LDA	CardPileRight0 + 1, X
	STA	r4H

	LDA	r15L
	BPL	@last

;	LDA	r14H
;	STA	r2L
	LDA	#$C7
	STA	r2H
	
	RTS
	
@last:
	LDX	r15H
	SEC
	LDA	r15L
	SBC	GAMECORE + GAMEDATA::CrdCmp0, X
	STA	r15L
	
	LDA	GAMECORE + GAMEDATA::CrdCmp0, X
	ASL
	STA	r5L

	LDA	r2L
	STA	r11L

	LDA	r15L
	STA	r2L
	LDA	#$08
	STA	r1L
	
	LDX	#r1
	LDY	#r2
	
	JSR	BBMult
	
	LDA	r1L
	CLC
	ADC	r11L
	ADC	r5L
	
	STA	r2L
	
	CLC
	ADC	#(CARDHEIGHT - 1)
	
	CMP	#$C8
	BCC	@done
	
	LDA	#$C7
	
@done:
	STA	r2H
	
	RTS
	

;-------------------------------------------------------------------------------
CardCalcComp:
;-------------------------------------------------------------------------------
	LDA	#$00			;Init pile compress count to 0
	LDX	r15H
	STA	GAMECORE + GAMEDATA::CrdCmp0, X
	
	LDY	#$00			;Check current pile length
	LDA	(a1), Y
	CMP	#$0C			;Less than 12, no compress
	BCC	@exit
	
	SEC
	SBC	#$0B			;Compress count = (len - 11) / 3 * 4
	
	STA	r1L
	STY	r1H
	
	LDA	#$03
	STA	r2L
	STY	r2H
	
	LDX	#r1
	LDY	#r2
	
	JSR	Ddiv
	
	LDA	r8L
	LSR
	BEQ	@cont0
	
	INC	r1L
	
@cont0:
	LDA	r1L
	ASL
	ASL
	
	LDX	r15H
	STA	GAMECORE + GAMEDATA::CrdCmp0, X
	
@exit:
	RTS


;-------------------------------------------------------------------------------
CardDrawPile:
;	IN	a1	address of card pile 
;		r15H	card pile index
;	USES	r14H	card pile y co-ord
;		r12L	card pile count
;		r12H	card index * 2
;		r13L
;		r13H
;
;	THIS ROUTINE NEEDS OPTIMISATION.  ALWAYS DRAWING WHOLE PILE
;
;-------------------------------------------------------------------------------
	JSR	CardCalcComp
	
	LDA	r15L
	STA	r11L
	
	LDA	#$FF
	STA	r15L
	JSR	CardLoadPileRect
	
	LDA	r11L
	STA	r15L
	
	LDA	r2L
	STA	r14H

	LDA	#$02
	JSR	SetPattern
	
	JSR	Rectangle
	
;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col

	LDA	r15H		;pile index
	STA	r2L
	
	LDA	#$05
	STA	r1L
	
	LDX	#r1
	LDY	#r2
	
	JSR	BBMult
	
	LDA	r1L
	STA	r14L

	LDA	#COLOURCLEAR
	STA	r9L

	LDA	r14H
	LSR
	LSR
	LSR
	STA	r9H
	
	LDA	#$10
	STA	r8L
	
	JSR	CardDrawColour	
	
	LDY	#$00
	LDA	(a1), Y
	BNE	@begin
	
	RTS
	
@begin:
	STA	r12L		;Card pile count

;	Calc card pile x co-ord
	LDA	r15H		;Card pile index

	STA	r2L
	LDA	#$05
	STA	r1L
	
	LDX	#r1
	LDY	#r2
	
	JSR	BBMult
	
	LDA	r1L
	STA	r14L		;Deal pile x co-ord

	LDX	r15H
	LDA	GAMECORE + GAMEDATA::CrdCmp0, X
	BEQ	@toponly
	
	STA	r13H
@loop:
	LDA	#<CardTopBL
	STA	r0L
	LDA	#>CardTopBL
	STA	r0H
	
	LDA	SuitColours0
	STA	r9L

	LDA	r14H
	LSR
	LSR
	LSR
	STA	r9H
	
	LDA	#$01
	STA	r8L
	
	JSR	CardDrawColour

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$02
	STA	r2H
	
	JSR	BitmapUp
	
;	CLC
;	LDA	r14H
;	ADC	#$02
;	STA	r14H
	INC	r14H
	INC	r14H

	DEC	r13H
	BNE	@loop

@toponly:
;	Draw tops
;	LDA	#$01
	LDX	r15H
	LDA	GAMECORE + GAMEDATA::CrdCmp0, X
	TAX
	INX
;	TXA
	STX	r13H

	LDA	r12L
	CMP	r13H 
	BEQ	@last

	TAX
	DEX	
	STX	r13L

@loop0:
	LDY	r13H
	LDA	(a1), Y
	ASL
	TAX

	INC	r13H
	INC	r13L
	
	LDA	CardTops0, X
	STA	r0L
	LDA	CardTops0 + 1, X
	STA	r0H

;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col

	LDA	Cards0, X
	TAX

	LDA	SuitColours0, X
	STA	r9L

	LDA	r14H
	LSR
	LSR
	LSR
	STA	r9H
	
	LDA	#$01
	STA	r8L
	
	JSR	CardDrawColour

	LDA	r14L
	STA	r1L
	LDA	r14H
	STA	r1H

	LDA	#$04
	STA	r2L
	LDA	#$08
	STA	r2H
	
	JSR	BitmapUp
	
	CLC
	LDA	r14H
	ADC	#$08
	STA	r14H
	
	LDA	r13H
	CMP	r12L
	BNE	@loop0

;	Draw last
@last:
	LDY	r12L
	LDA	(a1), Y
	ASL
	
	STA	r12H
	
	LDA	r14H
	LSR
	LSR
	LSR
	PHA
		
	JSR	CardDrawClip

;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col

	LDX	r12H
	LDA	Cards0, X
	TAX

	LDA	SuitColours0, X
	STA	r9L

	PLA
	STA	r9H
	
	LDA	#$06
	STA	r8L
	
	CLC
	LDA	r9H
	ADC	#$06
	CMP	#$19
	BCC	@colour
	
	SEC
	LDA	#$19
	SBC	r9H
	STA	r8L
	
@colour:
	JSR	CardDrawColour

@exit:
	RTS


;-------------------------------------------------------------------------------
CardDrawColour:
;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col
;-------------------------------------------------------------------------------
	LDX	r9H
	LDA	ColourRowsLo0, X
	STA	a2L
	LDA	ColourRowsHi0, X
	STA	a2H
	
	DEC	r8L
@loop0:
	LDA	r9L
	LDY	r14L
	
	LDX	#$03
@loop1:
	STA	(a2), Y
	INY
	DEX
	BPL	@loop1

	CLC
	LDA	a2L
	ADC	#$28
	STA	a2L
	LDA	a2H
	ADC	#$00
	STA	a2H
	
	DEC	r8L
	LDA	r8L
	BPL	@loop0

	RTS
	

;-------------------------------------------------------------------------------
SparPrepSelect:
;-------------------------------------------------------------------------------
	LDA	#$01
	STA	r9L

	LDX	r15H

	CLC
	LDA	r15H
	ADC	#$08
	STA	r15H
	
	LDA	#$00
	STA	r15L
	
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	STA	r13L
	
	RTS


;-------------------------------------------------------------------------------
SparCheckMove:
;-------------------------------------------------------------------------------
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	CMP	#$01
	BNE	@testmulti
	
	LDX	r15H
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	BNE	@nomove
	
	JMP	@canmove
	
@testmulti:
	LDA	GAMECORE + GAMEDATA::SparCnt
	CMP	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	BCS	@canmove
	
@nomove:
	CLC
	RTS
	
@canmove:
	SEC
	RTS


;-------------------------------------------------------------------------------
SparMoveSelect:
;-------------------------------------------------------------------------------
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	STA	r9L
	
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	TAX
	ASL
	TAY
	LDA	CardData0, Y
	STA	a0L
	LDA	CardData0 + 1, Y
	STA	a0H
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDY	#$00
	LDA	(a0), Y
	STA	GAMECORE + GAMEDATA::LastLns, X
	
	SEC
	SBC	r9L
	STA	(a0), Y

	SEC
	LDA	GAMECORE + GAMEDATA::SparCnt
	SBC	r9L
	STA	GAMECORE + GAMEDATA::SparCnt

	LDX	r15H
	
@loop0:
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	BEQ	@begin
	INX
	CPX	#$05
	BNE	@loop0
	LDX	#$00
	JMP	@loop0
	
@begin:
	STX	r7H			;Start spare pile index
	TXA
	
	CLC
	ADC	#$08

	STA	r7L			;Start spare pile index abs

	LDY	GAMECORE + GAMEDATA::CSelect + CSELECT::index
	INY
	STY	r8L			;Source pile index

@loop1:
	LDX	r7L
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDA	(a0), Y
	INY
	
	LDX	r7H
	STA	GAMECORE + GAMEDATA::SparPl0, X

	DEC	r9L
	BEQ	@done

@loop2:
	INX
	INC	r7L
	INC	r7H
	
	CPX	#$05
	BNE	@tstempty
	
	LDX	#$00
	STX	r7H
	LDA	#$08
	STA	r7L
	
@tstempty:
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	BNE	@loop2

	JMP	@loop1
	
@done:
	RTS


;-------------------------------------------------------------------------------
SparLoadPileRect:
;-------------------------------------------------------------------------------
	LDA	r15H
	ASL
	TAX

	LDA	#SPARPLE0_TOP
	STA	r2L		;pile y co-ord

	LDA	#SPARPLE0_BOTTOM
	STA	r2H

	LDA	SparPileLeft0, X
	STA	r3L
	LDA	SparPileLeft0 + 1, X
	STA	r3H

	LDA	SparPileRight0, X
	STA	r4L
	LDA	SparPileRight0 + 1, X
	STA	r4H

	RTS
	
	
;-------------------------------------------------------------------------------
SparDrawPile:
;-------------------------------------------------------------------------------
	LDA	r15H		;Spare pile index
	CLC
	ADC	#$08
	TAX	

	LDA	#$00
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDX	r15H		;Spare pile index
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	
	ASL
	STA	r12H		;Card index * 2


	LDA	#TOPPILES_Y	;y co-ord
	STA	r14H

	LDA	#$05
	STA	r1L
	STX	r2L		;spare pile index
	
	LDX	#r1
	LDY	#r2
	
	JSR	BBMult
	
	LDA	r1L
	STA	r14L		;Spare pile x co-ord

	JSR	CardDraw

;	Draw colour

;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col

	LDX	r15H		;Spare pile index
	LDA	GAMECORE + GAMEDATA::SparPl0, X
	ASL
	TAX
	LDA	Cards0, X
	TAX
	LDA	SuitColours0, X
	STA	r9L

	LDX	#(TOPPILES_Y / 8)
	STX	r9H
	
	LDA	#$06
	STA	r8L
	
	JSR	CardDrawColour

	RTS


;-------------------------------------------------------------------------------
SparDrawAll:
;-------------------------------------------------------------------------------
	LDA	#$00
	STA	r15H
	
@loop0:
	JSR	SparDrawPile
	
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop0

	RTS


;-------------------------------------------------------------------------------
SolvCheckMove:
;-------------------------------------------------------------------------------
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::card
	ASL
	TAX
	
	LDA	Cards0, X
	TAY
	DEY
	CPY	r15H
	BNE	@nomove

	LDA	Cards0 + 1, X
	STA	r9L
	DEC	r9L

	LDX	r15H
	LDA	GAMECORE + GAMEDATA::SolvPl0, X
	ASL
	TAX
	LDA	Cards0 + 1, X
	
	CMP	r9L
	BNE	@nomove
	
	SEC
	RTS
	
@nomove:
	CLC
	RTS


;-------------------------------------------------------------------------------
SolvMoveSelect:
;-------------------------------------------------------------------------------
	LDX	r15H
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::card
	STA	GAMECORE + GAMEDATA::SolvPl0, X

	LDA	r15H
	CLC
	ADC	#$0C
	TAX

	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	TAX
	CMP	#$08
	BCC	@cardpile
	
	SEC
	SBC	#$08
	TAY
	LDA	#$00
	STA	GAMECORE + GAMEDATA::SparPl0, Y
	
	INC	GAMECORE + GAMEDATA::SparCnt
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	RTS
	
@cardpile:
	ASL
	TAY
	LDA	CardData0, Y
	STA	a0L
	LDA	CardData0 + 1, Y
	STA	a0H
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDY	#$00
	LDA	(a0), Y
	STA	GAMECORE + GAMEDATA::LastLns, X
	
	SEC
	SBC	#$01
	STA	(a0), Y

	RTS
	
	
;-------------------------------------------------------------------------------
SolvLoadPileRect:
;-------------------------------------------------------------------------------
	LDA	r15H
	ASL
	TAX

	LDA	#SOLVPLE0_TOP
	STA	r2L		;pile y co-ord

	LDA	#SOLVPLE0_BOTTOM
	STA	r2H

	LDA	SolvPileLeft0, X
	STA	r3L
	LDA	SolvPileLeft0 + 1, X
	STA	r3H

	LDA	SolvPileRight0, X
	STA	r4L
	LDA	SolvPileRight0 + 1, X
	STA	r4H

	RTS


;-------------------------------------------------------------------------------
SolvDrawPile:
;-------------------------------------------------------------------------------
	LDA	r15H		;Solve pile index
	CLC
	ADC	#$0C
	TAX	

	LDA	#$00
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDX	r15H		;Solve pile index
	LDA	GAMECORE + GAMEDATA::SolvPl0, X
	
	ASL
	STA	r12H		;Card index * 2


	LDA	#TOPPILES_Y	;y co-ord
	STA	r14H

	LDA	#$05
	STA	r1L
	
	INX
	INX
	INX
	INX
	
	STX	r2L		;solve pile index
	
	LDX	#r1
	LDY	#r2
	
	JSR	BBMult
	
	LDA	r1L
	STA	r14L		;Solv pile x co-ord

	JSR	CardDraw

;	Draw colour

;	IN	r9L	colour 
;		r9H	top 
;		r8L	row count
;		r14L 	left col

	LDX	r15H		;Solve pile index
	LDA	GAMECORE + GAMEDATA::SolvPl0, X
	ASL
	TAX
	LDA	Cards0, X
	TAX
	LDA	SuitColours0, X
	STA	r9L

	LDX	#(TOPPILES_Y / 8)
	STX	r9H
	
	LDA	#$06
	STA	r8L
	
	JSR	CardDrawColour

	RTS


;-------------------------------------------------------------------------------
SolvDrawAll:
;-------------------------------------------------------------------------------
	LDA	#$00
	STA	r15H
	
@loop0:
	JSR	SolvDrawPile
	
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop0

	RTS


;-------------------------------------------------------------------------------
GameSetSelect:
;		length	.byte
;		pile	.byte
;		index	.byte
;		card	.byte
;		top	.byte
;		bottom	.byte
;		left	.word
;		right	.word
;-------------------------------------------------------------------------------
	LDA	r9L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	
	LDA	r15H
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	
	LDA	r15L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::index
	
	LDA	r13L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::card
	
	LDA	r2L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::top
	LDA	r2H
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::bottom
	LDA	r3L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::left
	LDA	r3H
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::left + 1
	LDA	r4L
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::right
	LDA	r4H
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::right + 1
	
	JSR	InvertRectangle
	
	RTS
	

;-------------------------------------------------------------------------------
GameMakeSelect:
;-------------------------------------------------------------------------------
;	Find if mouse in card pile rect
	LDA	#$00
	STA	r15H
	
@loop0:
	ASL
	TAX

	LDA	CardData0, X
	STA	a1L
	LDA	CardData0 + 1, X
	STA	a1H

	LDY	#$00
	LDA	(a1), Y
	BEQ	@next0

	LDA	#$FF
	STA	r15L

	JSR	CardLoadPileRect
	
	JSR	IsMseInRegion
	CMP	#TRUE
	BNE	@next0
	
	JSR	CardFindMseCard
	BCC	@spare0
	
;	OUT	r13L	card 
;		r13H	length card pile
;		r15L	index
;		r2

;	Check move count
	SEC
	LDA	r13H
	SBC	r15L
	STA	r9L
	
	LDX	GAMECORE + GAMEDATA::SparCnt
	INX
	TXA
	
	CMP	r9L
	BCS	@chkcont0
	
	RTS	
	
@chkcont0:
;	Check contiguous
	JSR	CardCheckContig
	BCS	@select
	
	RTS
	
@select:
;	Store selection
	JSR	GameSetSelect

	RTS
	
@next0:
	INC	r15H
	LDA	r15H
	CMP	#$08
	BNE	@loop0

@spare0:
;	Find if mouse in spare pile rect
	LDA	#$00
	STA	r15H
@loop1:
	JSR	SparLoadPileRect
	
	JSR	IsMseInRegion
	CMP	#TRUE
	BNE	@next1

	JSR	SparPrepSelect
	
	JSR	GameSetSelect
	
	RTS
	
@next1:
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop1

@solv0:
;	TODO
;	Find if mouse in solve pile rect

	RTS
	

;-------------------------------------------------------------------------------
GameMakeTarget:
;-------------------------------------------------------------------------------
;	Find if mouse in card pile rect
	LDA	#$00
	STA	r15H
	
@loop0:
	ASL
	TAX

	LDA	CardData0, X
	STA	a1L
	LDA	CardData0 + 1, X
	STA	a1H

	LDA	#$FF
	STA	r15L

	JSR	CardLoadPileRect
	
	JSR	IsMseInRegion
	CMP	#TRUE
	BNE	@next0
	
;	Check pile can receive cards
	JSR	CardCheckMove
	BCC	@deselect

	JSR	CardMoveSelect
	
@update:
	LDA	#$00
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	
	JSR	GameUpdatePiles
	RTS	
	
@next0:
	INC	r15H
	LDA	r15H
	CMP	#$08
	BNE	@loop0

@spare0:
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::pile
	CMP	#$08
	BCS	@solv0

;	Find if mouse in spare pile rect
	LDA	#$00
	STA	r15H
@loop1:
	JSR	SparLoadPileRect
	
	JSR	IsMseInRegion
	CMP	#TRUE
	BNE	@next1
	
	JSR	SparCheckMove
	BCC	@deselect
	
	JSR	SparMoveSelect
	JMP	@update
	
@next1:
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop1

@solv0:
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::length
	CMP	#$01
	BNE	@deselect

;	Find if mouse in solve pile rect
	LDA	#$00
	STA	r15H
@loop2:
	JSR	SolvLoadPileRect
	
	JSR	IsMseInRegion
	CMP	#TRUE
	BNE	@next2
	
	JSR	SolvCheckMove
	BCC	@deselect
	
	JSR	SolvMoveSelect
	JMP	@update
	
@next2:
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop2

@deselect:
	LDA	#$00
	STA	GAMECORE + GAMEDATA::CSelect + CSELECT::length

	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::top
	STA	r2L
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::bottom
	STA	r2H
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::left
	STA	r3L
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::left + 1
	STA	r3H
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::right
	STA	r4L
	LDA	GAMECORE + GAMEDATA::CSelect + CSELECT::right + 1
	STA	r4H
	
	JSR	InvertRectangle

	RTS
	

;-------------------------------------------------------------------------------
GameUpdatePiles:
;-------------------------------------------------------------------------------
	LDA	#$00
	STA	r15H

@loop0:
	TAX
	ASL
	TAY
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	BPL	@next0

	LDA	#$00
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDA	CardData0, Y
	STA	a1L
	LDA	CardData0 + 1, Y
	STA	a1H

	JSR	CardDrawPile

@next0:
	INC	r15H
	LDA	r15H
	CMP	#$08
	BNE	@loop0
	
	LDA	#$00
	STA	r15H

@loop1:
	CLC
	ADC	#$08
	TAX
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	BPL	@next1

	LDA	#$00
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	JSR	SparDrawPile

@next1:
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop1
	
	LDA	#$00
	STA	r15H

@loop2:
	CLC
	ADC	#$0C
	TAX
	
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	BPL	@next2

	LDA	#$00
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	JSR	SolvDrawPile

@next2:
	INC	r15H
	LDA	r15H
	CMP	#$04
	BNE	@loop2
	
	RTS


;-------------------------------------------------------------------------------
GameInit:
;-------------------------------------------------------------------------------
	JSR	DeckShuffle
;-------------------------------------------------------------------------------
GameStart:
	LDX	#$00
	JSR	BlockProcess
	LDX	#$01
	JSR	BlockProcess

	LDA	GAMECORE + GAMEDATA::AutoEnb
	STA	GAMECORE + GAMEDATA::AutoCan
	
	LDA	#$00
	STA	GameOverFlg0
	STA	GameOverIdx0
	
	LDA	#$04
	STA	GAMECORE + GAMEDATA::SparCnt

	JSR	DeckDeal

	JSR	GameUpdatePiles
	
	LDX	#$00
	JSR	RestartProcess
	LDX	#$01
	JSR	RestartProcess
	
	RTS


;-------------------------------------------------------------------------------
ProcGameOver:
;-------------------------------------------------------------------------------
	LDA	GameOverFlg0
	BNE	@animate
	
	LDA	GAMECORE + GAMEDATA::SolvPl0
	CMP	#CARDKINGD
	BNE	@exit
	
	LDA	GAMECORE + GAMEDATA::SolvPl0 + 1
	CMP	#CARDKINGC
	BNE	@exit
	
	LDA	GAMECORE + GAMEDATA::SolvPl0 + 2
	CMP	#CARDKINGH
	BNE	@exit

	LDA	GAMECORE + GAMEDATA::SolvPl0 + 3
	CMP	#CARDKINGS
	BNE	@exit

	LDA	#$01 
	STA	GameOverFlg0
	LDA	#$00
	STA	GameOverIdx0
	
	LDX	#$00
	JSR	BlockProcess
	
@animate:
;	JSR	GameAnimateOver

@exit:
	RTS
	

;-------------------------------------------------------------------------------
ProcAutoSolve:
;-------------------------------------------------------------------------------
	LDA	GAMECORE + GAMEDATA::AutoCan
	CMP	#TRUE
	BEQ	@begin
	
	RTS

@begin:
	LDA	#$00
	STA	r15H
	
@loop:
	ASL
	TAX
	LDA	CardData0, X
	STA	a1L
	LDA	CardData0 + 1, X
	STA	a1H
	
	LDY	#$00
	LDA	(a1), Y
	
	BEQ	@next
	
	TAY
	LDA	(a1), Y
	
	STA	r13L
	
	ASL
	TAX
	LDA	Cards0, X
	BEQ	@next
	
	STA	r14L
	
	LDA	Cards0 + 1, X
	STA	r14H
	
	LDX	r14L
	DEX
	TXA
	
	CLC
	ADC	#$0C
	STA	r13H
	
	LDA	GAMECORE + GAMEDATA::SolvPl0, X
	ASL
	TAX
	LDA	Cards0 + 1, X
	TAX
	INX
	
	CPX	r14H
	BEQ	@found
	
@next:
	INC	r15H
	LDA	r15H
	CMP	#$08
	BNE	@loop
	
	RTS
	
@found:
	LDY	#$00
	LDA	(a1), Y
	TAX
	DEX
	STX	r15L
	JSR	CardLoadPileRect
	
	JSR	InvertRectangle
	
	LDX	r13H
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X
	
	LDX	r14L
	DEX
	LDA	r13L
	STA	GAMECORE + GAMEDATA::SolvPl0, X

	LDX	r15H
	LDA	GAMECORE + GAMEDATA::DirtyPl, X
	ORA	#$80
	STA	GAMECORE + GAMEDATA::DirtyPl, X

	LDY	#$00
	LDA	(a1), Y
	
	STA	GAMECORE + GAMEDATA::LastLns, X
		
	TAX
	DEX
	TXA
	STA	(a1), Y
	
	JSR	GameUpdatePiles

	RTS
	

;-------------------------------------------------------------------------------
MenuFillColour:
;-------------------------------------------------------------------------------
	LDY	#$00

	LDA	(r0), Y
	LSR
	LSR
	LSR
	STA	r12L			;Top
	
	INY
	LDA	(r0), Y
	LSR
	LSR
	LSR
	STA	r12H			;Bottom
	INC	r12H
	
	INY
	LDA	(r0), Y
	LSR
	LSR
	LSR
	STA	r13L			;Left

	INY
	INY
	LDA	(r0), Y
	LSR
	LSR
	LSR
	STA	r13H			;Right
	INC	r13H
	
	
	LDY	r12L
@loop0:
	LDA	ColourRowsLo0, Y
	STA	a2L
	LDA	ColourRowsHi0, Y
	STA	a2H
	
	LDY	r13L
@loop1:
	LDA	#COLOURCLEAR
	STA	(a2), Y
	INY
	CPY	r13H
	BCC	@loop1
	
	INC	r12L
	LDY	r12L
	CPY	r12H
	BCC	@loop0
	
	RTS


;-------------------------------------------------------------------------------
DoMenuGeos:
;-------------------------------------------------------------------------------
	LDX	#$01
	JSR	BlockProcess
	
	LDA	RecoverFlags0
	ORA	#$01
	STA	RecoverFlags0
		
	LDA	#<MainMenuGeos
	STA	r0L
	LDA	#>MainMenuGeos
	STA	r0H
	
	JSR	MenuFillColour
	RTS


;-------------------------------------------------------------------------------
DoMenuFile:
;-------------------------------------------------------------------------------
	LDX	#$01
	JSR	BlockProcess
	
	LDA	RecoverFlags0
	ORA	#$01
	STA	RecoverFlags0
	
	LDA	#<MainMenuFile
	STA	r0L
	LDA	#>MainMenuFile
	STA	r0H
	
	JSR	MenuFillColour
	RTS


;-------------------------------------------------------------------------------
DoMenuOptions:
;-------------------------------------------------------------------------------
	LDX	#$01
	JSR	BlockProcess
	
	LDA	RecoverFlags0
	ORA	#$01
	STA	RecoverFlags0
	
	LDA	#<MainMenuOptions
	STA	r0L
	LDA	#>MainMenuOptions
	STA	r0H
	
	JSR	MenuFillColour
	RTS


;-------------------------------------------------------------------------------
DoGeosAbout:
;-------------------------------------------------------------------------------
	JSR	GotoFirstMenu
	
;	LDA	#CARDKINGD
;	STA	GAMECORE + GAMEDATA::SolvPl0
;
;	LDA	#CARDKINGC
;	STA	GAMECORE + GAMEDATA::SolvPl0 + 1
;	
;	LDA	#CARDKINGH
;	STA	GAMECORE + GAMEDATA::SolvPl0 + 2
;	
;	LDA	#CARDKINGS
;	STA	GAMECORE + GAMEDATA::SolvPl0 + 3
	
	RTS


;-------------------------------------------------------------------------------
DoFileNew:
;-------------------------------------------------------------------------------
	JSR	GotoFirstMenu

	LDA	#COLOURCLEAR
	JSR	MainFillColour
	
	LoadW	r0, ClearScreen1
	JSR	GraphicsString

	JSR	GameInit
	RTS


;-------------------------------------------------------------------------------
DoFileRestart:
;-------------------------------------------------------------------------------
	JSR	GotoFirstMenu

	LDA	#COLOURCLEAR
	JSR	MainFillColour
	
	LoadW	r0, ClearScreen1
	JSR	GraphicsString
	
	JSR	GameStart
	RTS
	

;-------------------------------------------------------------------------------
DoFileQuit:
;-------------------------------------------------------------------------------
	JSR	GotoFirstMenu
	
	LDA	ColourOrg0
	JSR	MainFillColour
	
	JMP	EnterDeskTop		;return to deskTop!
	

;-------------------------------------------------------------------------------
DoOptionsAuto:
;-------------------------------------------------------------------------------
	JSR	GotoFirstMenu
	
	LDA	GAMECORE + GAMEDATA::AutoEnb
	CMP	#TRUE
	BNE	@turnon
	
	LDA	#FALSE
	STA	GAMECORE + GAMEDATA::AutoEnb
	STA	GAMECORE + GAMEDATA::AutoCan
	
	LDA	#<MainMenuText8a
	STA	MenuAutoText0
	LDA	#>MainMenuText8a
	STA	MenuAutoText0 + 1
	
	RTS
	
@turnon:
	LDA	#TRUE
	STA	GAMECORE + GAMEDATA::AutoEnb
	STA	GAMECORE + GAMEDATA::AutoCan
	
	LDA	#<MainMenuText8
	STA	MenuAutoText0
	LDA	#>MainMenuText8
	STA	MenuAutoText0 + 1

	RTS



;-------------------------------------------------------------------------------
;DATA SECTION
;-------------------------------------------------------------------------------

ClearScreen0:				;graphics string table to clear screen
;-------------------------------------------------------------------------------
	.byte	NEWPATTERN, 2		;set new pattern value
	.byte	MOVEPENTO		;move pen to:
	.word	0			;top left corner of screen
	.byte	0
	.byte	RECTANGLETO		;draw filled rectangle to bottom right corner
	.word	319
	.byte	199
	.byte	NULL			;end of GraphicsString

ClearScreen1:				;graphics string table to clear screen
;-------------------------------------------------------------------------------
	.byte	NEWPATTERN, 2		;set new pattern value
	.byte	MOVEPENTO		;move pen to:
	.word	0			;top left corner of screen
	.byte	$10
	.byte	RECTANGLETO		;draw filled rectangle to bottom right corner
	.word	319
	.byte	199
	.byte	NULL			;end of GraphicsString
	
MainMenu:
;-------------------------------------------------------------------------------
		.byte	$00
		.byte	$0E
		.word	$0000
		.word	$0058
		.byte	03 | HORIZONTAL
		.word	MainMenuText0
		.byte	DYN_SUB_MENU
		.word	DoMenuGeos
		.word	MainMenuText1
		.byte	DYN_SUB_MENU
		.word	DoMenuFile
		.word	MainMenuText2
		.byte	DYN_SUB_MENU
		.word	DoMenuOptions
MainMenuGeos:
;-------------------------------------------------------------------------------
		.byte	$0F
		.byte	$1F
		.word	$0000
		.word	$0027
		.byte	01 | VERTICAL
		.word	MainMenuText4
		.byte	MENU_ACTION
		.word	DoGeosAbout
MainMenuFile:
;-------------------------------------------------------------------------------
		.byte	$0F
		.byte	$3F
		.word	$0018
		.word	$003F
		.byte	03 | VERTICAL
		.word	MainMenuText5
		.byte	MENU_ACTION
		.word	DoFileNew
		.word	MainMenuText6
		.byte	MENU_ACTION
		.word	DoFileRestart
		.word	MainMenuText7
		.byte	MENU_ACTION
		.word	DoFileQuit
MainMenuOptions:
;-------------------------------------------------------------------------------
		.byte	$0F
		.byte	$1F
		.word	$0030
		.word	$007F
		.byte	01 | VERTICAL
MenuAutoText0:
		.word	MainMenuText8
		.byte	MENU_ACTION
		.word	DoOptionsAuto

MainMenuText0:
		.byte	"geos", $00
MainMenuText1:
		.byte	"file", $00
MainMenuText2:
		.byte	"options", $00
MainMenuText4:
		.byte	"about", $00
MainMenuText5:
		.byte	"new", $00
MainMenuText6:
		.byte	"restart", $00
MainMenuText7:
		.byte	"quit", $00
MainMenuText8:
		.byte	"auto solve: on", $00
MainMenuText8a:
		.byte	"auto solve: off", $00


CardPileLeft0:
		.word	CARDPLE0_LEFT
		.word	CARDPLE1_LEFT
		.word	CARDPLE2_LEFT
		.word	CARDPLE3_LEFT
		.word	CARDPLE4_LEFT
		.word	CARDPLE5_LEFT
		.word	CARDPLE6_LEFT
		.word	CARDPLE7_LEFT
		
CardPileRight0:
		.word	CARDPLE0_RIGHT
		.word	CARDPLE1_RIGHT
		.word	CARDPLE2_RIGHT
		.word	CARDPLE3_RIGHT
		.word	CARDPLE4_RIGHT
		.word	CARDPLE5_RIGHT
		.word	CARDPLE6_RIGHT
		.word	CARDPLE7_RIGHT

SolvPileLeft0:
		.word	SOLVPLE0_LEFT
		.word	SOLVPLE1_LEFT
		.word	SOLVPLE2_LEFT
		.word	SOLVPLE3_LEFT
		
SolvPileRight0:
		.word	SOLVPLE0_RIGHT
		.word	SOLVPLE1_RIGHT
		.word	SOLVPLE2_RIGHT
		.word	SOLVPLE3_RIGHT
		
SparPileLeft0:
		.word	SPARPLE0_LEFT
		.word	SPARPLE1_LEFT
		.word	SPARPLE2_LEFT
		.word	SPARPLE3_LEFT
		
SparPileRight0:
		.word	SPARPLE0_RIGHT
		.word	SPARPLE1_RIGHT
		.word	SPARPLE2_RIGHT
		.word	SPARPLE3_RIGHT
		
CardKings0:
		.byte	CARDKINGD
		.byte	CARDKINGC
		.byte	CARDKINGH
		.byte	CARDKINGS

CardEmpty0:
		.byte	0
		.byte	13
		.byte	26
		.byte	39

ColourRowsLo0:
		.byte	<$8C00, <$8C28, <$8C50, <$8C78, <$8CA0
		.byte	<$8CC8, <$8CF0, <$8D18, <$8D40, <$8D68
		.byte 	<$8D90, <$8DB8, <$8DE0, <$8E08, <$8E30
		.byte	<$8E58, <$8E80, <$8EA8, <$8ED0, <$8EF8
		.byte	<$8F20, <$8F48, <$8F70, <$8F98, <$8FC0
		
ColourRowsHi0:
		.byte	>$8C00, >$8C28, >$8C50, >$8C78, >$8CA0
		.byte	>$8CC8, >$8CF0, >$8D18, >$8D40, >$8D68
		.byte 	>$8D90, >$8DB8, >$8DE0, >$8E08, >$8E30
		.byte	>$8E58, >$8E80, >$8EA8, >$8ED0, >$8EF8
		.byte	>$8F20, >$8F48, >$8F70, >$8F98, >$8FC0


;-------------------------------------------------------------------------------
	.include	"cards.inc"
;-------------------------------------------------------------------------------


CardPiles0:
;-------------------------------------------------------------------------------
	.repeat (.sizeof(CARDPILE) * 8), I
		.byte	$00
	.endrep

CardData0:
;-------------------------------------------------------------------------------
	.word	CardPiles0
	.word	CardPiles0 + .sizeof(CARDPILE)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 2)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 3)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 4)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 5)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 6)
	.word	CardPiles0 + (.sizeof(CARDPILE) * 7)


RecoverFlags0:
;-------------------------------------------------------------------------------
		.byte	$00
		
GameOverFlg0:
;-------------------------------------------------------------------------------
		.byte	$00

GameOverIdx0:
;-------------------------------------------------------------------------------
		.byte	$00
		

ColourOrg0:
;-------------------------------------------------------------------------------
		.byte	$BF

FlipCount0:
;-------------------------------------------------------------------------------
		.byte	$03

ProcessData0:
;-------------------------------------------------------------------------------
	.word	ProcAutoSolve
	.word	$1E
	.word	ProcGameOver
	.word	$1E


DeckData0:
;-------------------------------------------------------------------------------
	.repeat (52), I
		.byte	$00
	.endrep
	
SpareData0:
;-------------------------------------------------------------------------------
	.repeat (24), I
		.byte	$00
	.endrep


Heap0:


