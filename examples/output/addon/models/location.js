import DS from 'ember-data';

export default Location = DS.Model.extend({
  address: DS.attr(),
  name: DS.attr("string"),
  phone: DS.attr("string"),
  uid: DS.attr("string")
});
