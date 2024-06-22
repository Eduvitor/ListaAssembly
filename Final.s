##################################################################
###      Autor:      Eduardo Vitor Porfirio                    ###
###      Matricula:  2221101030                                ###
###      Matéria:    Organização de computadores               ###
###      Professor:  Luciano Lores Caimi                       ###
###                                                            ###
##################################################################


#Começo do programa
        .data
fmt:            .string "\nElemento: " 
ErrorInsert:    .string "\nOcorreu um erro de alocacao, Desculpe!"
string1:        .string "\nBem vindo a lista encadeada em assembly do risc-v\n"
string2:        .string "Digite a opção que deseja:\n"
string3:        .string "\n#####---MENU---####\n1) - Inserir elemento na lista:\n2) - Remover elemento por indice:\n3) - Remover elemento por valor:\n4) - Mostrar todos os elementos na lista:\n5) - Mostrar estatisticas:\n6) - Sair do programa:\n"
string4:        .string "Digite: "
string5:        .string "\nInforme o numero a ser adicionado: "
lista_vazia:    .string "\nA lista está vazia!\n"
succesInser:    .string "\nA inserção foi um sucesso!\n"
numInserir:     .string "\nNúmero a ser inserido: "
stringStatic:   .string "\n###---Exibindo as estatisticas da lista---###"
stringStatic1:  .string "\nMaior valor da lista: "
stringStatic2:  .string "\nMenor valor da lista: "
stringStatic3:  .string "\nNumero de elementos na lista: "
stringStatic4:  .string "\nQuantidade de insercoes na lista: "
stringStatic5:  .string "\nQuantidade de remocoes realizados: "
mensagemSair:   .string "\nObrigado por usar a lista encadeada, espero nos vermos novamente!"
stringUE:       .string "\nDigite o valor a ser removido: "
stringUI:       .string "\nDigite o indice a ser removido: "
stringExcludeV: .string "\nValor a ser removido: "
m_sucess_rm:    .string "\nO valor foi removido com sucesso!\nIndice removido: "
stringExcludeI:  .string "\nIndice a ser removido: "
valueExcludeS:  .string "\nA exclusao do elemento foi um sucesso\nValor removido: "
errorExclude:   .string "\nO valor informado nao esta presente na lista!"
errorExcludeOutR: .string "\nVoce digitou um indice que esta fora do range da lista!\nDigite um indice valido!"
head:           .word   0   #Definindo o endereço de inicio da lista e definindo como null
                .text
main:   
                li a7, 4
                la a0, string1 #Carrega o endereço da primeira string
                ecall
                la a0, string2 #
                ecall
                li s4, 0 #Inicializa o registrador que vai guardar a quantidade de insercoes realizadas
                li s5, 0 #Registrador que vai guardar a quantidade de remocoes || Remocoes = Num de elementos na lista - Num de remocoes realizadas
print_menu:
                li a7, 4
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
                la a0, head
                lw t0, 0(a0)
                beq t0, zero, empity_list #Testamos se a lista ta vazia
                la a0, stringUI
                li a7, 4 
                ecall
                li a7, 5
                ecall
                mv a1, a0       #Salva o valor digitado pelo usuário
                la a0, head     #Retorna o valor de head para a0
                jal remove_by_index  # jump to remove_by_index and save  position to ra
                li t6, 1
                beq t6, a0, rmindex_success # if t0 == t1 then target
                li t6, -1
                beq t6, a0, rmindex_error       #Testa se teve erro no retorno
rmindex_success: #a1 valor do elemento a remover
                la a0, valueExcludeS
                li a7, 4
                ecall
                mv a0, a1
                li a7, 1
                ecall
                j print_menu
rmindex_error:
                la a0, errorExcludeOutR
                li a7, 4
                ecall
                j print_menu  # jump to print_menu
            
