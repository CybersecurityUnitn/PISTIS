#as:
#objdump: -d
#source: ls32ls16p.s

.*: +file format .*

Disassembly of section \.text:

00000000 <.text>:
   0:	7320      	lwp!		r3, 16
   2:	7320      	lwp!		r3, 16
   4:	7460      	lwp!		r4, 48
   6:	7460      	lwp!		r4, 48
   8:	7790      	lwp!		r7, 72
   a:	7790      	lwp!		r7, 72
   c:	7840      	lwp!		r8, 32
   e:	7840      	lwp!		r8, 32
  10:	c0a28080 	lw		r5, \[r2, 128\]
  14:	c0a28080 	lw		r5, \[r2, 128\]
  18:	c0c68020 	lw		r6, \[r6, 32\]
  1c:	c0c68020 	lw		r6, \[r6, 32\]
  20:	7321      	lhp!		r3, 8
  22:	7321      	lhp!		r3, 8
  24:	7461      	lhp!		r4, 24
  26:	7461      	lhp!		r4, 24
  28:	7791      	lhp!		r7, 36
  2a:	7791      	lhp!		r7, 36
  2c:	7841      	lhp!		r8, 16
  2e:	7841      	lhp!		r8, 16
  30:	c4a28040 	lh		r5, \[r2, 64\]
  34:	c4a28040 	lh		r5, \[r2, 64\]
  38:	c4c68010 	lh		r6, \[r6, 16\]
  3c:	c4c68010 	lh		r6, \[r6, 16\]
  40:	7323      	lbup!		r3, 4
  42:	7323      	lbup!		r3, 4
  44:	7463      	lbup!		r4, 12
  46:	7463      	lbup!		r4, 12
  48:	7793      	lbup!		r7, 18
  4a:	7793      	lbup!		r7, 18
  4c:	7843      	lbup!		r8, 8
  4e:	7843      	lbup!		r8, 8
  50:	d8a28020 	lbu		r5, \[r2, 32\]
  54:	d8a28020 	lbu		r5, \[r2, 32\]
  58:	d8c68008 	lbu		r6, \[r6, 8\]
  5c:	d8c68008 	lbu		r6, \[r6, 8\]
  60:	7324      	swp!		r3, 16
  62:	7324      	swp!		r3, 16
  64:	7464      	swp!		r4, 48
  66:	7464      	swp!		r4, 48
  68:	7794      	swp!		r7, 72
  6a:	7794      	swp!		r7, 72
  6c:	7844      	swp!		r8, 32
  6e:	7844      	swp!		r8, 32
  70:	d0a28080 	sw		r5, \[r2, 128\]
  74:	d0a28080 	sw		r5, \[r2, 128\]
  78:	d0c68020 	sw		r6, \[r6, 32\]
  7c:	d0c68020 	sw		r6, \[r6, 32\]
  80:	7325      	shp!		r3, 8
  82:	7325      	shp!		r3, 8
  84:	7465      	shp!		r4, 24
  86:	7465      	shp!		r4, 24
  88:	7795      	shp!		r7, 36
  8a:	7795      	shp!		r7, 36
  8c:	7845      	shp!		r8, 16
  8e:	7845      	shp!		r8, 16
  90:	d4a28040 	sh		r5, \[r2, 64\]
  94:	d4a28040 	sh		r5, \[r2, 64\]
  98:	d4c68010 	sh		r6, \[r6, 16\]
  9c:	d4c68010 	sh		r6, \[r6, 16\]
  a0:	7327      	sbp!		r3, 4
  a2:	7327      	sbp!		r3, 4
  a4:	7467      	sbp!		r4, 12
  a6:	7467      	sbp!		r4, 12
  a8:	7797      	sbp!		r7, 18
  aa:	7797      	sbp!		r7, 18
  ac:	7847      	sbp!		r8, 8
  ae:	7847      	sbp!		r8, 8
  b0:	dca28020 	sb		r5, \[r2, 32\]
  b4:	dca28020 	sb		r5, \[r2, 32\]
  b8:	dcc68008 	sb		r6, \[r6, 8\]
  bc:	dcc68008 	sb		r6, \[r6, 8\]
  c0:	c002800c 	lw		r0, \[r2, 12\]
  c4:	c00580ff 	lw		r0, \[r5, 255\]
  c8:	c1e28000 	lw		r15, \[r2, 0\]
  cc:	c1e480ff 	lw		r15, \[r4, 255\]
  d0:	7410      	lwp!		r4, 8
  d2:	7410      	lwp!		r4, 8
  d4:	7710      	lwp!		r7, 8
  d6:	7740      	lwp!		r7, 32
	...
  e0:	c402800c 	lh		r0, \[r2, 12\]
  e4:	c40580ff 	lh		r0, \[r5, 255\]
  e8:	c5e28000 	lh		r15, \[r2, 0\]
  ec:	c5e480ff 	lh		r15, \[r4, 255\]
  f0:	7421      	lhp!		r4, 8
  f2:	7421      	lhp!		r4, 8
  f4:	7721      	lhp!		r7, 8
  f6:	7741      	lhp!		r7, 16
	...
 100:	d802800c 	lbu		r0, \[r2, 12\]
 104:	d80580ff 	lbu		r0, \[r5, 255\]
 108:	d9e28000 	lbu		r15, \[r2, 0\]
 10c:	d9e480ff 	lbu		r15, \[r4, 255\]
 110:	7443      	lbup!		r4, 8
 112:	7443      	lbup!		r4, 8
 114:	7743      	lbup!		r7, 8
 116:	7743      	lbup!		r7, 8
	...
 120:	d002800c 	sw		r0, \[r2, 12\]
 124:	d00580ff 	sw		r0, \[r5, 255\]
 128:	d1e28000 	sw		r15, \[r2, 0\]
 12c:	d1e480ff 	sw		r15, \[r4, 255\]
 130:	7414      	swp!		r4, 8
 132:	7414      	swp!		r4, 8
 134:	7714      	swp!		r7, 8
 136:	7744      	swp!		r7, 32
	...
 140:	d402800c 	sh		r0, \[r2, 12\]
 144:	d40580ff 	sh		r0, \[r5, 255\]
 148:	d5e28000 	sh		r15, \[r2, 0\]
 14c:	d5e480ff 	sh		r15, \[r4, 255\]
 150:	7425      	shp!		r4, 8
 152:	7425      	shp!		r4, 8
 154:	7725      	shp!		r7, 8
 156:	7745      	shp!		r7, 16
	...
 160:	dc02800c 	sb		r0, \[r2, 12\]
 164:	dc0580ff 	sb		r0, \[r5, 255\]
 168:	dde28000 	sb		r15, \[r2, 0\]
 16c:	dde480ff 	sb		r15, \[r4, 255\]
 170:	7447      	sbp!		r4, 8
 172:	7447      	sbp!		r4, 8
 174:	7747      	sbp!		r7, 8
 176:	7747      	sbp!		r7, 8
#pass