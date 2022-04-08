defmodule Apicall.MixProject do
  use Mix.Project

  def project do
    [
      app: :apicall,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Apicall.Application, []},
      env: [initial_calls: [["url-a1", "url-a2", "url-a3"], ["url-b1", "url-b2"], ["url-c1"]], number_of_workers: 1],
      register: [
        Apicall.Results,
        Apicall.ApicallQueue,
        Apicall.Ghetherer,
        Apicall.WorkerSupervisor
      ]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
