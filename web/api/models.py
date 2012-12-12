# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#     * Rearrange models' order
#     * Make sure each model has one field with primary_key=True
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.

from django.db import models
from xml.etree import ElementTree

class Cluster(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, unique=True, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'cluster_pool'

class Datastore(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, unique=True, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'datastore_pool'

class Document(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, blank=True)
    body = models.TextField(blank=True)
    type = models.IntegerField(null=True, blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'document_pool'

class Group(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, unique=True, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'group_pool'

class Host(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, unique=True, blank=True)
    body = models.TextField(blank=True)
    state = models.IntegerField(null=True, blank=True)
    last_mon_time = models.IntegerField(null=True, blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'host_pool'

class Image(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'image_pool'

class Lease(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    ip = models.BigIntegerField(null=True, primary_key=True, blank=True)
    body = models.TextField(blank=True)
    class Meta:
        db_table = u'leases'

class Network(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'network_pool'

class Template(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'template_pool'

class User(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, unique=True, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'user_pool'

class VirtualCluster(models.Model):
    # Status mapping
    # 'shifting' must be the last one
    STATES = ['pending', 'running', 'suspended', 'stopped', 'done', 'shifting']
    
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.TextField(blank=True)
    body = models.TextField(blank=True)
    vc_state = models.IntegerField(null=True, blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'vc_pool'
        
    def get_state_string(self):
        """Get state string"""
        return VirtualCluster.STATES[self.vc_state]
        
class NodeType(models.Model):
    # Status mapping
    STATES = VirtualCluster.STATES[:-1] # Remove 'shifting'
    ACTIONS = ['none', 'deploy', 'suspend', 'stop', 'resume', 'delete']
    
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.TextField(blank=True)
    body = models.TextField(blank=True)
    number = models.IntegerField(null=True, blank=True)
    # vcid = models.IntegerField(null=True, blank=True)
    tid = models.IntegerField(null=True, blank=True)
    pid = models.IntegerField(null=True, blank=True)
    nt_state = models.IntegerField(null=True, blank=True)
    action = models.IntegerField(null=True, blank=True)
    virtualcluster = models.ForeignKey(VirtualCluster, db_column=u'vcid', null=True, blank=True)
    class Meta:
        db_table = u'node_types'
        
    def get_state_string(self):
        """Get state string"""
        return NodeType.STATES[self.nt_state]
        
    def get_action_string(self):
        """Get action string"""
        return NodeType.ACTIONS[self.action]

class VirtualMachine(models.Model):
    # State mapping
    STATES = ['init', 'pending', 'hold', 'active', 'stopped', \
        'suspended', 'done', 'failed', 'poweroff']
    LCM_STATES = ['lcm_init', 'prolog', 'boot', 'running', 'migrate', \
        'save_stop', 'save_suspend', 'save_migrate', 'prolog_migrate' \
        'prolog_resume', 'epilog_stop', 'epilog', 'shutdown', \
        'cancel', 'failure', 'cleanup', 'unknown', 'hotplug', \
        'shutdown_poweroff', 'boot_unknown', 'boot_poweroff' \
        'boot_unknown', 'boot_poweroff', 'boot_suspeded', 'boot_stopped']
    
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.CharField(max_length=128, blank=True)
    body = models.TextField(blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    last_poll = models.IntegerField(null=True, blank=True)
    state = models.IntegerField(null=True, blank=True)
    lcm_state = models.IntegerField(null=True, blank=True)
    owner_u = models.IntegerField(null=True, blank=True)
    group_u = models.IntegerField(null=True, blank=True)
    other_u = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'vm_pool'
        
    def get_state_string(self):
        """Get state string"""
        return VirtualMachine.STATES[self.state]
        
    def get_lcm_state_string(self):
        """Get lcm_state string"""
        return VirtualMachine.LCM_STATES[self.lcm_state]
        
    def get_parsed_body(self):
        """Get body as parsed tree (root element)"""
        return ElementTree.fromstring(self.body)
        
    def get_hostname(self):
        """Get hostname (where vm in running on)"""
        return self.get_parsed_body().find('.//HOSTNAME').text
        
    def get_host_id(self):
        """Get host id"""
        return self.get_parsed_body().find('.//HID').text

class Node(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    virtualcluster = models.ForeignKey(VirtualCluster, db_column=u'vcid', null=True, blank=True)
    nodetype = models.ForeignKey(NodeType, db_column=u'ntid', null=True, blank=True)
    virtualmachine = models.ForeignKey(VirtualMachine, db_column='vmid', null=True, blank=True)
    class Meta:
        db_table = u'nodes'
