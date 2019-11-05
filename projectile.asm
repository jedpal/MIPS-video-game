.include "convenience.asm"
.include "game_settings.asm"

.globl projectile_coords

.data
projectile_coords:
			.word 0
			.word 0

.text
.globl shoot
shoot:
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3

	lw	s3, action_pressed
	beq	s3, zero, shoot_exit
	la	s0, player_location_array
	lw	s1, (s0)			#x coordinate of player
	lw	s2, 4(s0)			#y coordinate of player
	
	la	s4, projectile_coords
	sw	s1, (s4)			#coords of projectile
	addi	s2, s2, 1			#positioning projectile at hand
	sw	s2, 4(s4)
	lw	t0, direction
	beq	t0, zero, shoot_left_loop
	bne	t0, zero, shoot_right
	#check if block in front
shoot_right:
	addi	s1, s1, 4
shoot_right_loop:
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 1
	jal	check_platform
	bne	v0, zero, shoot_exit
	li	t1, 62
	bge	s1, t1, shoot_exit
	move	a0, s1
	move	a1, s2
	#addi	a1, a1, 1			#positioning projectile at hand
	li	a2, 2				#color
	jal	display_set_pixel
	#jal	move_player
	jal	display_lives
	jal	draw_platform
	jal	draw_player
	jal	display_update_and_clear
	jal	wait_for_next_frame
	addi	s1, s1, 2
	sw	s1, (s4)
	j	shoot_right_loop
shoot_left_loop:
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 1
	jal	check_platform
	bne	v0, zero, shoot_exit
	li	t1, 1
	ble	s1, t1, shoot_exit
	move	a0, s1
	move	a1, s2
	#addi	a1, a1, 1			#positioning projectile at hand
	li	a2, 2				#color
	jal	display_set_pixel
	#jal	move_player
	jal	display_lives
	jal	draw_platform
	jal	draw_player
	jal	display_update_and_clear
	jal	wait_for_next_frame
	subi	s1, s1, 2
	sw	s1, (s4)
	j	shoot_left_loop
shoot_exit:
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra