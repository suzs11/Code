import numpy as np
import matplotlib.pyplot as plt
from pyts.image import RecurrencePlot
from scipy.spatial.distance import pdist, squareform
import matplotlib.ticker as ticker

from Logistic_t import logistic
from data_R import get_rossler_data

##    help function      ##
def rec_plot(s, eps=0.10, steps=10):
    d = pdist(s[:,None])
    d = np.floor(d/eps)
    d[d>steps] = steps
    Z = squareform(d)
    return Z

#x_norm=np.linalg.norm(x, ord=None, axis=None, keepdims=False)

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
    _, result = logistic()
    traj = result[300:]
    #time, result = get_rossler_data()
 
    #fig1 = plt.figure()
    #plt.plot(time,result,'r-')
    #plt.xlim(0, 100)
    #plt.xlabel("$Time$",fontsize=18)
    #plt.ylabel("$x$",fontsize=18)
    
    '''
    fig2 = plt.figure()
    plt.plot(result, result ,'.',markersize=3., color='k')
    font1 = {'family' : 'serif',
    'weight' : 'normal',
    'size'   : 20,
    }
    plt.xlim((3.8, 4.0))
    plt.gca().xaxis.set_major_formatter(ticker.FormatStrFormatter('%.2f'))
    plt.xticks(fontsize=12)
    plt.yticks(fontsize=12)
    plt.xlabel('$X(t)$', font1)
    plt.ylabel('$X(t+50)$',font1)
    #plt.savefig('logistic.pdf')
    '''
  
    eps, steps = 1.0, 3
    #X = np.asarray(result)
    X = result

    #fig3 = plt.figure(figsize=(8,8))
    #plt.imshow(rec_plot(X, eps=eps, steps=steps),cmap='binary',origin='lower')
    #plt.pcolor(rec_plot(X[:1000], eps=eps, steps=steps), cmap='binary')


    dimension, delay, threshold, norm = 3, 10, .6, "manhattan"
    #distance_matrix = distance_matrix(X, dimension, delay, norm)
    #recurrence_matrix = recurrence_matrix(X, dimension, delay, threshold, norm)
    #LIN = len(distance_matrix[:,0])

    plt.figure(num=None, figsize=((12,6)), dpi= 100)
    plt.subplots_adjust(wspace = 0.3)
    plt.subplot(2,3,1)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap = 'binary', origin='lower')
    plt.title('A', fontsize=16, loc='left')
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(2,3,4)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm),
            cmap = cmap, vmin = 0, vmax = 1, origin='lower')
    plt.title("B", fontsize=16,loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    #plt.savefig('f_1.pdf')

    dimension, delay, threshold, norm = 3, 10, 0.6, "euclidean"
    #LIN = len(distance_matrix[:,0])

    #plt.figure(num=None, figsize=((12,6)), dpi= 100)
    plt.subplots_adjust(wspace = 0.3)
    plt.subplot(2,3,2)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap ='binary',origin='lower')
    plt.title('C',fontsize=16, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(2,3,5)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm), cmap =
               cmap, vmin = 0, vmax = 1,origin='lower')
    plt.title("D", fontsize=16, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    #plt.savefig('f_2.pdf')

    dimension, delay, threshold, norm = 3, 10, .6, "supremum"
    #distance_matrix = distance_matrix(X, dimension, delay, norm)
    #recurrence_matrix = recurrence_matrix(X, dimension, delay, threshold, norm)
    #LIN = len(distance_matrix[:,0])

    #plt.figure(num=None, figsize=((12,6)), dpi= 100)
    plt.subplots_adjust(wspace = 0.3)
    plt.subplot(2,3,3)
    plt.imshow(distance_matrix(X, dimension, delay, norm), cmap = 'binary',
               origin='lower')
    plt.title('E', fontsize=16, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    plt.colorbar(fraction=0.046, pad=0.04)
    plt.subplot(2,3,6)
    cmap = plt.get_cmap('binary', 2)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm), cmap =
               cmap, vmin = 0, vmax = 1,origin='lower')
    plt.title('F',fontsize=16, loc='left')
    #plt.axis([-0.5, LIN-0.5, -0.5, LIN-0.5])
    plt.xlabel('i', fontsize=14)
    plt.ylabel('j', fontsize=14)
    #plt.xticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    #plt.yticks([x for x in range(LIN)], [x+1 for x in range(LIN)])
    cbar = plt.colorbar(fraction=0.046, pad=0.04, ticks=[0.25,0.75])
    cbar.ax.set_yticklabels(['0', '1'])
    plt.savefig('f_inf.pdf')
    plt.show()