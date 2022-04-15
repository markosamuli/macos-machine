"""Local settings"""

from typing import Union, Dict
from ruamel.yaml import YAML

SETTINGS_FILE = "machine.yaml"
TRUTHY = ["true", "enable"]
FALSY = ["false", "disable"]


def load_settings() -> Dict:
    """Load settings from the local configuration file"""
    yml = YAML(typ="rt")
    yml.explicit_start = True
    yml.indent(sequence=4, offset=2)
    settings_file = SETTINGS_FILE
    with open(settings_file, "r", encoding="UTF-8") as settings_fp:
        data = yml.load(settings_fp)
    return data


def update_settings(settings: Dict) -> Dict:
    """Updates settings in the local configuration file"""
    yml = YAML(typ="rt")
    yml.explicit_start = True
    yml.indent(sequence=4, offset=2)
    settings_file = SETTINGS_FILE
    with open(settings_file, "r", encoding="UTF-8") as settings_fp:
        yml.load(settings_fp)
    with open(settings_file, "w", encoding="UTF-8") as settings_fp:
        yml.dump(settings, settings_fp)


def get_option(name: str) -> Union[str, bool, int]:
    """Get option value from the local configuration file"""
    settings = load_settings()
    try:
        return settings[name]
    except KeyError:
        return None


def set_option(name: str, value: Union[str, bool, int]) -> Union[str, bool, int]:
    """Set option value in the local configuration file"""
    settings = load_settings()
    settings[name] = value
    update_settings(settings)
    return settings[name]


def enable_option(name: str) -> bool:
    """Enable option in the local configuration file"""
    return set_option(name, True)


def disable_option(name: str) -> bool:
    """Disable option in the local configuration file"""
    return set_option(name, False)
