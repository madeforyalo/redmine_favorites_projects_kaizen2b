(function () {
  function ready(fn) {
    if (document.readyState !== 'loading') { fn(); }
    else { document.addEventListener('DOMContentLoaded', fn); }
  }

  function csrfToken() {
    var m = document.querySelector('meta[name="csrf-token"]');
    return m ? m.getAttribute('content') : '';
  }

  function onlyPath(url) {
    try {
      var u = new URL(url, window.location.origin);
      return u.pathname + (u.search || '');
    } catch (e) { return url; }
  }

  function extractIdentifierFromHref(href) {
    var m = onlyPath(href).match(/^\/projects\/([^\/\?#]+)/);
    return m ? decodeURIComponent(m[1]) : null;
  }

  function inContent(a) {
    try { return !!a.closest('#content'); } catch (e) { return false; }
  }

  function injectStars(favIdents) {
    var seen = new Set();

    // Todos los links a /projects/<identifier> dentro del contenido
    var links = document.querySelectorAll('a[href^="/projects/"]');

    links.forEach(function (a) {
      if (!inContent(a)) return;
      var ident = extractIdentifierFromHref(a.getAttribute('href'));
      if (!ident) return;

      // Evitar menús “>>”, activity, etc.
      if (/\/projects\/[^\/]+\/(activity|issues|news|files|documents|wiki)/.test(a.getAttribute('href'))) return;

      // Evitar duplicar por tarjeta o por fila
      var key = ident + '|' + (a.offsetTop || 0) + '|' + (a.offsetLeft || 0);
      if (seen.has(key)) return;
      seen.add(key);

      // Crear botón estrella
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'kzn-fav-star' + (favIdents.has(ident) ? ' on' : '');
      btn.title = favIdents.has(ident) ? 'Quitar de favoritos' : 'Marcar como favorito';
      btn.setAttribute('aria-label', btn.title);
      btn.innerHTML = '★';

      btn.addEventListener('click', function (ev) {
        ev.preventDefault();
        ev.stopPropagation();

        fetch('/favorites/toggle.json', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken()
          },
          credentials: 'same-origin',
          body: JSON.stringify({ project_identifier: ident })
        }).then(function (r) { return r.json(); })
          .then(function (res) {
            var on = !!res.favourited;
            btn.classList.toggle('on', on);
            btn.title = on ? 'Quitar de favoritos' : 'Marcar como favorito';
            btn.setAttribute('aria-label', btn.title);
          })
          .catch(function () { /* noop */ });
      });

      // Insertar antes del link
      var container = a.parentElement;
      if (container) container.insertBefore(btn, a);
    });
  }

  ready(function () {
    // Obtener favoritos del usuario una sola vez
    fetch('/favorites.json', { credentials: 'same-origin' })
      .then(function (r) { return r.ok ? r.json() : { project_identifiers: [] }; })
      .then(function (data) {
        var favIdents = new Set(data.project_identifiers || []);
        injectStars(favIdents);
      })
      .catch(function () {
        injectStars(new Set());
      });
  });
})();
