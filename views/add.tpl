% include('header.tpl')
% setdefault('wanted','0')

<div class="container-fluid">
	<div class="row pt-3">
		<div class="col-lg-6 offset-lg-3">
		<form id="add_form" action="/create{{"/{id}".format(id=result[0]) if result else ""}}" method="POST">
			<div class="form-group">
				<label for="inputName">{{translation["createName"]}}</label>
    		<input type="text" class="form-control" id="inputName" aria-describedby="nameHelp" placeholder="" name="name" value="{{result[2] if result else ""}}" required>
			</div>
			<div class="form-group">
				<label for="inputDescr">{{translation["createDescr"]}}</label>
    		<textarea class="form-control" id="inputDescr" rows="3" name="description" required>{{result[3] if result else ""}}</textarea>
			</div>
			<div class="form-group">
				<label for="inputURL">{{translation["createUrl"]}}</label>
    		<input type="text" class="form-control" id="inputURL" aria-describedby="urlHelp" placeholder="" name="url" value="{{result[4] if result else ""}}" required>
			</div>
			<div class="form-group">
				<label for="inputImg">{{translation["createImg"]}}</label>
    		<input type="text" class="form-control" id="inputImg" aria-describedby="imgHelp" placeholder="" name="img" value="{{result[5] if result else ""}}" required>
			</div>
			<div class="form-group">
				<label for="inputPrice">{{translation["createPrice"]}}</label>
    		<input type="text" class="form-control" id="inputPrice" aria-describedby="priceHelp" placeholder="xx.xx" name="price" value="{{result[6] if result else ""}}" required>
			</div>
			<div class="form-group">
				<label for="inputWanted">{{translation["createNumber"]}}</label>
				
				<select class="form-control" name="wanted">
					% if result:
					<option value="1" {{"selected" if result[8]==1 else ""}}>1</option>
					<option value="2" {{"selected" if result[8]==2 else ""}}>2</option>
					<option value="3" {{"selected" if result[8]==3 else ""}}>3</option>
					<option value="4" {{"selected" if result[8]==4 else ""}}>4</option>
					% else:
					<option value="1" selected>1</option>
					<option value="2">2</option>
					<option value="3">3</option>
					<option value="4">4</option>
					% end
				</select>
			</div>
			<div class="form-group">
				<button type="submit" class="btn btn-primary">{{translation["createChange"] if result else translation["createAdd"]}}</button>
			</div>
		</form>
		</div>
	</div>
</div>
% include('footer.tpl')
