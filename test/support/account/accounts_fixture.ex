defmodule RssSubscriptionBot.Core.AccountFixture do
  def pass_valid, do: "passpasspass"
  def pass_invalid, do: "passpass123"
  def username_valid, do: "username"
  def username_invalid, do: "12345"
  def attrs_username_absent, do: %{pwd_string: pass_valid()}
  def attrs_pwd_string_absent, do: %{username: username_valid()}
  def attrs_pass_invalid, do: %{username: username_valid(), pwd_string: pass_invalid()}
  def attrs_username_invalid, do: %{username: username_invalid(), pwd_string: pass_valid()}
  def attrs_valid, do: %{username: username_valid(), pwd_string: pass_valid()}
end
