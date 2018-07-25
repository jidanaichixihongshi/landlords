cd ../ebin
del *.beam
cd ../src
erl -make
move *.beam ../ebin
cd lib/
erl -make
move *.beam ../../ebin
cd ../../script

pause