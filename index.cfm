<!DOCTYPE html>
<html>
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<link rel="stylesheet" href="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.css">
		<script src="http://code.jquery.com/jquery-1.11.1.min.js"></script>
		<script src="http://code.jquery.com/mobile/1.4.5/jquery.mobile-1.4.5.min.js"></script>
		<link href='http://fonts.googleapis.com/css?family=Droid+Serif' rel='stylesheet' type='text/css'>
		<style>
			.btn {
				width : 50px !important;
			}
			
			.custom-class {
				height : auto !important;
			}
			
			.ui-widget-overlay {
			    opacity: 0.7;
			    background-color: #000000;
			}
			
		</style>
	</head>
	<body>
		<div data-role="page">
		  <div data-role="header">
		    <h1>My notes</h1>
		  </div>
		  <div data-role="main" class="ui-content">
		    <a href="#popupDialog" data-rel="popup" data-position-to="window" data-transition="flip" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-btn-icon-left ui-icon-plus">Add</a>
		  </div>
		  <div data-role="popup" id="popupDialog">
		      <div data-role="header">
		        <h1>New note</h1>
		      </div>
		      <div data-role="main" class="ui-content">
		      		<div data-role="fieldcontain">
		      			<label for="name"></label>
			        	<input type="text" name="name" id="name" placeholder="Title" />
			        </div>
			        <div data-role="fieldcontain">
						<label for="description"></label>
						<textarea cols="multiple"  rows="8" name="description" id="description" class="custom-class" placeholder="Description"></textarea>
					</div>
			        <a id="backBtn" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-back ui-btn-icon-left" data-rel="back">Back</a>
			        <a id="doneBtn" class="ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-check ui-btn-icon-left" onclick="javascript:onDone();">Done</a>
		      </div>
		      <div data-role="footer">
		        <h1></h1>
		      </div>
		  </div>
		  
		  <div data-role="popup" id="note">
		      <div data-role="header">
		        <h1>Edit note</h1>
		      </div>
		      <div data-role="main" class="ui-content">
		      		<div data-role="fieldcontain">
		      			<label for="name"></label>
			        	<input type="text" name="name" id="noteTitle" placeholder="Title" />
			        </div>
			        <div data-role="fieldcontain">
						<label for="noteDescription"></label>
						<textarea cols="multiple"  rows="8" name="noteDescription" id="noteDescription" class="custom-class" placeholder="Description"></textarea>
					</div>
			        <a id="backBtn" class="btn ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-back ui-btn-icon-left" data-rel="back">Back</a>
			        <a id="submit" class="btn ui-btn ui-corner-all ui-shadow ui-btn-inline ui-icon-check ui-btn-icon-left" onclick="javascript:updateNote();">Done</a>
			        <a href="#" class="ui-btn ui-icon-delete ui-btn-icon-left" onclick="javascript:deleteNote();">Delete</a>
			        
		      </div>
		      <div data-role="footer">
		        <h1></h1>
		      </div>
		  </div>
		  
		  <div id="data" data-role="content" class="ui-content">
		  	<h2 style="font-family: 'Droid Serif', serif;"> List of notes </h2>
		  	<div id="listOfNotes">
		  	</div>
		  </div>
		  <div data-role="footer">
		    <h1></h1>
		  </div>
		 </div>
	</body>
</html>

<script type="text/javascript">
		
		var id;
		
		$(document).ready(function(){
			//deleteAllNotes();
			listAllNotes();
		});
		
		function onDone() {
			
			if(areFieldsEmpty() == false)
				invokeCFClientFunction("addNote",null,null,null);
			
			$("#popupDialog").popup("close");
		}
		
		function areFieldsEmpty()
		{
			if($("#name").val().trim().length == 0 && $("#description").val().trim().length == 0)
				return true;
				
			else return false; 
		}
		
		function openNote(obj)
		{
			var title,description;
			id = obj.id.replace("table","");
			//alert(typeof id);
			
			$("#" + obj.id).find(".title").each(function(index){
				title = $(this).html();
			})
			
			$("#" + obj.id).find(".description").each(function(index){
				description = $(this).html();
			})
			
			$("#noteTitle").val(title);
			$("#noteDescription").val(description);
			$("#note").popup("open");
		}
		
		function updateNote()
		{
			var title = $("#noteTitle").val();
			var description = $("#noteDescription").val();
			
			//alert(Number(id));
			invokeCFClientFunction("update",title,description,id,null,null);
			$("#note").popup("close");
			$("#listOfNotes").empty();
			listAllNotes();
		}
		
		function deleteNote()
		{
			var title = $("#noteTitle").val();
			var description = $("#noteDescription").val();
			alert(id);
			invokeCFClientFunction("remove",id,null,null);
			$("#note").popup("close");
			$("#listOfNotes").empty();
			listAllNotes();
		}
