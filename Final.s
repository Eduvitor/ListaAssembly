####################################################
###      Autor:      Eduardo Vitor Porfirio      ###
###      Matricula:  2221101030                  ###
###      Matéria:    Organização de computadores ###
###      Professor:  Luciano Lores Caimi         ###
####################################################


#Começo do programa
        .data
fmt:            .string "\nElemento: "        #define um formato para printar os elementos 
limpaTela:      .string "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
string1:        .string "\nBem vindo a lista encadeada em assembly do risc-v\n"
string2:        .string "Digite a opção que deseja:\n"
string3:        .string "#####---MENU---####\n1) - Inserir elemento na lista:\n2) - Remover elemento por indice:\n3) - Remover elemento por valor:\n4) - Mostrar todos os elementos na lista:\n5) - Mostrar estatisticas:\n6) - Sair do programa:\n"
string4:        .string "Digite: "
string5:        .string "\nInforme o numero a ser adicionado: "
lista_vazia:    .string "A lista está vazia!\n"
succesInser:    .string "A inserção foi um sucesso!\n"
failInser:      .string "Ocorre um problema na inserção!\n"
numInserir:     .string "Número a ser inserido: "
head:           .word   0   #Definindo o endereço de inicio da lista e definindo como null
                .text
main:   
                li a7, 4
                la a0, string1 #Carrega o endereço da primeira string
                ecall
                la a0, string2 #
                ecall
                la a0, string3
                ecall
                la a0, string4 
                ecall
                li a7, 5
                ecall
                add t0, a0, zero # t0 = a0 + zero
                #inicia as comparações para saber qual função chamar 
                li t1, 1
                beq t0, t1, call_insert #se for igual a 1 ele vai para a chamada da func 1
                li t1, 2
                beq a0, t1, call_rmindex #se for igual a 2 ele vai para a chamada da func 2
                li t1, 3
                beq a0, t1, call_rmvalue # se for igual a 3 ele vai para a chamada da func 3
                li t1, 4 
                beq a0, t1, call_print #se for igual a 4 ele vai para printar a lista
                li t1, 5 
                beq a0, t1, call_statics #se for igual a 5 ele vai printar a lista
                li t1, 6 
                beq a0, t1, call_end #vai para o fim do programa
                j main  # jump to main

#definição da chamada das funções e carregamento dos argumentos
call_insert:
                #carregar os argurmentos a0 inicio da list a1 o valor a ser inserido
                li a7, 4        #print string info
                la a0, string5
                ecall
                li a7, 5 #Le um inteiro digitado pelo usuario
                ecall
                mv a1, a0 #carrega o valor que vai pedir do usuário em a1
                la a0, numInserir       #mostra ao user o num que vai inserir
                li a7, 4
                ecall
                mv a0, a1 #mostra o numero a ser inserido 
                li a7, 1
                ecall
                mv a1, a0 #carrega o valor que vai pedir do usuário em a1
                la a0, head #carrega o inicio da lista 
                jal insert_int  # jump to insert_int and save position to ra
                j main  # jump to menu
            
call_rmindex:
                jal remove_by_index  # jump to remove_by_index and save position to ra
                j main

call_rmvalue:
                jal remove_by_value  # jump to remove_by_value and save position to ra
                j main

call_print:
                la a0, head #carrega o endereço inicial da lista
                jal print_list  # jump to print_list and save position to ra
                j main

call_statics:
                jal print_statics  # jump to print_statics and save position to ra
                j main

call_end:
                li a7, 93
                ecall

#####################---Implementação Das Funções---##########################


insert_int: #função para inserir um numero inteiro na lista (return -1 insert error, return 0 insert success)
                #alocando a memória necessária
                lw t0, 0(a0) #Salva o valor do head 
                mv t1, a0       #t1 armazena o valor da cabeça da lista
                li a0, 8# a0 = 8      #tamanho de 8 bytes de alocação 4 valor 4 ponteiro retorno do endereço alocado está em a0
                li a7, 9
                ecall
                sw a1, 0(a0) # adicionando o primeiro valor para a lista
                sw zero, 4(a0) #define o proximo ponteiro como null
                beqz t0, insert_ifnull #se a lista tiver totalmente vazia apenas adicionamos no inicio
go_end:
                lw t2, 4(t0)
                beqz t2, insert_notnull
                mv t0, t2
                j go_end
insert_ifnull:
                sw a0, 0(t1) #Apontamos para o primeiro indice
                ret
insert_notnull:
                sw a0, 4(t0) # 
                ret                

remove_by_index: #função para remover por indice (return -1 error, return 0 success)
                ret

remove_by_value: #função para remover por indice (return -1 error, return 0 success)
                
                ret

print_list:
                lw t2, 0(a0) #Carrega o endereco
                beq t2, zero, empity_list # if a0 == zero then target
print_loop:
                lw t1, 0(t2)    #carrega o valor do nó atual em t1
                la a0, fmt      #Carrega o formato do print
                mv a1, t1       #move o valor do nó atual para a1
                li a7, 4        #carrega cod pra printar str
                ecall
                mv a0, a1       #carrega valor para printar
                li a7, 1        #cod para printar int
                ecall

                lw t2, 4(t2)
                bnez t2, print_loop
                j end_print
end_print:
                ret

empity_list:    #informa se a lista tá vazia
                li a7, 4
                la a0, lista_vazia #informa que a lista tá vazia 
                ecall
                ret

print_statics: #Estatisticas da lista
                ret
