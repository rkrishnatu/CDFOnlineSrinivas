<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>


<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>All Postings for the selected topic!</h1>
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
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Put user code to initialize the page here
		
				if (Session["UserName"] == null)
				{
					Response.Redirect("default.aspx");
				}

			//frmName.Text = "<b>" + Session["UserName"].ToString() + "</b>";
			ListAnswersForAPost();
		}

        private void ListAnswersForAPost()
		{
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			string strSelect =  "SELECT * ";
			strSelect +=		"FROM Replies ";
			strSelect +=		"WHERE PostID=" + Request.QueryString["ID"] + " ";
			strSelect +=		"ORDER BY ReplyCreateDate DESC;";

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
					outError.InnerHtml = "There are currently no answers given for this posting/ question, start reply to the posts in the postings form";
				}
				
				//Write the Posting as the Page Header
				PostContent.InnerHtml = "<h4>" + Request.QueryString["S"] + "</h4>";
			
				//close the DataReader and Connection
				objDataReader.Close();
				objConnect.Close();


			}

			catch (Exception objError) 
			{

				//display error details
				outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.InnerException + "<P>" + objError.Source + "<P>" + objError.StackTrace + "<P>" + strSelect;
				return;  //and stop execution
			}
		}

		public string AdminVisible()
		{
			if (Session["UserType"] == "professor") 
			{
				return " Visible=true";
			}
			else
			{
				return "";
			}
		}		

		</script>
		
	</HEAD>
	<body>
		<%--<form id="AddPosting" method="post" runat="server">--%>
			<h3>
				Course Course Discussion Forum -View Answers for the selected posting!
			</h3>
			<div ID="PostContent" Runat="server" style="color:red;font-style:italic">
			</div>
			
			<div id="Div1" runat="server">				
				<p>
					<a href="Postings.aspx?ID=<%= Request.QueryString["TID"] %>">Back to Postings List</a>
				</p>
			</div>
			<div id="outError" runat="server">
				<asp:DataGrid EnableViewState="False" DataKeyField="ReplyID" id="DataGrid1" runat="server" AutoGenerateColumns="False" HeaderStyle-CssClass="TableHeader" AlternatingItemStyle-CssClass="AltTableItem" ItemStyle-CssClass="TableItem" CssClass="DataTable" CellPadding="5">
					<HeaderStyle CssClass="TableHeader"></HeaderStyle>
					<PagerStyle NextPageText="Next &amp;gt;" PrevPageText="&lt; Prev"></PagerStyle>
					<AlternatingItemStyle CssClass="AltTableItem"></AlternatingItemStyle>
					<ItemStyle CssClass="TableItem"></ItemStyle>
					<Columns>						
						<asp:BoundColumn DataField="ReplyContent" HeaderText="Reply Message"></asp:BoundColumn>
                        <asp:BoundColumn DataField="ReplyCreateName" HeaderText="Replied By"></asp:BoundColumn>
						<asp:BoundColumn DataField="ReplyCreateDate" HeaderText="Replied On"></asp:BoundColumn>
					</Columns>
				</asp:DataGrid>
			</div>
		<%--</form>--%>
	</body>
</HTML>
    </asp:Content>