</script>

<cfclient>

	<cfset numofNotes = 1 />
	
	<cfquery datasource="notesDB">
		create table if not exists note (
			id integer primary key,
			title text,
			description text
		)
	</cfquery>
	<!---<cfset deleteAllNotes()>--->
	
	<cffunction name="listAllNotes">
		
		<cfset numofNotes = 1>
		<cfset html = "">
		<cfquery datasource="notesDB" name="resultSet">
			SELECT id,title, description FROM note;
		</cfquery>
		
		<cfloop query="resultSet">
			<cfoutput>
				<cfsavecontent variable="rowHtml">
					<br />
					<hr />
					<br />
					<div>
					<a href="##">
					<table id=table#id# onclick="openNote(this)" data-role="table" data-mode="columntoggle" class="ui-responsive ui-table ui-table-reflow" border="1">
				  		<thead style="font-family: 'Droid Serif', serif; font-size: 20px">
				  			<tr>
				  				<th data-priority="1" class="title">#title# <span style="padding-left:95%"></span><img src="icons/delete.png" /></th>		
				  			</tr>
				  		</thead>	
						<tbody  style="font-family: 'Droid Serif', serif; font-size: 15px">
							<tr>
								<td class="description">#description#</td>
							</tr>
						</tbody>
				  	</table>
				  	</a>
				  	</div>
				</cfsavecontent>
			</cfoutput>
			<cfset html = html & rowHtml>
		</cfloop>
		<cfset document.getElementById("listOfNotes").innerHTML += html>
	</cffunction>
	
	<cffunction name="addRow">
		<cfargument name="title">
		<cfargument name="description">
		
		<cfoutput>
			<cfsavecontent variable="rowHtml">
				<br />
				<hr />
				<br />
				<div>
				<a href="##">
				<table id=table#numofNotes# onclick="openNote(this)" data-role="table" data-mode="columntoggle" class="ui-responsive ui-table ui-table-reflow" border="1">
			  		<thead style="font-family: 'Droid Serif', serif; font-size: 20px">
			  			<tr>
			  				<th data-priority="1" class="title">#title#</th>
			  			</tr>
			  		</thead>	
					<tbody  style="font-family: 'Droid Serif', serif; font-size: 15px">
						<tr>
							<td class="description">#description#</td>
						</tr>
					</tbody>
			  	</table>
			  	</a>
			  	</div>
			</cfsavecontent>
		</cfoutput>
		
		<cfset numofNotes = numofNotes + 1 />
		
		<cfset document.getElementById("listOfNotes").innerHTML += rowHtml>
	</cffunction>
	
	<cffunction name="addNote">
		<cfset var title = document.getElementById("name").value>
		<cfset var description = document.getElementById("description").value>
		
		<cfquery datasource="notesDB">
			insert into note (title,description) values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#description#">
			)
		</cfquery>
		
		<cfset addRow(title,description)>
	</cffunction>
	
	<cffunction name="deleteAllNotes">
		<cfquery datasource="notesDB">
			DELETE FROM note; 
		</cfquery>
	</cffunction>
	
	<cffunction name="remove" >
		<cfargument name="noteId" >
		<cfoutput>
			<cfquery datasource="notesDB">
				DELETE FROM note WHERE id = #noteId#; 
			</cfquery>
		</cfoutput>
	</cffunction>
	
	<cffunction name="update">
		<cfargument name="noteTitle">
		<cfargument name="noteDesc">
		<cfargument name="noteId">
		<cfoutput>
			<cfquery datasource="notesDB">
				UPDATE note SET title=<cfqueryparam 
                            value="#noteTitle#" 
                            CFSQLType="CF_SQL_VARCHAR" >, 
                            description=<cfqueryparam 
                            value="#noteDesc#" 
                            CFSQLType="cf_sql_varchar"> 
                            WHERE id = <cfqueryparam 
                            value="#noteId#" 
                            CFSQLType="cf_sql_numeric">;
			</cfquery>
		</cfoutput>
	</cffunction>
</cfclient>	

