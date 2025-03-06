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

# # 写入excel
# df_complete.to_excel("流水线测试指令.xlsx")
#
# # 写入txt
# f_Instructions=open('Pipeline_CPU_Instructions.txt','w')
# for i in range(0,rows):
#     # 注意要换行
#     f_Instructions.write(df_complete.loc[i, '2进制数代码'][0:8]+"\n")
#     f_Instructions.write(df_complete.loc[i, '2进制数代码'][8:16]+"\n")
#     f_Instructions.write(df_complete.loc[i, '2进制数代码'][16:24]+"\n")
#     f_Instructions.write(df_complete.loc[i, '2进制数代码'][24:]+"\n")
# f_Instructions.close()