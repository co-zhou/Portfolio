import random
import datetime
from faker import Faker
from mysql.connector import connect, Error

fake = Faker(['en_US'])

def create_db():
    with open('rail_tables.sql', 'r') as sql_file:
        result_iterator = cursor.execute(sql_file.read(), multi=True)
        for res in result_iterator:
            print("Running query: ", res)
            print(f"Affected {res.rowcount} rows" )

if __name__ == '__main__':
    try:
        connection = connect(host = "mydb",
                             user = "root",
                             password = "password",
                             database = "rail")
    except Error as e:
        print(e)
    
    cursor = connection.cursor()
   
    create_db()
    
    ## INSERT INTO USERS
    insert_users_query = """
    INSERT INTO users
    (first_name, last_name)
    VALUES (%s, %s)
    """

    numUsers = 100
    data = []
    for i in range(numUsers):
        data.append((fake.first_name(), fake.last_name()))

    cursor.executemany(insert_users_query, data)
    
    ## INSERT INTO LOCATIONS
    insert_locations_query = """
    INSERT INTO locations
    (location_name)
    VALUES (%s)
    """

    numLocations = 20
    data = []
    for i in range(numLocations):
        data.append([fake.city()])

    cursor.executemany(insert_locations_query, data)

    ## INSERT INTO ROUTES
    insert_routes_query = """
    INSERT INTO routes
    (departure_id, arrival_id, departure_datetime, arrival_datetime, price)
    VALUES (%s, %s, %s, %s, %s)
    """

    numRoutes = 20
    data = []
    for i in range(numRoutes):
        id1 = 0
        id2 = 0
        while id1 == id2:
            id1 = random.randint(1, numLocations)
            id2 = random.randint(1, numLocations)
        departure = fake.future_datetime()
        data.append((id1,
                     id2,
                     departure,
                     departure + datetime.timedelta(seconds=random.randint(1800, 18000)),
                     round(random.uniform(1.00, 99.99), 2)))
   
    cursor.executemany(insert_routes_query, data)

    ## INSERT INTO USER_ROUTES
    insert_user_routes_query = """
    INSERT INTO user_routes
    (user_id, route_id)
    VALUES (%s, %s)
    """

    numUserRoutes = 200
    data = []
    for i in range(numUserRoutes):
        temp = (random.randint(1, numUsers), random.randint(1, numRoutes))
        while temp in data:
            temp = (random.randint(1, numUsers), random.randint(1, numRoutes))
        data.append(temp)
   
    cursor.executemany(insert_user_routes_query, data)

    connection.commit()
    cursor.close()
    connection.close()
