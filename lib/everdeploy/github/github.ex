defmodule Github do
  @github "https://api.github.com"
  @headers ["Authorization": "token #{System.get_env["GITHUB_TOKEN"]}", "Accept": "application/vnd.github.v3+json"]

  def branches(repo) do
    get("/repos/evercam/#{repo}/branches") |> response()
  end

  def branch(repo, branch) do
    get("/repos/evercam/#{repo}/branches/#{branch}") |> response()
  end

  def commits_in_branch(repo, branch) do
    get("/repos/evercam/#{repo}/commits?sha=#{branch}") |> response()
  end

  defp get(url) do
    HTTPoison.get(@github <> url, @headers, hackney: [])
  end

  defp response({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: body |> Jason.decode!
  defp response(_), do: []

  
end