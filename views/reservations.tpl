% include('header.tpl')

<div class="container-fluid">
	% if result:
	% for item in result:
	<div class="row pt-3" id="item{{item[4]}}">
		<div class="col-lg-6 offset-lg-3 text-center">
		<div class="card mb-3">				
  		<div class="row no-gutters">
    	<div class="col-lg-2 align-self-center text-center">
      <a href="/lijst/{{item[9]}}"><img src="{{item[3]}}" class="card-img img-responsive" alt="{{item[2]}}"></a>
    </div>
    <div class="col-lg-10">
      <div class="card-body">
        <h5 class="card-title">{{item[2]}}</h5>
        <ul class="list-group list-group-flush">
					<li class="list-group-item">{{translation["reservationBought"]}}: {{item[0]}}</li>
					<li class="list-group-item wrap text-left">{{item[1]}}</li>
				</ul>
      </div>
			<div class="card-footer text-muted">
					<button type="button" class="btn btn-secondary" disabled><span class="fas"></span>{{item[8]}}</button>
				%if item[6]>1:
					<button type="button" class="btn btn-secondary" disabled><span class="fas"></span>{{item[6]}} {{translation["reservationPieces"]}}</button>
				%end
				%if item[5]=="option1":
					<button type="button" class="btn btn-secondary" disabled><span class="fas"></span>{{translation["reservationOption1"]}}</button>
				%elif item[5]=="option2":
					<button type="button" class="btn btn-secondary" disabled><span class="fas"></span>{{translation["reservationOption2"]}}</button>
				%else:
					<button type="button" class="btn btn-secondary" disabled><span class="fas"></span>{{translation["reservationOption3"]}}</button>
				%end
				<button type="button" class="btn btn-secondary" disabled><a href="/reservations/delete/{{item[7]}}" onclick="return confirm('{{translation["reservationAreYouSure"]}}"?');"><span class="fas fa-trash category" title="{{translation["listIconDelete"]}}"></span></a></button>
			</div>
    </div>
  </div>
	</div>
	</div>
	</div>
	% end
	% else:
	<div class="row">
		<div class="col-lg-6 offset-lg-3 text-center mt-3">
			<button class="btn btn-secondary">{{translation["listNoItems"]}}</button>
		</div>
	</div>
	% end
</div>

% include('footer.tpl')