<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>
<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>
    

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">

    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
	<HEAD>
		<meta name="GENERATOR" Content="Microsoft Visual Studio 7.0">
		<meta name="CODE_LANGUAGE" Content="C#">
		<meta name="vs_defaultClientScript" content="JavaScript (ECMAScript)">
		<meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
		<link href="style.css" rel="stylesheet" type="text/css">

		<script language="C#" runat="server">
  
                       
		public void DoLogin(object sender, System.EventArgs e)
		{
            //check for user available or not in the database
            string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
            string strSelect = "SELECT * FROM users where username='" + frmUserName.Text.Trim() + "' and password='" + frmPassword.Text.Trim() + "'";
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

                if (!objDataReader.HasRows)
                {
                    outError.InnerHtml = "User is not valid. Please enter valid user credentials and try again.";
                }
                else
                {
                    //store this to use through out application to identify user and user type (professor or student)
                    Session["UserName"] = frmUserName.Text;

                    while (objDataReader.Read())
                    {
                        Session["UserType"] = objDataReader["UserType"].ToString();
                    }
                    
                    Response.Redirect("Topics.aspx");
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
		<section id="LoginForm">
			<table border="0" align="center" cellspacing="1" cellpadding="5" bgcolor="purple">
				<tr>
					<td width="100%" class="TableItem">
						<b>Enter to the Course Discussion Forum:</b><br />
						<table border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td valign="top">
									User Name:
									<asp:TextBox id="frmUserName" runat="server" Columns="15"></asp:TextBox>
                                    <br />
                                      <asp:RequiredFieldValidator ID="usernamevalidate" runat="server"
                                           ControlToValidate="frmUserName" Display="Dynamic"
                                           ErrorMessage="Please Enter the User Name" ForeColor="Red"
                                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
								</td>
								<td valign="top" align="left">
									Password: <asp:TextBox id="frmPassword" runat="server" Columns="15" TextMode="Password"></asp:TextBox>
                                    <br />
                      <asp:RequiredFieldValidator ID="passwordvalidate" runat="server"
                           ControlToValidate="frmPassword" Display="Dynamic"
                           ErrorMessage="Please Enter the Password" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
								</td>
							</tr>
							<tr>								
                                <td valign="top" >
									<asp:Button id="Button1" runat="server" OnClick="DoLogin" Text="Go" CssClass="button" ValidationGroup="signUp"></asp:Button>
								</td>
							</tr>
                            
                            <tr>                               

                                <td>
                                    <asp:HyperLink runat="server" ID="RegisterHyperLink" NavigateUrl="~/Register.aspx" Font-Bold="true" ForeColor="Red">Register</asp:HyperLink>
                                    if you don't have an account.
                                </td>
                            </tr>

                            <tr>
                                <td>
                                    <asp:HyperLink runat="server" ID="ForgetPwdLink" NavigateUrl="~/ForgotPassword.aspx" Font-Bold="true" ForeColor="Red">Forgot Password</asp:HyperLink>

                                </td>
                            </tr>

                            <%--<tr>
                                <td>
                                    Guest? <asp:HyperLink runat="server" ID="lnkGuest" NavigateUrl="~/Topics.aspx?guest=yes" Font-Bold="true" ForeColor="Red">Click Here!</asp:HyperLink>
                                    
                                </td>
                            </tr>--%>
						</table>
					</td>
				</tr>

                <tr>
                                <td valign="top" >
                                    <div id="outError" runat="server" style="color:red">
		                           </div>
                                </td>
                            </tr>

			</table>

             </section>

        <section id="socialLoginForm">
           
        </section>

		
	</body>
</HTML>

</asp:Content>


