import os
import shutil

from scripts.cadastre.utils.config import PATH


def remake_dir(dest):
    if os.path.exists(dest):
        shutil.rmtree(dest)
    os.mkdir(dest)


def clean_metadata_directories():

    remake_dir(PATH["contract_uri"])
    remake_dir(PATH["token_uri"])
    remake_dir(PATH["token_metadata"])


def main():
    clean_metadata_directories()
