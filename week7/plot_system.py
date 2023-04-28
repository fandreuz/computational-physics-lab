import numpy as np
import matplotlib.pyplot as plt
import matplotlib
import argparse

parser = argparse.ArgumentParser(
    prog="System plotter", description="CLI options for the system plotter"
)
parser.add_argument("-p", "--pbc", action="store_true")
args = parser.parse_args()


font = {"size": 15}
matplotlib.rc("font", **font)


def plot_up_down(up, down, alpha=1, label=True):
    plt.scatter(up[:, 0], up[:, 1], c="orange", s=50, label="Up" if label else None, alpha=alpha)
    plt.scatter(down[:, 0], down[:, 1], c="blue", s=50, label="Down" if label else None, alpha=alpha)


def plot(T):
    up = np.loadtxt(f"ising-up_{T}.dat").astype(int)
    down = np.loadtxt(f"ising-down_{T}.dat").astype(int)
    L = int(np.sqrt(len(up) + len(down)))

    data = np.empty((L, L), dtype=int)

    for row in up:
        data[row[0] - 1, row[1] - 1] = 1

    for row in down:
        data[row[0] - 1, row[1] - 1] = -1

    if args.pbc:
        max_x = max(np.max(up[:, 0]), np.max(down[:, 0]))
        max_y = max(np.max(up[:, 1]), np.max(down[:, 1]))

        up_bflags_top = np.logical_or(up[:, 0] == max_x, up[:, 1] == max_y)
        up_bflags_btm = np.logical_or(up[:, 0] == 0, up[:, 1] == 0)
        up_bflags = np.logical_or(up_bflags_top, up_bflags_btm)

        down_bflags_top = np.logical_or(down[:, 0] == max_x, down[:, 1] == max_y)
        down_bflags_btm = np.logical_or(down[:, 0] == 0, down[:, 1] == 0)
        down_bflags = np.logical_or(down_bflags_top, down_bflags_btm)

        plot_up_down(up[np.logical_not(up_bflags)], down[np.logical_not(down_bflags)])

        boundary_up = up[up_bflags]
        boundary_down = down[down_bflags]
        plot_up_down(boundary_up, boundary_down, alpha=0.3, label=False)
    else:
        plot_up_down(up, down)

    plt.axis("scaled")
    plt.legend()

    plt.title(f"T = {T}")


plt.figure(figsize=(20, 6))

plt.subplot(1, 2, 1)
plot(T=2)

plt.subplot(1, 2, 2)
plot(T=4)

plt.show()