call_rmvalue:
                la a0, head
                lw t2, 0(a0) #Carrega o enderecos
                beq t2, zero, empity_list # if a0 == zero then target testa se a lista ta vazia antes de tomar qualquer acao
                la a0, stringUE #pede ao usuario qual numero excluir
                li a7, 4       #printa
                ecall
                li a7, 5
                ecall
                mv a1, a0       #Passa o valor para a1
                la a0, stringExcludeV #Printa o valor a ser removido
                li a7, 4
                ecall
                li a7, 1        # 1 printar inteiro
                mv a0, a1 
                ecall
                la a0, head
                jal remove_by_value  # jump to remove_by_value and save position to ra
                li t0, -1       #Codigo de erro
                beq a0, t0, erro_remove
                li a7, 4
                la a0, m_sucess_rm
                ecall
                li a7, 1
                mv a0, a2     #Carregao contador de indices
                ecall
                j print_menu
                

erro_remove:    
                la a0, errorExclude
                li a7, 4 
                ecall
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
                #a0 head da lista a1 indice a ser removido 
                lw t1, 0(a0)    #Carrega o endereço do primeiro elemento
                li t3, 0        #Inicializa o contador de indices
                beq t3, a1, remove_head_index   #Se o indice a ser removido é o head ja identificamos aqui para remove-lo
percorrer_index:
                #Indice a ser removido está em a1
                lw t2, 4(t1) #pegamos o prox elemento
                beq t3, a1, achou_index #Se t3 for igual a a1 então achamos o index a ser removido
                addi t3, t3, 1 #Incrementa o contador de indice
                beqz t2, index_not_exists       #se chegarmos ao final da lista significa que o indice não foi encontrado 
                mv t4, t1       #Salva o elemento anterior
                mv t1, t2       #Caminha pela lista 
                j percorrer_index

achou_index:	#Chegou aqui é pq achamos o indice
                lw t5, 4(t1) #Carrega o prox elemento
                beqz t5, remove_index_fim	#Se o index que foi achado é o ultimo da lista então nosso cenário de remoção é no fim da lista  
#Quando precisamos remover no meio da lista
remove_index_meio:
		sw t5, 4(t4)
		lw a1, 0(t1)	#Retorno do valor a ser removido 
		sw zero, 4(t1) #Seta o ponteiro do nó removido para 0 pois não é necessario que ele saiba a localização da lista na memória
		li a0, 1	#Retorno de sucesso
		ret

#Quando o indice não existe
index_not_exists:
                li a0, -1       #Código de erro que o indice não foi encontrado 
                ret
#Situação onde remove o elemento do head sem nó adjacentes
remove_head_index:
		li t0, 0 
		lw t2, 4(t1)	#Carregamos o próx elemento 
		sw t2, 0(a0)	#Seta o head como o prox elemento se for 0 head vai valer 0
		lw a1, 0(t1)
               	li a0, 1
               	ret	
remove_index_fim:
		li a1, 0 
		sw a1, 4(t4)	#Seta o ponteiro do nó anterior como zero
		li a0, 1	#Retorno de sucesso
		lw a1, 0(t1)	#Retorna o valor que foi removido 
		ret
#FIm dos labels para remocao por indice
remove_by_value: #função para remover por indice (return -1 error, return 0 success)
                #a0 head da lista, a valor a ser removido
                lw t1, 0(a0)    #Carregam o primeiro elemento
                lw t5, 0(t1)    #Carrega o valor do primeiro elemento
                mv s2, zero  #Inicializa o contador de indices
                beq a1, t5, remove_inicio       #Identificado que o valor para ser removido é o head      
search_loop:    #a situacao complica um pouco caso o elemento a ser removido é o head, portanto aqui passa pela implementação de uma state machine onde temos uma condicao composta
                lw t2, 4(t1)    #Carrega o prox elemento
                lw t3, 0(t1)    #Pega o valor do elemento atual
                beq a1, t3, find_remove #Identifica se o valor foi encontrado na lista
                mv t4, t1               #Guarda o valor anterior do encontro
                addi s2, s2, 1  #adiciona em 1 para contar os indices
                beqz t2, not_achou      #náo achou o valor na lista 
                mv t1, t2               #Caminha pela lista
                j search_loop           #Volta para o loop

