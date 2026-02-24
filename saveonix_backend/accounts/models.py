from django.db import models

class user(models.Model):

    username = models.CharField(max_length=50, unique= True)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=225)

    def __str__(self):
        return self.username

    

