fish_add_path ~/.dotfiles/bin
set -gx EDITOR hx

function fish_greeting
    fastfetch
end

if status is-interactive
    # Commands to run in interactive sessions can go here
end
