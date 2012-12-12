from django.http import HttpResponse
from django.core import serializers
from api.models import *
import simplejson as json

def overview(request):
    vcs = VirtualCluster.objects.all()
    
    simplified_vcs = list()
    for vc in vcs:
        nts = vc.nodetype_set.all()
        
        simplified_nts = list()
        for nt in nts:
            nodes = nt.node_set.all()
            
            simplified_nodes = list()
            if len(nodes) > 0:
                # If there is some deployed nodes   
                for node in nodes:
                    vm = node.virtualmachine
                    simplified_nodes.append({
                        'id': node.pk,
                        'virtualmachine': {
                            'id': vm.pk,
                            'name': vm.name,
                            'body': vm.body,
                            'state': vm.get_state_string(),
                            'lcm_state': vm.get_lcm_state_string(),
                            'hostname': vm.get_hostname(),
                            'host_id': vm.get_host_id(),
                        },
                    })
            
            simplified_nts.append({
                'id': nt.pk,
                'name': nt.name,
                'body': nt.body,
                'state': nt.get_state_string(),
                'action': nt.get_action_string(),
                'nodes': simplified_nodes,
            })
        
        simplified_vcs.append({
            'id': vc.pk,
            'body': vc.body,
            'state': vc.get_state_string(),
            'name': vc.name,
            'nodetypes': simplified_nts,
        })
    
    return HttpResponse(json.dumps(simplified_vcs))

def virtualclusters(request, vc_id=None):
    if id == None:
        vcs = VirtualCluster.objects.all()
    else:
        vcs = VirtualCluster.objects.get(pk=vc_id)
    return HttpResponse(json.dumps({}))
    
def nodetypes(request, vc_id=None):
    if vc_id == None:
        nts = NodeType.objects.all()
    else:
        nts = VirtualCluster.objects.get(pk=vc_id).NodeType_set()
    
    return HttpResponse(json.dumps({}))
    
def nodes(request, vc_id=None, nt_id=None):
    if vc_id == None:
        nodes = Node.objects.all()
    
    return HttpResponse(json.dumps({}))