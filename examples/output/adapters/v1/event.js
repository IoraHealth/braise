// DO NOT EDIT - this file was autogenerated by Braise
import DS from 'ember-data';
import Ember from 'ember';

export default DS.RESTAdapter.extend({
  host: "https://production.icisapp.com",
  namespace: "api/v1",
  token: Ember.computed.alias('accessTokenWrapper.token'),
  
  headers: function() {
    return {
      'AUTHORIZATION': 'Bearer ' + this.get('token')
    };
  }.property('token')
});
