class puppet-share-git ($repo="kontsutestrepo") {
	package {"git":
		ensure => "latest"
	}

	user {"$repo":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
        }

	user {"kontsutest2":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
		password => '$6$RUyDZoIS$HO7pDXTn5.JqZqluk.6uujzMohQep/QpeqIEslo5XhL44P8C9hwyqeJk0MRfzcmZlCvuVqkOYFSxwsUUvvMo.1',
                groups => ["$repo"],
                require => User["$repo"],
        }

        user {"kontsutest3":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
		password => '$6$NriBfv/A$rzalsJ5pSqClDr1PBAQF0gzNstGcxn60yEkKw2tLiu4tqcd/G7j992XXe58GgYrIuOQHX9eO4bsNhsy2p42pq.',
                groups => ["$repo"],
                require => User["$repo"],
        }

	file {"/home/$repo/sharedGitFolder.git":
                ensure => "directory",
		owner => "$repo",
                group => "$repo",
                mode => "2775",
                require => User["$repo"],
        }

	file {"/home/kontsutest2/projects":
                ensure => "directory",
		owner => "kontsutest2",
		mode => "775",
                require => User["kontsutest2"],
        }

	file {"/home/kontsutest3/projects":
                ensure => "directory",
		owner => "kontsutest3",
		mode => "775",
                require => User["kontsutest3"],
        }

	exec {"initgit":
		command => "/usr/bin/git init --bare --shared",
		user => "$repo",
		cwd => "/home/$repo/sharedGitFolder.git/",
		require => File["/home/$repo/sharedGitFolder.git/"],
	}

	exec {"lockuser1":
                command => "/usr/sbin/usermod --lock $repo",
                require => User["$repo"],
        }

	exec {"folderowngroup":
                command => "/bin/chown $repo.$repo /home/$repo/sharedGitFolder.git/*",
                require => Exec["initgit"],
        }

	exec {"clone1":
		command => "/usr/bin/git clone /home/$repo/sharedGitFolder.git/",
		user => "kontsutest2",
		cwd => "/home/kontsutest2/projects/",
		creates => "/home/kontsutest2/projects/sharedGitFolder/.git/",
		require => [User["kontsutest2"], Exec["initgit"]],
	}

	exec {"clone2":
		command => "/usr/bin/git clone /home/$repo/sharedGitFolder.git/",
		user => "kontsutest3",
		cwd => "/home/kontsutest3/projects/",
		creates => "/home/kontsutest3/projects/sharedGitFolder/.git/",
		require => [User["kontsutest3"], Exec["initgit"]],
	}
}
