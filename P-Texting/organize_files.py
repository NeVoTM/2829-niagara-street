#!/usr/bin/env python3
"""
Organize P-Texting directory into subfolders
"""
import os
import shutil
from pathlib import Path

# Define folder structure
folders = {
    'databases': [
        'progress_shared.db',  # ACTIVE - keep in main
        'progress_chrome.db',
        'progress_edge.db', 
        'progress_firefox.db',
        'progress.db',
        'progress_chrome_backup_20251123_214006.db'
    ],
    'configs': [
        'config.json',  # ACTIVE - keep in main
        'config_chrome.json',  # ACTIVE - keep in main
        'config_edge.json',
        'config_firefox.json',
        'config_avast.json',
        'config_brave.json',
        'config_opera.json',
        'config_vivaldi.json'
    ],
    'browser_launchers': [
        'start_chrome_debug.bat',  # ACTIVE - keep in main
        'start_edge_debug.bat',
        'start_firefox_debug.bat',
        'start_avast_debug.bat',
        'start_brave_debug.bat',
        'start_opera_debug.bat',
        'start_vivaldi_debug.bat',
        'setup_firefox_debugging.bat',
        'run_ptexting_firefox.bat',
        'create_edge_shortcut.ps1',
        'create_shortcuts.ps1',
        'enable_firefox_debugging.ps1',
        'enable_firefox_debugging_simple.ps1'
    ],
    'main_programs': [
        'p_texting_gui.py',  # ACTIVE - keep in main
        'send_texts_date_filter.py',  # ACTIVE - keep in main
        'generate_report.py',  # ACTIVE - keep in main
        'export_database_to_csv.py',
        'landline_checker.py'
    ],
    'browser_specific': [
        'p_texting_chrome.py',
        'p_texting_edge.py',
        'p_texting_firefox.py',
        'p_texting_avast.py',
        'p_texting_brave.py',
        'p_texting_opera.py',
        'p_texting_vivaldi.py',
        'send_texts_date_filter_firefox.py',
        'send_texts_date_filter_avast.py',
        'send_texts_date_filter_brave.py',
        'send_texts_date_filter_opera.py',
        'send_texts_date_filter_vivaldi.py'
    ],
    'utilities': [
        'import_test_records.py',  # ACTIVE - keep in main
        'merge_chrome_edge_results.py',
        'migrate_to_shared_db.py',
        'reset_shared_db.py',
        'reset_and_import.py',
        'import_from_csv_export.py',
        'check_all_dbs.py',
        'check_db_schema.py',
        'check_landlines.py',
        'check_send_order.py',
        'open_google_voice.py'
    ],
    'data': [
        'database_export_20251123_222640.csv',
        'test_numbers_with_dates.csv'  # ACTIVE - keep in main
    ],
    'documentation': [
        'README.md',  # ACTIVE - keep in main
        'QUICK_START.md',
        'BROWSER_SETUP_HANDOFF.md',
        'BROWSER_PROGRAMS_SUMMARY.md',
        'CHANGES_NOV23_2025.md',
        'ENHANCEMENTS_STATUS.md',
        'FIREFOX_SETUP.md',
        'GOOGLE_VOICE_LIMITS.md',
        'HUMANIZATION_GUIDE.md',
        'IMPLEMENTATION_SUMMARY.md',
        'LANDLINE_DETECTION.md',
        'QUICK_START_SEPARATE.md',
        'README_SEPARATE_VERSIONS.md',
        'SESSION_HANDOFF_2025-11-20.md',
        'SESSION_HANDOFF_2025-11-21.md',
        'STATUS_2025-11-19.md',
        'STATUS_AND_SUMMARY.md'
    ],
    'junk': [
        'send_texts.py',
        'send_texts_backup.py',
        'send_texts_date_filter_backup_nov21.py',
        'send_texts_with_nudging_backup.py',
        'send_attach.py',
        'send_fixed.py',
        'send_hybrid.py',
        'send_undetected.py',
        'send_with_recording.py',
        'debug_browser.py',
        'debug_send_one.py',
        'diagnose_send_button.py',
        'manual_test.py',
        'test_humanization.py',
        'web_gui.py',
        'reset_db.py',
        'reset_failed_to_pending.py',
        'analyze_chrome_edge_overlap.py',
        'check_chrome_attempts.py',
        'check_chrome_errors.py'
    ]
}

# Files to KEEP in main directory
keep_in_main = [
    'p_texting_gui.py',
    'send_texts_date_filter.py',
    'generate_report.py',
    'import_test_records.py',
    'test_numbers_with_dates.csv',
    'progress_shared.db',
    'config.json',
    'config_chrome.json',
    'start_chrome_debug.bat',
    'README.md',
    'organize_files.py'
]

def organize():
    """Organize files into subfolders"""
    base_path = Path.cwd()
    
    print("Creating folder structure...")
    for folder in folders.keys():
        folder_path = base_path / folder
        folder_path.mkdir(exist_ok=True)
        print(f"  ✓ Created: {folder}/")
    
    print("\nMoving files...")
    moved_count = 0
    skipped_count = 0
    
    for folder, files in folders.items():
        for filename in files:
            if filename in keep_in_main:
                print(f"  ⊗ Keeping in main: {filename}")
                skipped_count += 1
                continue
                
            src = base_path / filename
            dst = base_path / folder / filename
            
            if src.exists():
                if dst.exists():
                    print(f"  ⚠ Already exists: {folder}/{filename}")
                else:
                    shutil.move(str(src), str(dst))
                    print(f"  ✓ Moved: {filename} → {folder}/")
                    moved_count += 1
            else:
                print(f"  ⊗ Not found: {filename}")
    
    print(f"\n{'='*60}")
    print(f"✅ Organization complete!")
    print(f"  Moved: {moved_count} files")
    print(f"  Kept in main: {skipped_count} files")
    print(f"\nMain directory now contains only active files:")
    for f in keep_in_main:
        if (base_path / f).exists():
            print(f"  • {f}")

if __name__ == '__main__':
    organize()
