/* Stubs e diagnostico de boot para o teste hello no PS4 (OpenOrbis). */

/* ---- log de boot em /data/FNF/boot.log (sem headers; so libc) ---- */
extern int mkdir(const char *path, unsigned short mode);
extern void *fopen(const char *path, const char *mode);
extern int fputs(const char *s, void *f);
extern int fclose(void *f);

static void boot_log(const char *msg)
{
  void *f;
  mkdir("/data/FNF", 0777);
  f = fopen("/data/FNF/boot.log", "a");
  if (f) {
    fputs(msg, f);
    fputs("\n", f);
    fclose(f);
  }
}

/* roda antes do main, se o loader processar init_array */
__attribute__((constructor, used)) static void boot_constructor(void)
{
  boot_log("[c] constructor (libc inicializada)");
}

/* o linker troca main por __wrap_main (--wrap=main) */
extern int __real_main(int argc, char **argv, char **envp);
int __wrap_main(int argc, char **argv, char **envp)
{
  int r;
  boot_log("[c] main alcancado");
  r = __real_main(argc, argv, envp);
  boot_log("[c] main retornou");
  return r;
}

/* ---- stubs de simbolos que a libc/libc++ referenciam ---- */

/* destrutores de variaveis thread_local: aqui nenhum destrutor roda no fim da thread */
int __cxa_thread_atexit_impl(void (*dtor)(void *), void *obj, void *dso_symbol)
{
  (void)dtor;
  (void)obj;
  (void)dso_symbol;
  return 0;
}

/* a libc (resolvconf.c) chama isto para ler o DNS; no hello nao ha rede, devolve erro */
int sceNetGetDnsInfo(void *s, void *info, int flags)
{
  (void)s;
  (void)info;
  (void)flags;
  return -1;
}
