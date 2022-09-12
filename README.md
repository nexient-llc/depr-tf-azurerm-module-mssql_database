# tf-azurerm-module-mssql_database

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This terraform module creates a Microsoft SQL Database instance in the Azure Portal. This module depends on the below mentioned resources which must be existing at the time of the creation of this module
- Resource group
- MS SQL Server
- Storage Account (for extended audit policy)

## Pre-Commit hooks

[.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to terraform, golang and common linting tasks. There are no custom hooks added.

`commitlint` hook enforces commit message in certain format. The commit contains the following structural elements, to communicate intent to the consumers of your commit messages:

- **fix**: a commit of the type `fix` patches a bug in your codebase (this correlates with PATCH in Semantic Versioning).
- **feat**: a commit of the type `feat` introduces a new feature to the codebase (this correlates with MINOR in Semantic Versioning).
- **BREAKING CHANGE**: a commit that has a footer `BREAKING CHANGE:`, or appends a `!` after the type/scope, introduces a breaking API change (correlating with MAJOR in Semantic Versioning). A BREAKING CHANGE can be part of commits of any type.
footers other than BREAKING CHANGE: <description> may be provided and follow a convention similar to git trailer format.
- **build**: a commit of the type `build` adds changes that affect the build system or external dependencies (example scopes: gulp, broccoli, npm)
- **chore**: a commit of the type `chore` adds changes that don't modify src or test files
- **ci**: a commit of the type `ci` adds changes to our CI configuration files and scripts (example scopes: Travis, Circle, BrowserStack, SauceLabs)
- **docs**: a commit of the type `docs` adds documentation only changes
- **perf**: a commit of the type `perf` adds code change that improves performance
- **refactor**: a commit of the type `refactor` adds code change that neither fixes a bug nor adds a feature
- **revert**: a commit of the type `revert` reverts a previous commit
- **style**: a commit of the type `style` adds code changes that do not affect the meaning of the code (white-space, formatting, missing semi-colons, etc)
- **test**: a commit of the type `test` adds missing tests or correcting existing tests

Base configuration used for this project is [commitlint-config-conventional (based on the Angular convention)](https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional#type-enum)

If you are a developer using vscode, [this](https://marketplace.visualstudio.com/items?itemName=joshbolduc.commitlint) plugin may be helpful.

`detect-secrets-hook` prevents new secrets from being introduced into the baseline. TODO: INSERT DOC LINK ABOUT HOOKS

In order for `pre-commit` hooks to work properly

- You need to have the pre-commit package manager installed. [Here](https://pre-commit.com/#install) are the installation instructions.
- `pre-commit` would install all the hooks when commit message is added by default except for `commitlint` hook. `commitlint` hook would need to be installed manually using the command below

```
pre-commit install --hook-type commit-msg
```

## To test the resource group module locally

1. For development/enhancements to this module locally, you'll need to install all of its components. This is controlled by the `configure` target in the project's [`Makefile`](./Makefile). Before you can run `configure`, familiarize yourself with the variables in the `Makefile` and ensure they're pointing to the right places.

```
make configure
```

This adds in several files and directories that are ignored by `git`. They expose many new Make targets.

2. The first target you care about is `env`. This is the common interface for setting up environment variables. The values of the environment variables will be used to authenticate with cloud provider from local development workstation.

`make configure` command will bring down `azure_env.sh` file on local workstation. Devloper would need to modify this file, replace the environment variable values with relevant values.

These environment variables are used by `terratest` integration suit.

Service principle used for authentication(value of ARM_CLIENT_ID) should have below privileges on resource group within the subscription.

```
"Microsoft.Resources/subscriptions/resourceGroups/write"
"Microsoft.Resources/subscriptions/resourceGroups/read"
"Microsoft.Resources/subscriptions/resourceGroups/delete"
```

Then run this make target to set the environment variables on developer workstation.

```
make env
```

3. The first target you care about is `check`.

**Pre-requisites**
Before running this target it is important to ensure that, developer has created files mentioned below on local workstation under root directory of git repository that contains code for primitives/segments. Note that these files are `azure` specific. If primitive/segment under development uses any other cloud provider than azure, this section may not be relevant.

- A file named `provider.tf` with contents below

```
provider "azurerm" {
  features {}
}
```

- A file named `terraform.tfvars` which contains key value pair of variables used.

Note that since these files are added in `gitignore` they would not be checked in into primitive/segment's git repo.

After creating these files, for running tests associated with the primitive/segment, run

```
make check
```

If `make check` target is successful, developer is good to commit the code to primitive/segment's git repo.

`make check` target

- runs `terraform commands` to `lint`,`validate` and `plan` terraform code.
- runs `conftests`. `conftests` make sure `policy` checks are successful.
- runs `terratest`. This is integration test suit.
- runs `opa` tests

# Creation Mode
The database module supports multiple creation modes
- *Default*: This is the default mode when user wants to create a new database
- *Restore*: When user wants to restore a deleted database. The variable `restore_dropped_database_id` is required.
- *PointInTimeRestore*: When user wants to perform a point in time restore from an existing database in the same server. The variables `creation_source_database_id` and `restore_point_in_time` are required
- *Recovery*: Creates a database by restoring a geo-replicated backup. The variable `creation_source_database_id` is required. This mode is not yet tested locally


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# Terradocs
Below are the details that are generated by Terradocs plugin. It contains information about the module, inputs, outputs etc.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.7 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.21.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [azurerm_mssql_database_extended_auditing_policy.db_auditing_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database_extended_auditing_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_database_name"></a> [database\_name](#input\_database\_name) | Name of the MS SQL Database instance | `string` | n/a | yes |
| <a name="input_sql_server_id"></a> [sql\_server\_id](#input\_sql\_server\_id) | The ID of the MS SQL Server | `string` | n/a | yes |
| <a name="input_license_type"></a> [license\_type](#input\_license\_type) | License type of the database. Possible values are LicenceIncluded or BasePrice | `string` | `"BasePrice"` | no |
| <a name="input_auto_pause_delay_in_minutes"></a> [auto\_pause\_delay\_in\_minutes](#input\_auto\_pause\_delay\_in\_minutes) | Time in minutes after which the database is automatically paused | `number` | `-1` | no |
| <a name="input_elastic_pool_id"></a> [elastic\_pool\_id](#input\_elastic\_pool\_id) | Specifies the ID of the elastic pool containing the database | `string` | `null` | no |
| <a name="input_geo_backup_enabled"></a> [geo\_backup\_enabled](#input\_geo\_backup\_enabled) | This setting is only applicable for DataWarehouse SKUs (DW*). This setting is ignored for all other SKUs. | `bool` | `false` | no |
| <a name="input_ledger_enabled"></a> [ledger\_enabled](#input\_ledger\_enabled) | Whether this is a ledger database | `bool` | `false` | no |
| <a name="input_sku_name"></a> [sku\_name](#input\_sku\_name) | The SKU of the database. The possible values are GP\_S\_Gen5\_2,HS\_Gen4\_1,BC\_Gen5\_2, ElasticPool, Basic,S0, P2 ,DW100c, DS100 | `string` | `"GP_Gen5_2"` | no |
| <a name="input_create_mode"></a> [create\_mode](#input\_create\_mode) | The create\_mode of the database. Possible values are Copy, Default, OnlineSecondary, PointInTimeRestore, Recovery, Restore, RestoreExternalBackup, RestoreExternalBackupSecondary, RestoreLongTermRetentionBackup or Secondary. More details at https://docs.microsoft.com/en-us/rest/api/sql/2021-02-01-preview/databases/create-or-update | `string` | `"Default"` | no |
| <a name="input_creation_source_database_id"></a> [creation\_source\_database\_id](#input\_creation\_source\_database\_id) | Id of the source database from which the copy/restore needs to be performed | `any` | `null` | no |
| <a name="input_restore_point_in_time"></a> [restore\_point\_in\_time](#input\_restore\_point\_in\_time) | The ISO 8601 format point in time for restore. Example: 2022-09-07T15:17:00.00Z | `any` | `null` | no |
| <a name="input_restore_dropped_database_id"></a> [restore\_dropped\_database\_id](#input\_restore\_dropped\_database\_id) | The ID of the database to be restored. This property is only applicable when create\_mode='Restore'. Copy the id from the output 'restorable\_dropped\_database\_ids' from the server | `string` | `null` | no |
| <a name="input_recover_database_id"></a> [recover\_database\_id](#input\_recover\_database\_id) | The ID of the database to be recovered. This property is only applicable when the create\_mode='Recovery' | `string` | `null` | no |
| <a name="input_zone_redundant"></a> [zone\_redundant](#input\_zone\_redundant) | Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones. This property is only settable for Premium and Business Critical databases. | `bool` | `false` | no |
| <a name="input_storage_account_type"></a> [storage\_account\_type](#input\_storage\_account\_type) | The type of storage account. Possible values are Geo, GeoZone, Local or Zone | `string` | `"Geo"` | no |
| <a name="input_max_size_gb"></a> [max\_size\_gb](#input\_max\_size\_gb) | Maximum size of the database in GBs. | `number` | `5` | no |
| <a name="input_extended_db_auditing_enabled"></a> [extended\_db\_auditing\_enabled](#input\_extended\_db\_auditing\_enabled) | Whether the database auditing should be enabled? | `bool` | `false` | no |
| <a name="input_retention_in_days"></a> [retention\_in\_days](#input\_retention\_in\_days) | Number of days to retain the logs in the storage account | `number` | `30` | no |
| <a name="input_storage_endpoint"></a> [storage\_endpoint](#input\_storage\_endpoint) | The blob storage endpoint that will hold the extended auditing logs. e.g. https://xxx.blob.core.windows.net | `string` | `""` | no |
| <a name="input_storage_account_access_key"></a> [storage\_account\_access\_key](#input\_storage\_account\_access\_key) | The access key of the storage account | `string` | `""` | no |
| <a name="input_is_access_key_secondary"></a> [is\_access\_key\_secondary](#input\_is\_access\_key\_secondary) | Is the storage account access key the secondary key? | `bool` | `false` | no |
| <a name="input_short_term_retention_policy"></a> [short\_term\_retention\_policy](#input\_short\_term\_retention\_policy) | Configuration for short term retention of the database. This is enabled by default | <pre>object({<br>    retention_days           = number<br>    backup_interval_in_hours = number<br>  })</pre> | <pre>{<br>  "backup_interval_in_hours": 12,<br>  "retention_days": 7<br>}</pre> | no |
| <a name="input_long_term_retention_enabled"></a> [long\_term\_retention\_enabled](#input\_long\_term\_retention\_enabled) | Whether long term retention for database backup be enabled? | `bool` | `false` | no |
| <a name="input_long_term_retention_policy"></a> [long\_term\_retention\_policy](#input\_long\_term\_retention\_policy) | Attributes for long term retention policy. Required only when long\_term\_retention\_enabled = true | <pre>object({<br>    weekly_retention  = string #How long to retain the monthly backup. Example P10W = for 10 weeks<br>    monthly_retention = string # How long to retain the monthly backup. Example P3M = for 3 months<br>    yearly_retention  = string #How long to retain the monthly backup. Example P5Y = for 5 years<br>    week_of_year      = number # Which weekly backup of the year would you like to keep?<br>  })</pre> | <pre>{<br>  "monthly_retention": "P1Y",<br>  "week_of_year": 2,<br>  "weekly_retention": "P1M",<br>  "yearly_retention": "P5Y"<br>}</pre> | no |
| <a name="input_maintenance_configuration_name"></a> [maintenance\_configuration\_name](#input\_maintenance\_configuration\_name) | The name of the public maintenance configuration window to apply to the database | `string` | `"SQL_Default"` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Custom tags to be attached to this database instance | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_id"></a> [database\_id](#output\_database\_id) | Id of the database |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name) | Name of the database |
| <a name="output_database_auditing_policy_id"></a> [database\_auditing\_policy\_id](#output\_database\_auditing\_policy\_id) | Id of the MS SQL Database Extended Auditing Policy |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
