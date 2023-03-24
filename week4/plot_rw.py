import numpy as np
import matplotlib.pyplot as plt

positions = np.loadtxt("position.dat")
avgs = np.loadtxt("avg.dat")
info = np.loadtxt("info.dat")

p_right = info[0]
p_left = info[1]
assert abs(p_right + p_left - 1) < 1.e-6
l = info[2]

N = np.arange(1, positions.shape[1] + 1)
x_avg_theory = N * (p_right - p_left) * l
mean_sq_displ_theory = 4 * p_left * p_right * N * l**2

plt.figure(figsize=(20,6))

plt.subplot(1,3,1)
plt.title(r"$\langle x_N \rangle$")

plt.plot(N, positions[0], label="0")
plt.plot(N, positions[1], label='1')
plt.plot(N, positions[2], label="2")
plt.plot(N, avgs[0], label="Avg")
plt.plot(N, x_avg_theory, label="Theory")

plt.subplot(1,3,2)
plt.title(r"$\langle x^2_N \rangle$")

plt.plot(N, positions[0]**2, label="0")
plt.plot(N, positions[1]**2, label='1')
plt.plot(N, positions[2]**2, label="2")
plt.plot(N, avgs[1], label="Avg")
plt.plot(N, x_avg_theory**2 + mean_sq_displ_theory, label="Theory")

plt.grid()
plt.legend()

plt.subplot(1,3,3)
plt.title(r"$\langle (\Delta x_N)^2 \rangle$")

plt.plot(N, avgs[1] - avgs[0]**2, label="Avg")
plt.plot(N, mean_sq_displ_theory, label="Theory")

plt.grid()
plt.legend()

plt.show()