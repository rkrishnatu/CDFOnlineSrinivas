<%@ Page language="c#" MasterPageFile="~/Site.master"  %>
<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>

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
				Response.Redirect("login.aspx");
			}

			frmName.Text = "<b>" + Session["UserName"].ToString() + "</b>";
			ListPostings();            
		}

        private string DummyCoursesOffered()
        {
            //Dummy courses offered - random allocate to students
            ArrayList ar = new ArrayList();
            ar.Add("Software Engineering");
            ar.Add("Database Management Systems");
            ar.Add("Image Processing");
            ar.Add("Remote Sensing");
            ar.Add("Information Systems");
            ar.Add("Network Programming");
            ar.Add("Digital Programming");
            ar.Add("Analog Systems");
            ar.Add("Structural Programming");
            ar.Add("Compuer Science");
            Random r = new Random();
            int index = r.Next(0, ar.Count - 1);
            return ar[index].ToString() + ", " + ar[index+1].ToString();
        }
        
		private void ListPostings()
		{
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			string strSelect =  "SELECT * ";
			strSelect +=		"FROM Postings ";
			strSelect +=		"Where TopicID=" + Request.QueryString["ID"] + " and PostCreateName = '" + Session["UserName"] + "'";

			strSelect +=		"ORDER BY PostCreateDate DESC;";

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

                RepDetails.DataSource = objDataReader;
                RepDetails.DataBind();

                if (RepDetails.Items.Count == 0)
				{
					outError.InnerHtml = "There are currently no Postings for this topic, start the posts with the form above.";
				}
				
				//Write the Topic Subject as the Page Header
				TopicSubject.InnerHtml = "<h4>" + Request.QueryString["S"] + "</h4>";
			
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


        protected void RepDetails_ItemCommand(object source, System.Web.UI.WebControls.RepeaterCommandEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                              
                TextBox replywrite = (TextBox)e.Item.FindControl("replyText");
                LinkButton replyButton = (LinkButton)e.Item.FindControl("replySubmit");
                
                if (e.CommandName == "lnkbtnreply") // check command is reply event clicked
                {
                    // get you required value
                    string PostID = (e.CommandArgument).ToString();
                    replywrite.Visible = true;
                    replyButton.Visible = true;
                }
                
                if (e.CommandName == "replySubmit") // check command is reply event clicked
                {
                    
                    //Reply for the selected question/ post
                    string replyMessage = replywrite.Text.Trim();
                    HiddenField selectedPostID = (HiddenField)e.Item.FindControl("hdnPostID");
                        
                    
                    string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                    string strInsert = "INSERT INTO replies (ReplyContent, ReplyCreateName, PostID) VALUES ('" + replyMessage + "', '" + Session["UserName"].ToString() + "','" + selectedPostID.Value + "')";

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

                    }

                    catch (Exception objError)
                    {

                        //display error details
                        outError.InnerHtml = "<b>* Error while inserting reply data</b>.<br />"
                            + objError.Message + "<br />" + objError.Source;
                        return;  //and stop execution
                    }
                }
                
                //Like
                if (e.CommandName == "lnkbtnlike") // check command is like event clicked
                {

                    //Like for the selected question/ post                    
                    HiddenField selectedPostID = (HiddenField)e.Item.FindControl("hdnPostID");
                    HiddenField NoOfLikesForSelectedPost = (HiddenField)e.Item.FindControl("hdnNoOfLikes");
                    
                        
                    // Like for the posting/ question                    
                    var NumberOfLikes = 0;

                    if (NoOfLikesForSelectedPost.Value != null && NoOfLikesForSelectedPost.Value != "")
                    {
                        NumberOfLikes = Convert.ToInt32(NoOfLikesForSelectedPost.Value) + 1;
                    }
                    else
                    {
                        NumberOfLikes = 1;
                    }

                    string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                    string strInsert = "UPDATE postings SET NumberOfLikes = " + NumberOfLikes + " WHERE POSTID=" + selectedPostID.Value;
                    
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

                        //reloading the postings page again since likes are submitted and to see updated data.
                        ListPostings();
                        
                       
                    }

                    catch (Exception objError)
                    {

                        //display error details
                        outError.InnerHtml = "<b>* Error while inserting reply data</b>.<br />"
                            + objError.Message + "<br />" + objError.Source;
                        return;  //and stop execution
                    }
                }
            }
        }
        
		public string AdminVisible()
		{
			if (Session["UserType"] == "Professor") 
			{
				return " Visible=true";
			}
			else
			{
				return "";
			}
		}
		

        // Create Post event
		public void DoAddPost(object sender, System.EventArgs e)
		{
			string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source="+Server.MapPath(".\\db\\forum.mdb");
			string strInsert = "INSERT INTO Postings (PostContent, PostCreateName, TopicID) VALUES ('" + frmPost.Text + "', '" + Session["UserName"].ToString() + "', " + Request.QueryString["ID"] + " )" ;
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

				Response.Redirect ("Postings.aspx?ID=" + Request.QueryString["ID"] + "&S=" + Request.QueryString["S"], true);
				
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
		
			<div ID="TopicSubject" Runat="server">
			</div>
			<p>
				To add a Post, enter your Message.
			</p>
			<div id="Div1" runat="server">
				<table cellpadding="5" cellspacing="1" border="0" class="DataTable">
					<tr>
						<td class="TableItem">
							Message from
							<asp:Label ID="frmName" Runat="server"></asp:Label>:
							<br>
							<asp:TextBox id="frmPost" runat="server" TextMode="MultiLine" MaxLength="255" Columns="40" Rows="5"></asp:TextBox>

                            <br />
                                      <asp:RequiredFieldValidator ID="postingValidate" runat="server"
                                           ControlToValidate="frmPost" Display="Dynamic"
                                           ErrorMessage="Please Enter the Posting" ForeColor="Red"
                                           ValidationGroup="dosubmit"></asp:RequiredFieldValidator>

							<table border="0" width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100%" align="right">
										<asp:Button onClick="DoAddPost" Text="Add Post" Runat="server" id="Button1" CssClass="button" ValidationGroup="dosubmit"></asp:Button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<p>
					<a href="Topics.aspx">Back to Topic List</a>
				</p>
			</div>
			<div id="outError" runat="server">

                <asp:Repeater ID="RepDetails" runat="server"  OnItemCommand="RepDetails_ItemCommand"  EnableViewState="False">
                    <HeaderTemplate>
                        <table style="border: 1px solid #df5015; width: 500px" cellpadding="0">
                            <tr style="background-color: #df5015; color: White">
                                <td colspan="2">
                                    <b>Questions</b>
                                </td>
                            </tr>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr style="background-color: #EBEFF0">
                            <td colspan="2">
                                <table style="background-color: #EBEFF0; border-top: 1px dotted #df5015; width: 500px">
                                    

                                    <tr>
                                        <td style="border: 1px solid #df5015;width:30%">
                                            <% if (Session["UserType"].ToString() == "Student")
                                               { %>
                                            <b>Student:</b>  <%#Eval("PostCreateName") %>
                                            <br /><b>Courses Offered:</b> <%# DummyCoursesOffered() %> 
                                            
                                            <% }%>
                                            
                                            <% if (Session["UserType"].ToString() == "Professor")
                                               { %>
                                            <b>Professor:</b> <%#Eval("PostCreateName") %> 
                                                                                       
                                            <% }%>  
                                            
                                            <% if (Session["UserType"].ToString() == "Teaching Assistant")
                                               { %>
                                            <b>Teaching Assistant:</b>  <%#Eval("PostCreateName") %> 
                                                                                       
                                            <% }%>                                              
                                        </td>
                                   
                                        <td style="border: 1px solid #df5015;width:70%">Posted Content:
                                            <asp:Label ID="lblPostContent" runat="server" Text='<%#Eval("PostContent") %>' Font-Bold="true" />                                           
                                        <br />
                                            Posted By:
                                            <asp:Label ID="lblPostCreateName" runat="server" Text='<%#Eval("PostCreateName") %>' Font-Bold="true" />                                            
                                       <br />
                                            Likes:
                                            <asp:Label ID="lblLikes" runat="server" Text='<%#Eval("NumberOfLikes") %>' Font-Bold="true" />                                            
                                        <br />

                                            <a class="adminlink" href="ViewReplies.aspx?S=<%# DataBinder.Eval(Container.DataItem, "PostContent") %>&TID=<%# Request.QueryString["ID"] %>&T=P&ID=<%# DataBinder.Eval(Container.DataItem, "PostID") %>">
										View </a>

                                            || <asp:LinkButton ID="lnkbtnreply" runat="server" Text="Reply" CommandName="lnkbtnreply" ></asp:LinkButton>

                                        <% if (Session["UserType"].ToString() == "Student" || Session["UserType"].ToString() == "Professor")
                                               { %>                                            
                                            || <asp:LinkButton ID="lnlLike" runat="server" Text="Like" CommandName="lnkbtnlike" ></asp:LinkButton>
                                            <%	}
                                            %>
                                        
                                           <% if (Session["UserType"].ToString() == "Professor")
										   { %>
									       <br>
									       <a class="adminlink" href="DeleteRecord.aspx?S=<%# Request.QueryString["S"] %>&TID=<%# Request.QueryString["ID"] %>&T=P&ID=<%# DataBinder.Eval(Container.DataItem, "PostID") %>">
										       || Delete</a>
									       <%	}
									       %> 
                                        
                                            <br />

                                            <asp:TextBox ID="replyText" runat="server"  placeholder="Enter Your Reply Here" Visible="false"  />
                                            <asp:LinkButton ID="replySubmit" runat="server" Text="Answer" Visible="false" CommandName="replySubmit" />
                                        </td>
                                    </tr>

                                    <tr>
                                        <td>
                                            
                                            <asp:HiddenField ID="hdnPostID" runat="server" Value='<%# Eval("PostID") %>' />
                                            <asp:HiddenField ID="hdnNoOfLikes" runat="server" Value='<%# Eval("NumberOfLikes") %>' />
                                        </td>
                                    </tr>

                                </table>
                            </td>
                        </tr>
                      
                        <tr>
                            <td colspan="2">&nbsp;</td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </table>
                    </FooterTemplate>
                </asp:Repeater>

			</div>
		
	</body>
</HTML>
    </asp:Content>

