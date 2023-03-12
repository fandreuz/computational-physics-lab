import numpy as np
import matplotlib.pyplot as plt
import sys

N = 10000
dn = 10

data = np.loadtxt("moments.dat")

n_moments = data.shape[0] // 2
moment_idx = int(sys.argv[1]) - 1

ns = (np.arange(N) + 1) * dn
plt.loglog(ns, data[2 * moment_idx], label="Computed")
plt.loglog(ns, data[2 * moment_idx + 1], label="Expected")

plt.legend()
plt.grid()

plt.show()
