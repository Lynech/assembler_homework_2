.globl process_cstring
.text

check_attribute:        # char cstr_attribute(char const *str)
    movq $0, %rax       # char result = 0;
    testq %rdi, %rdi    # if (str\
    je F1e              
    cmpb $97 , (%rdi)   # && *str >= 'a'\
    jl F1e
    cmpb $122 , (%rdi)  # && *str <= 'z')
    jg F1e
    jmp F1W1e           # start of while
F1W1b:
    incq %rdi           # ++str;
F1W1e:                  
    movb (%rdi), %r9b   # save *str in %r9b
    testb %r9b, %r9b    # %r9b & %r9b
    jne F1W1b           # while (*str != '\0')
    leaq -1(%rdi), %r8 
    cmpb $97, (%r8)     # if (*(str - 1) >= 'a'\
    jl F1e
    cmpb $122 , (%r8)   # && *(str - 1) <= 'z')
    jg F1e
    movq $1, %rax       # result = 1;
F1e:
    ret


rule_1:                 # void rule_1(char *str)
    testq %rdi, %rdi    # if (str)
    je F2e
    jmp F2W1e           # start for-loop
F2W1b:
    cmpb $97 , (%rdi)   # if (*str >= 'a'\
    jl F2W1E
    cmpb $122 , (%rdi)  # && *str <= 'z')
    jg F2W1E
    subb $32, (%rdi)    # *str += ('A' - 'a');
    jmp F2W1i           # skip else
F2W1E:
    cmpb $65 , (%rdi)   # else if (*str >= 'A'\
    jl F2W1i
    cmpb $90 , (%rdi)   # && *str <= 'Z')
    jg F2W1i
    addb $32, (%rdi)    # *str += ('a' - 'A');
F2W1i:
    incq %rdi           # ; ++str)
F2W1e:
    movb (%rdi), %r8b
    testb %r8b, %r8b    # for (; *str != '\0';
    jne F2W1b
F2e:
    ret


rule_2:                 # void rule_2(char *str)
    testq %rdi, %rdi    # if (str)
    je F3e
    movq %rdi, %r8      # char *ptr = str;
    movb (%r8), %r9b    # char last = *ptr;
    jmp F3F1e           # for (; \\start 1st for-loop
F3F1b:
    movb (%r8), %r9b    # last = *ptr;
    incq %r8            # ; ++str)
F3F1e:
    movb (%r8), %r10b
    testb %r10b, %r10b  #  *ptr != '\0';
    jne F3F1b
    movq %rdi, %r8      # ptr = str;
    movq $0, %r11       # int i = 0;
    jmp F3F2e           # for (; \\start 2nd for-loop
F3F2b:
    movq %r8, %rsi      # <
    movslq %r11d, %r11  # <
    subq %r11, %rsi     # < *(ptr - i) = *ptr;
    movb (%r8), %r10b   # <
    movb %r10b, (%rsi)  # <
    cmpb %r9b, (%r8)    # if (*ptr == last)
    jne F3F2i          
    incl %r11d          # ++i;
F3F2i:
    incq %r8            # ; ptr++)
F3F2e:
    movb (%r8), %r10b   # <
    testb %r10b, %r10b  # < ; *ptr != '\0';
    jne F3F2b           # <

    movslq %r11d, %r11  # <
    negq %r11           # < *(ptr - i) = '\0';
    movb $0, (%r8, %r11)# <

F3e:
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
