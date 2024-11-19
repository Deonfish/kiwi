module FuncDecodeEntry( 
    input  [31:0]                       inst_i          ,
    input  [2:0]                        instFunc3_i     ,   
    input                               mm_i            ,
    input                               um_i            ,
    input                               menvcfgCbie_i   ,   
    input                               senvcfgCbie_i   ,   
    output                              instAuipc_o     ,   
    output                              instLink_o      ,   
    output                              instBranch_o    ,   
    output                              instFlush_o     ,   
    output [5:0]                        instExeUnit_o   ,   
    output [3:0]                        instFuncCode_o  ,   
    output [2:0]                        instFunc3_o     ,   
    output [1:0]                        instFunc2_o     ,   
    output [4:0]                        instRdAddr_o    ,   
    output [4:0]                        instRs1Addr_o   ,   
    output [4:0]                        instRs2Addr_o   ,   
    output [4:0]                        instRs3Addr_o   ,   
    output [1:0]                        instRdType_o    ,   
    output                              instRs1Valid_o  ,   
    output                              instRs2Valid_o  ,   
    output                              instRs3Valid_o  
);

wire [4:0]          instOpcode  ;
wire [4:0]          instRd      ;   
wire [2:0]          instFunc3   ;   
wire [4:0]          instRs1     ;   
wire [4:0]          instRs2     ;   
wire [1:0]          instFunc2   ;   
wire [4:0]          instRs3     ;   
wire [11:0]         instCsrAddr ;

wire [15:0]         instC;
wire [2:0]          instCOp;
wire [4:0]          instCRd;
wire [4:0]          instCRs2;

wire                instC0;
wire                instC1;
wire                instC2;
wire                instC3;

wire                instLoad    ;   
wire                instLoadFp  ;
wire                instMiscMem ;
wire                instOpImm   ;   
wire                instAuipc   ;   
wire                instOpImm32 ;
wire                instStore   ;   
wire                instStoreFp ;
wire                instCustom1 ;
wire                instAmo     ;   
wire                instOp      ;   
wire                instLui     ;   
wire                instOp32    ;
wire                instMadd    ;
wire                instMsub    ;
wire                instNmsub   ;
wire                instNmadd   ;
wire                instOpFp    ;
wire                instBranch  ;
wire                instJalr    ;
wire                instJal     ;
wire                instSystem  ;

wire                instPrefetch;

wire                instAlu32   ;
wire                instLsu32   ;
wire                instBeu32   ;
wire                instMdu32   ;
wire                instFpu32   ;
wire                instRob32   ;

wire [5:0]          instExeUnit32;

wire                instEbreak32;
wire                instSret    ;
wire                instMret    ;
wire                instDret    ;
wire                instWfi     ;
wire                instEcall   ;
wire                instFence   ;
wire                instFencei  ;

wire [3:0]          robOpcode32 ;
wire [3:0]          aluOpcode32 ;
wire [3:0]          lsuOpcode32 ;
wire [3:0]          beuOpcode32 ;
wire [3:0]          mduOpcode32 ;
wire [3:0]          fpuOpcode32 ;

wire [3:0]          instFuncCode32;

wire                instRs1Valid32;
wire                instRs2Valid32;
wire                instRs3Valid32;

wire [1:0]          instRdType32;

wire                instFlush32 ;

wire                instCOp000;
wire                instCOp001;
wire                instCOp010;
wire                instCOp011;
wire                instCOp100;
wire                instCOp101;
wire                instCOp110;

wire                instRs1Zero ;
wire                instRs2Zero ;
wire                instRs3Zero ;
wire                instRdZero  ;
wire                instFunc3Zero;
wire                instFunc2Zero;

wire                instCOpZero;
wire                instCRdZero;
wire                instCRs2Zero;

wire                instOpImmC  ;
wire                instOpImm32C;
wire                instLuiC    ;
wire                instOpC     ;
wire                instOp32C   ;
wire                instJalC    ;
wire                instBranchC ;
wire                instJalrC   ;
wire                instLoadFpC ;
wire                instLoadC   ;
wire                instStoreFpC;
wire                instStoreC  ;
wire                instSystemC ;

wire                instAlu16   ;
wire                instLsu16   ;
wire                instBeu16   ;
wire                instRob16   ;

wire [5:0]          instExeUnit16;

