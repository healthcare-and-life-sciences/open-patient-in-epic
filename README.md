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

This Accelerator is compatible with both Epic API directly or MuleSoft.

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
1. **EHR Pre-Configuration Steps:**
    1. Work with your Epic Administrator in order to activate the Receive Communication API web service. 
    2.If you are connecting to Epic directly, ensure your EHR system's network is configured to accept traffic from your Health Cloud org. If you are connecting to Epic via MuleSoft, you can skip this step.
    3. If you are connecting to Epic directly, install the Epic on FHIR App called “**Salesforce Health Cloud - Clinical Summary**” into your Epic organization. If you are connecting to Epic via MuleSoft, you can skip this step.
        1. **Client ID:** 43b0500b-ea80-41d4-be83-21230c837c15

2. **Salesforce Pre-Installation Steps:**
    1. Ensure your Salesforce Health Cloud org has Vlocity OmniStudio or Core OmniStudio installed.
        1. To verify installation, please navigate to Setup > Installed Packages > OmniStudio.
    2. Enable Identity Provider according to these steps: https://help.salesforce.com/s/articleView?id=sf.identity_provider_enable.htm&type=5
    3. If you are connecting to Epic directly, create Custom Metadata for Authentication Provider. If you are connecting to Epic via MuleSoft, you can skip this step.
        1. Setup > Custom Metadata Types
        2. New Metadata Type - ensure it is named **“ClientCredentialsJWT”**
        3. Add the following Custom fields. All fields should be “Text” fields with a length of 255 characters.
            1. aud
            2. callback uri
            3. cert
            4. iss
            5. jti
            6. sub

![](/images/fcimage2.png)

<h4>Install the Data Pack</h4>

1. Follow the download steps in the "Download Now" flow presented on the HLS Accelerators website for this Accelerator which downloads the following GitHub repository on your machine: https://hlsaccelerators.developer.salesforce.com/s/bundle/a9E5f000000PL7fEAG/open-patient-in-epic-button
2. Unzip the resulting .zip file which is downloaded to your machine. 
3. Open the “OmniStudio” folder
    1. If you have the Vlocity_ins package installed in your org, open the folder titled “Vlocity Version”.
    2. If you have Core OmniStudio installed in your org, open the folder titled "OmniStudio Version".
    3. Install the DataPack into your org. 
        1. Click on App Launcher → Search for 'OmniStudio DataPacks' and click on it.
        2. Click on 'Installed' > Import > From File
        3. When the window opens, select the json file identified in the previous step. Click 'Open' then click 'Next' 3 times.
        4. When prompted, click "Activate Now".

4. If you are connecting to Epic directly, open the “salesforce-sfdx” folder. Use IDX or sfdx to install the files under the “salesforce-sfdx” folder. If you are connecting to Epic via MuleSoft, you can skip this step.
   1. To access the IDX workbench, please navigate to this URL: https://workbench.developerforce.com/login.php
   2. For more information regarding IDX, please review this Trailhead: https://trailhead.salesforce.com/content/learn/modules/omnistudio-developer-tools
7. If you are connecting to Epic directly, import the keystore FHIRDEMOKEYSTORE.jks from .zip file. If you are connecting to Epic via MuleSoft, you can skip this step.
    1. Setup > Certificates and Key Management > Import from Keystore
    2. Password: salesforce1

<h4>Post-Install Configuration Steps:</h4>

<h5>Add buttonStyles.css to Static Resources</h5>

1. Navigate to Setup > Static Resources
2. Click New and name the Static Resource “buttonStyles”
3. Add the buttonStyles.css file
4. Set the resource to Public
5. Save the Static Resource

<h5>Configure and Activate the OmniScript</h5>

1. If you are connecting to Epic directly, create a new Authentication Provider
    1. Setup > Auth Providers
    2. Create a New Authentication Provider
        1. Provider Type: **ClientCredentialJWT**
        2. Name: Epic_JWT_Auth
        3. iss: 43b0500b-ea80-41d4-be83-21230c837c15
        4. sub: 43b0500b-ea80-41d4-be83-21230c837c15
        5. aud: set this to the API endpoint for authentication - either the MuleSoft API or Epic FHIR API - e.g., https://fhir.epic.com/interconnect-fhir-oauth/oauth2/token
        6. jti: salesforce
        7. cert: fhirdemo_cert
        8. callback uri: https://YOURDOMAIN/services/authcallback/Epic_JWT_Auth
        9. Execute Registration As: your system administrator User
![](/images/fcimage3.png)
2. **If you are connecting to Epic directly, Add your API endpoint to Remote Site Settings**
    1. Setup > Remote Site Settings > New
    2. Give the Remote Site a name and paste the domain of the API endpoint into the URL field.
    3. Click Save.
3. **If you are connecting to Epic directly, Create a new Named Credential**
    1. Setup > Named Credential > New Legacy
        1. Name: Must be **Epic Auth JWT**
        2. URL: the URL of the endpoint you are going to connect to. For example, https://fhir.epic.com/interconnect-fhir-oauth/ 
        3. Identity Type: Named Principal
        4. Authentication Protocol: OAuth 2.0
        5. Authentication Provider: the name of your Authentication Provider above
        6. “Run Authentication Flow on Save”: Checked
