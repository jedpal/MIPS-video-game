.include "convenience.asm"
.include "game_settings.asm"

.globl projectile_coords
.globl projectile_activated

.data
projectile_coords:
			.word 0	#x coord
			.word 0	#y coord
			.word 0 #direction
projectile_activated:	.word 0

.text
.globl shoot
shoot:
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3

	la	t1, projectile_activated
	lw	t2, (t1)
	bne	t2, zero, activated

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
	la	t1, projectile_coords
	sw	t0, 8(t1)
	beq	t0, zero, shoot_left
	#positioning projectile to right side before calling shoot_right
	la	s4, projectile_coords
	lw	s1, (s4)			#x coordinate of projectile
	lw	s2, 4(s4)
	addi	s1, s1, 5
	
	bne	t0, zero, shoot_right
activated:
	la	t1, projectile_coords
	lw	t0, 8(t1)
	beq	t0, zero, shoot_left
	bne	t0, zero, shoot_right	
	#check if block in front
shoot_right:
	la	t5, projectile_activated
	li	t4, 1
	sw	t4, (t5)
	
	la	s4, projectile_coords
	lw	s1, (s4)			#x coordinate of projectile
	lw	s2, 4(s4)
	
	#addi	s1, s1, 5
shoot_right_loop:
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 1
	jal	check_platform
	bne	v0, zero, shoot_deactivate
	li	t1, 62
	bge	s1, t1, shoot_deactivate
	
	addi	s1, s1, 2
	sw	s1, (s4)
	j	shoot_exit
shoot_left:
	la	t5, projectile_activated
	li	t4, 1
	sw	t4, (t5)
	
	la	s4, projectile_coords
	lw	s1, (s4)			#x coordinate of projectile
	lw	s2, 4(s4)
shoot_left_loop:
	move	a0, s1
	move	a1, s2
	addi	a1, a1, 1
	jal	check_platform
	bne	v0, zero, shoot_deactivate
	li	t1, 1
	ble	s1, t1, shoot_deactivate
	
	subi	s1, s1, 2
	sw	s1, (s4)
	j	shoot_exit
shoot_deactivate:
	li	t1, 0
	la	t0, projectile_activated
	sw	t1, (t0)
	j	shoot_exit

shoot_exit:
	#la	t5, projectile_activated
	#li	t4, 0
	#sw	t4, (t5)
	
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra
	
.globl draw_shoot
draw_shoot:
	push	ra
	la	t1, projectile_activated
	lw	t2, (t1)
	beq	t2, zero, draw_shoot_exit
	
	la	t0, projectile_coords
	lw	a0, (t0)
	lw	a1, 4(t0)
	#move	a0, s1
	#move	a1, s2
	#addi	a1, a1, 1			#positioning projectile at hand
	li	a2, 2				#color
	jal	display_set_pixel
draw_shoot_exit:
	pop	ra
	jr	ra
