"""Permissions for non-public operational API actions."""

import secrets

from django.conf import settings
from rest_framework.permissions import BasePermission


class ServiceTokenPermission(BasePermission):
    """Allow staff users or callers holding the configured service token."""

    message = 'Se requiere autenticación de servicio.'

    def has_permission(self, request, view):
        if bool(getattr(request.user, 'is_staff', False)):
            return True

        expected = getattr(settings, 'LECTURAS_REFRESH_TOKEN', '')
        supplied = request.headers.get('X-Internal-Token', '')
        if not supplied:
            authorization = request.headers.get('Authorization', '')
            if authorization.lower().startswith('bearer '):
                supplied = authorization[7:].strip()
        return bool(expected and supplied and secrets.compare_digest(supplied, expected))
