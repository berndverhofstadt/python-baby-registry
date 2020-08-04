% include('header.tpl')

<div class="container-fluid">
	<div class="row pt-3">
        % for user in admin["users"]:
        <div class="card col-lg-4 text-center">
            <div class="card-body">
                <h5 class="card-title">Username: {{user[0]}}</h5>
                <h6 class="card-subtitle mb-2 text-muted">Role: {{user[1]}}</h6>
                <p class="card-text">{{user[3]}}</p>
            </div>
            <div class="card-footer text-muted">
				<a href="/delete_user/{{user[0]}}" class="btn bg-light">{{translation["adminDelUser"]}}</a>
		    </div>
        </div>
        %end

        <div class="card col-lg-4">
            <form id="create_user" action="/create_user" method="POST">
            <div class="card-body">

                <div class="form-group">
                    <label for="inputName">Username</label>
                    <input type="text" class="form-control" id="inputName" aria-describedby="nameHelp" placeholder="" name="name" required>
                </div>
                <div class="form-group">
                    <label for="inputName">Password</label>
                    <input type="password" class="form-control" id="inputPassword" aria-describedby="nameHelp" placeholder="" name="password" required>
                </div>
                <div class="form-group">
                    <label for="inputRole">Role</label>
                    <select class="form-control" name="role">
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
			    </div>
                <div class="form-group">
                    <label for="inputDescr">Description</label>
                    <input type="text" class="form-control" id="inputName" aria-describedby="nameHelp" placeholder="" name="description" required>
                </div>
            </div>
            <div class="card-footer text-muted">
                <div class="form-group">
                    <button type="submit" class="btn btn-primary">{{translation["adminCreateUser"]}}</button>
                </div>
		    </div>
		    </form>
        </div>
    </div>
</div>

% include('footer.tpl')