#!/bin/sh

if ls ~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2/*[Dd][Aa][Tt][Aa]*/HEROES2.AGG 2> /dev/null ;
then
  /app/bin/fheroes2
else
  ans=$(zenity --list \
    --text "To play <a href='https://ihhub.github.io/fheroes2/'><b>fheroes2</b></a> you will need assets from the original game or <a href='https://www.gog.com/de/game/heroes_of_might_and_magic_2_gold_edition'>GOG</a>.\nAlternatively, the <a href='https://archive.org/details/HeroesofMightandMagicIITheSuccessionWars_1020'>demo</a> (only one scenario, no campaign and limited assets) can be installed." \
    --title "Complete installation of fheroes2" \
    --column "What to do?" \
      'Manual install    (HoMM2 files needed)' \
      'Install GOG version    (installer-EXE needed)' \
      'Install demo'
  2> /dev/null)

  if [[ $ans == *"GOG"* ]]; then
    file=$(zenity --file-selection --title="Select installer from GOG (*.EXE)")
    innoextract --gog --output-dir ~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2 \
      --include DATA \
      --include GAMES \
      --include MAPS \
      --include MUSIC \
      --include SOUND \
      $file
    if [[ $? -ne 0 ]]; then
      zenity --error --text "Extraction failed!"
      exit 1
    fi
    /app/bin/fheroes2
  fi
  if [[ $ans == *"demo"* ]]; then
    unzip -o -q /app/extra/h2demo.zip "DATA/*" "MAPS/*" -d ~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2
    /app/bin/fheroes2
  fi
  if [[ $ans == *"Manual"* ]]; then
    zenity --info \
      --text "You will need to copy the 'ANIM', 'DATA', 'MAPS' and 'MUSIC' folders from Heroes II to the fheroes2 folder.\n\nFor example:\n~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2/ANIM\n~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2/DATA\n~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2/MAPS\n~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2/MUSIC"
    mkdir -p ~/.var/app/io.github.ihhub.Fheroes2/data/fheroes2
    dbus-send --session --print-reply --dest=org.freedesktop.FileManager1 \
      --type=method_call /org/freedesktop/FileManager1 org.freedesktop.FileManager1.ShowFolders \
        array:string:"file://$HOME/.var/app/io.github.ihhub.Fheroes2/data/fheroes2" string:""
  fi
fi
