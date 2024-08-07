<%@ Page Language="c#" %>
<%@ Import namespace="System.IO"%>
<%@ Import namespace="System.Security.Principal"%>
<%@ Import namespace="Microsoft.Web.Administration"%>
<!DOCTYPE html>
<html lang="en">

<head>
	<title>Aras Instances</title>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<!--===============================================================================================-->
	<link rel="icon" type="image/png" href="images/icons/aras-favicon.ico" />
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/bootstrap/css/bootstrap.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="fonts/font-awesome-4.7.0/css/font-awesome.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/animate/animate.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/select2/select2.min.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="vendor/perfect-scrollbar/perfect-scrollbar.css">
	<!--===============================================================================================-->
	<link rel="stylesheet" type="text/css" href="css/util.css">
	<link rel="stylesheet" type="text/css" href="css/main.css">
	<!--===============================================================================================-->
	<!-- 
		choose or customize a stylesheet to style the page background 
		find stylesheets in ArasHomepage/css/
	-->
	<link rel="stylesheet" type="text/css" href="css/aras.css">
	<!--===============================================================================================-->
</head>

<body>
	<nav class="navbar navbar-toggleable-md navbar-dark bg-dark" style="flex-direction: column;align-items: flex-start;">
		<!-- Navbar content -->
		 <a class="navbar-brand" href="#"> 
			<!-- Get serverName -->
			<%
				//Get serverName
				string serverName = System.Environment.MachineName;
				//string e2 = "<a class='navbar-brand' " + serverName + "</a>";
				Response.Write(serverName);
			%>
		 </a> 
			
		<ul class="nav justify-content-end">
			<li class="nav-item dropdown">
				<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">Aras Resources</a>

				<div class="dropdown-menu">
					<!-- Build a list of secondary links to display as dropdown items -->
					<%
						// create a dictionary of links you want to show in the aras dropdown list
						Dictionary<string,string> links_aras = new Dictionary<string,string>();
						links_aras["Aras Community"] = "https://community.aras.com/";
						links_aras["Aras Community Projects"] = "https://community.aras.com/p/projects";
						links_aras["ArasLabs Blog"] = "https://community.aras.com/aras-labs/";
						links_aras["ArasLabs GitHub"] = "https://github.com/ArasLabs";
						links_aras["MyInnovator"] = "https://MyInnovator.com/";
						links_aras["Subscriber Portal"] = "http://www.aras.com/SubscriberPortal/SubscriberLogon.aspx?ReturnUrl=%2fsubscriberportal%2fsupport.aspx";
						links_aras["Aras Roadmap"] = "https://www.aras.com/plm-roadmap/";
						links_aras["Aras Downloads"] = "https://www.aras.com/support/downloads/";

						foreach (KeyValuePair<string,string> link in links_aras)
						{
							string el = "<a class='dropdown-item' href='" + link.Value + "' target='_new'>" + link.Key + "</a>";
							Response.Write(el);
						}
					%>
				</div>
			</li>

			<!-- Build a list of primary links to display across the nav bar -->
			<%
				// create a dictionary of links you want to show in the nav bar
				Dictionary<string,string> links = new Dictionary<string,string>();
				/*
				links["MyInnovator"] = "https://MyInnovator.com/";
				links["GitHub"] = "https://github.com/";
				links["Labs Blog"] = "http://community.aras.com/en/category/technique/aras-labs/";
				*/

				foreach (KeyValuePair<string,string> link in links)
				{
					string el = "<li class='nav-item'><a class='nav-link' href='" + link.Value + "' target='_new'>" + link.Key + "</a></li>";
					Response.Write(el);
				}
			%>
				
		</ul>

	</nav>
	<div class="limiter">
		<div class="logo">
			<img src="images/aras-logo.svg">
		</div>
		<div class="container-table100">
			<div class="wrap-table100">
				<div class="table100">
					<table>
						<thead>
							<tr class="table100-head">
								<th class="column1">Instance name</th>
								<th class="column2">Nash</th>
								<th class="column3">Admin</th>
							</tr>
						</thead>
						<tbody>
							<%
								using (WindowsIdentity.GetCurrent().Impersonate())
								{									
									// Get all of the Innovator applications from IIS
									using (Microsoft.Web.Administration.ServerManager sm = new Microsoft.Web.Administration.ServerManager()) 
									{
										foreach (var site in sm.Sites) 
										{
											// We're using nested loops, but we're also expecting a small number of Sites
											// (typically only Default Web Site) so it's fine 
											foreach(var app in site.Applications) 
											{
												// Get the root virtual directory (i.e. not the Client, Server, Vault, etc.)
												string physicalPath = app.VirtualDirectories["/"].PhysicalPath;
												bool isInnovatorApplication = physicalPath.Trim('\\').EndsWith("Innovator");
												
												// Add all of our Innovator applications to a table for easy access
												if (isInnovatorApplication)
												{
													string appName = app.Path.Substring(1);
													string appPath = ".." + app.Path;
													string nashPath = appPath + "/Client/Scripts/nash.aspx";
													string adminPath = appPath + "/?username=admin";
													string row = "" +
														"<tr class='table100-head'>" +
														"	<td class='column1'>" +
														"		<a href='{0}' target='_new'>{3}</a>" +
														"	</td>" +
														"	<td class='column2'>" + 
														"		<a href='{1}' target='_new'>Run Nash</a>" +
														"	</td>" +
														"	<td class='column3'>" +
														"		<a href='{2}' target='_new'>Login as Admin</a>" + 
														"	</td>" +
														"</tr>";
													row = string.Format(row, appPath, nashPath, adminPath, appName);

													Response.Write(row);
												}
											}
										}
									}
								}
							%>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
	<!--===============================================================================================-->
	<script src="vendor/jquery/jquery-3.2.1.min.js"></script>
	<!--===============================================================================================-->
	<script src="vendor/bootstrap/js/popper.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>
	<!--===============================================================================================-->
	<script src="vendor/select2/select2.min.js"></script>
	<!--===============================================================================================-->
	<script src="js/main.js"></script>
</body>

</html>