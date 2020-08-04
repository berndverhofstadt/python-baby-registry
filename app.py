from beaker.middleware import SessionMiddleware
import bottle
from bottle import route, template, static_file, post, request, redirect, run, error
from cork import Cork
from cork.backends import SQLiteBackend
import datetime
import email.message
from email import encoders
import imaplib
import json
import mysql.connector
import os
from os.path import join, dirname
import platform
import requests
import smtplib
import sqlite3
import time


''' Init Path and Python version'''
os.chdir(os.path.dirname(__file__))
appPath = dirname(__file__)
version = platform.python_version()


''' Initialize config'''
if os.path.exists("config/config.py"):
	import config.config as config
else:
	import config.startup as config


''' Initialize translation'''
with open('translations/{lang}.json'.format(lang=config.LANG), 'r') as read_file:
	translation = json.load(read_file)


''' Initialize authentication'''
aaa = Cork(backend=SQLiteBackend('baby.db'))
authorize = aaa.make_auth_decorator(fail_redirect="/login", role="user")


''' Functions'''
def show_current_user_role():
	session = bottle.request.environ.get('beaker.session')
	if aaa.user_is_anonymous:
		return "anonymous"
	else:
		return aaa.current_user.role


def connect():
	return sqlite3.connect('baby.db')


''' Initialize Bottle Application and Beaker Session'''
bottle_app = bottle.app()
session_opts = {
	'session.cookie_expires': config.SESSION_OPTIONS["cookie_expires"],
	'session.encrypt_key': os.urandom(16),
	'session.httponly': config.SESSION_OPTIONS["httponly"],
	'session.timeout': config.SESSION_OPTIONS["timeout"],
	'session.type': config.SESSION_OPTIONS["type"],
	'session.validate_key': True,
}
bottle_app = SessionMiddleware(bottle_app, session_opts)


''' Routes '''


@route('/')
def index():
	redirect('list')


@route('/admin')
@authorize(role="admin", fail_redirect='/sorry')
def admin():
	aaa.require(role='admin', fail_redirect='/sorry')
	admin = dict(
			current_user=aaa.current_user,
			users=aaa.list_users(),
			roles=aaa.list_roles()
	)
	return template('admin', admin=admin, version=version, role=show_current_user_role(), config=config,
					translation=translation)


@post('/create')
@authorize(role="admin")
def index():
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute(
		"INSERT INTO baby_list (name, category, description, url, image, price, favo, wanted, bought, visible) VALUES (?,?,?,?,?,?,?,?,?,?)", (
		request.forms.get('name'), "none", request.forms.get('description'), request.forms.get('url'), request.forms.get('img'),
		request.forms.get('price'), 0, request.forms.get('wanted'), 0, 1))
	last_id = cursor.lastrowid
	mydb.commit()
	cursor.close()
	mydb.close()
	redirect("/list/{id}".format(id=last_id))


@post('/create/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("UPDATE baby_list SET name=?, description=?, url=?, image=?, price=?, wanted=? WHERE id = ?",
				   (request.forms.get('name'), request.forms.get('description'), request.forms.get('url'),
					request.forms.get('img'), request.forms.get('price'), request.forms.get('wanted'), id))
	mydb.commit()
	cursor.close()
	mydb.close()
	redirect("/list/{id}".format(id=id))


@route('/create')
@authorize(role="admin")
def index():
	result = {}
	return template('add', result=result, version=version, role=show_current_user_role(), config=config,
					translation=translation)