![](/images/fcimage4.png)

4. If you are connecting to Epic directly, set the Epic Receive Communication API endpoint by doing the following. If you are connecting to Epic via MuleSoft, you can skip this step.
    1. Click on CallEpicReceiveCommunicationAPI
    2. Add your organization’s unique API domain name before the existing text. For example: https://interconnect.makanahealth.com/wcf/Epic.Common.GeneratedServices/Utility.svc/rest_2015/ReceiveCommunication
    3. Add any additional Input Keys and Values according to your organization’s requirements (e.g., authentication keys). Work with your Epic administrator to determine additional needs.

![](/images/image8.png)

5. If you are using MuleSoft to connect to Epic, follow these steps to configure the Integration Procedure to call MuleSoft APIs:
   1. Follow the Epic Administration System API Setup Guide, if it has not already been completed as part of your MuleSoft implementation. https://anypoint.mulesoft.com/exchange/org.mule.examples/hc-accelerator-epic-us-core-administration-sys-api/minor/1.0/pages/edh-nhj/Setup%20Guide/
   2. Create new Remote Site (Setup > Remote Site Settings > New Remote Site) with the URL of the newly-created MuleSoft app.
   3. Create a Named Credential for your MuleSoft app.
   4. Update each HTTP Action element of the Integration Procedure titled CallEpicReceiveCommunicationAPI with the following:
      1. Path = endpoint of your MuleSoft app, without the domain. For example: /api/epic/2015/Common/Utility/RECEIVECOMMUNICATION/ReceiveCommunication
      2. Named Credential = the name of your MuleSoft Named Credential from step 3 above.
      3. Use the Preview pane to test the updates to the Integration Procedure.
      4. Activate the Integration Procedure.

<h5>Configure User and Patient API Input Parameters:</h5>

6. To configure the *User ID* which is used in the Epic API, open the *GetUserIDForEHR* DataRaptor
    1. On the “*Output*” panel, set the *Extract JSON Path* to the User ID field which stores the User’s Epic User ID 
    2. By default, the DataRaptor uses the *FederationIdentifier* field on the User object in Salesforce.

![](/images/image5.png)
7. To configure the *Patient ID Type* which is used in the Epic API, open the *GetPatientEHRId* DataRaptor
    1. On the “*Output*” panel, set the *Extract JSON Path* to the Account field which stores the Epic patient ID
    2. By default, this is set to *Account.HealthCloudGA__SourceSystemId__c* on the Account object.

![](/images/image6.png)
<h5>Configure Additional API Parameters</h5>

8. To configure additional API parameters, open the OpenEpicPatientAndContext Integration Procedure.
   1. Either deactivate or create a new version of the Integration Procedure to edit it.
   2. Click on the SetAPIParameters and configure the values according to your business needs. For more information on parameters for the Receive Communication API, refer to the Epic documentation here: https://open.epic.com/Operational/ContactCenter

![](/images/image7.png)

10. Activate the Integration Procedure.

**Activate the OmniScript**
11. Click on *App Launcher* → Search for “OmniScripts”
    1. Open the Epic Button OmniScript
    2. To configure different images or labels for the Context, select the Radio Button element in the OmniScript

![](/images/image3.png)
       c. Click on each option title to configure the label and desired image. 
       d. Activate the OmniScript
       e. For more information regarding activating Omniscripts, please see this article: https://docs.vlocity.com/en/Activating-OmniScripts.html
![](/images/image4.png)

12. Add the installed OmniScript to the lightning page layout of your choosing. 
    1. Refer to this article for more information regarding adding OmniScripts to a Lightning or Experience page: https://docs.vlocity.com/en/Adding-an-LWC-OmniScript-to-a-Community-or-Lightning-Page.html


<h2>Assumptions</h2>

1. A customer has licenses for Health Cloud, and the HINS Managed Package with OmniStudio. These solutions have all been installed and are functional.
2. A customer is assuming Salesforce Lightning Experience — not Classic.
3. Data Model elements that are part of the HINS (Vlocity) Managed package and Health Cloud are all available.
4. The Accelerator uses the Lightning Design System standards and look. Customers may want to apply their own branding which can be achieved.
5. A customer is live on Epic and has appropriate administrator resources to complete any required Epic configuration.
6. This tool is intended to provide capabilities for Customers to configure and optimize use of their implemented Salesforce Services. Customers should ensure that their use of this tool meets their own use case needs and compliance requirements (including any applicable healthcare and privacy laws, rules, and regulations).
7. Customers that use software, APIs, or other products from Epic may be subject to additional terms and conditions, including, without limitation, Epic's open.epic API Subscription Agreement terms.
8. Epic is a trademark of Epic Systems Corporation.


<h2>Revision History</h2>

* *Revision Short Description (Month Day, Year)*

    * Initial Commit (October 31, 2022)
    * Updated to include Epic authentication configuration from Salesforce to Epic directly (May 4, 2023)

