import numpy as np
import matplotlib.pyplot as plt
import matplotlib

from compute_block_average import compute_block_mean

font = {"size": 15}
matplotlib.rc("font", **font)

seeds = list(range(1, 5))
datas = [np.loadtxt(f"fort.1_{seed}")[:, [0, 3]] for seed in seeds]

plt.figure(figsize=(20, 12))

plt.title("Diffusion coefficient")

plt.xlabel("t")

print(np.mean(list(map(compute_block_mean, datas))))

for idx, data in enumerate(datas):
    block_mean = compute_block_mean(data[:, 1])
    plt.subplot(2, 2, idx + 1)
    plt.plot(data[:, 0], data[:, 1], label=r"$D(t)$")
    plt.hlines(
        block_mean,
        data[:, 0].min(),
        data[:, 0].max(),
        colors="r",
        linestyles="dashed",
        label=r"$\langle D_{}\rangle_T$",
    )

    plt.legend()
    plt.grid()

plt.show()
