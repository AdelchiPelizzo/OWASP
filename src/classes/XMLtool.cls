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
                    contact.lastName = detailElement.getText();
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


//        for ( Dom.XmlNode c : root.getChildElements() ) {
//            contact.FirstName = c.getChildElement('firstName', null).getText();
//            contact.LastName =  c.getChildElement('lastName', null).getText();
//            contact.Email =  c.getChildElement('email', null).getText();
//            contactList.add(contact);
//            contact = new Contact();
//        }
//        for(Contact c : contactList){
//            System.debug(c);
//        }
//        insert contactList;
        return contactList;
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
        }
    }
}
