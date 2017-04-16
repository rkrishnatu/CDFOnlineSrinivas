<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
<html>
	<head>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript (ECMAScript)">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<script language="C#" runat="server">
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Page used to Delete any Record from the DataBase
			// QueryStrings: 
			//		"T"   = Type (i.e. posting or Topic)
			//		"ID"  = Record ID to Delete
			//		"TID" = TopicID (fro Postings)
			//		"S"   = Subject (for Postings)
			// Build DELETE statement based on Type
			
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			
			// Build SQL String
			string strDELETE = "DELETE * FROM ";
			string strURL;
			
			if (Request.QueryString["T"] == "T") //Topic
				{
					strDELETE += "topics WHERE TopicID = " + Request.QueryString["ID"];
					strURL = "topics.aspx";
				}
			else
				{
					strDELETE += "postings WHERE PostID = " + Request.QueryString["ID"];
					strURL = "Postings.aspx?ID=" + Request.QueryString["TID"] + "&S=" + Request.QueryString["S"];
				}
			
			try
				{	
					// create a new OleDbConnection object using the connection string
					OleDbConnection objConnect = new OleDbConnection(strConnect);

					// open the connection to the database
					objConnect.Open();

					// create a new OleDbCommand using the connection object and select statement
					OleDbCommand objCommand = new OleDbCommand(strDELETE, objConnect);

					// execute the SQL statement
					objCommand.ExecuteNonQuery();

					// close the Connection
					objConnect.Close();
					
					Response.Redirect(strURL);
				}
			catch (Exception objError) 
				{
					//display error details
					outError.InnerHtml = "<b>Error while accessing data</b>.<br />"	+ objError.Message + "<br />" + objError.Source;
				}
		}
		</script>
	</head>
	<body MS_POSITIONING="GridLayout">
		<div id="outError" runat="server">
		</div>
	</body>
</html>
    </asp:Content>


