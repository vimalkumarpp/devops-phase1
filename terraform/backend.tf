terraform {
	backend "s3" {
		bucket = "devops-phase1-terraform"
		use_lockfile = true
	}
}
