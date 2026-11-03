from rest_framework import viewsets
from .models import Person
from .serializers import PersonSerializer


class PersonViewSet(viewsets.ModelViewSet):
    """
    CRUD uç noktaları sağlar:
      GET    /api/persons/       -> list()
      POST   /api/persons/       -> create()
      GET    /api/persons/{id}/  -> retrieve()
      PUT    /api/persons/{id}/  -> update()
      DELETE /api/persons/{id}/  -> destroy()
    """

    queryset = Person.objects.all()
    serializer_class = PersonSerializer
