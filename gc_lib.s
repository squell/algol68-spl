
F_reinitHeap:
    mov eax, [heap_end]
    mov [heap_ptr], eax
    mov eax, offset heap_fixedsize
    ret 0

F_mkAvail:
    mov eax, [esp+4]
    lea eax, [heap_start+eax*8]
    push edx
    mov edx, [heap_ptr]
    mov [heap_ptr], eax
    mov [eax], edx
    pop edx
    ret 4

F_bssSize:
    mov eax, offset _end
    sub eax, [heap_end]
    shr eax, 2
    ret 0

F_bss:
    mov eax, [esp+4]
    mov eax, [__bss_start+eax*4]
    ret 4

F_stackSize:
    mov eax, [stack_start]
    sub eax, ebp # use parents frame
    shr eax, 2
    ret 0

F_stack:
    mov eax, [esp+4]
    mov eax, [ebp+eax*4]
    ret 4

F_touch:
    mov eax, [esp+4]
    sub eax, offset heap_start
    shr eax, 3
    push ecx
    mov ecx, eax
    shr eax, 5
    bts [heap_mark+eax], ecx
    pop ecx
    ret 4

F_reached:
    mov eax, [esp+4]
    push ecx
    mov ecx, eax
    shr eax, 5
    btr [heap_mark+eax], ecx
    mov eax, 0
    pop ecx
    setc al
    ret 4

F_valid:
    mov eax, [esp+4]
    test eax, 7
    jnz .Lnull
    cmp eax, offset heap_start
    jb .Lnull
    cmp eax, offset heap_start+heap_fixedsize*8
    jae .Lnull
    ret 4
.Lnull:
    xor eax, eax
    ret 4

F_read:
    mov eax, [esp+4]
    ret 4

