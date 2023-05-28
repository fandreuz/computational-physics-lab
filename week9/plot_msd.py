import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from sklearn.linear_model import LinearRegression

font = {"size": 15}
matplotlib.rc("font", **font)

a = 2.0e-8
L = 20
skip = 5

data = np.loadtxt("fort.1")[:, :2]

plt.figure(figsize=(10, 6))

plt.xlabel("t")
plt.title(r"$\langle R^2(t) \rangle$")

plt.plot(data[:, 0], data[:, 1], "-", label=r"Simulation")
plt.plot(data[:, 0], a * a * np.arange(1, len(data) + 1) * skip, "-", label="$a^2 N$")

limit = (L * a / 2) ** 2
plt.hlines(
    limit,
    data[:, 0].min(),
    data[:, 0].max(),
    colors="r",
    linestyles="--",
    label="Th. limit",
)

under_limit_count = len(data[:, 1] < limit)
reg = LinearRegression(fit_intercept=False).fit(
    np.arange(under_limit_count)[:, None] * skip, data[:under_limit_count, 1][:, None]
)
plt.plot(
    data[:, 0],
    reg.coef_[0] * np.arange(1, len(data) + 1) * skip,
    "-",
    label="Linear fit",
)

plt.legend()
plt.grid()
plt.show()
