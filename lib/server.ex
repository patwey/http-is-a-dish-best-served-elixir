defmodule Server do
  def accept(port) do
    {:ok, socket} = :gen_tcp.listen(port,
                                    [:binary,
                                     packet: :line,
                                     active: false,
                                     reuseaddr: true])
    if {:ok, client} = :gen_tcp.accept(socket) do
      IO.puts "Got your request!"
      :gen_tcp.close(socket)
    else
      IO.puts "Listening on port: #{port}"
      accept(port)
    end
  end
end
