import numpy as np
import matplotlib.pyplot as plt
#from pyts.image import RecurrencePlot

plt.rcParams['savefig.dpi'] = 300 #图片像素
plt.rcParams['figure.dpi'] = 300 #分辨率
from scipy.spatial.distance import pdist, squareform

#############help function#########################
'''
def rec_plot(s, eps=1.10, steps=10):
    d = pdist(s[:,None])
    d = np.floor(d/eps)
    d[d>steps] = steps
    Z = squareform(d)
    return Z

def recurrence(s, eps=0.10, steps=10):
    d = np.linalg.norm(s)
    d = np.floor(d/eps)
    d[d>steps] = steps
    Z1 = squareform(d)
    return Z1
'''

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
    result = 2*np.random.rand(400)+0

    eps, steps = 1.0, 3
    X = result
    N = np.arange(1,401)
    X1 = np.sin(N*2*np.pi/70)+np.sin(N*2*np.pi/30)
    X2,x =[], 0.6
    for i in range(150):
        x = 4*x*(1-x)
        X2.append(x)
    ii = [aa for aa in range(0,150)]
    XX2 = np.array(X2) + 0.01*np.array(ii)
    delta_t = 0.01
    rd = np.cumsum(np.sqrt(delta_t) * np.random.randn(401))
    X3 = np.insert(rd, 0, 0)
    #plt.figure(figsize=(8,8))
    #plt.imshow(recurrence(X, eps=eps, steps=steps),cmap='binary',origin='lower')
    plt.figure(num=None, figsize=((20,6)), dpi= 100)
    #plt.subplots_adjust(top=1,bottom=0,left=0,right=1,hspace=0,wspace=0)
    #plt.subplot(1,2,1)
    dimension, delay, threshold, norm = 1, 6, 0.2, "euclidean"
    #plt.imshow(distance_matrix(X, dimension, delay, norm),  origin='lower')
    '''
    plt.axis('off')
    plt.gcf().set_size_inches(512 / 100, 512 / 100)
    plt.gca().xaxis.set_major_locator(plt.NullLocator())
    plt.gca().yaxis.set_major_locator(plt.NullLocator())
    plt.subplots_adjust(top=1, bottom=0, right=0.93, left=0, hspace=0, wspace=0)
    plt.margins(0, 0)
    '''
    '''
    fig5.set_size_inches(19.2/3,10.8/3) #dpi = 300, output = 700*700 pixels
    plt.gca().xaxis.set_major_locator(plt.NullLocator())
    plt.gca().yaxis.set_major_locator(plt.NullLocator())
    plt.subplots_adjust(top = 1, bottom = 0, right = 1, left = 0, hspace = 0, wspace = 0)
    plt.margins(0,0)
    fig5.savefig('target.jpg', format='jpg', transparent=True, dpi=300, pad_inches = 0)
    '''
    plt.subplot(1,4,1)
    plt.imshow(recurrence_matrix(X, dimension, delay, threshold, norm),cmap='binary', origin='lower')
    plt.xticks([])
    plt.yticks([])
    plt.title('(A)', fontsize=20, loc='left')
    #plt.subplots_adjust(top=1,bottom=0,left=0,right=1,hspace=0,wspace=0.05)
    plt.subplot(1,4,2)
    dimension, delay, threshold, norm = 4, 0, 0.4, "euclidean"
    plt.imshow(recurrence_matrix(X1, dimension, delay, threshold, norm),cmap='binary', origin='lower')
    plt.xticks([])
    plt.yticks([])
    plt.title('(B)', fontsize=20, loc='left')
    plt.subplot(1,4,3)
    dimension, delay, threshold, norm = 1, 0, 0.2, "euclidean"
    plt.imshow(recurrence_matrix(XX2, dimension, delay, threshold, norm),cmap='binary', origin='lower')
    plt.xticks([])
    plt.yticks([])
    plt.title('(C)', fontsize=20, loc='left')
    plt.subplot(1,4,4)
    dimension, delay, threshold, norm = 1, 0, 0.2, "euclidean"
    plt.imshow(recurrence_matrix(X3, dimension, delay, threshold, norm),cmap='binary', origin='lower')
    plt.xticks([])
    plt.yticks([])
    plt.title('(D)', fontsize=20, loc='left')
    plt.show()
