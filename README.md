# redmine_favorites_projects_kaizen2b

> Plugin liviano para **Redmine 6.x** que permite a cada usuario **marcar/desmarcar proyectos como favoritos**, ver un **listado** de sus favoritos y añadir un **bloque en “Mi página”**. Sin dependencias externas (no usa `redmine_crm` ni `redmineup`).

---

## Características
- ⭐ **Botón en la vista del proyecto** (columna derecha) para marcar / quitar de favoritos.
- 📄 **Página de favoritos**: listado de proyectos favoritos del usuario actual.
- 🧩 **Bloque “Mi página”**: muestra enlaces rápidos a los proyectos favoritos.
- 🌐 **I18n**: textos en **es** y **en**.
- 🧱 **Sin gems adicionales**; 1 tabla propia en DB: `favorite_projects`.

---

## Compatibilidad
- Redmine **6.0+** (Rails 7.x).
- Ruby: la del core de tu Redmine (probado con Ruby 3.2).

> Puede funcionar en Redmine 5.x, pero no está oficialmente soportado en este repo.

---

## Instalación

1. Clonar o copiar el plugin en:

```
/srv/redmine6/plugins/redmine_favorites_projects_kaizen2b
```

2. Ejecutar migraciones y compilar assets:

```bash
cd /srv/redmine6
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
touch tmp/restart.txt   # si usás Passenger
```

3. (Opcional) En **Mi página → Personalizar**, agregar el bloque **“Proyectos favoritos”**.

> Si no ves el bloque, asegurate de que existe la partial `app/views/my/blocks/_favorite_projects.html.erb` y que el idioma tiene la clave `my.blocks.favorite_projects` en `config/locales/*.yml`.

---

## Uso

- Entrá a cualquier **Proyecto** → en la columna derecha verás el botón ⭐ para **Marcar/Quitar de favoritos**.
- En el menú superior encontrarás **“Proyectos favoritos”** que lleva a `/favorites` (listado personal).

---

## Rutas

```text
GET  /favorites          -> favorites#index  (HTML)
POST /favorites/toggle   -> favorites#toggle (HTML; redirige a la página anterior)
```

---

## Esquema de base de datos

Migración: `db/migrate/001_create_favorite_projects.rb`

```sql
favorite_projects (
  id          integer PK,
  user_id     integer NOT NULL,
  project_id  integer NOT NULL,
  created_at  datetime,
  updated_at  datetime,
  UNIQUE (user_id, project_id),
  INDEX (project_id)
)
```

---

## Estructura del plugin (resumen)

```
redmine_favorites_projects_kaizen2b/
├─ init.rb
├─ config/
│  └─ routes.rb
├─ db/migrate/
│  └─ 001_create_favorite_projects.rb
├─ app/
│  ├─ controllers/ (favorites_controller.rb)
│  ├─ models/ (favorite_project.rb)
│  ├─ helpers/ (favorites_helper.rb)
│  └─ views/
│     ├─ redmine_favorites_kaizen2b/_favorite_button.html.erb
│     └─ my/blocks/_favorite_projects.html.erb
├─ lib/
│  ├─ redmine_favorites_kaizen2b.rb
│  └─ redmine_favorites/
│     └─ hooks/
│        └─ view_projects_show_right_hook.rb
├─ assets/
│  └─ stylesheets/redmine_favorites.css
└─ config/locales/
   ├─ es.yml
   └─ en.yml
```

---

## Desinstalación / Rollback

```bash
cd /srv/redmine6
bundle exec rake redmine:plugins:migrate NAME=redmine_favorites_projects_kaizen2b VERSION=0 RAILS_ENV=production
rm -rf plugins/redmine_favorites_projects_kaizen2b
touch tmp/restart.txt
```

---

## Solución de problemas

- **“Translation missing: …label_favorite_projects”**  
  Compilá assets y reiniciá. Verificá `config/locales/es.yml` y `en.yml`.
- **500 en página de Proyecto (`undefined method favorite_for?`)**  
  Asegurate de estar en una versión del plugin que **incluye** `FavoritesHelper` globalmente. Limpiá caché:
  ```bash
  bundle exec rake tmp:cache:clear
  touch tmp/restart.txt
  ```
- **No aparece el botón ⭐**  
  Verificá que hayas iniciado sesión y que la partial del botón exista:  
  `app/views/redmine_favorites_kaizen2b/_favorite_button.html.erb`.

---

## Desarrollo

- Mensajería de commits: **Conventional Commits**.
- Después de cambios en vistas/assets, recordá:
  ```bash
  bundle exec rake tmp:cache:clear
  bundle exec rake assets:precompile RAILS_ENV=production
  touch tmp/restart.txt
  ```
- Hooks usados: `:view_projects_show_right` (para el botón).

---

## Roadmap (ideas)

- AJAX para el toggle sin recarga.
- ⭐ en listados de proyectos con filtro “Solo favoritos”.
- API JSON estable (`/favorites.json`, `/favorites/toggle.json`).

---

## Licencia

MIT (podés cambiarla si tu organización requiere otra).

© Kaizen2B.
