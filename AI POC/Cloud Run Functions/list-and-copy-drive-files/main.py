import functions_framework
from constants import folder_id, batch_size
import logging
from utils import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@functions_framework.http
def upload_drive_files_to_gcs(request):
    """Fetches files from a Google Drive folder, batches them, and enqueues tasks for GCS upload."""

    # Authenticate APIs
    drive_service = authenticate_drive()

    # List files in the folder
    try:
        files = list_files_in_drive_folder(drive_service, folder_id)
        logger.info(f"Total number of files {len(files)}")
        logger.info(files)
    except Exception as e:
        logger.error(f"Exception : {e}")
        return "Failed accessing drive files\n"

    if not files:
        return "No files found in the folder."

    batched_files = batch_files(files, batch_size)

    for files_list in batched_files:
        enqueue_task(files_list)
        logger.info(f"File batch transfer to queue")

    return "Files successfully added to queue"