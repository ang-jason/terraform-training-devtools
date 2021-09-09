terraform {
  required_version = "1.0.5"
}

locals {
  # Numeric functions
  decimal     = parseint("100", 10)
  hexadecimal = parseint("FF", 16)
  binary      = parseint("101111101110", 2)

  # String functions
  removed   = substr("hello world", -5, -1)
  replaced  = replace("hello world", "l", "y")
  formatted = format("Hello, %s!", "Bob")

  # Collection functions
  generated_list = range(1, 20, 2)
  list_length    = length(local.generated_list)
  combined_list  = concat(["a", "b"], ["c", "d"])
  combined_map = merge(
    {
      foo  = "bar",
      fizz = "buzz"
    },
    {
      hello = "world"
    }
  )

  intersection = setintersection([1, 2, 3, 4], [2, 3, 5, 6])
  product      = setproduct([1, 2], [3, 4])
  subtract     = setsubtract([1, 2, 3, 4], [1, 2, 3])
  union        = setunion([1, 2, 3], [2, 3], [3, 4])

  # Encoding functions
  base64_encoded = base64encode("how you doin")
  json_encoded   = jsonencode({ hello = ["alice", "bob", "world"] })
  json_decoded   = jsondecode("{\"name\":\"Bob\",\"age\":30}")

  # Time functions
  current_time = timestamp()
  added_time   = timeadd("2021-09-22T12:00:00Z", "30m")

  # Hash & Crypto functions
  id     = uuid()
  hashed = sha256("peaches")

  # IP network functions
  ip   = cidrhost("10.50.0.0/21", 312)
  cidr = cidrsubnet("10.10.0.0/16", 8, 1)

}


output "all_vars" {
  value = {
    numbers = {
      decimal     = local.decimal
      hexadecimal = local.hexadecimal
      binary      = local.binary
    }
    strings = {
      removed   = local.removed
      replaced  = local.replaced
      formatted = local.formatted
    }
    collections_1 = {
      generated_list = local.generated_list
      list_length    = local.list_length
      combined_list  = local.combined_list
      combined_map   = local.combined_map
    }
    collections_2 = {
      intersection = local.intersection
      product      = local.product
      substract    = local.subtract
      union        = local.union
    }
    encoding = {
      base64_encoded = local.base64_encoded
      json_encoded   = local.json_encoded
      json_decoded   = local.json_decoded
    }
    time = {
      current_time = local.current_time
      added_time   = local.added_time
    }
    crypto = {
      id     = local.id
      hashed = local.hashed
    }
    networking = {
      ip   = local.ip
      cidr = local.cidr
    }
  }
}
