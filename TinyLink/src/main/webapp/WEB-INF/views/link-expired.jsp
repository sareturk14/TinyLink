<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="tr">
<head>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Linkin Süresi Dolmuş | URL Kısaltıcı</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex; align-items: center;
        }
        .expired-card {
            border: none; border-radius: 18px;
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.18);
        }
        .expired-icon {
            width: 88px; height: 88px; border-radius: 50%;
            background: #fff5e1; color: #b27500;
            display: inline-flex; align-items: center; justify-content: center;
            font-size: 2.4rem;
        }
    </style>
</head>
<body>
<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card expired-card">
                <div class="card-body p-5 text-center">
                    <div class="expired-icon mb-3">
                        <i class="bi bi-hourglass-bottom"></i>
                    </div>
                    <h2 class="fw-bold mb-2">Bu linkin süresi dolmuştur</h2>
                    <p class="text-muted">
                        <c:if test="${not empty shortCode}">
                            <code>/<c:out value="${shortCode}"/></code> kısa kodu artık geçerli değil.<br>
                        </c:if>
                        Link sahibi bu adrese bir geçerlilik süresi tanımlamış ve süre dolmuş.
                    </p>
                    <a href="${pageContext.request.contextPath}/" class="btn btn-primary mt-3">
                        <i class="bi bi-house-door"></i> Ana Sayfaya Dön
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
