; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx512f | FileCheck %s --check-prefixes=X86,X86-AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512f | FileCheck %s --check-prefixes=X64,X64-AVX512F
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=avx512bw | FileCheck %s --check-prefixes=X86,X86-AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512bw | FileCheck %s --check-prefixes=X64,X64-AVX512BW

define <16 x i32> @select00(i32 %a, <16 x i32> %b) nounwind {
; X86-LABEL: select00:
; X86:       # %bb.0:
; X86-NEXT:    cmpl $255, {{[0-9]+}}(%esp)
; X86-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X86-NEXT:    je .LBB0_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm1
; X86-NEXT:  .LBB0_2:
; X86-NEXT:    vpxord %zmm1, %zmm0, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: select00:
; X64:       # %bb.0:
; X64-NEXT:    cmpl $255, %edi
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    je .LBB0_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm1
; X64-NEXT:  .LBB0_2:
; X64-NEXT:    vpxord %zmm1, %zmm0, %zmm0
; X64-NEXT:    retq
  %cmpres = icmp eq i32 %a, 255
  %selres = select i1 %cmpres, <16 x i32> zeroinitializer, <16 x i32> %b
  %res = xor <16 x i32> %b, %selres
  ret <16 x i32> %res
}

define <8 x i64> @select01(i32 %a, <8 x i64> %b) nounwind {
; X86-LABEL: select01:
; X86:       # %bb.0:
; X86-NEXT:    cmpl $255, {{[0-9]+}}(%esp)
; X86-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X86-NEXT:    je .LBB1_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    vmovdqa64 %zmm0, %zmm1
; X86-NEXT:  .LBB1_2:
; X86-NEXT:    vpxorq %zmm1, %zmm0, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: select01:
; X64:       # %bb.0:
; X64-NEXT:    cmpl $255, %edi
; X64-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; X64-NEXT:    je .LBB1_2
; X64-NEXT:  # %bb.1:
; X64-NEXT:    vmovdqa64 %zmm0, %zmm1
; X64-NEXT:  .LBB1_2:
; X64-NEXT:    vpxorq %zmm1, %zmm0, %zmm0
; X64-NEXT:    retq
  %cmpres = icmp eq i32 %a, 255
  %selres = select i1 %cmpres, <8 x i64> zeroinitializer, <8 x i64> %b
  %res = xor <8 x i64> %b, %selres
  ret <8 x i64> %res
}

