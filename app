import requests
from flask import Flask, render_template, request
import psycopg2
app = Flask(name)

conn = psycopg2.connect(database="service_db",
user="postgres",
password="123",
host="localhost",
port="5432")
cursor = conn.cursor()

@app.route('/login/', methods=['GET'])
def index():
    return render_template('login.html')

@app.route('/login/', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    cursor.execute("SELECT * FROM service.users WHERE login=%s AND password=%s", (str(username), str(password)))
    records = list(cursor.fetchall())
    if not username or not password:
        return render_template('login.html', error = "Введите имя пользователя и пароль")
    try:
        return render_template('account.html', full_name=records[0][1], username = username, password = password)
    except IndexError:
        return render_template('login.html', error = "Неверный логин или пароль")
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login</title>
</head>
<body>
<form action="" method="post">
  <p>
    <label for="username">Username</label>
    <input type="text" name="username">
  </p>
  <p>
    <label for="password">Password</label>
    <input type="password" name="password">
  </p>
  <p>
    <input type="submit">
    <form action=""method="post">{% if error %}<p>{{error}}!</p>{% endif %}</p>
  </p>
</form>
</body>
</html>
