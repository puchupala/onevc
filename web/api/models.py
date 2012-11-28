# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#     * Rearrange models' order
#     * Make sure each model has one field with primary_key=True
# Feel free to rename the models, but don't rename db_table values or field names.
#
# Also note: You'll have to insert the output of 'django-admin.py sqlcustom [appname]'
# into your database.

from django.db import models

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

class NodeType(models.Model):
    # Status mapping
    state = ['pending', 'running', 'suspended', 'stopped', 'done']
    action = ['none', 'deploy', 'suspend', 'stop', 'resume', 'delete']
    
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.TextField(blank=True)
    body = models.TextField(blank=True)
    number = models.IntegerField(null=True, blank=True)
    vcid = models.IntegerField(null=True, blank=True)
    tid = models.IntegerField(null=True, blank=True)
    pid = models.IntegerField(null=True, blank=True)
    nt_state = models.IntegerField(null=True, blank=True)
    action = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'node_types'

class Node(models.Model):
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    vcid = models.IntegerField(null=True, blank=True)
    ntid = models.IntegerField(null=True, blank=True)
    vmid = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'nodes'

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
    state = NodeType.state + ['shifting']
    
    oid = models.IntegerField(null=True, primary_key=True, blank=True)
    name = models.TextField(blank=True)
    body = models.TextField(blank=True)
    vc_state = models.IntegerField(null=True, blank=True)
    uid = models.IntegerField(null=True, blank=True)
    gid = models.IntegerField(null=True, blank=True)
    class Meta:
        db_table = u'vc_pool'

class VirtualMachine(models.Model):
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

