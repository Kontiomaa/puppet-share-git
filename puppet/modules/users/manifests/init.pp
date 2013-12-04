class users {
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

}
