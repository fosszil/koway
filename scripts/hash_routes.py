import json
import os
from typing import Dict, List, Any

def read_json(filepath: str) -> Dict[str, Any]:
    if not os.path.exists(filepath):
        print(f"Error: File '{filepath}' not found.")
        return {}
    
    with open(filepath, 'r', encoding='utf-8') as file:
        return json.load(file)

def hash_routes(data: Dict[str, Any]) -> Dict[str, List[str]]:
    stop_to_routes_map: Dict[str, List[str]] = {}
    routes_data = data.get('routes', [])

    for route in routes_data:
        route_number = route.get('routeNumber')
        stops = route.get('stops', [])

        for stop in stops:
            stop_name = stop.get('stop_name')
            
            if stop_name in stop_to_routes_map:
                stop_to_routes_map[stop_name].append(route_number)
            else:
                stop_to_routes_map[stop_name] = [route_number]
                
    return stop_to_routes_map

def write_formatted_json(data: Dict[str, Any], file_path: str) -> None:
    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(data, file, indent=1) 
    print(f'Data written to {file_path}')


def main():
    path_to_file = '../koway/assets/routes.json'
    
    data = read_json(path_to_file)
    
    if not data:
        return

    route_data = hash_routes(data)

    output_file_path = '../koway/assets/hashed_routes.json'
    write_formatted_json(route_data, output_file_path)

if __name__ == "__main__":
    main()