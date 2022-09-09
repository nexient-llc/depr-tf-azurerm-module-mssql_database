// Copyright 2022 Nexient LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package test

// Basic imports
import (
	"fmt"
	"os"
	"path"
	"strconv"
	"testing"

	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/files"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/suite"
)

// Define the suite, and absorb the built-in basic suite
// functionality from testify - including a T() method which
// returns the current testing context
type TerraTestSuite struct {
	suite.Suite
	TerraformOptions *terraform.Options
}

// setup to do before any test runs
func (suite *TerraTestSuite) SetupSuite() {
	tempTestFolder := test_structure.CopyTerraformFolderToTemp(suite.T(), "../..", ".")
	_ = files.CopyFile(path.Join("..", "..", ".tool-versions"), path.Join(tempTestFolder, ".tool-versions"))
	pwd, _ := os.Getwd()
	suite.TerraformOptions = terraform.WithDefaultRetryableErrors(suite.T(), &terraform.Options{
		TerraformDir: tempTestFolder,
		VarFiles:     [](string){path.Join(pwd, "..", "demo.tfvars")},
	})

	terraform.InitAndApplyAndIdempotent(suite.T(), suite.TerraformOptions)
}

// TearDownAllSuite has a TearDownSuite method, which will run after all the tests in the suite have been run.
func (suite *TerraTestSuite) TearDownSuite() {
	terraform.Destroy(suite.T(), suite.TerraformOptions)
}

// In order for 'go test' to run this suite, we need to create
// a normal test function and pass our suite to suite.Run
func TestRunSuite(t *testing.T) {
	suite.Run(t, new(TerraTestSuite))
}

// All methods that begin with "Test" are run as tests within a suite.
func (suite *TerraTestSuite) TestOutputsWithAzureAPI() {

	actualDatabaseId := terraform.Output(suite.T(), suite.TerraformOptions, "database_id")
	actualDatabaseName := terraform.Output(suite.T(), suite.TerraformOptions, "database_name")
	expectedSqlServerName := "demo-eus-dev-000-dbs-001"
	expectedSqlDbName := "demo-eus-dev-000-db-002"
	expectedRgName := "deb-test-devops"
	// NOTE: "subscriptionID" is overridden by the environment variable "ARM_SUBSCRIPTION_ID". <>
	subscriptionID := ""
	database := azure.GetSQLDatabase(suite.T(), expectedRgName, expectedSqlServerName, expectedSqlDbName, subscriptionID)
	suite.Equal(*database.ID, actualDatabaseId, "The database IDs should match")
	suite.Equal(*database.Name, actualDatabaseName, "The Database Names should match")
	fmt.Println("Database Type: " + *database.Type)
	fmt.Println("Database Zone Redundant: " + strconv.FormatBool(*database.ZoneRedundant))
	suite.Equal(actualDatabaseName, expectedSqlDbName, "The database Name tf output should match with input database name")
}
