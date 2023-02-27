package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
	"strconv"
	"strings"
	"time"
)

func main() {
	flag.Parse()
	var args = flag.Args()
	max_tries, err := strconv.Atoi(args[0])
	if err != nil {
		fmt.Println("Wrong first arg:", args[0])
		os.Exit(1)
	}
	for i := 0; i < max_tries; i++ {
		raw_cmd := strings.Join(args[1:], " ")
		cmd := exec.Command("bash", "-c", raw_cmd)
		cmd.Stdout = os.Stdout
		cmd.Stderr = os.Stderr
		err = cmd.Run()
		if err != nil {
			exiterr := err.(*exec.ExitError)
			if i == max_tries-1 {
				fmt.Fprintf(os.Stderr, "Command '%s' failed after %d tries, aborting\n", raw_cmd, max_tries)
				os.Exit(exiterr.ExitCode())
			}
			time.Sleep(time.Duration(i+1) * time.Second)
		} else {
			os.Exit(0)
		}
	}
}