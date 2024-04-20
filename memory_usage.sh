# !/bin/bash
  # Accesing the file and printing all the values
# Going to the process directory

cd /proc/$1;
handler=$(cat statm);
i=0; # For storing the number of iteration
echo "Memory Information for PID: $1" ;
for task in $handler
do
	if(( $i==0 )); then 
	    echo "Total program Size : $task pages";
	elif(( $i==1 )); then
	    echo "Resident Set Size : $task pages";
	elif(( $i==2 )); then
	    echo "Shared Pages : $task pages";
	elif(( $i==3 )); then
	    echo "Text ( Code ) : $task pages";
	elif(( $i==4 )); then
	    echo "Library ( Unused in Linux 2.6 ) : $task pages";
	elif(( $i==5 )); then
	    echo "Data + Stack : $task pages";
	elif(( $i==6 )); then
	    echo "Dirty Pages ( Unused in Linux 2.6 ) : $task pages";
	fi
	i=$((i+1));
done


