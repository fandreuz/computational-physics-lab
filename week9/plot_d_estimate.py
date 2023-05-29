import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

a = 2.0e-8
dt = 1.0e-9

data = np.loadtxt("out2.txt")
D_th = a**2 / (4 * dt)

n_samples = list(range(1, len(data) + 1))
data = [data[:i].mean() for i in n_samples]

plt.figure(figsize=(10, 6))

plt.plot(n_samples, data, "-o")
plt.hlines(D_th, 1, len(data), colors="r", linestyles="dashed", label="Theoretical")

plt.xlabel("N. of samples")
plt.xticks([1] + n_samples[4::5], [1] + n_samples[4::5])

plt.legend()
plt.grid()

plt.title(r"$D$")

plt.show()
