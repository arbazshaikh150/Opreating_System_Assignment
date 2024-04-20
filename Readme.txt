
Hack : (For Process to be alive , we are using sleep(200) or in some question we are using scanf and not providing any input)


////// Question 1:
	proc/[PID]/ Statm --> Contains all the information related to the memory (using by the process with the above PID).
	STEPS: (bash memory_usage.sh "PID")
	    1) For getting all the contents of the statm file, using the descriptor(Handler) which holds the value (cat statm).
	    2) Now looping through Handler and printing the desired output on console.
	    

////// Question 2:
	Here we have to show the memory allocation using the output of the statm file of running process
	Step:
	1) In first turn we are allocating small memory and get the memory usage using the q1 shell script file (memory_usage.sh) (GOt PID using ps -a command).
	2)In Second turn we are allocating Large memory and get the memory usage using the q1 shell script file (memory_usage.sh) (GOt PID using ps -a command).
	
	
/////// Question 3 : 
	Here we are generating the C file using the shell script , 
	Step:
	1) First we are taking the input(Small) and printing the printf statement multiple times inside our C program (code size)
	2) For checking the memory usage (We put it on sleep ) and on second terminal we used (ps -a command) for getting the process id and then used the q1 script on that PID.
	3) Similiarly we are using for the large input and doing the similar thing and comparing the result.
	
	
//////// Question 4:
	/proc/[pid]/map --> Hold the virtual address of the process i.e of Code , Stack and heap section
	/proc/[pid]/pagemap --> Holds the mapping of virtual address to the physical address (Tooks long time to open)
	Steps:
	1) Generating the script using sanity check.
	2) It has a function which convert the virtual page number to physical page number --> By calculating the physical frame number (using the pagemap file descriptor) and offset and doing the required shift.
	3) After that using the awk command we are taking the start and the end virtual address and converting it to physical address using the function.
	
	
/////// Question 5:
	Steps:
	1) First checking whether the given agruments (PID , Virtual address) are correct (syntactically) or not.
	2) Then checking whether there exist a process with the given PID.
	3) After that taking the offset and virtual page number (from the input) and also getting the page table entry using the pagemap.
	4) With the help of page table entry, we got Physical frame number and adding offset to it gives us the actual physical address.
	
