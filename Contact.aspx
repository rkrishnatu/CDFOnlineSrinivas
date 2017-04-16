<%@ Page language="c#"  MasterPageFile="~/Site.master"  %>

<asp:Content runat="server" ID="BodyContent" ContentPlaceHolderID="MainContent">
    <hgroup class="title">
        <h1><%: Title %>.</h1>
        <h2>M Srinivas</h2>
    </hgroup>

    <section class="contact">
        <header>
            <h3>Phone:</h3>
        </header>
        <p>
            <span class="label">Main:</span>
            <span>+91 9885265800</span>
        </p>
        <p>
            <span class="label">After Hours:</span>
            <span>+91 9885265800</span>
        </p>
    </section>

    <section class="contact">
        <header>
            <h3>Email:</h3>
        </header>
        <p>
            <span class="label">Support:</span>
            <span><a href="mailto:marimgantisrinivas@gmail.com">marimgantisrinivas@gmail.com</a></span>
        </p>        
    </section>

    <section class="contact">
        <header>
            <h3>Address:</h3>
        </header>
        <p>
            IIIT<br />
            Hyderabad, Telangana
        </p>
    </section>
</asp:Content>
