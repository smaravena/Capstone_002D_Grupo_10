import { useState } from 'react'
import { Link } from 'react-router-dom'
import Logo from '../components/Logo'
import SocialIcons from '../components/SocialIcons'

const FEATURES = [
  {
    title: 'Diseño a medida',
    text: 'Convertimos tus ideas en prendas únicas, adaptadas a tu estilo y necesidades.',
    color: 'var(--pink)',
  },
  {
    title: 'Confección de calidad',
    text: 'Materiales y terminaciones cuidadas en cada punto, de la tela al producto final.',
    color: 'var(--blue)',
  },
  {
    title: 'Control de pedidos',
    text: 'Seguimiento claro del estado de cada pedido, desde el ingreso hasta la entrega.',
    color: 'var(--green)',
  },
  {
    title: 'Gestión de equipo',
    text: 'Administra a tu equipo del taller con roles y accesos según cada función.',
    color: 'var(--orange)',
  },
]

const FAQ_ITEMS = [
  {
    question: '¿Qué es Mil y Una Ideas?',
    answer:
      'Es la plataforma de gestión de nuestro taller: te permite administrar usuarios y pedidos de forma simple, todo en un solo lugar.',
  },
  {
    question: '¿Cómo ingreso al sistema?',
    answer:
      'Usa el botón "Iniciar sesión" en la parte superior derecha e ingresa el correo y la contraseña que te entregó tu taller.',
  },
  {
    question: '¿Puedo recuperar mi contraseña?',
    answer:
      'Próximamente. Por ahora, contacta a la persona encargada de administrar los usuarios de tu taller.',
  },
  {
    question: '¿Quién puede crear nuevos usuarios?',
    answer: 'Contenido de ejemplo: cualquier persona con acceso al módulo de Usuarios puede crear nuevas cuentas.',
  },
  {
    question: '¿Dónde veo el estado de mis pedidos?',
    answer: 'Contenido de ejemplo: dentro del módulo de Pedidos, una vez que iniciaste sesión.',
  },
]

export default function Landing() {
  const [openFaq, setOpenFaq] = useState(0)

  return (
    <div className="landing">
      <header className="landing-header">
        <Link to="/" className="landing-brand">
          <Logo size={52} />
        </Link>
        <nav className="landing-nav">
          <a href="#servicios">Servicios</a>
          <a href="#faq">Preguntas frecuentes</a>
          <a href="#contacto">Contacto</a>
        </nav>
        <Link to="/login" className="btn-login">
          Iniciar sesión
        </Link>
      </header>

      <section className="landing-hero">
        <div className="landing-hero-text">
          <h1>
            Mil <span className="amp">&amp;</span> Una Ideas
          </h1>
          <p className="landing-description">
            El taller de costura donde cada prenda nace de una idea. Gestiona tu equipo y tus pedidos en un
            solo lugar, de forma simple y ordenada.
          </p>
          <div className="landing-hero-actions">
            <a href="#servicios" className="btn-secondary">
              Conocer más
            </a>
          </div>
        </div>
        <div className="landing-hero-logo">
          <Logo size={180} />
        </div>
      </section>

      <section id="servicios" className="landing-features">
        <h2>Lo que hacemos</h2>
        <div className="landing-features-grid">
          {FEATURES.map((f) => (
            <div className="feature-card" key={f.title} style={{ '--card-color': f.color }}>
              <div className="feature-dot" />
              <h3>{f.title}</h3>
              <p>{f.text}</p>
            </div>
          ))}
        </div>
      </section>

      <section id="faq" className="landing-faq">
        <h2>Preguntas frecuentes</h2>
        <div className="faq-list">
          {FAQ_ITEMS.map((item, index) => {
            const isOpen = openFaq === index
            return (
              <div className={`faq-item ${isOpen ? 'open' : ''}`} key={item.question}>
                <button
                  type="button"
                  className="faq-question"
                  onClick={() => setOpenFaq(isOpen ? -1 : index)}
                  aria-expanded={isOpen}
                >
                  {item.question}
                  <span className="faq-icon">{isOpen ? '−' : '+'}</span>
                </button>
                {isOpen && <p className="faq-answer">{item.answer}</p>}
              </div>
            )
          })}
        </div>
      </section>

      <section id="contacto" className="landing-contact">
        <h2>Síguenos</h2>
        <p className="contact-subtitle">Encuéntranos también en nuestras redes sociales.</p>
        <SocialIcons />
      </section>

      <footer className="landing-footer">
        <Logo size={28} />
        <p>© {new Date().getFullYear()} Mil y Una Ideas · De tu imaginación a la tela</p>
      </footer>
    </div>
  )
}
