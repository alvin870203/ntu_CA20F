all:
	yosys -l cpu.yslog -q cpu.ys

test:
	iverilog -D T6 -f cpu.f
	vvp ./a.out

time:
	cat cpu.yslog | grep WireLoad 

clean:
	rm -f cpu.yslog cpu.edif cpu.constr

