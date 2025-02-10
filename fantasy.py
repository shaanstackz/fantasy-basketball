# Import necessary libraries
from flask import Flask, render_template, redirect, url_for, request
from flask_login import LoginManager, UserMixin, login_user, logout_user, login_required
from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired
from nba_api.stats.endpoints import playergamelog
from sportsreference.ncaab.roster import Roster
from sportsreference.ncaab.teams import Teams

# Import Registration Form
from forms import RegistrationForm

# Initialize Flask application
app = Flask(__name__)
app.secret_key = 'your_secret_key_here'

# Initialize Flask-Login
login_manager = LoginManager()
login_manager.init_app(app)

# Mock user database
users = {'user1': {'password': 'password1'}, 'user2': {'password': 'password2'}}

# User class for Flask-Login
class User(UserMixin):
    pass

@login_manager.user_loader
def load_user(user_id):
    user = User()
    user.id = user_id
    return user

# Login form
class LoginForm(FlaskForm):
    username = StringField('Username', validators=[DataRequired()])
    password = PasswordField('Password', validators=[DataRequired()])
    submit = SubmitField('Login')

# Register route
@app.route('/register', methods=['GET', 'POST'])
def register():
    form = RegistrationForm()
    if form.validate_on_submit():
        hashed_password = bcrypt.generate_password_hash(form.password.data).decode('utf-8')
        user = User(username=form.username.data, email=form.email.data, password=hashed_password)
        db.session.add(user)
        db.session.commit()
        return redirect(url_for('login'))
    return render_template('register.html', form=form)

# NBA player statistics route
@app.route('/nba_player_stats')
@login_required
def nba_player_stats():
    # Example: Fetch player game log for LeBron James
    player_id = '2544'  # LeBron James's player ID
    gamelog = playergamelog.PlayerGameLog(player_id=player_id)
    gamelog_df = gamelog.get_data_frames()[0]
    return render_template('nba_player_stats.html', gamelog=gamelog_df)

# College basketball player statistics route
@app.route('/college_player_stats')
@login_required
def college_player_stats():
    # Example: Fetch player statistics for Duke Blue Devils
    duke = Teams('DUKE')
    players_data = []
    for player in duke.players:
        players_data.append({'name': player.name, 'points': player.points})
    return render_template('college_player_stats.html', players_data=players_data)

# Login route
@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        username = form.username.data
        password = form.password.data
        # Check if the user exists and the password is correct
        if username in users and users[username]['password'] == password:
            user = User()
            user.id = username
            login_user(user)
            return redirect(url_for('dashboard'))
        else:
            return 'Invalid username or password'
    return render_template('login.html', form=form)

# Dashboard route
@app.route('/dashboard')
@login_required
def dashboard():
    return render_template('dashboard.html')

# Logout route
@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('index'))

# Index route
@app.route('/')
def index():
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug=True)
