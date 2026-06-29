# BarGen API — integration brief for an AI coding agent

You are integrating the **BarGen** barcode & QR code generation API into a project. Use the facts below as the single source of truth. Generate clean, production-ready code in the project's language/framework, read the API key from an environment variable, and handle errors gracefully.

## What it does
BarGen turns text/data into a barcode or QR code **image** via one HTTP request. Output formats: **SVG, PNG, PDF, EPS**. There is no SDK — it's a plain REST API you call over HTTPS.

## Base URL
```
https://api.bargen.pro
```

## Authentication
Every endpoint except `GET /v1/formats` and `GET /v1/health` requires an API key (create one in the dashboard at https://bargen.pro → API keys). Pass it any ONE of these ways:
- Header: `X-API-Key: <YOUR_KEY>`  ← preferred
- Header: `Authorization: Bearer <YOUR_KEY>`
- Query param: `?key=<YOUR_KEY>`  (the param name is `key`, not `api_key`)

Store the key in an env var such as `BARGEN_API_KEY`. Never hardcode it.

## Endpoints
| Method | Path | Auth | Purpose |
|--------|------|------|---------|
| GET | `/v1/health` | no | Service health check |
| GET | `/v1/formats` | no | List all barcode types + the plan each requires |
| GET | `/v1/validate` | yes | Validate the API key, see usage |
| GET | `/v1/barcode/{type}` | yes | Generate one barcode image |
| POST | `/v1/barcode/batch` | yes | Generate up to 50 barcodes in one call |

## Generate one barcode
```
GET /v1/barcode/{type}?data=<payload>&format=<svg|png|pdf|eps>&<options...>
```
The response body is the raw image with the correct `Content-Type` (`image/svg+xml`, `image/png`, `application/pdf`, `application/postscript`).

### Parameters
| Param | Required | Default | Notes |
|-------|----------|---------|-------|
| `data` | yes | — | The content to encode (URL-encode it) |
| `format` | no | `svg` | `svg`, `png`, `pdf`, `eps` (plan-gated, see below) |
| `scale` | no | `2` | Module scale, 1–10 |
| `width` | no | auto | Target width in px, 10–2000 |
| `height` | no | auto | Target height in px, 10–2000 |
| `color` | no | `000000` | Foreground hex (no `#`) |
| `bgcolor` | no | `ffffff` | Background hex (no `#`) |
| `includetext` | no | `true` | Show the human-readable text line |
| `fontsize` | no | `14` | Text size, 8–24 |
| `ecl` | no | `M` | QR error-correction level: `L`, `M`, `Q`, `H` |
| `pngzoom` | no | `1` | Extra zoom for PNG output, 0.5–10 |

## Barcode types (slug → name), grouped by the minimum plan that unlocks them
**Free (15):**
`qrcode` (QR Code), `code128` (Code 128), `code39` (Code 39), `ean13` (EAN-13), `ean8` (EAN-8), `upca` (UPC-A), `upce` (UPC-E), `itf12` (ITF-12), `itf14` (ITF-14), `itf16` (ITF-16), `gls-ecsomag` (GLS eCsomag), `codabar` (Codabar), `datamatrix` (DataMatrix), `pdf417` (PDF-417), `aztec` (Aztec)

**Pro adds (3):**
`gs1-128` (GS1-128 / UCC-EAN-128), `gs1-datamatrix` (GS1 DataMatrix), `microqr` (Micro QR)

**Business adds (7):**
`imb` (USPS Intelligent Mail), `rms4cc` (Royal Mail 4-State), `kix` (Dutch PostNL KIX), `postnet` (USPS POSTNET), `planet` (USPS PLANET), `maxicode` (MaxiCode), `dotcode` (DotCode)

Enterprise unlocks the same 25 types with no volume cap. Call `GET /v1/formats` at runtime to discover the current list + required plan programmatically.

## Output formats by plan
- **SVG** — all plans (incl. Free)
- **PNG** — Pro and above
- **PDF, EPS** — Business and above

## Plans & monthly limits
| Plan | Price | Monthly requests | Formats | Types |
|------|-------|------------------|---------|-------|
| Free | $0 | 1,000 | SVG | 15 |
| Pro | $9.99/mo | 10,000 | SVG, PNG | 18 |
| Business | $29/mo | 100,000 | SVG, PNG, PDF, EPS | 25 (incl. postal) |
| Enterprise | custom | unlimited | all | 25 |

## Errors (HTTP status)
| Code | Meaning | What to do |
|------|---------|------------|
| 400 | Invalid type / params / missing `data` | Fix the request |
| 401 | Missing or invalid API key | Check the key/header |
| 402 | Monthly request limit reached | Wait for next period or upgrade |
| 403 | Your plan doesn't include this barcode type or output format | Upgrade the plan |
| 404 | Unknown endpoint | Fix the URL |
Error responses are JSON: `{ "error": "message" }`.

## Batch generation
```
POST /v1/barcode/batch
Content-Type: application/json
X-API-Key: <YOUR_KEY>

{
  "codes": [
    { "type": "qrcode", "data": "https://example.com" },
    { "type": "ean13",  "data": "5901234123457" }
  ],
  "options": { "scale": 3 }
}
```
Max **50** codes per request. Optional top-level `options` apply to all codes. Response:
```json
{
  "results": [
    { "index": 0, "success": true,  "svg": "<base64-encoded SVG>" },
    { "index": 1, "success": false, "error": "..." }
  ],
  "total": 2,
  "successful": 1
}
```
Note: batch always returns **base64-encoded SVG** in each item's `svg` field (decode it client-side); per-item output format is not selectable in batch.

## Validate the key
```
GET /v1/validate
```
Returns: `{ "valid": true, "name": "<key name>", "requests": <count this period>, "created_at": "...", "last_used_at": "..." }`.

## Examples

**cURL**
```bash
curl -H "X-API-Key: $BARGEN_API_KEY" \
  "https://api.bargen.pro/v1/barcode/qrcode?data=Hello%20World&format=png&scale=4" \
  --output qr.png
```

**JavaScript (fetch)**
```js
const res = await fetch(
  "https://api.bargen.pro/v1/barcode/ean13?data=5901234123457&format=svg",
  { headers: { "X-API-Key": process.env.BARGEN_API_KEY } }
);
if (!res.ok) throw new Error(`BarGen ${res.status}: ${(await res.json()).error}`);
const svg = await res.text();
```

**Python (requests)**
```python
import os, requests
r = requests.get(
    "https://api.bargen.pro/v1/barcode/code128",
    params={"data": "ABC-123", "format": "png", "scale": 3},
    headers={"X-API-Key": os.environ["BARGEN_API_KEY"]},
)
r.raise_for_status()
open("barcode.png", "wb").write(r.content)
```

## Integration checklist
- [ ] Read the API key from `BARGEN_API_KEY` (env), not source.
- [ ] URL-encode the `data` value.
- [ ] Pick `format` based on need (SVG to embed in web pages; PNG for raster; PDF/EPS for print — note PNG needs Pro, PDF/EPS need Business).
- [ ] Handle non-2xx: surface 402 (limit) and 403 (plan) distinctly so the user knows to upgrade.
- [ ] Cache generated images when the `data` is stable to conserve your monthly quota.
- [ ] Optionally call `GET /v1/validate` on startup and `GET /v1/formats` to discover available types.
