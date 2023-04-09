import numpy as np
import matplotlib.pyplot as plt
import matplotlib
from sklearn.linear_model import LinearRegression

font = {'size' : 15}
matplotlib.rc('font', **font)

positions = np.loadtxt("position.dat")
avgs = np.loadtxt("avg.dat")
info = np.loadtxt("info.dat")

p_right = info[0]
p_left = info[1]
assert abs(p_right + p_left - 1) < 1.e-6
l = info[2]

N = np.arange(1, positions.shape[1] + 1)
x_avg_theory = N * (p_right - p_left) * l
mean_sq_displ_theory = 4 * p_left * p_right * N * l**2

plt.figure(figsize=(20,6))

plt.title(r"$\langle (\Delta x_N)^2 \rangle$ -- log-log fit")
plt.plot(N, avgs[2], label="Measured")
plt.plot(N, mean_sq_displ_theory, '-.', label="Theory")

N2 = np.array([2 ** i for i in range(11)])

model = LinearRegression(fit_intercept=False).fit(np.log(N2)[:,None], np.log(avgs[2][N2])[:,None])
v = model.coef_[0][0] / 2
v = np.round(v, 3)
plt.plot(N2, N2 ** (2 * v), 'o-', label=f"Fit (v={v})")

plt.grid()
plt.legend()

plt.show()