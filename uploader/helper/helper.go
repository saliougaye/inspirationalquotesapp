package helper

import (
	"context"
	"fmt"
	"inspirationalquotes/uploader/util"
	"os"

	"github.com/joho/godotenv"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func ConnectDB() *mongo.Collection {
	config, err := GetConfiguration()

	if err != nil {

		util.Exit(err)
	}

	// Set client options
	clientOptions := options.Client().ApplyURI(config.ConnectionString)

	// Connect to MongoDB
	client, err := mongo.Connect(context.TODO(), clientOptions)

	if err != nil {
		util.Exit(err)
	}

	fmt.Println("Connected to MongoDB!")

	collection := client.Database(config.DBName).Collection(config.CollectionName)

	return collection
}

// Configuration model
type Configuration struct {
	ConnectionString string
	DBName           string
	CollectionName   string
}

// GetConfiguration method basically populate configuration information from .env and return Configuration model
func GetConfiguration() (Configuration, error) {
	err := godotenv.Load("./.env")

	if err != nil {
		return Configuration{}, err
	}

	configuration := Configuration{
		os.Getenv("CONNECTION_STRING"),
		os.Getenv("DB_NAME"),
		os.Getenv("COLLECTION_NAME"),
	}

	return configuration, nil
}
