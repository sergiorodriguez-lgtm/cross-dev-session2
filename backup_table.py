import os
import csv
from azure.data.tables import TableServiceClient

def backup_table_to_csv():
    # Load the local Floci-AZ connection string
    conn_str = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
    service = TableServiceClient.from_connection_string(conn_str)
    
    # Connect to the local emulated table
    table_client = service.get_table_client("Users")
    
    output_file = 'users_backup.csv'
    
    # Query entities and write to CSV
    with open(output_file, mode='w', newline='') as file:
        writer = csv.writer(file)
        writer.writerow(['PartitionKey', 'RowKey', 'Name', 'Status'])
        
        for entity in table_client.list_entities():
            writer.writerow([
                entity.get('PartitionKey'),
                entity.get('RowKey'),
                entity.get('Name'),
                entity.get('Status')
            ])
            
    print(f"Backup successfully completed: {output_file}")

if __name__ == "__main__":
    backup_table_to_csv()