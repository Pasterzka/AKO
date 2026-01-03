# Instrukcja włączenia

## Linkujemy folder, w którym znajduje się program (u mnie D:\ako) 

```bash
mount d d:\ako
```

## Teraz można przeprowadzić aselblacje i linkowanie

```bash
masm program-ako.asm,,,;
link program-ako.obj;
```

## Można włączyć poprzez 

```bash
program-ako
```