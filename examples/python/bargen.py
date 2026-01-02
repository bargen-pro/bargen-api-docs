"""
BarGen API - Python Example

Generate barcodes and QR codes using the BarGen API.
Documentation: https://bargen.pro/docs
"""

import requests
from typing import Optional


class BarGenAPI:
    """Simple wrapper for BarGen API."""

    BASE_URL = "https://api.bargen.pro/v1"

    def __init__(self, api_key: str):
        self.api_key = api_key
        self.session = requests.Session()
        self.session.headers.update({
            "X-API-Key": api_key
        })

    def generate(
        self,
        barcode_type: str,
        data: str,
        format: str = "svg",
        scale: int = 2,
        color: str = "000000",
        bgcolor: str = "ffffff",
        include_text: bool = True,
        **kwargs
    ) -> bytes:
        """
        Generate a barcode.

        Args:
            barcode_type: Type of barcode (qrcode, ean13, code128, etc.)
            data: Data to encode
            format: Output format (svg, png, pdf, eps)
            scale: Scale factor (1-10)
            color: Foreground color (hex)
            bgcolor: Background color (hex)
            include_text: Show human-readable text
            **kwargs: Additional parameters (height, width, ecl, pngzoom, etc.)

        Returns:
            Barcode image as bytes
        """
        params = {
            "data": data,
            "format": format,
            "scale": scale,
            "color": color,
            "bgcolor": bgcolor,
            "includetext": str(include_text).lower(),
            **kwargs
        }

        response = self.session.get(
            f"{self.BASE_URL}/barcode/{barcode_type}",
            params=params
        )
        response.raise_for_status()
        return response.content

    def validate_key(self) -> dict:
        """Validate API key and get usage stats."""
        response = self.session.get(f"{self.BASE_URL}/validate")
        response.raise_for_status()
        return response.json()

    def list_formats(self) -> dict:
        """List all supported barcode formats."""
        response = self.session.get(f"{self.BASE_URL}/formats")
        response.raise_for_status()
        return response.json()


# Example usage
if __name__ == "__main__":
    # Initialize with your API key
    api = BarGenAPI("your_api_key_here")

    # Generate QR code
    qr_svg = api.generate("qrcode", "https://example.com")
    with open("qrcode.svg", "wb") as f:
        f.write(qr_svg)
    print("Generated: qrcode.svg")

    # Generate EAN-13 barcode as PNG
    ean_png = api.generate(
        "ean13",
        "5901234123457",
        format="png",
        pngzoom=3
    )
    with open("ean13.png", "wb") as f:
        f.write(ean_png)
    print("Generated: ean13.png")

    # Generate Code 128 with custom colors
    code128_svg = api.generate(
        "code128",
        "ABC-12345",
        color="003366",
        bgcolor="f0f0f0"
    )
    with open("code128.svg", "wb") as f:
        f.write(code128_svg)
    print("Generated: code128.svg")

    # Check API key validity
    info = api.validate_key()
    print(f"Plan: {info['plan']['name']}")
    print(f"Requests used: {info['plan']['requests_used']}")
