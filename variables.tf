# Copyright 2022 Nexient LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "database_name" {
  description = "Name of the MS SQL Database instance"
  type        = string
}

variable "sql_server_id" {
  description = "The ID of the MS SQL Server"
  type        = string
}

variable "license_type" {
  description = "License type of the database. Possible values are LicenceIncluded or BasePrice"
  type        = string
  default     = "BasePrice"

  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.license_type)
    error_message = "The license_type must be either 'LicenseIncluded' or 'BasePrice'."
  }
}

variable "auto_pause_delay_in_minutes" {
  description = "Time in minutes after which the database is automatically paused"
  type        = number
  default     = -1
}

variable "elastic_pool_id" {
  description = "Specifies the ID of the elastic pool containing the database"
  type        = string
  default     = null
}

variable "geo_backup_enabled" {
  description = "This setting is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs."
  default     = false
}

variable "ledger_enabled" {
  description = "Whether this is a ledger database"
  type        = bool
  default     = false
}

variable "sku_name" {
  description = "The SKU of the database. The possible values are GP_S_Gen5_2,HS_Gen4_1,BC_Gen5_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100"
  type        = string
  default     = "GP_Gen5_2"

  validation {
    condition     = contains(["GP_Gen5_2", "GP_S_Gen5_2", "HS_Gen4_1", "BC_Gen5_2", "ElasticPool", "Basic", "S0", "P2", "DW100c", "DS100"], var.sku_name)
    error_message = "The sku_name must be either 'GP_Gen5_2' or 'GP_S_Gen5_2' or 'HS_Gen4_1' or 'BC_Gen5_2' or 'ElasticPool' or 'Basic' or 'S0' or 'P2' or 'DW100c' or 'DS100'."
  }
}

variable "create_mode" {
  description = "The create_mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup or Secondary"
  type        = string
  default     = "Default"
  validation {
    condition     = contains(["Copy", "Default", "OnlineSecondary", "PointInTimeRestore", "Recovery", "Restore", "RestoreExternalBackup", "RestoreExternalBackupSecondary", "RestoreLongTermRetentionBackup", "Secondary"], var.create_mode)
    error_message = "The create_mode must be either 'Copy' or 'Default' or 'OnlineSecondary', 'PointInTimeRestore', 'Recovery', 'Restore', 'RestoreExternalBackup', 'RestoreExternalBackupSecondary', 'RestoreLongTermRetentionBackup' or 'Secondary'."
  }
}

variable "zone_redundant" {
  description = "Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases."
  type        = bool
  default     = false
}

variable "storage_account_type" {
  description = "The type of storage account. Possible values are Geo, GeoZone, Local or Zone"
  type        = string
  default     = "Geo"
  validation {
    condition     = contains(["Geo", "GeoZone", "Local", "Zone"], var.storage_account_type)
    error_message = "The storage_account_type must be either 'Geo', 'GeoZone', 'Local' or 'Zone'."
  }

}

variable "max_size_gb" {
  description = "Maximum size of the database in GBs."
  type        = number
  default     = 5
}

variable "extended_db_auditing_enabled" {
  description = "Whether the database auditing should be enabled?"
  type        = bool
  default     = false
}

variable "retention_in_days" {
  description = "Number of days to retain the logs in the storage account"
  type        = number
  default     = 30
}

variable "storage_endpoint" {
  description = "The blob storage endpoint that will hold the extended auditing logs. e.g. https://xxx.blob.core.windows.net"
  type        = string
  default     = ""
}

variable "storage_account_access_key" {
  description = "The access key of the storage account"
  type        = string
  default     = ""
}

variable "is_access_key_secondary" {
  description = "Is the storage account access key the secondary key?"
  type        = bool
  default     = false
}

variable "short_term_retention_policy" {
  description = "Configuration for short term retention of the database. This is enabled by default"
  type = object({
    retention_days           = number
    backup_interval_in_hours = number
  })
  default = {
    backup_interval_in_hours = 12 # Value is either 12 or 24
    retention_days           = 7  # Can take up values between 7 and 35
  }
}

variable "long_term_retention_enabled" {
  description = "Whether long term retention for database backup be enabled?"
  type        = bool
  default     = false
}

variable "long_term_retention_policy" {
  description = "Attributes for long term retention policy. Required only when long_term_retention_enabled = true"
  type = object({
    weekly_retention  = string #ISO 8601 format - P1Y, P1M, P1W or P7D
    monthly_retention = string #ISO 8601 format - P1Y, P1M, P1W or P7D
    yearly_retention  = string #ISO 8601 format - P1Y, P1M, P1W or P7D
    week_of_year      = number
  })
  default = {
    monthly_retention = "PT0S"
    week_of_year      = 0
    weekly_retention  = "PT0S"
    yearly_retention  = "PT0S"
  }
}

variable "custom_tags" {
  description = "Custom tags to be attached to this database instance"
  type        = map(string)
  default     = {}
}
