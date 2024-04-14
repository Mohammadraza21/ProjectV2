from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL


import MySQLdb.cursors
import re

app = Flask(__name__)

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = '1a2b3c4d5e6d7g8h9i10'

# Enter your database connection details below
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'Password'
app.config['MYSQL_DB'] = 'health_fitness_club'


# Intialize MySQL
mysql = MySQL(app)

# http://localhost:5000/health_fitness_club/login
# This will be the login page


@app.route('/', methods=['GET', 'POST'])
def login():
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        password = request.form['password']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute(
            'SELECT * FROM accounts WHERE username = %s AND password = %s', (username, password))

        account = cursor.fetchone()

        if account:

            session['loggedin'] = True
            session['id'] = account['user_id']
            session['username'] = account['username']
            session['role'] = account['role']
            session['usernum'] = account['member_id']

            if account['role'] == 'admin':
                return redirect(url_for('admindashboard'))
            elif account['role'] == 'trainer':
                return redirect(url_for('trainerdashboard'))
            elif account['role'] == 'member':
                return redirect(url_for('memberdashboard'))

        else:

            flash("Incorrect username/password!", "danger")
    return render_template('auth/login.html', title="Login")


# http://localhost:5000/health_fitness_club/register
# This will be the register page
@app.route('/register', methods=['GET', 'POST'])
def register():

    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form and 'phone_number' in request.form and 'address' in request.form and 'firstname' in request.form and 'lastname' in request.form and 'confirmpassword' in request.form and 'gender' in request.form:
        phone_number = request.form['phone_number']
        address = request.form['address']
        firstname = request.form['firstname']
        lastname = request.form['lastname']
        email = request.form['email']
        username = request.form['username']
        password = request.form['password']
        confirmpassword = request.form['confirmpassword']
        gender = request.form['gender']
        birthdate = request.form['birthdate']

        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cursor.execute(
            "SELECT * FROM accounts WHERE username LIKE %s", [username])
        account = cursor.fetchone()

        if account:
            flash("Account already exists!", "danger")
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            flash("Invalid email address!", "danger")
        elif not re.match(r'[A-Za-z0-9]+', username):
            flash("Username must contain only characters and numbers!", "danger")
        elif len(password) < 6:
            flash("Password must be at least 6 characters long", "danger")
        elif not re.match(r'^[a-zA-Z0-9]+', password):
            flash("Password must only contain alphabets and digits!", "danger")
        elif password != confirmpassword:
            flash("Passwords do not match!", "danger")
        elif not username or not password or not email:
            flash("Incorrect username/password!", "danger")
        else:

            cursor.execute(
                'INSERT INTO Members (email, first_name, last_name, gender, birthdate, phone_number, address) VALUES ( %s, %s, %s,  %s, %s, %s,  %s)', (email, firstname, lastname, gender, birthdate, phone_number, address,))
            cursor.execute(
                'INSERT INTO accounts (username, password, role) VALUES (%s, %s, %s)', (username, password, 'member',))
            mysql.connection.commit()
            flash("You have successfully registered!", "success")
            return redirect(url_for('login'))

    elif request.method == 'POST':

        flash("Please fill out the form!", "danger")

    return render_template('auth/register.html', title="Register")


# http://localhost:5000/pythinlogin/logout
# This will be the logout page
@app.route('/logout')
def logout():
    if 'loggedin' in session:
        session.pop('loggedin', None)
        session.pop('id', None)
        session.pop('username', None)

        flash("Logged out successfully", "success")

    return redirect(url_for('login'))


# http://localhost:5000/pythinlogin/members
# This will be the home page, only accessible for loggedin members, trainers, admin
@app.route('/member/home')
def memberdashboard():
    if 'loggedin' in session:
        if session.get('role') == 'member':
            return render_template('member/home.html', username=session['username'], title="Home")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))
    else:
        return redirect(url_for('login'))


@app.route('/member/profile')
def memberprofile():

    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM accounts WHERE user_id = %s',
                       (session['id'],))
        account = cursor.fetchone()
        cursor.close()

        return render_template('member/profile.html', account=account, title="Member Profile")

    return redirect(url_for('login'))


@app.route('/member/schedules')
def memberschedules():

    if 'loggedin' in session:
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
        cursor.execute('SELECT * FROM accounts WHERE user_id = %s',
                       (session['id'],))
        account = cursor.fetchone()
        cursor.close()

        return render_template('member/schedule.html', account=account, title="Member Schedules")

    return redirect(url_for('login'))


