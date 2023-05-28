import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

a = 2.0e-8
L = 20
skip = 5

data = np.loadtxt("fort.1")[:, :2]

plt.figure(figsize=(10, 6))

plt.xlabel("t")
plt.title(r"$\langle R^2(t) \rangle$")

plt.plot(data[:, 0], data[:, 1], "-", label=r"Simulation")
plt.plot(data[:, 0], a * a * np.arange(1, len(data) + 1) * skip, "-", label="$a^2 N$")
plt.hlines(
    (L * a / 2) ** 2,
    data[:, 0].min(),
    data[:, 0].max(),
    colors="r",
    linestyles="--",
    label="Th. limit",
)

plt.legend()
plt.grid()
plt.show()
