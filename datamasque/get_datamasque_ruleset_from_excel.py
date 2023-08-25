import pandas as pd

df = pd.read_excel(r"C:\Users\ckeeperman\Documents\datamasque_phi_ref.xlsx")

# results dict
desired_tables_and_fields = {}


# iterate
#print(df.columns)
for index, row in df.iterrows():
    schema_name = row['schemaName']
    table_name = row['tableName']
    column_name = row['columnName']
  
    # construct key
    key = '"' + schema_name + "_" + table_name + '"'
    
    # if table name not in dictionary
    # add it with empty list
    if key not in desired_tables_and_fields:
        desired_tables_and_fields[key] = []
    
    # add the column name to the list of columns for that table
    desired_tables_and_fields[key].append(f'{column_name}')

# print(desired_tables_and_fields)

with open("phi_dict.txt", 'w') as f:
    f.write(str(desired_tables_and_fields))
