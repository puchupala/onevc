from django.http import HttpResponse
from django.core import serializers
from api.models import *
import simplejson as json

def vc_list(request):
    vcs = VirtualCluster.objects.all()
    nodes = Node.objects.all()
                       
    output = [{
        'id': vc.pk,
        'body': vc.body,
        'state': VirtualCluster.state[vc.vc_state],
        'name': vc.name,
        'nodes': [{
            'id': node.pk,
            'ntid': node.ntid,
            'vmid': node.vmid,
        } for node in filter(lambda node: node.vcid == vc.pk, nodes)],
    } for vc in vcs]
        
    
    return HttpResponse(json.dumps(output))
