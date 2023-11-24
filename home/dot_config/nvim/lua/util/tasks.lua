local M = {}

function M.dispose_all_tasks()
  local status, overseer = pcall(require, 'overseer')
  if not status then
    return
  end

  local tasks = overseer.list_tasks({ unique = false })
  for _, task in ipairs(tasks) do
    overseer.run_action(task, 'dispose')
  end
end

return M
