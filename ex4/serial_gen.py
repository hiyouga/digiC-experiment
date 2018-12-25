# 用python生成第四次数电实验的代码,采用奇校验
data = list(map(int, input("输入要转化的16bit的二进制,空格分隔\n").split()))

if len(data) != 16:
    print("长度不满足！")
    exit()

j = 0
cnt = 0
output = []

for i in range(15):
    print("ROM[{:d}] <= 1'b0;".format(j))
    output.append("0\n")
    j+=1
for i in range(15):
    print("ROM[{:d}] <= 1'b1;".format(j))
    output.append("1\n")
    j+=1;

for d in data:
    if(d == 0):
        for i in range(5):
            print("ROM[{:d}] <= 1'b0;".format(j))
            output.append("0\n")
            j+=1
        for i in range(6):
            print("ROM[{:d}] <= 1'b1;".format(j))
            output.append("1\n")
            j+=1
    else:
        cnt += 1
        for i in range(5):
            print("ROM[{:d}] <= 1'b1;".format(j))
            output.append("1\n")
            j+=1
        for i in range(6):
            print("ROM[{:d}] <= 1'b0;".format(j))
            output.append("0\n")
            j+=1

if cnt % 2 == 0:
#if cnt % 2 != 0: # ERROR
    for i in range(5):
        print("ROM[{:d}] <= 1'b1;".format(j))
        output.append("1\n")
        j+=1
    for i in range(5):
        print("ROM[{:d}] <= 1'b0;".format(j))
        output.append("0\n")
        j+=1
    while j < 220:
        print("ROM[{:d}] <= 1'b0;".format(j))
        output.append("0\n")
        j+=1
else:
    for i in range(5):
        print("ROM[{:d}] <= 1'b0;".format(j))
        output.append("0\n")
        j+=1
    for i in range(5):
        print("ROM[{:d}] <= 1'b1;".format(j))
        output.append("1\n")
        j+=1
    while j < 220:
        print("ROM[{:d}] <= 1'b1;".format(j))
        output.append("1\n")
        j+=1

with open('rom.patt', 'w') as f:
    f.writelines(output)
    f.close()
