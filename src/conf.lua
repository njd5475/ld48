function love.conf(t)
	t.releases = {
		title = 'Demon\'s Call: Inevitable Summoning',
		package = 'demons-call-inevitable-summoning',
		loveVersion = '0.10.2',
		version = '0.0.1',
		author = 'Nick',
		description = 'Try to slow the summoning of a demon by hordes of minions while unlocking personal power. To see if you can survive the monster that awaits you.',
		email = 'AddiekinStudio@gmail.com',
		identifier = 'demons-call-inevitable-summoning',
		homepage = 'https://addikinstudios.itch.io/demons-call-inevitable-summoning',
		excludeFileList = { ''} ,
		compile = false,
		projectDirectory = './',
		releaseDirectory = '../dist',
	}
  t.title = "Demon\'s Call: Inevitable Summoning"
  t.window.fullscreen = false         -- Enable fullscreen (boolean)
  t.window.fullscreentype = "exclusive" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)  
  t.window.width = 1024
  t.window.height = 768
  t.window.highdpi = false
  t.window.resizable = false
  t.externalstorage = true
end
