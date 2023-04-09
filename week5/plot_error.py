import numpy as np
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rc("font", size=17)

data_is = np.loadtxt("error_is.txt")
data_sm = np.loadtxt("error_sm.txt")
x = data_is[:, 0].astype(int)

plt.figure(figsize=(20, 6))

plt.subplot(1, 2, 1)
plt.plot(x, data_is[:, 1], "-o", color="r", label="IS")
plt.plot(x, data_sm[:, 1], "-o", color="purple", label="SM")

plt.xlabel("N")
plt.ylabel("Error")

plt.title("Variance comparison")

plt.fill_between(
    x,
    data_is[:, 1] - data_is[:, 3],
    data_is[:, 1] + data_is[:, 3],
    color="r",
    alpha=0.3,
)
plt.fill_between(
    x,
    data_sm[:, 1] - data_sm[:, 3],
    data_sm[:, 1] + data_sm[:, 3],
    color="purple",
    alpha=0.3,
)

plt.xscale("log", base=2)
# plt.yscale("log")

plt.grid()
plt.legend()

plt.subplot(1, 2, 2)
plt.loglog(x, data_is[:, 1], "-o", color="r", base=2, label="IS")
plt.loglog(x, data_sm[:, 1], "-o", color="purple", base=2, label="SM")
plt.loglog(x, 1 / np.sqrt(x), "-o", base=2, label=r"$1/\sqrt{N}$")

plt.xlabel("N")

plt.title("Error")

plt.grid()
plt.legend()

plt.show()
