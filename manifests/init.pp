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
		#password => '$6$GtbgrQhn$sQYJqWf4fzEmjiVWWZPk0OBpnCj7SbIqDXHxG0BJAD0PjmOOlSTNpJUBAzL30TPhH6JWn31BhR/AEjt0GtRlw0:16050:0:99999:7:::',
                groups => ["$repo"],
                require => User["$repo"],
        }

        user {"kontsutest3":
                ensure => present,
                shell => "/bin/bash",
                managehome => true,
		#password => '$6$RrAOjgUM$AZWb4qzE.z9NXuMSDM5au8g0syHCnpAnVyNSwO.9MivH0i45lXaOLLJWGV0my32svULnJg1bRS.qj/q1MvlaI.:16050:0:99999:7:::',
                groups => ["$repo"],
                require => User["$repo"],
        }

	file {"/home/$repo/sharedGitFolder.git":
                ensure => "directory",
		owner => "$repo",
                group => "$repo",
                mode => "777",
                require => User["$repo"],
        }

	file {"/home/kontsutest2/projects":
                ensure => "directory",
		owner => "kontsutest2",
		mode => "777",
                require => User["kontsutest2"],
        }

	file {"/home/kontsutest3/projects":
                ensure => "directory",
		owner => "kontsutest3",
		mode => "777",
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
		command => "/usr/bin/git clone /home/kontsutest1/sharedGitFolder.git/",
		user => "kontsutest2",
		cwd => "/home/kontsutest2/projects/",
		require => [User["kontsutest2"], Exec["initgit"]],
	}

	exec {"clone2":
		command => "/usr/bin/git clone /home/kontsutest1/sharedGitFolder.git/",
		user => "kontsutest3",
		cwd => "/home/kontsutest3/projects/",
		require => [User["kontsutest3"], Exec["initgit"]],
	}
}
