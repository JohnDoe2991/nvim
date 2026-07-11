local M = {}

local agents = {
  { command = 'copilot_start', name = 'Copilot' },
  { command = 'codex', name = 'Codex' },
}

local function find_terminal_buf(command)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == 'terminal' then
      local name = vim.api.nvim_buf_get_name(buf)
      if name:match(vim.pesc(command)) then
        return buf
      end
    end
  end
end

local function open_or_focus_agent(agent)
  local buf = find_terminal_buf(agent.command)
  if buf then
    vim.api.nvim_set_current_buf(buf)
    vim.cmd 'startinsert'
    return
  end

  vim.cmd.terminal(agent.command)
  vim.cmd 'startinsert'
end

local function open_available_agent()
  for _, agent in ipairs(agents) do
    if vim.fn.executable(agent.command) == 1 then
      open_or_focus_agent(agent)
      return
    end
  end

  vim.notify('Kein AI-Agent verfügbar.', vim.log.levels.WARN, { title = 'AI Agent' })
end

local function flash_linewise_yank(start_line, end_line)
  local ns = vim.api.nvim_create_namespace 'custom-copy-yank-highlight'
  for line = start_line - 1, end_line - 1 do
    vim.api.nvim_buf_add_highlight(0, ns, 'IncSearch', line, 0, -1)
  end
  vim.defer_fn(function()
    pcall(vim.api.nvim_buf_clear_namespace, 0, ns, 0, -1)
  end, 160)
end

local function clean_linewise_selection_to_clipboard()
  local mode = vim.fn.mode()
  local start_line
  local end_line

  if mode == 'v' or mode == 'V' or mode == '\22' then
    start_line = vim.fn.getpos 'v'[2]
    end_line = vim.fn.getpos '.'[2]
  else
    start_line = vim.fn.getpos "'<"[2]
    end_line = vim.fn.getpos "'>"[2]
  end

  if start_line == 0 or end_line == 0 then
    return
  end
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('%s*┃%s*$', '')
  end
  local cleaned = table.concat(lines, '\n') .. '\n'
  vim.fn.setreg('+', cleaned, 'V')
  vim.fn.setreg('"', cleaned, 'V')
  flash_linewise_yank(start_line, end_line)
end

function M.setup()
  vim.keymap.set('n', '<leader>cp', open_available_agent, { desc = 'Open available AI agent' })
  vim.keymap.set('x', '<leader>cy', clean_linewise_selection_to_clipboard, { desc = 'Copy visual selection without TUI scrollbar' })
  vim.api.nvim_create_user_command('AiAgent', open_available_agent, { desc = 'Open available AI agent' })
end

return M
