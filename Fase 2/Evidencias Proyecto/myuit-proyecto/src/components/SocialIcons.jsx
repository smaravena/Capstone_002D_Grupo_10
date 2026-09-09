const SOCIAL_LINKS = [
  {
    name: 'WhatsApp',
    url: 'https://whatsapp.com',
    color: 'var(--green)',
    Icon: (props) => (
      <svg viewBox="0 0 24 24" fill="currentColor" {...props}>
        <path d="M12 2C6.48 2 2 6.48 2 12c0 1.85.5 3.58 1.35 5.05L2 22l5.13-1.32A9.94 9.94 0 0 0 12 22c5.52 0 10-4.48 10-10S17.52 2 12 2Zm0 18c-1.68 0-3.25-.46-4.6-1.26l-.33-.2-3.05.78.8-2.97-.21-.31A7.93 7.93 0 0 1 4 12c0-4.41 3.59-8 8-8s8 3.59 8 8-3.59 8-8 8Zm4.34-5.61c-.24-.12-1.42-.7-1.64-.78-.22-.08-.38-.12-.54.12-.16.24-.62.78-.76.94-.14.16-.28.18-.52.06-.24-.12-1-.37-1.9-1.17-.7-.62-1.17-1.39-1.31-1.63-.14-.24-.02-.37.1-.49.11-.12.24-.3.36-.45.12-.15.16-.26.24-.43.08-.17.04-.31-.03-.43-.07-.12-.6-1.45-.82-1.98-.22-.53-.44-.46-.6-.47h-.51c-.17 0-.44.06-.68.32-.24.26-.9.88-.9 2.14 0 1.26.92 2.48 1.05 2.65.13.17 1.78 2.72 4.32 3.71 2.14.83 2.57.67 3.03.63.46-.04 1.42-.58 1.62-1.14.2-.56.2-1.04.14-1.14-.06-.1-.22-.16-.46-.28Z" />
      </svg>
    ),
  },
  {
    name: 'Instagram',
    url: 'https://instagram.com',
    color: 'var(--pink)',
    Icon: (props) => (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" {...props}>
        <rect x="2.5" y="2.5" width="19" height="19" rx="5.5" />
        <circle cx="12" cy="12" r="4.3" />
        <circle cx="17.4" cy="6.6" r="1.1" fill="currentColor" stroke="none" />
      </svg>
    ),
  },
  {
    name: 'TikTok',
    url: 'https://tiktok.com',
    color: 'var(--ink)',
    Icon: (props) => (
      <svg viewBox="0 0 24 24" fill="currentColor" {...props}>
        <path d="M16.5 2c.24 2.02 1.5 3.6 3.5 3.86v2.72c-1.25.08-2.44-.3-3.5-1.03v6.86c0 2.86-2.32 5.19-5.19 5.19S6.12 17.27 6.12 14.41c0-2.77 2.21-5.03 4.97-5.18v2.75c-1.2.14-2.13 1.15-2.13 2.4 0 1.34 1.09 2.43 2.44 2.43s2.44-1.09 2.44-2.43V2h2.66Z" />
      </svg>
    ),
  },
]

export default function SocialIcons({ className = '' }) {
  return (
    <div className={`social-icons ${className}`}>
      {SOCIAL_LINKS.map(({ name, url, color, Icon }) => (
        <a
          key={name}
          href={url}
          target="_blank"
          rel="noopener noreferrer"
          className="social-icon"
          style={{ '--icon-color': color }}
          aria-label={name}
        >
          <Icon width={22} height={22} />
        </a>
      ))}
    </div>
  )
}
