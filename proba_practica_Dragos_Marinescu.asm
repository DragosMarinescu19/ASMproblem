bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit,scanf,printf,fopen,fclose,fread,fscanf               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import printf msvcrt.dll                         ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
import scanf msvcrt.dll
import fopen msvcrt.dll
import fclose msvcrt.dll
import fread msvcrt.dll
import fscanf msvcrt.dll
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; Se citeste de la tastatura un nume de fisier, un caracter c si un numar n. Sa se determine daca numarul de aparitii ale caracterului c, urmat de un spatiu, in textul fisierului este egal cu numarul n, afisandu-se la consola un mesaj corespunzator (formatati textul ca si in exemplu)./

; Read from the console a file name, a character c, and a number n. Determine if the number of occurrences of the character c followed by a space from the text file is equal with n, and write the corresponding message to the console (with the format as in the example).

; Example:

; c = a

; n = 2

; Input.txt

; ana are alte mere alina are doar pere

; Console:

; Numarul de aparitii al caracterului a urmat de un spatiu este egal cu numarul 2 citit./

            file resb 100
            car resb 1
            prop db '%s',0
            caracter db '%s',0
            numar db '%d',0
            n dd 0
            mod_acces db 'r',0
            descriptor dd 0
            count dd 100
            dimensiune dd 1
            sir resb 100
            mesaj db 'Numarul de aparitii al caracterului %s urmat de un spatiu este egal cu numarul %d citit',0
            mesaj2 db 'Numarul de aparitii al caracterului %s urmat de un spatiu nu este egal cu numarul %d citit, ci cu %d',0
            

; our code starts here
segment code use32 class=code
    start:
            
            push dword file
            push dword prop
            call [scanf]
            add esp,8
            
            push dword car
            push dword caracter
            call [scanf]
            add esp,8
            
            push dword n
            push dword numar
            call [scanf]
            add esp,8
            
            push dword mod_acces 
            push dword file
            call [fopen]
            add esp,8
            
            cmp eax,0
            je final
            mov [descriptor],eax
            
            push dword [descriptor]
            push dword [count]
            push dword [dimensiune]
            push dword sir
            call [fread]
            add esp,16
            
            mov ecx,0; contor
            
            mov al,[car]
            mov esi,0
            repeta:
            cmp byte [sir+esi],0
            je gata
            cmp byte [sir+esi],al
            je cauta_spatiu
            jmp urmator
            
            cauta_spatiu:
            inc esi
            cmp byte [sir+esi],' '
            je gasit
            dec esi
            
            jmp urmator
            gasit:
            dec esi
            inc ecx
            
            
            urmator:
            inc esi
            jmp repeta
            
            gata:
            cmp ecx,[n]
            je afisare
            jmp afisare2
            afisare:
            push dword ecx
            push dword car
            push dword mesaj
            call [printf]
            add esp,8
            
            jmp inchidere
            
            afisare2:
            
            
            push dword ecx
            push dword [n]
            push dword car
            push dword mesaj2
            call [printf]
            add esp,4
            
            inchidere:
            
            push dword [descriptor]
            call [fclose]
            add esp,4
            
            
            final:
            
            
            
            
            
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
