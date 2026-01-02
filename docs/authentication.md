# Authentication

All API requests (except `/v1/formats` and `/v1/health`) require authentication using an API key.

## Getting an API Key

1. Sign up at [bargen.pro/register](https://bargen.pro/register)
2. Go to your [Dashboard](https://bargen.pro/dashboard)
3. Navigate to **API Keys**
4. Click **Create API Key**
5. Give it a name and copy the key

> **Important**: Store your API key securely. It cannot be viewed again after creation.

## Authentication Methods

### 1. X-API-Key Header (Recommended)

```bash
curl "https://api.bargen.pro/v1/barcode/qrcode?data=Hello" \
  -H "X-API-Key: your_api_key_here"
```

### 2. Authorization Bearer Header

```bash
curl "https://api.bargen.pro/v1/barcode/qrcode?data=Hello" \
  -H "Authorization: Bearer your_api_key_here"
```

### 3. Query Parameter

Use this method for HTML embedding where headers cannot be set:

```html
<img src="https://api.bargen.pro/v1/barcode/qrcode?data=Hello&key=your_api_key_here">
```

> **Security Note**: Query parameter exposes your key in URLs and logs. Use header authentication when possible.

## Validating Your Key

Check if your API key is valid:

```bash
curl "https://api.bargen.pro/v1/validate" \
  -H "X-API-Key: your_api_key_here"
```

Response:

```json
{
  "success": true,
  "key": {
    "name": "Production Key",
    "created_at": "2025-01-01T00:00:00Z",
    "last_used_at": "2025-01-02T12:00:00Z"
  },
  "plan": {
    "name": "Pro",
    "requests_used": 150,
    "requests_limit": null
  }
}
```

## Error Responses

### Invalid API Key (401)

```json
{
  "success": false,
  "error": "Invalid API key"
}
```

### Missing API Key (401)

```json
{
  "success": false,
  "error": "API key required"
}
```

### Rate Limit Exceeded (402)

```json
{
  "success": false,
  "error": "API request limit exceeded. Please upgrade your plan.",
  "upgrade_url": "https://bargen.pro/dashboard/subscription"
}
```

## Multiple API Keys

You can create multiple API keys for different purposes:

- **Development** - For testing and development
- **Production** - For live applications
- **Analytics** - For tracking specific integrations

Each key shares your account's request quota.

## Revoking Keys

To revoke an API key:

1. Go to [Dashboard > API Keys](https://bargen.pro/dashboard/api-keys)
2. Find the key you want to revoke
3. Click the **Delete** button
4. Confirm deletion

Revoked keys stop working immediately.
