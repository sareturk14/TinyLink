<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"      uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:message code="auth.register.kvkkError" var="kvkkErrorMsg"/>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="auth.login.title"/></title>

    <link rel="icon" type="image/svg+xml"
          href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html, body { height: 100%; }
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #fff;
            background:
                linear-gradient(135deg, rgba(20, 18, 50, 0.65) 0%, rgba(40, 20, 70, 0.55) 100%),
                url('https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop') center/cover no-repeat fixed;
        }

        /* Dil butonu — sağ üst köşe */
        .lang-toggle {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 100;
        }
        .lang-toggle .btn {
            background: rgba(255,255,255,0.15);
            border: 1px solid rgba(255,255,255,0.3);
            color: #fff;
            font-size: .78rem;
            font-weight: 600;
            padding: .25rem .6rem;
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
        }
        .lang-toggle .btn.active,
        .lang-toggle .btn:hover {
            background: rgba(255,255,255,0.30);
            color: #fff;
        }

        .auth-shell {
            width: 100%;
            max-width: 440px;
            padding: 1rem;
        }

        .auth-card {
            border: 1px solid rgba(255, 255, 255, 0.22);
            border-radius: 22px;
            background: rgba(255, 255, 255, 0.10);
            backdrop-filter: blur(18px) saturate(140%);
            -webkit-backdrop-filter: blur(18px) saturate(140%);
            box-shadow: 0 24px 60px rgba(0, 0, 0, 0.35), inset 0 1px 0 rgba(255, 255, 255, 0.18);
            color: #fff;
        }

        .brand-icon-wrap {
            width: 68px; height: 68px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            margin: 0 auto;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.55);
            font-size: 2rem; color: #fff;
        }
        .brand-name {
            font-size: 2.1rem; font-weight: 800;
            background: linear-gradient(135deg, #c8d0ff 0%, #f0c0ff 100%);
            -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;
            letter-spacing: -0.03em; line-height: 1.1; margin-top: 0.5rem;
        }
        .brand-divider  { border-bottom: 1px solid rgba(255, 255, 255, 0.18); }
        .brand-slogan   { color: rgba(255,255,255,.78); font-size:.8rem; line-height:1.5; max-width:260px; margin:.5rem auto 0; }

        .auth-card h1          { color: #fff; }
        .auth-card .text-muted { color: rgba(255, 255, 255, 0.7) !important; }

        /* Floating label glass */
        .auth-card .form-floating > .form-control {
            background: rgba(255,255,255,0.10); border: 1px solid rgba(255,255,255,0.22);
            color: #fff; border-radius: 12px;
        }
        .auth-card .form-floating > .form-control:focus {
            background: rgba(255,255,255,0.16); border-color: rgba(180,170,255,0.7);
            color: #fff; box-shadow: 0 0 0 0.2rem rgba(140,130,230,0.25);
        }
        .auth-card .form-floating > .form-control::placeholder { color: transparent; }
        .auth-card .form-floating > label         { color: rgba(255,255,255,0.75); background: transparent !important; }
        .auth-card .form-floating > label::after  { background-color: transparent !important; }
        .auth-card .form-floating > .form-control:focus ~ label,
        .auth-card .form-floating > .form-control:not(:placeholder-shown) ~ label {
            color: rgba(255,255,255,0.95);
        }
        .auth-card input:-webkit-autofill,
        .auth-card input:-webkit-autofill:hover,
        .auth-card input:-webkit-autofill:focus,
        .auth-card input:-webkit-autofill:active {
            -webkit-text-fill-color: #fff !important;
            transition: background-color 9999s ease-in-out 0s !important;
            caret-color: #fff;
        }

        /* Şifre göster/gizle */
        .password-wrapper { position: relative; }
        .password-wrapper .form-control { padding-right: 2.8rem; }
        .toggle-pw {
            position: absolute; top: 50%; right: .75rem;
            transform: translateY(-50%);
            background: none; border: none;
            color: rgba(255,255,255,0.50); cursor: pointer;
            padding: .2rem; font-size: 1.05rem; line-height: 1; z-index: 5;
            transition: color .15s;
        }
        .toggle-pw:hover { color: rgba(255,255,255,0.95); }

        .btn-saas {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none; padding: 12px; font-weight: 600; color: #fff;
            border-radius: 12px;
            transition: transform .18s ease, box-shadow .18s ease, filter .18s ease;
            box-shadow: 0 8px 22px rgba(102,126,234,0.40);
        }
        .btn-saas:hover, .btn-saas:focus {
            color: #fff; transform: translateY(-2px);
            box-shadow: 0 12px 28px rgba(118,75,162,0.55); filter: brightness(1.05);
        }

        .auth-card a       { color: #d8d2ff; }
        .auth-card a:hover { color: #fff; }
        .alert { backdrop-filter: blur(6px); }

        /* Resend modal */
        .resend-modal-content {
            border: 1px solid rgba(255,255,255,0.22);
            border-radius: 22px;
            background: rgba(30, 25, 70, 0.82);
            backdrop-filter: blur(20px) saturate(140%);
            -webkit-backdrop-filter: blur(20px) saturate(140%);
            box-shadow: 0 24px 60px rgba(0,0,0,0.50);
            color: #fff;
        }
        .resend-modal-content .modal-header { border-bottom: 1px solid rgba(255,255,255,0.15); }
        .resend-modal-content .modal-footer { border-top:  1px solid rgba(255,255,255,0.15); }
        .resend-modal-content .modal-title  { color: #fff; }
        .resend-modal-content .btn-close    { filter: invert(1) brightness(1.5); }
        .resend-modal-content .form-control {
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.22);
            color: #fff; border-radius: 12px;
        }
        .resend-modal-content .form-control:focus {
            background: rgba(255,255,255,0.16);
            border-color: rgba(180,170,255,0.7);
            color: #fff; box-shadow: 0 0 0 0.2rem rgba(140,130,230,0.25);
        }
        .resend-modal-content .form-control::placeholder { color: rgba(255,255,255,0.45); }
        .resend-modal-content label { color: rgba(255,255,255,0.80); }
        .resend-modal-content .btn-outline-light {
            border-color: rgba(255,255,255,0.35); color: rgba(255,255,255,0.80);
        }
        .resend-modal-content .btn-outline-light:hover { background: rgba(255,255,255,0.12); color: #fff; }
    </style>
</head>
<body>

    <!-- Dil Butonu -->
    <div class="lang-toggle btn-group btn-group-sm" role="group">
        <a href="?lang=tr"
           class="btn ${pageContext.response.locale.language == 'tr' ? 'active' : ''}">
            <spring:message code="lang.tr"/>
        </a>
        <a href="?lang=en"
           class="btn ${pageContext.response.locale.language == 'en' ? 'active' : ''}">
            <spring:message code="lang.en"/>
        </a>
    </div>

    <div class="auth-shell">
        <div class="card auth-card">
            <div class="card-body p-4 p-md-5">

                <!-- Brand -->
                <div class="text-center mb-4 pb-3 brand-divider">
                    <div class="brand-icon-wrap">
                        <i class="bi bi-link-45deg"></i>
                    </div>
                    <div class="brand-name"><spring:message code="auth.brand.name"/></div>
                    <div class="brand-slogan"><spring:message code="auth.brand.slogan"/></div>
                </div>

                <div class="text-center mb-4">
                    <h1 class="h4 fw-bold mb-1"><spring:message code="auth.login.welcome"/></h1>
                    <p class="text-muted small mb-0"><spring:message code="auth.login.subtitle"/></p>
                </div>

                <%-- Resend verification flash mesajları --%>
                <c:if test="${resendSuccess}">
                    <div class="alert alert-success py-2" role="alert">
                        <i class="bi bi-check-circle me-1"></i><spring:message code="auth.resend.success"/>
                    </div>
                </c:if>
                <c:if test="${resendError == 'NOT_FOUND'}">
                    <div class="alert alert-warning py-2" role="alert">
                        <spring:message code="auth.resend.error.notFound"/>
                    </div>
                </c:if>
                <c:if test="${resendError == 'ALREADY_VERIFIED'}">
                    <div class="alert alert-info py-2" role="alert">
                        <spring:message code="auth.resend.error.alreadyVerified"/>
                    </div>
                </c:if>

                <c:if test="${param.error != null}">
                    <c:choose>
                        <c:when test="${param.error == 'invalid_token'}">
                            <div class="alert alert-danger py-2" role="alert">
                                <spring:message code="auth.login.error.invalidToken"/>
                            </div>
                        </c:when>
                        <c:when test="${param.error == 'locked'}">
                            <div class="alert alert-danger py-2" role="alert">
                                <i class="bi bi-ban me-1"></i>
                                <spring:message code="auth.login.error.locked"/>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-danger py-2" role="alert">
                                <spring:message code="auth.login.error.default"/>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </c:if>
                <c:if test="${param.verified != null}">
                    <div class="alert alert-success py-2" role="alert">
                        <spring:message code="auth.login.success.verified"/>
                    </div>
                </c:if>
                <c:if test="${param.registered != null}">
                    <div class="alert alert-success py-2" role="alert">
                        <spring:message code="auth.login.success.registered"/>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="form-floating mb-3">
                        <input type="email" class="form-control"
                               id="email" name="email" required autofocus
                               autocomplete="email" placeholder=" ">
                        <label for="email"><spring:message code="auth.login.emailLabel"/></label>
                    </div>
                    <div class="password-wrapper mb-4">
                        <div class="form-floating">
                            <input type="password" class="form-control"
                                   id="password" name="password" required
                                   autocomplete="current-password" placeholder=" ">
                            <label for="password"><spring:message code="auth.login.passwordLabel"/></label>
                        </div>
                        <button type="button" class="toggle-pw" id="toggleLoginPw">
                            <i class="bi bi-eye"></i>
                        </button>
                    </div>
                    <button type="submit" class="btn btn-saas w-100">
                        <spring:message code="auth.login.button"/>
                    </button>
                </form>

                <hr class="my-4" style="border-color: rgba(255,255,255,0.2);">

                <p class="text-center small mb-0" style="color: rgba(255,255,255,0.8);">
                    <spring:message code="auth.login.noAccount"/>
                    <a href="${pageContext.request.contextPath}/register" class="text-decoration-none fw-semibold">
                        <spring:message code="auth.login.registerLink"/>
                    </a>
                </p>

                <p class="text-center small mt-2 mb-0" style="color: rgba(255,255,255,0.55);">
                    <spring:message code="auth.resend.link"/>
                    <a href="#" class="text-decoration-none fw-semibold"
                       style="color: rgba(200,191,255,0.85);"
                       data-bs-toggle="modal" data-bs-target="#resendModal">
                        <spring:message code="auth.resend.linkAction"/>
                    </a>
                </p>
            </div>
        </div>
    </div>

<!-- Resend Verification Modal -->
<div class="modal fade" id="resendModal" tabindex="-1" aria-labelledby="resendModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content resend-modal-content">
            <div class="modal-header">
                <h5 class="modal-title fw-bold" id="resendModalLabel">
                    <i class="bi bi-envelope-check me-2"></i><spring:message code="auth.resend.modal.title"/>
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Kapat"></button>
            </div>
            <form action="${pageContext.request.contextPath}/auth/resend-verification" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-body py-4">
                    <p class="mb-3" style="color: rgba(255,255,255,0.75); font-size:.88rem;">
                        <spring:message code="auth.resend.modal.body"/>
                    </p>
                    <div class="form-floating">
                        <input type="email" class="form-control" id="resendEmail" name="email"
                               required placeholder=" " autocomplete="email">
                        <label for="resendEmail"><spring:message code="auth.resend.modal.emailLabel"/></label>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-light btn-sm px-3"
                            data-bs-dismiss="modal">
                        <spring:message code="auth.resend.modal.cancel"/>
                    </button>
                    <button type="submit" class="btn btn-saas px-4">
                        <i class="bi bi-send me-1"></i><spring:message code="auth.resend.modal.button"/>
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.getElementById('toggleLoginPw').addEventListener('click', function () {
        var input = document.getElementById('password');
        var icon  = this.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    });
</script>
</body>
</html>
