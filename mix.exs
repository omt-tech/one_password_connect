defmodule OnePasswordConnect.MixProject do
  use Mix.Project

  def project do
    [
      app: :one_password_connect,
      version: "0.0.1",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description:
        "Client library that reads secrets and other configuration from 1Password Connect Servers",
      source_url: "https://github.com/omt-tech/one_password_connect",
      package: [
        name: "one_password_connect",
        licenses: ["MIT"],
        links: %{
          Github: "https://github.com/omt-tech/one_password_connect"
        }
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :inets]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:jason, "~> 1.4"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end
end
