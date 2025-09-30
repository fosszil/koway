import os, json
from jsonschema import validate, ValidationError

ROUTES_DIR = "data/routes"
SCHEMA_FILE = "data/route.scheme.json"
OUTPUT_FILE = "routes.json"

with open(SCHEMA_FILE,'r',encoding="utf-8") as sf:
    schema = json.load(sf)

routes = []
done_routes = []
for item in os.listdir(ROUTES_DIR):
    if item.endswith(".json"):
        with open(os.path.join(ROUTES_DIR,item),'r') as f:
            try:
                route=json.load(f)
                validate(instance=route,schema=schema)
                routes.append(route)
                done_routes.append(item)
            except ValidationError as e:
                print(f"{item} failed validation : {e.message}")

output = {"routes": routes}

with open(OUTPUT_FILE, "w", encoding="utf-8") as m:
    json.dump(output, m, indent=2, ensure_ascii=False)

print(f"✅ Done compiling {len(routes)} routes into {OUTPUT_FILE}")
print(f"Compiled {len(done_routes)} {done_routes} routes into {OUTPUT_FILE}")
