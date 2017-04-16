<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Like for the selected Posting!</h1>
                <h2></h2>
            </hgroup>
            <p>
                
            </p>
        </div>
    </section>
</asp:Content>

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
			// Like for the posting/ question
            string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
            var NumberOfLikes = 0;
                
            if (Request.QueryString["NoOfLikes"] != null)
            {
                NumberOfLikes = Convert.ToInt32(Request.QueryString["NoOfLikes"]) + 1;
            }
            else
            {
                NumberOfLikes = 1;
            }

            string strInsert = "UPDATE postings SET NumberOfLikes = " + NumberOfLikes + " WHERE POSTID=" + Request.QueryString["ID"];
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

                lblLikeMessage.Text = "Thanks for liking my post!... :-}";
                
                // close the Connection
                objConnect.Close();

                // Redirect back to Topics
                //Response.Redirect("Topics.aspx", true);
            }

            catch (Exception objError)
            {
                // display error details
                outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.Source;
                return;  //and stop execution
            }
			
		}
		</script>

       <%-- <script Language="JavaScript">
            function Validate(theForm) {
                if (theForm.textboxReply.value == "") {
                    alert("Please enter reply message");
                    theForm.textboxReply.focus();
                    return (false);
                }
                return (true)
            }
		</script>--%>

	</head>
	<body>

        <%--<form id="ReplyPosting" method="post" runat="server" onSubmit="return Validate(this)">--%>

		<div id="outError" runat="server">
		</div>

			<div id="Div1" runat="server">
				<table cellpadding="5" cellspacing="1" border="0" class="DataTable">
					<tr>
						<td class="TableItem">							
							<asp:Label ID="lblLikeMessage" Runat="server"></asp:Label>
							<br>							
						</td>
					</tr>
				</table>
				<p>
					<a href="Postings.aspx?ID=<%= Request.QueryString["TID"] %>">Back to Postings List</a>
				</p>
			</div>
           <%-- </form>--%>

	</body>
</html>

    </asp:Content>