/**
 * BarGen API - JavaScript/Node.js Example
 *
 * Generate barcodes and QR codes using the BarGen API.
 * Documentation: https://bargen.pro/docs
 */

class BarGenAPI {
  constructor(apiKey) {
    this.apiKey = apiKey;
    this.baseUrl = 'https://api.bargen.pro/v1';
  }

  /**
   * Generate a barcode
   * @param {string} type - Barcode type (qrcode, ean13, code128, etc.)
   * @param {string} data - Data to encode
   * @param {Object} options - Additional options
   * @returns {Promise<ArrayBuffer|string>} - Barcode image
   */
  async generate(type, data, options = {}) {
    const params = new URLSearchParams({
      data,
      format: options.format || 'svg',
      scale: options.scale || 2,
      color: options.color || '000000',
      bgcolor: options.bgcolor || 'ffffff',
      includetext: options.includeText !== false,
      ...options
    });

    const response = await fetch(`${this.baseUrl}/barcode/${type}?${params}`, {
      headers: {
        'X-API-Key': this.apiKey
      }
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(error.error || 'Failed to generate barcode');
    }

    if (options.format === 'svg' || !options.format) {
      return response.text();
    }
    return response.arrayBuffer();
  }

  /**
   * Validate API key and get usage stats
   * @returns {Promise<Object>}
   */
  async validateKey() {
    const response = await fetch(`${this.baseUrl}/validate`, {
      headers: {
        'X-API-Key': this.apiKey
      }
    });
    return response.json();
  }

  /**
   * List all supported barcode formats
   * @returns {Promise<Object>}
   */
  async listFormats() {
    const response = await fetch(`${this.baseUrl}/formats`);
    return response.json();
  }
}

// Browser usage example
async function browserExample() {
  const api = new BarGenAPI('your_api_key_here');

  // Generate QR code and display in page
  const svg = await api.generate('qrcode', 'https://example.com');
  document.getElementById('barcode-container').innerHTML = svg;
}

// Node.js usage example
async function nodeExample() {
  const fs = require('fs');
  const api = new BarGenAPI('your_api_key_here');

  // Generate QR code
  const qrSvg = await api.generate('qrcode', 'https://example.com');
  fs.writeFileSync('qrcode.svg', qrSvg);
  console.log('Generated: qrcode.svg');

  // Generate EAN-13 as PNG
  const eanPng = await api.generate('ean13', '5901234123457', {
    format: 'png',
    pngzoom: 3
  });
  fs.writeFileSync('ean13.png', Buffer.from(eanPng));
  console.log('Generated: ean13.png');

  // Check API key
  const info = await api.validateKey();
  console.log(`Plan: ${info.plan.name}`);
  console.log(`Requests used: ${info.plan.requests_used}`);
}

// Export for Node.js
if (typeof module !== 'undefined' && module.exports) {
  module.exports = BarGenAPI;
}
