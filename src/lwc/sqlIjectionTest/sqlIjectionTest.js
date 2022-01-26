/**
 * Created by Adelchi on 18/01/2022.
 */

import {LightningElement, api, wire, track} from 'lwc' ;
import getContactTW from '@salesforce/apex/RecordRetriever.getContactsTW';
import getContactLW from '@salesforce/apex/RecordRetriever.getContactsLW';
import getContact from '@salesforce/apex/RecordRetriever.getContacts';
import getUserB from '@salesforce/apex/RecordRetriever.getUsersActive';
import getContactReg from '@salesforce/apex/RecordRetriever.getContactsReg';

export default class SqlIjectionTest extends LightningElement {

    @api
    searchKey = '';

    @api
    searchKeyReg = '';

    @api
    searchKeyTW = '';

    @api
    searchKeyLW = '';

    @api
    searchKeyB = '';

    @api
    contacts;

    @api
    contactsReg;

    @api
    contactsTW;

    @api
    contactsLW;

    @api
    usersB;

    @track
    error;

    @track
    errorReg;

    @track
    errorTW;

    @track
    errorLW;

    @track
    errorB;

    close(){
        this.error = '';
    }

    closeReg(){
        this.errorReg = '';
    }

    closeTW(){
        this.errorTW = '';
    }

    closeLW(){
        this.errorLW = '';
    }

    handleKeyChange(event) {
        console.log("key change", event.target.value);
        this.searchKey = event.target.value;
        console.log("key change", this.searchKey);
    }

    handleSearch(event) {
        console.log(event.target.value);
        this.searchKey = event.target.value;

        if (event.keyCode === 13) {
            getContact({ input: this.searchKey })
                .then((result) => {
                    this.contacts = result;
                    this.error = undefined;
                })
                .catch((error) => {
                    this.error = error.body.message.split('>');
                    this.contacts = undefined;
                });
        }
    }

    handleSearchReg(event) {

        this.searchKeyReg = event.target.value;

        if (event.keyCode === 13) {
            getContactReg({ input: this.searchKeyReg })
                .then((result) => {
                    this.contactsReg = result;
                    this.errorReg = undefined;
                })
                .catch((error) => {
                    this.errorReg = error.body.message.split('>');
                    this.contactsReg = undefined;
                });
        }
    }

    handleSearchTW(event) {
        this.searchKeyTW = event.target.value;

        if (event.keyCode === 13) {
            getContactTW({ input: this.searchKeyTW })
                .then((result) => {
                    this.contactsTW = result;
                    this.errorTW = undefined;
                })
                .catch((error) => {
                    this.errorTW = error.body.message.split('>');
                    this.contactsTW = undefined;
                });
        }
    }

    handleSearchLW(event) {
        this.searchKeyLW = event.target.value;

        if (event.keyCode === 13) {
            getContactLW({ input: this.searchKeyLW })
                .then((result) => {
                    this.contactsLW = result;
                    this.errorLW = undefined;
                })
                .catch((error) => {
                    this.errorLW = error.body.message.split('>');
                    this.contactsLW = undefined;
                });
        }
    }

    handleSearchB(event) {
        this.searchKeyB = event.target.value;
        console.log(this.searchKeyB);

        if (event.keyCode === 13) {
        getUserB({ bool: this.searchKeyB })
            .then((result) => {
                this.usersB = result;
                this.errorB = undefined;
            })
            .catch((error) => {
                this.errorB = error.body.message.split('>');
                this.usersB = undefined;
            });
        }
    }

}
