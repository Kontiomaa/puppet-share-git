class puppet-share-git {
	package {"git":
		ensure => "latest"
	}

	user {"kontsutest1":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
        }

	user {"kontsutest2":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
                groups => ["kontsutest1"],
                require => User["kontsutest1"],
        }

        user {"kontsutest3":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
                groups => ["kontsutest1"],
                require => User["kontsutest1"],
        }

	file {"/home/kontsutest1/sharedGitFolder.git":
                ensure => "directory",
                group => "kontsutest1",
                mode => "770",
                require => User["kontsutest1"],
        }

	file {'/home/kontsutest1/sharedGitFolder.git/script.sh':
		content => template('puppet-share-git/initgit.erb'),
		mode => 770,
		require => User["kontsutest1"], 
	}

	exec {"initgit":
		command => "/home/kontsutest1/sharedGitFolder.git/script.sh",
		require => File["/home/kontsutest1/sharedGitFolder.git/script.sh"],
	}
}
