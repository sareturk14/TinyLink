<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%-- Silme onayı Bootstrap modal ile yapılıyor, browser confirm() kullanılmıyor --%>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="trash.title"/> | <spring:message code="app.title"/></title>
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
        .table-card { border: none; border-radius: 14px; box-shadow: 0 6px 20px rgba(0,0,0,.06); }
        .url-cell { max-width:320px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .profile-avatar {
            width:36px; height:36px; border-radius:50%;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color:#fff; display:inline-flex; align-items:center; justify-content:center; font-weight:600;
        }
        /* Silme onay modalı */
        .delete-modal-icon {
            width:64px; height:64px; border-radius:50%;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            display:flex; align-items:center; justify-content:center;
            margin: 0 auto 1rem;
            box-shadow: 0 8px 24px rgba(238,90,36,.30);
            font-size:1.6rem; color:#fff;
        }
        .delete-modal-url {
            background: #f8f9fa; border-radius: 10px;
            padding: .6rem 1rem; font-size: .85rem;
            color: #555; word-break: break-all;
            border-left: 3px solid #dc3545;
        }
        .btn-delete-confirm {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            border: none; color: #fff; font-weight: 600;
            border-radius: 10px; padding: .5rem 1.4rem;
            box-shadow: 0 4px 14px rgba(238,90,36,.35);
            transition: filter .15s, transform .15s;
        }
        .btn-delete-confirm:hover { filter: brightness(1.08); transform: translateY(-1px); color:#fff; }
    </style>
</head>
<body>

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
            <a href="${pageContext.request.contextPath}/" class="btn btn-outline-secondary btn-sm">
                <i class="bi bi-house-door"></i> <spring:message code="nav.home"/>
            </a>
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

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="fw-bold mb-0">
                <i class="bi bi-trash3 text-danger"></i> <spring:message code="trash.title"/>
            </h3>
            <small class="text-muted"><spring:message code="trash.subtitle"/></small>
        </div>
        <span class="badge bg-secondary rounded-pill px-3 py-2">
            ${fn:length(urls)} <spring:message code="trash.records"/>
        </span>
    </div>

    <c:if test="${not empty info}">
        <div class="alert alert-success d-flex align-items-center" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>
            <div><c:out value="${info}"/></div>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-octagon-fill me-2"></i>
            <div><c:out value="${error}"/></div>
        </div>
    </c:if>

    <div class="card table-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                    <tr>
                        <th><spring:message code="admin.col.shortCode"/></th>
                        <th><spring:message code="admin.col.originalUrl"/></th>
                        <th><spring:message code="trash.col.deletedAt"/></th>
                        <th class="text-end"><spring:message code="admin.col.clicks"/></th>
                        <th class="text-end"><spring:message code="trash.col.actions"/></th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${empty urls}">
                            <tr>
                                <td colspan="5" class="text-center text-muted py-5">
                                    <i class="bi bi-trash3" style="font-size:1.5rem;"></i><br>
                                    <spring:message code="trash.empty"/>
                                </td>
                            </tr>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="url" items="${urls}">
                                <tr>
                                    <td class="fw-semibold"><c:out value="${url.shortCode}"/></td>
                                    <td class="url-cell" title="${url.originalUrl}">
                                        <span class="text-muted"><c:out value="${url.originalUrl}"/></span>
                                    </td>
                                    <td>
                                        <c:if test="${not empty url.deletedAt}">
                                            <c:out value="${fn:replace(fn:substring(url.deletedAt, 0, 16), 'T', ' ')}"/>
                                        </c:if>
                                    </td>
                                    <td class="text-end">
                                        <span class="badge bg-light text-dark">${url.clickCount}</span>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/urls/${url.id}/restore"
                                              method="post" class="d-inline m-0">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                            <button type="submit" class="btn btn-outline-success btn-sm">
                                                <i class="bi bi-arrow-counterclockwise"></i>
                                                <spring:message code="trash.restore"/>
                                            </button>
                                        </form>
                                        <button type="button" class="btn btn-outline-danger btn-sm"
                                                onclick="openDeleteModal(${url.id}, '${url.shortCode}', '${url.originalUrl}')">
                                            <i class="bi bi-x-lg"></i>
                                            <spring:message code="trash.delete.permanent"/>
                                        </button>
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

<!-- Kalıcı Silme Onay Modalı -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-labelledby="deleteConfirmLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:400px;">
        <div class="modal-content" style="border:none; border-radius:18px; box-shadow:0 24px 60px rgba(0,0,0,.18);">
            <div class="modal-body text-center p-4 pb-3">
                <div class="delete-modal-icon">
                    <i class="bi bi-trash3-fill"></i>
                </div>
                <h5 class="fw-bold mb-1" id="deleteConfirmLabel">Kalıcı Olarak Silinecek</h5>
                <p class="text-muted small mb-3">Bu işlem geri alınamaz. Link tamamen silinecek.</p>
                <div class="delete-modal-url mb-1">
                    <span class="fw-semibold text-danger" id="modalShortCode"></span>
                    <span class="mx-1 text-muted">→</span>
                    <span id="modalOriginalUrl"></span>
                </div>
            </div>
            <div class="modal-footer border-0 pt-0 pb-4 px-4 d-flex gap-2">
                <button type="button" class="btn btn-outline-secondary flex-grow-1 rounded-3"
                        data-bs-dismiss="modal">
                    <i class="bi bi-arrow-left me-1"></i> İptal
                </button>
                <form id="destroyForm" method="post" class="flex-grow-1 m-0">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn btn-delete-confirm w-100">
                        <i class="bi bi-trash3 me-1"></i> Kalıcı Sil
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    var contextPath = '${pageContext.request.contextPath}';

    function openDeleteModal(id, shortCode, originalUrl) {
        document.getElementById('modalShortCode').textContent  = '/' + shortCode;
        document.getElementById('modalOriginalUrl').textContent = originalUrl.length > 50
            ? originalUrl.substring(0, 50) + '…' : originalUrl;
        document.getElementById('destroyForm').action =
            contextPath + '/urls/' + id + '/destroy';
        new bootstrap.Modal(document.getElementById('deleteConfirmModal')).show();
    }
</script>
</body>
</html>
