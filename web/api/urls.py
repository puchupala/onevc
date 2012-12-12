from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
    url(r'^overview$', 'api.views.overview'),
    url(r'^virtual_clusters$', 'api.views.virtualclusters'),
    url(r'^nodetypes$', 'api.views.nodetypes'),
    url(r'^nodes$', 'api.views.nodes'),
)
