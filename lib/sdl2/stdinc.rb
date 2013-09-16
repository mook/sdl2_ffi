# TODO: Review stdinc stub.

require 'enumerable_constants'

module SDL2

  # Define a four character code as a Uint32
  #MACRO: SDL_FOURCC(A, B, C, D) \
  #    ((SDL_static_cast(Uint32, SDL_static_cast(Uint8, (A))) << 0) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (B))) << 8) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (C))) << 16) | \
  #     (SDL_static_cast(Uint32, SDL_static_cast(Uint8, (D))) << 24))
  def self.fourcc(*args)
    bit_cnt = 0
    result = 0
    args.each do |arg|
      arg = arg.codepoints[0] if arg.kind_of? String
      result = result | (arg << bit_cnt)
      bit_cnt += 8
    end
    return result
  end
  
    
  # These are for internal use mostly, they test the return result
  # of a function that can return an error.  They are designed to
  # return TRUE if there is NOT_AN_ERROR
    
  #Filter Proc, True when arg equals zero
  TRUE_WHEN_ZERO = Proc.new do |result|
    # Handles both Negative and Positive error values.
    result == 0
  end
  
  TRUE_WHEN_NOT_ZERO = Proc.new do |result|
    result != 0
  end
  
  # Filter Proc, True when arg not null?
  TRUE_WHEN_NOT_NULL = Proc.new do |result|
    # Anything but nil/null is considered valid.
    (!result.null?)
  end
  
  TRUE_WHEN_TRUE = Proc.new do |result|
    result == true
  end
    
  # NOTE: None of the SDL Memory Macros/Externals
    
  # TODO: Review importing SDL's Memory management and ICONV routines?
  #  #define SDL_stack_alloc(type, count)    (type*)SDL_malloc(sizeof(type)*(count))
  #  #define SDL_stack_free(data)            SDL_free(data)
  #  #endif
  #  
  #  extern DECLSPEC void *SDLCALL SDL_malloc(size_t size);
  #  extern DECLSPEC void *SDLCALL SDL_calloc(size_t nmemb, size_t size);
  #  extern DECLSPEC void *SDLCALL SDL_realloc(void *mem, size_t size);
  #  extern DECLSPEC void SDLCALL SDL_free(void *mem);
  #  
  #  extern DECLSPEC char *SDLCALL SDL_getenv(const char *name);
  #  extern DECLSPEC int SDLCALL SDL_setenv(const char *name, const char *value, int overwrite);
  #  
  #  extern DECLSPEC void SDLCALL SDL_qsort(void *base, size_t nmemb, size_t size, int (*compare) (const void *, const void *));
  #  
  #  extern DECLSPEC int SDLCALL SDL_abs(int x);
  #  
  #  /* !!! F!IXME: these have side effects. You probably shouldn't use them. */
  #  /* !!! F!IXME: Maybe we do forceinline functions of SDL_mini, SDL_minf, etc? */
  #  #define SDL_min(x, y) (((x) < (y)) ? (x) : (y))
  #  #define SDL_max(x, y) (((x) > (y)) ? (x) : (y))
  #  
  #  extern DECLSPEC int SDLCALL SDL_isdigit(int x);
  #  extern DECLSPEC int SDLCALL SDL_isspace(int x);
  #  extern DECLSPEC int SDLCALL SDL_toupper(int x);
  #  extern DECLSPEC int SDLCALL SDL_tolower(int x);
  #  
  #  extern DECLSPEC void *SDLCALL SDL_memset(void *dst, int c, size_t len);
  #  
  #  #define SDL_zero(x) SDL_memset(&(x), 0, sizeof((x)))
  #  #define SDL_zerop(x) SDL_memset((x), 0, sizeof(*(x)))
  #  
  #  /* Note that memset() is a byte assignment and this is a 32-bit assignment, so they're not directly equivalent. */
  #  SDL_FORCE_INLINE void SDL_memset4(void *dst, int val, size_t dwords)
  #  {
  #  #if defined(__GNUC__) && defined(i386)
  #      int u0, u1, u2;
  #      __asm__ __volatile__ (
  #          "cld \n\t"
  #          "rep ; stosl \n\t"
  #          : "=&D" (u0), "=&a" (u1), "=&c" (u2)
  #          : "0" (dst), "1" (val), "2" (SDL_static_cast(Uint32, dwords))
  #          : "memory"
  #      );
  #  #else
  #      size_t _n = (dwords + 3) / 4;
  #      Uint32 *_p = SDL_static_cast(Uint32 *, dst);
  #      Uint32 _val = (val);
  #      if (dwords == 0)
  #          return;
  #      switch (dwords % 4)
  #      {
  #          case 0: do {    *_p++ = _val;
  #          case 3:         *_p++ = _val;
  #          case 2:         *_p++ = _val;
  #          case 1:         *_p++ = _val;
  #          } while ( --_n );
  #      }
  #  #endif
  #  }
  #  
  #  
  #  extern DECLSPEC void *SDLCALL SDL_memcpy(void *dst, const void *src, size_t len);
  #  
  #  SDL_FORCE_INLINE void *SDL_memcpy4(void *dst, const void *src, size_t dwords)
  #  {
  #      return SDL_memcpy(dst, src, dwords * 4);
  #  }
  #  
  #  extern DECLSPEC void *SDLCALL SDL_memmove(void *dst, const void *src, size_t len);
  #  extern DECLSPEC int SDLCALL SDL_memcmp(const void *s1, const void *s2, size_t len);
  #  
  #  extern DECLSPEC size_t SDLCALL SDL_wcslen(const wchar_t *wstr);
  #  extern DECLSPEC size_t SDLCALL SDL_wcslcpy(wchar_t *dst, const wchar_t *src, size_t maxlen);
  #  extern DECLSPEC size_t SDLCALL SDL_wcslcat(wchar_t *dst, const wchar_t *src, size_t maxlen);
  #  
  #  extern DECLSPEC size_t SDLCALL SDL_strlen(const char *str);
  #  extern DECLSPEC size_t SDLCALL SDL_strlcpy(char *dst, const char *src, size_t maxlen);
  #  extern DECLSPEC size_t SDLCALL SDL_utf8strlcpy(char *dst, const char *src, size_t dst_bytes);
  #  extern DECLSPEC size_t SDLCALL SDL_strlcat(char *dst, const char *src, size_t maxlen);
  #  extern DECLSPEC char *SDLCALL SDL_strdup(const char *str);
  #  extern DECLSPEC char *SDLCALL SDL_strrev(char *str);
  #  extern DECLSPEC char *SDLCALL SDL_strupr(char *str);
  #  extern DECLSPEC char *SDLCALL SDL_strlwr(char *str);
  #  extern DECLSPEC char *SDLCALL SDL_strchr(const char *str, int c);
  #  extern DECLSPEC char *SDLCALL SDL_strrchr(const char *str, int c);
  #  extern DECLSPEC char *SDLCALL SDL_strstr(const char *haystack, const char *needle);
  #  
  #  extern DECLSPEC char *SDLCALL SDL_itoa(int value, char *str, int radix);
  #  extern DECLSPEC char *SDLCALL SDL_uitoa(unsigned int value, char *str, int radix);
  #  extern DECLSPEC char *SDLCALL SDL_ltoa(long value, char *str, int radix);
  #  extern DECLSPEC char *SDLCALL SDL_ultoa(unsigned long value, char *str, int radix);
  #  extern DECLSPEC char *SDLCALL SDL_lltoa(Sint64 value, char *str, int radix);
  #  extern DECLSPEC char *SDLCALL SDL_ulltoa(Uint64 value, char *str, int radix);
  #  
  #  extern DECLSPEC int SDLCALL SDL_atoi(const char *str);
  #  extern DECLSPEC double SDLCALL SDL_atof(const char *str);
  #  extern DECLSPEC long SDLCALL SDL_strtol(const char *str, char **endp, int base);
  #  extern DECLSPEC unsigned long SDLCALL SDL_strtoul(const char *str, char **endp, int base);
  #  extern DECLSPEC Sint64 SDLCALL SDL_strtoll(const char *str, char **endp, int base);
  #  extern DECLSPEC Uint64 SDLCALL SDL_strtoull(const char *str, char **endp, int base);
  #  extern DECLSPEC double SDLCALL SDL_strtod(const char *str, char **endp);
  #  
  #  extern DECLSPEC int SDLCALL SDL_strcmp(const char *str1, const char *str2);
  #  extern DECLSPEC int SDLCALL SDL_strncmp(const char *str1, const char *str2, size_t maxlen);
  #  extern DECLSPEC int SDLCALL SDL_strcasecmp(const char *str1, const char *str2);
  #  extern DECLSPEC int SDLCALL SDL_strncasecmp(const char *str1, const char *str2, size_t len);
  #  
  #  extern DECLSPEC int SDLCALL SDL_sscanf(const char *text, const char *fmt, ...);
  #  extern DECLSPEC int SDLCALL SDL_snprintf(char *text, size_t maxlen, const char *fmt, ...);
  #  extern DECLSPEC int SDLCALL SDL_vsnprintf(char *text, size_t maxlen, const char *fmt, va_list ap);
  #  
  #  #ifndef HAVE_M_PI
  #  #ifndef M_PI
  #  #define M_PI    3.14159265358979323846264338327950288   /* pi */
  #  #endif
  #  #endif
  #  
  #  extern DECLSPEC double SDLCALL SDL_atan(double x);
  #  extern DECLSPEC double SDLCALL SDL_atan2(double x, double y);
  #  extern DECLSPEC double SDLCALL SDL_ceil(double x);
  #  extern DECLSPEC double SDLCALL SDL_copysign(double x, double y);
  #  extern DECLSPEC double SDLCALL SDL_cos(double x);
  #  extern DECLSPEC float SDLCALL SDL_cosf(float x);
  #  extern DECLSPEC double SDLCALL SDL_fabs(double x);
  #  extern DECLSPEC double SDLCALL SDL_floor(double x);
  #  extern DECLSPEC double SDLCALL SDL_log(double x);
  #  extern DECLSPEC double SDLCALL SDL_pow(double x, double y);
  #  extern DECLSPEC double SDLCALL SDL_scalbn(double x, int n);
  #  extern DECLSPEC double SDLCALL SDL_sin(double x);
  #  extern DECLSPEC float SDLCALL SDL_sinf(float x);
  #  extern DECLSPEC double SDLCALL SDL_sqrt(double x);
  #  
  #  /* The SDL implementation of iconv() returns these error codes */
  #  #define SDL_ICONV_ERROR     (size_t)-1
  #  #define SDL_ICONV_E2BIG     (size_t)-2
  #  #define SDL_ICONV_EILSEQ    (size_t)-3
  #  #define SDL_ICONV_EINVAL    (size_t)-4
  #  
  #  /* SDL_iconv_* are now always real symbols/types, not macros or inlined. */
  #  typedef struct _SDL_iconv_t *SDL_iconv_t;
  #  extern DECLSPEC SDL_iconv_t SDLCALL SDL_iconv_open(const char *tocode,
  #                                                     const char *fromcode);
  #  extern DECLSPEC int SDLCALL SDL_iconv_close(SDL_iconv_t cd);
  #  extern DECLSPEC size_t SDLCALL SDL_iconv(SDL_iconv_t cd, const char **inbuf,
  #                                           size_t * inbytesleft, char **outbuf,
  #                                           size_t * outbytesleft);
  #  /**
  #   *  This function converts a string between encodings in one pass, returning a
  #   *  string that must be freed with SDL_free() or NULL on error.
  #   */
  #  extern DECLSPEC char *SDLCALL SDL_iconv_string(const char *tocode,
  #                                                 const char *fromcode,
  #                                                 const char *inbuf,
  #                                                 size_t inbytesleft);
  #  #define SDL_iconv_utf8_locale(S)    SDL_iconv_string("", "UTF-8", S, SDL_strlen(S)+1)
  #  #define SDL_iconv_utf8_ucs2(S)      (Uint16 *)SDL_iconv_string("UCS-2-INTERNAL", "UTF-8", S, SDL_strlen(S)+1)
  #  #define SDL_iconv_utf8_ucs4(S)      (Uint32 *)SDL_iconv_string("UCS-4-INTERNAL", "UTF-8", S, SDL_strlen(S)+1)
    

    
end