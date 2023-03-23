package main

import (
	"bufio"
	"flag"
	"fmt"
	"log"
	"os"

	corev1 "k8s.io/api/core/v1"
	"k8s.io/client-go/kubernetes/scheme"
)

func getInput(filename string) []byte {
	if filename != "" {
		f, err := os.ReadFile(filename)
		if err != nil {
			log.Fatal(err)
		}
		return f
	} else {
		reader := bufio.NewReader(os.Stdin)
		data := make([]byte, 10000)
		n, err := reader.Read(data)
		if err != nil {
			log.Fatal(err)
		}
		return data[:n]
	}

}

func transform(filename string) {
	f := getInput(filename)
	decode := scheme.Codecs.UniversalDeserializer().Decode
	obj, gKV, _ := decode(f, nil, nil)
	if gKV.Kind != "Secret" {
		log.Fatal("Not a secret, got ", gKV.Kind)
	}
	secret := obj.(*corev1.Secret)
	for k, v := range secret.Data {
		fmt.Printf("%s: %s\n", k, string(v))
	}
}

func main() {
	flag.Parse()
	var args = flag.Args()
	var filename = ""
	if len(args) > 0 {
		filename = args[0]
	}

	transform(filename)

}