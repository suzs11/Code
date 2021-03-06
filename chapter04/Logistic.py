import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker

def generateLogistic():
    mu = np.arange(0, 4.5, 0.001)
    x = 0.3
    N  = 2000
    traj = []
    nu = []
    for i in range(N):
        x = mu * x * (1 - x)
        if i > 1800:
            traj.append(x)
            nu.append(mu)
    traj = np.asarray(traj)
    nu = np.asarray(nu)
    return (nu, traj)

def get_logistic_data(split=0.2):
    nu, traj = generateLogistic()
    split_num = int(split * traj.shape[1])

    train_data = traj[:,:split_num]
    val_data = traj[:,split_num:]

    return train_data ,val_data
def lyap():
    mu = np.arange(0, 4.0, 0.001)
    x = 0.3
    N = 2000
    sums = 0
    nu = []
    for i in range(N):
        y = mu*(1-2*x)
        sums = sums + np.log(np.abs(y))
        x = mu * x * (1 - x)
    lambda_ = sums/N
    return mu, lambda_


if __name__== "__main__":
    nu, traj = generateLogistic()
    train_data , val_data = get_logistic_data()
    mu, lambda_ = lyap()
    print(train_data.shape)
    print(val_data.shape)
    #print(nu)
    #print(traj)
    plt.figure()
    plt.plot(nu, traj, '.k')
    #plt.xlim((3.8,4.0))
    #plt.gca().xaxis.set_major_formatter(ticker.FormatStrFormatter('%.2f'))
    plt.figure()
    plt.plot(mu, lambda_,'.r')
    plt.hlines(0,0,4.0)
    plt.xlim([0,4])
    plt.ylim([-5,1])
    plt.show()
