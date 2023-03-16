import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("fort.1")
data = np.delete(data, np.where(data == np.inf))
bins = np.histogram(data, bins=10000, range=(0, data.max()))
plt.hist(bins)
plt.show()