# resource "aws_sqs_queue" "count_queue" {
#   count = length(var.names)
#   name  = element(var.names, count.index)

# }

# variable "names" {
#   type        = list(string)
#   default     = ["first", "second", "third"]
#   description = "values to be used for the queue names"
# }

