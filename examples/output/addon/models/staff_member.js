import DS from 'ember-data';

export default Staff_member = DS.Model.extend({
  default_location: DS.attr(),
  degree: DS.attr(),
  first_name: DS.attr("string"),
  last_name: DS.attr("string"),
  photos: DS.attr(),
  role: DS.attr("string"),
  speciality: DS.attr(),
  suffix: DS.attr(),
  uid: DS.attr("string")
});
