
export function Mascot({ size = 140, className = "", floaty = false }: { size?: number; className?: string; floaty?: boolean }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 200 200"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={`${className} ${floaty ? "animate-floaty" : ""}`}
      aria-label="Téo, o mascote do Educate"
    >
      <defs>
        <linearGradient id="bearBody" x1="40" y1="30" x2="160" y2="190" gradientUnits="userSpaceOnUse">
          <stop stopColor="#a878e6" />
          <stop offset="0.5" stopColor="#6130ab" />
          <stop offset="1" stopColor="#4a2484" />
        </linearGradient>
        <linearGradient id="bearInner" x1="100" y1="92" x2="100" y2="185" gradientUnits="userSpaceOnUse">
          <stop stopColor="#F8F3FF" />
          <stop offset="1" stopColor="#E6DAFB" />
        </linearGradient>
        <radialGradient id="bearGlow" cx="0.35" cy="0.3" r="0.7">
          <stop stopColor="#ffffff" stopOpacity="0.35" />
          <stop offset="1" stopColor="#ffffff" stopOpacity="0" />
        </radialGradient>
      </defs>

      <ellipse cx="100" cy="191" rx="46" ry="7" fill="#2B2540" opacity="0.10" />

      <circle cx="59" cy="57" r="21" fill="url(#bearBody)" />
      <circle cx="141" cy="57" r="21" fill="url(#bearBody)" />
      <circle cx="59" cy="57" r="11" fill="url(#bearInner)" />
      <circle cx="141" cy="57" r="11" fill="url(#bearInner)" />
      <circle cx="59" cy="58" r="6" fill="#FFB6C9" opacity="0.5" />
      <circle cx="141" cy="58" r="6" fill="#FFB6C9" opacity="0.5" />

      <path d="M58 152c0-28 18-37 42-37s42 9 42 37c0 30-20 38-42 38s-42-8-42-38Z" fill="url(#bearBody)" />

      <ellipse cx="100" cy="159" rx="27" ry="24" fill="url(#bearInner)" />

      <ellipse cx="79" cy="185" rx="12" ry="8" fill="url(#bearBody)" />
      <ellipse cx="121" cy="185" rx="12" ry="8" fill="url(#bearBody)" />
      <ellipse cx="79" cy="186" rx="6" ry="3.6" fill="#EFE6FF" />
      <ellipse cx="121" cy="186" rx="6" ry="3.6" fill="#EFE6FF" />

      <ellipse cx="70" cy="150" rx="12" ry="15" fill="url(#bearBody)" />
      <ellipse cx="130" cy="150" rx="12" ry="15" fill="url(#bearBody)" />
      <circle cx="82" cy="160" r="10" fill="url(#bearBody)" />
      <circle cx="118" cy="160" r="10" fill="url(#bearBody)" />
      <g fill="#4a2484" opacity="0.35">
        <circle cx="82" cy="160" r="3.4" />
        <circle cx="78" cy="156" r="1.6" />
        <circle cx="86" cy="156" r="1.6" />
        <circle cx="118" cy="160" r="3.4" />
        <circle cx="114" cy="156" r="1.6" />
        <circle cx="122" cy="156" r="1.6" />
      </g>

      <circle cx="100" cy="98" r="54" fill="url(#bearBody)" />

      <circle cx="100" cy="98" r="54" fill="url(#bearGlow)" />

      <ellipse cx="100" cy="115" rx="31" ry="24" fill="url(#bearInner)" />

      <circle cx="63" cy="111" r="8" fill="#FF8FB1" opacity="0.4" />
      <circle cx="137" cy="111" r="8" fill="#FF8FB1" opacity="0.4" />

      <ellipse cx="80" cy="89" rx="8" ry="9.5" fill="#2B2540" />
      <ellipse cx="120" cy="89" rx="8" ry="9.5" fill="#2B2540" />
      <circle cx="83" cy="85" r="3.2" fill="#fff" />
      <circle cx="123" cy="85" r="3.2" fill="#fff" />
      <circle cx="78" cy="92" r="1.5" fill="#fff" opacity="0.7" />
      <circle cx="118" cy="92" r="1.5" fill="#fff" opacity="0.7" />

      <path d="M72 76c4-3 11-3 15 0" stroke="#4a2484" strokeWidth="2.6" strokeLinecap="round" opacity="0.5" />
      <path d="M113 76c4-3 11-3 15 0" stroke="#4a2484" strokeWidth="2.6" strokeLinecap="round" opacity="0.5" />

      <ellipse cx="100" cy="105" rx="9.5" ry="7" fill="#3a1c66" />
      <ellipse cx="96.5" cy="102.5" rx="2.4" ry="1.6" fill="#fff" opacity="0.55" />
      <path d="M100 112v6.5" stroke="#3a1c66" strokeWidth="3" strokeLinecap="round" />
      <path d="M100 118.5c-5 6-13 5-15.5-1" stroke="#3a1c66" strokeWidth="3" strokeLinecap="round" fill="none" />
      <path d="M100 118.5c5 6 13 5 15.5-1" stroke="#3a1c66" strokeWidth="3" strokeLinecap="round" fill="none" />

      <g>
        <path d="M100 38l-34 12 34 12 34-12-34-12Z" fill="#221c33" opacity="0.3" />
        <path d="M76 50q24 15 48 0v8q0 9-24 9t-24-9v-8Z" fill="#3a2b57" />
        <path d="M100 22L48 41l52 19 52-19-52-19Z" fill="#2B2540" />
        <path d="M100 22L48 41l52 19 22-8-44-16 22-8Z" fill="#3a3357" opacity="0.6" />
        <circle cx="100" cy="41" r="4.5" fill="#FFC800" />
        <path d="M152 41c4 8 3 18 0 26" stroke="#FFC800" strokeWidth="3.4" strokeLinecap="round" />
        <circle cx="152" cy="70" r="5.5" fill="#FFC800" />
        <circle cx="152" cy="70" r="2.4" fill="#e6a700" />
      </g>
    </svg>
  );
}

