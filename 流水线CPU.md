# 项目二：流水线CPU的**设计与实现**

## 一.实验目的

(1) 认识和掌握流水线数据通路图的构成、原理及其设计方法；

(2) 掌握流水线CPU的实现方法，代码实现方法；

(3) 编写一个编译器，将MIPS汇编程序编译为二进制机器码；

(4) 掌握流水线CPU的测试方法;

(5) 掌握流水线CPU的实现方法。



## 二.实验内容

设计一个流水线CPU，该CPU在单周期指令集的基础上增加实现以下指令功能操作。



### 1. 新增指令及其处理方式

逻辑运算指令

  （1）xori rt , rs , **immediate**

| 001110 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：GPR[rt] ← GPR[rs] XOR zero_extend( **immediate**)。

 ***针对此改变，Control Unit需要在原基础上增加这条指令的控制信号，并且设置一个相应的ALUCtr信号。***



比较指令

（1）slt rd, rs, rt      带符号

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 101010 |
| :----- | ------- | ------- | ------- | ------------ |

功能：if (GPR[rs] < GPR[rt]) GPR[rd] = 1 else (GPR[rd] = 0。

***针对此改变，Control Unit需要在原基础上增加这条指令的控制信号，并且设置一个相应的ALUCtr信号。***

 

跳转指令

（1）jr rs  

| 000000 | rs(5位) | 00000 | 00000 | 00000 | 001000 |
| ------ | ------- | ----- | ----- | ----- | ------ |

功能：PC ← GPR[rs]，跳转。

***针对此改变，Control Unit需要在原基础上增加这条指令的控制信号，但是ALUCtr可以为任意值，因为不需要使用ALU。***

 

调用子程序指令

（2）jal addr  

| 000011 | **addr**[27:2] |
| ------ | -------------- |

功能：调用子程序，PC ← {PC[31:28] , **addr** , 2’b0}；GPR[$31] ← pc+4，返回地址设置；子程序返回，需用指令 `jr $31`。跳转地址的形成同 j addr 指令。

***针对此改变，Control Unit需要在原基础上增加这条指令的控制信号，其中：DBDataSrc=2（从PC处写回寄存器），RegDst=1(写到rd寄存器）；***

***但是ALUCtr可以为任意值，因为不需要使用ALU。***



分支指令

（1）bltz rs, offset （单周期中是：小于等于0分支 blez rs, offset ）

| 000001 | rs(5位) | 00000 | **offset** (16位) |
| ------ | ------- | ----- | ----------------- |

功能：if(GPR[rs] < 0) pc←pc + 4 + sign_extend (**offset**) <<2 

else pc ←pc + 4。

***针对此改变，原来Control Unit中的判断条件要从“小于等于0”变成“小于0”；而ALUCtr不用变，因为ALU仍然是要做减法。***



综上，所有需设计的指令与格式如下：

### 2. 算术运算指令

（1）add rd , rs, rt 

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 100000 |
| ------ | ------- | ------- | ------- | ------------ |

功能：GPR[rd] ← GPR[rs] + GPR[rt]。

  （2）sub rd , rs , rt

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 100010 |
| ------ | ------- | ------- | ------- | ------------ |

功能：GPR[rd] ← GPR[rs] - GPR[rt]。

（3）addiu rt , rs ,**immediate** 

| 001001 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：GPR[rt] ← GPR[rs] + sign_extend(**immediate**)**；** **immediate**做符号扩展再参加“与”运算。

 

### 3. **逻辑运算指令**

（4）andi rt , rs ,**immediate** 

| 001100 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：GPR[rt] ← GPR[rs] and zero_extend(**immediate**)**；immediate**做0扩展再参加“与”运算。

（5）and rd , rs , rt

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 100100 |
| ------ | ------- | ------- | ------- | ------------ |

功能：GPR[rd] ← GPR[rs] and GPR[rt]。

（6）ori rt , rs ,**immediate** 

| 001101 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：GPR[rt] ← GPR[rs] or zero_extend(**immediate**)。

（7）or rd , rs , rt

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 100101 |
| ------ | ------- | ------- | ------- | ------------ |

功能：GPR[rd] ← GPR[rs] or GPR[rt]。

  **(8) xori rt , rs , immediate**  (新增)

| 001110 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：GPR[rt] ← GPR[rs] XOR zero_extend( **immediate**)。

 

### **4. **移位指令

（9）sll rd, rt,sa 

| 000000 | 00000 | rt(5位) | rd(5位) | sa(5位) | 000000 |
| ------ | ----- | ------- | ------- | ------- | ------ |

功能：GPR[rd] ← GPR[rt] << sa。



### 5. 比较指令

（10） slti rt, rs,**immediate**  带符号数

| 001010 | rs(5位) | rt(5位) | **immediate**(16位) |
| ------ | ------- | ------- | ------------------- |

功能：if GPR[rs] < sign_extend(**immediate**) GPR[rt] =1 else GPR[rt] = 0。



**(11) slt rd, rs, rt**      带符号  (新增)

| 000000 | rs(5位) | rt(5位) | rd(5位) | 00000 101010 |
| ------ | ------- | ------- | ------- | ------------ |

功能：if (GPR[rs] < GPR[rt]) GPR[rd] = 1 else (GPR[rd] = 0。



### 6. 存储器读/写指令

（12）sw rt , **offset** (rs) 写存储器

| 101011 | rs(5位) | rt(5位) | **offset**(16位) |
| ------ | ------- | ------- | ---------------- |

功能：memory[GPR[base] + sign_extend(**offset**)] ← GPR[rt]。

（13) lw rt , **offset** (rs) 读存储器

| 100011 | rs(5位) | rt(5位) | **offset** (16位) |
| ------ | ------- | ------- | ----------------- |

功能：GPR[rt] ← memory[GPR[base] + sign_extend(**offset**)]。

 

### 7. **分支指令**

  （14）beq rs,rt, **offset**

| 000100 | rs(5位) | rt(5位) | **offset** (16位) |
| ------ | ------- | ------- | ----------------- |

功能：if(GPR[rs] = GPR[rt]) pc←pc + 4 + sign_extend(**offset**)<<2 

else pc ←pc + 4

特别说明：**offset**是从PC+4地址开始和转移到的指令之间指令条数。**offset**符号扩展之后左移2位再相加。为什么要左移2位？由于跳转到的指令地址肯定是4的倍数（每条指令占4个字节），最低两位是“00”，因此将**offset**放进指令码中的时候，是右移了2位的，也就是以上说的“指令之间指令条数”。

  （15）bne rs,rt, **offset**

| 000101 | rs(5位) | rt(5位) | **offset** (16位) |
| ------ | ------- | ------- | ----------------- |

功能：if(GPR[rs] != GPR[rt]) pc←pc + 4 + sign_extend(**offset**) <<2 

else pc ←pc + 4

  **（16）小于0分支 bltz rs, offset** （单周期中是：小于等于0分支 blez rs, offset ）

| 000001 | rs(5位) | 00000 | **offset** (16位) |
| ------ | ------- | ----- | ----------------- |

功能：if(GPR[rs] **<** 0) pc←pc + 4 + sign_extend (**offset**) <<2 

else pc ←pc + 4。

 

### 8. **跳转指令**

（17）j addr  

| 000010 | **addr**(26位) |
| ------ | -------------- |

功能：PC ← {PC[31:28] , **addr** , 2’b0}，无条件跳转。

说明：由于MIPS32的指令代码长度占4个字节，所以指令地址二进制数最低2位均为0，将指令地址放进指令代码中时，可省掉！这样，除了最高6位操作码外，还有26位可用于存放地址，事实上，可存放28位地址，剩下最高4位由PC+4最高4位拼接上。

 



**（18）jr rs**   (新增)

| 000000 | rs(5位) | 00000 | 00000 | 00000 | 001000 |
| ------ | ------- | ----- | ----- | ----- | ------ |

功能：PC ← GPR[rs]，跳转。

***针对此改变，Control Unit需要在原基础上增加这条指令的控制信号，但是ALUCtr可以为任意值，因为不需要使用ALU。***

 

调用子程序指令

**（19）jal addr**    (新增)

| 000011 | **addr**[27:2] |
| ------ | -------------- |

功能：调用子程序，PC ← {PC[31:28] , **addr** , 2’b0}；**GPR[$31] ← pc+4**，返回地址设置；

**子程序返回，需用指令 jr $31。**

跳转地址的形成同 j addr 指令。

> [!CAUTION]
>
> 该指令要写寄存器！
>
> **GPR[$31] ← pc+4**



### 9. **停机指令**

（20）halt 

| 111111 | 00000000000000000000000000(26位) |
| ------ | -------------------------------- |

功能：停机；不改变PC的值，PC保持不变。



## 三.实验原理

### 1.流水线CPU简介

​       流水线CPU指的是将整个CPU的执行过程分成几个阶段，每个阶段用一个时钟周期来完成，并且多条指令可以并行的CPU。



### 2.流水线CPU处理指令的步骤

​        流水线CPU在处理指令时，一般需要经过以下几个阶段：

​        (1) 取指令(**IF**)：根据程序计数器PC中的指令地址，从存储器中取出一条指令，同时，PC根据指令字长度自动递增产生下一条指令所需要的指令地址，但遇到“地址转移”指令时，则控制器把“转移地址”送入PC，当然得到的“地址”需要做些变换才送入PC。

​        (2) 指令译码(**ID**)：对取指令操作中得到的指令进行分析并译码，确定这条指令需要完成的操作，从而产生相应的操作控制信号，用于驱动执行状态中的各种操作。

​	(3) 指令执行(**EXE**)：根据指令译码得到的操作控制信号，具体地执行指令动作，然后转移到结果写回状态。

​	(4) 存储器访问(**MEM**)：所有需要访问存储器的操作都将在这个步骤中执行，该步骤给出存储器的数据地址，把数据写入到存储器中数据地址所指定的存储单元或者从存储器中得到数据地址单元中的数据。

​	(5) 结果写回(**WB**)：指令执行的结果或者访问存储器中得到的数据写回相应的目的寄存器中。

​	流水线CPU，在一个时钟周期内完成一个阶段的处理。当前一条指令完成一个阶段处理进入下一个阶段时，后一条指令便可开始执行这个阶段的处理，从而实现流水线处理指令。



### 3.**MIPS指令**的三种格式

**MIPS指令**的三种格式：

![MIPS指令的3种格式](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/MIPS%E6%8C%87%E4%BB%A4%E7%9A%843%E7%A7%8D%E6%A0%BC%E5%BC%8F.png)

其中，

​	**op**：为操作码；

​	**rs**：只读。为第1个源操作数寄存器，寄存器地址（编号）是00000~11111，00~1F；

​	**rt**：可读可写。为第2个源操作数寄存器，或目的操作数寄存器，寄存器地址（同上）；

​	**rd**：只写。为目的操作数寄存器，寄存器地址（同上）；

​	**sa**：为位移量（shift amt），移位指令用于指定移多少位；

​	**funct**：为功能码，在寄存器类型指令中（R类型）用来指定指令的功能与操作码配合使用；

​	**immediate**：为16位立即数，用作无符号的逻辑操作数、有符号的算术操作数、数据加载（Laod）/数据保存（Store）指令的数据地址字节偏移量和分支指令中相对程序计数器（PC）的有符号偏移量；**address**：为地址。



### 4.流水线冒险的处理

​        流水线CPU会出现一种情况，再下一个时钟周期中，下一条指令不能执行。这种情况称为冒险(hazard)，有三种类型的流水线冒险，分别是：结构冒险、数据冒险、控制冒险。

​	下面详细介绍该流水线CPU处理这三种类型冒险的具体方式。



#### 4.1 结构冒险的处理方式

- 把指令存储器和数据存储器分开。避免同一个周期内取指令和取数据同时访问同一个存储器。
- 每条指令统一都需要5个时钟周期完成。避免不同指令同时使用同一个硬件的情况



#### 4.2 数据冒险的处理方式

##### 4.2.1普通的数据冒险

使用**旁路**

- 新增1个硬件Forwarding Unit
- 新增2个控制信号`ForwardA`，`ForwardB`，由Forwarding Unit 产生

这两个控制信号的作用如下:

| 信号取值 | ForwardA                         | ForwardB                         |
| -------- | -------------------------------- | -------------------------------- |
| 00       | 寄存器堆的Read Data1，即rs的数据 | 寄存器堆的Read Data2，即rt的数据 |
| 01       | 从WB阶段转发回来的数据           | 从WB阶段转发回来的数据           |
| 10       | 从MEM阶段转发回来的数据          | 从MEM阶段转发回来的数据          |



##### 4.2.2取数-使用型数据冒险的处理

对于取数-使用型数据冒险，在使用旁路的情况下，还必须要阻塞一个时钟周期。

为此，需要在数据通路中新增一个硬件Load-use detection unit



#### 4.3 控制冒险的处理

在第四阶段(**MEM**) 增加一个硬件Branch Detection Unit，用于检测是否需要进行分支。

新增1个控制信号`BranchType`来表示分支类型

| 信号取值 | BranchType          |
| -------- | ------------------- |
| 0        | 不分支              |
| 1        | beq（相等则分支）   |
| 2        | bne（不相等则分支） |
| 3        | bltz（小于0则分支） |

如果需要分支，则把**IF/ID,ID/EX,EX/MEM**这三个流水线寄存器的控制信号清零，并且把分支地址传给PC。然后继续按照新的PC继续顺序执行。

如果不需要分支，则继续执行。

新增3个控制信号`IF/ID.Flush` `ID/EX.Flush` `EX/MEM.Flush`来实现以上功能。

| 信号取值 | IF/ID.Flush | ID/EX.Flush | EX/MEM.Flush |
| -------- | ----------- | ----------- | ------------ |
| 0        | 不清零      | 不清零      | 不清零       |
| 1        | 清零        | 清零        | 清零         |

当需要分支时，把上述3个控制信号置为1

不需要分支时，则把上述3个控制信号置为0



#### 4.4 跳转指令的处理

在第二阶段(**ID**)，控制器在译码时，如果发现是跳转指令(比如：`j`,`jal`,`jr`)，则会把IF/ID这个流水线寄存器的控制信号清零，并且把跳转地址传给PC。然后继续按照新的PC继续执行。

当是跳转指令时，则把`IF/ID.Flush` 置为1；

不是跳转指令时，则把`IF/ID.Flush` 置为0。

| 信号取值 | IF/ID.Flush                      |
| -------- | -------------------------------- |
| 0        | 不是跳转指令                     |
| 1        | 是跳转指令(比如：`j`,`jal`,`jr`) |



### 5.流水线CPU的数据通路和控制线路

下图是我***自行绘制***的**流水线CPU的数据通路和控制线路图**。

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E6%B5%81%E6%B0%B4%E7%BA%BFCPU%E6%95%B0%E6%8D%AE%E9%80%9A%E8%B7%AF%E4%B8%8E%E6%8E%A7%E5%88%B6%E4%BF%A1%E5%8F%B7%E5%9B%BE.png" alt="流水线CPU数据通路与控制信号图" style="zoom:150%;" />



​        其中指令和数据各存储在不同存储器中，即既有指令存储器，又有数据存储器。

​	指令执行的结果总是在**时钟下降**沿保存到**寄存器堆和存储器**中， **PC** 的改变是在**时钟上升沿**进行的，这样稳定性较好。 

​	每个阶段的执行结果在**时钟下降**沿保存到**流水线寄存器**中，**IF/ID,ID/EX,EX/MEM**这三个流水线寄存器是否需要清零，则在**时钟上升沿**进行

​	访问存储器时，先给出内存地址，然后由读或写信号控制操作。对于寄存器组，先给出寄存器地址，读操作时不需要时钟信号，输出端就直接输出相应数据；而在写操作时，在 WE使能信号为1时，在时钟边沿触发将数据写入寄存器。

​	

### 6.控制信号介绍及其真值表

​	图中**控制信号**作用如下列各表所示：

#### 6.1 与PC相关的控制信号

| 控制信号名      | 状态“0”                                                      | 状态“1”                                                      |
| --------------- | ------------------------------------------------------------ | :----------------------------------------------------------- |
| **Reset**       | 初始化PC为0                                                  | PC接收新地址                                                 |
| **PCWre**       | PC不更改，相关指令：halt                                     | PC更改，相关指令：除指令halt外                               |
| **PCSrc[1..0]** | 00：pc<－pc+4，相关指令：add、addiu、sub、or、ori、and、andi、slti、sll、sw、lw、beq(zero=0)、bne(zero=1)、blez(sign=0&&zero=0)；  01：pc<－pc+4+(sign-extend)**immediate**，相关指令：beq(zero=1)、  bne(zero=0)、blez(sign=1\|\|zero=1)；  10：pc<－{(pc+4)[31:28],addr[25:0],2'b00}，相关指令：j，jal, jr；     11：未用 |                                                              |
| **JumpPCSrc**   | 跳转指令的地址来自**寄存器**。相关指令：jr                   | 跳转指令的地址为{PC[31:28] , instruction[25:0] , 2’b0}。相关指令：j、jal。默认情况下：取值为1 |



#### 6.2 与寄存器堆相关的控制信号

| 控制信号名 | 状态“0”                                                      | 状态“1”                                                      |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **RegWre** | 无写寄存器组寄存器，相关指令：  beq、bne、blez、sw、halt     | 寄存器组写使能，相关指令：add、addiu、sub、ori、or、and、andi、slti、sll、lw |
| **RegDst** | 写寄存器组寄存器的地址，来自rt字段，相关指令：addiu、andi、ori、slti、lw | 写寄存器组寄存器的地址，来自rd字段，相关指令：add、sub、and、or、sll |



#### 6.3 符号扩展或零扩展单元的控制信号

| 控制信号名 | 状态“0”                                                      | 状态“1”                                                      |
| ---------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **ExtSel** | (zero-extend)**immediate****（**0扩展**），**相关指令：addiu、andi、ori | (sign-extend)**immediate****（**符号扩展**）**  ，相关指令：slti、sw、lw、beq、bne、blez |



#### 6.4 与ALU相关的控制信号

| 控制信号名       | 状态“0”                                                      | 状态“1”                                                      |
| ---------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| **ALUSrcA**      | 来自寄存器堆data1输出，相关指令：add、sub、addiu、or、and、andi、ori、slti、beq、bne、blez、sw、lw | 来自移位数sa，同时，进行(zero-extend)sa，即 {{27{1'b0}},sa}，相关指令：sll |
| **ALUSrcB**      | 来自寄存器堆data2输出，相关指令：add、sub、or、and、beq、bne、blez | 来自sign或zero扩展的立即数，相关指令：addi、andi、ori、slti、sw、lw |
| **ALUOp[2..0]**  | ALUOp码(000-111)，看功能表                                   |                                                              |
| **ALUCtr[2..0]** | ALU的8种运算功能选择(000-111)，看功能表                      |                                                              |



#### 6.5 与数据存储器相关的控制信号

| 控制信号名  | 状态“0”    | 状态“1”                        |
| ----------- | ---------- | ------------------------------ |
| **MemRead** | 输出高阻态 | **读数据存储器，相关指令：lw** |
| **MemWre**  | 无操作     | **写数据存储器，相关指令：sw** |



#### 6.6 选择写回数据的控制信号

| 控制信号名    | 状态“0”                                                      | 状态“1”                                        |
| ------------- | ------------------------------------------------------------ | ---------------------------------------------- |
| **DBDataSrc** | 来自ALU运算结果的输出，相关指令：add、addiu、sub、ori、or、and、andi、slti、sll | 来自数据存储器（Data MEM）的输出，相关指令：lw |



#### 6.7 用于流水线寄存器清零的控制信号

| 控制信号名   | 状态“0” | 状态“1” |
| ------------ | ------- | ------- |
| IF/ID.Flush  | 不清零  | 清零    |
| ID/EX.Flush  | 不清零  | 清零    |
| EX/MEM.Flush | 不清零  | 清零    |



#### 6.8 主控制单元产生的控制信号

![主控产生的控制信号](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E4%B8%BB%E6%8E%A7%E4%BA%A7%E7%94%9F%E7%9A%84%E6%8E%A7%E5%88%B6%E4%BF%A1%E5%8F%B7.png)



#### 6.9 指令与ALUOp的对应关系

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E6%8C%87%E4%BB%A4%E4%BA%8EALUop%E5%85%B3%E7%B3%BB.png" alt="指令于ALUop关系" style="zoom:80%;" />



#### 6.10 ALU动作与ALUCtr的对应关系

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ALU%E5%8A%A8%E4%BD%9C%E4%BA%8EALUCtr%E7%9A%84%E5%85%B3%E7%B3%BB.png" alt="ALU动作于ALUCtr的关系" style="zoom: 80%;" />



#### 6.11 指令与ALUCtr的对应关系

![ALUCtr真值表](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ALUCtr%E7%9C%9F%E5%80%BC%E8%A1%A8.png)



### 7.设计特色

​	这个流水线CPU的设计与其他流水线CPU相比，主要有以下几个特点：

- 有**ALU控制单元**

- 所有流水线冲突都采用**硬件**处理，没有采用软件处理。即：所有流水线冲突都是通过**流水线CPU本身**的硬件设计来实现，而没有利用编译器来实现

- 分支是在**MEM阶段**检测出来。

- 跳转指令是在**ID阶段**检测出来。

- 含有2个旁路，分别是从MEM阶段到EX阶段的旁路、以及从WB阶段到EX阶段的旁路。

- 所有流水线寄存器都是在时钟下降沿写入，在时钟上升沿检查是否需要清零。

- PC是在时钟上升沿更新。

- 在规定了所有流水线寄存器都是在时钟下降沿写入，而且PC是在时钟上升沿更新之后，为了实现寄存器堆的“先写后读”，寄存器堆只能在时钟上升沿写入，而读取则是组合逻辑电路。

  > [!CAUTION]
  >
  > 由于各个硬件的时钟周期是这样设计的，因此，各个部件间的时钟周期并不是同步的。
  >
  > 具体而言：
  >
  > - PC的时钟周期是在2个上升沿之间
  > - 所有流水线寄存器写入的时钟周期是在2个下降沿之间。又由于流水线寄存器分隔了两个流水线阶段，所以每个流水线阶段的时钟周期也是在2个下降沿之间。
  > - 所有流水线寄存器检查是否需要清零的时钟周期是在2个上升沿之间
  > - 寄存器堆写入的时钟周期是在2个上升沿之间

  

## 四.实验器材

- 电脑                          一台

- Xilinx Vivado 软件  一套

- Basys3板                 一块





## 五.实验过程与结果

​	我首先利用Python编写了编译器的代码，并且成功将测试所用的汇编程序汇编成相应的二进制代码。

​	然后利用Verilog逐个模块进行设计，最后利用顶层模块把所用模块的接口连接起来，实现整个CPU的功能。对于每个模块的设计，我都会编写一个仿真代码进行验证，保证每个模块代码的正确性，稳扎稳打，步步为营。

​	下面是我设计流水线CPU的详细过程。



### 编译器

```python
import pandas as pd

data=pd.read_excel("C:/Users/23999.YHW/Desktop/大二/学习/计算机组成原理/流水线CPU/流水线CPU测试指令.xlsx")

print(data)

def int_to_binN(int_str, bits):
    """
    用于把任意位数的10进制数字转换成N位的二进制
    在编译器中，
        寄存器编号->对应的二进制（5位）
        立即数->对应的二进制（16位）
    :param int_str: 10进制字符串
            type:str
           N:转换成的二进制字符串的位数
    :return: binN:2进制（N位）
            type:str
    """
    int_num=int(int_str)
    if int_num >= 0:
        # 对于正数，直接转换为二进制
        binN = format(int_num, 'b').zfill(bits)  # 缺少部分用0填充

    else:
        # 对于负数，先求补码再转换为二进制
        binN = format((1 << bits) + int_num, 'b')
    return binN

def bin32_to_hex8(bin32):
    '''
    用于把32位的二进制转换为8位的16进制
    :param bin32: 32位的2进制
            type:str
    :return: hex8:8位的16进制
            type:str
    '''
    hex_origin=hex(int(bin32,2))[2:]  # 2进制转16进制，然后删去前面的0x
    zero_num=8-len(hex_origin)
    hex8="0"*zero_num+hex_origin
    return hex8

rows=data.shape[0]  # 获取指令行数
df_complete=pd.DataFrame(index=list(range(0,rows)),
                         columns=['地址','汇编程序','op','rs','rt','rd/immediate','16进制数代码','2进制数代码'])

def Rtype(IS_assembly,func_bin):
    # 除了sll之外的R型指令
    [rd, rs, rt] = IS_assembly[1].split(',')
    op_bin = "000000"
    rs_bin = int_to_binN(rs[1:],5)
    rt_bin = int_to_binN(rt[1:],5)
    rd_bin = int_to_binN(rd[1:],5)

    sa_bin="00000"
    IS_rear_16bit = rd_bin + sa_bin + func_bin
    IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
    IS_hex = bin32_to_hex8(IS_bin_32bit)
    print("op:{0}\nrs:{1}\nrt:{2}\nrd:{3}\nsa:{4}\nfunc:{5}\nhex:{6}\nbin:{7}\n"
          .format(op_bin, rs_bin, rt_bin, rd_bin, sa_bin, func_bin, IS_hex, IS_bin_32bit))
    return [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]

def Itype(IS_assembly,op_bin):
    # 除了分支指令(beq,bne,bltz)和lw,sw之外 的I型指令
    [rt, rs, immediate] = IS_assembly[1].split(',')

    rs_bin = int_to_binN(rs[1:], 5)
    rt_bin = int_to_binN(rt[1:], 5)
    immediate_bin = int_to_binN(immediate, 16)  # 转换为二进制

    IS_rear_16bit = immediate_bin
    IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
    IS_hex = bin32_to_hex8(IS_bin_32bit)
    print("op:{0}\nrs:{1}\nrt:{2}\nimmediate:{3}\nhex:{4}\nbin:{5}\n"
          .format(op_bin, rs_bin, rt_bin, immediate_bin, IS_hex, IS_bin_32bit))
    return [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]

def Branch(IS_assembly,op_bin):
    # beq,bne,bltz
    rs_rt_offset = IS_assembly[1].split(',')

    if(len(rs_rt_offset)==3):  # beq,bne
        [rs,rt,offset]=rs_rt_offset
    else:  # bltz
        [rs,offset] = rs_rt_offset
        rt="$0"

    rs_bin = int_to_binN(rs[1:], 5)
    rt_bin = int_to_binN(rt[1:], 5)
    offset_bin = int_to_binN(offset, 16)  # 转换为二进制

    IS_rear_16bit = offset_bin
    IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
    IS_hex = bin32_to_hex8(IS_bin_32bit)
    print("op:{0}\nrs:{1}\nrt:{2}\noffset:{3}\nhex:{4}\nbin:{5}\n"
          .format(op_bin, rs_bin, rt_bin, offset_bin, IS_hex, IS_bin_32bit))
    return [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]

def Jtype(IS_assembly,op_bin):
    target_address = IS_assembly[1][2:]  # 16进制的跳转地址
    IS_rear_26bit = int_to_binN((int(target_address, 16) >> 2), 26)

    IS_bin_32bit = op_bin + IS_rear_26bit
    IS_hex = bin32_to_hex8(IS_bin_32bit)
    print("op:{0}\ntarget address:{1}\nhex:{2}\nbin:{3}\n"
          .format(op_bin, IS_rear_26bit, IS_hex, IS_bin_32bit))
    return [IS_rear_26bit, IS_bin_32bit,IS_hex]

def IS_assembly_to_IS_bin(IS_assembly):
    if (IS_assembly[0] == "add"):
        func_bin = "100000"
        [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Rtype(IS_assembly, func_bin)
    elif (IS_assembly[0] == "sub"):
        func_bin = "100010"
        [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]=Rtype(IS_assembly,func_bin)
    elif (IS_assembly[0] == "and"):
        func_bin="100100"
        [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Rtype(IS_assembly, func_bin)
    elif (IS_assembly[0] == "or"):
        func_bin = "100101"
        [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Rtype(IS_assembly, func_bin)
    elif(IS_assembly[0] == "slt"):
        func_bin = "101010"
        [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Rtype(IS_assembly, func_bin)
    elif(IS_assembly[0] == "sll"):
        [rd,rt,sa]=IS_assembly[1].split(',')
        op_bin = "000000"
        rs_bin = "0" * 5
        rt_bin = int_to_binN(rt[1:], 5)
        rd_bin = int_to_binN(rd[1:], 5)
        func_bin ="000000"
        sa_bin = int_to_binN(sa,5)

        IS_rear_16bit = rd_bin + sa_bin + func_bin
        IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
        IS_hex = bin32_to_hex8(IS_bin_32bit)
        print("op:{0}\nrs:{1}\nrt:{2}\nrd:{3}\nsa:{4}\nfunc:{5}\nhex:{6}\nbin:{7}\n"
              .format(op_bin, rs_bin, rt_bin, rd_bin, sa_bin, func_bin, IS_hex, IS_bin_32bit))

    # Itype
    elif(IS_assembly[0] == "addiu"):
        op_bin = "001001"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]=Itype(IS_assembly,op_bin)
    elif(IS_assembly[0] == "andi"):
        op_bin = "001100"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Itype(IS_assembly, op_bin)
    elif(IS_assembly[0] == "ori"):
        op_bin = "001101"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Itype(IS_assembly, op_bin)
    elif (IS_assembly[0] == "xori"):
        op_bin = "001110"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Itype(IS_assembly, op_bin)
    elif (IS_assembly[0] == "slti"):
        op_bin = "001010"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Itype(IS_assembly, op_bin)

    # Branch 分支指令
    elif (IS_assembly[0] == "beq"):
        op_bin = "000100"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Branch(IS_assembly, op_bin)
    elif (IS_assembly[0] == "bne"):
        op_bin = "000101"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Branch(IS_assembly, op_bin)
    elif (IS_assembly[0] == "bltz"):
        op_bin = "000001"
        [rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex] = Branch(IS_assembly, op_bin)

    # lw,sw
    elif (IS_assembly[0] == "lw"):
        op_bin="100011"
        [rt,offset_rs]=IS_assembly[1].split(',')
        [offset,rs]=offset_rs.split('(')
        rs=rs[:2]
        rs_bin = int_to_binN(rs[1:], 5)
        rt_bin = int_to_binN(rt[1:], 5)
        offset_bin = int_to_binN(offset, 16)  # 转换为二进制

        IS_rear_16bit = offset_bin
        IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
        IS_hex = bin32_to_hex8(IS_bin_32bit)
        print("op:{0}\nrs:{1}\nrt:{2}\noffset:{3}\nhex:{4}\nbin:{5}\n"
              .format(op_bin, rs_bin, rt_bin, offset_bin, IS_hex, IS_bin_32bit))
    elif (IS_assembly[0] == "sw"):
        op_bin="101011"
        [rt,offset_rs]=IS_assembly[1].split(',')
        [offset,rs]=offset_rs.split('(')
        rs=rs[:2]
        rs_bin = int_to_binN(rs[1:], 5)
        rt_bin = int_to_binN(rt[1:], 5)
        offset_bin = int_to_binN(offset, 16)  # 转换为二进制

        IS_rear_16bit = offset_bin
        IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
        IS_hex = bin32_to_hex8(IS_bin_32bit)
        print("op:{0}\nrs:{1}\nrt:{2}\noffset:{3}\nhex:{4}\nbin:{5}\n"
              .format(op_bin, rs_bin, rt_bin, offset_bin, IS_hex, IS_bin_32bit))

    # Jtype
    elif (IS_assembly[0] == "j"):
        op_bin = "000010"
        [IS_rear_26bit, IS_bin_32bit, IS_hex]=Jtype(IS_assembly,op_bin)
        rs_bin = IS_rear_26bit[0:5]
        rt_bin = IS_rear_26bit[5:10]
        IS_rear_16bit = IS_rear_26bit[10:]
    elif (IS_assembly[0] == "jal"):
        op_bin = "000011"
        [IS_rear_26bit, IS_bin_32bit, IS_hex]=Jtype(IS_assembly,op_bin)
        rs_bin = IS_rear_26bit[0:5]
        rt_bin = IS_rear_26bit[5:10]
        IS_rear_16bit = IS_rear_26bit[10:]
    elif (IS_assembly[0] == "jr"):
        op_bin = "000000"
        rs_bin=int_to_binN(IS_assembly[1][1:],5)
        rt_bin="0"*5
        IS_rear_16bit="0"*10+"001000"
        IS_bin_32bit=op_bin+rs_bin+rt_bin+IS_rear_16bit
        IS_hex=bin32_to_hex8(IS_bin_32bit)

    elif (IS_assembly[0] == "halt"):
        op_bin="1"*6
        rs_bin="0"*5
        rt_bin="0"*5
        IS_rear_16bit="0"*16
        IS_bin_32bit = op_bin + rs_bin + rt_bin + IS_rear_16bit
        IS_hex = bin32_to_hex8(IS_bin_32bit)

    else:  # 异常！
        op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex=0,0,0,0,0,0
    return [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]


for i in range(0,rows):
    IS_assembly=data.iloc[i,1].split()  # 取出汇编指令

    # 指令转换为二进制
    [op_bin, rs_bin, rt_bin, IS_rear_16bit, IS_bin_32bit, IS_hex]=IS_assembly_to_IS_bin(IS_assembly)

    # 写入表格
    df_complete.loc[i,'地址']=data.iloc[i,0]
    df_complete.loc[i,'汇编程序']=data.iloc[i,1]
    df_complete.loc[i,'op']=op_bin
    df_complete.loc[i,'rs']=rs_bin
    df_complete.loc[i, 'rt'] = rt_bin
    df_complete.loc[i, 'rd/immediate'] =IS_rear_16bit
    df_complete.loc[i,'16进制数代码']=IS_hex
    df_complete.loc[i,'2进制数代码']=IS_bin_32bit

print(df_complete)

# 写入excel
df_complete.to_excel("流水线测试指令.xlsx")

# 写入txt
f_Instructions=open('Pipeline_CPU_Instructions.txt','w')
for i in range(0,rows):
    # 注意要换行
    f_Instructions.write(df_complete.loc[i, '2进制数代码'][0:8]+"\n")
    f_Instructions.write(df_complete.loc[i, '2进制数代码'][8:16]+"\n")
    f_Instructions.write(df_complete.loc[i, '2进制数代码'][16:24]+"\n")
    f_Instructions.write(df_complete.loc[i, '2进制数代码'][24:]+"\n")
f_Instructions.close()
```



### 测试程序段

​	利用我自己编写的编译器得到的**测试程序段的指令及其相应代码**如下表所示：

![测试代码](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E6%B5%8B%E8%AF%95%E4%BB%A3%E7%A0%81.png)



### 1. 程序计数器Program Counter

```verilog
module Program_Counter(
    //控制信号
    input wire Clk,
    input wire Reset,//置零信号，1:置零;0:不置零
    
    input wire PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit,
    input wire[1:0] PCSrc,
    
    input wire JumpPCSrc,
    
    //数据通路
    input wire [25:0] ID_targetAddress,//跳转指令的低26位
    input wire [31:0] ID_PCadd4,
    input wire [31:0] ID_ReadData1,//从rs读出的数据
    
    input wire [31:0] MEM_BranchPC,//从MEM级传来的分支地址
    
    output wire [31:0] IF_PCadd4,
    output reg [31:0] currAddress,
    output wire [31:0] nextPCAddress
    );
    
    // PC+4
    assign IF_PCadd4=currAddress+4;
    
    //选择JumpPC的来源
    //对于j,jal指令JumpPCSrc==1; 对于jr指令,JumpPCSrc==0
    wire [31:0] JumpPC;
    assign JumpPC=(JumpPCSrc==1)? {ID_PCadd4[31:28],ID_targetAddress,2'b00}:ID_ReadData1;
    
    assign nextPCAddress=(PCSrc==2'b10)? JumpPC://跳转指令
                         (PCSrc==2'b01)? MEM_BranchPC://分支指令的跳转
                         IF_PCadd4;//顺序执行下一条指令
    
    
    //Clk的上升沿到来时写入新的PC
    always @(posedge Clk or posedge Reset) begin
        if(Reset==1) currAddress<=0;//置零
        
        else if(PCWre_from_Control_Unit==1 && PCWre_from_Load_use_Detection_Unit==1) begin //写PC
            if(PCSrc==0)//顺序执行下一条指令
                currAddress<=IF_PCadd4;
            else if(PCSrc==2'b01)//分支指令的跳转
                currAddress<=MEM_BranchPC;
            else if(PCSrc==2'b10)//跳转指令
               currAddress<=JumpPC;
        end    
        //其余情况下：
        //PCWre_from_Control_Unit==1 或者 PCWre_from_Load_use_Detection_Unit==1
        //currAddress都保持不变
    end
endmodule
```



仿真代码如下：

```verilog
module Program_Counter_tb( );

    //inputs
    //控制信号
    reg Clk;
    reg PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit;
    reg Reset;
    reg[1:0] PCSrc;
    reg JumpPCSrc;
    
    //数据通路
    reg [31:0] ID_PCadd4;
    reg [25:0] ID_targetAddress;
    reg [31:0] ID_ReadData1;
    reg [31:0] MEM_BranchPC;


    //outputs
    wire [31:0] currAddress;
    wire [31:0] nextPCAddress;
    wire [31:0] IF_PCadd4;
    
    //例化
    Program_Counter pc(
    .Clk(Clk),
    .PCWre_from_Control_Unit(PCWre_from_Control_Unit),
    .PCWre_from_Load_use_Detection_Unit(PCWre_from_Load_use_Detection_Unit),
    .Reset(Reset),
    .PCSrc(PCSrc),
    .JumpPCSrc(JumpPCSrc),
    .currAddress(currAddress),
    .nextPCAddress(nextPCAddress),
    .ID_targetAddress(ID_targetAddress),
    .MEM_BranchPC(MEM_BranchPC),
    .ID_PCadd4(ID_PCadd4),
    .IF_PCadd4(IF_PCadd4),
    .ID_ReadData1(ID_ReadData1)
    );
    
    // 时钟信号生成
    always begin
        #5 Clk = ~Clk;
    end
    
    initial begin
        //初始化
        Clk = 0;
        PCWre_from_Control_Unit = 1;
        PCWre_from_Load_use_Detection_Unit=1;

        PCSrc = 0;//顺序执行
        ID_PCadd4=32'd4;
        ID_targetAddress=26'b10;
        MEM_BranchPC=32'd100;
        ID_ReadData1=32'h20;
        
        JumpPCSrc=1;
        
        Reset = 1;//置零
        #10;
        
        //Test1：顺序执行下一条指令
        Reset = 0;//不置零
        PCSrc = 0;//顺序执行
        #10;
        
        //Test2：分支指令的跳转
        PCSrc = 1;//分支指令的跳转
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        //Test3：跳转指令j,jal
        PCSrc = 2;//跳转指令
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        //Test4：跳转指令jr
        PCSrc = 2;//跳转指令
        JumpPCSrc=0;
        #10;
        
        PCSrc = 0;//顺序执行
        #10;
        
        PCSrc = 0;//顺序执行
        #10;

        //有Load_use冒险
        PCWre_from_Control_Unit=1;
        PCWre_from_Load_use_Detection_Unit=0;
        #10;

        //halt
        PCWre_from_Control_Unit=0;
        PCWre_from_Load_use_Detection_Unit=1;
        #10;
        $stop;
    end
endmodule
```



仿真波形图如下：
![PC仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/PC%E4%BB%BF%E7%9C%9F.png)



### 2. 指令存储器 Instruction Memory

```verilog
module InstructionMemory(
    input wire[31:0] InstructionAddress,
    
    //取出的32位的指令
    output reg [31:0] Instruction
    );
    //指令存储器，8位为1个字节，共128字节
    reg [7:0] Memory[127:0];

    initial begin
//    //测试硬件中的nop指令（addi $0,$0,0)
//    //001001 00000 00000 0000 0000 0000 0000
//        Memory[0]=8'b00100100;
//        Memory[1]=8'b00000000;
//        Memory[2]=8'b00000000;
//        Memory[3]=8'b00000000;
    //方法1：从文件中导入指令
        //$readmemb("Pipeline_CPU_Instructions.txt", Memory);//导入
    //方法2：自己人工输入，这样就能够烧入板中
        Memory[0]=8'b00100100;
        Memory[1]=8'b00000001;
        Memory[2]=8'b00000000;
        Memory[3]=8'b00001000;
        Memory[4]=8'b00110100;
        Memory[5]=8'b00000010;
        Memory[6]=8'b00000000;
        Memory[7]=8'b00000010;
        Memory[8]=8'b00111000;
        Memory[9]=8'b01000011;
        Memory[10]=8'b00000000;
        Memory[11]=8'b00001000;
        Memory[12]=8'b00000000;
        Memory[13]=8'b01100001;
        Memory[14]=8'b00100000;
        Memory[15]=8'b00100010;
        Memory[16]=8'b00000000;
        Memory[17]=8'b10000010;
        Memory[18]=8'b00101000;
        Memory[19]=8'b00100100;
        Memory[20]=8'b00000000;
        Memory[21]=8'b00000101;
        Memory[22]=8'b00101000;
        Memory[23]=8'b10000000;
        Memory[24]=8'b00010000;
        Memory[25]=8'b10100001;
        Memory[26]=8'b11111111;
        Memory[27]=8'b11111110;
        Memory[28]=8'b00001100;
        Memory[29]=8'b00000000;
        Memory[30]=8'b00000000;
        Memory[31]=8'b00010100;
        Memory[32]=8'b00000001;
        Memory[33]=8'b10100001;
        Memory[34]=8'b01000000;
        Memory[35]=8'b00101010;
        Memory[36]=8'b00100100;
        Memory[37]=8'b00001110;
        Memory[38]=8'b11111111;
        Memory[39]=8'b11111110;
        Memory[40]=8'b00000001;
        Memory[41]=8'b00001110;
        Memory[42]=8'b01001000;
        Memory[43]=8'b00101010;
        Memory[44]=8'b00101001;
        Memory[45]=8'b00101010;
        Memory[46]=8'b00000000;
        Memory[47]=8'b00000010;
        Memory[48]=8'b00101001;
        Memory[49]=8'b01001011;
        Memory[50]=8'b00000000;
        Memory[51]=8'b00000000;
        Memory[52]=8'b00000001;
        Memory[53]=8'b01101010;
        Memory[54]=8'b01011000;
        Memory[55]=8'b00100000;
        Memory[56]=8'b00010101;
        Memory[57]=8'b01100010;
        Memory[58]=8'b11111111;
        Memory[59]=8'b11111110;
        Memory[60]=8'b00100100;
        Memory[61]=8'b00001100;
        Memory[62]=8'b11111111;
        Memory[63]=8'b11111110;
        Memory[64]=8'b00100101;
        Memory[65]=8'b10001100;
        Memory[66]=8'b00000000;
        Memory[67]=8'b00000001;
        Memory[68]=8'b00000101;
        Memory[69]=8'b10000000;
        Memory[70]=8'b11111111;
        Memory[71]=8'b11111110;
        Memory[72]=8'b00110000;
        Memory[73]=8'b01001100;
        Memory[74]=8'b00000000;
        Memory[75]=8'b00000010;
        Memory[76]=8'b00001000;
        Memory[77]=8'b00000000;
        Memory[78]=8'b00000000;
        Memory[79]=8'b00010111;
        Memory[80]=8'b10101100;
        Memory[81]=8'b00100010;
        Memory[82]=8'b00000000;
        Memory[83]=8'b00000100;
        Memory[84]=8'b10001100;
        Memory[85]=8'b00101101;
        Memory[86]=8'b00000000;
        Memory[87]=8'b00000100;
        Memory[88]=8'b00000011;
        Memory[89]=8'b11100000;
        Memory[90]=8'b00000000;
        Memory[91]=8'b00001000;
        Memory[92]=8'b11111100;
        Memory[93]=8'b00000000;
        Memory[94]=8'b00000000;
        Memory[95]=8'b00000000;

        Instruction<= 0;//指令初始化
    end
    
    //取指令
    always@ (InstructionAddress) begin
        Instruction[31:24]<=Memory[InstructionAddress];
        Instruction[23:16]<=Memory[InstructionAddress+1];
        Instruction[15: 8]<=Memory[InstructionAddress+2];
        Instruction[ 7: 0]<=Memory[InstructionAddress+3];
    end

endmodule
```

由于该模块与单周期相比只是修改了存储器中的指令，所以没有进行仿真。



### 3. IF/ID流水线寄存器

```verilog
`timescale 1ns / 1ps

module IF_ID_Register(
    //控制信号
    input wire IF_ID_Flush,IF_ID_Wre,
    input wire Branch,//新增Branch
    input wire Clk,
    
    //数据通路
    input wire [31:0] IF_Instruction,
    input wire [31:0] IF_PCadd4,
    
    output reg [31:0] ID_Instruction,//取出的32位的指令
    output reg[5:0] Opcode,
    output reg[4:0] rs,rt,rd,sa,
    output reg[5:0] func,
    output reg[15:0] Immediate,
    output reg[25:0] targetAddress,
    
    output reg [31:0] ID_PCadd4 //取出的PC+4
    );
    
    //初始化
    initial begin
        ID_Instruction=0;
        Opcode=0;
        rs=0;rt=0;rd=0;sa=0;
        func=0;
        Immediate=0;
        targetAddress=0;
        
        ID_PCadd4=0;
    end
    

 //reg类型的输出,Clk的下降沿写入，上升沿检查IF_ID_Flush==1
    always @(negedge Clk or posedge Clk) begin 
        if(Clk==0) begin
            if(IF_ID_Wre==1&& IF_ID_Flush==0) begin  //不能删去: && IF_ID_Flush==0
                ID_Instruction<=IF_Instruction;
                Opcode<=IF_Instruction[31:26];
                rs<=IF_Instruction[25:21];
                rt<=IF_Instruction[20:16];
                rd<=IF_Instruction[15:11];
                sa<=IF_Instruction[10:6];
                func<=IF_Instruction[5:0];
                Immediate<=IF_Instruction[15:0];
                targetAddress<=IF_Instruction[25:0];
                
                ID_PCadd4<=IF_PCadd4;
            end
        end
        
        else//Clk==1
        begin
        
             //对于分支指令
            if( IF_ID_Flush==1) 
            begin 
               if(Branch==1) begin
                    ID_Instruction<=0;
                    Opcode<=0;//清除旧Opcode,否则上一条指令的PCWre会在下一个周期起作用
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//保持不变
                    
                    ID_PCadd4<=IF_PCadd4;
                end
            
            
                //对于跳转指令
                else 
                begin
                    ID_Instruction<=0;
                    Opcode<=IF_Instruction[31:26];//保留旧Opcode,否则控制信号会被刷新
                    rs<=0;
                    rt<=0;
                    rd<=0;
                    sa<=0;
                    func<=0;
                    Immediate<=0;
                    targetAddress<=IF_Instruction[25:0];//保持不变
                    
                    ID_PCadd4<=IF_PCadd4;//保持不变
                end
                
            end
        end
    end                                                                                                     
endmodule

```

仿真代码如下：

```verilog
module IF_ID_Register_tb( );

    //input 
    reg IF_ID_Flush,IF_ID_Wre;
    reg Clk;
    
    //output
    reg [31:0] IF_Instruction;
    reg [31:0] IF_PCadd4;
    
    wire [31:0] ID_Instruction;
    wire [31:0] ID_PCadd4;
    wire[5:0] Opcode;
    wire[4:0] rs,rt,rd,sa;
    wire[5:0] func;
    wire[15:0] Immediate;
    wire[25:0] targetAddress;
    
    IF_ID_Register if_id_register(
    .IF_ID_Flush(IF_ID_Flush),
    .IF_ID_Wre(IF_ID_Wre),
    .Clk(Clk),
    .IF_Instruction(IF_Instruction),
    .IF_PCadd4(IF_PCadd4),
    .ID_Instruction(ID_Instruction),
    .ID_PCadd4(ID_PCadd4),
    
    .Opcode(Opcode),
    .rs(rs),
    .rt(rt),
    .rd(rd),
    .sa(sa),
    .func(func),
    .Immediate(Immediate),
    .targetAddress(targetAddress)
    );
    
    initial begin
        //正常情况下：顺序执行
        IF_ID_Flush=0;
        IF_ID_Wre=1;
        
        Clk=1;
        IF_Instruction=32'd8;
        IF_PCadd4=32'd4;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        IF_Instruction=32'd12;
        IF_PCadd4=32'd8;
        Clk=1;
        #50;
        
        IF_ID_Flush=1;
        Clk=0;
        #50;
        
        //分支指令，要发生分支
        
        

        IF_Instruction=32'd16;
        IF_PCadd4=32'd8;
        Clk=1;
        #50;
        
        //继续正常顺序执行
        IF_ID_Flush=0;
        Clk=0;
        #50;
        
        
        IF_ID_Wre=1;
        
        Clk=1;
        IF_Instruction=32'd20;
        IF_PCadd4=32'd12;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        
        //load-use冲突，要阻塞
        IF_ID_Flush=0;
        IF_ID_Wre=0;//不写入
        
        Clk=1;
        IF_Instruction=32'd24;
        IF_PCadd4=32'd16;
        Clk=1;
        #50;
        
        Clk=0;
        //#50;
        
        //继续正常顺序执行
        IF_ID_Flush=0;
        IF_ID_Wre=1;
        
 
        IF_Instruction=32'd28;
        IF_PCadd4=32'd20;
        Clk=1;
        #50;
        
        Clk=0;
        #50;
        
        $stop;
    end
endmodule
```



仿真波形图如下：

![IF_ID仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/IF_ID%E4%BB%BF%E7%9C%9F.png)



### 4. 寄存器堆 Register File

```verilog
module RegisterFile(
    //控制信号
    input wire Clk,RegWre,
    
    //数据通路
    input wire[4:0] rs,rt,WriteReg,
    input wire[31:0] WriteData,
    
    output wire[31:0] ReadData1,ReadData2

    
    //初始化寄存器
    reg [31:0] register[0:31];//32个寄存器，每个寄存器32位
    integer i;
    initial begin
        for(i = 0;i < 32;i=i+1) 
            register[i] <= 0;//每个寄存器初始化为0
    end
    
    //读取部分（组合逻辑电路）
    wire[4:0] ReadReg1,ReadReg2;
    assign ReadReg1=rs;
    assign ReadReg2=rt;
    assign ReadData1=register[ReadReg1];
    assign ReadData2=register[ReadReg2];
    
    //写入部分（组合逻辑电路）
    //当时钟下降沿来临时，且RegWre==1，才可以写入
    always @(posedge Clk) begin
        if((RegWre==1)&& (WriteReg!=0))//避免写入0号寄存器
            register[WriteReg]<= WriteData;
    end
    
endmodule
```



仿真代码如下：

```verilog
module RegisterFile_tb(

    );
    //input 
    reg Clk,RegWre;
    
    reg[4:0] rs,rt,WriteReg;
    reg[31:0] WriteData;
    
    //output 
    wire[31:0] ReadData1,ReadData2;
    
    //例化
    RegisterFile RF(
    .Clk(Clk),
    .RegWre(RegWre),
    .rs(rs),
    .rt(rt),
    .WriteData(WriteData),
    .WriteReg(WriteReg),
    .ReadData1(ReadData1),
    .ReadData2(ReadData2)
    );
    
    initial begin
   
    //test1:不写
    Clk=1;
    RegWre=0;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd1;
    WriteReg=5'd1;
    #50;
    
    Clk=0;
    #50;
    
    //test2:写
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd2;
    WriteReg=5'd1;
    #50;
    
    Clk=0;
    #50;
    
    //test3:不写
    Clk=1;
    RegWre=0;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd3;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    //test4:写
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd16;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    //test5:写
    Clk=1;
    RegWre=1;
    rs=5'd1;
    rt=5'd2;
    WriteData=32'd3;
    WriteReg=5'd2;
    #50;
    
    Clk=0;
    #50;
    
    $stop;
    
    
    end
endmodule
```



仿真波形图如下：

![RF仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/RF%E4%BB%BF%E7%9C%9F.png)



### 5. 符号扩展单元SignZeroExtend

符号扩展单元是CPU中的负责**将立即数进行零扩展或者符号扩展**的模块。

该模块接受2个输入：

- ExtSel：符号扩展单元的扩展方式。为1，则符号扩展，为0，则零扩展
- Immediate (16 bit)：立即数字段

产生2个输出：

- Out (32 bit)：扩展后的数据

```verilog
module SignZeroExtend(ExtSel,Immediate,Out
    );
    input ExtSel;//1:符号扩展，0：零扩展
    input wire [15:0] Immediate;
    output wire [31:0] Out;
    
    assign Out[15:0]=Immediate[15:0];
    assign Out[15:0]=Immediate[15:0];
    assign Out[31:16]= ExtSel==1? {16{Immediate[15]}}:16'b0;
    
endmodule
```



仿真代码如下：

```verilog
module SignZeroExtend_tb( );
    //inputs
    reg signed [15:0] Immediate;
    reg ExtSel;
    
    //outputs
    wire [31:0] Out;
    
    SignZeroExtend uut(
        .Immediate(Immediate),
        .ExtSel(ExtSel),
        .Out(Out)
    );
    
    initial begin
    
        //Test1：测试零扩展
        ExtSel = 0;
        Immediate[15:0] = 15'd9;
        #50;
        
        //Test2：测试符号扩展，最高位=0
        ExtSel = 1;
        Immediate[15:0] = 15'd10;
        #50;
        
        ///Test3：测试符号扩展，最高位=1
        ExtSel = 1;
        Immediate[15:0] = 15'd7;
        Immediate[15] = 1;
        #50;
        
        $stop;
    end
```



仿真波形图如下：

![Extend仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/Extend%E4%BB%BF%E7%9C%9F.png)



### 6. 主控制单元 Control Unit

```verilog
`timescale 1ns / 1ps

module Control_Unit(
    //控制信号
    
    input wire Branch,
    input wire ControlSrc,
    
    //IF阶段
    output reg PCWre,
    output reg [1:0] PCSrc,
    output reg JumpPCSrc,

    //ID阶段
    output reg ExtSel,
    
    //EX阶段
    output reg [1:0] RegDst,
    output reg ALUSrcB,
    output reg [3:0] ALUOp,
    
    //MEM阶段
    output reg[1:0] BranchType,
    output reg MemWre,
    output reg MemRead,
    
    //WB阶段
    output reg RegWre,
    output reg [1:0] DBDataSrc,
    
    //处理分支，跳转的清零信号
    output reg IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush,
   
    //数据通路
    input wire [5:0] Opcode,
    input wire [5:0] func//专门为jr而设
    );
    
    initial begin
        IF_ID_Flush=0;
        PCSrc=0;
        PCWre=1;
    end  
    
    always @(*) begin
        //默认不分支，全为0
        IF_ID_Flush=0;
        ID_EX_Flush=0;
        EX_MEM_Flush=0;
        
        //处理分支
        //如果要分支，则IF_ID_Flush,ID_EX_Flush,EX_MEM_Flush 均为1，用于清零
        if(Branch==1) begin
            PCSrc=2'b01;//要分支，所以 PCSrc=2'b01
            PCWre=1;
            IF_ID_Flush=1;
            ID_EX_Flush=1;
            EX_MEM_Flush=1;
        end


        //如果出现Load-use冲突
        else if(ControlSrc==1) begin
            RegWre=0;//不写寄存器
            MemWre=0;//不写存储器
        end

        //其他情况（包含跳转在内）：
        else begin
        case(Opcode)
            6'b000000://R型或jr
            
                 //jr
                if(func==6'b001000)
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=0;//从寄存器rs取来
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，任意均可
                    
                    //IF_ID_Register中的数据清零
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
                
                //R型指令
                else 
                begin
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1，任意均可
                    
                    //EX
                    RegDst=1;//rd
                    ALUSrcB=0;
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b1000;//R型指令
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                    
                end
            6'b001001://addiu
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001100://andi
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0010;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001101://ori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0011;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001110://xori
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=0;
                    ALUOp=4'b0111;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b001010://slti
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0110;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=0;//写回ALU的数据
                end
            6'b101011://sw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=1;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;//不写寄存器
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b100011://lw
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//rt
                    ALUSrcB=1;
                    ExtSel=1;
                    ALUOp=4'b0000;
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=1;
                    
                    //WB阶段
                    RegWre=1;
                    DBDataSrc=1;//从Data Memory写回
                end
            6'b000100://beq
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b01;//beq
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000101://bne
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b10;//bne
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000001://bltz
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b00;//假设顺序执行，所以 PCSrc=2'b00
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;
                    ExtSel=1;
                    ALUOp=4'b0001;//减法
                    
                    //MEM阶段
                    BranchType=2'b11;//bltz
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                end
            6'b000010://j
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=0;//默认0，任意均可
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=0;
                    DBDataSrc=0;//默认0，实际上任意皆可
                    
                    //IF_ID_Register中的数据清零
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
            6'b000011://jal
                begin 
                    //IF
                    PCWre=1;
                    PCSrc=2'b10;
                    JumpPCSrc=1;//默认1
                    
                    //EX
                    RegDst=2'b10;//写回$31寄存器
                    ALUSrcB=0;//默认0，任意均可
                    ExtSel=1;//默认1，任意均可
                    ALUOp=4'b0000;//默认，任意均可
                    
                    //MEM阶段
                    BranchType=0;
                    MemWre=0;
                    MemRead=0;
                    
                    //WB阶段
                    RegWre=1; //写回$31寄存器
                    DBDataSrc=2;//写回的数据是PC+4
                    
                    //IF_ID_Register中的数据清零
                    IF_ID_Flush=1;
                    ID_EX_Flush=0;
                    EX_MEM_Flush=0;
                end
            6'b111111://halt
                begin
                    //IF
                    PCWre=0;
                    PCSrc=2'b00;
                end
        endcase

        
        end
    end
endmodule

```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module Control_Unit_tb;

    //inputs
    // 控制信号
    reg Branch,ControlSrc;
    
    // 数据通路信号
    reg [5:0] Opcode;
    reg [5:0] func;
    
    //outputs
    // IF阶段
    wire PCWre;
    wire [1:0] PCSrc;
    wire JumpPCSrc;
    
    // EX阶段
    wire RegDst;
    wire ALUSrcB;
    wire ExtSel;
    wire [3:0] ALUOp;
    
    // MEM阶段
    wire [1:0] BranchType;
    wire MemWre;
    wire MemRead;
    
    // WB阶段
    wire RegWre;
    wire [1:0] DBDataSrc;
    
    // 处理分支，跳转的清零信号
    wire IF_ID_Flush, ID_EX_Flush, EX_MEM_Flush;
    
    // 实例化控制单元模块
    Control_Unit uut (
        .Branch(Branch),
        .ControlSrc(ControlSrc),
        .Opcode(Opcode),
        .func(func),
        .PCWre(PCWre),
        .PCSrc(PCSrc),
        .JumpPCSrc(JumpPCSrc),
        .RegDst(RegDst),
        .ALUSrcB(ALUSrcB),
        .ExtSel(ExtSel),
        .ALUOp(ALUOp),
        .BranchType(BranchType),
        .MemWre(MemWre),
        .MemRead(MemRead),
        .RegWre(RegWre),
        .DBDataSrc(DBDataSrc),
        .IF_ID_Flush(IF_ID_Flush),
        .ID_EX_Flush(ID_EX_Flush),
        .EX_MEM_Flush(EX_MEM_Flush)
    );
    
    // 仿真过程
    initial begin
        // 初始化信号
        Branch = 0;
        ControlSrc=0;
        Opcode = 6'b000000;
        func = 6'b000000;
        #10;
        
        // Test for R-type instruction (e.g., add)
        Opcode = 6'b000000; func = 6'b100000; Branch = 0; // R-type (add)
        #10;
        
        // Test for jump (j)
        Opcode = 6'b000010; func = 6'b000000; Branch = 0; // j
        #10;
        //Test for jump and link (jal)
        Opcode = 6'b000011;func = 6'b000000; Branch = 0; //jal
        #10;
        // Test for jump register (jr)
        Opcode = 6'b000000; func = 6'b001000; Branch = 0; // jr
        #10;
        
        // Test for branch equal (beq)
        Opcode = 6'b000100; func = 6'b000000; Branch = 0; // beq
        #10;
        // Test for branch not equal (bne)
        Opcode = 6'b000101; func = 6'b000000; Branch = 0; // bne
        #10;
        // Test for branch if less than (bltz)
        Opcode = 6'b000001; func = 6'b000000; Branch = 0; // bltz
        #10
        
        // Test for load word (lw)
        Opcode = 6'b100011; func = 6'b000000; Branch = 0; // lw
        #10; 
        // Test for store word (sw)
        Opcode = 6'b101011; func = 6'b000000; Branch = 0; // sw
        #10;
        
        // Test for add immediate (addiu)
        Opcode = 6'b001001; func = 6'b000000; Branch = 0; // addiu
        #10;
        // Test for and immediate (andi)
        Opcode = 6'b001100; func = 6'b000000; Branch = 0; // andi
        #10;
        // Test for or immediate (ori)
        Opcode = 6'b001101; func = 6'b000000; Branch = 0; // ori
        #10;
        // Test for xor immediate (xori)
        Opcode = 6'b001110; func = 6'b000000; Branch = 0; // xori
        #10;
        // Test for set less than immediate (slti)
        Opcode = 6'b001010; func = 6'b000000; Branch = 0; // slti
        #10;
        
        // Test for halt
        Opcode = 6'b111111; func = 6'b000000; Branch = 0; // halt
        #10;
        
        //测试要分支的情况
        Opcode = 6'b000000; func = 6'b100000;//任意指令
        Branch=1;ControlSrc=0;
        #10;

        //测试Load-use的情况
        Opcode = 6'b000000; func = 6'b100000;//任意指令
        Branch=0;ControlSrc=1;
        #10;
        $finish;
    end
    
endmodule
```



仿真波形图如下：

![主控仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E4%B8%BB%E6%8E%A7%E4%BB%BF%E7%9C%9F.png)



### 7. ID/EX流水线寄存器

```verilog
module ID_EX_Register(
    //控制信号
    input wire Clk,ID_EX_Flush,
    
    //EX阶段的信号
    input wire ID_ALUSrcB,
    output reg EX_ALUSrcB,
    
    input wire [3:0] ID_ALUOp,
    output reg [3:0] EX_ALUOp,
    
    input wire [1:0] ID_RegDst,
    output reg [1:0] EX_RegDst,
    
    
    //MEM阶段的信号
    input wire ID_MemWre,
    output reg EX_MemWre,
    
    input wire ID_MemRead,
    output reg EX_MemRead,
    
    input wire[1:0] ID_BranchType,
    output reg[1:0] EX_BranchType,
    
    
    //WB阶段的信号
    input wire [1:0]ID_DBDataSrc,
    output reg [1:0]EX_DBDataSrc,
    
    input wire ID_RegWre,
    output reg EX_RegWre,
    
    
    //数据通路
    input wire [31:0] ID_PCadd4,
    output reg [31:0] EX_PCadd4,
    
    input wire [31:0] ID_ReadData1,ID_ReadData2,
    output reg [31:0] EX_ReadData1,EX_ReadData2,
    
    input wire[4:0] ID_sa,ID_rs,ID_rt,ID_rd,
    output reg[4:0] EX_sa,EX_rs,EX_rt,EX_rd,
    
    input wire[31:0] ID_Immediate32,
    output reg[31:0] EX_Immediate32,
    
    input wire[5:0] ID_func,
    output reg[5:0] EX_func
    
    );
    
    //初始化
    initial begin
        EX_ALUSrcB=0;
        EX_ALUOp=0;
        EX_DBDataSrc=0;
        EX_RegWre=0;
        EX_RegDst=0;
        EX_BranchType=0;
        EX_MemWre=0;
        EX_MemRead=0;
        
        EX_PCadd4=0;
        EX_ReadData1=0;
        EX_ReadData2=0;
        EX_sa=0;
        EX_rs=0;
        EX_rt=0;
        EX_rd=0;
        EX_Immediate32=0;
        EX_func=0;
        
    end
    
     //写入
    always @(negedge Clk or posedge Clk) begin 
       if(Clk==0) begin
           if(ID_EX_Flush==0) begin
                //EX阶段的信号
                EX_ALUSrcB<=ID_ALUSrcB;
                EX_ALUOp<=ID_ALUOp;
                EX_RegDst<=ID_RegDst;
                
                //MEM阶段的信号
                EX_MemWre<=ID_MemWre;
                EX_MemRead<=ID_MemRead;
                EX_BranchType<=ID_BranchType;
                
                //WB阶段的信号
                EX_DBDataSrc<=ID_DBDataSrc;
                EX_RegWre<=ID_RegWre;
                
                //数据通路
                EX_PCadd4<=ID_PCadd4;
                EX_ReadData1<=ID_ReadData1;
                EX_ReadData2<=ID_ReadData2;
                EX_sa<=ID_sa;
                EX_rs<=ID_rs;
                EX_rt<=ID_rt;
                EX_rd<=ID_rd;
                EX_Immediate32<=ID_Immediate32;
                EX_func<=ID_func;
                
           end
       end
       
       else//Clk==1
       begin
            if(ID_EX_Flush==1) begin     
             //EX阶段的信号
            EX_ALUSrcB=0;
            EX_ALUOp=8;//模仿addiu $0,$0,0 。即：nop 
            EX_RegDst=0;
            
            //MEM阶段的信号
            EX_MemWre=0;
            EX_MemRead=0;
            EX_BranchType=0;
            
            //WB阶段的信号
            EX_DBDataSrc=0;
            EX_RegWre=0;
            
            //数据通路
            EX_PCadd4=0;
            EX_ReadData1=0;
            EX_ReadData2=0;
            EX_sa=0;
            EX_rs=0;
            EX_rt=0;
            EX_rd=0;
            EX_Immediate32=0;
            EX_func=0;
           end
       end
    end
endmodule

```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module ID_EX_Register_tb();

    // 输入信号
    reg Clk, ID_EX_Flush;

    // EX阶段的信号
    reg ID_ALUSrcB;       // input
    wire EX_ALUSrcB;       // output

    reg [3:0] ID_ALUOp;   // input
    wire [3:0] EX_ALUOp;   // output

    reg [1:0] ID_RegDst;        // input
    wire [1:0] EX_RegDst;        // output

    // MEM阶段的信号
    reg ID_MemWre;        // input
    wire EX_MemWre;        // output

    reg ID_MemRead;       // input
    wire EX_MemRead;       // output

    reg [1:0] ID_BranchType;  // input
    wire [1:0] EX_BranchType;  // output

    // WB阶段的信号
    reg [1:0]ID_DBDataSrc;     // input
    wire [1:0]EX_DBDataSrc;     // output

    reg ID_RegWre;        // input
    wire EX_RegWre;        // output

    // 数据通路信号
    reg [31:0] ID_PCadd4;     // input
    wire [31:0] EX_PCadd4;     // output

    reg [31:0] ID_ReadData1, ID_ReadData2;   // input
    wire [31:0] EX_ReadData1, EX_ReadData2;   // output

    reg [4:0] ID_sa, ID_rs, ID_rt, ID_rd;    // input
    wire [4:0] EX_sa, EX_rs, EX_rt, EX_rd;    // output

    reg [31:0] ID_Immediate32;   // input
    wire [31:0] EX_Immediate32;   // output

    reg [5:0] ID_func;           // input
    wire [5:0] EX_func;           // output

    // 例化ID_EX_Register模块
    ID_EX_Register id_ex_register (
        .Clk(Clk),
        .ID_EX_Flush(ID_EX_Flush),
        .ID_ALUSrcB(ID_ALUSrcB),
        .EX_ALUSrcB(EX_ALUSrcB),
        .ID_ALUOp(ID_ALUOp),
        .EX_ALUOp(EX_ALUOp),
        .ID_RegDst(ID_RegDst),
        .EX_RegDst(EX_RegDst),
        .ID_MemWre(ID_MemWre),
        .EX_MemWre(EX_MemWre),
        .ID_MemRead(ID_MemRead),
        .EX_MemRead(EX_MemRead),
        .ID_BranchType(ID_BranchType),
        .EX_BranchType(EX_BranchType),
        .ID_DBDataSrc(ID_DBDataSrc),
        .EX_DBDataSrc(EX_DBDataSrc),
        .ID_RegWre(ID_RegWre),
        .EX_RegWre(EX_RegWre),
        .ID_PCadd4(ID_PCadd4),
        .EX_PCadd4(EX_PCadd4),
        .ID_ReadData1(ID_ReadData1),
        .EX_ReadData1(EX_ReadData1),
        .ID_ReadData2(ID_ReadData2),
        .EX_ReadData2(EX_ReadData2),
        .ID_sa(ID_sa),
        .EX_sa(EX_sa),
        .ID_rs(ID_rs),
        .EX_rs(EX_rs),
        .ID_rt(ID_rt),
        .EX_rt(EX_rt),
        .ID_rd(ID_rd),
        .EX_rd(EX_rd),
        .ID_Immediate32(ID_Immediate32),
        .EX_Immediate32(EX_Immediate32),
        .ID_func(ID_func),
        .EX_func(EX_func)
    );

    // 生成时钟信号
    always begin
        #50 Clk = ~Clk;  // 每50ns翻转一次时钟信号
    end

    initial begin
        // 初始化信号
        Clk = 0;
        ID_EX_Flush = 0;
        
        ID_ALUSrcB = 1;
        ID_ALUOp = 4'b0001;
        ID_RegDst = 2;
        ID_MemWre = 1;  
        ID_MemRead = 1;
        ID_BranchType = 2'b01;
        ID_DBDataSrc = 2;   
        ID_RegWre = 1;
        ID_PCadd4 = 32'h00000004; 
        ID_ReadData1 = 32'h00000010;
        ID_ReadData2 = 32'h00000020;
        ID_sa = 5'b00001;
        ID_rs = 5'b00010;
        ID_rt = 5'b00100;
        ID_rd = 5'b01000;
        ID_Immediate32 = 32'h0000FFFF;
        ID_func = 6'b100000;

        // 启动仿真
        #100;
        
        // 激活flush信号
        ID_EX_Flush = 1;
        #100;
        
        ID_EX_Flush = 0;
        #100;
        $stop;
    end

endmodule
```



仿真波形图如下：

![ID_EX仿真1](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ID_EX%E4%BB%BF%E7%9C%9F1.png)

![ID_EX仿真2](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ID_EX%E4%BB%BF%E7%9C%9F2.png)



###  8. ALU控制单元 ALU Control

```verilog
module ALU_Control(
    //数据通路
    input wire [5:0] func,
    
    //控制信号
    input wire [3:0] ALUOp,
    
    output reg ALUSrcA,
    output reg [3:0] ALUCtr
    );
    
    always @(*) begin
        ALUSrcA=0;
        case(ALUOp)
            4'b1000://R型指令
                 case(func)
                    6'b100000://add
                        ALUCtr=4'b0000;
                    6'b100010://sub
                        ALUCtr=4'b0001;
                    6'b100100://and
                        ALUCtr=4'b0010;
                    6'b100101://or
                        ALUCtr=4'b0011;
                    6'b000000://left shift
                    begin
                        ALUCtr=4'b0100;
                        ALUSrcA=1;
                    end
                    6'b100110://xor
                        ALUCtr=4'b0111;
                    6'b101011://无符号比较:sltu
                        ALUCtr=4'b0101;
                    6'b101010://有符号比较:slt
                        ALUCtr=4'b0110;
                    default:
                         ALUCtr=4'b0000;
                 endcase
                 
            4'b0000://加法:addi,sw,lw
                ALUCtr=4'b0000;
            4'b0001://减法:beq,bne,bltz
                ALUCtr=4'b0001;
            4'b0010://位与:andi
                ALUCtr=4'b0010;
            4'b0011://位或:ori
                ALUCtr=4'b0011;
            4'b0101://无符号比较:sltiu
                 ALUCtr=4'b0101;
            4'b0110://有符号比较:slti
                 ALUCtr=4'b0110;
            4'b0111://异或:xori
                 ALUCtr=4'b0111;
            default:
                 ALUCtr=4'b0000;
        endcase
    end
endmodule

```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module ALU_Control_tb();

    // Inputs
    reg [5:0] func;         // Function code (from the instruction)
    reg [3:0] ALUOp;        // ALU operation code

    // Outputs
    wire ALUSrcA;           // ALUSrcA control signal
    wire [3:0] ALUCtr;      // ALU control signals for the operation

    // Instantiate the ALU_Control module
    ALU_Control alu_control (
        .func(func),
        .ALUOp(ALUOp),
        .ALUSrcA(ALUSrcA),
        .ALUCtr(ALUCtr)
    );

    // Test stimulus
    initial begin
        // Test R-type instructions (ALUOp = 4'b1000)
        ALUOp = 4'b1000; func = 6'b100000; // ADD
        #10 
        ALUOp = 4'b1000; func = 6'b100010; // SUB
        #10 
        ALUOp = 4'b1000; func = 6'b100100; // AND
        #10 
        ALUOp = 4'b1000; func = 6'b100101; // OR
        #10 
        ALUOp = 4'b1000; func = 6'b000000; // LEFT SHIFT
        #10 
        ALUOp = 4'b1000; func = 6'b100110; // XOR
        #10 
        ALUOp = 4'b1000; func = 6'b101011; // SLTU (unsigned compare)
        #10 
        ALUOp = 4'b1000; func = 6'b101010; // SLT (signed compare)
        #10
        
        
        // Test I-type instructions (other ALUOp values)
        
        // Test ADDI (ALUOp = 4'b0000)
        ALUOp = 4'b0000; func = 6'b000000; // ADDI (any func code)
        #10
        // Test BEQ (ALUOp = 4'b0001)
        ALUOp = 4'b0001; func = 6'b000000; // BEQ (any func code)
        #10
        // Test ANDI (ALUOp = 4'b0010)
        ALUOp = 4'b0010; func = 6'b000000; // ANDI (any func code)
        #10
        // Test ORI (ALUOp = 4'b0011)
        ALUOp = 4'b0011; func = 6'b000000; // ORI (any func code)
        #10
        // Test SLTIU (ALUOp = 4'b0101)
        ALUOp = 4'b0101; func = 6'b000000; // SLTIU (any func code)
        #10
        // Test SLTI (ALUOp = 4'b0110)
        ALUOp = 4'b0110; func = 6'b000000; // SLTI (any func code)
        #10
        // Test XORI (ALUOp = 4'b0111)
        ALUOp = 4'b0111; func = 6'b000000; // XORI (any func code)
        #10
        
        // End of test
        $finish;
    end
    
endmodule
```



仿真波形图如下：

![ALUControl仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ALUControl%E4%BB%BF%E7%9C%9F.png)



### 9. 算术逻辑单元ALU

```verilog
`timescale 1ns / 1ps


module ALU(
    //控制信号
    input wire [3:0] ALUCtr,
    input wire ALUSrcA,ALUSrcB,
    input wire [1:0] ForwardA,ForwardB,
    
    //数据通路
    input wire [31:0] ReadData1,ReadData2,
    input wire [4:0] sa,
    input wire [31:0] ExtData,
    input wire [31:0] WB_WriteData,MEM_ALUResult,
    
    output wire Zero,
    output wire Sign,
    output reg [31:0] EX_ALUResult,
    output reg [31:0] TempDataA,//要展示于Basys板的数据
    output reg [31:0] TempDataB //要写入Data Memory的数据，且是要展示于Basys板的数据
    );
    
    //初始化
    initial begin
        EX_ALUResult=0;
    end

    
    //选择转发的数据
    always @(*) begin
        case(ForwardA)
            2'b00:
                TempDataA=ReadData1;
            2'b01:
                TempDataA=WB_WriteData;
            2'b10:
                TempDataA=MEM_ALUResult;
            default:
                TempDataA=ReadData1;
        endcase
        
        case(ForwardB)
            2'b00:
                TempDataB=ReadData2;
            2'b01:
                TempDataB=WB_WriteData;
            2'b10:
                TempDataB=MEM_ALUResult;
            default:
                TempDataB=ReadData2;
        endcase
    end
    
    //两个输入数据A,B
    wire [31:0] InA;
    wire [31:0] InB;
    
    //A端：如果ALUSrcA==0，则输入ReadData1; ALUSrcA==1，则输入sa
    assign InA=(ALUSrcA==0)?TempDataA:{27'b0,sa};
    //B端：如果ALUSrcB==0，则输入ReadData2; ALUSrcB==1，则输入ExtData
    assign InB=(ALUSrcB==0)?TempDataB:ExtData;
    
    
    //进行计算
    always@(*) begin
        case(ALUCtr)
            4'b0000:
                EX_ALUResult=InA + InB;
            4'b0001:
                EX_ALUResult=InA - InB;
            4'b0010:
                EX_ALUResult=InA & InB;
            4'b0011:
                EX_ALUResult=InA | InB;
            4'b0100://左移
                EX_ALUResult=InB << InA;
            4'b0101://无符号比较
                EX_ALUResult=(InA<InB)? 1:0;
            4'b0110://有符号比较
                EX_ALUResult=((InA[31]==1 && InB[31]==0)||(InA<InB && InA[31]==InB[31]))? 1:0;
            4'b0111://异或
                EX_ALUResult=InB ^ InA;
            default:
                EX_ALUResult=32'b0;
        endcase
    end
    
    //求Zero
    assign Zero=(EX_ALUResult==0)?1:0;
    
    //求Sign
    assign Sign=EX_ALUResult[31];
    
endmodule
```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module ALU_tb;

    // Inputs
    reg [3:0] ALUCtr;
    reg ALUSrcA, ALUSrcB;
    reg [1:0] ForwardA, ForwardB;
    reg [31:0] ReadData1, ReadData2;
    reg [4:0] sa;
    reg [31:0] ExtData;
    reg [31:0] WB_WriteData, MEM_ALUResult;

    // Outputs
    wire Zero;
    wire Sign;
    wire [31:0] EX_ALUResult;
    wire [31:0] TempDataB;

    // Instantiate the ALU module
    ALU uut (
        .ALUCtr(ALUCtr),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB),
        .ReadData1(ReadData1),
        .ReadData2(ReadData2),
        .sa(sa),
        .ExtData(ExtData),
        .WB_WriteData(WB_WriteData),
        .MEM_ALUResult(MEM_ALUResult),
        .Zero(Zero),
        .Sign(Sign),
        .EX_ALUResult(EX_ALUResult),
        .TempDataB(TempDataB)
    );

    // Test stimulus
    initial begin
        // Initialize Inputs
        ALUCtr = 4'b0000;  // ADD operation
        ALUSrcA = 0;
        ALUSrcB = 0;
        ForwardA = 2'b00;
        ForwardB = 2'b00;
        ReadData1 = 32'd00;
        ReadData2 = 32'd0;
        sa = 5'b0;
        ExtData = 32'd0;
        WB_WriteData = 32'd0;
        MEM_ALUResult = 32'd0;
        #10

        //正常执行
        // Test ADD operation
        ALUSrcA = 0; ALUSrcB = 0; ForwardA = 2'b00; ForwardB = 2'b00; ReadData1 = 32'd10; ReadData2 = 32'd5;
        ALUCtr = 4'b0000; // ADD
        #10 
        
        //Test ADDI operation
        ALUCtr = 4'b0000; // ADD
        ALUSrcA = 0; ALUSrcB = 1;  ReadData1 = 32'd10; ReadData2 = 32'd5; ExtData=32'd8;
        #10
        
        // Test SUB operation
        ALUCtr = 4'b0001; // SUB
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'd15; ReadData2 = 32'd10;
        #10 
        
        // Test AND operation
        ALUCtr = 4'b0010; // AND
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hF0F0F0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        // Test OR operation
        ALUCtr = 4'b0011; // OR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hFFFFF0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        // Test shift left operation (<<)
        ALUCtr = 4'b0100; // Shift left
        ALUSrcA = 1; ALUSrcB = 0;
        sa=5'd2; ReadData2 = 32'd8;
        #10 
        
        // Test unsigned comparison
        ALUCtr = 4'b0101; // Unsigned comparison
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hffffffff; ReadData2 = 32'd10;
        #10 
        
        // Test signed comparison
        ALUCtr = 4'b0110; // Signed comparison
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hffffffff; ReadData2 = 32'd10;
        #10 
        
        // Test XOR operation
        ALUCtr = 4'b0111; // XOR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'hFFFFF0F0; ReadData2 = 32'h0F0F0F0F;
        #10 
        
        
        //需要用旁路转发(简便起见：只用ADD来测试）
        // Test Forward
        ALUCtr = 4'b0000; // OR
        ALUSrcA = 0; ALUSrcB = 0;
        ReadData1 = 32'h1; ReadData2 = 32'h2;
        WB_WriteData = 32'd10;
        MEM_ALUResult = 32'd20;
        
        //单个数据需要转发
        ForwardA = 2'b01; 
        ForwardB = 2'b00;
        #10 
        
        ForwardA = 2'b00;
        ForwardB = 2'b01; 
        #10
        
        ForwardA = 2'b10;
        ForwardB = 2'b00;
        #10 
        
        ForwardA = 2'b00;
        ForwardB = 2'b10; 
        #10 
        
        
        //2个数据都要转发
        
        //都转发自WB
        ForwardA = 2'b01;
        ForwardB = 2'b01; 
        #10 
        
        //都转发自MEM
        ForwardA = 2'b10;
        ForwardB = 2'b10; 
        #10 
        
        //A转发自MEM，B转发自WB
        ForwardA = 2'b10;
        ForwardB = 2'b01; 
        #10 
        
        //A转发自WB，B转发自MEM
        ForwardA = 2'b01;
        ForwardB = 2'b10; 
        #10 
        
        // Finish the simulation
        $finish;
    end
    
endmodule
```



仿真波形图如下：

![ALU仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/ALU%E4%BB%BF%E7%9C%9F.png)



### 10. 分支地址计算单元

```verilog
`timescale 1ns / 1ps

module Adder_BranchPC(
    input wire [31:0] EX_PCadd4,
    input wire [31:0] EX_Immediate32,
    output wire [31:0] EX_BranchPC
    );
    assign EX_BranchPC=EX_PCadd4+(EX_Immediate32<<2);
    
endmodule
```



仿真代码如下：

```verilog
module Adder_BranchPC_tb( );
    //input 
    reg [31:0] EX_PCadd4;
    reg [31:0] EX_Immediate32;
    
    //output 
    wire [31:0] EX_BranchPC;
    
    //例化
    Adder_BranchPC adder_branchPC(
    .EX_PCadd4(EX_PCadd4),
    .EX_Immediate32(EX_Immediate32),
    .EX_BranchPC(EX_BranchPC)
    );
    
    initial begin
    //Test1:
        EX_PCadd4=32'h32;
        EX_Immediate32=-32'd2;
        #50;
        
    //Test2:
        EX_PCadd4=32'h84;
        EX_Immediate32=-32'd2;
        #50;
        
        $stop;
    end
endmodule
```



仿真波形图如下：

![分支加法器仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E5%88%86%E6%94%AF%E5%8A%A0%E6%B3%95%E5%99%A8%E4%BB%BF%E7%9C%9F.png)



### 11. 写入寄存器编号的多选器

```verilog
`timescale 1ns / 1ps
//选择写入的寄存器编号

module RegDst_Mux(
    //控制信号
    input wire[1:0] RegDst,
    
    //数据通路
    input wire[4:0] rt,rd,
    output wire [4:0] WriteReg
    );
    
    // MUX选择：根据RegDst选择目标寄存器
    // 如果RegDst是 00，选择rt；如果RegDst是 01，选择rd；如果RegDst是 10，选择$31（用于jal等指令）。
    assign WriteReg=(RegDst==2'b00)? rt:
                    (RegDst==2'b01)? rd:
                     5'd31;
                     
endmodule

```



仿真代码如下：

```verilog
module RegDst_Mux_tb( );
    //input
    reg [1:0] RegDst;
    reg [4:0] rt,rd;
    
    //output
    wire [4:0] WriteReg;
    
    //例化
    RegDst_Mux regdst_mux(
    .RegDst(RegDst),
    .rt(rt),
    .rd(rd),
    .WriteReg(WriteReg)
    );
    
    initial begin
        rt=5'd1;
        rd=5'd2;
        
        RegDst=2'b00;
        #50;
        
        rt=5'd1;
        rd=5'd2;
        RegDst=2'b01;
        #50;
        
        rt=5'd1;
        rd=5'd2;
        RegDst=2'b10;
        #50;
        
    $stop;
end
```



仿真波形图如下：

![RD多选器仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/RD%E5%A4%9A%E9%80%89%E5%99%A8%E4%BB%BF%E7%9C%9F.png)



### 12. EX/MEM流水线寄存器

```verilog
module EX_MEM_Register(
     //输入信号
     input wire Clk,EX_MEM_Flush,
    
    
     //MEM阶段的控制信号
     input wire EX_MemWre,
     output reg MEM_MemWre,
     
     input wire EX_MemRead,
     output reg MEM_MemRead,
     
     input wire[1:0] EX_BranchType,
     output reg[1:0] MEM_BranchType,
     
     
     //WB阶段的控制信号
     input wire[1:0] EX_DBDataSrc,
     output reg[1:0] MEM_DBDataSrc,
     
     input wire EX_RegWre,
     output reg MEM_RegWre,
    
    
     //数据通路
    input wire [31:0] EX_PCadd4,
    output reg [31:0] MEM_PCadd4,
    
    input wire [31:0] EX_BranchPC,
    output reg [31:0] MEM_BranchPC,
    
    input wire EX_Zero,EX_Sign,
    output reg MEM_Zero,MEM_Sign,
    
    input wire [31:0] EX_DataIn,
    output reg [31:0] MEM_DataIn,
    
    input wire [31:0] EX_ALUResult,
    output reg [31:0] MEM_ALUResult,
    
    input wire[4:0] EX_WriteReg,
    output reg[4:0] MEM_WriteReg
    );
    
    initial begin
        MEM_MemWre=0;
        MEM_MemRead=0;
        MEM_BranchType=0;
        MEM_RegWre=0;
        MEM_DBDataSrc=0;
        
        MEM_PCadd4=0;
        MEM_BranchPC=0;
        MEM_Zero=0;
        MEM_Sign=0;
        MEM_DataIn=0;
        MEM_ALUResult=0;
        MEM_WriteReg=0;
    end
    
     
    always @(negedge Clk or posedge Clk) begin 
        if(Clk==0) begin
           if(EX_MEM_Flush==0) begin
                
                //MEM阶段的控制信号
                MEM_MemWre<=EX_MemWre;
                MEM_MemRead<=EX_MemRead;
                MEM_BranchType<=EX_BranchType;
                
                //WB阶段的控制信号
                MEM_DBDataSrc<=EX_DBDataSrc;
                MEM_RegWre<=EX_RegWre;
                
                 //数据通路
                MEM_PCadd4<=EX_PCadd4;
                MEM_BranchPC<=EX_BranchPC;
                MEM_Zero<=EX_Zero;
                MEM_Sign<=EX_Sign;
                MEM_DataIn<=EX_DataIn;
                MEM_ALUResult<=EX_ALUResult;
                MEM_WriteReg<=EX_WriteReg;
           end
        end
        
        else //Clk==1
        begin
            if(EX_MEM_Flush==1)//处理分支
            begin     
                //MEM阶段的控制信号
                MEM_MemWre=0;
                MEM_MemRead=0;           
                MEM_BranchType=0;// 保持原有的值 错
                
                //WB阶段的控制信号
                MEM_DBDataSrc=0;
                MEM_RegWre=0;
                
                //数据通路
                MEM_PCadd4=0;
                //MEM_BranchPC=0;// 保持原有的值
                MEM_Zero=0;// 保持原有的值 错
                MEM_Sign=0;// 保持原有的值 错
                MEM_DataIn=0;
                MEM_ALUResult=0;
                MEM_WriteReg=0;
            end
        end
    end
    
endmodule
```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module EX_MEM_Register_tb;
    
    // 控制信号
    reg Clk;
    reg EX_MEM_Flush;

    // MEM阶段的信号
    reg EX_MemWre;
    wire MEM_MemWre;

    reg EX_MemRead;
    wire MEM_MemRead;

    reg [1:0] EX_BranchType;
    wire [1:0] MEM_BranchType;

    // WB阶段的信号
    reg [1:0] EX_DBDataSrc;
    wire [1:0] MEM_DBDataSrc;

    reg EX_RegWre;
    wire MEM_RegWre;

    // 数据通路
    reg [31:0] EX_PCadd4;
    wire [31:0] MEM_PCadd4;
    
    reg [31:0] EX_BranchPC;
    wire [31:0] MEM_BranchPC;

    reg EX_Zero;
    wire MEM_Zero;

    reg EX_Sign;
    wire MEM_Sign;

    reg [31:0] EX_DataIn;
    wire [31:0] MEM_DataIn;

    reg [31:0] EX_ALUResult;
    wire [31:0] MEM_ALUResult;

    reg [4:0] EX_WriteReg;
    wire [4:0] MEM_WriteReg;

    // 例化EX_MEM_Register模块
    EX_MEM_Register ex_mem_register (
        .Clk(Clk),
        .EX_MEM_Flush(EX_MEM_Flush),
        .EX_MemWre(EX_MemWre),
        .MEM_MemWre(MEM_MemWre),
        .EX_MemRead(EX_MemRead),
        .MEM_MemRead(MEM_MemRead),
        .EX_BranchType(EX_BranchType),
        .MEM_BranchType(MEM_BranchType),
        .EX_DBDataSrc(EX_DBDataSrc),
        .MEM_DBDataSrc(MEM_DBDataSrc),
        .EX_RegWre(EX_RegWre),
        .MEM_RegWre(MEM_RegWre),
        .EX_PCadd4(EX_PCadd4),
        .MEM_PCadd4(MEM_PCadd4),
        .EX_BranchPC(EX_BranchPC),
        .MEM_BranchPC(MEM_BranchPC),
        .EX_Zero(EX_Zero),
        .MEM_Zero(MEM_Zero),
        .EX_Sign(EX_Sign),
        .MEM_Sign(MEM_Sign),
        .EX_DataIn(EX_DataIn),
        .MEM_DataIn(MEM_DataIn),
        .EX_ALUResult(EX_ALUResult),
        .MEM_ALUResult(MEM_ALUResult),
        .EX_WriteReg(EX_WriteReg),
        .MEM_WriteReg(MEM_WriteReg)
    );

    // 时钟信号生成
    always begin
        #50 Clk = ~Clk;
    end

    // 初始化信号
    initial begin
        // 初始化时钟
        Clk = 0;

        // 初始化输入信号
        EX_MEM_Flush = 0;
        EX_MemWre = 1;
        EX_MemRead = 1;
        EX_BranchType = 2'b01;
        EX_DBDataSrc = 2;
        EX_RegWre = 1;
        EX_PCadd4=32'h12340000;
        EX_BranchPC = 32'h12345678;
        EX_Zero = 1;
        EX_Sign = 0;
        EX_DataIn = 32'hABC;
        EX_ALUResult = 32'hC0FFEE;
        EX_WriteReg = 5'b00001;

        // 仿真开始
        #100;

        // 激活 flush 信号，模拟分支条件
        EX_MEM_Flush = 1;
        #100;

        // 清除 flush 信号，恢复正常
        EX_MEM_Flush = 0;
        #100;

        // 停止仿真
        $stop;
    end
endmodule
```



仿真波形图如下：

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/EX_MEM%E4%BB%BF%E7%9C%9F.png" alt="EX_MEM仿真" style="zoom: 67%;" />



### 13. 分支检测单元 Branch Detection Unit

```verilog
`timescale 1ns / 1ps

module Branch_Detection_Unit(
    //控制信号
    input wire [1:0] MEM_BranchType,
   
    //数据通路
    input wire MEM_Zero, MEM_Sign,
    output reg Branch
    );
    always @(*) begin
        if(MEM_BranchType==2'b01 && MEM_Zero==1) Branch=1;//是beq指令,且计算结果为0（说明相等），要分支
        else if(MEM_BranchType==2'b10 && MEM_Zero==0) Branch=1;//是bne指令,且计算结果不为0（说明不相等），要分支
        else if(MEM_BranchType==2'b11 && MEM_Sign==1) Branch=1;//是bltz指令,且计算结果为<0，要分支
        else Branch=0; //不是分支指令，则不分支
    end
    
endmodule
```



仿真代码如下：

```verilog
`timescale 1ns / 1ps

module Branch_Detection_Unit_tb;

    // inputs
    reg [1:0] MEM_BranchType;
    reg MEM_Zero, MEM_Sign;
    
    //output
    wire Branch;

    // 实例化被测试模块
    Branch_Detection_Unit uut (
        .MEM_BranchType(MEM_BranchType),
        .MEM_Zero(MEM_Zero),
        .MEM_Sign(MEM_Sign),
        .Branch(Branch)
    );


    initial begin

        // 初始化输入信号
        MEM_BranchType = 2'b00; // 默认状态
        MEM_Zero = 0;
        MEM_Sign = 0;
        #10 
        // Test1: beq指令，MEM_Zero = 1（相等），应该分支
        MEM_BranchType = 2'b01; MEM_Zero = 1;
        #10 

        // Test2: beq 指令，MEM_Zero = 0（不相等），不应该分支
        MEM_BranchType = 2'b01;  MEM_Zero = 0;
        #10 

        // Test3: bne 指令，MEM_Zero = 1（相等），不应该分支
        MEM_BranchType = 2'b10; MEM_Zero = 1;
        #10

        // Test4: bne 指令，MEM_Zero = 0（不相等），应该分支
        MEM_BranchType = 2'b10;  MEM_Zero = 0;
        #10

        // Test5: bltz 指令，MEM_Sign = 1（负数），应该分支
        MEM_BranchType = 2'b11; MEM_Sign = 1;
        #10

        // Test6: bltz 指令，MEM_Sign = 0（非负数），不应该分支
        MEM_BranchType = 2'b11; MEM_Sign = 0;
        #10

        // Test7: 非分支指令，MEM_BranchType = 2'b00，不应该分支
        MEM_BranchType = 2'b00;
        #10

        $finish;
    end
endmodule

```



仿真波形图如下：

![分支检测单元仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E5%88%86%E6%94%AF%E6%A3%80%E6%B5%8B%E5%8D%95%E5%85%83%E4%BB%BF%E7%9C%9F.png)



### 14. 数据存储器 Data Memory

```verilog
`timescale 1ns / 1ps


module DataMemory(
    //控制信号
    input wire MemWre,
    input wire MemRead,
    input wire Clk,

    //数据通路
    input wire[31:0] DataAddress,DataIn,
    
    output reg [31:0] DataOut
    );
    //存储器,以8位为一字节，共128字节
    reg [7:0] Memory[0:63];
    
    //初始化存储器为0
    integer i;
    initial begin
        for(i=0;i<128;i=i+1)
            Memory[i]<=0;
    end
    
    //读取数据
    //当MemRead==1时，才可以读取
    always@(*)
    begin
        if(MemRead) begin
            DataOut[31:24]<=Memory[DataAddress];
            DataOut[23:16]<=Memory[DataAddress+1];
            DataOut[15:8]<=Memory[DataAddress+2];
            DataOut[7:0]<=Memory[DataAddress+3];
        end
        else begin
            DataOut = 32'bz;  // 如果 MemRead 为 0，输出高阻态z
        end
    end
    
    //写入数据
    //当时钟下降沿来临时，且MemWre==1，才可以写入
    always @(negedge Clk)begin
        if(MemWre) begin
            Memory[DataAddress]<=DataIn[31:24];
            Memory[DataAddress+1]<=DataIn[23:16];
            Memory[DataAddress+2]<=DataIn[15:8];
            Memory[DataAddress+3]<=DataIn[7:0];
        end
    end
endmodule
```



仿真代码如下：

```verilog
module DataMemory_tb(    );
    //inputs
    //控制信号
    reg MemWre,
MemRead,Clk;
    //数据通路
    reg [31:0] DataAddress,DataIn;
    
    //output
    wire [31:0] DataOut;//仿真文件中的output一定是wire型
    
    DataMemory DMem(
    .MemWre(MemWre),
    .MemRead(MemRead),
    .Clk(Clk),
    .DataAddress(DataAddress),
    .DataIn(DataIn),
    .DataOut(DataOut)
    );
    
    initial begin //initial中只能对reg型进行赋值，如果对wire型就会报错
        
        //Test1:测试 写数据
         MemWre=1;
         MemRead=0;
         DataAddress=32'd8;
         DataIn=32'd1;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test2:测试 读已有的数据
         MemWre=0;
         MemRead=1;
         DataAddress=32'd8;
         DataIn=32'd2;
         Clk=1;
         #50;
         Clk=0;
         #50;
         
         //Test3:测试 读未有的数据
         MemWre=0;
         MemRead=1;
         DataAddress=32'd1;
         DataIn=32'd3;
         Clk=1;
         #50;
         Clk=0;
         #50;
         $stop;

    end
endmodule
```



仿真波形图如下：

![DataMemory仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/DataMemory%E4%BB%BF%E7%9C%9F.png)



### 15. MEM/WB流水线寄存器

```verilog
`timescale 1ns / 1ps


module MEM_WB_Register(
     //控制信号
     input wire Clk,//MEM_WB_Flush,
     
     
     //WB阶段的信号
     input wire [1:0] MEM_DBDataSrc,
     output reg [1:0] WB_DBDataSrc,
     
     input wire MEM_RegWre,
     output reg WB_RegWre,
    
    
    //数据通路
    input wire [31:0] MEM_PCadd4,
    output reg [31:0] WB_PCadd4,
    
    input wire [31:0] MEM_DataFromMemory,
    output reg [31:0] WB_DataFromMemory,
    
    input wire [31:0] MEM_DataFromALU,
    output reg [31:0] WB_DataFromALU,
    
    input wire [4:0] MEM_WriteReg,
    output reg [4:0] WB_WriteReg
    );
    
    //初始化
    initial begin
    
        WB_DBDataSrc=0;
        WB_RegWre=0;
        
        WB_PCadd4=0;
        WB_DataFromALU=0;
        WB_DataFromMemory=0;
        WB_WriteReg=0;
    end
    
     //写入
    always @(negedge Clk) begin 
       //if(MEM_WB_Flush==0) begin
            
            //WB阶段的信号
            WB_DBDataSrc<=MEM_DBDataSrc;
            WB_RegWre<=MEM_RegWre;
            
            //数据通路
            WB_PCadd4<=MEM_PCadd4;
            WB_DataFromMemory<=MEM_DataFromMemory;
            WB_DataFromALU<=MEM_DataFromALU;
            WB_WriteReg<=MEM_WriteReg;
       //end
    end
    
endmodule

```

仿真代码如下：

```verilog
`timescale 1ns / 1ps

module MEM_WB_Register_tb;

    // 控制信号
    reg Clk;
    //reg MEM_WB_Flush;

    // WB阶段的信号
    reg [1:0] MEM_DBDataSrc;
    wire [1:0] WB_DBDataSrc;

    reg MEM_RegWre;
    wire WB_RegWre;

    // 数据通路信号
    reg [31:0] MEM_PCadd4;
    wire [31:0] WB_PCadd4;
     
    reg [31:0] MEM_DataFromMemory;
    wire [31:0] WB_DataFromMemory;

    reg [31:0] MEM_DataFromALU;
    wire [31:0] WB_DataFromALU;

    reg [4:0] MEM_WriteReg;
    wire [4:0] WB_WriteReg;

    // 例化 MEM_WB_Register 模块
    MEM_WB_Register mem_wb_register (
        .Clk(Clk),
        //.MEM_WB_Flush(MEM_WB_Flush),
        .MEM_DBDataSrc(MEM_DBDataSrc),
        .WB_DBDataSrc(WB_DBDataSrc),
        .MEM_RegWre(MEM_RegWre),
        .WB_RegWre(WB_RegWre),
        .MEM_PCadd4(MEM_PCadd4),
        .WB_PCadd4(WB_PCadd4),
        .MEM_DataFromMemory(MEM_DataFromMemory),
        .WB_DataFromMemory(WB_DataFromMemory),
        .MEM_DataFromALU(MEM_DataFromALU),
        .WB_DataFromALU(WB_DataFromALU),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_WriteReg(WB_WriteReg)
    );

    // 时钟信号生成
    always begin
        #50 Clk = ~Clk;
    end

    // 初始化信号
    initial begin
        // 初始化时钟
        Clk = 0;

        // 初始化输入信号
        MEM_PCadd4=32'h12341234;
        MEM_DBDataSrc = 1;
        MEM_RegWre = 1;
        MEM_DataFromMemory = 32'hA5A5A5A5;
        MEM_DataFromALU = 32'h5A5A5A5A;
        MEM_WriteReg = 5'b10101;

        // 仿真开始
        #100;
        
        MEM_PCadd4=32'h12;
        MEM_DBDataSrc = 2;
        MEM_RegWre = 1;
        MEM_DataFromMemory = 32'hA5;
        MEM_DataFromALU = 32'h5A;
        MEM_WriteReg = 5'b10;
        #100;

        // 停止仿真
        $stop;
    end

endmodule
```



仿真波形图如下：

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/MEM_WB%E4%BB%BF%E7%9C%9F.png" alt="MEM_WB仿真" style="zoom: 67%;" />



### 16. 写回寄存器数据的多选器

```verilog
`timescale 1ns / 1ps

//选择写回寄存器堆的数据的来源
module WB_Mux(
    //控制信号
    input wire[1:0] DBDataSrc,
    
    //数据通路
    input wire[31:0] DataFromALU,DataFromMem,WB_PCadd4,
    
    output wire[31:0] WriteData
    );
    //选择写入数据的来源
    

    
    assign WriteData=(DBDataSrc==2'b10)?WB_PCadd4 //如果DBDataSrc=2，则写回PC+4
            :(DBDataSrc==2'b01)? DataFromMem      //如果DBDataSrc=1，则写回从Data Memory读取的数据
            :DataFromALU;                         //默认写回ALU的结果
    
endmodule
```



仿真代码如下：

```verilog
module WB_Mux_tb( );
    
    //input
    reg [1:0] DBDataSrc;
    
    reg[31:0] DataFromALU,DataFromMem,WB_PCadd4;
    
    //output
    wire[31:0] WriteData;
    
     WB_Mux wb_mux(
     .DBDataSrc(DBDataSrc),
     .DataFromALU(DataFromALU),
     .DataFromMem(DataFromMem),
     .WB_PCadd4(WB_PCadd4),
     .WriteData(WriteData)
     );
     
     initial begin
     DataFromALU=32'd8;
     DataFromMem=32'd4;
     WB_PCadd4=32'd12;
     
     DBDataSrc=2'b00;
     #50;
     
     DBDataSrc=2'b01;
     #50;
     
     DBDataSrc=2'b10;
     #50;
     $stop;
     end
    
endmodule
```



仿真波形图如下：

![写回数据多选器仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E5%86%99%E5%9B%9E%E6%95%B0%E6%8D%AE%E5%A4%9A%E9%80%89%E5%99%A8%E4%BB%BF%E7%9C%9F.png)



### 17. 旁路单元 Forwarding_Unit

```verilog
module Forwarding_Unit(
    //控制信号
    input wire MEM_RegWre,WB_RegWre,
    output reg [1:0] ForwardA,ForwardB,
        
    //数据通路
    input wire [4:0] EX_rs,EX_rt,MEM_WriteReg,WB_WriteReg
    );
    
    always @(*) begin
        //默认 不转发
        ForwardA=2'b00;
        ForwardB=2'b00;
        
        //从MEM阶段到EX阶段的旁路
        if(MEM_RegWre==1 && MEM_WriteReg!=0) begin  
            if(EX_rs==MEM_WriteReg) begin  //如果MEM阶段的WriteReg与EX阶段的rs相同，说明要用旁路转发
                 ForwardA=2'b10;
            end
            
            if(EX_rt==MEM_WriteReg) begin //如果MEM阶段的WriteReg与EX阶段的rt相同，说明要用旁路转发
                 ForwardB=2'b10;          //则从MEM阶段到EX阶段转发
            end
            
        end
        
        //从WB阶段到EX阶段的旁路
        if(WB_RegWre==1 && WB_WriteReg!=0) begin
            
            //如果WB阶段的WriteReg与EX阶段的rs相同，
            if(EX_rs==WB_WriteReg) begin       
                
                 //并且 MEM阶段的WriteReg与EX阶段的rs不同
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rs==MEM_WriteReg)) begin
                    ForwardA=2'b01;            //则从WB阶段到EX阶段转发
                end
            end
			
             //如果WB阶段的WriteReg与EX阶段的rt相同，
            if(EX_rt==WB_WriteReg) begin  
                
                 //并且 MEM阶段的WriteReg与EX阶段的rt不同
                if(!(MEM_RegWre==1 && MEM_WriteReg!=0 && EX_rt==MEM_WriteReg)) begin
                     ForwardB=2'b01;            //则从WB阶段到EX阶段转发
                end
            end
        end
    end
    
endmodule
```



仿真代码如下：

```verilog
module Forwarding_Unit_tb( );
    //input 
    reg MEM_RegWre,WB_RegWre;
    reg [4:0] EX_rs,EX_rt,MEM_WriteReg,WB_WriteReg;
    //output
    wire [1:0] ForwardA,ForwardB;
    
    //例化
    Forwarding_Unit forwarding_unit(
        .MEM_RegWre(MEM_RegWre),
        .WB_RegWre(WB_RegWre),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .MEM_WriteReg(MEM_WriteReg),
        .WB_WriteReg(WB_WriteReg),
        .ForwardA(ForwardA),
        .ForwardB(ForwardB)
    );
    
    initial begin
    //Test1:EX_rs==MEM_WriteReg
        MEM_RegWre=1;
        WB_RegWre=1;
        EX_rs=5'd3;
        EX_rt=5'd4;
        MEM_WriteReg=5'd3;
        WB_WriteReg=5'd1;
        #50;
        
    //Test2:EX_rt==MEM_WriteReg
        MEM_WriteReg=5'd4;
        #50;
        
    //Test3:EX_rs==WB_WriteReg
        MEM_WriteReg=5'd20;
        WB_WriteReg=5'd3;
        #50;
        
    //Test4:EX_rt==WB_WriteReg
        WB_WriteReg=5'd4;
        #50;
        
    //Test5:EX_rs==MEM_WriteReg==WB_WriteReg
        MEM_WriteReg=5'd3;
        WB_WriteReg=5'd3;
        #50;
        
    //Test6:EX_rt==MEM_WriteReg==WB_WriteReg  
        MEM_WriteReg=5'd4;
        WB_WriteReg=5'd4;
        #50;
        
    //Test7:EX_rs==EX_rt==MEM_WriteReg==WB_WriteReg
    // 此时要从MEM转发到EX的 rs以及rt
        EX_rs=5'd1;
        EX_rt=5'd1;
        MEM_WriteReg=5'd1;
        WB_WriteReg=5'd1;
        #50;
        
    //Test8:都不相等
        EX_rs=5'd1;
        EX_rt=5'd2;
        MEM_WriteReg=5'd10;
        WB_WriteReg=5'd20;
        #50;
        
        $stop;
    end
    
endmodule
```



仿真波形图如下：

![旁路仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E6%97%81%E8%B7%AF%E4%BB%BF%E7%9C%9F.png)



### 18. 取数-使用型数据冒险检测单元 Load-use Detection Unit

```verilog
module Load_use_Detection_Unit(
    //控制信号
    input wire EX_MemRead,
    input wire Reset,//新增Reset,重置信号，1:重置为初始值;0:不重置
    
    output reg PCWre,IF_ID_Wre,ControlSrc,
    
    //数据通路
    input wire [4:0] EX_rt,ID_rs,ID_rt
    );
    
    always @(*) begin
    
        //初始情况
        if(Reset==1) begin
            IF_ID_Wre=1;//把 IF_ID_Wre 置为1，否则第一条指令无法写入 IF_ID_Register，导致所有指令都无法正常执行
            PCWre=1;
        end
        
        else begin
            if(EX_MemRead==1 &&(EX_rt==ID_rs || EX_rt==ID_rt) ) begin
                    PCWre=0;
                    IF_ID_Wre=0;
                    ControlSrc=1;
            end
            
            else begin
                //默认是正常情况，不用阻塞
                PCWre=1;
                IF_ID_Wre=1;
                ControlSrc=0;
            end
        end
    end

endmodule
```



仿真代码如下：

```verilog
module Load_use_Detection_Unit_tb(  );

    //input 
    reg EX_MemRead;
    reg [4:0] EX_rt,ID_rs,ID_rt;
    
    //output 
    wire PCWre,IF_ID_Wre,ControlSrc;
    
    //例化
    Load_use_Detection_Unit load_use_detection_unit(
    .EX_MemRead(EX_MemRead),
    .EX_rt(EX_rt),
    .ID_rs(ID_rs),
    .ID_rt(ID_rt),
    .PCWre(PCWre),
    .IF_ID_Wre(IF_ID_Wre),
    .ControlSrc(ControlSrc)
    );
    
    initial begin
    //Test1:load与下一指令无冲突
        EX_MemRead=1;
        EX_rt=5'd3;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        
    //Test2:load与下一指令有冲突
        EX_MemRead=1;
        EX_rt=5'd4;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        
    //Test3:不是load
        EX_MemRead=0;
        EX_rt=5'd4;
        ID_rs=5'd4;
        ID_rt=5'd5;
        #50;
        $stop;
    end

endmodule
```



仿真波形图如下：

![取数用数检测仿真](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E5%8F%96%E6%95%B0%E7%94%A8%E6%95%B0%E6%A3%80%E6%B5%8B%E4%BB%BF%E7%9C%9F.png)



### 19. CPU顶层模块Pipeline CPU

```verilog
`timescale 1ns / 1ps

module PipelineCPU(
    //控制信号
    input wire Clk,
    input wire Reset,

    //数据通路
    output wire [31:0] PCAddress,//当前PC的地址
    output wire [31:0] nextPCAddress,//下一条PC的地址
    
    output wire [4:0] EX_rs,//rs寄存器编号
    output wire[31:0] TempDataA,//经过旁路转发后的数据，用于展示的数据
    
    output wire [4:0] EX_rt,//rt寄存器编号
    output wire[31:0] TempDataB,//经过旁路转发后的数据，最终写入Data Memory的数据，且是用于展示的数据
    
    output wire [31:0] EX_ALUResult,//ALU计算结果，位于EX阶段
    output wire [31:0] WB_WriteData //写入寄存器的结果，位于WB阶段
    
    //用于debug
    //output wire[31:0] regData31
    
);


/////////////////////////////
//控制信号
//IF阶段
wire [1:0] PCSrc;
wire PCWre_from_Control_Unit,PCWre_from_Load_use_Detection_Unit;
wire JumpPCSrc;

//存在于ID阶段
//用于ID阶段
wire ControlSrc;
wire ExtSel;
//用于EX阶段
wire [1:0] ID_RegDst;
wire ID_ALUSrcB;
wire [3:0] ID_ALUOp;
//用于MEM阶段
wire [1:0] ID_BranchType;
wire ID_MemWre,ID_MemRead;
//用于WB阶段
wire [1:0] ID_DBDataSrc;
wire ID_RegWre;


//存在于EX阶段
//用于EX阶段
wire ALUSrcA;
wire [3:0] ALUCtr;
wire [1:0] EX_RegDst;
wire EX_ALUSrcB;
wire [3:0] EX_ALUOp;
//用于MEM阶段
wire EX_MemWre,EX_MemRead;
wire [1:0] EX_BranchType;
//用于WB阶段
wire [1:0] EX_DBDataSrc;
wire EX_RegWre;


//存在于MEM阶段
wire Branch;//MEM阶段产生
//用于MEM阶段
wire MEM_MemWre,MEM_MemRead;
wire [1:0] MEM_BranchType;
//用于WB阶段
wire [1:0] MEM_DBDataSrc;
wire MEM_RegWre;


//存在于WB阶段
//用于WB阶段
wire [1:0] WB_DBDataSrc;
wire WB_RegWre;


//处理冲突的控制信号
wire [1:0] ForwardA,ForwardB;
wire IF_ID_Wre;
wire IF_ID_Flush;
wire ID_EX_Flush;
wire EX_MEM_Flush;


/////////////////////////////////
//数据通路
//IF阶段
wire [31:0] IF_PCadd4;
wire [31:0] IF_Instruction;

//ID阶段
wire [25:0] ID_targetAddress;
wire [31:0] ID_ReadData1,ID_ReadData2;
wire [31:0] ID_Instruction;//可以无

wire[5:0] Opcode;
wire[4:0] ID_rs,ID_rt,ID_rd,ID_sa;
wire[5:0] ID_func;
wire[15:0] Immediate;

wire [31:0] ID_PCadd4; //PC+4
wire [31:0] ID_Immediate32; //拓展后的32位置立即数

//EX阶段
wire[5:0] EX_func;
wire[31:0] EX_PCadd4;
wire[31:0] EX_ReadData1,EX_ReadData2;
wire[4:0] EX_sa,EX_rd;
//EX_rs,EX_rt作为输出，用于展示
wire[31:0] EX_Immediate32;
wire EX_Zero,EX_Sign;
//EX_ALUResult,放在上面作为输出
wire [31:0] EX_BranchPC;
wire[4:0] EX_WriteReg;
//TempDataA，TempDataB作为输出，用于展示


//MEM阶段
wire [31:0] MEM_PCadd4;
wire [31:0] MEM_BranchPC;
wire MEM_Zero,MEM_Sign;
wire [31:0] MEM_DataIn;
wire [31:0] MEM_ALUResult;
wire [31:0] MEM_DataFromMemory;
wire [4:0] MEM_WriteReg;

//WB阶段
wire [31:0] WB_PCadd4;
wire [4:0] WB_WriteReg;
//WB_WriteData作为输出，用于展示
wire [31:0] WB_DataFromALU;
wire [31:0] WB_DataFromMemory;


/////////////////////////////////////
//元件例化
Program_Counter u_Program_Counter(
    //input
    .Clk                                ( Clk                                ),
    .Reset                              ( Reset                              ),
    .PCWre_from_Control_Unit            ( PCWre_from_Control_Unit            ),
    .PCWre_from_Load_use_Detection_Unit ( PCWre_from_Load_use_Detection_Unit ),
    .PCSrc                              ( PCSrc                              ),
    .JumpPCSrc                          ( JumpPCSrc                          ),
    .ID_targetAddress                   ( ID_targetAddress                   ),
    .ID_PCadd4                          ( ID_PCadd4                          ),
    .ID_ReadData1                       ( ID_ReadData1                       ),
    .MEM_BranchPC                       ( MEM_BranchPC                       ),

    //output
    .IF_PCadd4                          ( IF_PCadd4                          ),
    .currAddress                        ( PCAddress                          ),
    .nextPCAddress                      ( nextPCAddress                      )
);


InstructionMemory u_InstructionMemory(
    //input
    .InstructionAddress ( PCAddress   ),
    //output
    .Instruction        ( IF_Instruction )
);

IF_ID_Register u_IF_ID_Register(
    //input
    .IF_ID_Flush    ( IF_ID_Flush    ),
    .IF_ID_Wre      ( IF_ID_Wre      ),
    .Clk            ( Clk            ),
    .IF_Instruction ( IF_Instruction ),
    .IF_PCadd4      ( IF_PCadd4      ),
    .Branch         ( Branch         ),
    
    //output
    .ID_Instruction ( ID_Instruction ),
    .Opcode         ( Opcode         ),
    .rs             ( ID_rs             ),
    .rt             ( ID_rt             ),
    .rd             ( ID_rd             ),
    .sa             ( ID_sa             ),
    .func           ( ID_func           ),
    .Immediate      ( Immediate      ),
    .targetAddress  ( ID_targetAddress  ),
    .ID_PCadd4      ( ID_PCadd4      )
);

RegisterFile u_RegisterFile(
    //input
    .Clk       ( Clk       ),
    .RegWre    ( WB_RegWre    ),
    .rs        ( ID_rs        ),
    .rt        ( ID_rt        ),
    .WriteReg  ( WB_WriteReg  ),
    .WriteData ( WB_WriteData ),

    //output
    .ReadData1 ( ID_ReadData1 ),
    .ReadData2 ( ID_ReadData2 )
    
    //用于debug
    //.regData31 ( regData31    )
);

SignZeroExtend u_SignZeroExtend(
    //input
    .ExtSel    ( ExtSel    ),
    .Immediate ( Immediate ),

    //output
    .Out       ( ID_Immediate32 )
);

Control_Unit u_Control_Unit(
    //input
    .Branch       ( Branch       ),
    .ControlSrc   ( ControlSrc   ),
    .Opcode       ( Opcode       ),
    .func         ( ID_func      ),

    //output
    .PCWre        ( PCWre_from_Control_Unit ),
    .PCSrc        ( PCSrc        ),
    .JumpPCSrc    ( JumpPCSrc    ),
    .RegDst       ( ID_RegDst       ),
    .ALUSrcB      ( ID_ALUSrcB      ),
    .ExtSel       ( ExtSel       ),
    .ALUOp        ( ID_ALUOp        ),
    .BranchType   ( ID_BranchType   ),
    .MemWre       ( ID_MemWre       ),
    .MemRead      ( ID_MemRead      ),
    .RegWre       ( ID_RegWre       ),
    .DBDataSrc    ( ID_DBDataSrc    ),

    .IF_ID_Flush  ( IF_ID_Flush  ),
    .ID_EX_Flush  ( ID_EX_Flush  ),
    .EX_MEM_Flush ( EX_MEM_Flush )  
);

ID_EX_Register u_ID_EX_Register(
    .Clk            ( Clk            ),
    .ID_EX_Flush    ( ID_EX_Flush    ),
    .ID_ALUSrcB     ( ID_ALUSrcB     ),
    .EX_ALUSrcB     ( EX_ALUSrcB     ),
    .ID_ALUOp       ( ID_ALUOp       ),
    .EX_ALUOp       ( EX_ALUOp       ),
    .ID_RegDst      ( ID_RegDst      ),
    .EX_RegDst      ( EX_RegDst      ),
    .ID_MemWre      ( ID_MemWre      ),
    .EX_MemWre      ( EX_MemWre      ),
    .ID_MemRead     ( ID_MemRead     ),
    .EX_MemRead     ( EX_MemRead     ),
    .ID_BranchType  ( ID_BranchType  ),
    .EX_BranchType  ( EX_BranchType  ),
    .ID_DBDataSrc   ( ID_DBDataSrc   ),
    .EX_DBDataSrc   ( EX_DBDataSrc   ),
    .ID_RegWre      ( ID_RegWre      ),
    .EX_RegWre      ( EX_RegWre      ),
    .ID_PCadd4      ( ID_PCadd4      ),
    .EX_PCadd4      ( EX_PCadd4      ),
    .ID_ReadData1   ( ID_ReadData1   ),
    .ID_ReadData2   ( ID_ReadData2   ),
    .EX_ReadData1   ( EX_ReadData1   ),
    .EX_ReadData2   ( EX_ReadData2   ),
    .ID_sa          ( ID_sa          ),
    .ID_rs          ( ID_rs          ),
    .ID_rt          ( ID_rt          ),
    .ID_rd          ( ID_rd          ),
    .EX_sa          ( EX_sa          ),
    .EX_rs          ( EX_rs          ),
    .EX_rt          ( EX_rt          ),
    .EX_rd          ( EX_rd          ),
    .ID_Immediate32 ( ID_Immediate32 ),
    .EX_Immediate32 ( EX_Immediate32 ),
    .ID_func        ( ID_func        ),
    .EX_func        ( EX_func        )
);

ALU_Control u_ALU_Control(
    //input
    .func    ( EX_func    ),
    .ALUOp   ( EX_ALUOp   ),

    //output
    .ALUSrcA ( ALUSrcA ),
    .ALUCtr  ( ALUCtr  )
);

ALU u_ALU(
    //input
    .ALUCtr        ( ALUCtr        ),
    .ALUSrcA       ( ALUSrcA       ),
    .ALUSrcB       ( EX_ALUSrcB    ),
    .ForwardA      ( ForwardA      ),
    .ForwardB      ( ForwardB      ),
    .ReadData1     ( EX_ReadData1  ),
    .ReadData2     ( EX_ReadData2  ),
    .sa            ( EX_sa         ),
    .ExtData       ( EX_Immediate32),
    .WB_WriteData  ( WB_WriteData  ),
    .MEM_ALUResult ( MEM_ALUResult ),

    //output
    .Zero          ( EX_Zero       ),
    .Sign          ( EX_Sign       ),
    .EX_ALUResult  ( EX_ALUResult  ),
    .TempDataA     ( TempDataA     ),//用于展示的数据
    .TempDataB     ( TempDataB     ) //用于展示的数据
);

Adder_BranchPC u_Adder_BranchPC(
    //input
    .EX_PCadd4      ( EX_PCadd4      ),
    .EX_Immediate32 ( EX_Immediate32 ),

    //output
    .EX_BranchPC    ( EX_BranchPC    )
);

RegDst_Mux u_RegDst_Mux(
    //input
    .RegDst ( EX_RegDst ),
    .rt     ( EX_rt     ),
    .rd     ( EX_rd     ),

    //output
    .WriteReg  ( EX_WriteReg  )
);

Forwarding_Unit u_Forwarding_Unit(
    //input
    .MEM_RegWre   ( MEM_RegWre   ),
    .WB_RegWre    ( WB_RegWre    ),
    .EX_rs        ( EX_rs        ),
    .EX_rt        ( EX_rt        ),
    .MEM_WriteReg ( MEM_WriteReg ),
    .WB_WriteReg  ( WB_WriteReg  ),

    //output
    .ForwardA     ( ForwardA     ),
    .ForwardB     ( ForwardB     )
);

EX_MEM_Register u_EX_MEM_Register(
    .Clk            ( Clk            ),
    .EX_MEM_Flush   ( EX_MEM_Flush   ),
    .EX_MemWre      ( EX_MemWre      ),
    .MEM_MemWre     ( MEM_MemWre     ),
    .EX_MemRead     ( EX_MemRead     ),
    .MEM_MemRead    ( MEM_MemRead    ),
    .EX_BranchType  ( EX_BranchType  ),
    .MEM_BranchType ( MEM_BranchType ),
    .EX_DBDataSrc   ( EX_DBDataSrc   ),
    .MEM_DBDataSrc  ( MEM_DBDataSrc  ),
    .EX_RegWre      ( EX_RegWre      ),
    .MEM_RegWre     ( MEM_RegWre     ),
    .EX_PCadd4      ( EX_PCadd4      ),
    .MEM_PCadd4     ( MEM_PCadd4     ),
    .EX_BranchPC    ( EX_BranchPC    ),
    .MEM_BranchPC   ( MEM_BranchPC   ),
    .EX_Zero        ( EX_Zero        ),
    .EX_Sign        ( EX_Sign        ),
    .MEM_Zero       ( MEM_Zero       ),
    .MEM_Sign       ( MEM_Sign       ),
    .EX_DataIn      ( TempDataB      ),
    .MEM_DataIn     ( MEM_DataIn     ),
    .EX_ALUResult   ( EX_ALUResult   ),
    .MEM_ALUResult  ( MEM_ALUResult  ),
    .EX_WriteReg    ( EX_WriteReg    ),
    .MEM_WriteReg   ( MEM_WriteReg   )
);



Branch_Detection_Unit u_Branch_Detection_Unit(
    //input
    .MEM_BranchType ( MEM_BranchType ),
    .MEM_Zero       ( MEM_Zero       ),
    .MEM_Sign       ( MEM_Sign       ),

    //output
    .Branch         ( Branch         )
);

DataMemory u_DataMemory(
    //input
    .MemWre      ( MEM_MemWre  ),
    .MemRead     ( MEM_MemRead ),
    .Clk         ( Clk         ),
    .DataAddress ( MEM_ALUResult ),
    .DataIn      ( MEM_DataIn  ),

    //output
    .DataOut     ( MEM_DataFromMemory )
);

MEM_WB_Register u_MEM_WB_Register(
    .Clk                ( Clk                ),
    .MEM_DBDataSrc      ( MEM_DBDataSrc      ),
    .WB_DBDataSrc       ( WB_DBDataSrc       ),
    .MEM_RegWre         ( MEM_RegWre         ),
    .WB_RegWre          ( WB_RegWre          ),
    .MEM_PCadd4         ( MEM_PCadd4         ),
    .WB_PCadd4          ( WB_PCadd4          ),
    .MEM_DataFromMemory ( MEM_DataFromMemory ),
    .WB_DataFromMemory  ( WB_DataFromMemory  ),
    .MEM_DataFromALU    ( MEM_ALUResult      ),
    .WB_DataFromALU     ( WB_DataFromALU     ),
    .MEM_WriteReg       ( MEM_WriteReg       ),
    .WB_WriteReg        ( WB_WriteReg        )
);

WB_Mux u_WB_Mux(
    //input
    .DBDataSrc   ( WB_DBDataSrc ),
    .DataFromALU ( WB_DataFromALU  ),
    .DataFromMem ( WB_DataFromMemory  ),
    .WB_PCadd4   ( WB_PCadd4    ),

    //output
    .WriteData   ( WB_WriteData )
);


Load_use_Detection_Unit u_Load_use_Detection_Unit(
    //input
    .EX_MemRead ( EX_MemRead ),
    .EX_rt      ( EX_rt      ),
    .ID_rs      ( ID_rs      ),
    .ID_rt      ( ID_rt      ),
    .Reset      ( Reset      ),

    //output
    .PCWre      ( PCWre_from_Load_use_Detection_Unit      ),
    .IF_ID_Wre  ( IF_ID_Wre  ),
    .ControlSrc ( ControlSrc )
);
endmodule
```



仿真代码如下：

```verilog
module PipelineCPU_tb( );

     //inputs
    reg Clk,Reset;
    
    //output
    wire[31:0] EX_ALUResult;//ALU运算结果
    wire[31:0] PCAddress,nextPCAddress; //PC的地址
    
    //例化
    PipelineCPU PCPU(
    .Clk(Clk),
    .Reset(Reset),
    .EX_ALUResult(EX_ALUResult),
    .PCAddress(PCAddress),
    .nextPCAddress(nextPCAddress) 
    );
    
    initial begin 

        //初始化
        Clk= 1;
        Reset = 1;//刚开始设置PC为0

        #10;
        Clk = 0;
        Reset = 0;

        //产生时钟信号
        forever #10
        begin
            Clk = !Clk;
        end

    $stop;
    end
    
endmodule
```



### CPU仿真波形图及其解释

​        将测试程序段的指令代码放入指令存储器，或者放于一个txt文档中（但是这样烧板时指令不会烧进去），然后利用上述仿真代码，即可得以下CPU仿真波形图。

#### 第1~4周期

![解释1](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A1.png)



#### 第5~8周期

![解释2](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A2.png)



#### 第9~12周期

![解释3](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A3.png)





#### 第13~16周期

<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E6%8C%81%E7%BB%AD2%E4%B8%AA%E5%91%A8%E6%9C%9F%E7%9A%84%E8%A7%A3%E9%87%8A%20.png" alt="持续2个周期的解释 " style="zoom:50%;" />



**下面解释为什么这条指令会持续2个周期：**

1.在230ns~250ns之间是`jal 0x0000050`的ID阶段

- 0x0000001C的指令是`jal 0x0000050`，在ID阶段发现要跳转，因此令`IF_ID_Flush=1`表示要将IF/ID流水线寄存器清零。
- 同时，令`PCSrc=2`
- 同时，计算出`JumpPC=0x0000050`
- 由于`PCSrc=2`，所以令`NextPC=JumpPC`

在240ns时，时钟周期的**上升沿**来临

- `PCSrc=2`保持不变
- 新的PC写入，即写入`0x0000050`。然后PC+4，得到顺序执行的PC。
- IF/ID流水线寄存器检查`IF_ID_Flush`信号的值，发现`IF_ID_Flush=1`，因此把IF/ID流水线寄存器清零。

> [!CAUTION]
>
> 注意：因为跳转指令的JumpPC={(PC+4)[31:28] , Instruction[25:0] , 2’b0}
>
> 因此，为了实现跳转，则要使得`PCSrc=2`保持不变
>
> 那么就要使得**Op码（指令的高6位）**保持不变
>
> 此外，为了能够跳转到目标地址，还要使得**targetaddress（指令的低26位）**保持不变
>
> 也就是说这二者在IF/ID流水线寄存器的值不能被清零
>
> 
>
> 假如二者被清零，由于流水线寄存器的读取是组合逻辑电路，则会在240ns这个上升沿的瞬间把二者清零
>
> 然后，控制器(Control Unit)根据清零后的Op(000000)，译码得到`PCSrc=0`，
>
> 那么就会继续顺序执行下去，无法成功跳转



3.在250ns时，时钟周期的下降沿来临

- 由于此时`IF_ID_Flush=1`，PC保存到IF/ID流水线寄存器也会被清零，无法读取。

4.在260ns时，时钟周期的上升沿来临

- 本来应该是新的PC写入，但是由于这时`PCSrc=2`，所以写入的仍然是`0x0000050`
- 与此同时，是`sw  $2,4($1)`的ID阶段，发现不需要跳转，因此`IF_ID_Flush=0`，`PCSrc=0`

5.在270ns时，时钟周期的下降沿来临

- `sw  $2,4($1)`的ID阶段执行结果保存到ID/EX流水线寄存器

6.然后就继续按正常的情况执行下去



综上，`0x0000050`地址上的`sw  $2,4($1)`指令会被执行2个周期，通过观察仿真波形发现，这样并不会影响后续指令的执行。

而且，我尝试改动了其中部分硬件的设计，均会使后续指令不能正常执行。

因此，我采取了这个折中的办法。



<img src="%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A4.png" alt="解释4" style="zoom:150%;" />



#### 第17~20周期

![解释5](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A5.png)



#### 第21~24周期

![解释6](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A6.png)



#### 第25~28周期

![解释7](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A7.png)



#### 第29~32周期

![解释8](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A8.png)



#### 第33~36周期

![解释9](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A9.png)



#### 第37~40周期

![解释10](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E8%A7%A3%E9%87%8A10.png)

​	从仿真波形上看，我的流水线CPU成功完成了所有指令的执行





### 烧板部分的代码

​	在烧板之前，首先需要加入分频模块、消抖模块、选择模块、转换模块、显示模块以及 Basys3模块（连接所有模块）

#### 1. 分频模块

```verilog
module CLK_slow(
    input CLK_100mhz,//100mhz的原始时钟信号
    
    output reg CLK_slow//输出的分频时钟信号
);

reg [31:0] count = 0;//计数器
reg [31:0] N = 50000;//分频2^19，得到一个周期大约5ms的信号

initial CLK_slow = 0;

always @ (posedge CLK_100mhz) begin
    if(count >= N) begin
        count <= 0;
        CLK_slow <= ~CLK_slow;
    end
    else
        count <= count + 1;

end

endmodule 

```



#### 2. 消抖模块

```verilog
module Keyboard_CLK(
    input Button,
    input BasysCLK,

    output reg CPUCLK
);

    parameter SAMPLE_TIME =	5000;
    
    reg[21:0] count_low;
	reg[21:0] count_high;
	
    reg key_out_reg;
    
    initial
    begin
        CPUCLK=0;
    end


	always@(posedge BasysCLK)
    begin
		count_low <= Button ? 0 : count_low + 1;
		count_high <= Button ? count_high + 1 : 0;
		if(count_high == SAMPLE_TIME)
			key_out_reg <= 1;
		else if(count_low == SAMPLE_TIME)
			key_out_reg <= 0;
	end

    always@(*)
    begin
        CPUCLK =! key_out_reg;
    end

endmodule

```



#### 3. 选择模块

```verilog
module Select(
    input [15:0] In1, In2, In3, In4,
    input [1:0] SelectCode,

    output reg [15:0] DataOut
);

always @ (*) begin
    case (SelectCode)
        2'b00 : DataOut = In1;//输出PC
        2'b01 : DataOut = In2;//输出rs
        2'b10 : DataOut = In3;//输出rt
        2'b11 : DataOut = In4;//输出ALUResult,DB
    endcase
end

endmodule
```



#### 4. 转换模块

```verilog
module Transfer(
    input CLK,
    input [15:0] In,

    output reg [3:0] Out,//即为Display_7SegLED的输入数据
    output reg [3:0] Bit//位模式
);


integer i;
initial begin 
    i = 0;
end

always @ (negedge CLK) begin
    case(i)
        0 : begin
            Out = In[15:12];
            Bit = 4'b0111;
        end
        1 : begin
            Out = In[11:8];
            Bit = 4'b1011;
        end
        2 : begin
            Out = In[7:4];
            Bit = 4'b1101;
        end
        3 : begin
            Out = In[3:0];
            Bit = 4'b1110;
        end
    endcase
    i = (i == 3) ? 0 : i + 1;
end

endmodule
```



#### 5. 显示模块

```verilog
//显示模块
//共阳极：'0'-亮灯，'1'-熄灯 
//共阴极：'1'-亮灯，'0'-熄灯 
//Basys3板是共阳极

module Display_7SegLED(
    input [3:0] display_data,
    output reg [7:0] dispcode
);

always @ (display_data) begin
    case(display_data)
        4'b0000 : dispcode = 8'b1100_0000; //0;'0'-亮灯，'1'-熄灯 
        4'b0001 : dispcode = 8'b1111_1001; //1
        4'b0010 : dispcode = 8'b1010_0100; //2
        4'b0011 : dispcode = 8'b1011_0000; //3
        4'b0100 : dispcode = 8'b1001_1001; //4 
        4'b0101 : dispcode = 8'b1001_0010; //5 
        4'b0110 : dispcode = 8'b1000_0010; //6 
        4'b0111 : dispcode = 8'b1101_1000; //7 
        4'b1000 : dispcode = 8'b1000_0000; //8 
        4'b1001 : dispcode = 8'b1001_0000; //9 
        4'b1010 : dispcode = 8'b1000_1000; //A 
        4'b1011 : dispcode = 8'b1000_0011; //b 
        4'b1100 : dispcode = 8'b1100_0110; //C 
        4'b1101 : dispcode = 8'b1010_0001; //d 
        4'b1110 : dispcode = 8'b1000_0110; //E 
        4'b1111 : dispcode = 8'b1000_1110; //F 
        default : dispcode = 8'b0000_0000; //不亮
    endcase
end

endmodule
```



#### 6. Basys3模块

```verilog
`timescale 1ns / 1ps

module PipelineCPU_in_Basys3(

    input CLKButton,
    input BasysCLK, //Basys自身的时钟周期
    input RST_Button, //外部复位信号
    input [1:0] SW_in,

    output [7:0] SegOut,
    output [3:0] Bits
);

//CPU
wire [4:0] RsAddr, RtAddr;
wire [31:0] RsData, RtData;
wire [31:0] ALUResult;
wire [31:0] DBData;
wire [31:0] curPCAddress, nextPCAddress;

wire CPUCLK;
wire reset;//内部复位信号

PipelineCPU CPU(
    //控制信号
    .Clk(CPUCLK),
    .Reset(reset),
    
    //数据通路
    .EX_rs(RsAddr),
    .EX_rt(RtAddr),
    .TempDataA(RsData),
    .TempDataB(RtData),
    
    .PCAddress(curPCAddress),
    .nextPCAddress(nextPCAddress),
    .EX_ALUResult(ALUResult),
    .WB_WriteData(DBData)

);

//CLK_slow
wire Div_CLK;
CLK_slow clk_slow(
    .CLK_100mhz(BasysCLK),
    .CLK_slow(Div_CLK)
);

//Display_7Seg
wire [3:0] SegIn;

Display_7SegLED display_led(
    .display_data(SegIn),
    .dispcode(SegOut)
);

//Display_select
wire [15:0] display_data;
Select select(
    .In1({curPCAddress[7:0], nextPCAddress[7:0]}),
    .In2({3'b000, RsAddr[4:0], RsData[7:0]}),
    .In3({3'b000, RtAddr[4:0], RtData[7:0]}),
    .In4({ALUResult[7:0], DBData[7:0]}),

    .SelectCode(SW_in),
    .DataOut(display_data)
);

//Display_transfer
Transfer tansfer(
    .CLK(Div_CLK),
    .In(display_data),

    .Out(SegIn),
    .Bit(Bits)
);

//keyboard
Keyboard_CLK keyboard(
    .Button(CLKButton),
    .BasysCLK(BasysCLK),
    .CPUCLK(CPUCLK)
);

IBUFG RST_Button_IBUF (
      .O(reset), // 1-bit output: Clock output
      .I(RST_Button)  // 1-bit input: Clock input
   );
endmodule
```



#### 7. 引脚分配

```verilog
set_property PACKAGE_PIN W5 [get_ports {BasysCLK}]
set_property PACKAGE_PIN R2 [get_ports SW_in[1]]
set_property PACKAGE_PIN T1 [get_ports SW_in[0]]
set_property PACKAGE_PIN V17 [get_ports RST_Button]
set_property PACKAGE_PIN T17 [get_ports CLKButton]

# 设置 I/O 标准
set_property IOSTANDARD LVCMOS33 [get_ports {BasysCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports SW_in[1]]
set_property IOSTANDARD LVCMOS33 [get_ports SW_in[0]]
set_property IOSTANDARD LVCMOS33 [get_ports RST_Button]
set_property IOSTANDARD LVCMOS33 [get_ports CLKButton]

# 引脚分配
set_property PACKAGE_PIN W4 [get_ports {Bits[3]}]
set_property PACKAGE_PIN V4 [get_ports {Bits[2]}]
set_property PACKAGE_PIN U4 [get_ports {Bits[1]}]
set_property PACKAGE_PIN U2 [get_ports {Bits[0]}]

# 七段数码管引脚分配
set_property PACKAGE_PIN V7 [get_ports {SegOut[7]}]
set_property PACKAGE_PIN W7 [get_ports {SegOut[0]}]
set_property PACKAGE_PIN W6 [get_ports {SegOut[1]}]
set_property PACKAGE_PIN U8 [get_ports {SegOut[2]}]
set_property PACKAGE_PIN V8 [get_ports {SegOut[3]}]
set_property PACKAGE_PIN U5 [get_ports {SegOut[4]}]
set_property PACKAGE_PIN V5 [get_ports {SegOut[5]}]
set_property PACKAGE_PIN U7 [get_ports {SegOut[6]}]

# 设置 I/O 标准（确保只设置一次）
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Bits[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SegOut[0]}]
```



### Basys3板上的结果

​	当把代码烧到板子上时，板子上的结果却不符合预期。

​	首先是报出“严重警告”：某两个元器件之间的布线不合理，需要添加缓冲器。针对此问题，我根据网上介绍以及自己的探索，利用以下代码中缓冲器解决了这个严重警告。

```verilog
IBUFG RST_Button_IBUF (
      .O(reset), // 1-bit output: Clock output
      .I(RST_Button)  // 1-bit input: Clock input
   );
```

​	在解决这个问题后，板子上能够多显示几条指令，但是仍不符合预期。具体现象是：

- **无法实现分支指令**
- 在执行到第11周期时，再按下一条指令的按钮，板子上的结果保持不变，**不会切换到下一条指令**。

​	针对这个问题，我尝试了几种方法：

- 一是，尝试改变代码中的时序逻辑，但是都会使得仿真波形不正确
- 二是，尝试把一些调试信息利用七段数码管显示在板子上，但是当我更换成显示调试信息时，板子上所能显示的周期数会改变（比如：当我在板子上显示$31寄存器的值时，板子上就会多显示几个周期）。

对于这个问题，我非常疑惑，而且感到无能为力，无从下手。我询问了老师、助教、同学，没有得到很有效的方法。

因此，我最终没有成功烧板，板子上的结果只能显示11个周期的结果。

> [!CAUTION]
>
> 注意：
>
> 虽然我的板子上能显示11个周期的结果。
>
> 但是第10个周期以及之后都是错误的
>
> 第10个周期应该是实现了分支，PC应该是14（16进制）



​	经过我的不断调试，最终也无法解决。但我猜测可能的原因是：

- 我的时序逻辑设计有点不合理，比如：一个时钟周期的上升沿和下降沿我都用来做不同的事情，这可能导致时序的混乱。
- 虽然我的仿真波形是正确的，但这只是在理论上的正确，而在实际的物理器件中可能会由于布线问题等原因而导致无法实现想要的效果。



#### 第1周期

![烧板图周期1](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F1.jpg)



#### 第2周期

![烧板图周期2](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F2.jpg)



#### 第3周期

![烧板图周期3](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F3.jpg)



#### 第4周期

![烧板图周期4](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F4.jpg)



#### 第5周期

![烧板图周期5](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F5.jpg)



#### 第6周期

![烧板图周期6](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F6.jpg)



#### 第7周期

![烧板图周期7](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F7.jpg)



#### 第8周期

![烧板图周期8](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F8.jpg)



#### 第9周期

![烧板图周期9](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F9.jpg)



#### 第10周期

![烧板图周期10](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F10.jpg)



#### 第11周期

![烧板图周期11](%E6%B5%81%E6%B0%B4%E7%BA%BFCPU.assets/%E7%83%A7%E6%9D%BF%E5%9B%BE%E5%91%A8%E6%9C%9F11.jpg)



## 六.实验心得

​        在本次实验中，我利用Verilog语言设计了一个流水线CPU以及一个编译器。

​	该流水线CPU能够**从硬件上完全处理三种类型的流水线冲突**，而不需要利用软件处理。相应地，该编译器只能实现简单的从汇编语言转换到二进制语言的功能。

​	相比于不是完全使用硬件处理三种冲突的流水线CPU，我在设计该流水线CPU的时候难度稍微大一些。

​	主要难度在于：处理控制冲突时，需要将IF/ID、ID/EX、EX/MEM流水线寄存器清零;处理跳转指令时，需要将IF/ID流水线寄存器清零。二者在设计上需要注意整体的时序逻辑。如果时序逻辑不当，即使每个模块的仿真波形都正确，全部模块综合起来的仿真波形也有可能不成功。

​	经过多次尝试，对涉及时序逻辑部分的代码进行了多次修改，最终得到了目前这一版代码。这一版代码能够完成所给的测试代码，得到正确的仿真波形。

​	但是，在烧板时却遇到了一些奇怪的问题（具体问题见前文“Basys3板上的结果”）。经过我的不断调试，最终也无法解决。但我猜测可能的原因是：

- 我的时序逻辑设计有点不合理，比如：一个时钟周期的上升沿和下降沿我都用来做不同的事情，这可能导致时序的混乱。
- 虽然我的仿真波形是正确的，但这只是在理论上的正确，而在实际的物理器件中可能会由于布线问题等原因而导致无法实现想要的效果。

​	不过，在调试的过程中，我学到了许多宝贵的经验：

- 我对时序逻辑和组合逻辑二者的区别有了更深入的理解；
- 我也认识到了仿真波形正确只是理论上的正确，而烧录到板子上这种实际物理器件上仍然有可能不成功；
- 在设计时尽量不要既使用时钟周期的上升沿，又使用其下降沿，否则可能会引起时序混乱。

​	此外，我也明白了一个道理，“纸上得来终觉浅，得知此事要躬行”，"实践是检验真理的唯一标准"，我们在课堂上学习到的知识，还要应用于实践，在实践当中不断检查自己的知识是否完善，从而不断学习，不断完善自己的知识储备。同时，在实践过程中，也能提升我们的动手能力，处理复杂事情的能力，发现问题、思考问题、解决问题的能力。

​	总而言之，这次实验不仅加深了我对流水线CPU的理解，也增强了我使用Verilog语言进行开发设计并烧板的能力，同时也提高了我对编译器原理的理解。







