function love.conf(t)
	t.releases = {
		title = 'manticle',
		package = 'manticle',
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
  t.title = "Manticle"
  t.window.width = 800
  t.window.height = 600
  t.window.highdpi = true
  t.window.resizable = true
  t.externalstorage = true
end
