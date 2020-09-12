"""Ansible playbook tools"""

from collections import OrderedDict
import os.path
import sys
import yaml


def get_tags_from_playbook(playbook_file):
    """Get available tags from Ansible playbook"""
    tags = []
    playbook_path = os.path.dirname(playbook_file)
    with open(playbook_file) as playbook_fp:
        playbook = yaml.safe_load(playbook_fp)
        for item in playbook:
            if "import_playbook" in item:
                import_playbook = os.path.join(playbook_path, item["import_playbook"])
                imported_tags = get_tags_from_playbook(import_playbook)
                tags.extend(imported_tags)
            elif "tags" in item:
                if isinstance(item["tags"], (list,)):
                    tags.extend(item["tags"])
                else:
                    tags.append(item["tags"])
            else:
                print(item)

    # Remove duplicates while maintaining order
    tags = list(OrderedDict.fromkeys(tags))

    if tags.count("always") > 0:
        tags.remove("always")

    if len(tags) == 0:
        sys.stderr.write("%s has no tags\n" % playbook_file)

    return tags
