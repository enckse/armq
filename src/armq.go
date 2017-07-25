package main

import "net"
import "fmt"
import "C"

//export armaSend
func armaSend(output string, outputSize int, fxn string) string {
  conn, _ := net.Dial("tcp", "127.0.0.1:8081")
  for {
    fmt.Fprintf(conn, "test\n")
  }
  return "";
}

func main() {
}
