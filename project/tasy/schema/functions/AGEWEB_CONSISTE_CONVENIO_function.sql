-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageweb_consiste_convenio (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);
qt_retorno_w	bigint;


BEGIN
	select count(*)
	into STRICT	qt_retorno_w
	from (
		SELECT	1
		from 	pessoa_titular_convenio p,
			convenio c
		where  	p.cd_convenio = c.cd_convenio
		and	p.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	c.ie_situacao = 'A'
		and	c.ie_agenda_web = 'S'
		and (p.dt_inicio_vigencia <= clock_timestamp() or coalesce(p.dt_inicio_vigencia::text, '') = '')
		and (p.dt_fim_vigencia >= clock_timestamp() or coalesce(p.dt_fim_vigencia::text, '') = '')
		
union

		SELECT	1
		from 	pls_regra_convenio a,
			pls_contrato b,
			convenio c,
			pls_segurado s,
			pls_outorgante o
		where 	a.nr_seq_outorgante = o.nr_sequencia
		and	b.nr_seq_operadora = o.nr_sequencia
		and	a.cd_convenio = c.cd_convenio
		and	c.ie_situacao = 'A'
		and	c.ie_agenda_web = 'S'
		and	s.nr_seq_contrato = b.nr_sequencia
		and	s.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	coalesce(s.dt_rescisao::text, '') = '' 
	 LIMIT 1) alias8;

	if (qt_retorno_w = 0) then
		ds_retorno_w := 'N';
	else
		ds_retorno_w := 'S';
	end if;

	return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageweb_consiste_convenio (cd_pessoa_fisica_p text) FROM PUBLIC;

