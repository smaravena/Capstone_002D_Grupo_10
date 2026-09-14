import { useCallback, useEffect, useRef, useState } from 'react'

export default function Carousel({ images, interval = 4000 }) {
  const [index, setIndex] = useState(0)
  const timerRef = useRef(null)

  const goTo = useCallback(
    (i) => {
      setIndex(((i % images.length) + images.length) % images.length)
    },
    [images.length],
  )

  const goNext = useCallback(() => goTo(index + 1), [goTo, index])
  const goPrev = useCallback(() => goTo(index - 1), [goTo, index])

  useEffect(() => {
    timerRef.current = setInterval(() => {
      setIndex((prev) => (prev + 1) % images.length)
    }, interval)
    return () => clearInterval(timerRef.current)
  }, [images.length, interval])

  return (
    <div className="carousel">
      <div className="carousel-viewport">
        <div className="carousel-track" style={{ transform: `translateX(-${index * 100}%)` }}>
          {images.map((src, i) => (
            <img key={src} src={src} alt={`Taller Mil y Una Ideas ${i + 1}`} className="carousel-slide" />
          ))}
        </div>

        <button type="button" className="carousel-arrow carousel-arrow-prev" onClick={goPrev} aria-label="Foto anterior">
          ‹
        </button>
        <button type="button" className="carousel-arrow carousel-arrow-next" onClick={goNext} aria-label="Foto siguiente">
          ›
        </button>
      </div>

      <div className="carousel-dots">
        {images.map((src, i) => (
          <button
            key={src}
            type="button"
            className={`carousel-dot ${i === index ? 'active' : ''}`}
            onClick={() => goTo(i)}
            aria-label={`Ir a la foto ${i + 1}`}
          />
        ))}
      </div>
    </div>
  )
}
