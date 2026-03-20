#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
shopt -s dotglob nullglob

should_skip() {
	local item="$1"
	[[ "$item" == "." || "$item" == ".." || "$item" == ".git" || "$item" == "install.sh" ]]
}

link_path() {
	local src="$1"
	local dest="$2"
	local backup_dest

	mkdir -p "$(dirname "$dest")"

	if [ -L "$dest" ]; then
		if [ "$(readlink -f "$dest")" = "$(readlink -f "$src")" ]; then
			echo "Skipping $dest (already linked to $src)"
			return
		fi
	fi

	if [ -e "$dest" ] || [ -L "$dest" ]; then
		backup_dest="${dest}.backup.$(date +%Y%m%d%H%M%S).$$"
		echo "Backing up $dest -> $backup_dest"
		mv "$dest" "$backup_dest"
	fi

	echo "Linking $dest -> $src"
	ln -s "$src" "$dest"
}

link_entry() {
	local src="$1"
	local dest="$2"
	local item

	if [ -d "$src" ] && [ ! -L "$src" ]; then
		mkdir -p "$dest"
		for child in "$src"/*; do
			item="$(basename "$child")"
			should_skip "$item" && continue
			link_entry "$child" "$dest/$item"
		done
		return
	fi

	link_path "$src" "$dest"
}

echo "Installing dotfiles..."

for src in "$DOTFILES_DIR"/*; do
	item="$(basename "$src")"
	should_skip "$item" && continue
	dest="$HOME/$item"
	link_entry "$src" "$dest"
done
