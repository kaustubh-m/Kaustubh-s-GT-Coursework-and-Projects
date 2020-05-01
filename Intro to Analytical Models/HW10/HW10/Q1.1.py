
# coding: utf-8

# In[8]:

import csv
from pulp import *

with open('diet_test.csv') as csvfile:
    reader = csv.reader(csvfile)
    next(reader, None)
    data = list(reader)
    data = data[:-3]
#print(data[0])

foods = [x[0] for x in data]
cost = dict([(x[0], float(x[1][1:])) for x in data])
calories = dict([(x[0], float(x[3])) for x in data])
carbs = dict([(x[0], float(x[7])) for x in data])
protein = dict([(x[0], float(x[7])) for x in data])
cholesterol = dict([(x[0], float(x[4])) for x in data])
fat = dict([(x[0], float(x[5])) for x in data])
sodium = dict([(x[0], float(x[6])) for x in data])
vitA = dict([(x[0], float(x[8])) for x in data])
vitC = dict([(x[0], float(x[9])) for x in data])
calcm = dict([(x[0], float(x[10])) for x in data])
iron = dict([(x[0], float(x[11])) for x in data])

prob = LpProblem('My Problem', LpMinimize)
foodVars = LpVariable.dicts('Food', foods, 0, None)
foodFlag = LpVariable.dicts('Food Flag', foods, 0, 1, LpBinary)


# In[9]:

prob += lpSum([cost[f] * foodVars[f] for f in foods]), 'Total Cost'

prob += lpSum([calories[f] * foodVars[f] for f in foods]) >= 1500, 'Min Total Calories'
prob += lpSum([calories[f] * foodVars[f] for f in foods]) <= 2500, 'Max Total Calories'

prob += lpSum([carbs[f] * foodVars[f] for f in foods]) >= 130, 'Total Carbs Min'
prob += lpSum([carbs[f] * foodVars[f] for f in foods]) <= 450, 'Total Carbs Max'

prob += lpSum([protein[f] * foodVars[f] for f in foods]) >= 60, 'Total Protein Min'
prob += lpSum([protein[f] * foodVars[f] for f in foods]) <= 100, 'Total Protein Max'

prob += lpSum([cholesterol[f] * foodVars[f] for f in foods]) >= 30, 'Total Cholesterol Min'
prob += lpSum([cholesterol[f] * foodVars[f] for f in foods]) <= 240, 'Total Cholesterol Max'

prob += lpSum([fat[f] * foodVars[f] for f in foods]) >= 20, 'Total Fat Min'
prob += lpSum([fat[f] * foodVars[f] for f in foods]) <= 70, 'Total Fat Max'

prob += lpSum([sodium[f] * foodVars[f] for f in foods]) >= 800, 'Total Sodium Min'
prob += lpSum([sodium[f] * foodVars[f] for f in foods]) <= 2000, 'Total Sodium Max'

prob += lpSum([vitA[f] * foodVars[f] for f in foods]) >= 1000, 'Total Vitamin A Min'
prob += lpSum([vitA[f] * foodVars[f] for f in foods]) <= 10000, 'Total Vitamin A Max'

prob += lpSum([vitC[f] * foodVars[f] for f in foods]) >= 400, 'Total Vitamin C Min'
prob += lpSum([vitC[f] * foodVars[f] for f in foods]) <= 5000, 'Total Vitamin C Max'

prob += lpSum([calcm[f] * foodVars[f] for f in foods]) >= 700, 'Total Calcium Min'
prob += lpSum([calcm[f] * foodVars[f] for f in foods]) <= 1500, 'Total Calcium Max'

prob += lpSum([iron[f] * foodVars[f] for f in foods]) >= 10, 'Total Iron Min'
prob += lpSum([iron[f] * foodVars[f] for f in foods]) <= 40, 'Total Iron Max'


#prob += foodVars[f] for f in foods]



# In[10]:

#type(foodVars[1])


# In[11]:

# at least 1/10 or 0 contraint
#for f in foods:
#    prob += foodVars[f] <= 0.1 + 10000*foodFlag[f]
    
for f in foods:
    prob += lpSum([foodVars[f]]) >= 0.1 - 10000*(1-foodFlag[f])


# In[12]:

prob.solve()

for var in prob.variables():
    if var.varValue > 0:
        print(var.name + '=' + str(var.varValue))

