# Three different topics that our producer can publish to
resource "google_pubsub_topic" "topics" {
  count = "${length(var.fizzers)}"
  name  = "${var.fizzers[count.index]}"  
}

# Subscriptions for the functions to use
resource "google_pubsub_subscription" "subs" {
  count = "${length(var.fizzers)}"
  name  = "${var.fizzers[count.index]}"  
  topic = "${var.fizzers[count.index]}"  
}