inkdrop.commands.add(document.body, 'editor:paste-as-link', () => {
  const { cm } = inkdrop.getActiveEditor()
  const selectionText = cm.getSelection()
  const clipboardText = env.clipboard.readText()
  cm.replaceSelection(`[${selectionText}](${clipboardText})`)
})

inkdrop.menu.add([
  {
    label: 'Edit',
    submenu: [
      {
        label: 'Paste as Link',
        command: 'editor:paste-as-link'
      }
    ]
  }
])
