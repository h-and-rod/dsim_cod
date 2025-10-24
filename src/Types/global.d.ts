declare module '*.module.css' {
  const classes: { [key: string]: string };
  export default classes;
}

declare module '*.css' {
  const content: any;
  export default content;
}

// Declarações específicas para Swiper CSS
declare module 'swiper/css' {
  const content: any;
  export default content;
}

declare module 'swiper/css/effect-fade' {
  const content: any;
  export default content;
}

declare module 'swiper/css/navigation' {
  const content: any;
  export default content;
}

declare module 'swiper/css/pagination' {
  const content: any;
  export default content;
}

declare module '*.png' {
  const value: string;
  export default value;
}

declare module '*.jpg' {
  const value: string;
  export default value;
}

declare module '*.jpeg' {
  const value: string;
  export default value;
}

declare module '*.gif' {
  const value: string;
  export default value;
}

declare module '*.svg' {
  const value: string;
  export default value;
}

declare module '*.webp' {
  const value: string;
  export default value;
}