wire [3:0]          instFuncCode16;

wire                instRs1Valid16;
wire                instRs2Valid16;
wire                instRs3Valid16;

wire [1:0]          instRdType16;

wire                instFlush16 ;


wire                instCboInvalid;

wire [4:0]          instRdAddr32;
wire [4:0]          instRs1Addr32;
wire [4:0]          instRs2Addr32;
wire [4:0]          instRs3Addr32;
wire [2:0]          instFunc3_32;
wire [1:0]          instFunc2_32;

wire [31:7]         instCModeAddi4  ;
wire [31:7]         instCModeAddi   ;
wire [31:7]         instCModeLi     ;
wire [31:7]         instCModeAddiw  ;
wire [31:7]         instCModeAddi16 ;
wire [31:7]         instCModeLui    ;
wire [31:7]         instCModeSri    ;
wire [31:7]         instCModeAndi   ;
wire [31:7]         instCModeSub    ;
wire [31:7]         instCModeXor    ;
wire [31:7]         instCModeOrAnd  ;
wire [31:7]         instCModeSubAddw;
wire [31:7]         instCModeSlli   ;
wire [31:7]         instCModeAdd    ;
wire [31:7]         instCModeJ      ;
wire [31:7]         instCModeBranch ;
wire [31:7]         instCModeJalr   ;
wire [31:7]         instCModeLd     ;
wire [31:7]         instCModeLw     ;
wire [31:7]         instCModeSd     ;
wire [31:7]         instCModeSw     ;
wire [31:7]         instCModeLdsp   ;
wire [31:7]         instCModeLwsp   ;
wire [31:7]         instCModeSdsp   ;
wire [31:7]         instCModeSwsp   ;
wire [31:7]         instCModeEbreak ;

wire                instCAddi4      ;
wire                instCAddi       ;
wire                instCLi         ;
wire                instCAddiw      ;
wire                instCAddi16     ;
wire                instCLui        ;
wire                instCSri        ;
wire                instCAndi       ;
wire                instCSub        ;
wire                instCXor        ;
wire                instCOrAnd      ;
wire                instCSubAddw    ;
wire                instCSlli       ;
wire                instCAdd        ;
wire                instCJ          ;
wire                instCBranch     ;
wire                instCJalr       ;
wire                instCLd         ;
wire                instCLw         ;
wire                instCSd         ;
wire                instCSw         ;
wire                instCLdsp       ;
wire                instCLwsp       ;
wire                instCSdsp       ;
wire                instCSwsp       ;
wire                instCEbreak     ;

wire [31:7]         instC32;

wire [4:0]          instRdAddr16;
wire [4:0]          instRs1Addr16;
wire [4:0]          instRs2Addr16;
wire [4:0]          instRs3Addr16;
wire [2:0]          instFunc3_16;
wire [1:0]          instFunc2_16;


assign instOpcode   = inst_i[6:2];
assign instRd       = inst_i[11:7];
assign instFunc3    = inst_i[14:12];
assign instRs1      = inst_i[19:15];
assign instRs2      = inst_i[24:20];
assign instFunc2    = inst_i[26:25];
assign instRs3      = inst_i[31:27];
assign instCsrAddr  = inst_i[31:20];

assign instC        = inst_i[15:0];

assign instCOp      = inst_i[15:13];
assign instCRd      = inst_i[11:7];
assign instCRs2     = inst_i[6:2];

assign instC0       = instC[1:0] == `RVC_0;
assign instC1       = instC[1:0] == `RVC_1;
assign instC2       = instC[1:0] == `RVC_2;
assign instC3       = instC[1:0] == `RVC_3;

