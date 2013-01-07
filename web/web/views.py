from django.shortcuts import render_to_response
from settings import SUNSTONE_URL

def index(request):
    return render_to_response('index.html', {'sunstone_url': SUNSTONE_URL})