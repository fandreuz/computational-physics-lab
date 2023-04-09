import numpy as np
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rc("font", size=20)

data = np.loadtxt("error.txt")
data2 = np.loadtxt("error2.txt")

plt.figure(figsize=(20, 6))

plt.subplot(1, 2, 1)
plt.loglog(data[:, 0], data[:, 3], "-o", label=r"$\Delta_n$")
plt.loglog(data[:, 0], data[:, 5], "-o", label=r"$\sigma_n$")
plt.loglog(data[:, 0], 1 / np.sqrt(data[:, 0]), "-o", label=r"$1/\sqrt{N}$")

plt.grid()
plt.legend()

plt.subplot(1, 2, 2)
plt.loglog(data[:, 0], data2[::2, 4], "-o", label=r"$\sigma_m$")
plt.loglog(data[:, 0], data2[1::2, 4], "-o", label=r"$\sigma_s / \sqrt{s}$")
plt.loglog(data[:, 0], data[:, 6], "-o", label=r"$\sigma_n / \sqrt{N}$")

plt.grid()
plt.legend()

plt.show()
