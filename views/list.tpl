% include('header.tpl')
% setdefault('order','category, price asc')
% setdefault('visible','1')
% setdefault('bought','0')
<div class="container-fluid">
	<div class="row pt-3">
		<div class="col-lg-12 pt-3 pb-3 welcome-text">
			<p class="green">{{translation["listWelcome1"]}}</p>
  		    <p class="green">{{translation["listWelcome2"]}}</p>
			<p class="green">{{translation["listWelcome3"]}}</p>
		</div>
	</div>
	<div class="row pt-3">
		<div class="col-lg-12">
			<form class="form-inline" method="POST" action="/list">
				<label class="mb-2 mr-sm-2" for="sort">{{translation["listSortBy"]}}: </label>
				<select class="form-control mb-2 mr-sm-2" name="sort">
					<option value="bought asc, name asc" {{"selected" if order=="bought asc, name asc" else ""}}>{{translation["listSortName"]}}</option>
					<option value="url asc" {{"selected" if order=="url asc" else ""}}>{{translation["listSortShop"]}}</option>
					<option value="price asc, name asc" {{"selected" if order=="price asc, name asc" else ""}}>{{translation["listSortPriceAsc"]}}</option>
					<option value="price desc, name asc" {{"selected" if order=="price desc, name asc" else ""}}>{{translation["listSortPriceDesc"]}}</option>
					<option value="favo desc, bought asc, name asc" {{"selected" if order=="favo desc, bought asc, name asc" else ""}}>{{translation["listSortFavo"]}}</option>
					%if role =="admin":
					<option value="bought asc, id desc" {{"selected" if order=="bought asc, id desc" else ""}}>{{translation["listSortLatest"]}}</option>
					%end
				</select>
				% if role=="admin":
				<div class="form-check form-check-inline ml-4 mb-2 mr-sm-2">
  				<input class="form-check-input" type="radio" name="visible" id="inlineRadio1" value="1" {{"checked" if visible=="1" else ""}}>
					<label class="form-check-label" for="inlineRadio1">{{translation["listFilterVisible"]}}</label>
				</div>
				<div class="form-check form-check-inline mb-2 mr-sm-2">
					<input class="form-check-input" type="radio" name="visible" id="inlineRadio2" value="0" {{"checked" if visible=="0" else ""}}>
					<label class="form-check-label" for="inlineRadio2">{{translation["listFilterInvisible"]}}</label>
				</div>
				<div class="form-check form-check-inline mb-2 mr-sm-2">
					<input class="form-check-input" type="radio" name="visible" id="inlineRadio2" value="2" {{"checked" if visible=="2" else ""}}>
					<label class="form-check-label" for="inlineRadio2">{{translation["listFilterBoth"]}}</label>
				</div>
				% end
				<button type="submit" class="btn btn-secondary mb-2 ml-4">{{translation["listSort"]}}</button>
			</form>
		</div>
	</div>
	<div class="row">
	% for item in result:
	% from urllib.parse import urlparse
	% hostname = '{uri.netloc}'.format(uri=urlparse(item[4]))
	<div class="card col-lg-3 text-center {{"text-white bg-secondary" if item[8]==item[9] else ""}}">
		<div class="card-header text-right">
			% if item[7]==1 and role=="user":
				<button type="button" class="btn btn-danger" disabled><span class="fas fa-star"></span>{{translation["listSortFavo"]}}</button>
			% elif item[7]==1 and role=="admin":
				<button type="button" class="btn btn-danger" disabled><span class="fas fa-star"></span></button>
			% end
			<button type="button" class="btn {{"btn-light" if item[8]==item[9] else "btn-secondary"}}" disabled>{{hostname[4:100]}}</button>
			% if role=="admin":
			% if item[10]==0:
				<button type="button" class="btn btn-info" disabled><a href="/list/hide/{{item[0]}}"><span class="fas fa-eye category" title="{{translation["listIconVisible"]}}"></span></a></button>
			% else:
				<button type="button" class="btn btn-info" disabled><a href="/list/hide/{{item[0]}}"><span class="fas fa-eye-slash category" title="{{translation["listIconInvisible"]}}"></span></a></button>
			% end
			<button type="button" class="btn btn-info" disabled><a href="/list/favo/{{item[0]}}"><span class="fas fa-star category" title="{{translation["listIconFavo"]}}"></span></a></button>
			<button type="button" class="btn btn-info" disabled><a href="/create/{{item[0]}}"><span class="fas fa-pen category" title="{{translation["listIconChange"]}}"></span></a></button>
			<button type="button" class="btn btn-info" disabled><a href="/list/delete/{{item[0]}}" onclick="return confirm('{{translation["listAreYouSure"]}}?');"><span class="fas fa-trash category" title="{{translation["listIconDelete"]}}"></span></a></button>
			% end
		</div>
		<a href="/list/{{item[0]}}"><img class="card-img-top img-responsive mx-auto img-top" src="{{item[5]}}" alt="{{item[2]}}"></a>
		<div class="card-body">
			<h5 class="card-title">
				{{item[2]}}
			% if item[8]-item[9]>1:
				<span class="btn bg-secondary">{{item[8]}}</span>
			% end
			</h5>
			<ul class="list-group list-group-flush wrap">
				% descr = item[3][:100].rfind(".")+1
				% if descr==0:
				% descr = item[3][:300].rfind(".")+1
				% end
				<li class="list-group-item {{"list-group-item-secondary" if item[8]==item[9] else ""}}">{{item[3]}}</li>
				<li class="list-group-item {{"list-group-item-secondary" if item[8]==item[9] else ""}}">{{"%.2f" % item[6]}} {{translation["currency"]}}</li>
			</ul>
			
		</div>
		<div class="card-footer text-muted">
			% if item[8]==item[9]:
				<a href="#" class="btn bg-light">{{translation["listSold"]}}</a>
			% else:
				<a href="/list/{{item[0]}}" class="btn bg-navigation">{{translation["listWatch"]}}</a>
			% end
		</div>
	</div>
	%end
	</div>
	% if not result:
	<div class="row">
		<div class="col-lg-6 offset-lg-3 text-center mt-3">
			<button class="btn btn-secondary">{{translation["listNoItems"]}}</button>
		</div>
	</div>
	% end
</div>

% include('footer.tpl')


