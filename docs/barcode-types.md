# Barcode Types

BarGen API supports 19 barcode formats across different categories.

## 1D Barcodes (Linear)

### Code 128
High-density barcode supporting all 128 ASCII characters.

```
GET /v1/barcode/code128?data=ABC-12345
```

**Best for**: General-purpose labeling, shipping, inventory

---

### Code 39
Self-checking alphanumeric barcode.

```
GET /v1/barcode/code39?data=HELLO123
```

**Characters**: A-Z, 0-9, space, - . $ / + %
**Best for**: Automotive industry, government, healthcare

---

### EAN-13
European Article Number for retail products.

```
GET /v1/barcode/ean13?data=5901234123457
```

**Format**: 13 digits (12 + check digit)
**Best for**: Retail products worldwide

---

### EAN-8
Compact version of EAN-13 for small packages.

```
GET /v1/barcode/ean8?data=96385074
```

**Format**: 8 digits (7 + check digit)
**Best for**: Small items where EAN-13 won't fit

---

### UPC-A
Universal Product Code for North American retail.

```
GET /v1/barcode/upca?data=012345678905
```

**Format**: 12 digits (11 + check digit)
**Best for**: Retail products in USA/Canada

---

### UPC-E
Compressed version of UPC-A.

```
GET /v1/barcode/upce?data=01234565
```

**Format**: 8 digits
**Best for**: Small retail items

---

### ITF-14
Interleaved 2 of 5 for shipping containers.

```
GET /v1/barcode/itf14?data=15400141288763
```

**Format**: 14 digits
**Best for**: Shipping cartons, outer packaging

---

### Codabar
Self-checking numeric barcode with start/stop characters.

```
GET /v1/barcode/codabar?data=A12345B
```

**Characters**: 0-9, - $ : / . +, start/stop: A B C D
**Best for**: Libraries, blood banks, FedEx airbills

---

## 2D Barcodes

### QR Code
Quick Response code with high data capacity.

```
GET /v1/barcode/qrcode?data=https://example.com&ecl=M
```

**Capacity**: Up to 4,296 alphanumeric characters
**Error Correction Levels**:
- `L` - 7% recovery
- `M` - 15% recovery (default)
- `Q` - 25% recovery
- `H` - 30% recovery

**Best for**: URLs, contact info, mobile payments

---

### Data Matrix
Compact 2D code for small items.

```
GET /v1/barcode/datamatrix?data=DMX123456
```

**Capacity**: Up to 2,335 alphanumeric characters
**Best for**: Electronics, small parts, pharmaceutical

---

### Aztec
Space-efficient 2D code.

```
GET /v1/barcode/aztec?data=AZTEC-DATA
```

**Best for**: Transport tickets, airline boarding passes

---

### PDF417
Stacked linear barcode with high capacity.

```
GET /v1/barcode/pdf417?data=PDF417-DOCUMENT-DATA
```

**Capacity**: Up to 1,850 alphanumeric characters
**Best for**: ID cards, driver's licenses, shipping labels

---

## GS1 Barcodes (Pro Plan+)

### GS1-128
Code 128 with GS1 Application Identifiers.

```
GET /v1/barcode/gs1-128?data=(01)00012345678905(10)ABC123(17)251231
```

**Format**: AI codes in parentheses
**Best for**: Supply chain, healthcare, logistics

---

### GS1 DataMatrix
Data Matrix with GS1 Application Identifiers.

```
GET /v1/barcode/gs1-datamatrix?data=(01)00012345678905(21)SERIAL123
```

**Best for**: Pharmaceutical serialization, healthcare

### Common Application Identifiers

| AI | Name | Length | Example |
|----|------|--------|---------|
| 01 | GTIN | 14 digits | `(01)00012345678905` |
| 10 | Batch/Lot | 1-20 chars | `(10)ABC123` |
| 17 | Expiry Date | 6 digits | `(17)251231` |
| 21 | Serial Number | 1-20 chars | `(21)XYZ789` |
| 37 | Quantity | 1-8 digits | `(37)100` |

---

## Postal Barcodes (Enterprise Plan+)

### USPS Intelligent Mail Barcode (IMB)
65-bar code for US mail routing.

```
GET /v1/barcode/imb?data=01234567890123456789-12345
```

**Format**: `{20-digit tracking}-{0,5,9,11-digit routing}`
**Best for**: US Postal Service mail

---

### Royal Mail 4-State (RMS4CC)
UK postal barcode.

```
GET /v1/barcode/rms4cc?data=BX11LP
```

**Format**: Postcode + Delivery Point Suffix
**Best for**: UK Royal Mail

---

### Dutch PostNL KIX
Netherlands postal barcode.

```
GET /v1/barcode/kix?data=1234AA111
```

**Format**: Postcode + house number
**Best for**: Netherlands PostNL

---

### POSTNET
US ZIP code barcode (legacy).

```
GET /v1/barcode/postnet?data=12345
```

**Format**: 5, 9, or 11 digits
**Best for**: Legacy US postal applications

---

### PLANET
USPS tracking barcode (legacy).

```
GET /v1/barcode/planet?data=12345678901
```

**Format**: 11 or 13 digits
**Best for**: Legacy USPS tracking

---

## Plan Availability

| Category | Types | Plan Required |
|----------|-------|---------------|
| 1D Barcodes | code128, code39, ean13, ean8, upca, upce, itf14, codabar | Free |
| 2D Codes | qrcode, datamatrix, aztec, pdf417 | Free |
| GS1 | gs1-128, gs1-datamatrix | Pro |
| Postal | imb, rms4cc, kix, postnet, planet | Enterprise |
