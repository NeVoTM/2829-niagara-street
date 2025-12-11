#!/usr/bin/env python3
"""
Image Compression Utility

Compresses images to meet MMS size requirements while maintaining quality.
Target: Under 1.5 MB (ideal: 500-800 KB for best compatibility)
"""

import sys
from pathlib import Path
from PIL import Image
import os

def get_file_size_mb(file_path):
    """Get file size in MB"""
    return os.path.getsize(file_path) / (1024 * 1024)

def compress_image(input_path, output_path=None, target_size_mb=1.0, quality_start=85):
    """
    Compress image to target size
    
    Args:
        input_path: Path to input image
        output_path: Path for output (default: adds _compressed to filename)
        target_size_mb: Target size in MB (default: 1.0 MB)
        quality_start: Starting quality (default: 85)
    
    Returns:
        Path to compressed image
    """
    input_path = Path(input_path)
    
    if not input_path.exists():
        raise FileNotFoundError(f"Image not found: {input_path}")
    
    # Default output path
    if output_path is None:
        output_path = input_path.parent / f"{input_path.stem}_compressed{input_path.suffix}"
    else:
        output_path = Path(output_path)
    
    print(f"Input: {input_path}")
    print(f"Original size: {get_file_size_mb(input_path):.2f} MB")
    print(f"Target: {target_size_mb:.2f} MB")
    print()
    
    # Open image
    img = Image.open(input_path)
    
    # Convert to RGB if necessary (for PNG with transparency)
    if img.mode in ('RGBA', 'LA', 'P'):
        # Create white background
        background = Image.new('RGB', img.size, (255, 255, 255))
        if img.mode == 'P':
            img = img.convert('RGBA')
        background.paste(img, mask=img.split()[-1] if img.mode in ('RGBA', 'LA') else None)
        img = background
    
    print(f"Image info:")
    print(f"  Format: {img.format}")
    print(f"  Size: {img.size[0]}x{img.size[1]} pixels")
    print(f"  Mode: {img.mode}")
    print()
    
    # Try different quality levels to hit target size
    quality = quality_start
    min_quality = 30
    
    while quality >= min_quality:
        # Save with current quality
        img.save(output_path, 'JPEG', quality=quality, optimize=True)
        
        current_size = get_file_size_mb(output_path)
        print(f"Quality {quality}: {current_size:.2f} MB", end="")
        
        if current_size <= target_size_mb:
            print(" ✓")
            break
        else:
            print(" (too large)")
            quality -= 5
    
    final_size = get_file_size_mb(output_path)
    reduction_pct = ((get_file_size_mb(input_path) - final_size) / get_file_size_mb(input_path)) * 100
    
    print()
    print("=" * 60)
    print("COMPRESSION COMPLETE")
    print("=" * 60)
    print(f"Output: {output_path}")
    print(f"Final size: {final_size:.2f} MB ({final_size * 1024:.0f} KB)")
    print(f"Quality: {quality}")
    print(f"Reduction: {reduction_pct:.1f}%")
    
    if final_size <= target_size_mb:
        print("✓ Image meets size requirement!")
    else:
        print("⚠ Warning: Could not compress to target size")
        print("  Consider:")
        print("  - Reducing image dimensions (resize)")
        print("  - Increasing target size limit")
    
    return str(output_path)

def main():
    import argparse
    
    parser = argparse.ArgumentParser(description="Compress images for MMS sending")
    parser.add_argument('input', help='Input image file')
    parser.add_argument('-o', '--output', help='Output file (default: adds _compressed)')
    parser.add_argument('-s', '--size', type=float, default=1.0, 
                       help='Target size in MB (default: 1.0)')
    parser.add_argument('-q', '--quality', type=int, default=85,
                       help='Starting quality 1-100 (default: 85)')
    
    args = parser.parse_args()
    
    try:
        output = compress_image(args.input, args.output, args.size, args.quality)
        print()
        print("Use this path in your config:")
        print(f'  "image_path": "{output.replace(chr(92), chr(92)*2)}"')
        return 0
    except Exception as e:
        print(f"Error: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())
