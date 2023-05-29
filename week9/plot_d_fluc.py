import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

a = 2.0e-8
dt = 1.0e-9
equilibration = 400

data = np.loadtxt("fort.1")[:, [0, 3]]

plt.figure(figsize=(10, 6))

avg = data[equilibration:, 1].mean()

plt.plot(data[:, 0], (data[:, 1] - avg) / avg, label=r"$D(t)$")
plt.hlines(
    0,
    data[:, 0].min(),
    data[:, 0].max(),
    colors="r",
    linestyles="dashed",
    label=r"$\langle D \rangle_T(t>{:.1E})$".format(equilibration * dt),
)

plt.title("Relative fluctuations")
plt.xlabel("t")

plt.grid()
plt.legend()

plt.show()
