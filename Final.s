####################################################
###      Autor:      Eduardo Vitor Porfirio      ###
###      Matricula:  2221101030                  ###
###      Matéria:    Organização de computadores ###
###      Professor:   Luciano Lores Caimi        ###
####################################################


#Começo do programa
        .data
limpaTela:  .string "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
string1:    .string "Bem vindo a lista encadeada em assembly do risc-v\n"
string2:    .string "Digite a opção que deseja:\n"
string3:    .string "#####---MENU---####\n1) - Inserir elemento na lista:\n2) - Remover elemento por indice:\n3) - Remover elemento por valor:\n4) - Mostrar todos os elementos na lista:\n5) - Mostrar estatisticas:\n6) - Sair do programa:\n"
string4:    .string "Digite: "
string5:    .string "\nInforme o numero a ser adicionado: "
head:       .word   0   #Definindo o endereço de inicio da lista e definindo como null
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
            li a7, 4
            la a0, string5
            ecall
            li a7, 5 #Le um inteiro digitado pelo usuario
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
            li a7, 1
            mv a0, a1
            ecall
            ret

remove_by_index: #função para remover por indice (return -1 error, return 0 success)
            ret

remove_by_value: #função para remover por indice (return -1 error, return 0 success)
            ret

print_list: #printar lista no value returned
            ret

print_statics: #Estatisticas da lista
            ret
