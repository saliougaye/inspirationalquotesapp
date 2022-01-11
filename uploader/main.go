package main

import (
	"errors"
	"flag"
	"fmt"
	"os"
	"path/filepath"

	"github.com/xuri/excelize/v2"
)

var EXT_VALID = []string{
	".xlsx",
}

type input struct {
	filepath string
}

type quote struct {
	quote  string
	author string
	genre  string
}

func (q quote) toString() string {
	quote := fmt.Sprintf("%s\n%s\n%s\n", q.quote, q.genre, q.author)

	return quote
}

func main() {
	flag.Usage = usage

	file, err := getData()

	if err != nil {
		exit(err)
	}

	if _, err := isFileValid(file.filepath); err != nil {
		exit(err)
	}

	quotes := parseExcel(file.filepath)

	for i, quote := range quotes {
		if i == 10 {
			return
		}

		fmt.Println(quote.toString())
	}

}

func usage() {

	fmt.Printf("Usage %s [options] <excel file>\nOptions:\n", os.Args[0])
	flag.PrintDefaults()
}

func getData() (input, error) {

	if len(os.Args) < 2 {
		return input{}, errors.New("filepath is required")
	}

	flag.Parse()

	file := flag.Arg(0)

	return input{file}, nil
}

func isFileValid(file string) (bool, error) {

	fileExtension := filepath.Ext(file)

	if !isExtensionValid(fileExtension) {

		return false, fmt.Errorf("file %s is not excel", file)

	}

	if _, err := os.Stat(file); err != nil && os.IsNotExist(err) {
		return false, fmt.Errorf("file %s does not exist", file)
	}

	return true, nil

}

func isExtensionValid(extension string) bool {

	for _, ext := range EXT_VALID {
		if ext == extension {
			return true
		}
	}

	return false
}

func parseExcel(filename string) []quote {
	f, err := excelize.OpenFile(filename)

	if err != nil {
		exit(err)
	}

	defer func() {
		if err := f.Close(); err != nil {
			exit(err)
		}
	}()

	sheets := f.GetSheetList()

	sheet := sheets[0]

	var quotes []quote

	rows, err := f.GetRows(sheet)

	if err != nil {
		exit(err)
	}

	for _, row := range rows {
		if len(row) >= 3 {
			quote := quote{
				quote:  row[0],
				author: row[1],
				genre:  row[2],
			}

			quotes = append(quotes, quote)
		}
	}

	return quotes

}

func exit(err error) {

	fmt.Fprintf(os.Stderr, "error: %v\n", err)
	os.Exit(1)

}