define float @select02(float %a, float %b, float %c, float %eps) {
; X86-LABEL: select02:
; X86:       # %bb.0:
; X86-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-NEXT:    vucomiss {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    cmovael %eax, %ecx
; X86-NEXT:    flds (%ecx)
; X86-NEXT:    retl
;
; X64-LABEL: select02:
; X64:       # %bb.0:
; X64-NEXT:    vcmpless %xmm0, %xmm3, %k1
; X64-NEXT:    vmovss %xmm2, %xmm0, %xmm1 {%k1}
; X64-NEXT:    vmovaps %xmm1, %xmm0
; X64-NEXT:    retq
  %cmp = fcmp oge float %a, %eps
  %cond = select i1 %cmp, float %c, float %b
  ret float %cond
}

define double @select03(double %a, double %b, double %c, double %eps) {
; X86-LABEL: select03:
; X86:       # %bb.0:
; X86-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    vucomisd {{[0-9]+}}(%esp), %xmm0
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    cmovael %eax, %ecx
; X86-NEXT:    fldl (%ecx)
; X86-NEXT:    retl
;
; X64-LABEL: select03:
; X64:       # %bb.0:
; X64-NEXT:    vcmplesd %xmm0, %xmm3, %k1
; X64-NEXT:    vmovsd %xmm2, %xmm0, %xmm1 {%k1}
; X64-NEXT:    vmovapd %xmm1, %xmm0
; X64-NEXT:    retq
  %cmp = fcmp oge double %a, %eps
  %cond = select i1 %cmp, double %c, double %b
  ret double %cond
}

define <16 x double> @select04(<16 x double> %a, <16 x double> %b) {
; X86-LABEL: select04:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-64, %esp
; X86-NEXT:    subl $64, %esp
; X86-NEXT:    vmovaps 8(%ebp), %zmm1
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
;
; X64-LABEL: select04:
; X64:       # %bb.0:
; X64-NEXT:    vmovaps %zmm3, %zmm1
; X64-NEXT:    retq
  %sel = select <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false>, <16 x double> %a, <16 x double> %b
  ret <16 x double> %sel
}

define i8 @select05(i8 %a.0, i8 %m) {
; X86-LABEL: select05:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    orb {{[0-9]+}}(%esp), %al
; X86-NEXT:    retl
;
; X64-LABEL: select05:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    orl %esi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %mask = bitcast i8 %m to <8 x i1>
  %a = bitcast i8 %a.0 to <8 x i1>
  %r = select <8 x i1> %mask, <8 x i1> <i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1>, <8 x i1> %a
  %res = bitcast <8 x i1> %r to i8
  ret i8 %res;
}

define i8 @select05_mem(<8 x i1>* %a.0, <8 x i1>* %m) {
; X86-AVX512F-LABEL: select05_mem:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX512F-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-AVX512F-NEXT:    kmovw (%ecx), %k0
; X86-AVX512F-NEXT:    kmovw (%eax), %k1
; X86-AVX512F-NEXT:    korw %k1, %k0, %k0
; X86-AVX512F-NEXT:    kmovw %k0, %eax
; X86-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: select05_mem:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    kmovw (%rsi), %k0
; X64-AVX512F-NEXT:    kmovw (%rdi), %k1
; X64-AVX512F-NEXT:    korw %k1, %k0, %k0
; X64-AVX512F-NEXT:    kmovw %k0, %eax
; X64-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: select05_mem:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX512BW-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-AVX512BW-NEXT:    kmovw (%ecx), %k0
; X86-AVX512BW-NEXT:    kmovw (%eax), %k1
; X86-AVX512BW-NEXT:    korw %k1, %k0, %k0
; X86-AVX512BW-NEXT:    kmovd %k0, %eax
; X86-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: select05_mem:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    kmovw (%rsi), %k0
; X64-AVX512BW-NEXT:    kmovw (%rdi), %k1
; X64-AVX512BW-NEXT:    korw %k1, %k0, %k0
; X64-AVX512BW-NEXT:    kmovd %k0, %eax
; X64-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512BW-NEXT:    retq
  %mask = load <8 x i1> , <8 x i1>* %m
  %a = load <8 x i1> , <8 x i1>* %a.0
  %r = select <8 x i1> %mask, <8 x i1> <i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1, i1 -1>, <8 x i1> %a
  %res = bitcast <8 x i1> %r to i8
  ret i8 %res;
}

define i8 @select06(i8 %a.0, i8 %m) {
; X86-LABEL: select06:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; X86-NEXT:    retl
;
; X64-LABEL: select06:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl %esi, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
  %mask = bitcast i8 %m to <8 x i1>
  %a = bitcast i8 %a.0 to <8 x i1>
  %r = select <8 x i1> %mask, <8 x i1> %a, <8 x i1> zeroinitializer
  %res = bitcast <8 x i1> %r to i8
  ret i8 %res;
}

define i8 @select06_mem(<8 x i1>* %a.0, <8 x i1>* %m) {
; X86-AVX512F-LABEL: select06_mem:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX512F-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-AVX512F-NEXT:    kmovw (%ecx), %k0
; X86-AVX512F-NEXT:    kmovw (%eax), %k1
; X86-AVX512F-NEXT:    kandw %k1, %k0, %k0
; X86-AVX512F-NEXT:    kmovw %k0, %eax
; X86-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: select06_mem:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    kmovw (%rsi), %k0
; X64-AVX512F-NEXT:    kmovw (%rdi), %k1
; X64-AVX512F-NEXT:    kandw %k1, %k0, %k0
; X64-AVX512F-NEXT:    kmovw %k0, %eax
; X64-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: select06_mem:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-AVX512BW-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-AVX512BW-NEXT:    kmovw (%ecx), %k0
; X86-AVX512BW-NEXT:    kmovw (%eax), %k1
; X86-AVX512BW-NEXT:    kandw %k1, %k0, %k0
; X86-AVX512BW-NEXT:    kmovd %k0, %eax
; X86-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: select06_mem:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    kmovw (%rsi), %k0
; X64-AVX512BW-NEXT:    kmovw (%rdi), %k1
; X64-AVX512BW-NEXT:    kandw %k1, %k0, %k0
; X64-AVX512BW-NEXT:    kmovd %k0, %eax
; X64-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512BW-NEXT:    retq
  %mask = load <8 x i1> , <8 x i1>* %m
  %a = load <8 x i1> , <8 x i1>* %a.0
  %r = select <8 x i1> %mask, <8 x i1> %a, <8 x i1> zeroinitializer
  %res = bitcast <8 x i1> %r to i8
  ret i8 %res;
}
define i8 @select07(i8 %a.0, i8 %b.0, i8 %m) {
; X86-AVX512F-LABEL: select07:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512F-NEXT:    kmovw %eax, %k0
; X86-AVX512F-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512F-NEXT:    kmovw %eax, %k1
; X86-AVX512F-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512F-NEXT:    kmovw %eax, %k2
; X86-AVX512F-NEXT:    kandnw %k2, %k0, %k2
; X86-AVX512F-NEXT:    kandw %k0, %k1, %k0
; X86-AVX512F-NEXT:    korw %k2, %k0, %k0
; X86-AVX512F-NEXT:    kmovw %k0, %eax
; X86-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: select07:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    kmovw %edx, %k0
; X64-AVX512F-NEXT:    kmovw %edi, %k1
; X64-AVX512F-NEXT:    kmovw %esi, %k2
; X64-AVX512F-NEXT:    kandnw %k2, %k0, %k2
; X64-AVX512F-NEXT:    kandw %k0, %k1, %k0
; X64-AVX512F-NEXT:    korw %k2, %k0, %k0
; X64-AVX512F-NEXT:    kmovw %k0, %eax
; X64-AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: select07:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512BW-NEXT:    kmovd %eax, %k0
; X86-AVX512BW-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512BW-NEXT:    kmovd %eax, %k1
; X86-AVX512BW-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-AVX512BW-NEXT:    kmovd %eax, %k2
; X86-AVX512BW-NEXT:    kandnw %k2, %k0, %k2
; X86-AVX512BW-NEXT:    kandw %k0, %k1, %k0
; X86-AVX512BW-NEXT:    korw %k2, %k0, %k0
; X86-AVX512BW-NEXT:    kmovd %k0, %eax
; X86-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: select07:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    kmovd %edx, %k0
; X64-AVX512BW-NEXT:    kmovd %edi, %k1
; X64-AVX512BW-NEXT:    kmovd %esi, %k2
; X64-AVX512BW-NEXT:    kandnw %k2, %k0, %k2
; X64-AVX512BW-NEXT:    kandw %k0, %k1, %k0
; X64-AVX512BW-NEXT:    korw %k2, %k0, %k0
; X64-AVX512BW-NEXT:    kmovd %k0, %eax
; X64-AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; X64-AVX512BW-NEXT:    retq
  %mask = bitcast i8 %m to <8 x i1>
  %a = bitcast i8 %a.0 to <8 x i1>
  %b = bitcast i8 %b.0 to <8 x i1>
  %r = select <8 x i1> %mask, <8 x i1> %a, <8 x i1> %b
  %res = bitcast <8 x i1> %r to i8
  ret i8 %res;
}

define i64 @pr30249() {
; X86-LABEL: pr30249:
; X86:       # %bb.0:
; X86-NEXT:    movl $1, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:    retl
;
; X64-LABEL: pr30249:
; X64:       # %bb.0:
; X64-NEXT:    movl $1, %eax
; X64-NEXT:    retq
  %v = select i1 undef , i64 1, i64 2
  ret i64 %v
}

define double @pr30561_f64(double %b, double %a, i1 %c) {
; X86-LABEL: pr30561_f64:
; X86:       # %bb.0:
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    cmovnel %eax, %ecx
; X86-NEXT:    fldl (%ecx)
; X86-NEXT:    retl
;
; X64-AVX512F-LABEL: pr30561_f64:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    kmovw %edi, %k1
; X64-AVX512F-NEXT:    vmovsd %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512BW-LABEL: pr30561_f64:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    kmovd %edi, %k1
; X64-AVX512BW-NEXT:    vmovsd %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512BW-NEXT:    retq
  %cond = select i1 %c, double %a, double %b
  ret double %cond
}

define float @pr30561_f32(float %b, float %a, i1 %c) {
; X86-LABEL: pr30561_f32:
; X86:       # %bb.0:
; X86-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %eax
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    cmovnel %eax, %ecx
; X86-NEXT:    flds (%ecx)
; X86-NEXT:    retl
;
; X64-AVX512F-LABEL: pr30561_f32:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    kmovw %edi, %k1
; X64-AVX512F-NEXT:    vmovss %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512F-NEXT:    retq
;
; X64-AVX512BW-LABEL: pr30561_f32:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    kmovd %edi, %k1
; X64-AVX512BW-NEXT:    vmovss %xmm1, %xmm0, %xmm0 {%k1}
; X64-AVX512BW-NEXT:    retq
  %cond = select i1 %c, float %a, float %b
  ret float %cond
}

define <16 x i16> @pr31515(<16 x i1> %a, <16 x i1> %b, <16 x i16> %c) nounwind {
; X86-AVX512F-LABEL: pr31515:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X86-AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X86-AVX512F-NEXT:    vpsllw $15, %ymm0, %ymm0
; X86-AVX512F-NEXT:    vpsraw $15, %ymm0, %ymm0
; X86-AVX512F-NEXT:    vpandn %ymm2, %ymm0, %ymm0
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: pr31515:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X64-AVX512F-NEXT:    vpmovzxbw {{.*#+}} ymm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero,xmm0[8],zero,xmm0[9],zero,xmm0[10],zero,xmm0[11],zero,xmm0[12],zero,xmm0[13],zero,xmm0[14],zero,xmm0[15],zero
; X64-AVX512F-NEXT:    vpsllw $15, %ymm0, %ymm0
; X64-AVX512F-NEXT:    vpsraw $15, %ymm0, %ymm0
; X64-AVX512F-NEXT:    vpandn %ymm2, %ymm0, %ymm0
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: pr31515:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    # kill: def $ymm2 killed $ymm2 def $zmm2
; X86-AVX512BW-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X86-AVX512BW-NEXT:    vpsllw $7, %xmm0, %xmm0
; X86-AVX512BW-NEXT:    vpmovb2m %zmm0, %k0
; X86-AVX512BW-NEXT:    knotw %k0, %k1
; X86-AVX512BW-NEXT:    vmovdqu16 %zmm2, %zmm0 {%k1} {z}
; X86-AVX512BW-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: pr31515:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    # kill: def $ymm2 killed $ymm2 def $zmm2
; X64-AVX512BW-NEXT:    vpand %xmm1, %xmm0, %xmm0
; X64-AVX512BW-NEXT:    vpsllw $7, %xmm0, %xmm0
; X64-AVX512BW-NEXT:    vpmovb2m %zmm0, %k0
; X64-AVX512BW-NEXT:    knotw %k0, %k1
; X64-AVX512BW-NEXT:    vmovdqu16 %zmm2, %zmm0 {%k1} {z}
; X64-AVX512BW-NEXT:    # kill: def $ymm0 killed $ymm0 killed $zmm0
; X64-AVX512BW-NEXT:    retq
  %mask = and <16 x i1> %a, %b
  %res = select <16 x i1> %mask, <16 x i16> zeroinitializer, <16 x i16> %c
  ret <16 x i16> %res
}

define <32 x i16> @pr42355_v32i16(i1 %c, <32 x i16> %x, <32 x i16> %y) {
; X86-AVX512F-LABEL: pr42355_v32i16:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    pushl %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa_offset 8
; X86-AVX512F-NEXT:    .cfi_offset %ebp, -8
; X86-AVX512F-NEXT:    movl %esp, %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa_register %ebp
; X86-AVX512F-NEXT:    andl $-32, %esp
; X86-AVX512F-NEXT:    subl $32, %esp
; X86-AVX512F-NEXT:    testb $1, 8(%ebp)
; X86-AVX512F-NEXT:    jne .LBB14_2
; X86-AVX512F-NEXT:  # %bb.1:
; X86-AVX512F-NEXT:    vmovaps 40(%ebp), %ymm1
; X86-AVX512F-NEXT:    vmovaps %ymm2, %ymm0
; X86-AVX512F-NEXT:  .LBB14_2:
; X86-AVX512F-NEXT:    movl %ebp, %esp
; X86-AVX512F-NEXT:    popl %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa %esp, 4
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: pr42355_v32i16:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    testb $1, %dil
; X64-AVX512F-NEXT:    jne .LBB14_2
; X64-AVX512F-NEXT:  # %bb.1:
; X64-AVX512F-NEXT:    vmovaps %ymm2, %ymm0
; X64-AVX512F-NEXT:    vmovaps %ymm3, %ymm1
; X64-AVX512F-NEXT:  .LBB14_2:
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: pr42355_v32i16:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-AVX512BW-NEXT:    jne .LBB14_2
; X86-AVX512BW-NEXT:  # %bb.1:
; X86-AVX512BW-NEXT:    vmovaps %zmm1, %zmm0
; X86-AVX512BW-NEXT:  .LBB14_2:
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: pr42355_v32i16:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    testb $1, %dil
; X64-AVX512BW-NEXT:    jne .LBB14_2
; X64-AVX512BW-NEXT:  # %bb.1:
; X64-AVX512BW-NEXT:    vmovaps %zmm1, %zmm0
; X64-AVX512BW-NEXT:  .LBB14_2:
; X64-AVX512BW-NEXT:    retq
  %a = select i1 %c, <32 x i16> %x, <32 x i16> %y
  ret <32 x i16> %a
}

define <64 x i8> @pr42355_v64i8(i1 %c, <64 x i8> %x, <64 x i8> %y) {
; X86-AVX512F-LABEL: pr42355_v64i8:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    pushl %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa_offset 8
; X86-AVX512F-NEXT:    .cfi_offset %ebp, -8
; X86-AVX512F-NEXT:    movl %esp, %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa_register %ebp
; X86-AVX512F-NEXT:    andl $-32, %esp
; X86-AVX512F-NEXT:    subl $32, %esp
; X86-AVX512F-NEXT:    testb $1, 8(%ebp)
; X86-AVX512F-NEXT:    jne .LBB15_2
; X86-AVX512F-NEXT:  # %bb.1:
; X86-AVX512F-NEXT:    vmovaps 40(%ebp), %ymm1
; X86-AVX512F-NEXT:    vmovaps %ymm2, %ymm0
; X86-AVX512F-NEXT:  .LBB15_2:
; X86-AVX512F-NEXT:    movl %ebp, %esp
; X86-AVX512F-NEXT:    popl %ebp
; X86-AVX512F-NEXT:    .cfi_def_cfa %esp, 4
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: pr42355_v64i8:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    testb $1, %dil
; X64-AVX512F-NEXT:    jne .LBB15_2
; X64-AVX512F-NEXT:  # %bb.1:
; X64-AVX512F-NEXT:    vmovaps %ymm2, %ymm0
; X64-AVX512F-NEXT:    vmovaps %ymm3, %ymm1
; X64-AVX512F-NEXT:  .LBB15_2:
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: pr42355_v64i8:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    testb $1, {{[0-9]+}}(%esp)
; X86-AVX512BW-NEXT:    jne .LBB15_2
; X86-AVX512BW-NEXT:  # %bb.1:
; X86-AVX512BW-NEXT:    vmovaps %zmm1, %zmm0
; X86-AVX512BW-NEXT:  .LBB15_2:
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: pr42355_v64i8:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    testb $1, %dil
; X64-AVX512BW-NEXT:    jne .LBB15_2
; X64-AVX512BW-NEXT:  # %bb.1:
; X64-AVX512BW-NEXT:    vmovaps %zmm1, %zmm0
; X64-AVX512BW-NEXT:  .LBB15_2:
; X64-AVX512BW-NEXT:    retq
  %a = select i1 %c, <64 x i8> %x, <64 x i8> %y
  ret <64 x i8> %a
}

; This would crash because AVX512 has legal vector select
; condition values that are not 256/512-bit vectors.

define <16 x i64> @narrowExtractedVectorSelect_crash(<16 x i64> %arg, <16 x i16> %arg1) #0 {
; X86-AVX512F-LABEL: narrowExtractedVectorSelect_crash:
; X86-AVX512F:       # %bb.0:
; X86-AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X86-AVX512F-NEXT:    vptestmq %zmm1, %zmm1, %k1
; X86-AVX512F-NEXT:    kunpckbw %k0, %k1, %k1
; X86-AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; X86-AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; X86-AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm1
; X86-AVX512F-NEXT:    vpmovzxwq {{.*#+}} zmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X86-AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm1
; X86-AVX512F-NEXT:    vpmovzxwq {{.*#+}} zmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X86-AVX512F-NEXT:    retl
;
; X64-AVX512F-LABEL: narrowExtractedVectorSelect_crash:
; X64-AVX512F:       # %bb.0:
; X64-AVX512F-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X64-AVX512F-NEXT:    vptestmq %zmm1, %zmm1, %k1
; X64-AVX512F-NEXT:    kunpckbw %k0, %k1, %k1
; X64-AVX512F-NEXT:    vpternlogd $255, %zmm0, %zmm0, %zmm0 {%k1} {z}
; X64-AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; X64-AVX512F-NEXT:    vpand %ymm2, %ymm0, %ymm1
; X64-AVX512F-NEXT:    vpmovzxwq {{.*#+}} zmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X64-AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm1
; X64-AVX512F-NEXT:    vpmovzxwq {{.*#+}} zmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X64-AVX512F-NEXT:    retq
;
; X86-AVX512BW-LABEL: narrowExtractedVectorSelect_crash:
; X86-AVX512BW:       # %bb.0:
; X86-AVX512BW-NEXT:    # kill: def $ymm2 killed $ymm2 def $zmm2
; X86-AVX512BW-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X86-AVX512BW-NEXT:    vptestmq %zmm1, %zmm1, %k1
; X86-AVX512BW-NEXT:    kunpckbw %k0, %k1, %k1
; X86-AVX512BW-NEXT:    vmovdqu16 %zmm2, %zmm1 {%k1} {z}
; X86-AVX512BW-NEXT:    vpmovzxwq {{.*#+}} zmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X86-AVX512BW-NEXT:    vextracti128 $1, %ymm1, %xmm1
; X86-AVX512BW-NEXT:    vpmovzxwq {{.*#+}} zmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X86-AVX512BW-NEXT:    retl
;
; X64-AVX512BW-LABEL: narrowExtractedVectorSelect_crash:
; X64-AVX512BW:       # %bb.0:
; X64-AVX512BW-NEXT:    # kill: def $ymm2 killed $ymm2 def $zmm2
; X64-AVX512BW-NEXT:    vptestmq %zmm0, %zmm0, %k0
; X64-AVX512BW-NEXT:    vptestmq %zmm1, %zmm1, %k1
; X64-AVX512BW-NEXT:    kunpckbw %k0, %k1, %k1
; X64-AVX512BW-NEXT:    vmovdqu16 %zmm2, %zmm1 {%k1} {z}
; X64-AVX512BW-NEXT:    vpmovzxwq {{.*#+}} zmm0 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X64-AVX512BW-NEXT:    vextracti128 $1, %ymm1, %xmm1
; X64-AVX512BW-NEXT:    vpmovzxwq {{.*#+}} zmm1 = xmm1[0],zero,zero,zero,xmm1[1],zero,zero,zero,xmm1[2],zero,zero,zero,xmm1[3],zero,zero,zero,xmm1[4],zero,zero,zero,xmm1[5],zero,zero,zero,xmm1[6],zero,zero,zero,xmm1[7],zero,zero,zero
; X64-AVX512BW-NEXT:    retq
  %tmp = icmp ne <16 x i64> %arg, zeroinitializer
  %tmp2 = select <16 x i1> %tmp, <16 x i16> %arg1, <16 x i16> zeroinitializer
  %tmp3 = zext <16 x i16> %tmp2 to <16 x i64>
  ret <16 x i64> %tmp3
}