assign instLoad     = instOpcode == `RV_OP_LOAD     ;
assign instLoadFp   = instOpcode == `RV_OP_LOAD_FP  ;
assign instMiscMem  = instOpcode == `RV_OP_MISC_MEM ;
assign instOpImm    = instOpcode == `RV_OP_OP_IMM   ;
assign instAuipc    = instOpcode == `RV_OP_AUIPC    ;
assign instOpImm32  = instOpcode == `RV_OP_OP_IMM32 ;
assign instStore    = instOpcode == `RV_OP_STORE    ;
assign instStoreFp  = instOpcode == `RV_OP_STORE_FP ;
assign instCustom1  = instOpcode == `RV_OP_CUSTOM1  ;
assign instAmo      = instOpcode == `RV_OP_AMO      ;
assign instOp       = instOpcode == `RV_OP_OP       ;
assign instLui      = instOpcode == `RV_OP_LUI      ;
assign instOp32     = instOpcode == `RV_OP_OP32     ;
assign instMadd     = instOpcode == `RV_OP_MADD     ;
assign instMsub     = instOpcode == `RV_OP_MSUB     ;
assign instNmsub    = instOpcode == `RV_OP_NMSUB    ;
assign instNmadd    = instOpcode == `RV_OP_NMADD    ;
assign instOpFp     = instOpcode == `RV_OP_OP_FP    ;
assign instBranch   = instOpcode == `RV_OP_BRANCH   ;
assign instJalr     = instOpcode == `RV_OP_JALR     ;
assign instJal      = instOpcode == `RV_OP_JAL      ;
assign instSystem   = instOpcode == `RV_OP_SYSTEM   ;

assign instRs1Zero  = ~|instRs1;
assign instRs2Zero  = ~|instRs2;
assign instRs3Zero  = ~|instRs3;
assign instRdZero   = ~|instRd;
assign instFunc3Zero= ~|instFunc3;
assign instFunc2Zero= ~|instFunc2;

assign instCOpZero  = ~|instCOp;
assign instCRdZero  = ~|instCRd;
assign instCRs2Zero = ~|instCRs2;

assign instPrefetch = instRdZero && instFunc3 == 3'b110 && ~|instRs2[4:2] && !(instRs2[1] && !instRs2[0]);

assign instAlu32    = (instOpImm && !instPrefetch)                          ||
                      instOpImm32                                           ||
                      (instOp && !instFunc2[0])                             ||
                      instLui                                               ||
                      (instOp32 && !instFunc2[0])                           ||
                      instAuipc                                             ;
