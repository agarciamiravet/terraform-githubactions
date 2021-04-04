package main

blacklist = [
  "aws_s3_bucket_public_access_block"
]

deny[msg] {
  check_resources(input.resource_changes, blacklist)
  banned := concat(", ", blacklist)
  msg = sprintf("Prohibited resources found: %v", [banned])
}

# Checks whether the plan will cause resources with certain prefixes to change
check_resources(resources, disallowed_prefixes) {
  startswith(resources[_].type, disallowed_prefixes[_])
}
