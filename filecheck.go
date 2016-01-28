package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
)

const (
	syncDir = "/mnt/minio/data"
)

// Serve will start the fetcher server and block until it stops. Since it blocks, it's a best practice to execute this func in a goroutine.
func main() {
	rtr := mux.NewRouter()
	rtr.HandleFunc("/{path:.+}", checkpath).Methods("GET")
	rtr.HandleFunc("/health", health).Methods("GET")
	http.Handle("/", rtr)
	log.Println("Listening... on 3000")
	http.ListenAndServe(":3000", nil)

}

func health(w http.ResponseWriter, r *http.Request) {
	fmt.Fprint(w, "Hello, world!")
}

func checkpath(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	path := params["path"]
	fmt.Println("GET params:", path)
	_, err := os.Stat("/" + path)
	if err == nil {
		w.Write([]byte("present"))
		return
	}
	w.Write([]byte("notPresent"))
}
