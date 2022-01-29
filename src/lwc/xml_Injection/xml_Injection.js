/**
 * Created by Adelchi on 25/01/2022.
 */

import {LightningElement, api, wire, track} from 'lwc' ;
import addContact from '@salesforce/apex/XMLtool.addContactViaXML';
import addContactOvl from '@salesforce/apex/XMLtool.addContactViaXMLOverload';
import addContactBuildOnServer from '@salesforce/apex/XMLtool.addContactBuildEscapeXML';

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


    @track
    firstName;

    @track
    lastName;

    @track
    email;

    @api
    contacts;

    @api
    error;

    @api
    wait = false;

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

    closeWait(){
        this.wait = false;
    }

    closeContact(){
        this.contacts = '';
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

    addContactBuildOnSer(){

        let inputLst = [];

        inputLst[0] = this.firstName;
        inputLst[1] = this.lastName;
        inputLst[2] = this.email;

        this.wait = true;

        let el = this.template.querySelectorAll('lightning-input');
        for(let i = 0; i < el.length; i++){
            el[i].value  = '';
        }

        addContactBuildOnServer({inputList: inputLst}).then(result => {
            console.log('sending to server');
            this.contacts = result;
            this.wait = false;
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