@app.route('/member/home/routines', methods=['GET', 'POST'])
def exerciseroutines():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('SELECT * FROM exercise_routines WHERE member_id = %s',
                           (session['usernum'],))
            stats = cursor.fetchall()
            cursor.close()

            return render_template('member/exercise_routines.html', stats=stats, title="Exercise Routines")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/home/fitnessgoals', methods=['GET', 'POST'])
def fitnessgoals():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            if request.method == 'GET':
                cursor.execute('SELECT * FROM goals WHERE member_id = %s',
                               (session['usernum'],))
                stats = cursor.fetchall()
                cursor.close()

                return render_template('member/fitness_goals.html', stats=stats, title="Fitness Goals")
            else:
                if 'goal_type' in request.form or 'startdate' in request.form or 'enddate' in request.form or 'target_value' in request.form or 'progress' in request.form:
                    goal_type = request.form['goal_type']
                    start_date = request.form['startdate']
                    end_date = request.form['enddate']
                    target_value = request.form['target_value']
                    progress = request.form['progress']
                    goal_notes = request.form['goalnotes']
                    member_id = session['usernum']

                    cursor.execute(
                        'INSERT INTO Goals (member_id, goal_type, target_value, start_date, end_date, progress, notes) VALUES (%s, %s, %s, %s, %s, %s, %s)', (member_id, goal_type, target_value, start_date, end_date, progress, goal_notes,))

                    mysql.connection.commit()
                    flash("Fitness goals added successfully!", "success")

                    cursor.close()
                    return redirect(url_for('fitnessgoals'))
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/home/achievements', methods=['GET', 'POST'])
def fitnessachievements():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            if request.method == "GET":

                cursor.execute(
                    'SELECT goal_id, goal_type FROM goals WHERE member_id = %s', (session['usernum'],))
                goals = cursor.fetchall()

                cursor.execute('SELECT DISTINCT achievement_date, achievement_description, goal_type, start_date, target_value '
                               'FROM fitness_achievements JOIN goals ON fitness_achievements.member_id = goals.member_id '
                               'WHERE fitness_achievements.member_id = %s',
                               (session['usernum'],))
                stats = cursor.fetchall()

                cursor.close()

                return render_template('member/fitness_achievements.html', goals=goals, stats=stats, title="Fitness Achievements")
            else:
                goal_id = request.form['goal_id']
                achievement_date = request.form['achievement_date']
                achievement_description = request.form['achievement_description']

                cursor.execute(
                    'INSERT INTO fitness_achievements (member_id, goal_id, achievement_date, achievement_description) VALUES (%s, %s, %s, %s)', (session['usernum'], goal_id, achievement_date, achievement_description,))

                mysql.connection.commit()
                flash("Fitness achievement added successfully!", "success")

                cursor.close()
                return redirect(url_for('fitnessachievements'))

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/home/healthstats', methods=['GET'])
def healthstatistics():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            if request.method == "GET":
                cursor.execute('SELECT * FROM Health_Statistics WHERE member_id = %s',
                               (session['usernum'],))
                stats = cursor.fetchall()
                cursor.close()

                return render_template('member/health_metrics.html', stats=stats, title="Health Metrics")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/profile/update', methods=['GET', 'POST'])
def updateprofile():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute('SELECT * FROM accounts WHERE user_id = %s',
                           (session['id'],))
            account = cursor.fetchone()
            cursor.close()

            return render_template('member/profile.html', account=account, title="Update Profile")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/profile/health-metrics', methods=['GET', 'POST'])
