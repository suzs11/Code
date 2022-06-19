import numpy as np
import matplotlib.pyplot as plt
#from pyts.image import RecurrencePlot
from scipy.spatial.distance import pdist, squareform

from data import get_lorenz_data
#from data_R import get_rossler_data


##    help function      ##
def rec_plot(s, eps=0.10, steps=10):
    d = pdist(s[:,None])
    d = np.floor(d/eps)
    d[d>steps] = steps
    Z = squareform(d)
    return Z

def moving_average(s, r=5):
    return np.convolve(s, np.ones((r,))/r, mode='valid')

def distance_matrix(data, dimension, delay, norm):
    N = int(len(data) - (dimension-1) * delay)
    distance_matrix = np.zeros((N, N), dtype="float32")
    if norm == 'manhattan':
        for i in range(N):
            for j in range(i, N, 1):
                temp = 0.0
                for k in range(dimension):
                    temp += np.abs(data[i+k*delay] - data[j+k*delay])
                distance_matrix[i,j] = distance_matrix[j,i] = temp
    elif norm == 'euclidean':
        for i in range(N):
            for j in range(i, N, 1):
                temp = 0.0
                for k in range(dimension):
                    temp += np.power(data[i+k*delay] - data[j+k*delay], 2)
                distance_matrix[i,j] = distance_matrix[j,i] = np.sqrt(temp)
    elif norm == 'supremum':
        temp = np.zeros(dimension)
        for i in range(N):
            for j in range(i, N, 1):
                for k in range(dimension):
                    temp[k] = np.abs(data[i+k*delay] - data[j+k*delay])
                distance_matrix[i,j] = distance_matrix[j,i] = np.max(temp)
    return distance_matrix

def recurrence_matrix(data, dimension, delay, threshold, norm):
    recurrence_matrix = distance_matrix(data, dimension, delay, norm)
    N = len(recurrence_matrix[:,0])
    for i in range(N):
        for j in range(i, N, 1):
            if recurrence_matrix[i,j] <= threshold:
                recurrence_matrix[i,j] = recurrence_matrix[j,i] = 1
            else:
                recurrence_matrix[i,j] = recurrence_matrix[j,i] = 0
    return recurrence_matrix.astype(int)
##########################
if __name__=="__main__":

    dt = 0.02
    train_data = get_lorenz_data(dt=dt)
    #train_data = get_rossler_data(dt=dt)

    #traj = np.r_[train_data, val_data] 
    traj = train_data
    t = np.linspace(0, traj.shape[0]*dt, traj.shape[0])
    fig1 = plt.figure()
    ax1 = plt.axes(projection='3d')
    ax1.plot3D(traj[:,0],traj[:,1],traj[:,2],'r-')

    fig2 = plt.figure()
    plt.plot(t[3000:],traj[3000:,0], 'b-')
    plt.xlim(0, 60)
    plt.xlabel("$\it{t}$", fontsize=18)
    plt.ylabel('$\it{x}$', fontsize=18)

    fig3 = plt.figure()
    plt.plot(traj[:-400,0],traj[400:,0],'m--')
    plt.xlabel("$x(t)$",fontsize=18)
    plt.ylabel("$x(t+8)$",fontsize=18)

    '''
    x = traj[:,0]
    N=450
    eps1 = 1.
    d = 3
    t1 = 6
    rp = np.zeros((N,N))
    for i in range(N):
        for j in range(N):
            rp=np.heaviside(eps1-np.sqrt(np.sum(x[i:i+(d-1)*t1:t1]
                  - x[j:j+(d-1)*t1:t1])**2))
            rp.append()
    plt.imshow(rp, cmap='binary', origin='lower')
    plt.show()
    '''
    eps, steps = 1.0, 3
    X = traj[3000:,0]
    #plt.figure(figsize=(8,8))
    #plt.imshow(rec_plot(X, eps=eps, steps=steps),cmap='binary',origin='lower')
    #plt.pcolor(rec_plot(X[:1000], eps=eps, steps=steps), cmap='binary')

    dimension, delay, threshold, norm = 3, 5, 15, "manhattan"
    #distance_matrix = distance_matrix(X, dimension, delay, norm)
    #recurrence_matrix = recurrence_matrix(X, dimension, delay, threshold, norm)
    #LIN = len(distance_matrix[:,0])

    plt.figure(num=None, figsize=((12,6)), dpi= 100)
    plt.subplot(3,2,1)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap = 'binary', origin='lower')
    plt.title('A', fontsize=12, loc='left')
    plt.xlabel('i', fontsize=10)
    plt.ylabel('j', fontsize=10)
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(3,2,2)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm),
            cmap = cmap, vmin = 0, vmax = 1, origin='lower')
    plt.title("B", fontsize=12,loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=10)
    plt.ylabel('j', fontsize=10)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    #plt.savefig('f_1.pdf')

    #dimension, delay, threshold, norm = 3, 5, 0.1, "euclidean"
    #LIN = len(distance_matrix[:,0])

    #plt.figure(num=None, figsize=((12,6)), dpi= 100)
    #plt.subplots_adjust(wspace = 0.3)
    plt.subplot(3,2,3)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap ='binary',origin='lower')
    plt.title('C',fontsize=20, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(3,2,4)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm), cmap =
               cmap, vmin = 0, vmax = 1,origin='lower')
    plt.title("D", fontsize=20, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    #plt.savefig('f_2.pdf')

    #dimension, delay, threshold, norm = 3, 5, 0.1, "supremum"
    #distance_matrix = distance_matrix(X, dimension, delay, norm)
    #recurrence_matrix = recurrence_matrix(X, dimension, delay, threshold, norm)
    #LIN = len(distance_matrix[:,0])

    #plt.figure(num=None, figsize=((12,6)), dpi= 100)
    #plt.subplots_adjust(wspace = 0.3)
    plt.subplot(3,2,5)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap = 'binary',
               origin='lower')
    plt.title('E', fontsize=20, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(3,2,6)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm), cmap =
               cmap, vmin = 0, vmax = 1,origin='lower')
    plt.title('F',fontsize=20, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    plt.savefig('f_inf.pdf')
    plt.close()
    plt.show()
