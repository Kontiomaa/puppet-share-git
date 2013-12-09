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

	file {"/home/kontsutest2/projects":
                ensure => "directory",
                require => User["kontsutest2"],
        }

	file {"/home/kontsutest3/projects":
                ensure => "directory",
                require => User["kontsutest3"],
        }

	exec {"initgit":
		command => "/usr/bin/git init --bare --shared /home/kontsutest1/sharedGitFolder.git/",
		require => File["/home/kontsutest1/sharedGitFolder.git/"],
	}

	exec {"lockuser1":
                command => "/usr/sbin/usermod --lock kontsutest1",
                require => User["kontsutest1"],
        }

	exec {"folderowngroup":
                command => "/bin/chown .kontsutest1 /home/kontsutest1/sharedGitFolder.git/",
                require => File["/home/kontsutest1/sharedGitFolder.git/"],
        }
}
