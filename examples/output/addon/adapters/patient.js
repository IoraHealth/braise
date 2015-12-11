import DS from 'ember-data';
import Ember from 'ember';

export default DS.RESTAdapter.extend({
  host: "https://api.icisapp.com",
  namespace: "v20150918",
  token: Ember.computed.alias('accessTokenWrapper.token'),
  
  headers: function() {
    return {
      'AUTHORIZATION': 'Bearer ' + this.get('token')
    };
  }.property('token')
});
