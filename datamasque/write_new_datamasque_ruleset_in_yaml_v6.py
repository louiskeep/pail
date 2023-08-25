import yaml

# Function for processing the data (example: increasing each number by 1)
def process_data(data):
    print(1)

# Load data from master_1.yaml
with open("master_1.yaml", 'r') as file:
    data = yaml.safe_load(file)

# Process the data
processed_data = process_data(data['tasks'])

# Write processed data to master_2.yaml
with open("master_2.yaml", 'w') as file:
    yaml.safe_dump(processed_data, file, indent=2, sort_keys=False, default_flow_style=False)

print("Processing done. Data saved to master_2.yaml")
