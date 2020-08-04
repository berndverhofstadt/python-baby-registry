% setdefault('role', 'user')
<!DOCTYPE HTML>
<html>
<head>
    <meta http-equiv="Content-type" content="text/html;charset=utf-8" />
    <meta charset="UTF-8">
    <title>{{config.TITLE}}</title>
    <meta name="Description" content="BC">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous" />
    <script src="https://kit.fontawesome.com/1f77bd986c.js" crossorigin="anonymous"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link id="main" rel="stylesheet" type="text/css" href="/static/css/publisher.css" />
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-navigation">
    <a class="navbar-brand" href="/"><img src="/static/img/logo.png" width="120" alt=""></a>
	<span class="navbar-text title-text"><h1>{{config.TITLE}}</h1></span>
    % if role=="admin":
	    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
        <div class="navbar-nav navbar-right">
                <a class="nav-item nav-link" href="/reservations">{{translation["menuReservations"]}}</a>
                <a class="nav-item nav-link" href="/create">{{translation["menuAddItem"]}}</a>
                <a class="nav-item nav-link" href="/admin">{{translation["menuUsers"]}}</a>
                <a class="nav-item nav-link" href="/logout">{{translation["menuLogout"]}}</a>
        </div>
        </div>
    % end
</nav>
