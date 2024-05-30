#################################################
#       Autor:      Eduardo Vitor Porfirio      #
#       Matricula:  2221101030                   #
#       Semestre:   2024.1                      #
#       Matéria:    Organização de computadores #
#################################################


#Começo do programa
        .data
string1: .string "Bem vindo a lista encadeada em assembly do risc-v\n"
string2: .string "Digite a opção que deseja:\n"
string3: .string "#####---MENU---####\n1) - Inserir elemento na lista:\n2) - Remover elemento por indice:\n3) - Remover elemento por valor:\n4) - Mostrar todos os elementos na lista:\n5) - Mostrar estatisticas:\n6) - Sair do programa:"
string4: .string "Digite: \n"
head:   .word   0   #Definindo o endereço de inicio da lista
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
            li a7, 5
            ecall

insere_inteiro: #função para inserir um numero inteiro na lista (return -1 insert error, return 0 insert success)
            ret

remove_by_index: #função para remover por indice (return -1 error, return 0 success)
            ret

remove_by_value: #função para remover por indice (return -1 error, return 0 success)
            ret

print_list: #printar lista no value returned
            ret

print_statics: #Estatisticas da lista
            ret
