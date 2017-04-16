<%@ Page language="c#" MasterPageFile="~/Site.master"  %>
<%@Import Namespace="System.Data.OleDb" %>
<%@Import Namespace="System.Data" %>


<asp:Content runat="server" ID="FeaturedContent" ContentPlaceHolderID="FeaturedContent">
    <section class="featured">
        <div class="content-wrapper">
            <hgroup class="title">
                <h1>Rate your Professor!</h1>
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

                if (Session["UserName"] == null)
                {
                    Response.Redirect("Login.aspx");
                }

                if (!IsPostBack)
                {
                    // Rate your selected professor

                    //Step 1 = Fill all topics/ courses from database to topics drop down list
                    string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                    string strSelect = "SELECT distinct TopicID, TopicSubject, TopicCreateName, TopicCreateDate FROM topics ORDER BY TopicCreateDate DESC";

                    try
                    {
                        // create a new OleDbConnection object using the connection string
                        OleDbConnection objConnect = new OleDbConnection(strConnect);

                        // open the connection to the database
                        objConnect.Open();

                        // create a new OleDbCommand using the connection object and select statement
                        OleDbCommand objCommand = new OleDbCommand(strSelect, objConnect);

                        //declare a variable to hold a DataReader object
                        OleDbDataReader objDataReader;

                        //execute the SQL statement against the command to fill the DataReader
                        objDataReader = objCommand.ExecuteReader();


                        //clear all topics and professors
                        listAllTopic.Items.Clear();
                        drpProfessors.Items.Clear();

                        //All topics
                        ListItem listItem = new ListItem();
                        listAllTopic.Items.Add("Select");

                        //All professors
                        ListItem listProfItem = new ListItem();
                        drpProfessors.Items.Add("Select");

                        while (objDataReader.Read())
                        {
                            //Fill All topics                   
                            listItem = new ListItem();
                            listItem.Text = objDataReader["TopicSubject"].ToString();
                            listItem.Value = objDataReader["TopicID"].ToString();

                            listAllTopic.Items.Add(listItem);

                            //Fill all professors
                            listProfItem = new ListItem();
                            listProfItem.Text = objDataReader["TopicCreateName"].ToString();
                            listProfItem.Value = objDataReader["TopicCreateName"].ToString();

                            drpProfessors.Items.Add(listProfItem);
                        }

                        // close the Connection
                        objDataReader.Close();
                        objConnect.Close();

                        listAllTopic.SelectedIndex = 0;
                        drpProfessors.SelectedIndex = 0;
                    }
                    catch (Exception objError)
                    {
                        // display error details
                        outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.Source;
                        return;  //and stop execution
                    }
                }
            }

            public void DoFeedback(object sender, System.EventArgs e)
            {
                string strConnect = "Provider=Microsoft.Jet.OLEDB.4.0 ;Data Source=" + Server.MapPath(".\\db\\forum.mdb");
                string strInsert = "INSERT INTO Feedback (TopicID, Professor, GivenBy, Rating, AddComments) VALUES ('" + Convert.ToInt32(listAllTopic.SelectedValue) + "', '" + drpProfessors.SelectedValue + "', '" + Session["UserName"].ToString() + "', '" + grade.SelectedValue + "', '" + textAddComments.Text.Trim() + "')";

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

                    //Successfull Rated
                    outError.InnerHtml = "<b>Thank you for Rating!. Your details are kept as confidential</b>";
                }

                catch (Exception objError)
                {
                    // display error details
                    outError.InnerHtml = "<b>* Error while accessing data</b>.<br />" + objError.Message + "<br />" + objError.Source;
                    return;  //and stop execution
                }
            }

		</script>

      
	</head>
	<body>

		<div id="outError" runat="server" style="font-size:15">
				<table cellpadding="5" cellspacing="1" border="0" >

                    <tr>
                        <td>Topic: &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            <asp:DropDownList runat="server" ID="listAllTopic" EnableViewState="true"></asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                                   ControlToValidate="listAllTopic" Display="Dynamic"
                                   ErrorMessage="Please Select Topic" InitialValue="Select" ForeColor="Red"
                                   ValidationGroup="dosubmit"></asp:RequiredFieldValidator>
                        </td>
                    </tr>

                    <tr>
                        <td>Professor: 
                            <asp:DropDownList runat="server" ID="drpProfessors" EnableViewState="true"></asp:DropDownList>
                             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                                   ControlToValidate="drpProfessors" InitialValue="Select" Display="Dynamic"
                                   ErrorMessage="Please Select Professor" ForeColor="Red"
                                   ValidationGroup="dosubmit"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr><td></td></tr>
                    <tr><td></td></tr>
					<tr>
                        <p></p>
                        <td class="style12" >
                        <b>Rating:</b>
                              <asp:RadioButtonList ID="grade" runat="server" RepeatDirection="Vertical">
                                  <asp:ListItem Value="5">Excellent (5)</asp:ListItem>
                                  <asp:ListItem Value="4">Above Average (4) </asp:ListItem>
                                  <asp:ListItem Value="3">Average (3) </asp:ListItem>
                                  <asp:ListItem Value="2">Below Average (2) </asp:ListItem>
                                  <asp:ListItem Value="1">Poor (1) </asp:ListItem>
                                  <asp:ListItem Value="0">Need Improvement (0) </asp:ListItem>
                              </asp:RadioButtonList>
                              <asp:RequiredFieldValidator ID="gardevalidator" runat="server"
                                   ControlToValidate="grade" Display="Dynamic"
                                   ErrorMessage="Please Select the Rating" ForeColor="Red"
                                   ValidationGroup="dosubmit"></asp:RequiredFieldValidator>
                          </td>
                        </tr>

                    <tr>
						<td class="TableItem">
							<asp:Label ID="frmName" Runat="server"></asp:Label>
							<br />
							Additional Comments: (255 character Max)
							<br />
							<asp:TextBox id="textAddComments" runat="server" TextMode="MultiLine" MaxLength="255" Columns="40" Rows="5"></asp:TextBox>

                            
							<table border="0" width="100%" cellspacing="0" cellpadding="0">
								<tr>
									<td width="100%" align="right">
										<asp:Button onClick="DoFeedback" Text="Submit" Runat="server" id="Button1" CssClass="button" ValidationGroup="dosubmit"></asp:Button>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<p>
				</p>
				
			</div>

	</body>
</html>

    </asp:Content>