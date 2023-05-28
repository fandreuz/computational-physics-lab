import numpy as np

# equilibration
skip = 400
# number of blocks for a run of 1000 consecutive timesteps
number_of_blocks = 5


def compute_block_mean(data):
    return np.mean(
        [np.mean(block) for block in np.array_split(data[skip:], number_of_blocks)]
    )

if __name__ == "__main__":
    data = np.loadtxt("fort.1")[:, 3]
    print(compute_block_mean(data))