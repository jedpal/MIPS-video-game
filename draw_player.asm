.include "convenience.asm"
.include "game_settings.asm"

.globl player_img
.globl hurt

.eqv HURT_DURATION 70

.data
hurt:		.word 0
sho_no_sho:	.word 0
hurt_counter:	.word 0
player_img:       .byte
    	    0xFF 0xFF 7 0xFF 0xFF
		7  7  4  7  7
	    0xFF   4  4  4  0xFF
	    0xFF   7  7  7  0xFF
	    0xFF   7 0xFF 7 0xFF
.text

.globl draw_player
draw_player:
	push	ra
	la	t1, hurt
	lw	t2, (t1)
	bne	t2, zero, draw_player_hurt
	la	t0, player_location_array
	lw	a0, (t0)
	addi	t0, t0, 4
	lw	a1, (t0)
	la	a2, player_img 
	jal	display_blit_5x5_trans
	#jal	display_update_and_clear
	j	draw_player_exit
draw_player_hurt:
	la	t2, hurt_counter
	lw	t3, (t2)
	li	t4, HURT_DURATION
	bge	t3, t4, end_hurt
	la	t0, sho_no_sho
	lw	t1, (t0)
	li	t2, 10
	div	t1, t2
	mfhi	t3
	addi	t1, t1, 1
	sw	t1, (t0)
	la	t5, hurt_counter
	lw	t6, (t5)
	addi	t6, t6, 1
	sw	t6, (t5)
	beq	t3, zero, draw_player_exit
	la	t4, player_location_array
	lw	a0, (t4)
	addi	t4, t4, 4
	lw	a1, (t4)
	la	a2, player_img 
	jal	display_blit_5x5_trans
	j	draw_player_exit
end_hurt:
	la	t0, hurt_counter
	li	t1, 0
	sw	t1, (t0)
	la	t2, hurt
	li	t3, 0
	sw	t3, (t2)
	j	draw_player_exit
draw_player_exit:
	pop	ra
	jr	ra
