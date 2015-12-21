import DS from 'ember-data';

export default Patient = DS.Model.extend({
  care_team: DS.attr(),
  dob: DS.attr("string"),
  first_name: DS.attr("string"),
  guid: DS.attr("string"),
  last_name: DS.attr("string"),
  patient_app_shared: DS.attr("boolean"),
  practice: DS.attr(),
  preferred_location: DS.attr()
});