def healthmetrics():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            if request.method == "POST" and 'date' in request.form or 'weight' in request.form or 'height' in request.form or 'body_fat_percentage' in request.form or 'blood_pressure_systolic' in request.form or 'blood_pressure_diastolic' in request.form or 'resting_heart_rate' in request.form or 'notes' in request.form:
                date = request.form['date']
                weight = request.form['weight']
                height = request.form['height']
                body_fat_percentage = request.form['body_fat_percentage']
                blood_pressure_systolic = request.form['blood_pressure_systolic']
                blood_pressure_diastolic = request.form['blood_pressure_diastolic']
                resting_heart_rate = request.form['resting_heart_rate']
                notes = request.form['notes']

                member_id = session['usernum']

                cursor.execute(
                    'INSERT INTO Health_Statistics (member_id, date, weight, height, body_fat_percentage, blood_pressure_systolic, blood_pressure_diastolic, resting_heart_rate, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)', (member_id, date, weight, height, body_fat_percentage, blood_pressure_systolic, blood_pressure_diastolic, resting_heart_rate, notes,))

                mysql.connection.commit()
                flash("Health stats added!", "success")

                cursor.close()
                return redirect(url_for('healthmetrics'))

            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('SELECT * FROM Health_Statistics WHERE member_id = %s',
                               (session['usernum'],))
                stats = cursor.fetchall()
                cursor.close()

            return render_template('member/health_metrics.html', stats=stats, title="Health Metrics")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/schedule/personal-sessions', methods=['GET', 'POST'])
def personalsessions():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("SELECT session_id, concat(trainers.first_name, ' ', trainers.last_name) AS Trainer, session_type, session_date, start_time, end_time, class_id, member_id "
                           "FROM sessions "
                           "JOIN Trainers on sessions.trainer_id=Trainers.trainer_id "
                           "WHERE member_id= % s", (session['usernum'],))
            data = cursor.fetchall()
            cursor.close()

            return render_template('member/schedule.html', sessions=data, title="Workout Sessions")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/member/schedule/group-sessions', methods=['GET', 'POST'])
def groupsessions():

    if 'loggedin' in session:
        if session.get('role') == 'member':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
            cursor.execute("SELECT class_name, class_day, concat(trainers.first_name, ' ', trainers.last_name) AS Trainer, session_type, session_date, start_time, end_time "
                           "FROM Class_members "
                           "LEFT JOIN Classes on Classes.class_id = class_members.class_id "
                           "JOIN Trainers on Classes.trainer_id = Trainers.trainer_id "
                           "JOIN sessions on Class_members.class_id = sessions.class_id "
                           "WHERE class_members.member_id= %s", (session['usernum'],))
            data = cursor.fetchall()
            cursor.close()

            return render_template('member/group_schedule.html', sessions=data, title="Workout Sessions")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))

# http://localhost:5000/trainers
# This will be the home page, only accessible for loggedin trainers, admin


@app.route('/trainer/home')
def trainerdashboard():
    if 'loggedin' in session:
        if session.get('role') == 'trainer':  # Check if user's role is 'member'
            return render_template('trainer/home.html', username=session['username'], title="Home")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))
    else:
        return redirect(url_for('login'))


@app.route('/trainer/class-management', methods=['GET', 'POST'])
def class_management():

    if 'loggedin' in session:
        if session.get('role') == 'trainer':
            if request.method == "POST":
                class_name = request.form['class_name']
                max_capacity = request.form['max_capacity']
                class_date = request.form['class_date']
                class_time = request.form['class_time']
                class_duration = request.form['class_duration']
                class_description = request.form['class_description']

                trainer_id = session['usernum']

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute(
                    'INSERT INTO Classes (class_name, description, class_date, class_time, duration_min, max_capacity, trainer_id) VALUES (%s, %s, %s, %s, %s, %s, %s)', (class_name, class_description, class_date, class_time, class_duration, max_capacity, trainer_id,))

                mysql.connection.commit()
                cursor.close()
                flash("Class details added successfully!", "success")

                return redirect(url_for('class_management'))

            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('SELECT * FROM Classes WHERE trainer_id = %s',
                               (session['usernum'],))
                stats = cursor.fetchall()
                cursor.close()

                return render_template('trainer/class_management.html', stats=stats, title="Class Management")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/trainer/schedule_management', methods=['GET', 'POST'])
