defmodule RssSubscriptionBot.SchemaCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case
      alias Ecto.Changeset

      defp assert_has_fields(schema, expected_fields_and_types) do
        assert schema
               |> get_fields_and_types()
               |> MapSet.new() == MapSet.new(expected_fields_and_types)
      end

      defp get_fields_and_types(schema) do
        for field <- schema.__schema__(:fields),
            do: {field, schema.__schema__(:type, field)}
      end

      defp assert_invalid(%Changeset{} = changeset) do
        assert !changeset.valid?
        changeset
      end
    end
  end
end
