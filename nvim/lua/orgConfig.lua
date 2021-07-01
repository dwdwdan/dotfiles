require('orgmode').setup{
	org_agenda_files = '~/org/*',
	org_default_notes_file = '~/org/refile.org',
	org_todo_keywords = {'TODO', '|', 'DONE', 'CANCELLED', 'CHECKED'},
	org_agenda_templates = {
		t = {
			description = 'Task',
			template = '* TODO %?\n  %U',
			target = '~/org/todo.org'
		},
		r = {
			description = 'Reference',
			template = '* %?\n',
			target = '~/org/reference.org'
		}
	}
}
