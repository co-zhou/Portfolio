from flask import Flask, render_template, request, redirect, url_for
from mysql.connector import connect, Error

app = Flask(__name__)
try:
    connection = connect(host = "mydb",
                         user = "root",
                         password = "password",
                         database = "rail")
except Error as e:
    print(e)

cursor = connection.cursor()

def select(selectQuery):
    try:
        cursor.execute(selectQuery)
        return [cursor.column_names] + cursor.fetchall()
    except Error as e:
        print(e)

def insert(insertQuery, data):
    try:
        cursor.execute(insertQuery, data)
        connection.commit()
    except Error as e:
        print(e)

# Converts a 2D matrix into an html formatted table
# Column names are also inserted into index 0
# Args: List of tuples
# Return: String
def html_table(data):
    table = "<table>\n"

    for row in data:
        table += "<tr>\n"
        for column in row:
            table += f"<th>{column}</th>\n"
        table += "</tr>\n"

    return table + "</table>"    

@app.route('/', methods=["GET", "POST"])
def root():
    if request.method == "POST":
        insert("""
               INSERT INTO user_routes
               (user_id, route_id)
               VALUES (%s, %s)
               """, (request.form.get('user_id'), request.form.get('route_id')))
        return redirect(url_for('root'))

    else:
        search = request.args.get('search').strip() if request.args.get('search') is not None else ""

        query = ""
        if search:
            query = f"""
            SELECT * FROM view_all_routes
            WHERE Departure LIKE '%{search}%' OR Arrival LIKE '%{search}%'
            """
        else:
            query= """
            SELECT
                routes.id AS No,
                departure.location_name AS Departure,
                arrival.location_name AS Arrival,
                departure_datetime AS 'Departure Time',
                arrival_datetime AS 'Arrival Time',
                price AS Price
            FROM routes
            JOIN locations AS departure
                ON routes.departure_id = departure.id
            JOIN locations AS arrival
                ON routes.arrival_id = arrival.id;
            """

        return render_template('root.html', data=html_table(select(query)))

@app.route('/users', methods=['GET', 'POST'])
def users():
    if request.method == "POST":
        insert("""
               INSERT INTO users(first_name, last_name)
               VALUES (%s, %s)
               """, (request.form.get('first_name'), request.form.get('last_name')))
        return redirect(url_for('users'))

    else:
        search = request.args.get('search').strip() if request.args.get('search') is not None else ""
        
        if search:
            return render_template('users.html', data=html_table(select(
            f"""
            SELECT * 
            FROM view_all_users            
            WHERE Name LIKE '%{search}%'
            """)) + "\n<br>\n" + html_table(select(
            f"""
            SELECT
                No,
                Name,
                SUM(Price) AS Total
            FROM view_all_users
            GROUP BY No
            HAVING Name LIKE '%{search}%'
            """)))

        else:
            query = """
            SELECT
                id AS No,
                CONCAT(first_name, ' ', last_name) AS Name
            FROM users
            """
            
            return render_template('users.html', data=html_table(select(query)))
