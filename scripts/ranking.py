import theano
import numpy as np

# [dt, stars]
# inputs =  [[1, 100], [2, 100], [3, 100], [4, 100], [5, 100], [6, 100], [10,100]]
# targets = [[0, 80],  [0,  70], [0,  60], [0,  55], [0,  50], [0,  45], [0,  30]]

# inputs =  [[24, 1000], [6, 100], [3, 100], [1, 100], [2, 100], [8, 100], [12,100]]
# targets = [[0, 10],  [0,  60], [0,  80], [0,  95], [0,  90], [0,  50], [0,  30]]

inputs =  [[1, 100], [2, 100], [3, 100], [4, 100], [5, 100], [6, 100], [8, 100], [12,100], [24, 100]]
targets =  [[0, 95], [0, 90],  [0, 85],  [0, 80],  [0, 70],  [0, 60],  [0, 50],  [0, 40],  [0, 30]]

b = theano.shared(0.0)
e = theano.shared(1.1)
p = theano.shared(0.9)

def rank(dt,stars):
    return b + (stars**p) / (e**dt)

x = theano.tensor.matrix()
y = theano.tensor.matrix()

def calcError(x,y):
    result, updates = theano.scan(fn=lambda xi, yi, e: e + (rank(xi[0], xi[1]) - rank(yi[0], yi[1]))**2,
                #   outputs_info=theano.tensor.as_tensor_variable(0, dtype=theano.config.floatX, dim=0),
                  outputs_info=np.float64(0),
                  sequences=[x,y])
    return result[-1]

cost = calcError(x,y) + (e-1)**2 + (p-1)**2

print 'compile grads'
gradb = theano.tensor.grad(cost, b)
grade = theano.tensor.grad(cost, e)
gradp = theano.tensor.grad(cost, p)

learning_rate = 0.001
training_steps = 10000

print 'compile train'
train = theano.function([x,y],cost, updates = [(b,b-learning_rate*gradb),(e,e-learning_rate*grade), (p,p-learning_rate*gradp)])

print 'training...'
for i in range(training_steps):
    print train(inputs,targets)

print 'done'
print 'b:', b.get_value()
print 'e:', e.get_value()
print 'p:', p.get_value()
