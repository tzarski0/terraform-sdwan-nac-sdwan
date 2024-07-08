resource "sdwan_configuration_group" "configuration_group" {
  for_each    = { for g in local.configuration_groups : g.name => g }
  name        = each.value.name
  description = each.value.description
  solution    = lookup(each.value, "solution", "sdwan")

  feature_profiles = [
    for profile_type in sort(["cli_profile", "service_profile", "system_profile", "transport_profile"]) :
    lookup(each.value, profile_type, null) != null ? {
      id = lookup({
        cli_profile       = sdwan_cli_feature_profile.cli_feature_profile,
        service_profile   = sdwan_service_feature_profile.service_feature_profile,
        system_profile    = sdwan_system_feature_profile.system_feature_profile,
        transport_profile = sdwan_transport_feature_profile.transport_feature_profile,
      }, profile_type)[lookup(each.value, profile_type)].id
    } : null
    if lookup(each.value, profile_type, null) != null
  ]
}
