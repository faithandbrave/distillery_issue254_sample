defmodule AdminSite.PageController do
  use AdminSite.Web, :controller

  defp remove_return_code(s) do
    String.replace_suffix(s, "\n", "")
  end

  @spec git_root_dir :: String.t
  defp git_root_dir do
    {git_root_dir_result, 0} = System.cmd("git", ["rev-parse", "--show-toplevel"])
    remove_return_code(git_root_dir_result)
  end

  def index(conn, _params) do
    render conn, "index.html"
  end

  def start_deploy(conn, _params) do
    cmd = "cd #{git_root_dir} && sh deploy.sh"
    opts = [out: {:send, self()}]

    %Porcelain.Process{pid: pid} = Porcelain.spawn_shell(cmd, opts)

    conn = conn
           |> put_resp_content_type("text/event-stream")
           |> send_chunked(200)

    {:ok, conn} = chunk(conn, "start deploy\n")
    conn = wait_complete_deploy(conn, pid)
    IO.puts "complete"
    conn
  end

  @spec wait_complete_deploy(Plug.Conn, pid) :: Plug.Conn
  def wait_complete_deploy(conn, pid) do
    receive do
      {^pid, :data, :out, data} ->
        {:ok, conn} = chunk(conn, data)
        IO.puts "continue"
        wait_complete_deploy(conn, pid)
      {^pid, :result, %Porcelain.Result{status: _status}} ->
        {:ok, conn} = chunk(conn, "complete deploy\n")
        IO.puts "end"
        conn
      after 3000 -> chunk(conn, ".")
        # avoid connection close
        IO.puts "wait"
        wait_complete_deploy(conn, pid)
    end
  end
end
