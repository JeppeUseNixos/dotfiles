{
config,
pkgs,
...
}: let
	old-treesitter = (pkgs.vimPlugins.nvim-treesitter.withPlugins (p: [
		p.nix
		p.lua
		p.go
		p.vim
		p.markdown
		p.sql
		p.zig
	])).overrideAttrs (old: {
			src = pkgs.fetchFromGitHub {
				owner = "nvim-treesitter";
				repo = "nvim-treesitter";
				rev = "e527584cf8508b2f99f127c2a20f93237e8fcf83";
				hash = "sha256-kPB4KyhE0+mNfanTIzc4O+4wvw/u8lyHTHoQ368KWXI=";
			};
		});
in{
  home.username = "z3co";
  home.homeDirectory = "/home/z3co";
  home.stateVersion = "25.11";
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.caskaydia-cove
    zoxide
    nixfmt
    fzf
		nix-prefetch-git
		gimp
  ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
		extraPackages = with pkgs; [
			wl-clipboard
			gcc
			fd
			gnumake
			nodejs
			tree-sitter
			ripgrep
			lua5_1
			luarocks
			nixd
			lua-language-server
			tinymist
			nixfmt
		];
		plugins = with pkgs.vimPlugins; [
			catppuccin-nvim
			old-treesitter
			nvim-lspconfig
			plenary-nvim
			telescope-fzf-native-nvim
			nvim-cmp
			cmp-nvim-lsp
		];
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "Jeppe Wolff Johansen";
      user.email = "JeppeUseNixos@proton.me";
      init.defaultBranch = "main";
			commit.gpgsign = true;
			gpg.format = "openpgp";
			user.signingkey = "A0CC64616A31B7C7";
    };
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lA --color";
      cd = "z";
    };
    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      path = "/home/z3co/.hist";
      saveNoDups = true;
      save = 10000;
      size = 10000;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "zoxide" "fzf" ];
    };
    plugins = [
      {
	name = "fzf-tab";
	src = pkgs.zsh-fzf-tab;
	file = "share/fzf-tab/fzf-tab.plugin.zsh";
      }
    ];
  };
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    configFile = ./config/ohmyposh/base.toml;
  };
  home.file."Backgrounds".source = ./config/backgrounds;
  home.file.".config/waybar".source = ./config/waybar;
	xdg.configFile."alacritty".source = config.lib.file.mkOutOfStoreSymlink "/home/z3co/dotfiles/config/alacritty";
	xdg.configFile."niri".source = config.lib.file.mkOutOfStoreSymlink "/home/z3co/dotfiles/config/niri";
	xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/z3co/dotfiles/config/nvim";
	xdg.configFile."swaylock".source = config.lib.file.mkOutOfStoreSymlink "/home/z3co/dotfiles/config/swaylock";
}
