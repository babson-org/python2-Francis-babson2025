
fname = 'Sarah'
lname ='Pinkerton'
grade = 'Freshman'
redidence = 'Woodland House' 
age = 18
gpa = 3.7
email = 'spinkerton@babson.edu'
international = False

'''

student = []


student.append(fname) 
student.append(lname)
student.append(grade)
student.append(redidence)  
student.append(age)
student.append(gpa)
student.append(email)
student.append(international)

#print(student[3])

primes =[2,3,5,7,11,13,19,23]

student_dict = {}

student_dict['fname'] = 'Sarah'
student_dict['lname'] ='Pinkerton'
student_dict['grade'] = 'Freshman'
student_dict['redidence'] = 'Woodland House' 
student_dict['age'] = 18
student_dict['gpa'] = 3.7
student_dict['email'] = 'spinkerton@babson.edu'
student_dict['international'] = False


#print(student_dict['grade'])

student_dictb ={'fname':'Sarah', 'lname': 'Pinkerton', 'grade': 3.7}

#print(student_dictb['fnxame'])

name = student_dictb.get('fnxme', 'NO FIRST NAME')
#print(name)

students = []

student = {'fname':'Ja-riel', 'lname': 'Bailey', 'email':'jbailey@babson.edu'}

students.append(student)

#print(students)

for idx in range(3):
    
    fname = input('first name: ')
    lname = input('last name: ')
    email = input('email address: ')

    student = {'fname': fname, 'lname': lname, 'email': email}

    students.append(student)


#print(students)



clients = []
client = {'fname': None, 'lname': None, 'transactions' : []}


transaction = {'date': None, 'symbol': None, 'type': None, 'trn_price': None, 'shares': None}

client['transactions'].append(transaction)

clients.append(client)

clients[0]['transactions'].append(transaction)


for client in clients:
    print(client)
'''
def rev(s):
    for c in s:
        print(c)
        return str(c) + rev(s[1:])
    
print(rev("abc"))