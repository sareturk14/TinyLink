<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%-- JS'ye geçirilecek mesajlar --%>
<spring:message code="form.url.placeholder" var="urlPlaceholder"/>
<spring:message code="dashboard.copied"      var="copiedLabel"/>
<spring:message code="dashboard.clicks.title" var="clicksTitle"/>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="app.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; min-height: 100vh; }
        .navbar-brand-grad {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 700;
        }
        .hero-card {
            border: none; border-radius: 18px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            box-shadow: 0 12px 30px rgba(102, 126, 234, 0.25);
        }
        .hero-card .form-control, .hero-card .form-select { border: none; border-radius: 10px; }
        .hero-card .btn-primary { background: #fff; color: #5a3ec8; border: none; font-weight: 600; }
        .hero-card .btn-primary:hover { background: #f3f0ff; color: #5a3ec8; }
        .url-card {
            border: none; border-radius: 14px;
            box-shadow: 0 6px 20px rgba(0,0,0,.06);
            transition: transform .15s ease; height: 100%;
        }
        .url-card:hover { transform: translateY(-3px); }
        .url-card .card-body { padding: 1.25rem; }
        .url-original { color: #6c757d; font-size:.85rem; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .url-short a { color:#5a3ec8; font-weight:600; text-decoration:none; }
        .url-short a:hover { text-decoration:underline; }
        .ai-summary {
            background: linear-gradient(135deg,#f6f4ff 0%,#eef0ff 100%);
            border-left: 3px solid #764ba2; border-radius: 8px;
            padding: .65rem .85rem; font-size: .85rem; color: #444; line-height: 1.4;
        }
        .stat-pill { background:#f1f3f9; border-radius:999px; padding:.2rem .7rem; font-size:.78rem; color:#555; }
        .result-card {
            border: none; border-radius: 14px; border-left: 4px solid #28a745;
            background: #fff; box-shadow: 0 6px 20px rgba(0,0,0,.06);
        }
        .profile-avatar {
            width:36px; height:36px; border-radius:50%;
            background: linear-gradient(135deg,#667eea,#764ba2);
            color:#fff; display:inline-flex; align-items:center; justify-content:center; font-weight:600;
        }
        .url-search-input {
            background: rgba(102,126,234,.08);
            border: 1.5px solid rgba(102,126,234,.28);
            border-radius: 10px;
            color: #333;
            min-width: 200px;
            transition: border-color .2s, box-shadow .2s, background .2s;
        }
        .url-search-input::placeholder { color: rgba(90,62,200,.45); }
        .url-search-input:focus {
            outline: none;
            border-color: #764ba2;
            box-shadow: 0 0 0 3px rgba(102,126,234,.18);
            background: rgba(102,126,234,.04);
        }
    </style>
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-light bg-white shadow-sm py-3 mb-4">
    <div class="container">
        <a class="navbar-brand navbar-brand-grad d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/">
            <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>"
                 width="28" height="28" alt="TinyLink" style="border-radius:7px;flex-shrink:0;">
            <spring:message code="app.title"/>
        </a>
        <div class="d-flex align-items-center gap-2">
            <!-- Dil seçici -->
            <div class="btn-group btn-group-sm" role="group">
                <a href="?lang=tr"
                   class="btn ${pageContext.response.locale.language == 'tr' ? 'btn-primary' : 'btn-outline-secondary'}">
                    <spring:message code="lang.tr"/>
                </a>
                <a href="?lang=en"
                   class="btn ${pageContext.response.locale.language == 'en' ? 'btn-primary' : 'btn-outline-secondary'}">
                    <spring:message code="lang.en"/>
                </a>
            </div>
            <!-- Çöp kutusu kısa yolu -->
            <a href="${pageContext.request.contextPath}/trash" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-trash3"></i> <spring:message code="nav.trash"/>
            </a>
            <!-- Admin panel kısayolu -->
            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-primary btn-sm">
                    <i class="bi bi-shield-lock"></i> <spring:message code="nav.admin.link"/>
                </a>
            </sec:authorize>
            <!-- Profil dropdown -->
            <c:if test="${not empty currentUser}">
                <div class="dropdown">
                    <button class="btn btn-light d-flex align-items-center gap-2 dropdown-toggle"
                            type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="profile-avatar">
                            <c:out value="${fn:toUpperCase(fn:substring(currentUser.username, 0, 1))}"/>
                        </span>
                        <span class="d-none d-sm-inline fw-semibold">
                            <c:out value="${currentUser.username}"/>
                        </span>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end shadow">
                        <li class="px-3 py-2">
                            <div class="fw-semibold"><c:out value="${currentUser.username}"/></div>
                            <div class="text-muted small"><c:out value="${currentUser.email}"/></div>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item" href="${pageContext.request.contextPath}/trash">
                                <i class="bi bi-trash3 me-2"></i> <spring:message code="nav.trash"/>
                            </a>
                        </li>
                        <li>
                            <form action="${pageContext.request.contextPath}/logout" method="post" class="m-0">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                <button type="submit" class="dropdown-item text-danger">
                                    <i class="bi bi-box-arrow-right me-2"></i> <spring:message code="nav.logout"/>
                                </button>
                            </form>
                        </li>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>
</nav>

<div class="container pb-5">

    <!-- HERO: KISALTMA FORMU -->
    <div class="card hero-card mb-4">
        <div class="card-body p-4 p-md-5">
            <h2 class="fw-bold mb-1"><spring:message code="app.title"/></h2>
            <p class="mb-4 opacity-75"><spring:message code="app.subtitle"/></p>
            <form action="${pageContext.request.contextPath}/shorten" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="row g-2">
                    <div class="col-md-7">
                        <input type="url" class="form-control form-control-lg"
                               id="originalUrl" name="originalUrl"
                               placeholder="${urlPlaceholder}" required>
                    </div>
                    <div class="col-md-3">
                        <select name="lifetime" class="form-select form-select-lg">
                            <option value="forever"><spring:message code="lifetime.forever"/></option>
                            <option value="1h"><spring:message code="lifetime.1h"/></option>
                            <option value="24h"><spring:message code="lifetime.24h"/></option>
                            <option value="7d"><spring:message code="lifetime.7d"/></option>
                            <option value="30d"><spring:message code="lifetime.30d"/></option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-primary btn-lg w-100">
                            <i class="bi bi-scissors"></i>
                            <span class="d-none d-lg-inline ms-1"><spring:message code="form.button.shorten"/></span>
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Kısaltma sonucu (flash mesaj) -->
    <c:if test="${not empty shortCode}">
        <div class="card result-card mb-4">
            <div class="card-body p-4">
                <h5 class="fw-bold text-success mb-3">
                    <i class="bi bi-check-circle-fill"></i> <spring:message code="result.title"/>
                </h5>
                <div class="mb-2">
                    <small class="text-muted"><spring:message code="result.original"/>:</small><br>
                    <span class="text-break"><c:out value="${originalUrl}"/></span>
                </div>
                <div class="mb-2">
                    <small class="text-muted"><spring:message code="result.short"/>:</small><br>
                    <a href="${pageContext.request.contextPath}/${shortCode}" target="_blank"
                       class="fw-semibold text-decoration-none">
                        ${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/${shortCode}
                    </a>
                </div>
                <c:if test="${not empty aiSummary}">
                    <div class="ai-summary mt-3">
                        <strong><i class="bi bi-stars"></i> <spring:message code="result.aiSummary"/>:</strong>
                        <c:out value="${aiSummary}"/>
                    </div>
                </c:if>
            </div>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-octagon-fill me-2"></i>
            <div><strong><spring:message code="error.title"/>:</strong> <c:out value="${error}"/></div>
        </div>
    </c:if>
    <c:if test="${not empty info}">
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <div><c:out value="${info}"/></div>
        </div>
    </c:if>

    <!-- AKTİF URL LİSTESİ (sadece giriş yapmış kullanıcının — veri izolasyonu) -->
    <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <h4 class="fw-bold mb-0">
            <i class="bi bi-collection text-primary"></i> <spring:message code="dashboard.myurls"/>
            <small class="text-muted fs-6">(${fn:length(urls)})</small>
        </h4>
        <c:if test="${not empty urls}">
            <div class="d-flex align-items-center gap-2 flex-wrap">
                <input type="text" id="urlSearchInput"
                       class="form-control form-control-sm url-search-input"
                       placeholder="&#128269; Ara / Search"
                       autocomplete="off">
                <select id="categoryFilter" class="form-select form-select-sm" style="max-width:160px;">
                    <option value=""><spring:message code="dashboard.filter.all"/></option>
                </select>
            </div>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${empty urls}">
            <div class="card url-card">
                <div class="card-body text-center text-muted py-5">
                    <i class="bi bi-inbox" style="font-size:2rem;"></i>
                    <p class="mb-0 mt-2"><spring:message code="dashboard.empty"/></p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-3">
                <c:forEach var="url" items="${urls}">
                    <div class="col-md-6 col-lg-4" data-category="${url.aiCategory}">
                        <div class="card url-card">
                            <div class="card-body d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-2">
                                    <div class="url-short flex-grow-1 me-2">
                                        <a href="${pageContext.request.contextPath}/${url.shortCode}" target="_blank">
                                            /<c:out value="${url.shortCode}"/>
                                            <i class="bi bi-box-arrow-up-right small"></i>
                                        </a>
                                    </div>
                                    <span class="badge bg-primary rounded-pill" title="${clicksTitle}">
                                        <i class="bi bi-cursor-fill"></i> ${url.clickCount}
                                    </span>
                                </div>
                                <div class="url-original mb-2" title="${url.originalUrl}">
                                    <i class="bi bi-link-45deg"></i>
                                    <c:out value="${url.originalUrl}"/>
                                </div>
                                <div class="d-flex flex-wrap gap-2 mb-2">
                                    <span class="stat-pill">
                                        <i class="bi bi-calendar3"></i>
                                        <c:if test="${not empty url.createdAt}">
                                            <c:out value="${fn:replace(fn:substring(url.createdAt, 0, 16), 'T', ' ')}"/>
                                        </c:if>
                                    </span>
                                    <c:choose>
                                        <c:when test="${not empty url.expiresAt}">
                                            <span class="stat-pill" style="background:#fff5e1;color:#b27500;">
                                                <i class="bi bi-hourglass-split"></i>
                                                <c:out value="${fn:replace(fn:substring(url.expiresAt, 0, 16), 'T', ' ')}"/>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stat-pill" style="background:#e7f7ee;color:#0a8a4f;">
                                                <i class="bi bi-infinity"></i>
                                                <spring:message code="dashboard.permanent"/>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <c:if test="${not empty url.aiCategory}">
                                        <span class="stat-pill" style="background:#ede9fe;color:#5b21b6;">
                                            <i class="bi bi-tag"></i>
                                            <spring:message code="category.${url.aiCategory}" text="${url.aiCategory}"/>
                                        </span>
                                    </c:if>
                                </div>
                                <c:if test="${not empty url.aiSummary}">
                                    <div class="ai-summary mt-auto">
                                        <strong><i class="bi bi-stars"></i> <spring:message code="result.aiSummary"/>:</strong>
                                        <c:out value="${url.aiSummary}"/>
                                    </div>
                                </c:if>
                                <div class="d-flex gap-2 mt-3">
                                    <button type="button"
                                            class="btn btn-outline-secondary btn-sm flex-grow-1"
                                            onclick="copyShort('${pageContext.request.contextPath}/${url.shortCode}')">
                                        <i class="bi bi-clipboard"></i> <spring:message code="dashboard.copy"/>
                                    </button>
                                    <form action="${pageContext.request.contextPath}/urls/${url.id}/delete"
                                          method="post" class="m-0">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="bi bi-trash3"></i> <spring:message code="dashboard.delete"/>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Kategori filtresi + Anlık Arama — ikisi birlikte çalışır
    (function () {
        const select      = document.getElementById('categoryFilter');
        const searchInput = document.getElementById('urlSearchInput');
        const cols        = Array.from(document.querySelectorAll('[data-category]'));

        // Kategori seçeneklerini doldur
        if (select) {
            const cats = [...new Set(cols.map(c => c.dataset.category).filter(Boolean))].sort();
            cats.forEach(function(cat) {
                const opt = document.createElement('option');
                opt.value = cat;
                opt.textContent = cat;
                select.appendChild(opt);
            });
        }

        function applyFilters() {
            const term = searchInput ? searchInput.value.toLowerCase().trim() : '';
            const sel  = select ? select.value : '';

            cols.forEach(function(col) {
                const card = col.querySelector('.url-card');
                if (!card) { col.style.display = ''; return; }

                // Kategori eşleşmesi
                const catOk = (sel === '' || col.dataset.category === sel);

                // Arama eşleşmesi
                let searchOk = true;
                if (term) {
                    const originalText = (col.querySelector('.url-original')  || {textContent:''}).textContent;
                    const shortText    = (col.querySelector('.url-short a')   || {textContent:''}).textContent;
                    const summaryText  = (col.querySelector('.ai-summary')     || {textContent:''}).textContent;
                    searchOk = (originalText + ' ' + shortText + ' ' + summaryText).toLowerCase().includes(term);
                }

                col.style.display = (catOk && searchOk) ? '' : 'none';
            });
        }

        if (select)      select.addEventListener('change', applyFilters);
        if (searchInput) searchInput.addEventListener('input', applyFilters);
    })();

    const COPIED_LABEL = '${copiedLabel}';
    function copyShort(path) {
        const full = window.location.protocol + '//' + window.location.host + path;
        navigator.clipboard.writeText(full).then(function () {
            const toast = document.createElement('div');
            toast.textContent = COPIED_LABEL + ' ' + full;
            toast.style.cssText = 'position:fixed;bottom:20px;right:20px;background:#333;color:#fff;padding:10px 16px;border-radius:8px;z-index:1080;box-shadow:0 6px 18px rgba(0,0,0,.2);font-size:0.9rem;';
            document.body.appendChild(toast);
            setTimeout(() => toast.remove(), 1800);
        });
    }
</script>
</body>
</html>
