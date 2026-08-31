if [[ "$OSTYPE" == darwin* ]]; then
  export NOTES_DIR=~/DriveWorkNotes/
  export PNOTES_DIR=~/Dropbox/Notes/

  note() {
    $EDITOR "$NOTES_DIR/$(date +%Y%m%d)_$*.txt"
  }
  note_ls() {
    ls -c "$NOTES_DIR" | grep "$*"
  }
  note_cd() {
    cd "$NOTES_DIR"
  }

  pnote() {
    $EDITOR "$PNOTES_DIR/$(date +%Y%m%d)_$*.txt"
  }
  pnote_ls() {
    ls -c "$PNOTES_DIR" | grep "$*"
  }
  pnote_cd() {
    cd "$PNOTES_DIR"
  }
else
  # On Arch Linux, note points to Dropbox/Notes (same as pnote on Mac)
  export NOTES_DIR=~/Dropbox/Notes/
  export PNOTES_DIR=~/Dropbox/Notes/

  note() {
    $EDITOR "$NOTES_DIR/$(date +%Y%m%d)_$*.txt"
  }
  note_ls() {
    ls -c "$NOTES_DIR" | grep "$*"
  }
  note_cd() {
    cd "$NOTES_DIR"
  }

  pnote() {
    note "$@"
  }
  pnote_ls() {
    note_ls "$@"
  }
  pnote_cd() {
    note_cd
  }
fi
