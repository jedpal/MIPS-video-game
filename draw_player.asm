.include "convenience.asm"
.include "game_settings.asm"

.globl player_img

.data
player_img:       .byte
    		0  0  7  0  0
		7  7  4  7  7
		0  4  4  4  0
		0  7  7  7  0
		0  7  0  7  0
.text

.globl draw_player
draw_player:
	push	ra
	la	t0, player_location_array
	lw	a0, (t0)
	addi	t0, t0, 4
	lw	a1, (t0)
	la	a2, player_img 
	jal	display_blit_5x5_trans
	jal	display_update_and_clear
draw_player_exit:
	pop	ra
	jr	ra