@route('/create/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT * FROM baby_list WHERE id=?", (id,))
	result = cursor.fetchone()
	cursor.close()
	mydb.close()
	return template('add', result=result, version=version, role=show_current_user_role(), config=config,
					translation=translation)


@post('/create_user')
@authorize(role="admin", fail_redirect='/sorry')
def create_user():
	password = request.POST.get('password').strip()
	user = request.POST.get('name').strip()
	role = request.POST.get('role').strip()
	description = request.POST.get('description').strip()
	aaa.create_user(user, role, password, None, description)
	redirect("/admin")


@route('/delete_user/<user>')
def delete_user(user):
	aaa.delete_user(user)
	redirect("/admin")


@post('/list')
@authorize(role="user")
def index():
	order = request.forms.get('sort')
	visible = request.forms.get('visible')
	mydb = connect()
	cursor = mydb.cursor()
	if show_current_user_role() == "admin":
		if visible != "2":
			cursor.execute("SELECT * FROM baby_list WHERE visible=? ORDER BY {order}".format(order=order), (visible,))
		else:
			cursor.execute("SELECT * FROM baby_list ORDER BY {order}".format(order=order))
	else:
		cursor.execute("SELECT * FROM baby_list WHERE visible = 1 ORDER BY {order}".format(order=order))
	result = cursor.fetchall()
	cursor.close()
	mydb.close()
	return template('list', result=result, order=order, visible=visible, version=version, role=show_current_user_role(),
					config=config, translation=translation)


@route('/list')
@authorize(role="user")
def index():
	mydb = connect()
	cursor = mydb.cursor()
	if show_current_user_role() == "admin":
		cursor.execute("SELECT * FROM baby_list WHERE visible = 1 ORDER BY price ASC, name ASC")
	else:
		cursor.execute("SELECT * FROM baby_list WHERE visible = 1 ORDER BY bought ASC, name ASC")
	result = cursor.fetchall()
	cursor.close()
	mydb.close()
	return template('list', result=result, version=version, role=show_current_user_role(), config=config,
					translation=translation)


@post('/list/<id>')
@authorize(role="user")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT * FROM baby_list WHERE id=?", (id,))
	result = cursor.fetchall()

	if request.forms.get('type') == "option3":
		payload = '<p>{emailHeading}</p><p>{emailReserved} <a href="{baseURL}/list/{id}" target="_blank">{item}</a>.</p><p>{emailOption3} {bank}.</p><p>{emailChangedMind}</p><p>{emailThanks}<br />{babyName}</p>'.format(
			emailHeading=translation["emailHeading"], emailReserved=translation["emailReserved"],
			baseURL=config.BASE_URL, id=id, item=result[0][2], emailOption3=translation["emailOption3"], bank=config.BANKDETAILS,
			emailChangedMind=translation["emailChangedMind"], emailThanks=translation["emailThanks"],
			babyName=config.BABY_FIRSTNAME)

	else:
		payload = '<p>{emailHeading}</p><p>{emailReserved} <a href="{baseURL}/list/{id}" target="_blank">{item}</a>.</p><p>{emailChangedMind}</p><p>{emailThanks}<br />{babyName}</p>'.format(
			emailHeading=translation["emailHeading"], emailReserved=translation["emailReserved"],
			baseURL=config.BASE_URL, id=id, item=result[0][2], emailChangedMind=translation["emailChangedMind"],
			emailThanks=translation["emailThanks"],	babyName=config.BABY_FIRSTNAME)

	if result[0][8] - result[0][9] > 0:
		cursor.execute("UPDATE baby_list SET bought=bought+? WHERE id=?", (request.forms.get('number'), id))
		cursor.execute(
			"INSERT INTO baby_reservations (name, email, message, item, type, number, delivered) VALUES (?,?,?,?,?,?,?)", (
			request.forms.get('name'), request.forms.get('email'), request.forms.get('message'), id,
			request.forms.get('type'), request.forms.get('number'),0))
		mydb.commit()
		msg = email.message.Message()
		msg['Subject'] = translation["emailSubject"]
		msg['From'] = '{firstname} {lastname} <{email}>'.format(firstname=config.BABY_FIRSTNAME,lastname=config.BABY_LASTNAME,email=config.EMAIL)
		msg['To'] = request.forms.get('email')
		msg.add_header('Content-Type', 'text/html')
		msg.set_payload(payload)
		s = smtplib.SMTP_SSL(host=config.EMAILSMTP,port=config.EMAILSMTPPORT)
		s.login(config.EMAIL, config.EMAILPASSWD)
		s.sendmail(config.EMAIL, [msg['To']], msg.as_string().encode('utf8'))
		s.quit()
		imap = imaplib.IMAP4_SSL(config.EMAILIMAP, config.EMAILIMAPPORT)
		imap.login(config.EMAIL, config.EMAILPASSWD)
		imap.append(config.EMAILFOLDER, '\\Seen', imaplib.Time2Internaldate(time.time()), msg.as_string().encode('utf8'))
		imap.logout()
	cursor.close()
	mydb.close()
	buyer = {'name': request.forms.get('name'), 'email': request.forms.get('email')}

	return template('listdetail', result=result, id=id, buyer=buyer, type=request.forms.get('type'), version=version,
					role=show_current_user_role(), config=config, translation=translation)


@route('/list/<id>')
@authorize(role="user")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT * FROM baby_list WHERE id=?", (id,))
	result = cursor.fetchall()
	cursor.close()
	mydb.close()
	buyer = {}
	return template('listdetail', result=result, id=id, buyer=buyer, version=version, role=show_current_user_role(),
					config=config, translation=translation)

@route('/list/delete/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("DELETE FROM baby_list WHERE id=?",(id,))
	mydb.commit()
	cursor.close()
	mydb.close()
	redirect("/list")


@route('/list/hide/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT id, visible FROM baby_list WHERE id=?",(id,))
	result = cursor.fetchall()
	if result[0][1]==0:
		cursor.execute("UPDATE baby_list SET visible = 1 WHERE id=?",(id,))
	else:
		cursor.execute("UPDATE baby_list SET visible = 0 WHERE id=?",(id,))
	mydb.commit()
	cursor.close()
	mydb.close()
	redirect("/list")


@route('/list/favo/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT id, favo FROM baby_list WHERE id=?",(id,))
	result = cursor.fetchall()
	if result[0][1]==0:
		cursor.execute("UPDATE baby_list SET favo = 1 WHERE id=?",(id,))
	else:
		cursor.execute("UPDATE baby_list SET favo = 0 WHERE id=?",(id,))
	mydb.commit()
	cursor.close()
	mydb.close()
	redirect("/list")


@post('/login')
def login():
	password = request.POST.get('password').strip()
	username = request.POST.get('username').strip()
	aaa.login(username, password, success_redirect='/list', fail_redirect='/login')


@route('/login')
def login_form():
	return template('login', version=version, config=config, translation=translation)


@route('/logout')
def logout():
	aaa.logout(success_redirect='/')


@route('/reservations')
@authorize(role="admin")
def index():
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT a.name, a.message, b.name as item, b.image, b.id, a.type, a.number, a.id, a.date, a.item from baby_reservations a, baby_list b WHERE a.item = b.id ORDER BY a.date DESC")
	result = cursor.fetchall()
	cursor.close()
	mydb.close()
	return template('reservations', result=result, version=version, role=show_current_user_role(),
					config=config, translation=translation)


@route('/reservations/delete/<id>')
@authorize(role="admin")
def index(id):
	mydb = connect()
	cursor = mydb.cursor()
	cursor.execute("SELECT number,item FROM baby_reservations WHERE id = ?", (id,))
	result = cursor.fetchone()
	cursor.execute("UPDATE baby_list SET bought = bought-? WHERE id=?",(result[0],result[1]))
	cursor.execute("DELETE FROM baby_reservations WHERE id=?",(id,))
	mydb.commit()
	cursor.close()
	mydb.close()	
	redirect("/reservations")


@route('/sorry')
def index():
	return template('sorry', version=version, config=config, translation=translation)


@route('/static/<filepath:path>')
def server_static(filepath):
	return static_file(filepath, root='static')


@error(404)
def error404(error):
	redirect("/sorry")


# application = bottle_app
bottle.run(app=bottle_app, host='0.0.0.0', port=8020)