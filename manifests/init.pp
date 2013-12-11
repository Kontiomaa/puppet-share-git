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
		#password => '$6$GtbgrQhn$sQYJqWf4fzEmjiVWWZPk0OBpnCj7SbIqDXHxG0BJAD0PjmOOlSTNpJUBAzL30TPhH6JWn31BhR/AEjt0GtRlw0:16050:0:99999:7:::',
                groups => ["kontsutest1"],
                require => User["kontsutest1"],
        }

        user {"kontsutest3":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
		#password => '$6$RrAOjgUM$AZWb4qzE.z9NXuMSDM5au8g0syHCnpAnVyNSwO.9MivH0i45lXaOLLJWGV0my32svULnJg1bRS.qj/q1MvlaI.:16050:0:99999:7:::',
                groups => ["kontsutest1"],
                require => User["kontsutest1"],
        }

	file {"/home/kontsutest1/sharedGitFolder.git":
                ensure => "directory",
		owner => "kontsutest1",
                group => "kontsutest1",
                mode => "770",
                require => User["kontsutest1"],
        }

	file {"/home/kontsutest2/projects":
                ensure => "directory",
		owner => "kontsutest2",
		mode => "770",
                require => User["kontsutest2"],
        }

	file {"/home/kontsutest3/projects":
                ensure => "directory",
		owner => "kontsutest3",
		mode => "770",
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
