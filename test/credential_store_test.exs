defmodule CredentialStoreTest do
  use ExUnit.Case
  import Mock

  alias InvokeLambda.CredentialStore

  @instance_role TestHelper.example_instance_role_name()
  @meta_data_host TestHelper.default_meta_data_host()

  test "makes a request for the credentials when given a instance_role" do
    with_mocks([
      {HTTPoison, [], [get!: fn _ -> TestHelper.expected_meta_data_response() end]}
    ]) do
      result =
        CredentialStore.retrieve_using_instance_role(%{instance_role_name: @instance_role, meta_data_host: @meta_data_host})

      expected_result = %{
        aws_access_key: "aws-access-key",
        aws_secret_key: "aws-secret-key",
        aws_token: "aws-token"
      }

      assert_called(HTTPoison.get!(TestHelper.expected_meta_data_url(@instance_role)))
      assert result == expected_result
    end
  end
end
