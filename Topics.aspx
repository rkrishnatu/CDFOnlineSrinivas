<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>All Topics</h1>
                <h2></h2>
            </hgroup>
            <p>
                
            </p>
        </div>
    </section>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">

    <HTML>
	<HEAD>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript (ECMAScript)">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="style.css" rel="stylesheet" type="text/css">

		<script language="C#" runat="server">

		public void Page_Load(object sender, System.EventArgs e)
		{
			if (Session["UserName"] == null && Request.QueryString["guest"] != "yes")
			{
				Response.Redirect("Login.aspx");
			}

            var user = Session["UserName"] != null ? Session["UserName"] : "Guest";
			welcome.InnerHtml = "Welcome " + user + ", choose a topic to see the postings.<P><P>";
			ListTopics();
		}

		public void ListTopics()
		{
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			string strSelect = "SELECT * FROM topics ORDER BY TopicCreateDate DESC";

			try 
			{

				//create a new OleDbConnection object using the connection string
				OleDbConnection objConnect = new OleDbConnection(strConnect);

				//open the connection to the database
				objConnect.Open();

				//create a new OleDbCommand using the connection object and select statement
				OleDbCommand objCommand = new OleDbCommand(strSelect, objConnect);

				//declare a variable to hold a DataReader object
				OleDbDataReader objDataReader;

				//execute the SQL statement against the command to fill the DataReader
				objDataReader = objCommand.ExecuteReader();

				DataGrid1.DataSource = objDataReader;
				DataGrid1.DataBind();

				if (DataGrid1.Items.Count == 0)
				{
					outError.InnerHtml = "There are currently no Postings for this topic, start the posts with the form above.";
				}
				
				//close the DataReader and Connection
				objDataReader.Close();
				objConnect.Close();

			}

			catch (Exception objError) 
			{

				//display error details
				outError.InnerHtml = "<b>* Error while accessing data</b>.<br />"
					+ objError.Message + "<br />" + objError.Source;
				return;  //and stop execution
			}
		}
		
		</script>
	</HEAD>
	<body>
		
			<%--<h3>
				Course Course Discussion Forum -All Topics!
			</h3>--%>
			<div id="welcome" runat="server" />
        
                <% if (Session["UserType"] != null && Session["UserType"].ToString() == "Professor")
										       { %>
			       <a href="AddTopic.aspx">Add a topic</a>
                <%	}
				%>
			<p />

			<div id="outError" runat="server" style="width:50%">
				<asp:DataGrid id="DataGrid1" runat="server" AutoGenerateColumns="False" HeaderStyle-CssClass="TableHeader" AlternatingItemStyle-CssClass="AltTableItem" ItemStyle-CssClass="TableItem" CssClass="DataTable" CellPadding="5">
					<Columns>
						<asp:TemplateColumn HeaderText="Posted By">
							<ItemTemplate>
								<asp:Label Runat='server' ID="lblAdminLink">
									<%# DataBinder.Eval(Container.DataItem, "TopicCreateName") %>
									<% if (Session["UserType"] != null && Session["UserType"].ToString() == "Professor")
										{ %>
									<br>
									<a class="adminlink" href="DeleteRecord.aspx?T=T&ID=<%# DataBinder.Eval(Container.DataItem, "TopicID") %>">
										Delete</a>
									<%	}
									%>
									<br>
								</asp:Label>
							</ItemTemplate>
						</asp:TemplateColumn>
						<asp:TemplateColumn HeaderText="Topic: click to view posts">
							<ItemTemplate>
								<asp:Label Runat='server' ID="lblSubject">
									<a href="Postings.aspx?ID=<%#  DataBinder.Eval(Container.DataItem, "TopicID") %>&S=<%# DataBinder.Eval(Container.DataItem, "TopicSubject") %>">
										<%# DataBinder.Eval(Container.DataItem, "TopicSubject") %>
									</a>
								</asp:Label>
							</ItemTemplate>
						</asp:TemplateColumn>
						<asp:BoundColumn DataField="TopicCreateDate" HeaderText="Posted"></asp:BoundColumn>
					</Columns>
				</asp:DataGrid>
			</div>
		
	</body>
</HTML>
</asp:Content>
