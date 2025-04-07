import os
import logging
import functions_framework
from constants import (
    gcs_bucket_name, 
    download_folder, 
)
from utils import *

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@functions_framework.http
def upload_to_gcs(request):
    """
    This function handles the process of downloading files from Google Drive, converting them to PDF if needed,
    uploading them to Google Cloud Storage, and appending metadata for each file.
    """
    request_json = request.get_json(silent=True)
    files = request_json["files"]
    storage_client = authenticate_storage()
    drive_service = authenticate_drive()
    # sheets_service = authenticate_sheets()

    for file in files:
        file_name = file["name"]
        file_id = file["id"]
        mime = file['mimeType']
        
        logger.info(f"Processing file: {file_name}")
        file_path = download_file_from_drive(drive_service, file_id, file_name, download_folder, mime)
        if file_path is not None:
            if file_path.endswith(".docx") or mime == 'application/vnd.google-apps.document':
                pdf_path = file_path.replace(".docx", ".pdf") if ".docx" in file_path else file_path + ".pdf"
                convert_docx_to_pdf(file_path, pdf_path)
                file_path = pdf_path
            elif file_path.endswith(".ppt") or file_path.endswith(".pptx"):
                pdf_path = file_path.replace(".pptx", ".pdf") if ".pptx" in file_path else file_path.replace(".ppt", ".pdf")
                convert_ppt_to_pdf(file_path, pdf_path)
                file_path = pdf_path

            if file_path.endswith(".pdf") and os.path.exists(file_path):
                source_file_path = upload_file_to_gcs(storage_client, gcs_bucket_name, file_path, file_path.split("/")[-1])
                if source_file_path is not None and file_path.endswith(".pdf"):
                    content = extract_content_from_pdf(file_path, file_path.split("/")[-1])
                    metadata = create_metadata(file_id, file_path.split("/")[-1][:-4], "application/pdf", content, file_path.split("/")[-1])
                    append_metadata_to_gcs(storage_client, metadata)

            if os.path.exists(file_path):
                os.remove(file_path)
            logger.info(f"File {file_name} has been removed from local storage.")

    return "File uploaded to gcs bucket"
