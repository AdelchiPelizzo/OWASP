/**
 * Created by Adelchi on 25/01/2022.
 */

import {LightningElement, api, wire, track} from 'lwc' ;
import addContact from '@salesforce/apex/XMLtool.addContactViaXML';
import addContactOvl from '@salesforce/apex/XMLtool.addContactViaXMLOverload';

export default class xmlInjection extends LightningElement {

    @api
    XMLContactString =
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
        '</contact>';


    @api
    firstName;

    @api
    lastName;

    @api
    email;

    @api
    contacts;

    @api
    error;

    setFirstName(event){
        this.firstName = event.target.value;
    }

    setLastName(event){
        this.lastName = event.target.value;
    }

    setEmail(event){
        this.email = event.target.value;
    }

    close(){
        this.error = '';
    }

    buildXMLandSendOvl(){

        this.XMLContactString =
                '<contact>' +
                    '<firstName>'+this.firstName+'</firstName>' +
                    '<lastName>' +this.lastName+'</lastName>' +
                    '<email>'+this.email+'</email>' +
                '</contact>';

        addContactOvl({xmlString: this.XMLContactString}).then(result => {
            this.contacts = result;
        }).catch(error => {
            console.log(error);
            this.error = error.body.message;
        });

    }

    buildXMLandSend(){
        addContact().then(result => {
            this.contacts = result;
        }).catch(error => {
            this.error = error;
        });

    }
}
