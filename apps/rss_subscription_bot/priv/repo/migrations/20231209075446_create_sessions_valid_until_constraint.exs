defmodule RssSubscriptionBot.Repo.Migrations.CreateSessionsValidUntilConstraint do
  use Ecto.Migration

  def change do
    create(
      constraint("sessions", :sessions_valid_until_constraint,
        check: "valid_until > CURRENT_DATE"
      )
    )
  end
end
