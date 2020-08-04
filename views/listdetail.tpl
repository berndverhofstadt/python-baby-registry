% include('header.tpl')
% setdefault('bought', -1)
% from urllib.parse import urlparse
<div class="container-fluid">
	% for item in result:
	% hostname = '{uri.netloc}'.format(uri=urlparse(item[4]))
	% bought = item[9]
	<div class="row pt-3">
		<div class="col-lg-6 offset-lg-3 text-center">
		<div class="card mb-4">
  		<div class="row no-gutters">
    	<div class="col-lg-4 align-self-center text-center">
      <img src="{{item[5]}}" class="card-img img-responsive" alt="{{item[2]}}">
    </div>
    <div class="col-lg-8">
      <div class="card-body">
        <h5 class="card-title">{{item[2]}}</h5>
        <ul class="list-group list-group-flush">
					<li class="list-group-item wrap">{{item[3]}}</li>
					<li class="list-group-item"><a href="{{item[4]}}" target="_blank">{{translation["detailView"]}}</a></li>
					<li class="list-group-item">{{"%.2f" % item[6]}} {{translation["currency"]}}</li>
				</ul>
      </div>
    </div>
  </div>
</div>
	</div>
	</div>
	% end
	% if item[8]>bought and not buyer:
	<div class="row">
		<div class="col-lg-6 offset-lg-3">
		<form id="listdetail_form" action="/list/{{id}}" method="POST">
			<div class="form-check mb-4">
				<input class="form-check-input" type="radio" name="type" id="exampleRadios1" value="option1" checked>
				<label class="form-check-label" for="exampleRadios1"><span class="green">{{translation["detailOption1"]}}</span><br /><small class="text-muted">{{translation["detailOption1Tip"].format(webshop=hostname[4:100])}}</small></label>
			</div>
			<div class="form-check mb-4">
				<input class="form-check-input" type="radio" name="type" id="exampleRadios1" value="option2">
				<label class="form-check-label" for="exampleRadios1"><span class="green">{{translation["detailOption2"]}}</span><br /><small class="text-muted">{{translation["detailOption2Tip"].format(webshop=hostname[4:100],address=config.ADDRESS)}}</small></label>
			</div>
			<div class="form-check mb-4">
				<input class="form-check-input" type="radio" name="type" id="exampleRadios2" value="option3">
				<label class="form-check-label" for="exampleRadios2"><span class="green">{{translation["detailOption3"]}}</span><br /><small class="text-muted">Ik betaal via overschrijving.</small></label>
			</div>
			% if item[8]-item[9]>1:
			<div class="form-group">
				<label for="inputNumber">{{translation["detailNumber"]}}</label>
				<select class="form-control" name="number">
					%for x in range(1,item[8]-item[9]+1):
						<option value="{{x}}">{{x}}</option>
					% end
				</select>
			</div>
			% else:
				<input type="hidden" class="form-control" id="inputName" aria-describedby="nameHelp" placeholder="" name="number" value="1" required>
			% end
			<div class="form-group">
				<label for="inputName">{{translation["listSortName"]}}:</label>
    		<input type="text" class="form-control" id="inputName" aria-describedby="nameHelp" placeholder="" name="name" required>
			</div>
			<div class="form-group">
				<label for="inputEmail">{{translation["detailEmail"]}}:</label>
    		<input type="email" class="form-control" id="inputEmail" aria-describedby="emailHelp" placeholder="" name="email" required>
    		<small id="emailHelp" class="form-text text-muted">{{translation["detailConfirmation"]}}</small>
			</div>
			<div class="form-group">
				<label for="inputMessage">{{translation["detailMessage"]}}:</label>
    		<textarea class="form-control" id="inputMessage" rows="3" name="message"></textarea>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary">{{translation["detailSubmit"]}}</button>
				<small id="emailHelp" class="form-text text-muted">{{translation["detailSubmitTip"]}}</small>
			</div>
		</form>
		</div>
	</div>
	% elif buyer:
	<div class="row">
		<div class="col-lg-6 offset-lg-3 text-center">
			<p>{{translation["detailThanks"]}}</p>
			% if type!="option3":
				<p>{{translation["detailTransfer"]}}</p>
				<small class="text-muted">{{translation["detailSubmitTip"]}}</small>
				<script>var timer = setTimeout(function() {window.location='{{item[4]}}'}, 10000);</script>
			% else:
				<p>{{translation["detailBank"].format(bank=config.BANKDETAILS)}}</p>
				<small class="text-muted">{{translation["detailSubmitTip"]}}</small>
			% end
		</div>
	</div>
	% elif bought==-1:
	<div class="row">
		<div class="col-lg-6 offset-lg-3 text-center mt-3">
			<button class="btn btn-secondary">{{translation["detailNotExists"]}}</button>
		</div>
	</div>
	% else:
	<div class="row">
		<div class="col-lg-6 offset-lg-3 text-center mt-3">
			<button class="btn btn-secondary">{{translation["detailAlreadyReserved"]}}</button>
		</div>
	</div>
	%end

% include('footer.tpl')