# MAIN APP IMPLEMENTATION

from flask import Flask, render_template, request, redirect, url_for, session
from flask_wtf.csrf import CSRFProtect
from mysql.connector import connect, Error
from datetime import timedelta
import bcrypt
import re

# Global Flask App Initialization
app = Flask(__name__)
app.secret_key = '-=gyr6sfkhw$+mt+yx9x@o&aey)h=fg80k$+4a*#$lsmuf-$-('
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(days=1)
csrf = CSRFProtect(app)

# Global MYSQL connection and cursor
try:
    connection = connect(host = "mydb",
                         user = "root",
                         password = "password",
                         database = "rail")
except Error as e:
    print(e)

cursor = connection.cursor()

# SELECT QUERY
# Input: Valid sql select query string
# Output: List of tuples first element column names
def select(selectQuery):
    try:
        cursor.execute(selectQuery)
        return [cursor.column_names] + cursor.fetchall()
    except Error as e:
        print(e)

# INSERT QUERY
# insertQuery: Valid sql insert query FORMAT STRING
# data: tuple
# return: boolean
def insert(insertQuery, data):
    try:
        cursor.execute(insertQuery, data)
        connection.commit()
        return True
    except Error as e:
        print(e)
        return False

# DELETE QUERY
# Input: Valid sql delete query string
# Output: List of tuples first element column names
def delete(deleteQuery):
    try:
        cursor.execute(deleteQuery)
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

# Root
@app.route('/', methods=["GET", "POST"])
def root():
    # Adds route to logged in user using route id
    if request.method == "POST" and session.get('loggedIn'):
        insert("""
               INSERT INTO user_routes
               (user_id, route_id)
               VALUES (%s, %s)
               """, (session.get('id'), request.form.get('route_id')))
        return redirect(url_for('root'))

    else:
        # Print all available routes if search string is in arrival or destination name
        search = request.args.get('search').strip() if request.args.get('search') is not None else ""
        query = f"""
            SELECT
                routes.id AS `Route No.`,
                departure_locations.location_name AS Departure,
                arrival_locations.location_name AS Arrival,
                departure_datetime AS 'Departure Time',
                arrival_datetime AS 'Arrival Time',
                price AS Price
            FROM routes
            JOIN locations AS departure_locations
                ON routes.departure_id = departure_locations.id
            JOIN locations AS arrival_locations
                ON routes.arrival_id = arrival_locations.id
            WHERE departure_locations.location_name LIKE '%{search}%' OR arrival_locations.location_name LIKE '%{search}%'
            """

        return render_template('root.html', data=html_table(select(query)))

# Login
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        
        # Fetch user that matches email
        # Email field is UNIQUE
        cursor.execute(f"""
                        SELECT * FROM users
                        WHERE email = '{request.form.get("email").strip()}'
                        """)

        account = cursor.fetchone()
        
        # Check given password with stored bcrypt hash string
        if account and bcrypt.checkpw(request.form.get('password').strip().encode('utf-8'), account[4].encode('utf-8')):
            session['loggedIn'] = True
            session['id'] = account[0]
            session['name'] = account[1] + ' ' + account[2]
            session['email'] = account[3]
            return redirect(url_for('root'))

    return render_template('login.html')

# Logout
@app.route('/logout')
def logout():
    # Pop all session variables
    session.pop('loggedIn', None)
    session.pop('id', None)
    session.pop('name', None)
    session.pop('email', None)

    return redirect(url_for('root'))

# Register
@app.route('/register', methods=['GET', 'POST'])
def register():
    # Trying to register with register form
    if request.method == "POST":
        # Check if all fields are filled and email is correct format
        if (request.form.get('first_name').strip() and
            request.form.get('last_name').strip() and
            request.form.get('password').strip() and
            re.fullmatch(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b', request.form.get('email').strip())):
            insert_success = insert("""
               INSERT INTO users(first_name, last_name, email, password)
               VALUES (%s, %s, %s, %s)
               """, (request.form.get('first_name').strip(),
                   request.form.get('last_name').strip(),
                   request.form.get('email').strip(),
                   bcrypt.hashpw(request.form.get('password').strip().encode('utf-8'), bcrypt.gensalt())))
        
            # Redirect to automatic login with credentials if successful insert
            if insert_success:
                return redirect(url_for('login'), code=307) 

    return render_template('register.html')

# Home
@app.route('/home', methods=['GET', 'POST'])
def home():
    # If trying to access /home without being logged in
    # Redirect to login page
    if session.get('loggedIn') is None:
        return redirect(url_for('login'))

    # Trying to drop route
    elif request.method == "POST":
        delete(f"""
                DELETE FROM user_routes
                WHERE user_id={session.get('id')} AND route_id = {request.form.get('route_id').strip()}
                """)

        return redirect(url_for('home'))
    
    else:
        search = request.args.get('search').strip() if request.args.get('search') is not None else ""
        
        return render_template('home.html', data=html_table(select(
            # Get all routes for user with search string inside arrival or departure name
            f"""
            SELECT
                `Route No.`,
                Departure,
                Arrival,
                `Departure Time`,
                `Arrival Time`,
                Price
            FROM view_all_routes            
            WHERE `User No.`={session.get('id')} AND (Departure LIKE '%{search}%' OR Arrival LIKE '%{search}%')
             """)) + "\n<br>\n" + html_table(select(
            # Get sum of all prices of routes for user
            f"""
            SELECT
                SUM(Price) AS Total
            FROM view_all_routes
            GROUP BY `User No.`
            HAVING `User No.`={session.get('id')}
             """)))

# Delete Account
@app.route('/delete-account')
def delete_account():
    # Delete user from users table
    # Cascades to user_routes table
    delete(f"""
                DELETE FROM users
                WHERE id={session.get('id')}
                """)

    return redirect(url_for('logout'))
