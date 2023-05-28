import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

data = np.loadtxt("fort.1")[:, [0, 3, 4]]

plt.figure(figsize=(10, 6))

plt.title("Diffusion coefficient")

plt.xlabel("t")

plt.plot(data[:, 0], data[:, 1], label=r"$D(t)$")
plt.hlines(
    data[-1, -1],
    data[:, 0].min(),
    data[:, 0].max(),
    colors="g",
    label=r"$\langle D\rangle_T$",
)

plt.legend()
plt.grid()
plt.show()
