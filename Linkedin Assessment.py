import math
def massmod():
    
    n=int(input("Enter the mass of modules : "))
    list=[]
    list1=[]
    sum= 0
    for i in range(0,n):
            ele = int(input())
            ele1 = math.trunc((ele/3)) - 2
            sum = sum + ele1
            list.append(ele)
            list1.append(ele1)
    return list, sum, list1

output = massmod()

print("Mass of module :"+ str(output[0]))
print("Indiviual module fuel requirement:"+ str(output[2]))
print("Total fuel requirement:"+ str(output[1]))