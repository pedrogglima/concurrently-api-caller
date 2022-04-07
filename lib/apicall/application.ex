defmodule Apicall.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Apicall.Results,
      {Apicall.ApicallQueue, Application.get_env(:apicall, :initial_calls)},
      Apicall.WorkerSupervisor,
      {Apicall.Gatherer, Application.get_env(:apicall, :number_of_workers)}
    ]

    opts = [strategy: :one_for_all, name: Apicall.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
