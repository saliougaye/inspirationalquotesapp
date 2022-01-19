package main

import (
	"context"
	"errors"
	"flag"
	"fmt"
	"inspirationalquotes/uploader/helper"
	"inspirationalquotes/uploader/models"
	"inspirationalquotes/uploader/util"
	"os"
	"path/filepath"
	"strings"

	"github.com/xuri/excelize/v2"
	"go.mongodb.org/mongo-driver/bson"
)

var EXT_VALID = []string{
	".xlsx",
}

type input struct {
	filepath string
	n        int
}

var collection = helper.ConnectDB()

func main() {
	flag.Usage = usage

	file, err := getData()

	if err != nil {
		util.Exit(err)
	}

	if _, err := isFileValid(file.filepath); err != nil {
		util.Exit(err)
	}

	quotes := parseExcel(file)

	uploadQuotes(quotes)

	fmt.Println("upload completed")

}

func usage() {

	fmt.Printf("Usage %s [options] <excel file>\nOptions:\n", os.Args[0])
	flag.PrintDefaults()
}

func getData() (input, error) {
	flagNLines := flag.Int("n", -1, "number of lines to upload")

	if len(os.Args) < 2 {
		return input{}, errors.New("filepath is required")
	}

	flag.Parse()

	file := flag.Arg(0)

	fmt.Println(*flagNLines)

	return input{file, *flagNLines}, nil
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

func parseExcel(input input) []models.Quote {
	f, err := excelize.OpenFile(input.filepath)

	if err != nil {
		util.Exit(err)
	}

	defer func() {
		if err := f.Close(); err != nil {
			util.Exit(err)
		}
	}()

	sheets := f.GetSheetList()

	sheet := sheets[0]

	var quotes []models.Quote

	rows, err := f.GetRows(sheet)

	if err != nil {
		util.Exit(err)
	}

	for _, row := range rows {
		if len(row) >= 3 {
			quote := models.Quote{
				Quote:  strings.TrimSpace(row[0]),
				Author: strings.TrimSpace(row[1]),
				Genre:  strings.TrimSpace(row[2]),
			}

			quotes = append(quotes, quote)
		}
	}

	quotes = quotes[:input.n]

	return quotes

}

func uploadQuotes(quotes []models.Quote) {
	for i, quote := range quotes {

		var quoteBson bson.D
		var err error
		quote.ToBson(&quoteBson, err)

		if err != nil {
			util.Exit(err)
		}

		_, err = collection.InsertOne(context.TODO(), quoteBson)

		var res string

		if err != nil {
			res = fmt.Sprintf("%d row not inserted, Error: %s", i, err)
		} else {
			res = fmt.Sprintf("%d inserted correctly", i)
		}

		fmt.Println(res)

	}
}
