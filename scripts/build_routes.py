import os, json

ROUTES = "data/routes/"

routes = []
for item in os.listdir(ROUTES):
    if item.endswith(".json"):
        with open(os.path.join(ROUTES,item),'r') as f:
            route = json.load(f)
            routes.append(route)
            print("Added route")

output = {"routes": routes}
with open('routes.json','w') as m:
    json.dump(output,m,indent=2)
    print("Done compiling.")