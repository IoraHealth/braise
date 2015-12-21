import DS from 'ember-data';
import Ember from 'ember';

export default DS.RESTAdapter.extend({
  host: "https://api.icisapp.com",
  namespace: "v20150918",
  token: Ember.computed.alias('accessTokenWrapper.token'),
  
  pathForType: function(type) {
    var decamelized = Ember.String.decamelize(type);
    return Ember.String.pluralize(decamelized);
  },

  headers: function() {
    return {
      'AUTHORIZATION': 'Bearer ' + this.get('token')
    };
  }.property('token')
});
