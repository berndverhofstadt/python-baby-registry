# Python Baby Registry
 A self-hosted baby registry written in Python using bottle for routing, bottle-cork for authentication and sqlite for data storage.

## Installation
Install the necessary modules from requirements.txt, pull this repository and run it:
```
python3.x app.py
```
The app will be accessible on http://ip.address:8020

Uncomment 
```
# application = bottle_app
```
and comment
```
bottle.run(app=bottle_app, host='0.0.0.0', port=8020)
```
if you want to run the app using wsgi.

## Configuration

The config file is self-explanatory and can be found here:
```
config/startup.py
```
The translation folder contains an English and a Dutch version of the app.

## Dockerized

Steps to run container:
1. Install tools and dependencies via [https://www.docker.com/blog/how-to-dockerize-your-python-applications/].  
1. Build image
1. Start container

## Login

Default credentials are "admin" & "admin"  
To view as a buyer, you can use "user" & "user"  
Please update credentials!

## Notes
SMTP config not tested in combination with dockerfile.