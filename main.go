package main

import (
	"embed"
	"log"
	"net/http"
	"path/filepath"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
)

//go:embed dev-utilities/out/*
var staticFiles embed.FS

func main() {
	// Create a new Fiber instance
	app := fiber.New()

	// Custom middleware to handle paths without .html extension
	app.Use(func(c *fiber.Ctx) error {
		// Get the requested path
		path := c.Path()

		// Check if the path does not have an extension
		if filepath.Ext(path) == "" {
			// Append .html to the path
			htmlPath := path + ".html"

			// Check if the .html file exists in the embedded filesystem
			if _, err := staticFiles.Open("dev-utilities/out" + htmlPath); err == nil {
				// Serve the .html file
				c.Path(htmlPath)
			}
		}

		// Proceed to the next middleware
		return c.Next()
	})

	// Serve static files from the embedded filesystem
	app.Use("/", filesystem.New(filesystem.Config{
		Root:       http.FS(staticFiles),
		PathPrefix: "dev-utilities/out",
		Browse:     true,
	}))

	// Start the server on port 3000
	log.Fatal(app.Listen(":3000"))
}
