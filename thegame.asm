# jep168
# Jedaiah Palmer

.include "convenience.asm"
.include "game_settings.asm"


#	Defines the number of frames per second: 16ms -> 60fps
.eqv	GAME_TICK_MS		16
#.eqv	LIVES			3
.globl	lives

.data
# don't get rid of these, they're used by wait_for_next_frame.
last_frame_time:  .word 0
frame_counter:    .word 0

space:		   .asciiz " "
comma:		   .asciiz ","
lives:		   .word 3
game_over_text:    .asciiz "Game Over"
score_text:	   .asciiz "Score:"


.text
# --------------------------------------------------------------------------------------------------

.globl game
game:
	# set up anything you need to here,
	# and wait for the user to press a key to start.
	jal	display_lives
	jal	draw_platform
	jal	draw_player
	jal	draw_enemies
	
	# Wait for a key input
_game_wait:
	jal	input_get_keys
	beqz	v0, _game_wait
	
_game_loop:
	# check for input,
	jal     handle_input
	
	# update everything,
	jal	move_player
	jal	move_enemy
	jal	shoot
	
	# draw everything
	jal	display_lives
	jal	draw_platform
	jal	draw_player
	jal	draw_shoot
	#jal	move_enemy
	jal	draw_enemies
	
	jal	display_update_and_clear

	## This function will block waiting for the next frame!
	jal	wait_for_next_frame
	b	_game_loop

.globl _game_over
_game_over:
	li	a0, 1
	li	a1, 1
	la	a2, game_over_text
	jal	display_draw_text
	li	a0, 1
	li	a1, 11
	la	a2, score_text
	jal	display_draw_text
	li	a0, 30
	li	a1, 30
	lw	a2, score
	jal	display_draw_int
	
	jal	display_update_and_clear
	exit

.globl display_lives
display_lives:
	push	ra
	push	s0 
	push	s1
	li	s0, 55		#x coordinate start
	li	s1, 0		#count
display_lives_loop:
	la	t0, lives
	lw	t1, (t0)
	bge	s1, t1, display_lives_exit
	move	a0, s0
	li	a1, 58
	la	a2, player_img
	jal	display_blit_5x5_trans
	inc	s1
	addi	s0, s0, -6
	j	display_lives_loop
display_lives_exit:
	pop	s1
	pop	s0
	pop	ra
	jr	ra

# --------------------------------------------------------------------------------------------------
# call once per main loop to keep the game running at 60FPS.
# if your code is too slow (longer than 16ms per frame), the framerate will drop.
# otherwise, this will account for different lengths of processing per frame.
.globl wait_for_next_frame
wait_for_next_frame:
	enter	s0
	lw	s0, last_frame_time
_wait_next_frame_loop:
	# while (sys_time() - last_frame_time) < GAME_TICK_MS {}
	li	v0, 30
	syscall # why does this return a value in a0 instead of v0????????????
	sub	t1, a0, s0
	bltu	t1, GAME_TICK_MS, _wait_next_frame_loop

	# save the time
	sw	a0, last_frame_time

	# frame_counter++
	lw	t0, frame_counter
	inc	t0
	sw	t0, frame_counter
	leave	s0

# --------------------------------------------------------------------------------------------------
