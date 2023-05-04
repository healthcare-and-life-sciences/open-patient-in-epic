/*
 * Copyright (c) 2023, salesforce.com, inc.
 * All rights reserved.
 * SPDX-License-Identifier: BSD-3-Clause
 * For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
 *
 *
 *
 * Custom Authentication Provider to support the client_credential JWT Bearer flow that is used by 
 * ehrs like Epic and eCW.  This will be supported withtin the next few releases. To be used with a 
 * legacy named credential.
 * 
 * Requires a Custom Metadata Type called 'EHR Auth' with the following fields:
 * 
 * iss: client id (or app id)
 * sub:
 * aud:
 * cert: the certificate used to sign your app or used to create the JWKS
 * callback uri:  Save your authentication provider once and then you can copy the callback url into this field. 
 * Toekn Endpoint: no used - to be removed
 * 
 * 
 * Version 1.0
 *
 * April 6, 2023
 * 
 *
 * author: Derek Cassese - Accelerate HLS - dcassese@salesforce.com
 * 
 *
 */
public class ClientCredentialJWT extends Auth.AuthProviderPluginClass {
    private String metadataApiName = 'ClientCredentialsJWT__mdt';
    private String callbackUrl ='';
    private String tokenType = 'Bearer';
    private String authProviderName = 'ClientCredentialJWT';
  
    public  String getCustomMetadataType() {
        return metadataApiName;
    }
      
    public PageReference initiate(Map<string,string> authProviderConfiguration, String stateToPropagate) { 

        callbackUrl += authProviderConfiguration.get('callback_uri__c') + '?state=' + stateToPropagate;
        return new PageReference(callbackUrl);
    } 
     
    public Auth.AuthProviderTokenResponse handleCallback(Map<string,string> authProviderConfiguration, Auth.AuthProviderCallbackState state ) { 

        String refreshToken = EncodingUtil.base64Encode (Crypto.generateAesKey (128)) ; // random refreshToken required or named credential will not refresh
        HttpResponse res = obtainAccessToken(authProviderConfiguration);
        ResponseWrapper responseWrapper = (ResponseWrapper) JSON.deserialize(res.getBody(), ResponseWrapper.class);
        return new Auth.AuthProviderTokenResponse(authProviderName, responseWrapper.access_token, refreshToken, state.queryParameters.get('state'));
      } 

    public override Auth.OAuthRefreshResult refresh(Map<String,String> authProviderConfiguration, String refreshToken) {
        HttpResponse res = this.obtainAccessToken(authProviderConfiguration);
		ResponseWrapper responseWrapper = (ResponseWrapper) JSON.deserialize(res.getBody(), ResponseWrapper.class);
        return new Auth.OAuthRefreshResult(responseWrapper.access_token, tokenType);
    }
                 
    /*     The code that go and grabs the access_code   */

    private HttpResponse obtainAccessToken(Map<string,string> authProviderConfiguration) {
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        String iss = authProviderConfiguration.get('iss__c');
        String sub = authProviderConfiguration.get('sub__c');
        String aud = authProviderConfiguration.get('aud__c');
        String jti = authProviderConfiguration.get('jti__c');
        Long exp = DateTime.now().addMinutes(5).getTime();
        String fixedExp = String.valueOf(exp);
        fixedExp = fixedExp.subString(0, fixedExp.length() - 3);
        // Start constructing the header and claims
        String jwtHeader = '{"alg":"RS256","typ":"JWT"}';
        String jwtClaims = '{"iss":"' + iss + '","sub":"' + sub + '","aud":"' + aud + '","jti":"' + jti + '","exp":' + fixedExp + '}';
        String encodedHeader = base64URLencode(Blob.valueOf(jwtHeader));
        String jwtRequest = encodedHeader + '.' + base64URLencode(Blob.valueOf(jwtClaims));
        Blob signature = null;
        String certname = authProviderConfiguration.get('cert__c');
        signature = Crypto.signWithCertificate('rsa-sha256', Blob.valueOf(jwtRequest), certname);
        jwtRequest = jwtRequest + '.' + base64URLencode(signature);
        String signedJwtRequest = jwtRequest;
        String payload =
            'grant_type=client_credentials&client_assertion_type=' +
            System.EncodingUtil.urlEncode('urn:ietf:params:oauth:client-assertion-type:jwt-bearer', 'UTF-8');
        payload += '&client_assertion=' + signedJwtRequest;
        Http httpObj = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res;
        req.setEndpoint(aud);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setBody(payload);
        res = httpObj.send(req);
        return res;
    }

    public Auth.UserData getUserInfo(Map<string,string> authProviderConfiguration, Auth.AuthProviderTokenResponse response) 
    { 
        return new Auth.UserData('fakeId', 'first', 'last', 'full', 'a Backend Service (Accelerate HLS)', 'link', null, null, null, null, null);
    } 
    
    public static String base64URLencode(Blob input) {
        String output = encodingUtil.base64Encode(input);
        output = output.replace('+', '-');
        output = output.replace('/', '_');
        while (output.endsWith('=')) {
            output = output.subString(0, output.length() - 1);
        }
        return output;
    }
      
    public class ResponseWrapper {
        public String access_token;
        public String token_type;
        public String expires_in;
    }
      
  }