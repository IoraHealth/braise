import DS from 'ember-data';

export default Emergency_contact = DS.Model.extend({
  email: DS.attr(),
  first_name: DS.attr(),
  last_name: DS.attr(),
  phone: DS.attr(),
  relationship: DS.attr()
});
