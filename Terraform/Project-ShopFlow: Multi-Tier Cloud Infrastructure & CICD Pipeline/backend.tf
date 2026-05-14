terraform {
  backend "s3" {
    bucket       = "statetfelgenral"
    key          = "state"
    region       = "us-east-1"
    use_lockfile = true  
  }
}
