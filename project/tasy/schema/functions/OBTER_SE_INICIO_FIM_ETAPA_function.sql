-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_inicio_fim_etapa ( nr_atendimento_p bigint, cd_medico_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


qt_registro_w	bigint;
ds_retorno_w	varchar(1) := 'N';


BEGIN

if (ie_opcao_p = 'I') then
	select	count(*)
	into STRICT	qt_registro_w
	from	checkup_etapa b,
		checkup a
	where	a.nr_sequencia		= b.nr_seq_checkup
	and	a.nr_atendimento	= nr_atendimento_p
	and	b.cd_pessoa_fisica	= cd_medico_p
	and	coalesce(b.dt_inicio_real::text, '') = ''
	and	(a.dt_inicio_real IS NOT NULL AND a.dt_inicio_real::text <> '')
	and	coalesce(a.dt_fim_real::text, '') = '';
else
	select	count(*)
	into STRICT	qt_registro_w
	from	checkup_etapa b,
		checkup a
	where	a.nr_sequencia		= b.nr_seq_checkup
	and	a.nr_atendimento	= nr_atendimento_p
	and	b.cd_pessoa_fisica	= cd_medico_p
	and	(b.dt_inicio_real IS NOT NULL AND b.dt_inicio_real::text <> '')
	and	coalesce(b.dt_fim_etapa::text, '') = ''
	and	(a.dt_inicio_real IS NOT NULL AND a.dt_inicio_real::text <> '')
	and	coalesce(a.dt_fim_real::text, '') = '';
end if;


if (qt_registro_w > 0) then
	ds_retorno_w	:= 'S';
end if;

return ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_inicio_fim_etapa ( nr_atendimento_p bigint, cd_medico_p text, ie_opcao_p text) FROM PUBLIC;