export function MascotMark({ size = 40, className = "" }: { size?: number; className?: string }) {
  return (
    <svg width={size} height={size} viewBox="0 0 100 100" fill="none" className={className} aria-hidden>
      <defs>
        <linearGradient id="markBear" x1="20" y1="14" x2="82" y2="92" gradientUnits="userSpaceOnUse">
          <stop stopColor="#a878e6" />
          <stop offset="1" stopColor="#6130ab" />
        </linearGradient>
      </defs>
      <circle cx="31" cy="31" r="12" fill="url(#markBear)" />
      <circle cx="69" cy="31" r="12" fill="url(#markBear)" />
      <circle cx="31" cy="31" r="6" fill="#EFE6FF" />
      <circle cx="69" cy="31" r="6" fill="#EFE6FF" />
      <circle cx="50" cy="54" r="30" fill="url(#markBear)" />
      <ellipse cx="50" cy="63" rx="17" ry="13" fill="#EFE6FF" />
      <circle cx="39" cy="49" r="4.6" fill="#2B2540" />
      <circle cx="61" cy="49" r="4.6" fill="#2B2540" />
      <circle cx="40.5" cy="47.5" r="1.6" fill="#fff" />
      <circle cx="62.5" cy="47.5" r="1.6" fill="#fff" />
      <ellipse cx="50" cy="58" rx="5" ry="3.6" fill="#3a1c66" />
      <path d="M50 18L26 27l24 9 24-9-24-9Z" fill="#2B2540" />
      <path d="M70 27v11" stroke="#FFC800" strokeWidth="3" strokeLinecap="round" />
      <circle cx="70" cy="40" r="3.4" fill="#FFC800" />
    </svg>
  );
}

