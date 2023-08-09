#!/bin/bash

# Create a directory for the layer
mkdir -p latex_layer/bin

# Todo: eventually replace this with a solution
# that uses `which pdflatex` to pull pdflatex path
cp /Library/TeX/texbin/pdflatex latex_layer/bin

# Zip the layer
cd latex_layer
zip -r latex_layer.zip .

# Create layer
aws lambda publish-layer-version --layer-name latex-layer --zip-file fileb://latex_layer.zip --compatible-runtimes python3.8

# Attach layer to lambda function
# Todo: pull account id from secrets file
aws lambda update-function-configuration --function-name compile_tex --layers arn:aws:lambda:us-east-1:your-account-id:layer:latex-layer:1
