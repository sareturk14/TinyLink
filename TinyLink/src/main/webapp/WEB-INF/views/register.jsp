<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"      uri="jakarta.tags.core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<spring:message code="auth.register.kvkkError"      var="kvkkErrorMsg"/>
<spring:message code="auth.register.emailError"    var="emailErrorMsg"/>
<spring:message code="auth.register.passwordError" var="passwordErrorMsg"/>
<spring:message code="auth.register.error.weakPassword"    var="weakPasswordMsg"/>
<spring:message code="auth.register.error.passwordMismatch" var="passwordMismatchMsg"/>
<spring:message code="auth.register.confirmPasswordLabel"   var="confirmPasswordLabelMsg"/>
<spring:message code="auth.register.confirmPasswordError"   var="confirmPasswordErrorMsg"/>
<spring:message code="auth.password.toggleLabel"            var="togglePwLabel"/>
<!DOCTYPE html>
<html lang="${pageContext.response.locale.language}">
<head>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 64 64'><defs><linearGradient id='g' x1='0' y1='0' x2='1' y2='1'><stop offset='0' stop-color='%23667eea'/><stop offset='1' stop-color='%23764ba2'/></linearGradient></defs><rect width='64' height='64' rx='14' fill='url(%23g)'/><path d='M25 39a8 8 0 0 1 0-11l5-5a8 8 0 0 1 11 0 1 1 0 1 1-1.4 1.4 6 6 0 0 0-8.2 0l-5 5a6 6 0 0 0 0 8.2 1 1 0 1 1-1.4 1.4z' fill='%23ffffff'/><path d='M39 25a8 8 0 0 1 0 11l-5 5a8 8 0 0 1-11 0 1 1 0 1 1 1.4-1.4 6 6 0 0 0 8.2 0l5-5a6 6 0 0 0 0-8.2 1 1 0 1 1 1.4-1.4z' fill='%23ffffff'/><path d='M46 14l1.5 3.5L51 19l-3.5 1.5L46 24l-1.5-3.5L41 19l3.5-1.5z' fill='%23ffd86b'/></svg>">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><spring:message code="auth.register.title"/></title>


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
            max-width: 460px;
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
        .brand-divider { border-bottom: 1px solid rgba(255, 255, 255, 0.18); }
        .brand-slogan  { color: rgba(255,255,255,.78); font-size:.8rem; line-height:1.5; max-width:280px; margin:.5rem auto 0; }

        .auth-card h1          { color: #fff; }
        .auth-card .text-muted { color: rgba(255, 255, 255, 0.7) !important; }
        .auth-card .form-text  { color: rgba(255, 255, 255, 0.65); }

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

        /* KVKK onay kutusu */
        .kvkk-check {
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 12px;
            padding: .75rem 1rem;
        }
        .kvkk-check.is-invalid { border-color: rgba(255,100,100,0.7) !important; }
        .kvkk-check .form-check-input {
            background-color: rgba(255,255,255,0.12);
            border-color: rgba(255,255,255,0.4);
            flex-shrink: 0; margin-top: 3px;
        }
        .kvkk-check .form-check-input:checked {
            background-color: #667eea; border-color: #667eea;
        }
        .kvkk-check .form-check-label {
            color: rgba(255,255,255,0.82); font-size:.8rem; line-height:1.45;
        }
        .kvkk-error {
            color: #ff8a8a; font-size: .78rem; margin-top: .4rem;
            display: none;
        }
        .kvkk-error.visible { display: block; }

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
        .kvkk-link { color: #c8bfff; text-decoration: underline dotted; text-underline-offset: 3px; }
        .kvkk-link:hover { color: #fff; }

        /* KVKK Modal */
        .kvkk-modal-content {
            border-radius: 18px; border: none;
            box-shadow: 0 24px 60px rgba(0,0,0,0.45);
        }
        .kvkk-modal-content .modal-header { padding: 1.5rem 1.5rem .5rem; }
        .kvkk-modal-content .modal-body   { padding: .75rem 1.5rem 1rem; }
        .kvkk-modal-content .modal-footer { padding: .5rem 1.5rem 1.25rem; }
        .kvkk-highlight {
            background: #f0eeff; border-left: 3px solid #667eea;
            border-radius: 8px; padding: .85rem 1rem; margin: .5rem 0;
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

        .auth-card .form-floating > .form-control.is-invalid {
            border-color: rgba(255, 90, 90, 0.75) !important;
            box-shadow: 0 0 0 0.2rem rgba(255, 80, 80, 0.18) !important;
        }
        .field-error {
            color: #ff8a8a; font-size: .78rem; margin-top: .35rem;
            display: none;
        }
        .field-error.visible { display: block; }

        .alert { backdrop-filter: blur(6px); }
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
                    <h1 class="h4 fw-bold mb-1"><spring:message code="auth.register.heading"/></h1>
                    <p class="text-muted small mb-0"><spring:message code="auth.register.subtitle"/></p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger py-2" role="alert">
                        <c:choose>
                            <c:when test="${error == 'weak_password'}">
                                ${weakPasswordMsg}
                            </c:when>
                            <c:when test="${error == 'password_mismatch'}">
                                ${passwordMismatchMsg}
                            </c:when>
                            <c:otherwise>
                                <c:out value="${error}"/>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:if>

                <form id="registerForm" action="${pageContext.request.contextPath}/register" method="post" novalidate>
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                    <div class="form-floating mb-3">
                        <input type="text" class="form-control"
                               id="username" name="username" required autofocus minlength="3" maxlength="50"
                               autocomplete="username" placeholder=" "
                               value="<c:out value='${username}'/>">
                        <label for="username"><spring:message code="auth.register.usernameLabel"/></label>
                    </div>
                    <div class="mb-3">
                        <div class="form-floating">
                            <input type="email" class="form-control"
                                   id="email" name="email" required maxlength="120"
                                   autocomplete="email" placeholder=" "
                                   value="<c:out value='${email}'/>">
                            <label for="email"><spring:message code="auth.register.emailLabel"/></label>
                        </div>
                        <div class="field-error" id="emailError">
                            <i class="bi bi-exclamation-circle me-1"></i>${emailErrorMsg}
                        </div>
                    </div>
                    <div class="mb-3">
                        <div class="password-wrapper">
                            <div class="form-floating">
                                <input type="password" class="form-control"
                                       id="password" name="password" required minlength="6"
                                       autocomplete="new-password" placeholder=" ">
                                <label for="password"><spring:message code="auth.register.passwordLabel"/></label>
                            </div>
                            <button type="button" class="toggle-pw" id="togglePw" aria-label="${togglePwLabel}">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="form-text mt-1" id="passwordHint"><spring:message code="auth.register.passwordHint"/></div>
                        <div class="field-error" id="passwordError">
                            <i class="bi bi-exclamation-circle me-1"></i>${passwordErrorMsg}
                        </div>
                    </div>
                    <div class="mb-4">
                        <div class="password-wrapper">
                            <div class="form-floating">
                                <input type="password" class="form-control"
                                       id="confirmPassword" name="confirmPassword" required
                                       autocomplete="new-password" placeholder=" ">
                                <label for="confirmPassword">${confirmPasswordLabelMsg}</label>
                            </div>
                            <button type="button" class="toggle-pw" id="toggleConfirmPw" aria-label="${togglePwLabel}">
                                <i class="bi bi-eye"></i>
                            </button>
                        </div>
                        <div class="field-error" id="confirmPasswordError">
                            <i class="bi bi-exclamation-circle me-1"></i>${confirmPasswordErrorMsg}
                        </div>
                    </div>

                    <div class="kvkk-check mb-1" id="kvkkBox">
                        <div class="form-check d-flex gap-2 align-items-start">
                            <input class="form-check-input" type="checkbox" id="kvkk" name="kvkk">
                            <label class="form-check-label" for="kvkk">
                                <spring:message code="auth.register.kvkkPrefix"/>
                                <a href="#" class="kvkk-link" data-bs-toggle="modal" data-bs-target="#kvkkModal"
                                   onclick="return false;"><strong><spring:message code="auth.register.kvkkLinkText"/></strong></a>.
                            </label>
                        </div>
                    </div>
                    <div class="kvkk-error mb-3" id="kvkkError">
                        <i class="bi bi-exclamation-circle me-1"></i><spring:message code="auth.register.kvkkError"/>
                    </div>

                    <button type="submit" class="btn btn-saas w-100">
                        <spring:message code="auth.register.button"/>
                    </button>
                </form>

                <hr class="my-4" style="border-color: rgba(255,255,255,0.2);">

                <p class="text-center small mb-0" style="color: rgba(255,255,255,0.8);">
                    <spring:message code="auth.register.hasAccount"/>
                    <a href="${pageContext.request.contextPath}/login" class="text-decoration-none fw-semibold">
                        <spring:message code="auth.register.loginLink"/>
                    </a>
                </p>
            </div>
        </div>
    </div>

<!-- KVKK Modal -->
<div class="modal fade" id="kvkkModal" tabindex="-1" aria-labelledby="kvkkModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content kvkk-modal-content">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold" id="kvkkModalLabel">
                    <i class="bi bi-shield-check me-2 text-primary"></i>KVKK Aydınlatma Metni
                </h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Kapat"></button>
            </div>
            <div class="modal-body pt-2" style="font-size:.92rem; line-height:1.75; color:#1a1a2e;">

                <p class="text-muted mb-3" style="font-size:.82rem;">
                    Son güncelleme: Mayıs 2025 &nbsp;·&nbsp; 6698 sayılı KVKK kapsamında hazırlanmıştır.
                </p>

                <h6 class="fw-bold mt-3">1. Veri Sorumlusu</h6>
                <p>
                    <strong>TinyLink</strong> platformu ("Platform") olarak, 6698 sayılı Kişisel Verilerin Korunması
                    Kanunu ("KVKK") uyarınca kişisel verilerinizi işlemekten sorumlu veri sorumlusuyuz.
                    Platform yalnızca eğitim ve akademik amaçlıdır.
                </p>

                <h6 class="fw-bold mt-3">2. İşlenen Kişisel Veriler</h6>
                <ul>
                    <li><strong>Hesap bilgileri:</strong> Kullanıcı adı, e-posta adresi ve şifrenizin güvenli hash'i kayıt sırasında toplanır.</li>
                    <li><strong>Girilen URL'ler:</strong> Kısaltılmak üzere platforma ilettiğiniz bağlantılar işlenir ve veritabanımızda saklanır.</li>
                    <li><strong>Kullanım istatistikleri:</strong> Kısaltılmış bağlantıların tıklanma sayısı ve tarihleri anonim olarak tutulur.</li>
                    <li><strong>Teknik veriler:</strong> Oturum bilgileri ve CSRF token'ları güvenlik amacıyla geçici olarak tutulur.</li>
                </ul>

                <h6 class="fw-bold mt-3">3. Veri İşleme Amaçları</h6>
                <ul>
                    <li>Platforma üyelik oluşturulması ve kimlik doğrulaması</li>
                    <li>URL kısaltma hizmetinin sunulması</li>
                    <li>Kısaltılan bağlantıların içerik özetinin otomatik olarak oluşturulması</li>
                    <li>Platforma giriş yapan kullanıcıların bağlantı geçmişinin yönetilmesi</li>
                </ul>

                <h6 class="fw-bold mt-3">4. Google Gemini API ile Veri Paylaşımı</h6>
                <div class="kvkk-highlight">
                    <p class="mb-2">
                        <i class="bi bi-google me-1"></i>
                        Platforma ilettiğiniz <strong>URL adresleri</strong>, o bağlantının içeriğine dair
                        kısa bir özet oluşturmak amacıyla <strong>Google Gemini API</strong>'ye iletilmektedir.
                    </p>
                    <ul class="mb-0">
                        <li>Bu işlem sırasında yalnızca URL kendisi paylaşılmakta; adınız, e-postanız veya diğer kişisel bilgileriniz Google'a aktarılmamaktadır.</li>
                        <li>Google Gemini API hizmet şartları ve gizlilik politikası Google LLC tarafından belirlenmektedir.</li>
                        <li>Gemini API kullanımı devre dışı bırakılamaz; kısaltma hizmeti bu bütünleşik yapı üzerinde çalışmaktadır.</li>
                    </ul>
                </div>

                <h6 class="fw-bold mt-3">5. Yasal Dayanak</h6>
                <p>
                    Kişisel verileriniz; <em>KVKK Madde 5/2-c</em> (sözleşmenin ifası) ve
                    <em>Madde 5/2-f</em> (meşru menfaat) kapsamında, açık rızanızla işlenmektedir.
                    Google Gemini API'ye aktarım ise <em>Madde 9</em> uyarınca açık rızanıza dayanmaktadır.
                </p>

                <h6 class="fw-bold mt-3">6. Saklama Süresi</h6>
                <ul>
                    <li>Hesabınız aktif olduğu sürece verileriniz saklanır.</li>
                    <li>Hesabı silinen kullanıcılara ait URL kayıtları 30 gün içinde kalıcı olarak silinir.</li>
                    <li>Çöp kutusuna taşınan URL'ler 7 gün sonra otomatik olarak silinir.</li>
                </ul>

                <h6 class="fw-bold mt-3">7. KVKK Kapsamındaki Haklarınız</h6>
                <p>KVKK Madde 11 uyarınca aşağıdaki haklara sahipsiniz:</p>
                <ul>
                    <li>Kişisel verilerinizin işlenip işlenmediğini öğrenme</li>
                    <li>İşlenmişse buna ilişkin bilgi talep etme</li>
                    <li>Verilerin düzeltilmesini veya silinmesini isteme</li>
                    <li>Verilerin aktarıldığı üçüncü kişilerin bildirilmesini talep etme</li>
                    <li>İşlemenin otomatik sistemlerle analiz edilmesi nedeniyle aleyhine çıkan sonuca itiraz etme</li>
                </ul>

                <p class="text-muted mt-3 mb-0" style="font-size:.8rem;">
                    Bu platformun yalnızca akademik/eğitim amaçlı çalıştığını ve ticari bir varlığı temsil
                    etmediğini hatırlatırız. Sorularınız için platform yöneticisiyle iletişime geçebilirsiniz.
                </p>
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-saas px-4" data-bs-dismiss="modal">
                    Anladım, Kapat
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    /* ── Toggle password visibility ── */
    function togglePassword(inputId, btn) {
        var input = document.getElementById(inputId);
        var icon  = btn.querySelector('i');
        if (input.type === 'password') {
            input.type = 'text';
            icon.classList.replace('bi-eye', 'bi-eye-slash');
        } else {
            input.type = 'password';
            icon.classList.replace('bi-eye-slash', 'bi-eye');
        }
    }
    document.getElementById('togglePw').addEventListener('click', function () {
        togglePassword('password', this);
    });
    document.getElementById('toggleConfirmPw').addEventListener('click', function () {
        togglePassword('confirmPassword', this);
    });

    /* ── Instant validation ── */
    const emailInput    = document.getElementById('email');
    const emailError    = document.getElementById('emailError');
    const passwordInput = document.getElementById('password');
    const passwordError = document.getElementById('passwordError');
    const passwordHint  = document.getElementById('passwordHint');
    const confirmInput  = document.getElementById('confirmPassword');
    const confirmError  = document.getElementById('confirmPasswordError');
    const EMAIL_RE      = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    const PASSWORD_RE   = /^(?=.*[A-Z]).{6,}$/;

    function setEmailState(invalid) {
        emailInput.classList.toggle('is-invalid', invalid);
        emailError.classList.toggle('visible', invalid);
    }
    function setPasswordState(invalid) {
        passwordInput.classList.toggle('is-invalid', invalid);
        passwordError.classList.toggle('visible', invalid);
        if (passwordHint) passwordHint.style.display = invalid ? 'none' : '';
    }
    function setConfirmState(invalid) {
        confirmInput.classList.toggle('is-invalid', invalid);
        confirmError.classList.toggle('visible', invalid);
    }

    emailInput.addEventListener('input', function () {
        if (this.value.length > 0) setEmailState(!EMAIL_RE.test(this.value));
        else setEmailState(false);
    });
    passwordInput.addEventListener('input', function () {
        if (this.value.length > 0) setPasswordState(!PASSWORD_RE.test(this.value));
        else setPasswordState(false);
        if (confirmInput.value.length > 0) setConfirmState(confirmInput.value !== this.value);
    });
    confirmInput.addEventListener('input', function () {
        if (this.value.length > 0) setConfirmState(this.value !== passwordInput.value);
        else setConfirmState(false);
    });

    /* ── Submit validation ── */
    document.getElementById('registerForm').addEventListener('submit', function (e) {
        var valid = true;
        if (!EMAIL_RE.test(emailInput.value))          { setEmailState(true);    valid = false; }
        if (!PASSWORD_RE.test(passwordInput.value))    { setPasswordState(true); valid = false; }
        if (confirmInput.value !== passwordInput.value){ setConfirmState(true);  valid = false; }
        var cb  = document.getElementById('kvkk');
        var box = document.getElementById('kvkkBox');
        var err = document.getElementById('kvkkError');
        if (!cb.checked) { box.classList.add('is-invalid'); err.classList.add('visible'); valid = false; }
        if (!valid) e.preventDefault();
    });

    document.getElementById('kvkk').addEventListener('change', function () {
        if (this.checked) {
            document.getElementById('kvkkBox').classList.remove('is-invalid');
            document.getElementById('kvkkError').classList.remove('visible');
        }
    });
</script>
</body>
</html>
