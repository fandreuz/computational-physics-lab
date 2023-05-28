import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

D = np.loadtxt("fort.1")[400:, 3]
l = len(D)
block_sizes = [1, 5, 10, 25, 50, 75, 100, 125, 150]


def block_average(block_size):
    block_count = l // block_size
    blocks = np.array_split(D, block_count)
    means = np.fromiter(map(np.mean, blocks), dtype=float)
    return np.std(means, ddof=1) / np.sqrt(block_count - 1)


stdevs = list(map(block_average, block_sizes))

plt.figure(figsize=(10, 6))
plt.title(r"$\sigma_b / \sqrt{n_b - 1}$")

plt.plot(block_sizes, stdevs, "-o")

plt.xlabel("Block size")

plt.grid()

plt.show()
