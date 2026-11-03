from django.db import models


class Person(models.Model):
    fullName = models.CharField(max_length=255)
    department = models.CharField(max_length=255)
    photoUrl = models.URLField(max_length=500)
    birthPlace = models.CharField(max_length=255)
    birthDate = models.DateField()
    email = models.EmailField(max_length=255)
    phone = models.CharField(max_length=20)

    class Meta:
        db_table = "persons"
        ordering = ["id"]

    def __str__(self):
        return self.fullName
