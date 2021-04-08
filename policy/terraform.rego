package main

import input as tfplan

########################
# Parameters for Policy
########################

# acceptable score for automated authorization
blast_radius = 0

#########
# Policy
#########

# Authorization holds if score for the plan is acceptable, deletes is denied
deny[msg] {

    deletes := [r | r := tfplan.resource_changes[_]; r.change.actions[_] == "delete"]
    total := count(deletes)
    total > 0
    msg = sprintf("Deletes is not allowed, we need peer review. Total deletes: %v", [total])
}

deny[msg] {
  where := location_changes[_]
  not startswith(where, "westeurope")
  msg := sprintf("Location must be `westeurope`; found `%v`", [where])
}

####################
# Terraform Library
####################

# list of all resources of a given type
resources[resource_type] = all {
    some resource_type
    resource_types[resource_type]
    all := [name |
        name:= tfplan.resource_changes[_]
        name.type == resource_type
    ]
}

# number of creations of resources of a given type
num_creates[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    creates := [res |  res:= all[_]; res.change.actions[_] == "create"]
    num := count(creates)
}


# number of deletions of resources of a given type
num_deletes[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    deletions := [res |  res:= all[_]; res.change.actions[_] == "delete"]
    num := count(deletions)
}

# number of modifications to resources of a given type
num_modifies[resource_type] = num {
    some resource_type
    resource_types[resource_type]
    all := resources[resource_type]
    modifies := [res |  res:= all[_]; res.change.actions[_] == "update"]
    num := count(modifies)
}

#Get location from all resources
location_changes[c] {
 c := input.resource_changes[_].change.after.location
}