# BarGen API

**Professional Barcode & QR Code Generation API**

Generate high-quality barcodes and QR codes via a simple REST API. Perfect for e-commerce, logistics, healthcare, and enterprise applications.

[![API Status](https://img.shields.io/badge/API-Operational-brightgreen)](https://status.bargen.pro)
[![Documentation](https://img.shields.io/badge/Docs-bargen.pro-blue)](https://bargen.pro/docs)

## Features

- **19 Barcode Formats** - 1D barcodes, 2D codes, GS1, and postal codes
- **Multiple Output Formats** - SVG, PNG, PDF, EPS
- **GS1 Validation** - Built-in Application Identifier validation for GS1-128 and GS1 DataMatrix
- **High Resolution** - Configurable zoom for print-quality output
- **Fast & Reliable** - 99.9% uptime SLA available
- **Simple Integration** - RESTful API with examples in 5+ languages

## Quick Start

### 1. Get Your API Key

Sign up at [bargen.pro](https://bargen.pro/register) and create an API key in your dashboard.

### 2. Generate Your First Barcode

```bash
curl "https://api.bargen.pro/v1/barcode/qrcode?data=Hello%20World" \
  -H "X-API-Key: your_api_key"
```

### 3. Use the Response

The API returns the barcode image directly. Save it or embed it in your application.

## Supported Barcode Types

### 1D Barcodes
| Type | Description | Example Data |
|------|-------------|--------------|
| `code128` | High-density alphanumeric | `ABC-12345` |
| `code39` | Alphanumeric, self-checking | `HELLO123` |
| `ean13` | Retail products (Europe) | `5901234123457` |
| `ean8` | Small packages | `96385074` |
| `upca` | Retail products (USA) | `012345678905` |
| `upce` | Compressed UPC | `01234565` |
| `itf14` | Shipping cartons | `15400141288763` |
| `codabar` | Libraries, blood banks | `A12345B` |

### 2D Codes
| Type | Description | Example Data |
|------|-------------|--------------|
| `qrcode` | URLs, vCards, general data | `https://example.com` |
| `datamatrix` | Small parts marking | `DMX123456` |
| `aztec` | Transport tickets, IDs | `AZTEC-DATA` |
| `pdf417` | IDs, transport | `PDF417DATA` |

### GS1 Barcodes (Pro+)
| Type | Description | Example Data |
|------|-------------|--------------|
| `gs1-128` | Logistics, healthcare | `(01)00012345678905(10)ABC123` |
| `gs1-datamatrix` | Pharmaceutical | `(01)00012345678905(17)251231` |

### Postal Codes (Enterprise+)
| Type | Description | Example Data |
|------|-------------|--------------|
| `imb` | USPS Intelligent Mail | `01234567890123456789-12345` |
| `rms4cc` | Royal Mail 4-State | `BX11LP` |
| `kix` | Dutch PostNL | `1234AA111` |
| `postnet` | US ZIP encoding | `12345` |
| `planet` | USPS tracking | `12345678901` |

## API Reference

### Generate Barcode

```
GET https://api.bargen.pro/v1/barcode/{type}
```

#### Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `data` | string | Yes | - | Data to encode |
| `format` | string | No | `svg` | Output: `svg`, `png`, `pdf`, `eps` |
| `scale` | integer | No | `2` | Scale factor (1-10) |
| `height` | integer | No | auto | Height in pixels (1D codes) |
| `width` | integer | No | auto | Width in modules (2D codes) |
| `color` | string | No | `000000` | Foreground color (hex) |
| `bgcolor` | string | No | `ffffff` | Background color (hex) |
| `includetext` | boolean | No | `true` | Show human-readable text |
| `fontsize` | integer | No | `14` | Font size (8-24) |
| `ecl` | string | No | `M` | Error correction (QR): L/M/Q/H |
| `pngzoom` | float | No | `1` | Zoom for PNG/PDF/EPS (0.5-10) |

#### Authentication

Include your API key using one of these methods:

```bash
# Header (recommended)
-H "X-API-Key: your_api_key"

# Bearer token
-H "Authorization: Bearer your_api_key"

# Query parameter (for embedding)
?key=your_api_key
```

#### Response

- **Success**: Returns the barcode image with appropriate Content-Type
- **Error**: Returns JSON with error details

```json
{
  "success": false,
  "error": "Invalid barcode data"
}
```

### List Formats

```
GET https://api.bargen.pro/v1/formats
```

Returns all supported barcode types with plan requirements.

### Validate API Key

```
GET https://api.bargen.pro/v1/validate
```

Check if your API key is valid and view usage statistics.

### Health Check

```
GET https://api.bargen.pro/v1/health
```

Check API operational status (no authentication required).

## Code Examples

### cURL

```bash
# Generate QR code
curl "https://api.bargen.pro/v1/barcode/qrcode?data=https://example.com" \
  -H "X-API-Key: your_api_key" \
  -o qrcode.svg

# Generate EAN-13 barcode as PNG
curl "https://api.bargen.pro/v1/barcode/ean13?data=5901234123457&format=png&pngzoom=3" \
  -H "X-API-Key: your_api_key" \
  -o barcode.png
```

### JavaScript (Fetch)

```javascript
const response = await fetch(
  'https://api.bargen.pro/v1/barcode/qrcode?data=Hello%20World',
  {
    headers: {
      'X-API-Key': 'your_api_key'
    }
  }
);

const svgText = await response.text();
document.getElementById('barcode').innerHTML = svgText;
```

### Python

```python
import requests

response = requests.get(
    'https://api.bargen.pro/v1/barcode/code128',
    params={'data': 'ABC-12345', 'format': 'png'},
    headers={'X-API-Key': 'your_api_key'}
)

with open('barcode.png', 'wb') as f:
    f.write(response.content)
```

### PHP

```php
$ch = curl_init();
curl_setopt_array($ch, [
    CURLOPT_URL => 'https://api.bargen.pro/v1/barcode/ean13?data=5901234123457',
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HTTPHEADER => ['X-API-Key: your_api_key']
]);

$svg = curl_exec($ch);
curl_close($ch);

file_put_contents('barcode.svg', $svg);
```

### HTML Embedding

```html
<!-- Direct embedding with API key -->
<img src="https://api.bargen.pro/v1/barcode/qrcode?data=Hello&key=your_api_key"
     alt="QR Code">
```

## Pricing

| Plan | Price | API Calls | Features |
|------|-------|-----------|----------|
| **Free** | $0 | 1,000/month | All barcode types, SVG output |
| **Pro** | $9.99/month | Unlimited | + Priority support, batch generation |
| **Enterprise** | $99/month | 100,000/month | + All formats (PNG/PDF/EPS), GS1/Postal, 99.9% SLA |
| **Enterprise Plus** | $249/month | Unlimited | + Dedicated account manager, custom SLA |

[View full pricing](https://bargen.pro/pricing) | [Sign up free](https://bargen.pro/register)

## GS1 Application Identifiers

For GS1-128 and GS1 DataMatrix barcodes, use parentheses around Application Identifiers:

```
(01)00012345678905(10)ABC123(17)251231
```

| AI | Name | Format |
|----|------|--------|
| 01 | GTIN | 14 digits |
| 10 | Batch/Lot | 1-20 alphanumeric |
| 17 | Expiration Date | YYMMDD |
| 21 | Serial Number | 1-20 alphanumeric |

[Full GS1 AI reference](https://bargen.pro/docs#gs1)

## Rate Limits

- **Free**: 1,000 requests/month
- **Pro**: Unlimited
- **Enterprise**: 100,000 requests/month
- **Enterprise Plus**: Unlimited

When limit is exceeded, API returns `402 Payment Required`.

## Support

- **Documentation**: [bargen.pro/docs](https://bargen.pro/docs)
- **Status Page**: [status.bargen.pro](https://status.bargen.pro)
- **Email**: support@bargen.pro
- **Enterprise**: enterprise@bargen.pro

## Links

- [Website](https://bargen.pro)
- [API Documentation](https://bargen.pro/docs)
- [Interactive Generator](https://bargen.pro/dashboard/generator)
- [Pricing](https://bargen.pro/pricing)
- [Status Page](https://status.bargen.pro)

---

© 2025 BarGen API. All rights reserved.
