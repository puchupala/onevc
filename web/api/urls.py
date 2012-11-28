from django.conf.urls import patterns, include, url

urlpatterns = patterns('',
    url(r'^$', 'api.views.vc_list'),
)
