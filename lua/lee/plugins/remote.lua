return {
	"nosduco/remote-sshfs.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim"
	},
	opts = {
		connections = {
			ssh_configs = {
				vim.fn.expand("$HOME") .. "/.ssh/config"
			},
			ssh_known_hosts = vim.fn.expand("$HOME") .. "/.ssh/known_hosts",
			sshfs_args = { -- arguments to pass to the sshfs command
				"-o reconnect",
				"-o ConnectTimeout=5",
			},
		},
		mounts = {
			base_dir = vim.fn.expand("$HOME") .. "/.local/share/nvim/sshfs",
			unmount_on_exit = true
		},
		handlers = {
			on_connect = {
				change_dir = true,  -- When connected change vim work dir
			},
			on_disconnect = {
				clean_mount_folders = true,
			},
		},
		log = {
			enabled = true,
			truncate = false,
			types = {
				all = true,
			}
		}
	}
}
