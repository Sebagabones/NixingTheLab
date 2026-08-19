#!/usr/bin/env python3
import concurrent.futures
import re
from pathlib import Path
from sys import argv

import fontforge


def save_file(filepath, font):
    font.generate(filepath)
    return filepath


def combine_font(path_i, end_location, b_type, new_name="Berkeley_Mono"):
    type = re.search("BerkeleyMono-(.*).ttf", str(b_type))

    if type is not None:
        old_type = type.group(1)
        if old_type == "Bold-Oblique":
            type = "BoldItalic"
        elif old_type == "Oblique":
            type = "Italic"
        else:
            type = old_type
    else:
        return
    i_type = str(path_i) + f"/IoskeleyMonoTermNerdFont-{type}.ttf"
    amb = fontforge.open(f"{b_type}")
    amb.mergeFonts(f"{i_type}")
    # amb.fontname = f"{new_name}"
    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        future_to_save = {
            executor.submit(
                save_file,
                f"{end_location}-{old_type}.{extension_type}",
                amb,
            ): extension_type
            for extension_type in ["ttf", "otf", "woff2"]
        }
        for future in concurrent.futures.as_completed(future_to_save):
            file = future.result()
            # print(f"done {file}")

    return f"CustomBerkeleyMono-{type}"


# Takes three arguments, dir of berkely mono, dir of IoskeleyMono and the output dir
def main():
    listOfFiles = []
    path_b: Path = Path(argv[1])

    for item in path_b.iterdir():
        if str(item).endswith(".ttf"):
            listOfFiles.append(str(item))
    with concurrent.futures.ProcessPoolExecutor() as executor:
        future_to = {
            executor.submit(combine_font, Path(argv[2]), str(argv[3]), type_b): type_b
            for type_b in listOfFiles
        }
        for future in concurrent.futures.as_completed(future_to):
            print(future.result())


if __name__ == "__main__":
    main()
