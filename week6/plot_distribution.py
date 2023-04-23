import numpy as np
import matplotlib.pyplot as plt

plt.figure(figsize=(20, 6))
for i in [100, 1000, 10000, 100000]:
    data = np.loadtxt(f"{i}.dat")
    plt.plot(data[:, 0], data[:, 1], label=f"N={i}")

s = np.random.normal(0, 1, 10000000)
bins, edges = np.histogram(s, 100, density=True)
plt.plot((edges[1:] + edges[:-1]) / 2, bins, "-o", label="Truth")

plt.legend()
plt.grid()

plt.show()
