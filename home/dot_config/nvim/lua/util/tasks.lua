local M = {}

--- Iterate over all tasks and run an action on each one
--- @param actionName string
function M.run_on_every_task(actionName)
  local status, overseer = pcall(require, 'overseer')
  if not status then
    return
  end

  local tasks = overseer.list_tasks({ unique = false })
  for _, task in ipairs(tasks) do
    overseer.run_action(task, actionName)
  end
end

--- Dispose all tasks
function M.dispose_all_tasks()
  M.run_on_every_task('dispose')
end

--- Stop all tasks
function M.stop_all_tasks()
  M.run_on_every_task('stop')
end

return M
