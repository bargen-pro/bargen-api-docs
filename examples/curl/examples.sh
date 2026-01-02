#!/bin/bash
#
# BarGen API - cURL Examples
#
# Generate barcodes and QR codes using the BarGen API.
# Documentation: https://bargen.pro/docs
#

API_KEY="your_api_key_here"
BASE_URL="https://api.bargen.pro/v1"

# -----------------------------------------------------------------------------
# QR Code Examples
# -----------------------------------------------------------------------------

# Basic QR code (SVG)
curl "${BASE_URL}/barcode/qrcode?data=https://example.com" \
  -H "X-API-Key: ${API_KEY}" \
  -o qrcode.svg

# QR code with high error correction
curl "${BASE_URL}/barcode/qrcode?data=Hello%20World&ecl=H" \
  -H "X-API-Key: ${API_KEY}" \
  -o qrcode-high-ecl.svg

# QR code as PNG (high resolution)
curl "${BASE_URL}/barcode/qrcode?data=https://example.com&format=png&pngzoom=5" \
  -H "X-API-Key: ${API_KEY}" \
  -o qrcode.png

# -----------------------------------------------------------------------------
# 1D Barcode Examples
# -----------------------------------------------------------------------------

# EAN-13 barcode
curl "${BASE_URL}/barcode/ean13?data=5901234123457" \
  -H "X-API-Key: ${API_KEY}" \
  -o ean13.svg

# Code 128 barcode
curl "${BASE_URL}/barcode/code128?data=ABC-12345" \
  -H "X-API-Key: ${API_KEY}" \
  -o code128.svg

# UPC-A barcode as PNG
curl "${BASE_URL}/barcode/upca?data=012345678905&format=png&pngzoom=3" \
  -H "X-API-Key: ${API_KEY}" \
  -o upca.png

# Code 39 with custom height
curl "${BASE_URL}/barcode/code39?data=HELLO123&height=100" \
  -H "X-API-Key: ${API_KEY}" \
  -o code39.svg

# -----------------------------------------------------------------------------
# Custom Styling
# -----------------------------------------------------------------------------

# Custom colors (dark blue on light gray)
curl "${BASE_URL}/barcode/code128?data=STYLED&color=003366&bgcolor=f0f0f0" \
  -H "X-API-Key: ${API_KEY}" \
  -o styled.svg

# Without human-readable text
curl "${BASE_URL}/barcode/ean13?data=5901234123457&includetext=false" \
  -H "X-API-Key: ${API_KEY}" \
  -o ean13-no-text.svg

# Custom font size
curl "${BASE_URL}/barcode/code128?data=ABC123&fontsize=18" \
  -H "X-API-Key: ${API_KEY}" \
  -o code128-large-font.svg

# -----------------------------------------------------------------------------
# GS1 Barcodes (Pro Plan)
# -----------------------------------------------------------------------------

# GS1-128 with GTIN and batch number
curl "${BASE_URL}/barcode/gs1-128?data=(01)00012345678905(10)ABC123(17)251231" \
  -H "X-API-Key: ${API_KEY}" \
  -o gs1-128.svg

# GS1 DataMatrix
curl "${BASE_URL}/barcode/gs1-datamatrix?data=(01)00012345678905(21)SERIAL123" \
  -H "X-API-Key: ${API_KEY}" \
  -o gs1-datamatrix.svg

# -----------------------------------------------------------------------------
# Postal Barcodes (Enterprise Plan)
# -----------------------------------------------------------------------------

# USPS Intelligent Mail Barcode
curl "${BASE_URL}/barcode/imb?data=01234567890123456789-12345" \
  -H "X-API-Key: ${API_KEY}" \
  -o imb.svg

# Royal Mail 4-State
curl "${BASE_URL}/barcode/rms4cc?data=BX11LP" \
  -H "X-API-Key: ${API_KEY}" \
  -o rms4cc.svg

# -----------------------------------------------------------------------------
# API Information
# -----------------------------------------------------------------------------

# List all supported formats
curl "${BASE_URL}/formats" | jq .

# Validate API key
curl "${BASE_URL}/validate" \
  -H "X-API-Key: ${API_KEY}" | jq .

# Health check (no auth required)
curl "${BASE_URL}/health" | jq .

echo "Done! Check the generated files."
