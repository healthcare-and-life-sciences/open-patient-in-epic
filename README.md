![](/images/Image1.png)
<h1>A-HLS Open Patient in Epic Documentation </h1>

<h2>Overview</h2>

The Open Patient in Epic Accelerator enables the user to open a patient’s record in the Epic EHR system from an OmniScript component in Health Cloud, with user-specified context (e.g., Scheduling, Refill). 

The Accelerator pre-populates parameters and the url suffix for the Epic API “Receive Communication” as documented here on open.epic.com (http://open.epic.com/): https://open.epic.com/Operational/ContactCenter.

The Accelerator gives the user a choice of context for which to view the patient in Epic. By default, the contexts included are:

* Scheduling
* Medication Refill
* Nurse Triage
* Member Services
* Log Phone Call
* (Pre-selected by default) Default Patient Context - this represents a blank context which will trigger a default documentation activity configured by the organization.

![](/images/image2.png)

<h2>Business Objective</h2>

The Accelerator increases efficiency and improves the user experience by reducing the number of clicks in a user’s workflow. It reduces IT cost by providing pre-built components for workflow integration between Salesforce and Epic. 

<h3>Business Value and Benefits</h3>

* Increased Efficiency
* Improved User Experience
* Decreased IT Costs


<h2>Industry Focus and Workflow</h2>

<h3>Primary Industry:</h3>

* Provider

<h3>Primary User Persona:</h3>

* Call Center Agent

<h3>User Workflow:</h3>

* User is supporting a patient who calls into the organization
* User needs to complete a task for the patient which is done in Epic
* User clicks the Open Patient in Epic button which launches the patient’s record with specified context in Epic


<h2>Package Includes:</h2>

*OmniScript (1)*

* Epic Button OmniScript

*DataRaptor (2)*

* GetPatientEHRId
* GetUserIDForEHR

*Integration Procedure (1)*

* OpenEpicPatientAndContext
    * Type: EHRConnect
    * SubType: EpicReceiveCommunication

Images (6)

* i_schedule_school_date_time.png
* rx.png
* nurse.png
* social_work.png
* phone.png
* clinical_fe.png

Static Resources - CSS (1)

* buttonStyles.css


<h2>Configuration Requirements</h2>

<h3>Pre-Install Configuration Steps:</h3>

1. Work with your Epic Administrator in order to activate the Receive Communication API web service. 
2. Configure the Remote Site Settings in Salesforce in order to enable calls between Salesforce and Epic. More information can be found here: https://help.salesforce.com/s/articleView?id=sf.configuring_remoteproxy.htm&type=5

<h4>Install the Data Pack</h4>

1. Follow the download steps presented on the Accelerate HLS website for this Accelerator. 
    1. Alternatively, you may download the Data Pack folder in the following GitHub repository: https://github.com/healthcare-and-life-sciences/open-patient-in-epic
2. Then, complete the following steps to import them into your Salesforce org.
    1. To Import, in your destination Salesforce org, Click on *App Launcher* → Search for '*OmniStudio DataPacks*' and click on it.
    2. Click on '*Installed*' and on the right side click on '*Import from*'.
    3. Select '*From File*' - When the window opens, select the Data Pack file that you downloaded and stored on your machine. Click '*Install*'.
    4. When prompted to Activate the OmniScript, choose *Not Now*.

<h4>Post-Install Configuration Steps:</h4>

<h5>Add buttonStyles.css to Static Resources</h5>

1. Navigate to Setup > Static Resources
2. Click New and name the Static Resource “buttonStyles”
3. Add the buttonStyles.css file
4. Set the resource to Public
5. Save the Static Resource

<h5>Configure and Activate the OmniScript</h5>

1. Click on *App Launcher* → Search for “OmniScripts”
    1. Open the Epic Button OmniScript
    2. To configure different images or labels for the Context, select the Radio Button element in the OmniScript

![](/images/image3.png)
c. Click on each option title to configure the label and desired image. 
d. Activate the OmniScript
e. For more information regarding activating Omniscripts, please see this article: https://docs.vlocity.com/en/Activating-OmniScripts.html
![](/images/image4.png)

1. Add the installed OmniScript to the lightning page layout of your choosing. 
    1. Refer to this article for more information regarding adding OmniScripts to a Lightning or Experience page: https://docs.vlocity.com/en/Adding-an-LWC-OmniScript-to-a-Community-or-Lightning-Page.html

<h5>Configure User and Patient API Input Parameters:</h5>

1. To configure the *User ID Type* which is used in the Epic API, open the *GetUserIDForEHR* DataRaptor
    1. On the “*Output*” panel, set the *Extract JSON Path* to the User ID field which stores the User’s Epic User ID 
    2. By default, the DataRaptor uses the *FederationIdentifier* field on the User object in Salesforce.

![](/images/image5.png)
1. To configure the *Patient ID Type* which is used in the Epic API, open the *GetPatientEHRId* DataRaptor
    1. On the “*Output*” panel, set the *Extract JSON Path* to the Account field which stores the Epic patient ID
    2. By default, this is set to *Account.HealthCloudGA__SourceSystemId__c* on the Account object.

![](/images/image6.png)
<h5>Configure Additional API Parameters</h5>

1. To configure additional API parameters, open the OpenEpicPatientAndContext Integration Procedure.
2. Either deactivate or create a new version of the Integration Procedure to edit it.
3. Click on the SetAPIParameters and configure the values according to your business needs. For more information on parameters for the Receive Communication API, refer to the Epic documentation here: https://open.epic.com/Operational/ContactCenter

![](/images/image7.png)
1. Next, set the Epic Receive Communication API endpoint by doing the following:
    1. Click on CallEpicReceiveCommunicationAPI
    2. Add your organization’s unique API domain name before the existing text. For example: https://interconnect.makanahealth.com/wcf/Epic.Common.GeneratedServices/Utility.svc/rest_2015/ReceiveCommunication
    3. Add any additional Input Keys and Values according to your organization’s requirements (e.g., authentication keys). Work with your Epic administrator to determine additional needs.

![](/images/image8.png)
1. Activate the Integration Procedure.


<h2>Assumptions</h2>

1. A customer has licenses for Health Cloud, and the HINS Managed Package with OmniStudio. These solutions have all been installed and are functional.
2. A customer is assuming Salesforce Lightning Experience — not Classic.
3. Data Model elements that are part of the HINS (Vlocity) Managed package and Health Cloud are all available.
4. The Accelerator uses the Lightning Design System standards and look. Customers may want to apply their own branding which can be achieved.
5. A customer is live on Epic and has appropriate administrator resources to complete any required Epic configuration.
6. This tool is intended to provide capabilities for Customers to configure and optimize use of their implemented Salesforce Services. Customers should ensure that their use of this tool meets their own use case needs and compliance requirements (including any applicable healthcare and privacy laws, rules, and regulations).
7. Customers that use software, APIs, or other products from Epic may be subject to additional terms and conditions, including, without limitation, Epic's open.epic API Subscription Agreement terms.
8. Epic is a trademarks of Epic Systems Corporation.


<h2>Revision History</h2>

* *Revision Short Description (Month Day, Year)*

    * Initial Commit (October 31, 2022)

