(function () {
  function ready(fn) {
    if (document.readyState !== 'loading') fn();
    else document.addEventListener('DOMContentLoaded', fn);
  }

  function csrfToken() {
    var m = document.querySelector('meta[name="csrf-token"]');
    return m ? m.getAttribute('content') : '';
  }

  function onlyPath(url) {
    try { var u = new URL(url, window.location.origin); return u.pathname + (u.search || ''); }
    catch (e) { return url; }
  }

  function extractIdentifierFromHref(href) {
    var m = onlyPath(href).match(/^\/projects\/([^\/\?#]+)/);
    return m ? decodeURIComponent(m[1]) : null;
  }

  function inContent(a) {
    try { return !!a.closest('#content'); } catch (e) { return false; }
  }

  function toggleFavourite(ident, btn) {
    // Optimistic UI
    var wasOn = btn.classList.contains('on');
    btn.classList.toggle('on', !wasOn);

    fetch('/favorites/toggle.json', {
      method: 'POST',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-CSRF-Token': csrfToken(),
        'X-Requested-With': 'XMLHttpRequest'
      },
      credentials: 'same-origin',
      body: JSON.stringify({
        project_identifier: ident,
        authenticity_token: csrfToken() // fallback CSRF param
      })
    })
      .then(function (r) { return r.ok ? r.json() : Promise.reject(r); })
      .then(function (res) {
        var on = !!res.favourited;
        btn.classList.toggle('on', on);
        btn.title = on ? 'Quitar de favoritos' : 'Marcar como favorito';
        btn.setAttribute('aria-label', btn.title);
      })
      .catch(function (e) {
        // Revert UI on error
        btn.classList.toggle('on', wasOn);
        // Útil para debug si algo falla con CSRF/rutas
        console.error('Fav toggle failed', e);
      });
  }

  function injectStars(favIdents) {
    var seen = new Set();
    var links = document.querySelectorAll('a[href^="/projects/"]');

    links.forEach(function (a) {
      if (!inContent(a)) return;

      var ident = extractIdentifierFromHref(a.getAttribute('href'));
      if (!ident) return;

      // Evitar enlaces a secciones internas del proyecto
      if (/\/projects\/[^\/]+\/(activity|issues|news|files|documents|wiki)/.test(a.getAttribute('href'))) return;

      // Evitar duplicados en tarjetas/listas
      var key = ident + '|' + (a.offsetTop || 0) + '|' + (a.offsetLeft || 0);
      if (seen.has(key)) return;
      seen.add(key);

      // Botón estrella
      var btn = document.createElement('button');
      btn.type = 'button';
      btn.className = 'kzn-fav-star' + (favIdents.has(ident) ? ' on' : '');
      btn.title = favIdents.has(ident) ? 'Quitar de favoritos' : 'Marcar como favorito';
      btn.setAttribute('aria-label', btn.title);
      btn.innerHTML = '★';

      btn.addEventListener('click', function (ev) {
        ev.preventDefault();
        ev.stopPropagation();
        if (ev.stopImmediatePropagation) ev.stopImmediatePropagation();
        toggleFavourite(ident, btn);
      });

      // Insertar antes del link
      var parent = a.parentElement;
      if (parent) parent.insertBefore(btn, a);
    });
  }

  ready(function () {
    fetch('/favorites.json', { credentials: 'same-origin', headers: { 'Accept': 'application/json' } })
      .then(function (r) { return r.ok ? r.json() : { project_identifiers: [] }; })
      .then(function (data) {
        var favIdents = new Set((data && data.project_identifiers) || []);
        injectStars(favIdents);
      })
      .catch(function () {
        injectStars(new Set());
      });
  });
})();
