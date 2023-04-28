import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)


def plot(T):
    up = np.loadtxt(f"ising-up_{T}.dat").astype(int)
    down = np.loadtxt(f"ising-down_{T}.dat").astype(int)
    L = int(np.sqrt(len(up) + len(down)))

    data = np.empty((L, L), dtype=int)

    for row in up:
        data[row[0] - 1, row[1] - 1] = 1

    for row in down:
        data[row[0] - 1, row[1] - 1] = -1

    plt.scatter(up[:, 0], up[:, 1], c="orange", s=50, label="Up")
    plt.scatter(down[:, 0], down[:, 1], c="blue", s=50, label="Down")

    plt.axis("scaled")
    plt.legend()

    plt.title(f"T = {T}")


plt.figure(figsize=(20, 6))

plt.subplot(1, 2, 1)
plot(T=2)

plt.subplot(1, 2, 2)
plot(T=4)

plt.show()
