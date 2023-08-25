import yaml
import pandas as pd


def find_tables_with_no_hashes(yaml_content):
    s = set()
    for table_entry in yaml_content:
        for rule in table_entry.get('rules', []):
            if not "hash_columns" in rule:
                s.add( table_entry.get('table') )
            
    with open('./tables_with_no_hashes.txt', 'w+') as f:
        for i in s:
            i = i.split(".")
            i = i[1].strip('"')
            f.write(f'{i}\n')


def find_table_in_yaml(yaml_content, table_name):
    for entry in yaml_content:
        if entry.get('type') == 'mask_table' and entry.get('table') == table_name:
            return entry
    return None


def get_table_columns(entry, all_tables_and_columns_dict, schema_name, table_name):
    # Get dictionary of ALL schemas, tables, fields
    
    #table_columns = [rule['column'].lower() for rule in table_data[entry.get('table')].get('rules', [])]
    
    """
    if schema_name in all_tables_and_columns_dict:
        # Check if the table exists within the schema
        if table_name in all_tables_and_columns_dict[schema_name]:
            # Return the fields for the table
            table_columns = all_tables_and_columns_dict[schema_name][table_name]
    """
    print("Building table_columns\n")
    table_columns = [record.lower() for record in all_tables_and_columns_dict[schema_name][table_name]]
    
    return table_columns


def process_dict(d):
    if isinstance(d, dict):
        return {k.lower().strip('"').strip("'"): process_dict(v) for k, v in d.items()}
    elif isinstance(d, list):
        return [process_dict(i) for i in d]
    elif isinstance(d, str):
        return d.lower().strip('"').strip("'")
    return d


def filter_yaml(yaml_content, to_mask_tables_and_fields, all_tables_and_columns_dict):
    
    print("Filtering YAML\n")

    filtered_content = []

    for entry in yaml_content:
        # Check for 'mask_unique_key' type.
        if entry.get('type') == 'mask_unique_key':
            filtered_content.append(entry)
            continue

        table_name = entry.get('table').split('.')[1].strip('"').strip("'")
        
        if entry.get('type') == 'mask_table' and f'"{table_name}"' in to_mask_tables_and_fields:

            new_entry = {
                'type': 'mask_table',
                'table': entry['table'],
                'key': entry['key'],
                'rules': []
            }

            table_name = entry.get('table').split('.')[1].strip("'").strip('"')
            schema_name = entry.get('table').split('.')[0].strip("'").strip('"')

            for rule in entry.get('rules', []):

                rule_column_lower = rule['column'].strip('"').lower()
                table_columns = to_mask_tables_and_fields[f'"{table_name}"']
                
                # for every column that needs to be masked in table
                for column in table_columns:
                    
                    # if column needs to be masked
                    if rule['column'] == column:

                        # current hash_columns in rule
                        hash_columns = [item.lower() for item in rule.get("hash_columns", [])]

                        # check if patientid or patient_id already exist in hash_columns for the specific rule being processed
                        if ('patientid' == rule_column_lower and 'patientid' not in hash_columns) or 'patientid' in all_tables_and_columns_dict[schema_name][table_name]:
                            hash_columns.append('PatientID')
                        if ('patient_id' == rule_column_lower and 'patient_id'.lower() not in hash_columns):
                            hash_columns.append('Patient_ID')

                        # if no hash columns exist
                        if not hash_columns:
                            ordered_rule = {
                                "column": rule["column"],
                                "masks": rule["masks"]
                            }

                        # if hash columns already exist
                        else:
                            ordered_rule = {
                                "column": rule["column"],
                                "hash_columns": hash_columns,
                                "masks": [rule["masks"]]
                            }

                        new_entry['rules'].append(ordered_rule)
            
            if not new_entry['rules']:
                column = to_mask_tables_and_fields[f'"{table_name}"']
                
                # Assuming column is a list; if not, wrap it in a list
                if not isinstance(column, list):
                    column = [column]

                ordered_rule = {
                    "column": column[0],  # Assuming you want the first item as the column
                    "hash_columns": [field.strip('"') for field in column],  # Using the entire list for hash_columns
                    "masks": rule["masks"] #### TODO what masks to add for single fields?
                }

                new_entry['rules'].append(ordered_rule)

            filtered_content.append(new_entry)

    return filtered_content



