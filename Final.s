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
ErrorInsert:    .string "\nOcorreu um erro de alocacao, Desculpe!"
string1:        .string "\nBem vindo a lista encadeada em assembly do risc-v\n"
string2:        .string "Digite a opção que deseja:\n"
string3:        .string "\n#####---MENU---####\n1) - Inserir elemento na lista:\n2) - Remover elemento por indice:\n3) - Remover elemento por valor:\n4) - Mostrar todos os elementos na lista:\n5) - Mostrar estatisticas:\n6) - Sair do programa:\n"
string4:        .string "Digite: "
string5:        .string "\nInforme o numero a ser adicionado: "
lista_vazia:    .string "A lista está vazia!\n"
succesInser:    .string "\nA inserção foi um sucesso!\n"
#failInser:      .string "\nOcorreu um problema na inserção!\n"
numInserir:     .string "\nNúmero a ser inserido: "
stringStatic:   .string "\n###---Exibindo as estatisticas da lista---###"
stringStatic1:  .string "\nMaior valor da lista: "
stringStatic2:  .string "\nMenor valor da lista: "
stringStatic3:  .string "\nNumero de elementos na lista: "
stringStatic4:  .string "\nQuantidade de insercoes na lista: "
stringStatic5:  .string "\nQuantidade de remocoes realizados: "
mensagemSair:   .string "\nObrigado por usar a lista encadeada, espero nos vermos novamente!"
head:           .word   0   #Definindo o endereço de inicio da lista e definindo como null
                .text
main:   
                li a7, 4
                la a0, string1 #Carrega o endereço da primeira string
                ecall
                la a0, string2 #
                ecall
                li s4, 0 #Inicializa o registrador que vai guardar a quantidade de insercoes realizadas
                li s5, 0 #Registrador que vai guardar a quantidade de remocoes
print_menu:
                li a7, 4
                la a0, string3
                ecall
                la a0, string4 
                ecall
                li a7, 5
                ecall
                #li s2, 0 #Inicializa o resgistrador que vai guardar o maior valor
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
                j print_menu  # jump to main

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
                li t6, 1
                beq a0, t1, success	#Retorno de sucesso.
                li t6, -1
                beq a0, t6, error       #Retorno de erro da funcao
success:
		li a7, 4
		la a0, succesInser
		ecall
                j print_menu  # jump to menu
error:
                la a0, ErrorInsert
                li a7, 4
                ecall
                j print_menu
            
call_rmindex:
                jal remove_by_index  # jump to remove_by_index and save position to ra
                j print_menu

call_rmvalue:
                jal remove_by_value  # jump to remove_by_value and save position to ra
                j print_menu

call_print:
                la a0, head #carrega o endereço inicial da lista
                jal print_list  # jump to print_list and save position to ra
                j print_menu

call_statics:
                #Registradores S usados para armazenar as estatisticas da lista
                li a7, 4
                la a0, stringStatic #printa o inicio das mensagens das estatisticas
                ecall
                la a0, head
                jal print_statics  # jump to print_statics and save position to ra
                j print_menu

call_end:
                jal exit_list

#####################---Implementação Das Funções---##########################


insert_int:                             #função para inserir um numero inteiro na lista (return -1 insert error, return 0 insert success)
                #alocando a memória necessária
                lw t0, 0(a0)            #Salva o valor do head 
                mv t1, a0               #t1 armazena o valor da cabeça da lista
                li a0, 8# a0 = 8        #tamanho de 8 bytes de alocação 4 valor 4 ponteiro retorno do endereço alocado está em a0
                li a7, 9
                ecall
                li t6, -1               #Carrega o valor de erro de alocacao -1
                beq a0, t6, error_malloc   #Testa se o endereco retornado n
                addi s4, s4, 1          #Atualiza o contador de insercoes realizadas, depois de comparar se a alocacao foi bem sucedida
                sw a1, 0(a0)            #adicionando o primeiro valor para a lista
                sw zero, 4(a0)          #define o proximo ponteiro como null
                beqz t0, insert_ifnull  #se a lista tiver totalmente vazia apenas adicionamos no inicio
                lw t3, 0(t0)            #carrega o valor do elemento head
                lw t4, 0(a0)            #Carrega o valor do novo nó
                ble t4, t3, insert_head #se o novo valor for menor que o que está no head então adicionamos no head
go_end:
                lw t2, 4(t0)            #carrega o prox endereço
                lw t5, 0(t0)            #Pega o valor do endereço atual
                bge t5, t4, insert_middle #vai indicar a posição que o novo nó vai ser posiconado
                mv t1, t0               #carrega o elemento anterior ao que foi testado
                beqz t2, insert_notnull #testa se for nulo então insere no final
                mv t0, t2               #anda pela lista
                j go_end

insert_head:
                sw t0, 4(a0)            #Faz o ponteiro do novo head apontar para o antigo head 
                sw a0, 0(t1)            #Faz o head da lista apontar para o novo node.
                li a0, 1		 #Retorn
                ret
insert_middle:
                #A lógica é percorrer a lista e encontrar a posição do novo valor, essa posição está em a0 
                #Aqui devo apenas fazer o emponteiramento dos valores
                sw t0, 4(a0)            #Faz o ponteiro do novo nó apontar para o antigo
                sw a0, 4(t1)            #Faz o ponteiro do anterior apontar para o novo
                li a0, 1		 #Retorno
                ret

insert_ifnull:
                sw a0, 0(t1) #Apontamos para o primeiro indice
                li a0, 1		 #Retorno
                ret
insert_notnull:
                sw a0, 4(t0)             #Insere no fim da lista
                li a0, 1		 #Retorno
                ret

error_malloc:
                li a0, -1               #retorno de erro da func
                ret                
#Fim dos labels para funcionamento da função de inserir um valor

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
#Fim dos labels para a função de printar uma lista
print_statics: #Estatisticas da lista
                #capturar o menor valor da lista
                li s6, 0 #Registrador para guardar o numero de elementos na lista
                lw t0, 0(a0) #Salva o endereco do primeiro elemento
                li a7, 4
                la a0, stringStatic2    
                ecall
                li a7, 1
                #mv a0, s3
                lw a0, 0(t0)
                ecall        #Printa o menor da lista
                #vai atras do maior valor
percorrer_fim:
                lw t0, 4(t0) #Carrega o proximo valor presente na lista
                #bnez t0, percorrer_fim
                #S6 guarda o numero de elementos
                addi s6, s6, 1 # s6 = s6 + 1 #Conta quantos elementos a lista possui
                beq t0, zero, printa_maior
                mv t1, t0       #Pega o item da lista anterior, util quando chegar no ultimo
                j percorrer_fim
printa_maior:
                la a0, stringStatic1
                li a7, 4
                ecall
                li a7, 1
                lw a0, 0(t1)    #Carrega em a0 o valor do ultimo node
                #Percorre a lista e encontra o maior valor que esta no fim da lista
                ecall
                li a7, 4
                la a0, stringStatic3 #printa o numero de elementos na lista
                ecall
                li a7, 1 
                mv a0, s6
                ecall
                la a0, stringStatic4 #printa o numero de insercoes realizadas na lista 
                li a7, 4
                ecall
                mv a0, s4
                li a7, 1
                ecall
                ret

exit_list:
                li a7, 4
                la a0, mensagemSair
                ecall
                li a7, 93
                ecall
