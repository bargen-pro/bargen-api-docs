<?php
/**
 * BarGen API - PHP Example
 *
 * Generate barcodes and QR codes using the BarGen API.
 * Documentation: https://bargen.pro/docs
 */

class BarGenAPI
{
    private string $apiKey;
    private string $baseUrl = 'https://api.bargen.pro/v1';

    public function __construct(string $apiKey)
    {
        $this->apiKey = $apiKey;
    }

    /**
     * Generate a barcode
     *
     * @param string $type Barcode type (qrcode, ean13, code128, etc.)
     * @param string $data Data to encode
     * @param array $options Additional options
     * @return string Barcode image content
     * @throws Exception
     */
    public function generate(string $type, string $data, array $options = []): string
    {
        $params = array_merge([
            'data' => $data,
            'format' => 'svg',
            'scale' => 2,
            'color' => '000000',
            'bgcolor' => 'ffffff',
            'includetext' => 'true',
        ], $options);

        $url = $this->baseUrl . '/barcode/' . $type . '?' . http_build_query($params);

        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $url,
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'X-API-Key: ' . $this->apiKey
            ]
        ]);

        $response = curl_exec($ch);
        $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
        curl_close($ch);

        if ($httpCode !== 200) {
            $error = json_decode($response, true);
            throw new Exception($error['error'] ?? 'Failed to generate barcode');
        }

        return $response;
    }

    /**
     * Validate API key and get usage stats
     *
     * @return array
     */
    public function validateKey(): array
    {
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $this->baseUrl . '/validate',
            CURLOPT_RETURNTRANSFER => true,
            CURLOPT_HTTPHEADER => [
                'X-API-Key: ' . $this->apiKey
            ]
        ]);

        $response = curl_exec($ch);
        curl_close($ch);

        return json_decode($response, true);
    }

    /**
     * List all supported barcode formats
     *
     * @return array
     */
    public function listFormats(): array
    {
        $ch = curl_init();
        curl_setopt_array($ch, [
            CURLOPT_URL => $this->baseUrl . '/formats',
            CURLOPT_RETURNTRANSFER => true,
        ]);

        $response = curl_exec($ch);
        curl_close($ch);

        return json_decode($response, true);
    }
}

// Example usage
if (php_sapi_name() === 'cli') {
    $api = new BarGenAPI('your_api_key_here');

    // Generate QR code
    $qrSvg = $api->generate('qrcode', 'https://example.com');
    file_put_contents('qrcode.svg', $qrSvg);
    echo "Generated: qrcode.svg\n";

    // Generate EAN-13 as PNG
    $eanPng = $api->generate('ean13', '5901234123457', [
        'format' => 'png',
        'pngzoom' => 3
    ]);
    file_put_contents('ean13.png', $eanPng);
    echo "Generated: ean13.png\n";

    // Generate Code 128 with custom colors
    $code128Svg = $api->generate('code128', 'ABC-12345', [
        'color' => '003366',
        'bgcolor' => 'f0f0f0'
    ]);
    file_put_contents('code128.svg', $code128Svg);
    echo "Generated: code128.svg\n";

    // Check API key
    $info = $api->validateKey();
    echo "Plan: {$info['plan']['name']}\n";
    echo "Requests used: {$info['plan']['requests_used']}\n";
}
