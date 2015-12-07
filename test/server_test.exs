defmodule ServerTest do
  use ExUnit.Case
  test "parse_request interprets and stores request" do
    request = "GET / HTTP/1.1\r\nUser-Agent: curl/7.37.1\r\nHost: example.com\r\nAccept: /\r\n\r\n"
    [ verb: "GET", path: "/", protocol_version: "HTTP/1.1" ] = Server.parse_request(request)
  end
end
