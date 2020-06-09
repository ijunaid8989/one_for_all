defmodule Github do
  @github "https://api.github.com"
  @headers ["Authorization": "token #{System.get_env["GITHUB_TOKEN"]}", "Accept": "application/vnd.github.v3+json"]

  def branches(repo) do
    get("/repos/evercam/#{repo}/branches") |> response() |> Enum.map(&parse_branch_info(&1))
  end

  def branch(repo, branch) do
    get("/repos/evercam/#{repo}/branches/#{branch}") |> response()
  end

  def commits_in_branch(repo, branch, since \\ DateTime.utc_now |> DateTime.add(-259200, :second) |> DateTime.to_iso8601) do
    get("/repos/evercam/#{repo}/commits?sha=#{branch}&since=#{since}") |> response() |> Enum.map(&parse_commit_info(&1))
  end

  defp get(url) do
    HTTPoison.get(@github <> url, @headers, hackney: [])
  end

  defp response({:ok, %HTTPoison.Response{body: body, status_code: 200}}), do: body |> Jason.decode!
  defp response(_), do: []

  defp parse_branch_info(%{
    "commit" => %{
      "sha" => sha
    },
    "name" => branch_name
  }) do
    %{
      sha: sha,
      branch_name: branch_name
    }
  end

  defp parse_commit_info(%{
    "author" => %{
      "avatar_url" => avatar_url,
      "login" => login,
      "type" => type
    },
    "commit" => %{
      "author" => %{
        "date" => author_date,
        "email" => author_email,
        "name" => author_name
      },
      "committer" => %{
        "date" => committer_date,
        "email" => committer_email,
        "name" => committer_name
      },
      "message" => commit_message
    }
  }) do
    %{
      avatar_url: avatar_url,
      login: login,
      type: type,
      author_date: author_date,
      author_email: author_email,
      author_name: author_name,
      committer_date: committer_date,
      committer_email: committer_email,
      committer_name: committer_name,
      commit_message: commit_message
    }
  end
end