export function MascotStudying({ size = 170, className = "", floaty = false }: { size?: number; className?: string; floaty?: boolean }) {
  return (
    <svg
      width={size}
      height={size}
      viewBox="0 0 200 200"
      fill="none"
      xmlns="http://www.w3.org/2000/svg"
      className={`${className} ${floaty ? "animate-floaty" : ""}`}
      aria-label="Téo estudando com um livro"
    >
      <defs>
        <linearGradient id="studyBody" x1="40" y1="20" x2="160" y2="180" gradientUnits="userSpaceOnUse">
          <stop stopColor="#a878e6" />
          <stop offset="0.5" stopColor="#6130ab" />
          <stop offset="1" stopColor="#4a2484" />
        </linearGradient>
        <linearGradient id="studyPage" x1="100" y1="124" x2="100" y2="186" gradientUnits="userSpaceOnUse">
          <stop stopColor="#FBF8FF" />
          <stop offset="1" stopColor="#ECE2FB" />
        </linearGradient>
        <radialGradient id="studyGlow" cx="0.35" cy="0.3" r="0.7">
          <stop stopColor="#ffffff" stopOpacity="0.32" />
          <stop offset="1" stopColor="#ffffff" stopOpacity="0" />
        </radialGradient>
      </defs>

      <ellipse cx="100" cy="192" rx="54" ry="7" fill="#2B2540" opacity="0.10" />

      <circle cx="61" cy="49" r="17" fill="url(#studyBody)" />
      <circle cx="139" cy="49" r="17" fill="url(#studyBody)" />
      <circle cx="61" cy="49" r="9" fill="#EFE6FF" />
      <circle cx="139" cy="49" r="9" fill="#EFE6FF" />
      <circle cx="61" cy="50" r="5" fill="#FFB6C9" opacity="0.5" />
      <circle cx="139" cy="50" r="5" fill="#FFB6C9" opacity="0.5" />

      <ellipse cx="55" cy="124" rx="11" ry="14" fill="url(#studyBody)" />
      <ellipse cx="145" cy="124" rx="11" ry="14" fill="url(#studyBody)" />

      <circle cx="100" cy="80" r="46" fill="url(#studyBody)" />
      <circle cx="100" cy="80" r="46" fill="url(#studyGlow)" />

      <ellipse cx="100" cy="94" rx="25" ry="19" fill="#F4ECFF" />

      <circle cx="67" cy="91" r="6.5" fill="#FF8FB1" opacity="0.4" />
      <circle cx="133" cy="91" r="6.5" fill="#FF8FB1" opacity="0.4" />

      <ellipse cx="84" cy="74" rx="6.5" ry="8" fill="#2B2540" />
      <ellipse cx="116" cy="74" rx="6.5" ry="8" fill="#2B2540" />
      <circle cx="85.5" cy="77" r="2.4" fill="#fff" />
      <circle cx="117.5" cy="77" r="2.4" fill="#fff" />

      <path d="M76 63c3-2 9-2 13 0" stroke="#4a2484" strokeWidth="2.4" strokeLinecap="round" opacity="0.5" />
      <path d="M111 63c3-2 9-2 13 0" stroke="#4a2484" strokeWidth="2.4" strokeLinecap="round" opacity="0.5" />

      <ellipse cx="100" cy="88" rx="7.5" ry="5.5" fill="#3a1c66" />
      <ellipse cx="97" cy="86" rx="2" ry="1.4" fill="#fff" opacity="0.5" />
      <path d="M100 93v5" stroke="#3a1c66" strokeWidth="2.6" strokeLinecap="round" />
      <path d="M100 98c-4 5-11 4-13-1" stroke="#3a1c66" strokeWidth="2.6" strokeLinecap="round" fill="none" />
      <path d="M100 98c4 5 11 4 13-1" stroke="#3a1c66" strokeWidth="2.6" strokeLinecap="round" fill="none" />

      <g>
        <path d="M100 36l-30 11 30 11 30-11-30-11Z" fill="#221c33" opacity="0.3" />
        <path d="M78 47q22 13 44 0v7q0 8-22 8t-22-8v-7Z" fill="#3a2b57" />
        <path d="M100 20L52 38l48 18 48-18-48-18Z" fill="#2B2540" />
        <path d="M100 20L52 38l48 18 20-7.5-40-15 20-7.5Z" fill="#3a3357" opacity="0.6" />
        <circle cx="100" cy="38" r="4" fill="#FFC800" />
        <path d="M148 38c4 7 3 16 0 23" stroke="#FFC800" strokeWidth="3.2" strokeLinecap="round" />
        <circle cx="148" cy="64" r="5" fill="#FFC800" />
        <circle cx="148" cy="64" r="2.2" fill="#e6a700" />
      </g>

      <path d="M36 132q64-12 128 0v54q-64 10-128 0Z" fill="#4a2484" />
      <path d="M44 136q28-6 55-1v48q-27-4-55 2Z" fill="url(#studyPage)" />
      <path d="M156 136q-28-6-55-1v48q27-4 55 2Z" fill="url(#studyPage)" />
      <path d="M100 135v48" stroke="#cdbce8" strokeWidth="2" strokeLinecap="round" />
      <g stroke="#c9b6e8" strokeWidth="2.6" strokeLinecap="round">
        <path d="M54 147h38" />
        <path d="M54 156h38" />
        <path d="M54 165h32" />
        <path d="M108 147h38" />
        <path d="M108 156h38" />
        <path d="M114 165h32" />
      </g>

      <ellipse cx="48" cy="134" rx="12" ry="9" fill="url(#studyBody)" />
      <ellipse cx="152" cy="134" rx="12" ry="9" fill="url(#studyBody)" />
      <g fill="#4a2484" opacity="0.3">
        <circle cx="46" cy="132" r="1.6" />
        <circle cx="50" cy="132" r="1.6" />
        <circle cx="150" cy="132" r="1.6" />
        <circle cx="154" cy="132" r="1.6" />
      </g>
    </svg>
  );
}
