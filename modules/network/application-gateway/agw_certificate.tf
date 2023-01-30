# retrieve the application gateway certificate for internet traffic from the given key vault, if a certificate name has been specified
data azurerm_key_vault_certificate given {
  count = length(var.agw_key_vault_certificate_name) != 0 ? 1 : 0
  key_vault_id = var.key_vault_id
  name = var.agw_key_vault_certificate_name
}

# generate a new application gateway certificate for internet traffic if no certificate was specified
resource "azurerm_key_vault_certificate" "generated" {
  count = length(var.agw_key_vault_certificate_name) == 0 ? 1 : 0
  name = "kvc-${local.agw_name}-${random_uuid.suffix.result}"
  key_vault_id = var.key_vault_id
  tags = merge({ Name = "kvc-${local.agw_name}-${random_uuid.suffix.id}" }, local.module_common_tags)

  certificate_policy {
    issuer_parameters {
      name = "Self"
    }

    key_properties {
      exportable = true
      key_size   = 2048
      key_type   = "RSA"
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "AutoRenew"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pkcs12"
    }

    x509_certificate_properties {
      # Server Authentication = 1.3.6.1.5.5.7.3.1
      # Client Authentication = 1.3.6.1.5.5.7.3.2
      extended_key_usage = ["1.3.6.1.5.5.7.3.1"]

      key_usage = [
        "cRLSign",
        "dataEncipherment",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "keyEncipherment",
      ]

      subject_alternative_names {
        dns_names = var.agw_host_names
      }

      subject            = "CN=${var.agw_host_names[0]}"
      validity_in_months = 12
    }
  }
}

resource random_uuid suffix {

}