def get_all_tables_and_columns_dict():
    print("Read datamasque_phi_ref.xlsx\n")
    xls = pd.ExcelFile(r"C:\Users\ckeeperman\Documents\datamasque_phi_ref.xlsx")

    # Read the ALL_TABLES_AND_COLUMNS sheet
    print("Parsing ALL_TABLES_AND_COLUMNS\n")
    df = xls.parse('ALL_TABLES_AND_COLUMNS')

    # Initialize an empty dictionary
    all_tables_and_columns_dict = {}

    # Iterate through the DataFrame rows and populate the dictionary
    print("Building dictionary\n")
    for index, row in df.iterrows():
        schema = row['SCHEMA']
        table = row['TABLE']
        column = row['COLUMN']
        
        # Using schema and table as nested keys in the dictionary
        if schema not in all_tables_and_columns_dict:
            all_tables_and_columns_dict[schema] = {}
        if table not in all_tables_and_columns_dict[schema]:
            all_tables_and_columns_dict[schema][table] = []
        
        all_tables_and_columns_dict[schema][table].append(column)

    print("Writing all fields to db_dict.txt\n")
    with open("db_dict.txt", 'w') as f:
        f.write(str(all_tables_and_columns_dict))

    return all_tables_and_columns_dict


def get_tables_and_fields_to_mask():
    print("Read datamasque_phi_ref.xlsx\n")
    excel = pd.ExcelFile(r"C:\Users\ckeeperman\Documents\datamasque_phi_ref.xlsx")

    # Read the ALL_TABLES_AND_COLUMNS sheet
    print("Parsing TO_BE_MASKED\n")
    dataframe = excel.parse('TO_BE_MASKED')

    # results dict
    to_mask_tables_and_fields = {}

    # iterate
    print("Building dictionary\n")
    for index, row in dataframe.iterrows():
        schema_name = row['schemaName']
        table_name = row['tableName']
        column_name = row['columnName']
    
        # construct key
        key = f'"{schema_name}_{table_name}"'
        
        # if table name not in dictionary
        # add it with empty list
        if key not in to_mask_tables_and_fields:
            to_mask_tables_and_fields[key] = []
        
        # add the column name to the list of columns for that table
        to_mask_tables_and_fields[key].append(f'"{column_name}"')
    
    print("Writing dictionary to phi_dict.txt\n")
    with open("phi_dict.txt", 'w') as f:
        f.write(str(to_mask_tables_and_fields))
    
    return to_mask_tables_and_fields

def main():
    
    print("Getting list of to_mask_tables_and_fields\n")
    # Define tables and fields
    to_mask_tables_and_fields = get_tables_and_fields_to_mask()
    
    # Read the original YAML
    print("Reading qtip_tst.yaml\n")
    with open('qtip_tst.yaml', 'r') as f:
        yaml_content = yaml.safe_load(f)
    
    print("Filtering\n")
    # Filter the content based on desired tables and fields
    filtered_content = {'tasks': filter_yaml(yaml_content['tasks'], to_mask_tables_and_fields, get_all_tables_and_columns_dict())}

    print("Writing to filtered.yaml()\n")
    # Write the filtered content to a new YAML file
    with open('filtered_v4.yaml', 'w') as f:
        yaml.dump(filtered_content, f, indent=4, sort_keys=False, default_flow_style=False)


if __name__ == '__main__':
        
    # Read the original YAML
    #with open('qtip_tst.yaml', 'r') as f:
    #    yaml_content = yaml.safe_load(f)
    #    find_tables_with_no_hashes(yaml_content['tasks'])
    print("Begin main()\n")
    main()
