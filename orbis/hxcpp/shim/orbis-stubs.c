/* Stubs para simbolos que o libc++ do OpenOrbis referencia mas a libc nao define. */

/* usado para destrutores de variaveis thread_local; aqui nenhum destrutor roda no fim da thread */
int __cxa_thread_atexit_impl(void (*dtor)(void *), void *obj, void *dso_symbol)
{
  (void)dtor;
  (void)obj;
  (void)dso_symbol;
  return 0;
}
