function love.conf(t)
	t.releases = {
		title = 'spitballs',
		package = 'spitballs',
		loveVersion = '0.10.2',
		version = '0.0.1',
		author = 'Nick',
		email = 'AnorStudios@gmail.com',
		description = 'Tower Defense Platformer',
		homepage = 'https://anorstudios.itch.io/spitballs',
		identifier = 'spitballs',
		excludeFileList = { ''} ,
		compile = false,
		projectDirectory = './',
		releaseDirectory = '../dist',
	}
  t.title = "Spitballs"
  t.window.width = 1024
  t.window.height = 768
  t.window.highdpi = true
  t.window.resizable = true
  t.externalstorage = true
end

