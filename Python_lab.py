#create a class with two methods, one to set value and other to print value
class Python_lab:

    def set_list(self, dataInput):
        self.inputData = dataInput;
        
    def print_objects(self):
        print(self.inputData)
      
      
    # Create 5 objects from that class with different data and add those object to the list
 
obj1 = Python_lab(); 
obj2 = Python_lab();
obj3 = Python_lab(); 
obj4 = Python_lab(); 
obj5 = Python_lab(); 


obj1.set_list("Monday");
obj2.set_list("Tuesday")
obj3.set_list("Wednesday")
obj4.set_list("Thursday")
obj5.set_list("Friday")
    
new_list = [obj1, obj2, obj3, obj4, obj5]


 # Iterate list using the list and print stored value
    
for value in new_list:
    value.print_objects()
    