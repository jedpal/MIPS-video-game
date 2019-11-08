.include "convenience.asm"
.include "game_settings.asm"

.eqv ENEMIES 5

.data
enemy_array:	#activated, direction, x coord, y coord
		.word 1, 0, 25, 5, 1, 1, 30, 5, 1, 0, 20, 35, 1, 1, 15, 45, 1, 0, 25, 45
		
enemy_counter:	.word 0	
draw_enemy_counter: .word 0	
		
enemy_img:       .byte
    	    0xFF 0xFF 7 0xFF 0xFF
		7  7  3  7  7
	    0xFF   3  3  3  0xFF
	    0xFF   7  7  7  0xFF
	    0xFF   7 0xFF 7 0xFF

.text
.globl move_enemy 
move_enemy:
	push	ra
	push	s0
	push	s1
	push	s2
	
	li	s2, 0
move_enemy_loop:
#check if end of array (5 enemies), if so, go to exit
	#la	t0, enemy_counter
	#lw	s2, (t0)	#counter
	li	t2, ENEMIES
	bge	s2, t2, move_enemy_exit
#check if active, if not, go to next enemy in array
	la	s0, enemy_array
	mul	t4, s2, 16
	add	s1, t4, s0	#activated address
#check if hit by projectile
	lw	t5, (s1)
	beq	t5, zero, check_active_enemy
	la	t5, projectile_activated
	lw	t6, (t5)	
	beq	t6, zero, check_active_enemy
	la	t0, projectile_coords
	lw	t1, 8(s1)	#enemy x
	lw	t2, 12(s1)	#enemy y
	lw	t3, (t0)	#projectile x
	lw	t4, 4(t0)	#projectile y
	sub	t3, t3, t1
	sub	t4, t4, t2
	bge	t3, 5, check_active_enemy	#only pass if within 5 x and y coords
	blt	t3, zero, check_active_enemy
	bge	t4, 5, check_active_enemy
	blt	t4, zero, check_active_enemy
	la	t5, projectile_activated
	li	t6, 0
	sw	t6, (t5)
	sw	t6, (s1)
#continuing checking if active
check_active_enemy:
	lw	t5, (s1)	#activated value

	addi	s2, s2, 1		#incrementing counter
	#sw	s2, (t0)
	beq	t5, zero, move_enemy_loop
#check direction enemy is travelling, and go to move_enemy_left or move_enemy_left
	addi	t6, s1, 4	#direction address
	lw	t7, (t6)
	beq	t7, zero, move_enemy_left
	bne	t7, zero, move_enemy_right
move_enemy_left:
#set direction value to 0
	li	t0, 0
	addi	t1, s1, 4
	sw	t0, (t1)
#check if hitting wall, and if so, go to right
	li	t5, 2
	lw	a0, 8(s1)
	lw	a1, 12(s1)
	ble	a0, t5, move_enemy_right
	jal	check_platform
	bne	v0, zero, move_enemy_right
#move enemy left
	lw	t2, 8(s1)
	subi	t2, t2, 1
	sw	t2, 8(s1)
#jump to move_enemy
	j	move_enemy_loop
move_enemy_right:
#set direction value to 1
	li	t0, 1
	addi	t1, s1, 4
	sw	t0, (t1)
#check if hitting wall, and if so, go to left
	li	t5, 61
	lw	a0, 8(s1)
	addi	a0, a0, 4
	lw	a1, 12(s1)
	bge	a0, t5, move_enemy_left
	jal	check_platform
	bne	v0, zero, move_enemy_left
#move enemy right
	lw	t2, 8(s1)
	addi	t2, t2, 1
	sw	t2, 8(s1)
#jump to move_enemy
	j	move_enemy_loop
move_enemy_exit:
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra

.globl draw_enemies
draw_enemies:
	push	ra
	push	s0
	push	s1
	push	s2
	
	li	s2, 0
draw_enemies_loop:
#check if end of array (5 enemies), if so, go to exit
	#la	t0, draw_enemy_counter
	#lw	s2, (t0)	#counter
	li	t2, ENEMIES
	bge	s2, t2, draw_enemy_exit
#check if active, if not, go to next enemy in array
	la	s0, enemy_array
	mul	t4, s2, 16
	add	s1, t4, s0	#activated address
	lw	t5, (s1)	#activated value

	addi	s2, s2, 1		#incrementing counter
	#sw	s2, (t0)
	beq	t5, zero, draw_enemies_loop
	j	actually_draw
actually_draw:
	lw	a0, 8(s1)
	lw	a1, 12(s1)
	la	a2, enemy_img
	jal	display_blit_5x5_trans
	j	draw_enemies_loop
draw_enemy_exit:
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra