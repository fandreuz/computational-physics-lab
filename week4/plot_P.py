import numpy as np
import matplotlib.pyplot as plt
from math import gamma, factorial

P8 = np.loadtxt("P8.dat")
P32 = np.loadtxt("P32.dat")
P64 = np.loadtxt("P64.dat")

l = 1


def plot(P):
    N = (P.shape[1] - 1) // 2

    bins = np.array([l * i for i in range(-N, N + 1)])
    plt.bar(bins, P[0], label="Measured")
    plt.plot(bins, P[2], "r", label="Theory")

    plt.xticks(bins[::10], bins[::10])

    plt.legend()
    plt.title(f"N={N}")


plt.figure(figsize=(20, 6))

plt.subplot(1, 3, 1)
plot(P8)

plt.subplot(1, 3, 2)
plot(P32)

plt.subplot(1, 3, 3)
plot(P64)

# x = np.arange(-N, N+1) * l
# xm = np.empty(len(x))
# xp = np.empty(len(x))
# for i in range(len(xm)):
#    xp[i] = gamma(N / 2 + x[i] / 2 + 1)
#    xm[i] = gamma(N / 2 - x[i] / 2 + 1)
# plt.plot(bins, factorial(N) / (xm * xp) * (1/2) ** (N / 2 + x / 2) * (1/2) ** (N / 2 - x / 2))

plt.show()
