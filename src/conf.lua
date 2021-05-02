function love.conf(t)
	t.releases = {
		title = 'DeeperDungeon',
		package = 'DeeperDungeon',
		loveVersion = '0.10.2',
		version = '0.0.1',
		author = 'Nick',
		email = 'AnorStudios@gmail.com',
		description = 'Multiplayer Action',
		homepage = 'https://anorstudios.itch.io/spitballs',
		identifier = 'spitballs',
		excludeFileList = { ''} ,
		compile = false,
		projectDirectory = './',
		releaseDirectory = '../dist',
	}
  t.title = "Deeper Dungeon"
  t.window.width = 1024
  t.window.height = 768
  t.window.highdpi = true
  t.window.resizable = true
  t.externalstorage = true
end
