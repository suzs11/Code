import numpy as np
import matplotlib.pyplot as plt

def logistic():
    mu = 4.0
    times = []
    result = []
    x = 0.32
    for i in range(1,1001):
        x = mu * x *(1 - x)
        result.append(x)
        times.append(i)
    return (times, result)
    
def logistic_(mu):
    times_ = []
    result_ = []
    x = 0.6
    for i in range(1,1001):
        x = mu * x *(1 - x)
        result_.append(x)
        times_.append(i)
    return (times_, result_)
#np.savetxt('lg.txt',np.column_stack((times,result)),fmt="%d %f",delimiter="\n")
if __name__=='__main__':
    times, result = logistic()
    mu = 4.0
    times_, result_ = logistic_(mu)
    plt.figure()
    plt.plot(times[:500],result[:500],"r-")
    plt.xlim(0, 500)
    
    plt.figure()
    plt.plot(times_[:500],result_[:500],"b-")
    plt.xlim(0, 500)
    #plt.savefig("lgstic_t.pdf")
    plt.show()
