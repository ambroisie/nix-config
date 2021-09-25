# Secrets configuration
{ ... }:
{
  config.age.secrets = {
    # Must be readable by the service
    "nextcloud/password".owner = "nextcloud";
  };
}
