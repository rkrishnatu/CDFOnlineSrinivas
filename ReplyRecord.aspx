<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>

<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Reply for the selected Posting!</h1>
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
  
            public void DoReplyPost(object sender, System.EventArgs e)
            {
                string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                string strInsert = "INSERT INTO replies (ReplyContent, ReplyCreateName, PostID) VALUES ('" + textboxReply.Text + "', '" + Session["UserName"].ToString() + "','" + Request.QueryString["ID"] + "')";
                
                try
                {

                    //create a new OleDbConnection object using the connection string
                    OleDbConnection objConnect = new OleDbConnection(strConnect);

                    //open the connection to the database
                    objConnect.Open();

                    //create a new OleDbCommand using the connection object and select statement
                    OleDbCommand objCommand = new OleDbCommand(strInsert, objConnect);

                    //execute the SQL statement against the command to fill the DataReader
                    objCommand.ExecuteNonQuery();

                    //close the Connection
                    objConnect.Close();

                    Response.Redirect("Postings.aspx?ID=" + Request.QueryString["TID"] + "&S=" + Request.QueryString["S"], true);

                }

                catch (Exception objError)
                {

                    //display error details
                    outError.InnerHtml = "<b>* Error while inserting reply data</b>.<br />"
                        + objError.Message + "<br />" + objError.Source;
                    return;  //and stop execution
                }
            }
            
		private void Page_Load(object sender, System.EventArgs e)
		{
			// Page used to Reply for the posting/ question
			// QueryStrings: 
			//		"T"   = Type (i.e. Posting or Topic)
			//		"ID"  = Record ID to Delete
			//		"TID" = TopicID (fro Postings)
			//		"S"   = Subject (for Postings)
			// Build DELETE statement based on Type
			
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
	<body MS_POSITIONING="GridLayout">

        <%--<form id="ReplyPosting" method="post" runat="server" onSubmit="return Validate(this)">--%>

		<div id="outError" runat="server">
		</div>
            <h3>
				Course Discussion Forum -Reply For Posting/ Question 
			</h3>
			<div ID="ReplyPost" Runat="server">
			</div>
			<p>
				To reply a post, enter answer message and click on submit.
			</p>
			<div id="Div1" runat="server">
				<table cellpadding="5" cellspacing="1" border="0" class="DataTable">
					<tr>
						<td class="TableItem">
							Reply Message
							<asp:Label ID="frmName" Runat="server"></asp:Label>:
							<br>
							<asp:TextBox id="textboxReply" runat="server" TextMode="MultiLine" MaxLength="255" Columns="40" Rows="5"></asp:TextBox>

                            <br />
                                      <asp:RequiredFieldValidator ID="replyValidate" runat="server"
                                           ControlToValidate="textboxReply" Display="Dynamic"
                                           ErrorMessage="Please Enter the Reply Message" ForeColor="Red"
                                           ValidationGroup="dosubmit"></asp:RequiredFieldValidator>

							<table border="0" width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100%" align="right">
										<asp:Button onClick="DoReplyPost" Text="Reply Post" Runat="server" id="Button1" CssClass="button" ValidationGroup="dosubmit"></asp:Button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<p>
					<a href="Postings">Back to Postings List</a>
				</p>
			</div>
           <%-- </form>--%>

	</body>
</html>

    </asp:Content>
