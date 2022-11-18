package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesComplete(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-east-2.tfvars"},
	}

	terraform.Init(t, terraformOptions)
	// Run tests in parallel
	t.Run("Disabled", testExamplesCompleteDisabled)
	t.Run("Enabled", testExamplesComplete)
	t.Run("PrivateZone", testExamplesCompletePrivateZone)
}

func testExamplesCompleteDisabled(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-disabled-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
		Vars: map[string]interface{}{
			"enabled": false,
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	allOutputs := terraform.OutputAll(t, terraformOptions)
	for _, v := range allOutputs {
		assert.Empty(t, v)
	}
}

func testExamplesComplete(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-enabled.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	zoneName := terraform.Output(t, terraformOptions, "zone_name")
	zoneType := terraform.Output(t, terraformOptions, "type")

	expectedZoneName := "test-domain.testing.cloudposse.co"
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedZoneName, zoneName)
	assert.Equal(t, "public", zoneType)
}



func testExamplesCompletePrivateZone(t *testing.T) {
	t.Parallel()

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-private-zone.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"private-zone.us-west-1.tfvars"},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	zoneName := terraform.Output(t, terraformOptions, "zone_name")
	zoneType := terraform.Output(t, terraformOptions, "type")

	expectedZoneName := "private-zone.testing.cloudposse.co"
	// Verify we're getting back the outputs we expect
	assert.Equal(t, expectedZoneName, zoneName)
	assert.Equal(t, "private", zoneType)
}