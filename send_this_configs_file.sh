#!/bin/bash

# ==============================================================================
# Script to compress 'lr_configs' and transfer the directory to remote host
# Destination: 192.168.100.229:~/Desktop/
# ==============================================================================

# Exit on error
set -e

# Configuration
REMOTE_HOST="192.168.100.229"
REMOTE_USER="lr"
REMOTE_DEST="~/Desktop/"

# Get the directory where this script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR_NAME="$( basename "$SCRIPT_DIR" )"
ARCHIVE_NAME="${DIR_NAME}.tar.gz"

echo "------------------------------------------------------------"
echo "Target: $REMOTE_USER@$REMOTE_HOST"
echo "Source Path: $SCRIPT_DIR"
echo "Archive Name: $ARCHIVE_NAME"
echo "------------------------------------------------------------"

# 1. Compress the internal contents
echo "Step 1: Compressing internal contents into $ARCHIVE_NAME..."
# -c: create, -z: gzip, -v: verbose, -f: file
# --exclude: do not include the archive itself if it already exists
tar -czf "$SCRIPT_DIR/$ARCHIVE_NAME" -C "$SCRIPT_DIR" --exclude="$ARCHIVE_NAME" .

# 2. Verify rsync is installed
if ! command -v rsync &> /dev/null; then
    echo "Error: rsync is not installed. Please install it first."
    exit 1
fi

# 3. Transfer the directory using rsync
echo "Step 2: Starting transfer of '$DIR_NAME' (including archive)..."
rsync -avz --progress "$SCRIPT_DIR" "$REMOTE_USER@$REMOTE_HOST:$REMOTE_DEST"

echo "------------------------------------------------------------"
echo "Compression and transfer completed successfully!"
echo "Check $REMOTE_DEST$DIR_NAME/$ARCHIVE_NAME on the remote host."
echo "------------------------------------------------------------"
