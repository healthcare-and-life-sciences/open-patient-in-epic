
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
* Chart - this represents a blank context which will trigger a default documentation activity configured by the organization.

This Accelerator is compatible with both Epic ReceiveCommunication API directly or via MuleSoft. Instructions for configuring the accelerator for either method are included below. 

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
* User clicks the Open Patient in Epic button which launches the patient’s record with specified context in Epic on the user's desktop.


<h2>Package Includes:</h2>

*OmniScript (1)*

* Epic Button OmniScript

*DataRaptor (2)*

* GetPatientEHRId
* GetUserIDForEHR
* EpicReceiveCommunicationJSONTransform

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
<h3>1. EHR Pre-Configuration Steps:</h3>

* Work with your Epic Administrator in order to activate the Receive Communication API web service. If your organization is using the ReceiveCommunication2 API, the accelerator may be configured easily to call this API instead. 
* You may need to perform the following build steps in the Epic EHR:
	* Computer Telephony build to enable CT capabilities
	* Create an external ID type and assign it to your users who will be using the Accelerator
	* Configure Activity records in Epic that you wish to be supported in the Accelerator (e.g., Scheduling, Telephone)

<h3>2. Salesforce Pre-Installation Steps:</h3>

Ensure your Salesforce Health Cloud org has Vlocity OmniStudio or Core OmniStudio installed.
* To verify installation, please navigate to Setup > Installed Packages > OmniStudio.
* Enable Identity Provider according to these steps: https://help.salesforce.com/s/articleView?id=sf.identity_provider_enable.htm&type=5

<h3>2. Install the Data Pack:</h3>

* Follow the download steps in the **"Download Now"** flow presented on the HLS Accelerators website for this Accelerator which downloads the following GitHub repository on your machine: https://hlsaccelerators.developer.salesforce.com/s/bundle/a9E5f000000PL7fEAG/open-patient-in-epic-button
* Unzip the resulting .zip file which is downloaded to your machine. 
* Open the **“OmniStudio”** folder
	* If you have the Vlocity_ins package installed in your org, open the folder titled “Vlocity Version”.
	* If you have Core OmniStudio installed in your org, open the folder titled "OmniStudio Version".
	* Install the DataPack into your org. 
		* In Salesforce, click on **App Launcher** → Search for **"OmniStudio DataPacks"** and click on it.
		* Click on **"Installed"** > Import > From File
		* When the window opens, select the .json file identified in the previous step. Click **"Open"** then click 'Next' 3 times.
		* When prompted, click **"Activate Now"**.


<h3>3. Post-Installation Steps:</h3>

<h4>Add buttonStyles.css to Static Resources:</h4>

1. Navigate to **Setup** > Static Resources
2. Click **New** and name the Static Resource “buttonStyles”
3. Add the buttonStyles.css file
4. Set the resource to **Public**
5. **Save** the Static Resource

<h3>4. Integration Setup</h3>
There are 3 different ways to configure this accelerator based on your organization's integration strategy. Click on the links below to be taken to the appropriate instructions for your architecture:

