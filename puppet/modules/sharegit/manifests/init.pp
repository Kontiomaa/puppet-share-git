class sharegit {
	package {"git":
		ensure => "latest"
	}

	class {"users":}
}
