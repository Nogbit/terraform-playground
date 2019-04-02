from flask        import escape
from google.cloud import pubsub_v1

project_id = "terraform-playground-236106"

def callback(message_future):
    # When timeout is unspecified, the exception method waits indefinitely.
    if message_future.exception(timeout=30):
        print('Publishing message on {} threw an Exception {}.'.format(
            topic_name, message_future.exception()))
    else:
        print(message_future.result())

def produce(request):
    request_json = request.get_json(silent=True)
    request_args = request.args
    publisher    = pubsub_v1.PublisherClient()

    # create 1000's of messages if you really want to
    if request_json and 'count' in request_json:
        n = int(request_json['count'])
    elif request_args and 'count' in request_args:
        n = int(request_args['count'])
    else:
        n = 100

    out = ''
    topic = 'None'
    for y in range(1,n):
        if y % 3 == 0 and y % 5 == 0:
            topic = 'FizzBuzz'
        elif y % 3 == 0:
            topic = 'Fizz'
        elif y % 5 == 0:
            topic = 'Buzz'
        else:
            continue

        topic_path = publisher.topic_path(project_id, topic)
        data       = u'FizzBuzz number {}'.format(y)

        message_future = publisher.publish(topic_path, data.encode('utf-8'))
        message_future.add_done_callback(callback)

    return 'Created {} messages!'.format(escape(n))