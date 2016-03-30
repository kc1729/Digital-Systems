import random
output = "";
for i in range(0, 256):
	for j in range(0, 256):

		if (j == 0):
			m = 0;
			n = 0;
		else:
			m = i / j;
			n = i % j;
		output += '{0:08b}'.format(i) + " ";
		output += '{0:08b}'.format(j) + " ";
		output += '{0:08b}'.format(m) + " ";
		output += '{0:08b}'.format(n) + "\n";
f = open('TRACEFILE.txt', 'w')
f.write(output)
f.close()