find_remove:    #Aqui ja achamos o valor a remover na lista
                lw t5, 4(t1)    #Carregamos o endereço do ponteiro para o prox elemento
                beqz t5, remove_fim #Testa para ver se ele é o ultimo elemento da lista.

remove_meio:    #Ponteiro do no anterior ao removido passa a apontar para o no seguinte do removido, zerar valores do no removido 
                sw t5, 4(t4)       #Carrega o valor do próx ponteiro no nó anterior 
                sw zero, 4(t1)     #Seta o ponteiro do no a ser removido como 0 só por segurança
                li a0, 1           #Retorno de sucesso
                mv a2, s2
                ret

remove_fim:     #Simplesmente desfazer o emponteiramento do penultimo no setando seu ponteiro para 0
                li a1, 0        #Carrega 0 para redefinimos o ponteiro
                sw a1, 4(t4)    #Seta o ponteiro do no anterior para 0
                li a0, 1        #Valor de retorno da funcao
                mv a2, s2
                ret

remove_inicio:  #Head deve guardar o valor do ponteiro do no removido caso ele for o primeiro, devemos setar o head para 0
                li t0, 0        #Carregamos o t0 com 0 para redefinimos o head
                lw t2, 4(t1)    #Carrega o ponteiro do primeiro nó
                #bne t2, t0, not_unique     #Testa para ver se o elemento é o unico da lista
                sw t2, 0(a0)    #Seta o head como zero
                li a1, 1        #Retorno de sucesso
                mv a2, s2
                ret
not_achou:      #Informa ao usuario que nao achou o valor e retorna -1 para indicar erro!
                li a0, -1 
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

                lw t2, 4(t2)    #Carrega endereco do prox elemento
                bnez t2, print_loop
                j end_print
end_print:
                ret

empity_list:    #informa se a lista tá vazia
                li a7, 4
                la a0, lista_vazia #informa que a lista tá vazia 
                ecall
                j print_menu
#Fim dos labels para a função de printar uma lista
print_statics: #Estatisticas da lista
                #capturar o menor valor da lista
                lw t2, 0(a0) #Carrega o endereco
                li s6, 0 #Registrador para guardar o numero de elementos na lista
                beq t2, zero, lista_vazia_statics# if a0 == zero then target
                lw t0, 0(a0) #Salva o endereco do primeiro elemento
                li a7, 4
                la a0, stringStatic2    
                ecall
                li a7, 1
                #mv a0, s3
                lw a0, 0(t0)
                ecall        #Printa o menor da lista
                #lw t5, 4(t0) #Testa se a tem apenas um elemento
                #beqz t5, printa_maior
                #vai atras do maior valor
                mv t1, t2
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
                lw a0, 0(t1)
                #mv a0, t2    #Carrega em a0 o valor do ultimo node informa erro nessa linha quando temos apenas um item na lista
                #Percorre a lista e encontra o maior valor que esta no fim da lista
                ecall
                li a7, 4
                la a0, stringStatic3 #printa o numero de elementos na lista
                ecall
                li a7, 1 
                mv a0, s6
                ecall
lista_vazia_statics:
                la a0, stringStatic4 #printa o numero de insercoes realizadas na lista 
                li a7, 4
                ecall
                mv a0, s4
                li a7, 1
                ecall
                la a0, stringStatic5	#Printar número de remocoes realizadas
                li a7, 4
                ecall
                li a7, 1
                sub a0, s4, s6	#Subtrai o numero de insercoes pelo numero de elementos na lista
                ecall
                ret

exit_list:
                li a7, 4
                la a0, mensagemSair
                ecall
                li a7, 93
                ecall
