package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	appContent, err := ioutil.ReadFile("/data/app.html")
	if err != nil {
		appContent, err = ioutil.ReadFile("/html/app.html")
		if err != nil {
			panic(err)
		}
	}
	fmt.Fprintln(w, string(appContent))
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Running IoT app. Press Ctrl+C to exit...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
