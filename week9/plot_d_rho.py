import numpy as np
import matplotlib.pyplot as plt
import matplotlib

font = {"size": 15}
matplotlib.rc("font", **font)

data = np.loadtxt("out.txt")
rhos = [0.1, 0.2, 0.3, 0.5, 0.7]

data = [np.mean(block) for block in np.split(data, len(rhos))]

plt.figure(figsize=(10, 6))

plt.plot(rhos, data, "-o")

plt.xlabel(r"$\rho$")
plt.title(r"$D(\rho)$")

plt.grid()
plt.show()