def schedule_management():
    if 'loggedin' in session:
        if session.get('role') == 'trainer':
            if request.method == "GET":
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute('SELECT sessions.*, classes.class_day, classes.class_name '
                               'FROM sessions JOIN Classes ON sessions.trainer_id = classes.trainer_id '
                               'AND sessions.class_id = classes.class_id '
                               'WHERE sessions.trainer_id = %s', (session['usernum'],))

                schedule = cursor.fetchall()
                cursor.execute(
                    'SELECT class_id, class_name FROM classes WHERE trainer_id = %s', (session['usernum'],))
                classes = cursor.fetchall()

                cursor.close()
                return render_template('trainer/schedule_management.html', schedule=schedule, classes=classes, title="Schedule Management")
            else:
                session_type = request.form['session_type']
                session_date = request.form['session_date']
                start_time = request.form['start_time']
                end_time = request.form['end_time']
                class_id = request.form['class_id']

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute(
                    'INSERT INTO sessions (trainer_id, session_type, session_date, start_time, end_time, class_id) VALUES (%s, %s, %s, %s, %s, %s)', (session['usernum'], session_type, session_date, start_time, end_time, class_id,))

                mysql.connection.commit()

                cursor.close()

                flash("Schedule updated successfully!", "success")

                return redirect(url_for('schedule_management'))
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))
    return redirect(url_for('login'))


@app.route('/trainer/view_profile', methods=['GET', 'POST'])
def view_member_profile():
    if 'loggedin' in session:
        if session.get('role') == 'trainer':
            cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

            if request.method == "POST":
                member_name = request.form['member_name']
                cursor.execute(
                    'SELECT * FROM members WHERE CONCAT(first_name, " ", last_name) LIKE %s', (f"%{member_name}%",))
                members = cursor.fetchall()
                cursor.close()
                return render_template('trainer/view_member_profile.html', data=members, title="View Member Profile")
            else:
                cursor.execute('SELECT * FROM members')
                members = cursor.fetchall()
                cursor.close()
                return render_template('trainer/view_member_profile.html', data=members, title="View Member Profile")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))
    return redirect(url_for('login'))


# http://localhost:5000/admin/home
# This will be the home page, only accessible for loggedin  admin
@app.route('/admin/home')
def admindashboard():
    if 'loggedin' in session:
        if session.get('role') == 'admin':  # Check if user's role is 'admin'
            return render_template('admin/home.html', username=session['username'], title="Home")
        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))
    else:
        return redirect(url_for('login'))


@app.route('/admin/class-management', methods=['GET', 'POST'])
def admin_class_management():

    if 'loggedin' in session:
        if session.get('role') == 'admin':
            if request.method == "POST":
                class_name = request.form['class_name']
                max_capacity = request.form['max_capacity']
                class_date = request.form['class_date']
                class_time = request.form['class_time']
                class_duration = request.form['class_duration']
                class_description = request.form['class_description']

                trainer_id = session['usernum']

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute(
                    'INSERT INTO Classes (class_name, description, class_date, class_time, duration_min, max_capacity, trainer_id) VALUES (%s, %s, %s, %s, %s, %s, %s)', (class_name, class_description, class_date, class_time, class_duration, max_capacity, trainer_id,))

                mysql.connection.commit()
                cursor.close()
                flash("Class details added successfully!", "success")

                return redirect(url_for('class_management'))

            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute('SELECT * FROM Classes',
                               )
                stats = cursor.fetchall()
                cursor.close()

                return render_template('admin/class_management.html', stats=stats, title="Class Management")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/admin/equipment-management', methods=['GET', 'POST'])
def admin_equip_management():

    if 'loggedin' in session:
        if session.get('role') == 'admin':

            if request.method == "POST":
                equipment_name = request.form['equipment_name']
                current_condition = request.form['current_condition']
                last_maintenance_date = request.form['last_maintenance_date']
                last_maintenance_description = request.form['last_maintenance_description']

                admin_id = session['usernum']

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute(
                    'INSERT INTO equipment_maintenance (admin_id, equipment_name, last_maintenance_description, last_maintenance_date, current_condition) VALUES (%s, %s, %s, %s, %s)', (admin_id, equipment_name, last_maintenance_description, last_maintenance_date, current_condition))

                mysql.connection.commit()
                cursor.close()
                flash("Equipment maintenance details added successfully!", "success")

                return redirect(url_for('admin_equip_management'))

            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)
                cursor.execute(
                    'SELECT * FROM equipment_maintenance WHERE admin_id = %s', (session['usernum'],))
                data = cursor.fetchall()
                cursor.close()

                return render_template('admin/equipment_management.html', equipments=data, title="Equipment Management")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/admin/payments-management', methods=['GET', 'POST'])
