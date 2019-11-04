.include "convenience.asm"
.include "game_settings.asm"

.globl player_location_array

.data
player_location_array:  
		       .word 30
		       .word 45

.text
.globl move_player
#a0 is 
move_player:
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3
	push	s4
	j	move_player_left	
move_player_left:
	lw	s0, left_pressed
	beq	s0, zero, move_player_right
	la	s1, player_location_array
	lw	s2, (s1)
	#subi	s4, s2, 1
	lw	s3, 4(s1)
	move	a0, s2
	subi	a0, a0, 1
	move	a1, s3
	jal	check_platform
	bne	v0, zero, move_player_exit
	ble	s2, BOARD_OFFSET, move_player_exit
	subi	s2, s2, 1
	sw	s2, (s1)
move_player_right:
	lw	s0, right_pressed
	beq	s0, zero, move_player_exit
	la	s1, player_location_array
	lw	s2, (s1)	#x coordinate
	move	a0, s2
	addi	a0, a0, 5
	lw	a1, 4(s1)	#y coordinate in a1
	jal	check_platform
	bne	v0, zero, move_player_exit
	li	s3, BOARD_WIDTH
	subi	s4, s3, BOARD_OFFSET
	subi	s4, s4, SPRITE_WIDTH
	bge	s2, s4, move_player_exit
	addi	s2, s2, 1
	sw	s2, (s1)
#move_player_up:

 
#move_player_down:

move_player_exit:
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	
	jr	ra 
