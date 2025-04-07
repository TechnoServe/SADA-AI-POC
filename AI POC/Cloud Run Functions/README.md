# TechnoServe AI POC

This Proof of Concept (POC) leverages **Google Cloud Platform** services to process and move documents from **Google Drive** to **Google Cloud Storage (GCS)**. It also generates metadata for each document uploaded. The flow is composed of three components:

## Components

1. **Cloud Run Function - `list-and-copy-drive-files`**  
   Lists documents from Google Drive, batches them, and sends each batch to a Cloud Tasks queue.

2. **Cloud Tasks Queue - `kb-ingestor-queue`**  
   Holds tasks and triggers the Cloud Function to process each batch.

3. **Cloud Run Function - `upload-to-gcs`**  
   Processes each batch of documents, downloads them from Google Drive, uploads them to GCS, and generates metadata (`metadata.jsonl`).

---

## Architecture Overview

### 1. Cloud Run Function: `list-and-copy-drive-files`

- Lists documents from a specified Google Drive folder.
- Batches the files and sends each batch as a task to a Cloud Tasks queue.

### 2. Cloud Tasks Queue: `kb-ingestor-queue`

- Holds and schedules tasks for the file upload function.
- Triggers the `upload-to-gcs` Cloud Function with each batch.

### 3. Cloud Run Function: `upload-to-gcs`

- Triggered by Cloud Tasks.
- Downloads documents from Google Drive.
- Uploads them to the specified GCS bucket.
- Generates metadata (`metadata.jsonl`) for the uploaded files.

---

## Configurations

### `list-and-copy-drive-files/constants.py`

```python
folder_id = '<<drive Folder ID>>'  # Google Drive folder ID
batch_size = 5                     # Batch size for task queue
function_url = "<<upload-to-gcs cloud function url>>"
project_id = "<<project ID>>"
queue_name = "kb-ingestor-queue"
queue_location = "<<cloud task location>>"
service_account_email = "<<service account name>>"
