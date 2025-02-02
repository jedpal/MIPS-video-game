.include "convenience.asm"
.include "game_settings.asm"

.globl player_location_array
.globl direction

.eqv	JUMP_HEIGHT	15

.data
mid_jump:		.word 0
player_location_array:  
		       .word 12
		       .word 15
direction:	.word 0
#30, 45
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
	
	la	t6, direction
	li	t7, 0		#direction for projectile
	sw	t7, (t6)
	
	la	s1, player_location_array
	lw	s2, (s1)
	#subi	s4, s2, 1
	lw	s3, 4(s1)
	move	a0, s2
	subi	a0, a0, 1
	move	a1, s3
	jal	check_platform
	move	s5, v0
	
	lw	a0, (s1)	#x coordinate
	#move	a0, s2
	subi	a0, a0, 1
	lw	a1, 4(s1)
	addi	a1, a1, 4	#bottom left
	jal	check_platform
	bne	v0, zero, move_player_right
	bne	s5, zero, move_player_right
	ble	s2, BOARD_OFFSET, move_player_right
	subi	s2, s2, 1
	sw	s2, (s1)
move_player_right:
	lw	s0, right_pressed
	beq	s0, zero, move_player_up
	
	la	t6, direction
	li	t7, 1		#direction for projectile
	sw	t7, (t6)
	
	la	s1, player_location_array
	lw	s2, (s1)	#x coordinate
	move	a0, s2
	addi	a0, a0, 5
	lw	a1, 4(s1)	#y coordinate in a1
	jal	check_platform
	move	s5, v0
	
	lw	a0, (s1)	#x coordinate
	#move	a0, s2
	addi	a0, a0, 5
	lw	a1, 4(s1)
	addi	a1, a1, 4	#bottom right
	jal	check_platform
	bne	v0, zero, move_player_up
	bne	s5, zero, move_player_up
	li	s3, BOARD_WIDTH
	subi	s4, s3, BOARD_OFFSET
	subi	s4, s4, SPRITE_WIDTH
	bge	s2, s4, move_player_up
	addi	s2, s2, 1
	sw	s2, (s1)
move_player_up:
	la	t2, mid_jump
	lw	t3, (t2)	#checking if mid jump
	bne	t3, zero, jump_loop
	
	lw	s0, up_pressed
	beq	s0, zero, move_player_down
	
	la	t0, mid_jump
	li	t1, 1		#marking that player is mid jump
	sw	t1, (t0)
	
	la	s0, player_location_array
	lw	s1, (s0)	#x coordinate
	lw	s2, 4(s0)	#y coordinate
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 5
	jal	check_platform
	move	s3, v0		#left side bottom
	addi	a0, s1, 4
	move	a1, s2
	addi	a1, a1, 5
	jal	check_platform
	move	s4, v0		#right side bottom
	bne	s3, zero, jump
	bne	s4, zero, jump
	j	move_player_down
jump:				#CHECK FOR UPPER OUT OF BOUNDS
	lw	s1, (s0)	#x coordinate
	lw	s2, 4(s0)	#y coordinate
	
	
	li	s5, 0
jump_loop:
	la	s0, player_location_array
	lw	s1, (s0)	#x coordinate
	lw	s2, 4(s0)

	move	a0, s1
	move	a1, s2
	subi	a1, a1, 1
	jal	check_platform
	move	s3, v0		#left side top	
	addi	a0, s1, 4
	move	a1, s2
	subi	a1, a1, 1
	jal	check_platform
	move	s4, v0		#right side top
	bne	s3, zero, move_player_down
	bne	s4, zero, move_player_down

	li	t0, JUMP_HEIGHT
	bge	s5, t0, move_player_down
	ble	s2, zero, move_player_down
	subi	s2, s2, 1
	
	sw	s2, 4(s0)
	#lw	a0, (s0)
	#lw	a1, 4(s0)
	#la	a2, player_img
	#jal	display_blit_5x5_trans
	#jal	display_lives
	#jal	draw_platform
	#jal	draw_player
	#jal	display_update_and_clear
	#jal	wait_for_next_frame
	inc	s5
	j	move_player_exit
move_player_down:
	la	t0, mid_jump
	li	t1, 0
	sw	t1, (t0)
	la	s0, player_location_array
	lw	s1, (s0)	#x coordinate
	lw	s2, 4(s0)	#y coordinate
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 5
	jal	check_platform
	move	s3, v0		#left side
	addi	s1, s1, 4
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 5
	jal	check_platform
	move	s4, v0		#right side
	bne	s3, zero, move_player_exit
	bne	s4, zero, move_player_exit
	addi	s2, s2, 1
	sw	s2, 4(s0)
move_player_exit:
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	
	jr	ra 
