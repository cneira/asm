
; generate<QUIET_CHECKS> generates all pseudo-legal non-captures and knight
; underpromotions that give check. Returns a pointer to the end of the move list.


		      align  16
Gen_QuietChecks:
		       push   rsi r12 r13 r14 r15

			mov   r15, qword [rbp+Pos.typeBB+8*White]
			 or   r15, qword [rbp+Pos.typeBB+8*Black]

			mov   r14, qword [rbx+State.dcCandidates]
		       test   r14, r14
			 jz   .PopLoopDone
.PopLoop:
			bsf   r13, r14
		      _blsr   r14, r14, rax
		      movzx   r12d, byte[rbp+Pos.typeBB+r13]
			and   r12d, 7
			jmp   qword [Gen_QuietChecks_JmpTable+8*r12]
.AttacksFromRet:
			shl   r13d, 6
		       test   rsi, rsi
			 jz   .MoveLoopDone
 .MoveLoop:
			bsf   rax, rsi
			 or   eax, r13d
			mov   dword [rdi], eax
			lea   rdi, [rdi+8]
		      _blsr   rsi, rsi, rdx
			jnz   .MoveLoop
 .MoveLoopDone:


.PopSkip:
		       test   r14, r14
			jnz   .PopLoop

.PopLoopDone:
			not   r15
			mov   r14, qword[rbp+Pos.typeBB+8*White]
			 or   r14, qword[rbp+Pos.typeBB+8*Black]
			cmp   byte [rbp+Pos.sideToMove], 0
			jne   Gen_QuietChecks_Black

		      align   8
Gen_QuietChecks_White:
	       generate_all   White, QUIET_CHECKS
			pop   r15 r14 r13 r12 rsi
			ret
	       generate_jmp   White, QUIET_CHECKS

		      align   8
Gen_QuietChecks_Black:
	       generate_all   Black, QUIET_CHECKS
			pop   r15 r14 r13 r12 rsi
			ret
	       generate_jmp   Black, QUIET_CHECKS





Gen_QuietChecks_Jmp:
		      align   8
.AttacksFromKnight:
			mov   rsi, qword [KnightAttacks+8*r13]
		      _andn   rsi, r15, rsi
			jmp   Gen_QuietChecks.AttacksFromRet

		      align   8
.AttacksFromKing:
			mov   rsi, qword [KingAttacks+8*r13]
		      _andn   rsi, r15, rsi
		      movzx   ecx, byte [rbx+State.ksq]
			mov   rax, qword [RookAttacksPDEP+8*rcx]
			 or   rax, qword [BishopAttacksPDEP+8*rcx]
		      _andn   rsi, rax, rsi
			jmp   Gen_QuietChecks.AttacksFromRet

		      align   8
.AttacksFromBishop:
	      BishopAttacks   rsi, r13, r15, rax
		      _andn   rsi, r15, rsi
			jmp   Gen_QuietChecks.AttacksFromRet

		      align   8
.AttacksFromRook:
		RookAttacks   rsi, r13, r15, rax
		      _andn   rsi, r15, rsi
			jmp   Gen_QuietChecks.AttacksFromRet

		      align   8
.AttacksFromQueen:
	      BishopAttacks   rsi, r13, r15, rax
		RookAttacks   rdx, r13, r15, rax
			 or   rsi, rdx
		      _andn   rsi, r15, rsi
			jmp   Gen_QuietChecks.AttacksFromRet


