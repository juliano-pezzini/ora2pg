-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qualif_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_parametro_p timestamp, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255)	:= 'N';

certificacoes_c CURSOR FOR
	SELECT	a.ie_acreditacao
	from	pls_prestador_qualif	a
	where	a.nr_seq_prestador	= nr_seq_prestador_p
	and	dt_parametro_p between coalesce(a.dt_inicio_vigencia, dt_parametro_p-1) and coalesce(dt_fim_vigencia, dt_parametro_p+1);

-- Conforme RN405
certific_rn405_c CURSOR FOR
	SELECT	c.ie_atrib_qualif
	from	pls_prestador_qualif	a,
		pls_instituicao_acred	b,
		pls_atrib_qualif_prest	c
	where	c.nr_sequencia	= b.nr_seq_atrib_qualif_prest
	and	b.nr_sequencia	= a.nr_seq_instituicao_acred
	and	a.nr_seq_prestador	= nr_seq_prestador_p
	and	clock_timestamp() between coalesce(a.dt_inicio_vigencia, dt_parametro_p-1) and coalesce(a.dt_fim_vigencia, dt_parametro_p+1)
	and	(a.nr_seq_instituicao_acred IS NOT NULL AND a.nr_seq_instituicao_acred::text <> '');
BEGIN

for r_c01_w in certificacoes_c loop
	if (r_c01_w.ie_acreditacao = ie_retorno_p) then
		ds_retorno_w	:= 'S';
	end if;
end loop;

for r_c02_w in certific_rn405_c loop
	if (r_c02_w.ie_atrib_qualif = ie_retorno_p) then
		ds_retorno_w	:= 'S';
	end if;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qualif_prest ( nr_seq_prestador_p pls_prestador.nr_sequencia%type, dt_parametro_p timestamp, ie_retorno_p text) FROM PUBLIC;
