import yaml

def check_keys_in_table(yaml_doc, tables):
    with open(yaml_doc, 'r') as file:
        data = yaml.safe_load(file)
        print( data['tasks']['tables'] )
    
    results = {}

    for table in tables:
        if table in data:
            if "Patient_ID" in data[table]['rules']['hash_columns'] or "PatientID" in data[table]['rules']['hash_columns']:
                print("true")
                results[table] = True
            else:
                #print("false")
                results[table] = False
        else:
            #print("not present")
            results[table] = "not present"
    
    return results

if __name__ == "__main__":
    yaml_doc = './filtered.yaml'

    with open('./tables_with_patient_id_patientid.txt', 'r') as file:
        tables = [line.strip() for line in file.readlines()]

    results = check_keys_in_table(yaml_doc, tables)
"""
    for table, has_key in results.items():
        if has_key:
            print(f"'{table}' has either 'patient_id' or 'patientid'")
        elif not has_key:
            print(f"'{table}' does not have 'patient_id' or 'patientid'")
        else:
            print(f'{table} not present')

"""