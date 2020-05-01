import csv
import pulp
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
foodVars = LpVariable.dicts('Food', foods, 0, None, LpInteger)
foodFlag = LpVariable.dicts('Food Flag', foods, 0, 1, LpBinary)



prob += lpSum([cost[f] * foodVars[f] for f in foods]), 'Total Cost'

prob += lpSum([calories[f] * foodVars[f] for f in foods]) >= 2000, 'Total Calories'

prob += lpSum([carbs[f] * foodVars[f] for f in foods]) >= 130, 'Total Carbs Min'
prob += lpSum([carbs[f] * foodVars[f] for f in foods]) <= 200, 'Total Carbs Max'

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




prob += lpSum(foodFlag['Frozen Broccoli'] + foodFlag['Celery, Raw']) <= 1

# meat, poultry, fish
prob += lpSum(foodFlag['Roasted Chicken'] + foodFlag['Poached Eggs']) + foodFlag['Scrambled Eggs'] +foodFlag['Bologna,Turkey'] + foodFlag['Frankfurter, Beef'] + foodFlag['Ham,Sliced,Extralean'] + foodFlag['Kielbasa,Prk'] + foodFlag['Pork'] + foodFlag['Sardines in Oil'] + foodFlag['White Tuna in Water'] + foodFlag['Chicknoodl Soup'] + foodFlag['Splt Pea&Hamsoup'] >= 3

# vegetables          
prob += lpSum(foodFlag['Frozen Broccoli'] + foodFlag['Carrots,Raw'] + foodFlag['Celery, Raw'] + foodFlag['Frozen Corn'] +
                    foodFlag['Lettuce,Iceberg,Raw'] + foodFlag['Peppers, Sweet, Raw'] + foodFlag['Potatoes, Baked'] +
                    foodFlag['Tomato,Red,Ripe,Raw'] + foodFlag['Tomato Soup']) >= 3
# fruits
prob += lpSum(foodFlag['Apple,Raw,W/Skin'] + foodFlag['Banana'] + foodFlag['Grapes'] + foodFlag['Kiwifruit,Raw,Fresh'] +
                    foodFlag['Oranges']) >= 3
# grains
prob += lpSum(foodFlag['Wheat Bread'] + foodFlag['Malt-O-Meal,Choc'] + foodFlag['Bagels'] + foodFlag['White Bread'] +
                    foodFlag["Cap'N Crunch"] + foodFlag['Cheerios'] + foodFlag["Corn Flks, Kellogg'S"] + foodFlag["Raisin Brn, Kellg'S"] +
                    foodFlag['Rice Krispies'] + foodFlag['Special K'] + foodFlag['Oatmeal'] + foodFlag['Couscous'] + foodFlag['White Rice']) >= 3
# beans/nuts
# diet_model += lpSum(u['Peanut Butter'] + u['Beanbacn Soup,W/Watr']) >= 3
# dairy products
prob += lpSum(foodFlag['Cheddar Cheese'] + foodFlag['3.3% Fat,Whole Milk'] + foodFlag['2% Lowfat Milk'] +
                    foodFlag['Skim Milk'] + foodFlag['New E Clamchwd,W/Mlk'] + foodFlag['Crm Mshrm Soup,W/Mlk']) >= 3
# dessert
prob += lpSum(foodFlag['Apple Pie'] + foodFlag['Chocolate Chip Cookies'] + foodFlag['Oatmeal Cookies']) >= 3





#!!!!!!!!!!!!!!!!!!!!!!!!Does not work!!!!!!!!!!!!!!!!!!!!!!!!!!!111
#Food quantities to be in multiples of 0.1

prob += lpSum([(10*foodVars[f] - math.floor(10*foodVars[f])) for f in foods]) == 0.0, 'Food quantity precision'

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


prob.solve()

for var in prob.variables():
    if var.varValue > 0:
        print(var.name + '=' + str(var.varValue))