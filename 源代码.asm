#��Ŀ���ƣ���������  
##########################################################
#������������
#���������ִ���תΪ�������ݴ洢
#��ʾ���ָ��������������
#���򣨵�������������ս��
###########################################################
#����������
#change1: ���ַ���ת��Ϊ��ֵ������
#output1: ���ת�������ֵ����
#done: ������������򣨵�����
###########################################################
      .data
start:  .asciiz "Input Numbers: \n"            #������ʾ��
output_1:  .asciiz "The  num  of  all  is:   "     #�����С
output_2:  .asciiz  "\n The detail:\n"           #������ϸ��ֵ
empty:   .asciiz  "  "                     #�ո�
output_3:  .asciiz "\n The detail after sort is:\n"     #��������������
num:  .word 0             
      .space 1024                             #����һ���������鼰��С
string:  .space 1024                           #�����ַ������鼰��С
   .globl main 
   .text
main:   la  $a0,start
        li $v0,4
        syscall           #��ʼ��ʾ��
        la  $a0,string 
        li  $a1,1024
        li $v0,8
        syscall         #�����ַ���
        move $t0,$a0
        li $s0,0x20          #�ո�
        li $s1,0x0a           #����
        la  $a0,num           #�������ַ
        move $t1,$a0
        li $a0,0
        li $t2,0
        addi  $sp,$sp,-12
        sw  $t1,0($sp)
        sw  $t0,4($sp)
        sw  $ra,8($sp)          #����ջ���������ֵ
        jal  change1        #���ַ���ת��Ϊ��ֵ������
        lw  $ra,8($sp)
        lw  $t0,4($sp)
        lw  $t1,0($sp)
        addi  $sp,$sp,12         #�ָ�
        la  $a0,output_1
        li $v0,4
        syscall
        move  $a0,$t2
        li  $v0,1
        syscall
        la  $a0,output_2                #�����ʾ��
        li $v0,4
        syscall
        addi  $sp,$sp,-12
        sw  $t1,0($sp)     
        sw  $t2,4($sp)
        sw  $ra,8($sp)
        jal  output1           #���ת�������ֵ����
        lw   $ra,8($sp)
        lw   $t2,4($sp)
        lw   $t1,0($sp)
        addi  $sp,$sp,12
        addi  $sp,$sp,-12
        sw  $t2,0($sp)    #�����С
        sw  $t1,4($sp)    #�������ַ
        sw  $ra,8($sp)
        jal  done             #����������
        lw  $ra,8($sp)
        lw  $t1,4($sp)
        lw  $t2,0($sp)
        addi  $sp,$sp,12
        la  $a0,output_3        #�����ʾ
        li  $v0,4
        syscall
        jal  output1            #�������������
        li  $v0,10                  #�˳�
        syscall
loop0:  sw $a0,($t1)          #������������
        addi  $t1,$t1,4       #���������ַ��4
        addi $t2,$t2,1      #��¼�����С
        addi $t0,$t0,1      #�ַ�����ַ��1
        li $a0,0
change1: lb  $a3,($t0)           #ȡһ���ֽ�
        beq $a3,$s0,loop0         #Ϊ�ո���loop0
        beq  $a3,$s1,ret1         #Ϊ�س���ret1
        beqz  $a3,ret             #Ϊ0��ret
        mul  $a0,$a0,10          
        addi $a2,$a3,-48          #�ַ�ת��
        addu  $a0,$a0,$a2
        addi  $t0,$t0,1       #��ַ��һ
        b  change1
done: la   $a0, num    #a0=num�׵�ַ
       addi  $t0,$t2,-1      #��ѭ������t0��ʼ��Ϊ���鳤��-1
lp0:   addi $a1, $a0, 4    #��ѭ����㡣��ѭ������ʼ�Ƚϵ�Ԫ��ʼ��
       addi $t1, $t0,-1    #��ѭ������t1��ʼ����t1=t0-1
lp1:   lw   $t2, ($a0)     #��ѭ����㡣ȡ�����˱Ƚϵĵ�Ԫ
       lw   $t3, ($a1)     #���ȡ�����ĵ�Ԫ
       ble  $t2, $t3, next #ǰ���С����ʲô������
       sw   $t2, ($a1)     #ǰ��Ĵ��򽻻�2����Ԫ
       sw   $t3, ($a0)
next:  addi $a1, $a1, 4    #a1ָ����һ����Ԫ
       addi $t1, $t1,-1    #��ѭ������t1--
       bgez  $t1,lp1   #��ѭ��������ֱ��t1=0�˳�ѭ��
       addi $a0, $a0, 4    #׼����һ�֣�a1ָ����һ�ֱȽϵĵ�Ԫ
       addi $t0, $t0,-1    #��ѭ������t0--
       bgt  $t0, $0, lp0   #��ѭ��������ֱ��t0=0�˳�ѭ��
       j  ret         # ����

output1:   beqz  $t2,ret       #��������
           lw  $a0,($t1)
           li  $v0,1            #�������Ԫ��
           syscall
           addi  $t2,$t2,-1
           addi  $t1,$t1,4
           la  $a0,empty          #�ո�
           li $v0,4
           syscall
           b  output1
ret1:  sw  $a0,($t1)
       addi  $t2,$t2,1
       jr  $ra           #�洢������
ret:  jr  $ra            #����
        
