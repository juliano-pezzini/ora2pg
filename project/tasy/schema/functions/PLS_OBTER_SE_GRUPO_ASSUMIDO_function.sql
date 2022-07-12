-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_grupo_assumido ( nr_seq_auditoria_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
nm_usuario_exec_w		varchar(15);
nr_seq_grupo_atual_w		bigint;
nr_seq_grupo_auditor_w		bigint;


BEGIN

select	coalesce(pls_obter_grupo_analise_atual(nr_seq_auditoria_p),0)
into STRICT	nr_seq_grupo_atual_w
;

if (nr_seq_grupo_atual_w > 0) then
	select	max(coalesce(c.nr_sequencia,0))
	into STRICT	nr_seq_grupo_auditor_w
	from	pls_auditoria_grupo	c,
		pls_grupo_auditor	b,
		pls_membro_grupo_aud	a
	where	c.nr_seq_grupo		= b.nr_sequencia
	and	b.nr_sequencia		= a.nr_seq_grupo
	and	c.nr_sequencia		= nr_seq_grupo_atual_w
	and	coalesce(c.dt_liberacao::text, '') = ''
	and	a.nm_usuario_exec	= nm_usuario_p;

	if (nr_seq_grupo_auditor_w > 0) then
		select	coalesce(nm_usuario_exec,'X')
		into STRICT	nm_usuario_exec_w
		from	pls_auditoria_grupo
		where	nr_sequencia	= nr_seq_grupo_auditor_w;

		if (nm_usuario_exec_w = nm_usuario_p) then
			ds_retorno_w := 'S';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_grupo_assumido ( nr_seq_auditoria_p bigint, nm_usuario_p text) FROM PUBLIC;
