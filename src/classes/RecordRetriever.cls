/**
 * Created by Adelchi on 18/01/2022.
 * Purpose : Testing Area for Injection SQL
 */


public  with sharing class RecordRetriever {

    /**
 * Purpose : Stop Process if any dangerous characters are used.
 * @param (parameter input) (String passed from user)
 * @return (List of Contacts)
 */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContacts(String input){

        List<Contact> lstContact = new List<Contact>();

        String nameAttk = String.escapeSingleQuotes(input);
        String s = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+nameAttk+'%\'';

        if(input.containsNone('&|!(){}[]^"~*?:\\+-%')){
            String name = String.escapeSingleQuotes(input);
            String q = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+name+'%\'';
            Contact[] cList = Database.query(q);
            for(Contact c : cList){
                lstContact.add(c);
            }
            return lstContact;
        }else{
            throw new AuraHandledException('Parameter Not Valid> [ '+s+' ]');
        }
    }

    /**
 * Purpose : Stop Process if any characters not a word is entered.
 * @param (parameter input) (String passed from user)
 * @return (List of Contacts)
 */

    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsReg(String input){

        List<Contact> lstContact = new List<Contact>();

        String s = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+input+'%\'';

        Pattern pattern = Pattern.compile('/\\w/gmi');
        Matcher matcher = pattern.matcher(input);

        if(matcher.matches()){
            String q = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+input+'%\'';
            Contact[] cList = Database.query(q);
            for(Contact c : cList){
                lstContact.add(c);
            }
            return lstContact;
        }else{
            throw new AuraHandledException('Parameter Not Valid> [ '+s+' ]');
        }
    }

    /**
 * Purpose : Stop Process if any dangerous characters are used.
 * @param (parameter input) (String passed from user)
 * @return (List of Contacts)
 */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsTW(String input){

        List<Contact> lstContact = new List<Contact>();

        String nameAttk = String.escapeSingleQuotes(input);
        String s = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \''+nameAttk+'%\'';

        if(input.containsNone('&|!(){}[]^"~*?:\\+-%')){
            String name = String.escapeSingleQuotes(input);
            String q = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \''+name+'%\'';
            Contact[] cList = Database.query(q);
            for(Contact c : cList){
                lstContact.add(c);
            }
            return lstContact;
        }else{
            throw new AuraHandledException('Parameter Not Valid> [ '+s+' ]');
        }
    }

    /**
 * Purpose : Stop Process if any dangerous characters are used.
 * @param (parameter input) (String passed from user)
 * @return (List of Contacts)
 */
    @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsLW(String input){

        List<Contact> lstContact = new List<Contact>();

        String nameAttk = String.escapeSingleQuotes(input);
        String s = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+nameAttk+'\'';

        if(input.containsNone('&|!(){}[]^"~*?:\\+-%')){
            String name = String.escapeSingleQuotes(input);
            String q = 'SELECT firstName, Id FROM Contact WHERE firstName LIKE \'%'+name+'\'';
            Contact[] cList = Database.query(q);
            for(Contact c : cList){
                lstContact.add(c);
            }
            return lstContact;
        }else{
            throw new AuraHandledException('Parameter Not Valid> [ '+s+' ]');
        }
    }

    /**
 * Purpose : Pass value FALSE  if any characters other than Boolean TRUE are used.
 * @param (parameter input) (String passed from user)
 * @return (List of Contacts)
 */
    @AuraEnabled(cacheable=true)
    public static List<User> getUsersActive(String bool){

        List<User> lstContact = new List<User>();
        String q = 'SELECT Name, Id FROM User WHERE IsActive =' + Boolean.valueOf(bool);
        User[] userList = Database.query(q);
        for(User u : userList){
            lstContact.add(u);
        }
        return userList;
    }

    @AuraEnabled(cacheable=true)
    public static List<Contact> findContacts(String searchKey) {
        String key = '%' + searchKey + '%';
        return [
                SELECT Id, Name, Title, Phone, Email
                FROM Contact
                WHERE Name LIKE :key
                WITH SECURITY_ENFORCED
                LIMIT 10
        ];
    }
}
