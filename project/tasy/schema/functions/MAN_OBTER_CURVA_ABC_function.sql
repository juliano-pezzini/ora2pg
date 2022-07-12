-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_curva_abc ( nr_seq_cliente_p bigint, nr_seq_gerencia_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
nm_usuario_w		varchar(15);
nr_seq_gerencia_w		bigint;
nr_seq_diretor_w		bigint;
cd_cnpj_w		varchar(14);


BEGIN
nm_usuario_w			:= wheb_usuario_pck.get_nm_usuario;
nr_seq_diretor_w		:= sis_obter_diretor(nm_usuario_w,'S');
if (coalesce(nr_seq_diretor_w::text, '') = '') then
	begin

	if (coalesce(nr_seq_gerencia_p::text, '') = '') then
		begin
		select	max(y.nr_seq_gerencia)
		into STRICT	nr_seq_gerencia_w
		from	gerencia_wheb_grupo y,
				gerencia_wheb_grupo_usu x
		where	y.nr_sequencia		= x.nr_seq_grupo
		and		x.nm_usuario_grupo	= nm_usuario_w;
		end;
	else
		nr_seq_gerencia_w		:= nr_seq_gerencia_p;
	end if;

	select	max('S')
	into STRICT	ds_retorno_w
	from	gerencia_s_cliente a
	where	a.nr_seq_cliente	= nr_seq_cliente_p
	and		((a.nr_seq_gerencia	= nr_seq_gerencia_w) or (coalesce(a.nr_seq_gerencia::text, '') = ''))
	and		clock_timestamp() between dt_inicial and dt_final + 86399/86400;

	if (coalesce(ds_retorno_w::text, '') = '')then
		select	coalesce(max(a.ie_avaliacao),'')
		into STRICT	ds_retorno_w
		from	gerencia_abc_cliente a
		where	a.nr_seq_cliente	= nr_seq_cliente_p
		and		a.nr_seq_gerencia	= nr_seq_gerencia_w;
	end if;

	end;
else
	begin

	if (coalesce(nr_seq_gerencia_p::text, '') = '') then
		select	max(y.nr_seq_gerencia)
		into STRICT	nr_seq_gerencia_w
		from	gerencia_wheb_grupo y,
			gerencia_wheb_grupo_usu x
		where	y.nr_sequencia		= x.nr_seq_grupo
		and	x.nm_usuario_grupo	= nm_usuario_w;
	else
		nr_seq_gerencia_w		:= nr_seq_gerencia_p;
	end if;

	select	coalesce(max(a.cd_cnpj),'0')
	into STRICT	cd_cnpj_w
	from	com_cliente a
	where	a.nr_sequencia = nr_seq_cliente_p;

	select	max('S')
	into STRICT	ds_retorno_w
	from	gerencia_s_cliente a
	where	a.cd_cnpj			= cd_cnpj_w
	and		((a.nr_seq_gerencia	= nr_seq_gerencia_w) or (coalesce(a.nr_seq_gerencia::text, '') = ''))
	and		clock_timestamp() between dt_inicial and dt_final + 86399/86400;

	if (coalesce(ds_retorno_w::text, '') = '')then
		select	coalesce(max(a.ie_avaliacao),'')
		into STRICT	ds_retorno_w
		from	gerencia_abc_cliente a
		where	a.cd_cnpj			= cd_cnpj_w
		and		a.nr_seq_diretor	= nr_seq_diretor_w;
	end if;

	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_curva_abc ( nr_seq_cliente_p bigint, nr_seq_gerencia_p bigint default null) FROM PUBLIC;
