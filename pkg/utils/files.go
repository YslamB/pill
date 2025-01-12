package utils

import (
	"bytes"
	"errors"
	"fmt"
	"image"
	"image/jpeg"
	"image/png"
	"io"
	"pharmacy/internal/config"
	"os"
	"path/filepath"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/nfnt/resize"
)

var extensions map[string]bool = map[string]bool{
	"jpg":  true,
	"jpeg": true,
	"png":  true,
	"mp4":  true,
	"heic": true,
}

func WriteImage(c *gin.Context, dir string) string {
	image, header, _ := c.Request.FormFile("image")

	if image == nil {
		return ""
	}

	splitedFileName := strings.Split(header.Filename, ".")
	extension := splitedFileName[len(splitedFileName)-1]
	filename := fmt.Sprintf("%v.", uuid.NewString()) + extension

	if extension == "webp" || extension == "svg" || extension == "jpeg" ||
		extension == "jpg" || extension == "png" {

		buf := bytes.NewBuffer(nil)
		io.Copy(buf, image)
		err := os.WriteFile(
			config.ENV.UPLOAD_PATH+dir+filename,
			buf.Bytes(), os.ModePerm,
		)
		if err != nil {
			return ""
		}

		return filename
	}

	return ""
}

func SaveFiles(c *gin.Context) ([]string, int, error) {
	form, _ := c.MultipartForm()

	if form == nil {
		return nil, 400, errors.New("didn't upload the files")
	}

	files := form.File["files"]

	if len(files) == 0 {
		return nil, 400, errors.New("must load minimum 1 file")
	}

	var filePaths []string
	var fileNames []string
	var video = 0
	var images = 0
	for _, file := range files {
		const maxFileSize = 50 * 1024 * 1024 // 50MB

		if file.Size > maxFileSize {
			return nil, 400, fmt.Errorf("file %s is too large", file.Filename)
		}
		splitedFileName := strings.Split(file.Filename, ".")
		extension := splitedFileName[len(splitedFileName)-1]

		extensionExists := extensions[extension]

		if !extensionExists {
			return nil, 400, fmt.Errorf("this file (extension) is forbidden: .%s", extension)
		}

		if extension == "mp4" {
			video += 1
		} else {
			images += 1
		}

		if video > 1 || images > 5 {
			return nil, 400, fmt.Errorf("trying to upload %v video and %v images", video, images)
		}

		fileNames = append(fileNames, uuid.NewString()+"."+extension)
	}

	for index, file := range files {
		readerFile, _ := file.Open()

		buf := bytes.NewBuffer(nil)
		io.Copy(buf, readerFile)
		err := os.WriteFile(
			config.ENV.UPLOAD_PATH+"orders/"+fileNames[index],
			buf.Bytes(),
			os.ModePerm,
		)

		if err != nil {
			return nil, 500, err
		}

		if strings.ToLower(filepath.Ext(fileNames[index])) != ".mp4" && strings.ToLower(filepath.Ext(fileNames[index])) != ".heic" {

			err = resizeImage(config.ENV.UPLOAD_PATH+"orders/"+fileNames[index], 700)
			if err != nil {
				return nil, 500, err
			}

		}

		filePaths = append(filePaths, "/uploads/orders/"+fileNames[index])
	}

	return filePaths, 0, nil
}

func resizeImage(imagePath string, width uint) error {
	// Open the image file
	file, err := os.Open(imagePath)
	if err != nil {
		return fmt.Errorf("failed to open image: %w", err)
	}
	defer file.Close()

	// Decode the image
	img, format, err := image.Decode(file)
	if err != nil {
		return fmt.Errorf("failed to decode image: %w", err)
	}

	// Resize the image to the specified width
	newImage := resize.Resize(width, 0, img, resize.Lanczos3)

	// Close the original file so it can be deleted
	file.Close()

	// Delete the original image file
	err = os.Remove(imagePath)
	if err != nil {
		return fmt.Errorf("failed to delete original image: %w", err)
	}

	// Create a new file with the same name
	out, err := os.Create(imagePath)
	if err != nil {
		return fmt.Errorf("failed to create new image file: %w", err)
	}
	defer out.Close()

	// Encode and save the resized image
	switch format {
	case "jpeg":
		err = jpeg.Encode(out, newImage, nil)
	case "png":
		err = png.Encode(out, newImage)
	default:
		return fmt.Errorf("unsupported image format: %s", format)
	}
	if err != nil {
		return fmt.Errorf("failed to save resized image: %w", err)
	}

	return nil
}
