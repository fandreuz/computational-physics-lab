import numpy as np
import matplotlib.pyplot as plt

data1 = np.loadtxt("fort.1")
data2 = np.loadtxt("fort.2")

plt.figure(figsize=(20,7))

plt.subplot(1,3,1)
plt.hist(data1, bins='auto')

plt.subplot(1,3,2)
plt.hist(data2, bins='auto')

plt.subplot(1,3,3)
x = np.linspace(-1, 1, 1000)[:-1]
plt.plot(x, 1 / (np.pi * np.sqrt(1 - x**2)))

plt.show()