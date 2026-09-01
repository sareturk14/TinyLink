<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <link rel="icon" type="image/svg+xml"
          href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="admin.title"/> | <spring:message code="app.title"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; min-height: 100vh; }
        .navbar-admin { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); }
        .stat-card { border: none; border-radius: 14px; box-shadow: 0 6px 20px rgba(0,0,0,.06); transition: transform .15s ease; }
        .stat-card:hover { transform: translateY(-3px); }
        .stat-icon { width:56px; height:56px; border-radius:14px; display:flex; align-items:center; justify-content:center; font-size:24px; color:#fff; }
        .icon-users  { background: linear-gradient(135deg, #667eea, #764ba2); }
        .icon-urls   { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .icon-clicks { background: linear-gradient(135deg, #f7971e, #ffd200); }
        .table-card { border: none; border-radius: 14px; box-shadow: 0 6px 20px rgba(0,0,0,.06); }
        .table-card .card-header {
            background: #fff; border-bottom: 1px solid #eef0f5;
            border-top-left-radius: 14px; border-top-right-radius: 14px;
            padding: 1rem 1.25rem; font-weight: 600;
        }
        .badge-verified   { background:#d1f7e0; color:#0a8a4f; }
        .badge-unverified { background:#ffe4e1; color:#c0392b; }
        .badge-role-admin { background:#e7e1ff; color:#5a3ec8; }
        .badge-role-user  { background:#eef0f5; color:#6c757d; }
        .url-cell { max-width:280px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .table-search { max-width:280px; }
        .profile-avatar {
            width:36px; height:36px; border-radius:50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color:#fff; display:inline-flex; align-items:center; justify-content:center; font-weight:600;
        }
        .navbar-admin .dropdown-menu { color:#333; }
        .badge-banned { background:#ffe4e1; color:#c0392b; }
        .btn-ban   { background:#ffe4e1; color:#c0392b; border:1px solid #f1948a; border-radius:8px; font-size:.78rem; padding:.25rem .65rem; font-weight:600; white-space:nowrap; }
        .btn-ban:hover   { background:#fad7d4; color:#a93226; }
        .btn-unban { background:#d1f7e0; color:#0a8a4f; border:1px solid #82e0aa; border-radius:8px; font-size:.78rem; padding:.25rem .65rem; font-weight:600; white-space:nowrap; }
        .btn-unban:hover { background:#b8f0cd; color:#08703f; }
    </style>
</head>
<body>

<nav class="navbar navbar-dark navbar-admin py-3 mb-4">
    <div class="container">
        <span class="navbar-brand mb-0 h1 d-flex align-items-center gap-2">
            <img src="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23ffffff' stop-opacity='0.9'/><stop offset='1' stop-color='%23e0d8ff' stop-opacity='0.9'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='rgba(255,255,255,0.18)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>"
                 width="28" height="28" alt="TinyLink" style="border-radius:7px;flex-shrink:0;">
            <i class="bi bi-shield-lock-fill me-1"></i> <spring:message code="admin.title"/>
        </span>
        <div class="d-flex align-items-center gap-2">
            <!-- Dil seçici -->
            <div class="btn-group btn-group-sm" role="group">
                <a href="?lang=tr"
                   class="btn ${pageContext.response.locale.language == 'tr' ? 'btn-light' : 'btn-outline-light'}">
                    <spring:message code="lang.tr"/>
                </a>
                <a href="?lang=en"
                   class="btn ${pageContext.response.locale.language == 'en' ? 'btn-light' : 'btn-outline-light'}">
                    <spring:message code="lang.en"/>
                </a>
            </div>
            <!-- Ana sayfa butonu -->
            <a href="${pageContext.request.contextPath}/" class="btn btn-light btn-sm">
                <i class="bi bi-house-door me-1"></i> <spring:message code="nav.home"/>
            </a>
            <!-- Profil dropdown -->
            <c:if test="${not empty currentUser}">
                <div class="dropdown">
                    <button class="btn btn-light d-flex align-items-center gap-2 dropdown-toggle"
                            type="button" data-bs-toggle="dropdown" aria-expanded="false">
                        <span class="profile-avatar">
                            <c:out value="${fn:toUpperCase(fn:substring(currentUser.username, 0, 1))}"/>
                        </span>
                        <span class="d-none d-sm-inline fw-semibold text-dark">
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

    <%-- Ban işlemi flash mesajları --%>
    <c:if test="${not empty banAction}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <c:choose>
                <c:when test="${banAction == 'ban'}"><spring:message code="admin.ban.success"/></c:when>
                <c:otherwise><spring:message code="admin.unban.success"/></c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty banErrorCode}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <c:choose>
                <c:when test="${banErrorCode == 'self'}"><spring:message code="admin.ban.error.self"/></c:when>
                <c:otherwise><spring:message code="admin.ban.error.notFound"/></c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- ÖZET KARTLAR -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon icon-users me-3"><i class="bi bi-people-fill"></i></div>
                    <div>
                        <div class="text-muted small text-uppercase"><spring:message code="admin.stat.users"/></div>
                        <div class="h3 fw-bold mb-0">${totalUsers}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon icon-urls me-3"><i class="bi bi-link-45deg"></i></div>
                    <div>
                        <div class="text-muted small text-uppercase"><spring:message code="admin.stat.urls"/></div>
                        <div class="h3 fw-bold mb-0">${totalUrls}</div>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card stat-card">
                <div class="card-body d-flex align-items-center">
                    <div class="stat-icon icon-clicks me-3"><i class="bi bi-bar-chart-fill"></i></div>
                    <div>
                        <div class="text-muted small text-uppercase"><spring:message code="admin.stat.clicks"/></div>
                        <div class="h3 fw-bold mb-0">${totalClicks}</div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- KATEGORİ DAĞILIMI -->
    <c:if test="${not empty categoryStats}">
    <div class="card table-card mb-4">
        <div class="card-header">
            <i class="bi bi-tags-fill me-2"></i>Kategori Dağılımı
        </div>
        <div class="card-body py-3">
            <c:forEach var="entry" items="${categoryStats}">
                <c:choose>
                    <c:when test="${entry.key == 'Sosyal Medya'}">
                        <c:set var="catColor" value="bg-info"/>
                        <c:set var="catIcon"  value="bi-people-fill"/>
                    </c:when>
                    <c:when test="${entry.key == 'Eğitim'}">
                        <c:set var="catColor" value="bg-success"/>
                        <c:set var="catIcon"  value="bi-book-fill"/>
                    </c:when>
                    <c:when test="${entry.key == 'Teknoloji'}">
                        <c:set var="catColor" value="bg-primary"/>
                        <c:set var="catIcon"  value="bi-cpu-fill"/>
                    </c:when>
                    <c:when test="${entry.key == 'Haber'}">
                        <c:set var="catColor" value="bg-warning"/>
                        <c:set var="catIcon"  value="bi-newspaper"/>
                    </c:when>
                    <c:when test="${entry.key == 'E-Ticaret'}">
                        <c:set var="catColor" value="bg-danger"/>
                        <c:set var="catIcon"  value="bi-cart-fill"/>
                    </c:when>
                    <c:when test="${entry.key == 'Eğlence'}">
                        <c:set var="catColor" value="bg-primary"/>
                        <c:set var="catIcon"  value="bi-play-circle-fill"/>
                    </c:when>
                    <c:when test="${entry.key == 'Kurumsal'}">
                        <c:set var="catColor" value="bg-secondary"/>
                        <c:set var="catIcon"  value="bi-building"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="catColor" value="bg-dark"/>
                        <c:set var="catIcon"  value="bi-question-circle-fill"/>
                    </c:otherwise>
                </c:choose>
                <div class="mb-3">
                    <div class="d-flex justify-content-between align-items-center mb-1">
                        <span class="fw-semibold small">
                            <i class="bi ${catIcon} me-1"></i>
                            <spring:message code="category.${entry.key}" text="${entry.key}"/>
                        </span>
                        <span class="badge ${catColor} rounded-pill">${entry.value}</span>
                    </div>
                    <div class="progress" style="height:10px; border-radius:6px;">
                        <div class="progress-bar ${catColor}" role="progressbar"
                             style="width: ${totalUrls > 0 ? entry.value * 100 / totalUrls : 0}%"
                             aria-valuenow="${entry.value}" aria-valuemin="0" aria-valuemax="${totalUrls}">
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- KULLANICILAR TABLOSU -->
    <div class="card table-card mb-4">
        <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <span><i class="bi bi-people me-2"></i><spring:message code="admin.users.header"/> (${totalUsers})</span>
            <input type="text" id="userSearch" class="form-control form-control-sm table-search"
                   placeholder="<spring:message code="admin.users.search"/>">
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="usersTable">
                <thead class="table-light">
                    <tr>
                        <th><spring:message code="admin.col.no"/></th>
                        <th><spring:message code="admin.col.username"/></th>
                        <th><spring:message code="admin.col.email"/></th>
                        <th><spring:message code="admin.col.role"/></th>
                        <th><spring:message code="admin.col.createdAt"/></th>
                        <th><spring:message code="admin.col.verification"/></th>
                        <th><spring:message code="admin.col.actions"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty users}">
                            <tr>
                                <td colspan="7" class="text-center text-muted py-4">
                                    <spring:message code="admin.users.empty"/>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="u" items="${users}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td><c:out value="${u.username}"/></td>
                                    <td><c:out value="${u.email}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.role == 'ADMIN'}">
                                                <span class="badge badge-role-admin">ADMIN</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-role-user">USER</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty u.createdAt}">
                                            <c:out value="${fn:replace(fn:substring(u.createdAt, 0, 16), 'T', ' ')}"/>
                                        </c:if>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.verified}">
                                                <span class="badge badge-verified">
                                                    <i class="bi bi-check-circle-fill"></i>
                                                    <spring:message code="admin.badge.verified"/>
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unverified">
                                                    <i class="bi bi-exclamation-circle-fill"></i>
                                                    <spring:message code="admin.badge.pending"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <c:if test="${u.banned}">
                                            <span class="badge badge-banned ms-1">
                                                <i class="bi bi-ban"></i>
                                                <spring:message code="admin.badge.banned"/>
                                            </span>
                                        </c:if>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users/${u.id}/toggle-ban"
                                              method="post" class="m-0 d-inline">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="${u.banned ? 'btn-unban' : 'btn-ban'}">
                                                <i class="bi ${u.banned ? 'bi-unlock-fill' : 'bi-ban'} me-1"></i>
                                                <c:choose>
                                                    <c:when test="${u.banned}"><spring:message code="admin.unban.button"/></c:when>
                                                    <c:otherwise><spring:message code="admin.ban.button"/></c:otherwise>
                                                </c:choose>
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

    <!-- URL'LER TABLOSU -->
    <div class="card table-card">
        <div class="card-header d-flex justify-content-between align-items-center flex-wrap gap-2">
            <span><i class="bi bi-link-45deg me-2"></i><spring:message code="admin.urls.header"/> (${totalUrls})</span>
            <input type="text" id="urlSearch" class="form-control form-control-sm table-search"
                   placeholder="<spring:message code="admin.urls.search"/>">
        </div>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0" id="urlsTable">
                <thead class="table-light">
                    <tr>
                        <th><spring:message code="admin.col.no"/></th>
                        <th><spring:message code="admin.col.shortCode"/></th>
                        <th><spring:message code="admin.col.originalUrl"/></th>
                        <th><spring:message code="admin.col.owner"/></th>
                        <th><spring:message code="admin.col.createdAtUrl"/></th>
                        <th class="text-end"><spring:message code="admin.col.clicks"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty urls}">
                            <tr>
                                <td colspan="6" class="text-center text-muted py-4">
                                    <spring:message code="admin.urls.empty"/>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="url" items="${urls}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/${url.shortCode}"
                                           target="_blank" class="text-decoration-none fw-semibold">
                                            <c:out value="${url.shortCode}"/>
                                        </a>
                                    </td>
                                    <td class="url-cell" title="${url.originalUrl}">
                                        <a href="${url.originalUrl}" target="_blank"
                                           class="text-decoration-none text-muted">
                                            <c:out value="${url.originalUrl}"/>
                                        </a>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty url.user}">
                                                <c:out value="${url.user.email}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted">
                                                    <spring:message code="admin.url.anonymous"/>
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:if test="${not empty url.createdAt}">
                                            <c:out value="${fn:replace(fn:substring(url.createdAt, 0, 16), 'T', ' ')}"/>
                                        </c:if>
                                    </td>
                                    <td class="text-end">
                                        <span class="badge bg-primary rounded-pill">${url.clickCount}</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function attachSearch(inputId, tableId) {
        const input = document.getElementById(inputId);
        const table = document.getElementById(tableId);
        if (!input || !table) return;
        input.addEventListener('input', function () {
            const term = this.value.toLowerCase();
            table.querySelectorAll('tbody tr').forEach(function (row) {
                row.style.display = row.textContent.toLowerCase().includes(term) ? '' : 'none';
            });
        });
    }
    attachSearch('userSearch', 'usersTable');
    attachSearch('urlSearch', 'urlsTable');
</script>

</body>
</html>
