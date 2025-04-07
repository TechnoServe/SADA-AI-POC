from googleapiclient.discovery import build
from google.cloud import storage,tasks_v2
from google.auth import default
from googleapiclient.errors import HttpError
from constants import function_url,project_id,queue_location,queue_name,service_account_email
import logging
import json

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def authenticate_drive():
    """Authenticates and returns a Google Drive service client."""
    
    credentials, project = default(scopes=["https://www.googleapis.com/auth/drive"])
    drive_service = build("drive", "v3", credentials=credentials)
    return drive_service


def list_files_in_drive_folder(drive_service, folder_id):
    """Recursively lists all files in a Google Drive folder, including subfolders."""

    all_files = []

    try:

        query = f"'{folder_id}' in parents and trashed = false"
        results = drive_service.files().list(q=query).execute()
        files = results.get("files", [])

        for file in files:
            file_id = file.get("id")
            mime_type = file.get("mimeType")
            
            if mime_type == 'application/vnd.google-apps.folder':
                logger.info(f"Folder: {file.get('name')}, files ")
                subfolder_files = list_files_in_drive_folder(drive_service, file_id)
                all_files.extend(subfolder_files)
            else:

                all_files.append(file)
        
        # Handle pagination if there are more than 1000 files in the folder
        while 'nextPageToken' in results:
            page_token = results['nextPageToken']
            results = drive_service.files().list(q=query, pageToken=page_token).execute()
            files = results.get("files", [])
            for file in files:
                file_id = file.get("id")
                mime_type = file.get("mimeType")
                if mime_type == 'application/vnd.google-apps.folder':
                    logger.info(f"Found folder: {file.get('name')}, listing files inside...")
                    subfolder_files = list_files_in_drive_folder(drive_service, file_id)
                    all_files.extend(subfolder_files)
                else:
                    all_files.append(file)

    except HttpError as error:
        logger.error(f"An error occurred: {error}")
    
    return all_files

def batch_files(files, batch_size):
    """Yield batches of files with a given batch size."""
    for i in range(0, len(files), batch_size):
        yield files[i:i + batch_size]


def enqueue_task(files_list):
    """Enqueues a batch of files as a task in Cloud Tasks for asynchronous processing."""
    
    client = tasks_v2.CloudTasksClient()
    parent = client.queue_path(project_id, queue_location, queue_name)

    payload = {
        "files": files_list
    }
    task = tasks_v2.Task(
        http_request=tasks_v2.HttpRequest(
            http_method=tasks_v2.HttpMethod.POST,
            headers={"Content-Type": "application/json"},
            url=function_url,
            oidc_token=tasks_v2.OidcToken(
                service_account_email=service_account_email,
                audience=function_url,
            ),
            body=json.dumps(payload).encode('utf-8'),
        ),
    )
    client.create_task(tasks_v2.CreateTaskRequest(parent=parent, task=task))
    logger.info(f"Task enqueued for {files_list}")
