import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

data = np.loadtxt("es4.dat")
T = np.round(data[:, 0], 1)

plt.figure(figsize=(20, 20))

plt.subplot(2, 2, 1)
plt.plot(T, data[:, 1], "-o", label="$\langle E \\rangle / N$")
plt.axvline(x=2.26, c="grey", label="Theoretical $T_C$")
plt.grid()
plt.legend()

plt.subplot(2, 2, 2)
plt.plot(T, data[:, 2], "-o", label="$\langle M \\rangle / N$")
plt.axvline(x=2.26, c="grey", label="Theoretical $T_C$")
plt.grid()
plt.legend()

plt.subplot(2, 2, 3)
plt.plot(T, data[:, 3], "-o", label="$c$")
h = T[1] - T[0]
plt.plot(
    T[1:],
    (data[1:, 1] - data[:-1, 1]) / h,
    "-o",
    label=r"$\partial \langle E \rangle / \partial T$",
)
plt.axvline(x=2.26, c="grey", label="Theoretical $T_C$")
plt.grid()
plt.legend()
plt.xlabel("T")

plt.subplot(2, 2, 4)
plt.plot(T, data[:, 4], "-o", label="$\chi$")
plt.axvline(x=2.26, c="grey", label="Theoretical $T_C$")
plt.grid()
plt.legend()
plt.xlabel("T")

plt.show()
