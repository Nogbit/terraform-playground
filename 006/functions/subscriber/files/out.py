def write(data, context):
    import base64

    if 'data' in data:
        name = base64.b64decode(data['data']).decode('utf-8')
    else:
        name = 'World'

    print('Hello {}!'.format(name))