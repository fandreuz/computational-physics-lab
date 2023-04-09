import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

positions = np.loadtxt("position.dat")
avgs = np.loadtxt("avg.dat")
# avgs10 = np.loadtxt("avg10.dat")
info = np.loadtxt("info.dat")

p_right = info[0]
p_left = info[1]
assert abs(p_right + p_left - 1) < 1.0e-6
l = info[2]

N = np.arange(1, positions.shape[1] + 1)
x_avg_theory = N * (p_right - p_left) * l
mean_sq_displ_theory = 4 * p_left * p_right * N * l**2

plt.figure(figsize=(20, 6))

plt.subplot(1, 3, 1)
plt.title(r"$\langle x_N \rangle$")
# plt.title(r"$x_N$")

# plt.plot(N, positions[0], label="0")
# plt.plot(N, positions[1], label='1')
# plt.plot(N, positions[2], label="2")
# plt.plot(N, positions[3], label="3")
# plt.plot(N, avgs10[0], label="10")
plt.plot(N, avgs[0], label="100")
plt.plot(N, x_avg_theory, "-.", label="Theory")

plt.grid()
plt.legend()

plt.subplot(1, 3, 2)
plt.title(r"$\langle x^2_N \rangle$")
# plt.title(r"$x^2_N$")

# plt.plot(N, positions[0]**2, label="0")
# plt.plot(N, positions[1]**2, label='1')
# plt.plot(N, positions[2]**2, label="2")
# plt.plot(N, positions[3]**2, label="3")
# plt.plot(N, avgs10[1], label="10")
plt.plot(N, avgs[1], label="100")
plt.plot(N, x_avg_theory**2 + mean_sq_displ_theory, "-.", label="Theory")

plt.grid()
plt.legend()

plt.subplot(1, 3, 3)
plt.title(r"$\langle (\Delta x_N)^2 \rangle$")

# plt.plot(N, avgs10[2], label="10")
plt.plot(N, avgs[2], label="100")
plt.plot(N, mean_sq_displ_theory, "-.", label="Theory")

plt.grid()
plt.legend()

plt.show()
