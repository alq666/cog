defmodule Cog.Commands.RelayGroup do
  use Cog.Command.GenCommand.Base, bundle: Cog.embedded_bundle, name: "relay-group"
  alias Cog.Commands.RelayGroup
  alias Cog.Commands.Helpers

  @moduledoc """
  Manages relay groups
  Usage relay-group <subcommand> [flags]

  Subcommands
  * list -- Lists relay groups
  * create -- Creates a relay group
  * rename -- Renames a relay group
  * delete -- Deletes a relay group
  * add -- Adds relays to relay groups
  * remove -- Remove relays from relay groups
  * assign -- Assigns bundles to relay groups
  * unassign -- Un-assigns bundles from relay groups
  """

  permission "manage_relays"

  rule "when command is #{Cog.embedded_bundle}:relay-group must have #{Cog.embedded_bundle}:manage_relays"

  # general options
  option "help", type: "bool", short: "h"

  # list options
  option "verbose", type: "bool", short: "v"

  def handle_message(req, state) do
    {subcommand, args} = Helpers.get_subcommand(req.args)

    result = case subcommand do
      "list" ->
        RelayGroup.List.list_relay_groups(req)
      "create" ->
        RelayGroup.Create.create_relay_group(req, args)
      "rename" ->
        RelayGroup.Rename.rename_relay_group(req, args)
      "delete" ->
        RelayGroup.Delete.delete_relay_group(req, args)
      "add" ->
        RelayGroup.Add.add_relays(req, args)
      "remove" ->
        RelayGroup.Remove.remove_relays(req, args)
      "assign" ->
        RelayGroup.Assign.assign_bundles(req, args)
      "unassign" ->
        RelayGroup.Unassign.unassign_bundles(req, args)
      nil ->
        show_usage
      invalid ->
        {:error, {:unknown_subcommand, invalid}}
    end

    case result do
      {:ok, template, data} ->
        {:reply, req.reply_to, template, data, state}
      {:ok, message} ->
        {:reply, req.reply_to, message, state}
      {:error, err} ->
        {:error, req.reply_to, Helpers.error(err), state}
    end
  end

  defp show_usage do
    {:ok, "usage", %{usage: @moduledoc}}
  end
end

