import numpy as np
import matplotlib.pyplot as plt
import matplotlib
font = {'size' : 15}
matplotlib.rc('font', **font)

info = np.loadtxt("info.dat")
p_right = info[0]
p_left = info[1]
l = info[2]

Ns = [8, 32, 128]

i = [50 * k for k in range(1,41)]
measured = np.array([[np.loadtxt(f"avg{ii}_{N}.dat")[2,-1] for ii in i] for N in Ns])

mean_sq_displ_theory = np.array([4 * p_left * p_right * N * l**2 for N in Ns])
print(mean_sq_displ_theory)

err = np.abs(measured / mean_sq_displ_theory[:,None] - 1)

plt.figure(figsize=(20,6))
plt.title(r"$\langle (\Delta x_N)^2 \rangle$ accuracy")

for N, erri in zip(Ns, err):
    plt.plot(i, erri, '-o', label=f"Measured -- N={N}")
plt.hlines(0.05, xmin=i[0], xmax=i[-1], colors='r', label="5% accuracy")

plt.grid()
plt.legend()

plt.show()