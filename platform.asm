.include "convenience.asm"
.include "game_settings.asm"

.eqv	BOARD_SIZE		132

.data
#plat_row:	  .word 0
#plat_col:	  .word 0
platform_img:     .byte
    		2  3  2  3  3
		3  2  2  3  2
		2  3  2  3  2
		3  2  2  3  3
		3  2  3  2  2
plat_matrix:	  .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		   	0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0
		  	0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0
		  	0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		  	0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
		  	0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0
		  	0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0
		  	0, 0, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0
		  	0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
		  	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
		  	1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
.text
.globl draw_platform
draw_platform:
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3
	push	s4
	li	s0, 0
	la	s1, plat_matrix
platform_loop:
	bge	s0, BOARD_SIZE, draw_platform_exit
	lw	s4, (s1)
	#print_string space
	#print_int s0
	#print_string comma
	#print_int s4
	li	t2, 1
	beq	s4, t2, add_platform
	inc	s0
	#mul	t1, s0, 4
	addi	s1, s1, 4
	j	platform_loop
add_platform:
	li	t3, 12
	#li	t4, 12
	div	s0, t3
	mfhi	s2	#column
	mul	s2, s2, 5
	addi	a0, s2, 2
	div	s0, t3
	mflo	s3	#row
	mul	a1, s3, 5
	#print_string space
	#print_int s2
	#print_string space
	#print_int s3
	#print_string space
	#move	a0, s2
	#move	a1, s3
	la	a2, platform_img
	jal	display_blit_5x5
	inc	s0
	#mul	t1, s0, 4
	addi	s1, s1, 4
	j	platform_loop
draw_platform_exit:
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	jr	ra

.globl check_platform
check_platform:
#getting x and y coordinates, changing to (column,row), and outputting 1 or 0 if platform is or isn't in that spot
#get coordinates as a0 (x) and a1 (y)
	push	ra
	push	s0
	push	s1
	push	s2
	push	s3
	push	s4
#subtract a0 by 2 (OFFSET)
#divide a0 by 5 (PLAYER_WIDTH) and get mflo value = column
	subi	s0, a0, 2
	li	s1, SPRITE_WIDTH
	div	s0, s1
	mflo	s0
#divide a1 by 5 (PLAYER_WIDTH)	and get mflo value = row
	div	a1, s1
	mflo	s2
#addr(row,col) = matrix + (row*48) + (col*4)
	la	s3, plat_matrix
	mul	s2, s2, 48
	mul	s0, s0, 4
	add	s3, s3, s2
	add	s3, s3, s0
#lw from found address and return it in v0
	lw	s4, (s3)
	move	v0, s4
#exit	
	pop	s4
	pop	s3
	pop	s2
	pop	s1
	pop	s0
	pop	ra
	
	jr	ra