* [MuleSoft Direct](#MuleSoft-Direct)
* [MuleSoft Anypoint Platform](#MuleSoft-Anypoint-Platform)
* [Directly to Epic Interconnect](#Epic-Direct-Connection)

<h2>MuleSoft Direct</h2>
*Available starting June 5, 2023*

Required SKUs:
* Health Cloud
* Anypoint Starter or Base

<h3>1. Complete MuleSoft Direct Configuration:</h3>

* Complete the Setup steps for the [**Integrations Setup for Industry Integration Solutions**](https://help.salesforce.com/s/articleView?language=en_US&id=sf.industry_integration_solutions.htm&type=5)
	* In the **Generic FHIR Client Setup**, enter the following information for the Epic EHR credentials
		* **Authentication Protocol**: JSON Web Token
		* **Base URL**: your Epic FHIR server’s base URL
		* **Token URL**: your Epic FHIR server’s authentication URL
		* **Client ID**: 43b0500b-ea80-41d4-be83-21230c837c15
		* **Private Key** - import the Private Key which is included in the Accelerator download .zip folder  
		* **Non-PRD Test Information**:
			* **Endpoint**: [https://fhir.epic.com/interconnect-fhir-oauth/oauth2/token](https://fhir.epic.com/interconnect-fhir-oauth/oauth2/token)
			* **Client ID**: fe0e3375-fffa-469b-8338-d5fe08f7d3b1
			* Refer to the **Epic FHIR App**: Salesforce Health Cloud - Clinical Summary

<h3>2. Configure the Accelerator:</h3>

Update the **CallEpicReceiveCommunicationAPI** Integration Procedure to use the MuleSoft Direct connection instead of Epic FHIR APIs directly:

* App Launcher > Integration Procedures > CallEpicReceiveCommunicationAPI
	* Create a **New Version** of the Integration Procedures
	* For the **HTTP Action** element, make the following changes:
		* In the **Path** field, remove the “/FHIR/R4” portion of the path such that the Path = /api/AllergyIntolerance (for example)
		* Replace **Epic_Auth_JWT** with the name of the Named Credential resulting from the MuleSoft Direct setup above (e.g. **Health_generic_system_app**)
	* **Activate** your new Integration Procedure version

<h4>Configure User and Patient API Input Parameters:</h4>

* To configure the *User ID* which is used in the Epic API, open the *GetUserIDForEHR* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the User ID field which stores the User’s Epic User ID 
	* By default, the DataRaptor uses the *FederationIdentifier* field on the User object in Salesforce.
![](/images/image5.png)
* To configure the *Patient ID Type* which is used in the Epic API, open the *GetPatientEHRId* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the Account field which stores the Epic patient ID
    * By default, this is set to *Account.HealthCloudGA__SourceSystemId__c* on the Account object.
![](/images/image6.png)
<h4>Configure Additional API Parameters</h4>

* To configure additional API parameters, open the OpenEpicPatientAndContext Integration Procedure.
   * Either deactivate or create a new version of the Integration Procedure to edit it.
   * Click on the SetAPIParameters and configure the values according to your business needs. For more information on parameters for the Receive Communication API, refer to the Epic documentation here: https://open.epic.com/Operational/ContactCenter
![](/images/image7.png)
 * **Activate** your new Integration Procedure version

<h4>Configure the OmniScript</h4>

* Click on *App Launcher* → Search for “OmniScripts”
    * Open the Epic Button OmniScript
    * To configure different images or labels for the Context, select the Radio Button element in the OmniScript
![](/images/image3.png)
* Click on each option title to configure the label and desired image. 
	* Activate the OmniScript
	* For more information regarding activating Omniscripts, please see this article: https://docs.vlocity.com/en/Activating-OmniScripts.html
![](/images/image4.png)
* Add the installed OmniScript to the lightning page layout of your choosing. 
    * Refer to this article for more information regarding adding [**OmniScripts to a Lightning or Experience page**](https://docs.vlocity.com/en/Adding-an-LWC-OmniScript-to-a-Community-or-Lightning-Page.html) 


<h2>MuleSoft Anypoint Platform</h2>

<h3>1. Pre-Install Configuration Steps:</h3>

Required SKUs:
* Health Cloud
* Anypoint Platform



<h3>1. Configure MuleSoft</h3>

* Follow the [**Epic Administration System API Setup Guide**](https://anypoint.mulesoft.com/exchange/org.mule.examples/hc-accelerator-epic-us-core-administration-sys-api/minor/1.0/pages/edh-nhj/Setup%20Guide/)
* Create a new **Remote Site** (Setup > Remote Site Settings > New Remote Site) with the URL of the newly-created **MuleSoft app**.
* Create a **Named Credential** for your **MuleSoft app**:
	* Refer to **steps 5 - 8** in this article for the detailed setup: [https://sfdc247.com/2021/11/step-by-step-guide-on-integrating-mulesoft-and-salesforce.html](https://sfdc247.com/2021/11/step-by-step-guide-on-integrating-mulesoft-and-salesforce.html)
	* You do **NOT** need to complete the **External Services** configuration in the article above

<h3>2. Configure the Accelerator</h3>

* App Launcher > Integration Procedures > CallEpicReceiveCommunicationAPI
	* Create a **New Version** of the Integration Procedure
	* For the **HTTP Action** element, make the following changes:
		* In the **Path** field, set it to the URL of the newly-created **MuleSoft app**.
		* In the Named Credential field, Replace **Epic_Auth_JWT** with the newly created **Named Credential** for your **MuleSoft app**

<h4>Configure User and Patient API Input Parameters:</h4>

* To configure the *User ID* which is used in the Epic API, open the *GetUserIDForEHR* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the User ID field which stores the User’s Epic User ID 
	* By default, the DataRaptor uses the *FederationIdentifier* field on the User object in Salesforce.
![](/images/image5.png)
* To configure the *Patient ID Type* which is used in the Epic API, open the *GetPatientEHRId* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the Account field which stores the Epic patient ID
    * By default, this is set to *Account.HealthCloudGA__SourceSystemId__c* on the Account object.
![](/images/image6.png)
<h4>Configure Additional API Parameters</h4>

* To configure additional API parameters, open the OpenEpicPatientAndContext Integration Procedure.
   * Either deactivate or create a new version of the Integration Procedure to edit it.
   * Click on the SetAPIParameters and configure the values according to your business needs. For more information on parameters for the Receive Communication API, refer to the Epic documentation here: https://open.epic.com/Operational/ContactCenter
![](/images/image7.png)
 * **Activate** your new Integration Procedure version

<h4>Configure the OmniScript</h4>

* Click on *App Launcher* → Search for “OmniScripts”
    * Open the Epic Button OmniScript
    * To configure different images or labels for the Context, select the Radio Button element in the OmniScript
![](/images/image3.png)
* Click on each option title to configure the label and desired image. 
	* Activate the OmniScript
	* For more information regarding activating Omniscripts, please see this article: https://docs.vlocity.com/en/Activating-OmniScripts.html
![](/images/image4.png)
* Add the installed OmniScript to the lightning page layout of your choosing. 
    * Refer to this article for more information regarding adding [**OmniScripts to a Lightning or Experience page**](https://docs.vlocity.com/en/Adding-an-LWC-OmniScript-to-a-Community-or-Lightning-Page.html) 

<h2>Epic Direct Connection</h2>

Required SKUs:
* Health Cloud

<h3>1. EHR Pre-Configuration Steps:</h3>

* Ensure your EHR system's network is configured to accept traffic from your Health Cloud org.
* Install the Epic on FHIR App called “**Salesforce Health Cloud - Clinical Summary**” into your Epic organization. 
	* **Client ID:** 43b0500b-ea80-41d4-be83-21230c837c15

<h3>2. Salesforce Pre-Installation Steps:</h3>

<h4>Create a new Custom Metadata Type </h4>

* Setup > **Custom Metadata Types**
	* New Metadata Type - **must be named** as follows:  **ClientCredentialsJWT**
        * Add the following **Custom fields**. All fields should be **“Text”** fields with a length of **255** characters.
            * aud
            * callback uri
            * cert
            * iss
            * jti
            * sub
![](/images/fcimage2.png)
<h4>Install custom Apex Class</h4>

* Open the **“salesforce-sfdx”** folder in the .zip file that you downloaded for the Accelerator. 
* Use IDX or sfdx to install the files under the “salesforce-sfdx” folder. 
	* Click here to access the [**IDX workbench**](https://workbench.developerforce.com/login.php)
	* For more information regarding IDX, please review this [**Trailhead**](https://trailhead.salesforce.com/content/learn/modules/omnistudio-developer-tools)
* Alternatively, you may create a new Apex Class manually by performing the following:
	* Setup > Apex Classes > New
	* Copy the entire code of the Apex Class in the salesforce-sfdx folder and paste in the new Apex Class editor and Save.
* Import the keystore **FHIRDEMOKEYSTORE.jks** from .zip file. 
	* Setup > **Certificates and Key Management** > Import from **Keystore**
	* **Password**: salesforce1


<h4>Create a new Authentication Provider</h4>

* Setup > Auth Providers
    * Create a New Authentication Provider
        * Provider Type: **ClientCredentialJWT**
        * Name: Epic_JWT_Auth
        * iss: 43b0500b-ea80-41d4-be83-21230c837c15
        * sub: 43b0500b-ea80-41d4-be83-21230c837c15
        * aud: set this to the API endpoint for authentication - either the MuleSoft API or Epic FHIR API - e.g., https://fhir.epic.com/interconnect-fhir-oauth/oauth2/token
        * jti: salesforce
        * cert: fhirdemo_cert
        * callback uri: https://YOURDOMAIN/services/authcallback/Epic_JWT_Auth
        * Execute Registration As: your system administrator User
![](/images/fcimage3.png)
<h4>Configure Remote Site Settings</h4>

* Setup > Remote Site Settings > New
    * Give the Remote Site a name and paste the domain of the API endpoint into the URL field.
    * Click Save.

<h4>Create a new Named Credential</h4>

* Setup > **Named Credential** > **New Legacy**
	* **Name**: **Must be** the following: **Epic Auth JWT**
	* **URL**: the URL of the endpoint you are going to connect to. For example, https://fhir.epic.com/interconnect-fhir-oauth/ 
	* **Identity Type**: Named Principal
	* **Authentication Protocol**: OAuth 2.0
	* **Authentication Provider**: the name of your Authentication Provider above
	* Check the **“Run Authentication Flow on Save”** box
![](/images/fcimage4.png)

<h3>3. Configure the Accelerator</h3>


* App Launcher > Integration Procedures > **EHRConnectDirect/ReceiveCommunication**
	* Create a **New Version** of the Integration Procedure
	* For the **HTTP Action** element, make the following changes:
		* In the **Path** field, add your organization’s unique API domain name before the existing text. For example: https://**interconnect.makanahealth.com**/wcf/Epic.Common.GeneratedServices/Utility.svc/rest_2015/ReceiveCommunication
		* Add any additional Input Keys and Values according to your organization’s requirements (e.g., authentication keys). Work with your Epic administrator to determine additional needs.

![](/images/image8.png)
<h4>Configure User and Patient API Input Parameters:</h4>

* To configure the *User ID* which is used in the Epic API, open the *GetUserIDForEHR* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the User ID field which stores the User’s Epic User ID 
	* By default, the DataRaptor uses the *FederationIdentifier* field on the User object in Salesforce.
![](/images/image5.png)
* To configure the *Patient ID Type* which is used in the Epic API, open the *GetPatientEHRId* DataRaptor
	* On the “*Output*” panel, set the *Extract JSON Path* to the Account field which stores the Epic patient ID
    * By default, this is set to *Account.HealthCloudGA__SourceSystemId__c* on the Account object.
![](/images/image6.png)
<h4>Configure Additional API Parameters</h4>

* To configure additional API parameters, open the OpenEpicPatientAndContext Integration Procedure.
   * Either deactivate or create a new version of the Integration Procedure to edit it.
   * Click on the SetAPIParameters and configure the values according to your business needs. For more information on parameters for the Receive Communication API, refer to the Epic documentation here: https://open.epic.com/Operational/ContactCenter
![](/images/image7.png)
 * **Activate** your new Integration Procedure version

<h4>Configure the OmniScript</h4>

* Click on *App Launcher* → Search for “OmniScripts”
    * Open the Epic Button OmniScript
    * If not already deactivated, Deactivate the OmniScript.
    * Click on the "Open Patient in Epic" Action button
    * Change the Integration Procedure to EHRConnectDirect_ReceiveCommunication instead of EHRConnect_ReceiveCommunication. 
    * To configure different images or labels for the Context, select the Radio Button element in the OmniScript
![](/images/image3.png)
* Click on each option title to configure the label and desired image. 
	* Activate the OmniScript
	* For more information regarding activating Omniscripts, please see this article: https://docs.vlocity.com/en/Activating-OmniScripts.html
![](/images/image4.png)
* Add the installed OmniScript to the lightning page layout of your choosing. 
    * Refer to this article for more information regarding adding [**OmniScripts to a Lightning or Experience page**](https://docs.vlocity.com/en/Adding-an-LWC-OmniScript-to-a-Community-or-Lightning-Page.html) 


<h2>Assumptions</h2>

1. A customer has licenses for Health Cloud, and either the HINS Managed Package with OmniStudio or Core OmniStudio. These solutions have all been installed and are functional.
2. A customer is assuming Salesforce Lightning Experience — not Classic.
3. Data Model elements that are part of Health Cloud and the HINS (Vlocity) Managed package or Core OmniStudio are all available.
4. The Accelerator uses the Lightning Design System standards and look. Customers may want to apply their own branding which can be achieved.
5. A customer is live on Epic and has appropriate administrator resources to complete any required Epic configuration.
6. This tool is intended to provide capabilities for Customers to configure and optimize use of their implemented Salesforce Services. Customers should ensure that their use of this tool meets their own use case needs and compliance requirements (including any applicable healthcare and privacy laws, rules, and regulations).
7. Customers that use software, APIs, or other products from Epic may be subject to additional terms and conditions, including, without limitation, Epic's open.epic API Subscription Agreement terms.
8. Epic is a trademark of Epic Systems Corporation.


<h2>Revision History</h2>

* *Revision Short Description (Month Day, Year)*

    * Initial Commit (October 31, 2022)
    * Updated to include Epic authentication configuration from Salesforce to Epic directly (May 4, 2023)
    * Updated instructions with the 3 different options for integration with Epic (May 23, 2023)

