# resource "aws_sqs_queue" "for_each_queue" {
#   for_each = var.for_each_names
#   name     = each.value
# }

# variable "for_each_names" {
#   type        = map(any)
#   description = "values to be used for the queue names"
#   default = {
#     first  = "first-for-each-sqs"
#     second = "second-for-each-sqs"
#     third  = "third-for-each-sqs"
#   }
# }

resource "aws_sqs_queue" "for_each_queue" {
  for_each = toset(local.queue_names)
  name     = each.value

}
locals {
  queue_names = [for i in range(1, 3) : "for-each-sqs-${i}"]
}
