% include('header.tpl')

<div class="container-fluid">
  <div class="row pt-3">
		<div class="col-lg-6 offset-lg-3">
		<form id="listdetail_form" action="/login" method="POST">
		    <div class="form-group">
				<label for="inputName">{{translation["loginInputUser"]}}:</label>
    		    <input type="text" class="form-control" id="inputCode" aria-describedby="userHelp" placeholder="" name="username" required>
    		    <small id="codeHelp" class="form-text text-muted">{{translation["loginUser"]}}</small>
    		</div>
			<div class="form-group">
				<label for="inputCode">{{translation["loginInputCode"]}}:</label>
    		    <input type="text" class="form-control" id="inputCode" aria-describedby="codeHelp" placeholder="" name="password" required>
    		    <small id="codeHelp" class="form-text text-muted">{{translation["loginCode"]}}</small>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary">Login</button>
			</div>
		</form>
		</div>
	</div>
</div>

% include('footer.tpl')