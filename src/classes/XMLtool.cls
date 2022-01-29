/**
 * Created by Adelchi on 24/01/2022.
 * Purpose : (Write a succinct description of this class here.)
 */


public with sharing class XMLtool {
    /**
 * Purpose : (Write a succinct description of this method here.)
 * @param (parameter name) (Describe the first parameter here)
 * @param (parameter name) (Do the same for each additional parameter)
 * @return (description of the return value)
 */

    public static String toParse =
            '<contacts>'+
                '<contact>' +
                    '<firstName>John</firstName>' +
                    '<lastName>Doe</lastName>' +
                    '<email>joedoe@A2ZCorp.com</email>' +
                '</contact>' +
                '<contact>' +
                    '<firstName>Jane</firstName>' +
                    '<lastName>Doe</lastName>' +
                    '<email>janedoe@A2ZCorp.com</email>' +
                '</contact>' +
                '<contact>' +
                    '<firstName>Alice</firstName>' +
                    '<lastName>Joyce</lastName>' +
                    '<email>aliceloyce@A2ZCorp.com</email>' +
                '</contact>' +
                '<contact>' +
                    '<firstName>Hacker</firstName>' +
                    '<lastName>Hacker</lastName>' +
                    '<email>hacker@example.net</email>' +
                '</contact>'+
            '</contacts>';

    @AuraEnabled
    public static List<Contact> addContactViaXML(){
        List<Contact> contactList = new List<Contact>();

        DOM.Document doc = new DOM.Document();
        doc.load(toParse);
        Dom.XmlNode root = doc.getRootElement();


        Contact contact = new Contact();

        for ( Dom.XMLNode childElement : root.getChildElements() ) {
            for ( Dom.XMLNode detailElement : childElement.getChildElements() ) {
                if (detailElement.getName() == 'firstName' &&  !detailElement.getText().containsAny('</\\>-')) {
                    contact.FirstName = detailElement.getText();
                } else if (detailElement.getName() == 'lastName' &&  !detailElement.getText().containsAny('</\\>-')) {
                    contact.LastName = detailElement.getText();
                } else if (detailElement.getName() == 'email' &&  !detailElement.getText().containsAny('</\\>-')) {
                    contact.Email = detailElement.getText();
                } else {
                    throw new AuraHandledException('XML Not Valid');
                }
            }
            contactList.add(contact);
            contact = new Contact();
        }
        insert contactList;
        return contactList;
    }

    @AuraEnabled
    public static Contact addContactBuildEscapeXML(List<String> inputList){

        System.debug(inputList);

        Dom.Document dd = new Dom.Document();
        Dom.XmlNode contacts = dd.createRootElement('contacts', null, null);
        Dom.XmlNode body1 = contacts.addChildElement('contact', null, null);
        Dom.XmlNode body11 = body1.addChildElement('firstName', null, null);
        body11.addTextNode(String.escapeSingleQuotes(inputList[0]));
        Dom.XmlNode body12 = body1.addChildElement('lastName', null, null);
        body12.addTextNode(String.escapeSingleQuotes(inputList[1]));
        Dom.XmlNode body13 = body1.addChildElement('email', null, null);
        body13.addTextNode(String.escapeSingleQuotes(inputList[2]));

        String toParse =
            '<contact>' +
                '<firstName>'+inputList[0].escapeXml()+'</firstName>' +
                '<lastName>'+inputList[1].escapeXml()+'</lastName>' +
                '<email>'+inputList[2].escapeXml()+'</email>' +
            '</contact>';
        System.debug(toParse);
        System.debug(dd.toXmlString());

        try {
            Dom.XmlNode contactRoot = dd.getRootElement();
            List<DOM.XmlNode> n = contactRoot.getChildren();
            Contact contact = new Contact();
            for(DOM.XmlNode nd : n){
                if(!nd.getChildElement('firstName', null).getText().containsAny('</\\>-')){
                    contact.FirstName = nd.getChildElement('firstName', null).getText();
                }else {
                    throw new AuraHandledException('XML parsed but Not Valid for firstName field '+ nd.getChildElement('firstName', null).getText());
                }
                if(!nd.getChildElement('lastName', null).getText().containsAny('</\\>-')){
                    contact.LastName = nd.getChildElement('lastName', null).getText();
                }else {
                    throw new AuraHandledException('XML parsed but Not Valid for lastName field'+ nd.getChildElement('lastName', null).getText());
                }
                if(!nd.getChildElement('email', null).getText().containsAny('</\\>-')){
                    contact.Email = nd.getChildElement('email', null).getText();
                }else{
                    throw new AuraHandledException('XML parsed but Not Valid for email field'+ nd.getChildElement('email', null).getText());
                }

            }
            insert contact;
            return contact;
        } catch ( System.XmlException e){
            throw new AuraHandledException('XML Not Valid \n- '+ e.getTypeName()+'\n - '+e.getMessage()+'\n - '+e.getStackTraceString());
        }finally{
            System.debug('NO BREXIT');
        }
    }



    @AuraEnabled
    public static Contact addContactViaXMLOverload(String xmlString){
        try {
            DOM.Document doc = new DOM.Document();
            doc.load(xmlString);
            Dom.XmlNode contactRoot = doc.getRootElement();
            Contact contact = new Contact();
            if(!contactRoot.getChildElement('firstName', null).getText().containsAny('</\\>-')){
                contact.FirstName = contactRoot.getChildElement('firstName', null).getText();
            }else {
                throw new AuraHandledException('XML parsed but Not Valid for firstName field '+ contactRoot.getChildElement('firstName', null).getText());
            }
            if(!contactRoot.getChildElement('lastName', null).getText().containsAny('</\\>-')){
                contact.LastName = contactRoot.getChildElement('lastName', null).getText();
            }else {
                throw new AuraHandledException('XML parsed but Not Valid for lastName field'+ contactRoot.getChildElement('lastName', null).getText());
            }
            if(!contactRoot.getChildElement('email', null).getText().containsAny('</\\>-')){
                contact.Email = contactRoot.getChildElement('email', null).getText();
                throw new AuraHandledException('XML parsed but Not Valid for email field '+ contactRoot.getChildElement('email', null).getText());
            }

            insert contact;
            return contact;
        } catch ( System.XmlException e){
            throw new AuraHandledException('XML Not Valid \n- '+ e.getTypeName()+'\n - '+e.getMessage()+'\n - '+e.getStackTraceString());
        }finally{
            System.debug('NO BREXIT');
        }

    }

    public static void deleteTodayContacts(){
        List<Contact> lsC = [SELECT Id FROM Contact WHERE  CreatedDate = TODAY];
        delete lsC;
    }

}
