-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_proc_rol ( nr_seq_rol_p bigint, nr_seq_capitulo_p bigint, nr_seq_grupo_p bigint, nr_seq_subgrupo_p bigint, nr_seq_grupo_proc_p bigint, nr_seq_rol_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


cont_w				bigint	:= 0;


BEGIN

if (coalesce(cd_procedimento_p,0) = 0) then
	return 'S';
else
	if (nr_seq_rol_proc_p IS NOT NULL AND nr_seq_rol_proc_p::text <> '') then
		select	count(1)
		into STRICT	cont_w
		from	pls_rol_procedimento	a
		where	a.nr_sequencia		= nr_seq_rol_proc_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p  LIMIT 1;
	elsif (nr_seq_grupo_proc_p IS NOT NULL AND nr_seq_grupo_proc_p::text <> '') then
		select	count(1)
		into STRICT	cont_w
		from	pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	b.nr_sequencia		= a.nr_seq_rol_grupo
		and	b.nr_sequencia		= nr_seq_grupo_proc_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p
		and	coalesce(b.ie_situacao,'A')	= 'A'  LIMIT 1;
	elsif (nr_seq_subgrupo_p IS NOT NULL AND nr_seq_subgrupo_p::text <> '') then
		select	count(1)
		into STRICT	cont_w
		from	pls_rol_subgrupo	c,
			pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	b.nr_sequencia		= a.nr_seq_rol_grupo
		and	c.nr_sequencia		= b.nr_seq_subgrupo
		and	c.nr_sequencia		= nr_seq_subgrupo_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p
		and	coalesce(b.ie_situacao,'A')	= 'A'
		and	coalesce(c.ie_situacao,'A')	= 'A'  LIMIT 1;
	elsif (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
		select	count(*)
		into STRICT	cont_w
		from	pls_rol			f,
			pls_rol_capitulo	e,
			pls_rol_grupo		d,
			pls_rol_subgrupo	c,
			pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	f.nr_sequencia		= e.nr_seq_rol
		and	e.nr_sequencia		= d.nr_seq_capitulo
		and	d.nr_sequencia		= c.nr_seq_grupo
		and	b.nr_sequencia		= a.nr_seq_rol_grupo
		and	c.nr_sequencia		= b.nr_seq_subgrupo
		and	d.nr_sequencia		= nr_seq_grupo_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p
		and	coalesce(b.ie_situacao,'A')	= 'A'
		and	coalesce(c.ie_situacao,'A')	= 'A'
		and	coalesce(d.ie_situacao,'A')	= 'A'
		and	coalesce(e.ie_situacao,'A')	= 'A'  LIMIT 1;
	elsif (nr_seq_capitulo_p IS NOT NULL AND nr_seq_capitulo_p::text <> '') then
		select	count(*)
		into STRICT	cont_w
		from	pls_rol			f,
			pls_rol_capitulo	e,
			pls_rol_grupo		d,
			pls_rol_subgrupo	c,
			pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	f.nr_sequencia		= e.nr_seq_rol
		and	e.nr_sequencia		= d.nr_seq_capitulo
		and	d.nr_sequencia		= c.nr_seq_grupo
		and	b.nr_sequencia		= a.nr_seq_rol_grupo
		and	c.nr_sequencia		= b.nr_seq_subgrupo
		and	e.nr_sequencia		= nr_seq_capitulo_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p
		and	coalesce(b.ie_situacao,'A')	= 'A'
		and	coalesce(c.ie_situacao,'A')	= 'A'
		and	coalesce(d.ie_situacao,'A')	= 'A'
		and	coalesce(e.ie_situacao,'A')	= 'A'  LIMIT 1;
	elsif (nr_seq_rol_p IS NOT NULL AND nr_seq_rol_p::text <> '') then
		select	count(*)
		into STRICT	cont_w
		from	pls_rol			f,
			pls_rol_capitulo	e,
			pls_rol_grupo		d,
			pls_rol_subgrupo	c,
			pls_rol_grupo_proc	b,
			pls_rol_procedimento	a
		where	f.nr_sequencia		= e.nr_seq_rol
		and	e.nr_sequencia		= d.nr_seq_capitulo
		and	d.nr_sequencia		= c.nr_seq_grupo
		and	b.nr_sequencia		= a.nr_seq_rol_grupo
		and	c.nr_sequencia		= b.nr_seq_subgrupo
		and	f.nr_sequencia		= nr_seq_rol_p
		and	a.cd_procedimento	= cd_procedimento_p
		and	a.ie_origem_proced	= ie_origem_proced_p
		and	coalesce(b.ie_situacao,'A')	= 'A'
		and	coalesce(c.ie_situacao,'A')	= 'A'
		and	coalesce(d.ie_situacao,'A')	= 'A'
		and	coalesce(e.ie_situacao,'A')	= 'A'  LIMIT 1;
	end if;

	if (cont_w > 0) then
		return 'S';
	else
		return 'N';
	end if;
end if;

return	'S';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_proc_rol ( nr_seq_rol_p bigint, nr_seq_capitulo_p bigint, nr_seq_grupo_p bigint, nr_seq_subgrupo_p bigint, nr_seq_grupo_proc_p bigint, nr_seq_rol_proc_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
