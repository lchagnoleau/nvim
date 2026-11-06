-- Open Diffview from Lazygit (running inside Neovim via Snacks.lazygit / <leader>gg).
--
-- Lazygit custom commands (see ~/.config/lazygit/config.yml) call back into this
-- Neovim instance through its RPC socket ($NVIM is set in every :terminal), e.g.:
--   nvim --server "$NVIM" --remote-expr "v:lua.require'config.lazygit_diffview'.open('commit', 'abc123', '', '/repo')"
-- so no `neovim-remote` (nvr) dependency is needed.

local M = {}

-- "<sha>^" fails for a root commit: fall back to Diffview's null-tree sentinel
-- (it is special-cased by Diffview, git's real empty-tree sha shows no files).
local function parent_of(repo, sha)
  vim.fn.system({ "git", "-C", repo, "rev-parse", "--verify", "--quiet", sha .. "^" })
  return vim.v.shell_error == 0 and (sha .. "^") or require("diffview.vcs.adapters.git.rev").GitRev.NULL_TREE_SHA
end

local function close_diffviews()
  local ok, lib = pcall(require, "diffview.lib")
  if not ok then
    return
  end
  for _, view in ipairs({ unpack(lib.views) }) do
    pcall(function()
      view:close()
      lib.dispose_view(view)
    end)
  end
end

---@param kind "file"|"commit"|"commit_file"|"branch"
---@param param string  path (file / commit_file), "<from>..<to>" or sha (commit), branch name (branch)
---@param sha? string   commit sha, for kind == "commit_file"
---@param repo? string  repository root (lazygit's $PWD)
function M.open(kind, param, sha, repo)
  -- Return to the RPC caller right away, do the work afterwards.
  vim.schedule(function()
    -- Leave terminal mode (lazygit float), then wait for the mode change.
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", false)

    vim.defer_fn(function()
      local ok, err = pcall(function()
        repo = (repo and repo ~= "") and repo or vim.fn.getcwd()
        close_diffviews()

        -- -C makes Diffview resolve the repo and paths from lazygit's repo root,
        -- without touching Neovim's cwd.
        local args = { "-C" .. vim.fn.fnameescape(repo) }

        if kind == "file" then
          vim.list_extend(args, { "--", vim.fn.fnameescape(param) })
        elseif kind == "commit" then
          -- param is "<from>..<to>" (range selection) or a single sha
          local from, to = param:match("^(.-)%.%.(.+)$")
          from, to = from or param, to or param
          table.insert(args, parent_of(repo, from) .. ".." .. to)
        elseif kind == "commit_file" then
          assert(sha and sha ~= "", "missing commit SHA for file diff")
          vim.list_extend(args, { parent_of(repo, sha) .. ".." .. sha, "--", vim.fn.fnameescape(param) })
        elseif kind == "branch" then
          table.insert(args, param)
        else
          error("unknown kind: " .. tostring(kind))
        end

        vim.cmd("DiffviewOpen " .. table.concat(args, " "))
      end)

      if not ok then
        vim.notify("Lazygit → Diffview: " .. tostring(err), vim.log.levels.ERROR)
      end
    end, 100)
  end)
end

return M
