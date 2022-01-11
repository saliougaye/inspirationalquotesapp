package util

import (
	"fmt"
	"os"
)

func Exit(err error) {
	fmt.Fprintf(os.Stderr, "error: %v\n", err)
	os.Exit(1)

}