assign instLsu32    = instLoad                                              || 
                      instLoadFp                                            || 
                      instMiscMem                                           || 
                      (instOpImm && instPrefetch)                           ||
                      instStore                                             ||
                      instStoreFp                                           ||
                      (instCustom1 && instFunc3 != 3'b010)                  ||
                      instAmo                                               ||
                      instWfi                                               ;
assign instBeu32    = instBranch                                            ||
                      instJalr                                              ||
                      instJal                                               ;
assign instMdu32    = (instCustom1 && instFunc3 == 3'b010)                  ||
                      (instOp && instFunc2[0])                              ||
                      (instOp32 && instFunc2[0])                            ||
                      (instOpFp && !(~|instRs3[4:2] && ~&instRs3[1:0]))     ||
                      (instSystem && !instFunc3Zero)                        ||
                      (instSystem && instFunc3Zero && {instRs3, instFunc2} == 7'b0001001);
assign instFpu32    = instMadd || instMsub || instNmadd || instNmsub        ||
                      (instOpFp && ~|instRs3[4:2] && ~&instRs3[1:0])        ;
assign instRob32    = (instMiscMem && ~|instFunc3[2:1] && instFunc3[0])     ||
                      (instSystem && instFunc3Zero && !instFunc2[0])        ||
                      (instSystem && instFunc3Zero && &instRs3[3:0]);

assign instExeUnit32[`RV_ALU]    = instAlu32;
assign instExeUnit32[`RV_LSU]    = instLsu32;
assign instExeUnit32[`RV_BEU]    = instBeu32;
assign instExeUnit32[`RV_MDU]    = instMdu32;
assign instExeUnit32[`RV_FPU]    = instFpu32;
assign instExeUnit32[`RV_ROB]    = instRob32;

assign instEbreak32     = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b000000000001;
assign instSret         = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b000100000010;
assign instMret         = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b001100000010;
assign instDret         = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b011110110010;
assign instWfi          = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b000100000101;
assign instEcall        = instSystem && instRdZero && instFunc3Zero && instRs1Zero && instCsrAddr == 12'b000000000000;
assign instFence        = instMiscMem && instFunc3Zero;
assign instFencei       = instMiscMem && ~|instFunc3[2:1] && instFunc3[0];


assign robOpcode32      = ({4{instEbreak32  }} & `RV_EBREAK     )  | 
                          ({4{instDret      }} & `RV_DRET       )  |
                          ({4{instSret      }} & `RV_SRET       )  | 
                          ({4{instMret      }} & `RV_MRET       )  | 
                          ({4{instWfi       }} & `RV_WAIT_ROB   )  |
                          ({4{instFence     }} & `RV_FENCE_ROB  )  | 
                          ({4{instFencei    }} & `RV_FENCEI_ROB )  | 
                          ({4{instEcall     }} & `RV_ECALL      )  ;
assign aluOpcode32      = {1'b0, instOpcode[3], instOpcode[1:0]};
assign lsuOpcode32      = {instMiscMem || instOpcode[2], instOpcode[3], instOpcode[1:0]};
assign beuOpcode32      = {1'b0, instOpcode[3], instOpcode[1:0]};
assign mduOpcode32      = {instOpcode[4:2], (instOpcode[1] || (instSystem && instFunc3Zero))};
assign fpuOpcode32      = {1'b0, instOpcode[2:0]};

assign instFuncCode32   = ({4{instAlu32}} & aluOpcode32) |
                          ({4{instLsu32}} & lsuOpcode32) |
                          ({4{instBeu32}} & beuOpcode32) |
                          ({4{instMdu32}} & mduOpcode32) |
                          ({4{instFpu32}} & fpuOpcode32) |
                          ({4{instRob32}} & robOpcode32) ;

assign instRs1Valid32   = !(instAuipc || 
                            (instCustom1 && instFunc3[1]) || 
                            instLui || 
                            instJal || 
                            (instSystem && (instFunc3Zero && !instFunc2[0] || instFunc3[2])));

assign instRs2Valid32   = instStore     || instStoreFp  || instOp       || instOp32     || 
                          instMadd      || instMsub     || instNmadd    || instNmsub    || 
                          instBranch    || (instOpFp && !instRs3[3])    || 
                          (instAmo && !(instRs3[1] && !instRs3[0]))     || 
                          (instSystem && instFunc3Zero && instFunc2[0]) ;

assign instRs3Valid32   = instMadd      || instMsub     || instNmadd    || instNmsub    ;

assign instRdType32[0]  = instLoad      || instAuipc    || instOpImm32  || instAmo      || 
                          instOp        || instLui      || instOp32     || instJalr     || 
                          instJal       || 
                          (instOpImm && !instRdZero)                    || 
                          (instOpFp && instRs3[4] && !instRs3[1])       || 
                          (instSystem && !instFunc3Zero)                ;

assign instRdType32[1]  = instLoadFp    || instMadd     || instMsub     || instNmadd    || 
                          instNmsub     || (instOpFp && !(instRs3[4] && !instRs3[1]))   ;

assign instFlush32      = instMiscMem && instFunc3[0] || 
                          instSystem                  || 
                          instCustom1 && instFunc3[1] && !instFunc3[0];

assign instCOp000       = instCOpZero;
assign instCOp001       = ~|instCOp[2:1] && instCOp[0];
assign instCOp010       = !instCOp[2] && instCOp[1] && !instCOp[0];
assign instCOp011       = !instCOp[2] && &instCOp[1:0];
assign instCOp100       = instCOp[2] && ~|instCOp[1:0];
assign instCOp101       = instCOp[2] && !instCOp[1] && instCOp[0];
assign instCOp110       = &instCOp[2:1] && !instCOp[0];

assign instOpImmC       = (instC0 && instCOpZero)                               ||
                          (instC1 && ((!instCOp[2] && !instCOp[0])      || 
                                      (instCOp011 && instCRd == 5'h2)   || 
                                      (instCOp100 && ~&instCRd[4:3])))          ||
                          (instC2 && instCOp000)                                ;
assign instOpImm32C     = instC1 && instCOp001;
assign instLuiC         = instC1 && instCOp011 && instCRd != 5'h2;
assign instOpC          = instC1 && instCOp100 && &instCRd[4:3] && !instC[12] ||
                          instC2 && instCOp100 && !instCRs2Zero;
assign instOp32C        = instC1 && instCOp100 && &instCRd[4:3] && instC[12];
assign instJalC         = instC1 && instCOp101;
assign instBranchC      = instC1 && &instCOp[2:1];
assign instJalrC        = instC2 && instCOp100 && !instCRdZero && instCRs2Zero;
assign instLoadFpC      = instC0 && instCOp001 || 
                          instC2 && instCOp001 ;
assign instLoadC        = instC0 && !instCOp[2] && instCOp[1] ||
                          instC2 && !instCOp[2] && instCOp[1] ;
assign instStoreFpC     = instC0 && instCOp101 ||
                          instC2 && instCOp101 ;
assign instStoreC       = instC0 && &instCOp[2:1] ||
                          instC2 && &instCOp[2:1] ;
assign instSystemC      = instC2 && instCOp100 && instCRdZero && instCRs2Zero;

assign instAlu16        = instOpImmC || instOpImm32C || instLuiC || instOpC || instOp32C;
assign instLsu16        = instLoadFpC || instLoadC || instStoreFpC || instStoreC;
assign instBeu16        = instJalC || instBranchC || instJalrC;
assign instRob16        = instSystemC;


assign instExeUnit16[`RV_ALU]    = instAlu16;
assign instExeUnit16[`RV_LSU]    = instLsu16;
assign instExeUnit16[`RV_BEU]    = instBeu16;
assign instExeUnit16[`RV_MDU]    = 1'b0;
assign instExeUnit16[`RV_FPU]    = 1'b0;
assign instExeUnit16[`RV_ROB]    = instRob16;

assign instFuncCode16   = ({4{instOpImmC    }} & 4'b0000)  |
                          ({4{instOpImm32C  }} & 4'b0010)  |
                          ({4{instLuiC      }} & 4'b0101)  |
                          ({4{instOpC       }} & 4'b0100)  |
                          ({4{instOp32C     }} & 4'b0110)  |
                          ({4{instJalC      }} & 4'b0111)  |
                          ({4{instBranchC   }} & 4'b0100)  |
                          ({4{instJalrC     }} & 4'b0101)  |
                          ({4{instLoadFpC   }} & 4'b0001)  |
                          ({4{instLoadC     }} & 4'b0000)  |
                          ({4{instStoreFpC  }} & 4'b0101)  |
                          ({4{instStoreC    }} & 4'b0100)  |
                          ({4{instSystemC   }} & 4'b0100)  ;

assign instRs1Valid16   = !(instLuiC || instJalC || instSystemC);

assign instRs2Valid16   = instOpC || instOp32C || instStoreC || instStoreFpC;

assign instRs3Valid16   = 1'b0;

assign instRdType16[0]  = !(instBranchC || instLoadFpC || instStoreC || instStoreFpC || instSystemC);

assign instRdType16[1]  = instLoadFpC;

assign instFlush16      = instSystemC;

assign instExeUnit_o    = instC3 ? instExeUnit32    : instExeUnit16 ;
assign instFuncCode_o   = instC3 ? instFuncCode32   : instFuncCode16;
assign instRs1Valid_o   = instC3 ? instRs1Valid32   : instRs1Valid16;
assign instRs2Valid_o   = instC3 ? instRs2Valid32   : instRs2Valid16;
assign instRs3Valid_o   = instC3 ? instRs3Valid32   : instRs3Valid16;
assign instRdType_o     = instC3 ? instRdType32     : instRdType16  ;

assign instCboInvalid   = instMiscMem && (instFunc3 == 3'b010) && instRs3Zero && instRs2Zero && instFunc2Zero;

assign instRdAddr32     = instRd;
assign instRs1Addr32    = instRs1;
assign instRs2Addr32    = (instCboInvalid && ((!mm_i && !menvcfgCbie_i) || (um_i && !senvcfgCbie_i))) ? 5'b00010 : instRs2;
assign instRs3Addr32    = instRs3;
assign instFunc3_32     = instFunc3_i;
assign instFunc2_32     = instFunc2;

assign instCModeAddi4   = {2'b0, instC[10:7], instC[12:11], instC[5], instC[6], 2'b0, 5'h2, 3'b0, 2'b01, instC[4:2]};
assign instCModeAddi    = {{6{instC[12]}}, instC[12], instC[6:2], instCRd, 3'b0, instCRd};
assign instCModeLi      = {{6{instC[12]}}, instC[12], instC[6:2], 5'b0, 3'b0, instCRd};
assign instCModeAddiw   = {{6{instC[12]}}, instC[12], instC[6:2], instCRd, 3'b0, instCRd};
assign instCModeAddi16  = {{2{instC[12]}}, instC[12], instC[4:3], instC[5], instC[2], instC[6], 4'b0, instCRd, 3'b0, instCRd};
assign instCModeLui     = {{14{instC[12]}}, instC[12], instC[6:2], instCRd};
assign instCModeSri     = {instC[11:10], 4'b0, instC[12], instC[6:2], 2'b01, instC[9:7], 3'b101, 2'b01, instC[9:7]};
assign instCModeAndi    = {{6{instC[12]}}, instC[12], instC[6:2], 2'b01, instC[9:7], 3'b111, 2'b01, instC[9:7]};
assign instCModeSub     = {7'b0100000, 2'b01, instC[4:2], 2'b01, instC[9:7], 3'b0, 2'b01, instC[9:7]};
assign instCModeXor     = {7'b0, 2'b01, instC[4:2], 2'b01, instC[9:7], 3'b100, 2'b01, instC[9:7]};
assign instCModeOrAnd   = {7'b0, 2'b01, instC[4:2], 2'b01, instC[9:7], 1'b1, instC[6:5], 2'b01, instC[9:7]};
assign instCModeSubAddw = {1'b0, !instC[5], 5'b0, 2'b01, instC[4:2], 2'b01, instC[9:7], 3'b0, 2'b01, instC[9:7]};
assign instCModeSlli    = {6'b0, instC[12], instC[6:2], instRd, 3'b001, instRd};
assign instCModeAdd     = {7'b0, instCRs2, ({5{instC[12]}} & instRd), 3'b0, instRd};
assign instCModeJ       = {instC[12], instC[8], instC[10:9], instC[6], instC[7], instC[2], instC[11], instC[5:3], instC[12], {8{instC[12]}}, 5'b0};
assign instCModeBranch  = {instC[12], {3{instC[12]}}, instC[6:5], instC[2], 5'b0, 2'b01, instC[9:7], 2'b0, instC[13], instC[11:10], instC[4:3], instC[12]};
assign instCModeJalr    = {12'b0, instCRd, 3'b0, 4'b0, instC[12]};
assign instCModeLd      = {4'b0, instC[6:5], instC[12:10], 3'b0, 2'b01, instC[9:7], 3'b011, 2'b01, instC[4:2]};
assign instCModeLw      = {5'b0, instC[5], instC[12:10], instC[6], 2'b0, 2'b01, instC[9:7], 3'b010, 2'b01, instC[4:2]};
assign instCModeSd      = {4'b0, instC[6:5], instC[12], 2'b01, instC[4:2], 2'b01, instC[9:7], 3'b011, instC[11:10], 3'b0};
assign instCModeSw      = {5'b0, instC[5], instC[12], 2'b01, instC[4:2], 2'b01, instC[9:7], 3'b010, instC[11:10], instC[6], 2'b0};
assign instCModeLdsp    = {3'b0, instC[4:2], instC[12], instC[6:5], 3'b0, 5'b00010, 3'b011, instCRd};
assign instCModeLwsp    = {4'b0, instC[3:2], instC[12], instC[6:4], 2'b0, 5'b00010, 3'b010, instCRd};
assign instCModeSdsp    = {3'b0, instC[9:7], instC[12], instCRs2, 5'b00010, 3'b011, instC[11:10], 3'b0};
assign instCModeSwsp    = {4'b0, instC[8:7], instC[12], instCRs2, 5'b00010, 3'b010, instC[11:9], 2'b0};
assign instCModeEbreak  = {11'b0, 1'b1, 13'b0};

assign instCAddi4       = instC0 && instCOp000;
assign instCAddi        = instC1 && instCOpZero;
assign instCLi          = instC1 && !instCOp[2] && instCOp[1] && !instCOp[0];
assign instCAddiw       = instC1 && instCOp001;
assign instCAddi16      = instC1 && instCOp011 && instCRd==5'h2;
assign instCLui         = instC1 && instCOp011 && instCRd!=5'h2;
assign instCSri         = instC1 && instCOp100 && !instC[11];
assign instCAndi        = instC1 && instCOp100 && instC[11] && !instC[10];
assign instCSub         = instC1 && instCOp100 && &instC[11:10] && !instC[12] && ~|instC[6:5];
assign instCXor         = instC1 && instCOp100 && &instC[11:10] && !instC[12] && !instC[6] && instC[5];
assign instCOrAnd       = instC1 && instCOp100 && &instC[11:10] && !instC[12] && instC[6];
assign instCSubAddw     = instC1 && instCOp100 && &instC[11:10] && instC[12];
assign instCSlli        = instC2 && instCOp000;
assign instCAdd         = instC2 && instCOp100 && !instCRs2Zero;
assign instCJ           = instC1 && instCOp101;
assign instCBranch      = instC1 && &instCOp[2:1];
assign instCJalr        = instC2 && instCOp100 && !instCRdZero && instCRs2Zero;
assign instCLd          = instC0 && !instCOp[2] && instCOp[0];
assign instCLw          = instC0 && instCOp010;
assign instCSd          = instC0 && instCOp[2] && instCOp[0];
assign instCSw          = instC0 && instCOp110;
assign instCLdsp        = instC2 && !instCOp[2] && instCOp[0];
assign instCLwsp        = instC2 && instCOp010;
assign instCSdsp        = instC2 && instCOp[2] && instCOp[0];
assign instCSwsp        = instC2 && instCOp110;
assign instCEbreak      = instC2 && instCOp100 && instCRdZero && instCRs2Zero;

assign instC32          = ({25{instCAddi4  }} & instCModeAddi4  ) | 
                          ({25{instCAddi   }} & instCModeAddi   ) |
                          ({25{instCLi     }} & instCModeLi     ) |
                          ({25{instCAddiw  }} & instCModeAddiw  ) |
                          ({25{instCAddi16 }} & instCModeAddi16 ) |
                          ({25{instCLui    }} & instCModeLui    ) |
                          ({25{instCSri    }} & instCModeSri    ) |
                          ({25{instCAndi   }} & instCModeAndi   ) |
                          ({25{instCSub    }} & instCModeSub    ) |
                          ({25{instCXor    }} & instCModeXor    ) |
                          ({25{instCOrAnd  }} & instCModeOrAnd  ) |
                          ({25{instCSubAddw}} & instCModeSubAddw) |
                          ({25{instCSlli   }} & instCModeSlli   ) |
                          ({25{instCAdd    }} & instCModeAdd    ) |
                          ({25{instCJ      }} & instCModeJ      ) |
                          ({25{instCBranch }} & instCModeBranch ) |
                          ({25{instCJalr   }} & instCModeJalr   ) |
                          ({25{instCLd     }} & instCModeLd     ) |
                          ({25{instCLw     }} & instCModeLw     ) |
                          ({25{instCSd     }} & instCModeSd     ) |
                          ({25{instCSw     }} & instCModeSw     ) |
                          ({25{instCLdsp   }} & instCModeLdsp   ) |
                          ({25{instCLwsp   }} & instCModeLwsp   ) |
                          ({25{instCSdsp   }} & instCModeSdsp   ) |
                          ({25{instCSwsp   }} & instCModeSwsp   ) |
                          ({25{instCEbreak }} & instCModeEbreak ) ;

assign instRs3Addr16    = instC32[31:27];
assign instFunc2_16     = instC32[26:25];
assign instRs2Addr16    = instC32[24:20];
assign instRs1Addr16    = instC32[19:15];
assign instFunc3_16     = instC32[14:12];
assign instRdAddr16     = instC32[11:7];

assign instRs3Addr_o    = instC3 ? instRs3Addr32    : instRs3Addr16;
assign instFunc2_o      = instC3 ? instFunc2_32     : instFunc2_16 ;
assign instRs2Addr_o    = instC3 ? instRs2Addr32    : instRs2Addr16;
assign instRs1Addr_o    = instC3 ? instRs1Addr32    : instRs1Addr16;
assign instFunc3_o      = instC3 ? instFunc3_32     : instFunc3_16 ;
assign instRdAddr_o     = instC3 ? instRdAddr32     : instRdAddr16 ;

assign instAuipc_o      = instC3 && instAuipc;
assign instLink_o       = instExeUnit_o[`RV_BEU] && ({instFuncCode_o[2], instFuncCode_o[0]} == 2'b11);
assign instBranch_o     = instExeUnit_o[`RV_BEU] && instFuncCode_o[2];
assign instFlush_o      = instC3 ? instFlush32 : instFlush16;

endmodule
