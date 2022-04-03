function love.conf(t)
	t.releases = {
		title = 'DeeperDungeon',
		package = 'DeeperDungeon',
		loveVersion = '0.10.2',
		version = '0.0.1',
		author = 'Nick',
		email = 'AddiekinStudio@gmail.com',
		description = 'Multiplayer Action',
		homepage = 'https://addikinstudios.itch.io/spitballs',
		identifier = 'Inevitable Summoning',
		excludeFileList = { ''} ,
		compile = false,
		projectDirectory = './',
		releaseDirectory = '../dist',
	}
  t.title = "Deeper Dungeon"
  t.window.fullscreen = false         -- Enable fullscreen (boolean)
  t.window.fullscreentype = "exclusive" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)  
  t.window.width = 1024
  t.window.height = 768
  t.window.highdpi = false
  t.window.resizable = false
  t.externalstorage = true
end
