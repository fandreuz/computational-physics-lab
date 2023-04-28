import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

Ts = [2, 4]
data = [np.loadtxt(f"energy_magnetization_{T}.dat") for T in Ts]

plt.figure(figsize=(20, 6))

plt.subplot(1, 2, 1)
for idx, T in enumerate(Ts):
    plt.plot(data[idx][:, 0], label=f"T={T}")

plt.title("Energy per spin")
plt.grid()
plt.legend()

plt.xlabel("MC step")

plt.subplot(1, 2, 2)
for idx, T in enumerate(Ts):
    plt.plot(data[idx][:, 1], label=f"T={T}")

plt.title("Magnetization per spin")
plt.grid()
plt.legend()

plt.xlabel("MC step")

plt.show()
