
```
 DevPac Developer assembler options                                                    Rmac Equivalent
 ----------------------------------                                                    ---------------

 01+ will optimise backward branches to short if within range,                         o0?
 can be disabled with 01-.
 
 02+ will optimise address register indirect with displacement                         o3?
 addressing modes to address register indirect, if the
 displacement evaluates to zero. It can be disabled with
 02-. For example move.1 next(a0),d3 will be optimised to move.1 (a0),d3
 if the value of next is zero.
 
 03+ will optimise absolute addresses to short-word addressing                         o0
 if in the signed 32 bit range $FFFF8000 to $7FFF
 inclusive.
 
 04+ will optimise instructions of the form MOVE.L #x, dn to                           
 MOVEQ if x is in the range -128 to 127 inclusive.
 
 05+ ADD #x and SUB #x instructions will be optimised to                              o8
 quick forms if x is in the range 1 - 8 inclusive.
 
 06+ not strictly an optimisation; a warning will be issued for                       None
 each forward branch that could be made short; this must
 be used in conjunction with option type 1.
 
 07+ convert BRA.S to next instruction to NOP; note that this                         o6
 instruction is not possible on the 680x0, so an error will
 be issued if this attempted without this optimisation.
 
 08+ will optimise 68020 base displacements to the short form                         o5
 addressing if in the signed 32 bit range $FFFF8000 to
 $7FFF inclusive.
 
 09+ will optimise 68020 outer displacements to the short form                        o5?
 addressing if in the signed 32 bit range $FFFF8000 to
 $7FFF inclusive.
 
 010+ will optimise ADD #x,An and SUB #x,An instructions to                           o9 (but no SUB?)
 LEA x(An),An or LEA -x(An),An if this is possible but
 not in the case when an ADDQ/SUBQ instruction is
 preferable. This option is normally used in conjunction
 with 05+.
 
 011+ will optimise LEA x(An),An or LEA -X(An),An                                     o4
 instructions to ADDQ.W #x,An and SUBQ.W #x,An if
 this is possible.
 
 012+ will optimise MOVE.L #x,An to MOVE.W #x,An if                                   o10?
 possible and if another optimisation has not been
 performed. This also optimises the correspond ADD, SUB
 and CMP instructions.
```
