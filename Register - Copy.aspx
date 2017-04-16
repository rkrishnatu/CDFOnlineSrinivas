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
		
        <style type="text/css">
      .style1
      {
          width: 436px;
          text-align: center;
          height: 45px;
      }
      .style2
      {
          color: #0066CC;
          text-align: center;
      }
      .style7
      {
          height: 45px;
          color: #0066CC;
          text-align: left;
      }
      .style8
      {
          height: 45px;
          color: #0066CC;
          text-align: center;
      }
      .style9
      {
          height: 45px;
          color: #0066CC;
          width: 256px;
          text-align: center;
      }
      .style10
      {
          width: 237px;
          text-align: center;
          height: 26px;
      }
      .style11
      {
          width: 225px;
          text-align: center;
          height: 26px;
      }
      .style12
      {
          color: #0066CC;
          width: 256px;
          text-align: center;
      }
      .style13
      {
          color: #0066CC;
          text-align: left;
      }
      .style14
      {
          width: 436px;
          text-align: center;
          height: 30px;
      }
      .style15
      {
          height: 30px;
          color: #0066CC;
          width: 256px;
          text-align: center;
      }
      .style16
      {
          height: 30px;
          color: #0066CC;
          text-align: left;
      }
      .style17
      {
          width: 436px;
          text-align: center;
          height: 38px;
      }
  </style>

        <script language="C#" runat="server">
            public void DoRegister(object sender, System.EventArgs e)
            {
                string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                string strInsert = "INSERT INTO users (UserName, [Password], ConfirmPwd, Gender, UserType, EmailID) VALUES ('" + Uname.Text + "', '" + Password.Text + "', '" + Cpassword.Text + "', '" + Gender.Text + "', '" + usertype.SelectedValue + "', '" + eMail.Text + "')";

                try
                {
           
                //create a new OleDbConnection object using the connection string
                OleDbConnection objConnect = new OleDbConnection(strConnect);

                //open the connection to the database
                objConnect.Open();

                //create a new OleDbCommand using the connection object and select statement
                OleDbCommand objCommand = new OleDbCommand(strInsert, objConnect);

                //declare a variable to hold a DataReader object
                OleDbDataReader objDataReader;

                //execute the SQL statement against the command to fill the DataReader
                objDataReader = objCommand.ExecuteReader();
                
                //Display successfull message to the end user
                outError.InnerHtml = "<b>* Registration Successfull! Click on <a href='login.aspx'>Login</a>  to SignIn and start Course Disucussion Forum!</b> <br />";

                //close the DataReader and Connection
                objDataReader.Close();
                objConnect.Close();                

              }
              catch (Exception objError)
              {
                    // display error details
                    outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.Source;
                    return;  //and stop execution
              }
            }
            </script>
		
	</HEAD>
	<body> 
		
			 <div class="clear">
                   
                 
                     <h3 class="style2"> <strong>New Member Sign Up Here</strong></h3>

          <table style="width:100%;" >
              
              <tr>
                  <td class="style15">
                      User Name</td>
                  <td class="style16">
                      <asp:TextBox ID="Uname" runat="server" MaxLength="15"></asp:TextBox>
                      <br />
                      <asp:RequiredFieldValidator ID="re_user" runat="server"
                           ControlToValidate="Uname" Display="Dynamic"
                           ErrorMessage="Please enter the User Name" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
                  </td>
              </tr>
              <tr>
                 
                  <td class="style12" >
                      Gender</td>
                  <td class="style13" >
                      <asp:RadioButtonList ID="Gender" runat="server" RepeatDirection="Horizontal">
                          <asp:ListItem>Male</asp:ListItem>
                          <asp:ListItem>Female</asp:ListItem>
                      </asp:RadioButtonList>
                      <asp:RequiredFieldValidator ID="re_gender" runat="server"
                           ControlToValidate="Gender" Display="Dynamic"
                           ErrorMessage="Please Select the Gender" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
                  </td>
              </tr>
              <tr>
                  <td class="style9" >
                      Password</td>
                  <td class="style7">
                      <asp:TextBox ID="Password" runat="server" MaxLength="8" TextMode="Password"></asp:TextBox>
                      <br />
                      <asp:RequiredFieldValidator ID="re_pass" runat="server"
                           ControlToValidate="Password" Display="Dynamic"
                           ErrorMessage="Please Enter the Password" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
                  </td>
              </tr>
              <tr>
                  
                  <td class="style9">
                      Confirm Password</td>
                  <td class="style7">
                      <asp:TextBox ID="Cpassword" runat="server" MaxLength="8" TextMode="Password"></asp:TextBox>
                      <br />
                      <asp:RequiredFieldValidator ID="re_cpass" runat="server"
                           ControlToValidate="Cpassword" Display="Dynamic"
                           ErrorMessage="Please Enter the Confirm Password" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
                      <br />
                      <asp:CompareValidator ID="re_passCompare" runat="server"
                           ControlToCompare="Password" ControlToValidate="Cpassword" Display="Dynamic"
                           ErrorMessage="Password Mismatch" ForeColor="Red" ValidationGroup="signUp"></asp:CompareValidator>
                  </td>
              </tr>
               <tr>
                 
                  <td class="style12" >
                      Register Type</td>
                  <td class="style13" >
                      <asp:RadioButtonList ID="usertype" runat="server" RepeatDirection="Horizontal">
                          <asp:ListItem>Professor</asp:ListItem>
                          <asp:ListItem>Student</asp:ListItem>
                          <asp:ListItem>Teaching Assistant</asp:ListItem>
                      </asp:RadioButtonList>
                      <asp:RequiredFieldValidator ID="usertypevalidator" runat="server"
                           ControlToValidate="usertype" Display="Dynamic"
                           ErrorMessage="Please Select the Register Type" ForeColor="Red"
                           ValidationGroup="signUp"></asp:RequiredFieldValidator>
                  </td>
              </tr>
              <tr>
                 
                  <td class="style9">
                      E-mail Id</td>
                  <td class="style7">
                      <asp:TextBox ID="eMail" runat="server"></asp:TextBox>
                      <br />
                      <asp:RequiredFieldValidator ID="re_email" runat="server"
                           ControlToValidate="eMail" Display="Dynamic"
                           ErrorMessage="Please Enter the Email" ForeColor="Red" ValidationGroup="signUp"></asp:RequiredFieldValidator>
                      <br />
                      <asp:RegularExpressionValidator ID="re_validemail" runat="server"
                           ControlToValidate="eMail" Display="Dynamic"
                           ErrorMessage="Enter the Valid Email Id" ForeColor="Red"
                           ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                           ValidationGroup="signUp"></asp:RegularExpressionValidator>
                  </td>
              </tr>
              <tr>
                  <td></td>
                  <td class="style8" >
                      <asp:Button ID="Button1" class="button_example" runat="server" Text="Sign Up"
                           onclick="DoRegister" ValidationGroup="signUp"
                           />
                  </td>
              </tr>
              <tr>
                  
                  <td class="style8" >
                        <asp:Label runat="server" ID="message"></asp:Label>
                  </td>
              </tr>
          </table>
      </div>
  
            <div id="outError" runat="server">
		         </div>

		
	</body>
</HTML>
</asp:Content>
