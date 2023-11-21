locals {
  six-figure-tags = {
    Company = "6-figure"
    Contact = "6figure@company.com"
    Project = "E-learning-app"
    env = "${terraform.workspace}"
    Creationtime = formatdate("DD MMM YYh:YY hmm ZZZ", timestamp())

  }
}