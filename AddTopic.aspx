<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Add Topic!</h1>
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
			// Check that they have entered a UserName
			if (Session["UserName"].ToString().Length < 1)
			{
				Response.Redirect("default.aspx");
			}
			frmName.Text = "<b>" + Session["UserName"].ToString() + "</b>";
		}

		public void DoAddTopic(object sender, System.EventArgs e)
		{
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			string strInsert = "INSERT INTO topics (TopicSubject, TopicCreateName) VALUES ('" + frmPost.Text + "', '" + Session["UserName"].ToString() + "')";
			try 
			{
				// create a new OleDbConnection object using the connection string
				OleDbConnection objConnect = new OleDbConnection(strConnect);

				// open the connection to the database
				objConnect.Open();

				// create a new OleDbCommand using the connection object and select statement
				OleDbCommand objCommand = new OleDbCommand(strInsert, objConnect);

				// execute the SQL statement
				objCommand.ExecuteNonQuery();

				// close the Connection
				objConnect.Close();

				// Redirect back to Topics
				Response.Redirect ("Topics.aspx", true);
			}

			catch (Exception objError) 
			{
				// display error details
				outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.Source;
				return;  //and stop execution
			}
		}
		</script>
		<%--<script Language="JavaScript">
			function Validate(theForm)
			{
			if (theForm.frmPost.value == "")
   			{
			     alert("Please enter a Topic subject");
			     theForm.frmPost.focus();
			     return (false);
			  }
			return (true)
			}
		</script>--%>

	</HEAD>
	<body>
		<%--<form id="AddTopic" method="post" runat="server" onSubmit="return Validate(this)">--%>
			<h3>
				Course Discussion Forum -Add Topic!
			</h3>
			<p>
				To add a topic, enter your name and
				<br>
				give the topic a brief subject.
			</p>
			<div id="outError" runat="server">
				<table cellpadding="5" cellspacing="1" border="0" class="DataTable">
					<tr>
						<td class="TableItem">
							<asp:Label ID="frmName" Runat="server"></asp:Label>
							<br />
							Brief Topic Subject: (255 character Max)
							<br />
							<asp:TextBox id="frmPost" runat="server" TextMode="MultiLine" MaxLength="255" Columns="40" Rows="5"></asp:TextBox>

                            <br />
                                      <asp:RequiredFieldValidator ID="topicValidate" runat="server"
                                           ControlToValidate="frmPost" Display="Dynamic"
                                           ErrorMessage="Please Enter the Topic" ForeColor="Red"
                                           ValidationGroup="dosubmit"></asp:RequiredFieldValidator>

							<table border="0" width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100%" align="right">
										<asp:Button onClick="DoAddTopic" Text="Submit" Runat="server" id="Button1" CssClass="button" ValidationGroup="dosubmit"></asp:Button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<p>
				</p>
				<a href="Topics.aspx">Back to Topic List</a>
			</div>
		<%--</form>--%>
	</body>
</HTML>
    </asp:Content>


