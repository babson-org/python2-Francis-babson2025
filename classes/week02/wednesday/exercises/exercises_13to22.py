
from classes.week00.second_class.utils import clear_screen
'''
#13 - Conditional Logic
Ask the user for a number and print whether it is positive, negative, or zero.
'''
# enter code here
num = float(input("Enter a number: "))
if num > 0:
    print("The number is positive.")
elif num < 0:
    print("The number is negative.")
else:
    print("The number is zero.")


pause=input('pause')
clear_screen()

'''
#14 - Even/Odd Check
Ask the user for a number and print if it is even or odd.
'''
# enter code here
num = float(input("Enter a number"))
if num % 2 == 0:
    print("The number is even")
else:
    print("The number is odd")


pause=input('pause')
clear_screen()

'''
#15 - Boolean Operators
Ask the user for two numbers and check if both are positive, either is positive, or none is positive.
'''
# enter code here
num1 = float(input("Enter a number: "))
num2 = float(input("Enter a number: "))
if num1 and num2 > 0:
    print("The two numbers are positive.")
elif num1 and num2 < 0:
    print("The two numbers are negative.")
else:
    print("One of the two numbers are positive. ")


pause=input('pause')
clear_screen()

'''
#16 - For Loop
Print all numbers from 1 to 20, skipping multiples of 3.
'''
# enter code here
for num in range(1, 21):
    if num % 3 == 0:
        continue  # Skip multiples of 3
    print(num)


pause=input('pause')
clear_screen()

'''
#17 - While Loop
Ask the user to guess a secret number (hardcoded) until they get it right.
'''
# enter code here
secret_number = 48
while True:
    guess = int(input("Guess the secret number: "))
    if guess == secret_number:
        print("Congratulations! You guessed it right.")
        break
    else:
        print("Wrong guess. Try again!")

pause=input('pause')
clear_screen()

'''
#18 - Break / Continue
Print numbers 1-10 but stop printing when you reach 7 and skip 3.
'''
# enter code here
for num in range(1, 11):
    if num == 3:
        continue  # Skip 3
    if num == 7:
        break     # Stop at 7
    print(num)


pause=input('pause')
clear_screen()

'''
#19 - Function Definition
Write a function square(x) that returns the square of a number and test it.
'''
# enter code here
def square(x):
    return x * x
print("square(2) =", square(2))     # Output: 4

pause=input('pause')
clear_screen()

'''
#20 - Function with Mutable Argument
Write a function add_item(lst, item) that appends item to lst and observe the effect on the original list.
'''
# enter code here
def add_item(lst, item):
    lst.append(item)
my_list = [1, 2, 3]
add_item(my_list, 4)
print("Updated list:", my_list)


pause=input('pause')
clear_screen()

'''
#21 - Comments / Documentation
Write a function greet(name) with single-line and multi-line comments explaining each step.
'''
# enter code here
def greet(name):
    print("Hello, " + name + "! Welcome aboard.")


pause=input('pause')
clear_screen()

'''
#22 - Combining Tools
Ask the user to enter 5 names. Store them in a list, capitalize each name, sort the list, and print it.
'''
# enter code here
names = []
for i in range(5):
    name = input(f"Enter name {i+1}: ")
    names.append(name)

capitalized_names = [name.capitalize() for name in names]

sorted_names = sorted(capitalized_names)

print("Sorted and capitalized names:")
for name in sorted_names:
    print(name)


pause=input('pause')
clear_screen()

