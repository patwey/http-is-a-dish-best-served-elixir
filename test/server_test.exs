defmodule ServerTest do
  use ExUnit.Case
  test "parse_first_line interprets and stores first line" do
    first_line = "GET / HTTP/1.1"
    [ verb: "GET", path: "/", protocol_version: "HTTP/1.1" ] = Server.parse_first_line(first_line)
  end

  test "parse_headers interprets and stores headers" do
    headers = "User-Agent: curl/7.37.1\r\nHost: example.com\r\nAccept: /"
    [] = Server.parse_headers(headers)
  end
end