def admin_payments_management():
    if 'loggedin' in session:
        if session.get('role') == 'admin':
            admin_id = session['usernum']

            if request.method == "POST":
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                member_id = request.form['member_id']
                payment_date = request.form['payment_date']
                amount = request.form['amount']
                payment_method = request.form['payment_method']
                description = request.form['description']

                cursor.execute(
                    'INSERT INTO payments (member_id, payment_date, amount, payment_method, description) VALUES (%s, %s, %s, %s, %s)', (member_id, payment_date, amount, payment_method, description))

                mysql.connection.commit()
                cursor.close()
                flash("Payment details added successfully!", "success")

                return redirect(url_for('admin_payments_management'))
            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute(
                    "select payments.*, concat(first_name, ' ', last_name) as membername from payments JOIN members on payments.member_id = members.member_id")
                data = cursor.fetchall()

                cursor.execute(
                    "SELECT member_id, concat(first_name, ' ', last_name) as membername from members")
                members = cursor.fetchall()

                cursor.close()

                return render_template('admin/payment_management.html', payments=data, members=members, title="Payments Management")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/admin/rooms-management', methods=['GET', 'POST'])
def admin_rooms_management():

    if 'loggedin' in session:
        if session.get('role') == 'admin':
            if request.method == "POST":

                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                if request.form.get('_method') == 'DELETE':
                    booking_id = request.form.get('booking_id')

                    cursor.execute(
                        'DELETE FROM room_bookings WHERE booking_id = %s', (booking_id,))
                    mysql.connection.commit()

                    flash("Room booking deleted successfully!", "danger")
                else:
                    class_id = request.form['class_id']
                    room_name = request.form['room_name']
                    booking_date = request.form['booking_date']
                    booking_from_time = request.form['from_time']
                    booking_to_time = request.form['to_time']
                    room_status = request.form['room_status']

                    cursor.execute(
                        'INSERT INTO room_bookings (class_id, room, booking_date, from_time, to_time, status) VALUES (%s, %s, %s, %s, %s, %s)', (class_id, room_name, booking_date, booking_from_time, booking_to_time, room_status,))
                    cursor.close()

                    flash("Room bookings details added successfully!", "success")
                    mysql.connection.commit()
                    return redirect(url_for('admin_rooms_management', title="Room Bookings"))

            else:
                cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

                cursor.execute(
                    'SELECT room_bookings.*, classes.class_name FROM room_bookings JOIN classes ON classes.class_id = room_bookings.class_id')
                data = cursor.fetchall()

                cursor.execute('SELECT class_id, class_name FROM classes')
                classes = cursor.fetchall()

                cursor.close()

                return render_template('admin/rooms_management.html', classes=classes, rooms=data, title="Room Bookings Management")

        else:
            flash("Access denied! You are not authorized to access this page.", "danger")
            return redirect(url_for('login'))

    return redirect(url_for('login'))


@app.route('/admin/update-room/<int:booking_id>', methods=['POST', 'GET'])
def update_room(booking_id):
    if 'loggedin' in session and session.get('role') == 'admin':
        cursor = mysql.connection.cursor(MySQLdb.cursors.DictCursor)

        cursor.execute(
            "SELECT * FROM room_bookings WHERE booking_id = %s", (booking_id,))
        room = cursor.fetchone()

        if request.method == 'POST':
            class_id = request.form['class_id']
            room_name = request.form['room_name']
            booking_date = request.form['booking_date']
            booking_from_time = request.form['from_time']
            booking_to_time = request.form['to_time']
            room_status = request.form['room_status']

            cursor.execute(
                'UPDATE room_bookings SET class_id = %s, room = %s, booking_date = %s, from_time = %s, to_time = %s, status = %s WHERE booking_id = %s',
                (class_id, room_name, booking_date, booking_from_time, booking_to_time, room_status, booking_id))
            mysql.connection.commit()

            flash("Room bookings updated successfully!", "success")

        else:
            cursor.execute(
                'SELECT room_bookings.*, classes.class_name FROM room_bookings JOIN classes ON classes.class_id = room_bookings.class_id')
            data = cursor.fetchall()

            cursor.execute('SELECT class_id, class_name FROM classes')
            classes = cursor.fetchall()

            cursor.close()

            return render_template('admin/rooms_management.html', classes=classes, rooms=data, title="Room Bookings Management")

    else:
        flash("Access denied! You are not authorized to perform this action.", "danger")

    return redirect(url_for('admin_rooms_management'))


if __name__ == '__main__':
    app.run(debug=True)
