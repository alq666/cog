defmodule Cog.Chat.Slack.Templates.Embedded.BundleEnableTest do
  use Cog.TemplateCase

  test "bundle-enable template" do
    data = %{"results" => [%{"name" => "foo",
                             "version" => "1.0.0"}]}
    expected = ~s(Bundle "foo" version "1.0.0" has been enabled.)
    assert_rendered_template(:slack, :embedded, "bundle-enable", data, expected)
  end

  test "bundle-enable template with multiple inputs" do
    data = %{"results" => [%{"name" => "foo", "version" => "1.0.0"},
                           %{"name" => "bar", "version" => "2.0.0"},
                           %{"name" => "baz", "version" => "3.0.0"}]}
    expected = """
    Bundle "foo" version "1.0.0" has been enabled.
    Bundle "bar" version "2.0.0" has been enabled.
    Bundle "baz" version "3.0.0" has been enabled.
    """ |> String.strip
    assert_rendered_template(:slack, :embedded, "bundle-enable", data, expected)
  end

end
