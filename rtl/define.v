`define BIU_REQQ_SIZE 8
`define BIU_RESPQ_SIZE 8
`define SCOREBOARD_SIZE 4
`define SCOREBOARD_SIZE_WIDTH 2

`define CSR_RW                          2'b01
`define CSR_RS                          2'b10
`define CSR_RC                          2'b11
`define CSR_IMM                         1'b1


`define MDU_DIV                         1'b1
`define MUL                             3'b000
`define MULH                            3'b001
`define MULHSU                          3'b010
`define MULHU                           3'b011
`define DIV                             3'b100
`define DIVU                            3'b101
`define REM                             3'b110
`define REMU                            3'b111

`define INST_SLOT_SIZE                  32

`define NORMAL                          4'b0000
`define NOP                             4'b0001
`define SSNOP                           4'b0010
`define TLBP                            4'b0100
`define TLBR                            4'b0101
`define TLBWI                           4'b0110
`define TLBWR                           4'b0111
`define SDBBP                           4'b1000
`define DERET                           4'b1001
`define PAUSE                           4'b1010
`define ERET                            4'b1011
`define BREAK                           4'b0011
`define WAIT_ROB                        4'b1100
`define SYNC_ROB                        4'b1101
`define SYNCI_ROB                       4'b1110
`define SYSCALL                         4'b1111

`define RVC_0                           2'b00
`define RVC_1                           2'b01
`define RVC_2                           2'b10
`define RVC_3                           2'b11

`define RV_ALU                          0
`define RV_BEU                          1
`define RV_MDU                          2
`define RV_LSU                          3
`define RV_ROB                          4
`define RV_FPU                          5

//riscv inst opcode, which is also inst[6:2]
`define RV_OP_LOAD                      5'b00000
`define RV_OP_LOAD_FP                   5'b00001
`define RV_OP_CUSTOM0                   5'b00010
`define RV_OP_MISC_MEM                  5'b00011
`define RV_OP_OP_IMM                    5'b00100
`define RV_OP_AUIPC                     5'b00101
`define RV_OP_OP_IMM32                  5'b00110
`define RV_OP_48B0                      5'b00111
`define RV_OP_STORE                     5'b01000
`define RV_OP_STORE_FP                  5'b01001
`define RV_OP_CUSTOM1                   5'b01010
`define RV_OP_AMO                       5'b01011
`define RV_OP_OP                        5'b01100
`define RV_OP_LUI                       5'b01101
`define RV_OP_OP32                      5'b01110
`define RV_OP_64B                       5'b01111
`define RV_OP_MADD                      5'b10000
`define RV_OP_MSUB                      5'b10001
`define RV_OP_NMSUB                     5'b10010
`define RV_OP_NMADD                     5'b10011
`define RV_OP_OP_FP                     5'b10100
`define RV_OP_VECTOR                    5'b10101
`define RV_OP_CUSTOM2                   5'b10110
`define RV_OP_48B1                      5'b10111
`define RV_OP_BRANCH                    5'b11000
`define RV_OP_JALR                      5'b11001
`define RV_OP_RESERVED0                 5'b11010
`define RV_OP_JAL                       5'b11011
`define RV_OP_SYSTEM                    5'b11100
`define RV_OP_RESERVED1                 5'b11101
`define RV_OP_CUSTOM3                   5'b11110
`define RV_OP_80B                       5'b11111

//riscv branch function encode define
`define FUNC3_BEQ                       3'b000
`define FUNC3_BNE                       3'b001
`define FUNC3_BLT                       3'b100
`define FUNC3_BGE                       3'b101
`define FUNC3_BLTU                      3'b110
`define FUNC3_BGEU                      3'b111

//ALU opcode encode define
`define RV_OP_I_IMM_ALU                 3'b000
`define RV_OP_I_IMM32_ALU               3'b010
`define RV_OP_R_ALU                     3'b100
`define RV_OP_U_LUI                     3'b101
`define RV_OP_R32_ALU                   3'b110

//BEU opcode encode define
`define RV_OP_B_BRANCH                  3'b100
`define RV_OP_I_JALR                    3'b101
`define RV_OP_J_JAL                     3'b111
`define RV_OP_U_AUIPC                   3'b001

//MDU opcode encode define
`define RV_OP_MDU_I_CUSTOM1                4'b0101
`define RV_OP_MDU_R_OP                     4'b0110
`define RV_OP_MDU_R_OP32                   4'b0111
`define RV_OP_MDU_R_OP_FP                  4'b1010
`define RV_OP_MDU_I_SYSTEM                 4'b1110
`define RV_OP_MDU_R_SYSTEM                 4'b1111

//FPU opcode encode define
`define RV_OP_R4_MADD                  3'b000
`define RV_OP_R4_MSUB                  3'b001
`define RV_OP_R4_NMSUB                 3'b010
`define RV_OP_R4_NMADD                 3'b011
`define RV_OP_R_OP_FP                  3'b100

//LSU opcode encode define
`define RV_OP_I_LOAD                   4'b0000
`define RV_OP_I_LOAD_FP                4'b0001
`define RV_OP_I_MISC_MEM               4'b1011
`define RV_OP_S_STORE                  4'b0100
`define RV_OP_S_STORE_FP               4'b0101
`define RV_OP_R_CUSTOM1                4'b0110
`define RV_OP_R_AMO                    4'b0111
`define RV_OP_I_PREFETCH               4'b1000

//ROB function encode define
`define RV_NORMAL                      4'b0000
`define RV_NOP                         4'b0001
`define RV_CONTROL_ROB                 4'b0010
`define RV_FENCE_ROB                   4'b0011
`define RV_EBREAK                      4'b0100
`define RV_WAIT_ROB                    4'b1100
`define RV_ECALL                       4'b0110
`define RV_MRET                        4'b0111
`define RV_SRET                        4'b0101
`define RV_FENCEI_ROB                  4'b1011
`define RV_DRET                        4'b1111

//riscv exception encode
`define RV_EXCEPT_IAM                  5'b00000
`define RV_EXCEPT_IAF                  5'b00001
`define RV_EXCEPT_ILI                  5'b00010
`define RV_EXCEPT_BRK                  5'b00011
`define RV_EXCEPT_LAM                  5'b00100
`define RV_EXCEPT_LAF                  5'b00101
`define RV_EXCEPT_SAM                  5'b00110
`define RV_EXCEPT_SAF                  5'b00111
`define RV_EXCEPT_ECU                  5'b01000
`define RV_EXCEPT_ECS                  5'b01001
`define RV_EXCEPT_ECM                  5'b01011
`define RV_EXCEPT_IPF                  5'b01100
`define RV_EXCEPT_LPF                  5'b01101
`define RV_EXCEPT_SPF                  5'b01111
`define RV_EXCEPT_TBM                  5'b11000
`define RV_EXCEPT_ICR                  5'b10010

`define INST_EBREAK                    32'h00100073

`define H_EXE_UNIT_WIDTH               6

`define H_ALU0                         `H_EXE_UNIT_WIDTH'd0
`define H_ALU1                         `H_EXE_UNIT_WIDTH'd1
`define H_BEU                          `H_EXE_UNIT_WIDTH'd2
`define H_LSU                          `H_EXE_UNIT_WIDTH'd3
