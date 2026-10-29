import random

random.seed(520)

with open("sim/input_data.txt", "w") as file:
	for i in range(32):
		data = random.randint(0, 65535)
		file.write(f"{data:04X}\n")

print("FIFO input data generated")
