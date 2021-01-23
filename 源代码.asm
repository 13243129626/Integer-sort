#项目名称：整数排序  
##########################################################
#程序功能描述：
#输入数字字串并转为整型数据存储
#显示数字个数和输入的整数
#排序（递增）后输出最终结果
###########################################################
#函数描述：
#change1: 将字符串转换为数值并储存
#output1: 输出转换后的数值数组
#done: 将数组进行排序（递增）
###########################################################
      .data
start:  .asciiz "Input Numbers: \n"            #输入提示串
output_1:  .asciiz "The  num  of  all  is:   "     #数组大小
output_2:  .asciiz  "\n The detail:\n"           #数组详细数值
empty:   .asciiz  "  "                     #空格
output_3:  .asciiz "\n The detail after sort is:\n"     #排序后的数组数据
num:  .word 0             
      .space 1024                             #定义一个整型数组及大小
string:  .space 1024                           #定义字符串数组及大小
   .globl main 
   .text
main:   la  $a0,start
        li $v0,4
        syscall           #初始提示串
        la  $a0,string 
        li  $a1,1024
        li $v0,8
        syscall         #输入字符串
        move $t0,$a0
        li $s0,0x20          #空格
        li $s1,0x0a           #换行
        la  $a0,num           #数组初地址
        move $t1,$a0
        li $a0,0
        li $t2,0
        addi  $sp,$sp,-12
        sw  $t1,0($sp)
        sw  $t0,4($sp)
        sw  $ra,8($sp)          #利用栈保护相关数值
        jal  change1        #将字符串转换为数值并储存
        lw  $ra,8($sp)
        lw  $t0,4($sp)
        lw  $t1,0($sp)
        addi  $sp,$sp,12         #恢复
        la  $a0,output_1
        li $v0,4
        syscall
        move  $a0,$t2
        li  $v0,1
        syscall
        la  $a0,output_2                #输出提示串
        li $v0,4
        syscall
        addi  $sp,$sp,-12
        sw  $t1,0($sp)     
        sw  $t2,4($sp)
        sw  $ra,8($sp)
        jal  output1           #输出转换后的数值数组
        lw   $ra,8($sp)
        lw   $t2,4($sp)
        lw   $t1,0($sp)
        addi  $sp,$sp,12
        addi  $sp,$sp,-12
        sw  $t2,0($sp)    #数组大小
        sw  $t1,4($sp)    #数组初地址
        sw  $ra,8($sp)
        jal  done             #调用排序函数
        lw  $ra,8($sp)
        lw  $t1,4($sp)
        lw  $t2,0($sp)
        addi  $sp,$sp,12
        la  $a0,output_3        #输出提示
        li  $v0,4
        syscall
        jal  output1            #输出排序后的数组
        li  $v0,10                  #退出
        syscall
loop0:  sw $a0,($t1)          #存入整型数组
        addi  $t1,$t1,4       #整型数组地址加4
        addi $t2,$t2,1      #记录数组大小
        addi $t0,$t0,1      #字符串地址加1
        li $a0,0
change1: lb  $a3,($t0)           #取一个字节
        beq $a3,$s0,loop0         #为空格则到loop0
        beq  $a3,$s1,ret1         #为回车则到ret1
        beqz  $a3,ret             #为0则到ret
        mul  $a0,$a0,10          
        addi $a2,$a3,-48          #字符转换
        addu  $a0,$a0,$a2
        addi  $t0,$t0,1       #地址加一
        b  change1
done: la   $a0, num    #a0=num首地址
       addi  $t0,$t2,-1      #外循环变量t0初始化为数组长度-1
lp0:   addi $a1, $a0, 4    #外循环起点。内循环的起始比较单元初始化
       addi $t1, $t0,-1    #内循环变量t1初始化，t1=t0-1
lp1:   lw   $t2, ($a0)     #内循环起点。取出本趟比较的单元
       lw   $t3, ($a1)     #逐个取出随后的单元
       ble  $t2, $t3, next #前面的小，则什么都不做
       sw   $t2, ($a1)     #前面的大，则交换2个单元
       sw   $t3, ($a0)
next:  addi $a1, $a1, 4    #a1指向下一个单元
       addi $t1, $t1,-1    #内循环变量t1--
       bgez  $t1,lp1   #内循环结束，直到t1=0退出循环
       addi $a0, $a0, 4    #准备下一轮，a1指向下一轮比较的单元
       addi $t0, $t0,-1    #外循环变量t0--
       bgt  $t0, $0, lp0   #外循环结束，直到t0=0退出循环
       j  ret         # 返回

output1:   beqz  $t2,ret       #控制条件
           lw  $a0,($t1)
           li  $v0,1            #输出数组元素
           syscall
           addi  $t2,$t2,-1
           addi  $t1,$t1,4
           la  $a0,empty          #空格
           li $v0,4
           syscall
           b  output1
ret1:  sw  $a0,($t1)
       addi  $t2,$t2,1
       jr  $ra           #存储并返回
ret:  jr  $ra            #返回
        
