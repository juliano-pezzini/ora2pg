-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bsc_obter_os_encerrada_pessoa ( dt_referencia_p timestamp, ie_area_p text default null, nr_seq_gerencia_p bigint default null, ie_somente_desenv_p text default null) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		double precision := 0;
qt_total_os_w		bigint := 0;
dt_ref_mes_w		timestamp;
dt_fim_mes_w		timestamp;


BEGIN

dt_ref_mes_w	:= trunc(dt_referencia_p,'month');
dt_fim_mes_w	:= last_day(dt_ref_mes_w) + 86399/86400;

if (trunc(dt_referencia_p,'month') = trunc(clock_timestamp(),'month')) then
	begin
	select	count(1)
	into STRICT	qt_total_os_w
	from	gerencia_wheb g,
		os_encerrada_gerencia_v a
	where	a.dt_fim_real between dt_ref_mes_w and dt_fim_mes_w
	and	g.nr_sequencia = a.nr_seq_gerencia
	and (g.nr_sequencia = nr_seq_gerencia_p or coalesce(nr_seq_gerencia_p::text, '') = '')
	and (g.ie_area_gerencia = ie_area_p or coalesce(ie_area_p::text, '') = '')
	and (coalesce(ie_somente_desenv_p,'N') = 'N' or g.ie_area_gerencia in ('DES', 'PDES'));

	select	coalesce(sum(phi_obter_valor_usu_grupo(dt_referencia_p,c.nm_usuario_grupo,c.nr_seq_grupo,null,3)),0)
	into STRICT	qt_retorno_w
	from	usuario_grupo_des c,
		grupo_desenvolvimento b,
		gerencia_wheb a
	where	a.nr_sequencia = b.nr_seq_gerencia
	and	b.nr_sequencia = c.nr_seq_grupo
	and	c.ie_funcao_usuario in ('P','S','N','M')
	and	b.ie_situacao = 'A' --
	and (a.nr_sequencia = nr_seq_gerencia_p or coalesce(nr_seq_gerencia_p::text, '') = '')
	and (a.ie_area_gerencia = ie_area_p or coalesce(ie_area_p::text, '') = '')
	and (coalesce(ie_somente_desenv_p,'N') = 'N' or a.ie_area_gerencia in ('DES','PDES'))
	and	dt_referencia_p between c.dt_inicio_vigencia and fim_mes(coalesce(c.dt_fim_vigencia,dt_referencia_p));

	qt_retorno_w := dividir(qt_total_os_w,qt_retorno_w);
	end;
else
	if (coalesce(nr_seq_gerencia_p::text, '') = '') then
		select	dividir(sum(qt_os_encerrada_mes),sum(qt_total_pessoas) - sum(qt_pessoa_ausente)) qt_encerrada_pessoa
		into STRICT	qt_retorno_w
		from	w_indicador_desenv_apres
		where	dt_referencia = last_day(dt_ref_mes_w)
		and	ie_abrangencia = 'AREA'
		and (ie_area_gerencia = ie_area_p or coalesce(ie_area_p::text, '') = '')
		and (coalesce(ie_somente_desenv_p,'N') = 'N' or ie_area_gerencia in ('DES','PDES'));
	else
		select	max(qt_encerrada_pessoa)
		into STRICT	qt_retorno_w
		from	w_indicador_desenv_apres
		where	dt_referencia = last_day(trunc(to_date('08/2018', 'mm/yyyy'), 'month'))
		and	ie_abrangencia = 'GER'
		and	nr_seq_gerencia = 4
		and	ie_area_gerencia = 'DES';
	end if;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bsc_obter_os_encerrada_pessoa ( dt_referencia_p timestamp, ie_area_p text default null, nr_seq_gerencia_p bigint default null, ie_somente_desenv_p text default null) FROM PUBLIC;
