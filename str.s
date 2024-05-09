.globl process_cstring
.text

check_attribute:         # char cstr_attribute(char const *str)
    pushq %r10
    pushq %r11
    movq $0, %rax       # char result = 0;
    testq %rdi, %rdi    # if (str\
    je F1e              
    cmpb $97 , (%rdi)   # && *str >= 'a'\
    jb F1e
    cmpb $122 , (%rdi)  # && *str <= 'z')
    ja F1e
    jmp F1W1e           # start of while
F1W1b:
    incq %rdi           # ++str;
F1W1e:                  
    movb (%rdi), %r11b  # save *str in %r11b
    testb %r11b, %r11b  # %r11b & %r11b
    jne F1W1b           # while (*str != '\0')
    leaq -1(%rdi), %r10 
    cmpb $97, (%r10)    # if (*(str - 1) >= 'a'\
    jb F1e
    cmpb $122 , (%r10)  # && *(str - 1) <= 'z')
    ja F1e
    movq $1, %rax       # result = 1;
F1e:
    popq %r11
    popq %r10
    ret


rule_1:                 # void rule_1(char *str)
    pushq %r10
    testq %rdi, %rdi    # if (str)
    je F2e
    jmp F2W1e           # start for-loop
F2W1b:
    cmpb $97 , (%rdi)   # if (*str >= 'a'\
    jb F2W1E
    cmpb $122 , (%rdi)  # && *str <= 'z')
    ja F2W1E
    subb $32, (%rdi)    # *str += ('A' - 'a');
    jmp F2W1i           # skip else
F2W1E:
    cmpb $65 , (%rdi)   # else if (*str >= 'A'\
    jb F2W1i
    cmpb $90 , (%rdi)   # && *str <= 'Z')
    ja F2W1i
    addb $32, (%rdi)    # *str += ('a' - 'A');
F2W1i:
    incq %rdi           # ; ++str)
F2W1e:
    movb (%rdi), %r10b
    testb %r10b, %r10b  # for (; *str != '\0';
    jne F2W1b
F2e:
    popq %r10
    ret


rule_2:                 # void rule_2(char *str)
    pushq  %r10
    pushq  %r11
    pushq  %r12
    pushq  %r13
    pushq  %r14
    pushq  %r15
    testq %rdi, %rdi    # if (str)
    je F3e
    movq %rdi, %r10     # char *ptr = str;
    movb (%r10), %r11b  # char last = *ptr;
    jmp F3F1e           # for (; \\start 1st for-loop
F3F1b:
    movb (%r10), %r11b  # last = *ptr;
    incq %r10           # ; ++str)
F3F1e:
    movb (%r10), %r12b
    testb %r12b, %r12b  #  *ptr != '\0';
    jne F3F1b
    movq %rdi, %r10     # ptr = str;
    movq $0, %r13       # int i = 0;
    jmp F3F2e           # for (; \\start 2nd for-loop
F3F2b:
    movq %r10, %r15     # <
    movslq %r13d, %r14  # <
    subq %r14, %r15     # < *(ptr - i) = *ptr;
    movb (%r10), %r14b  # <
    movb %r14b, (%r15)  # <
    cmpb %r11b, (%r10)  # if (*ptr == last)
    jne F3F2i          
    incl %r13d          # ++i;
F3F2i:
    incq %r10           # ; ptr++)
F3F2e:
    movb (%r10), %r12b  # <
    testb %r12b, %r12b  # < ; *ptr != '\0';
    jne F3F2b           # <

    movq %r10, %r15     # <
    movslq %r13d, %r14  # < *(ptr - i) = '\0';
    subq %r14, %r15     # <
    movb $0, (%r15)     # <

F3e:
    popq  %r15
    popq  %r14
    popq  %r13
    popq  %r12
    popq  %r11
    popq  %r10
    ret


process_cstring:        # void process_cstring(char *str)
    pushq %rax          # func has to be void
    pushq %rdi
    call check_attribute 
    popq %rdi
    testb %al, %al      # if (check_attribute(str))
    je L2
    call rule_1         # rule_1(str);
    jmp L1
L2:
    call rule_2         # rule_2(str);
L1: 
    popq %rax
    ret
