-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_aval_subj_global ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_aval_nut_w	varchar(255);
dt_avaliacao_w	varchar(50);
dt_aval_w	varchar(50);
dt_aval_ped_w	varchar(50);
nm_pf_w		varchar(255);


BEGIN

select  	coalesce(max(to_char(b.dt_avaliacao,'dd/mm/yyyy hh24:mi:ss')),'0') dt_aval,
	coalesce(max(to_char(c.dt_avaliacao,'dd/mm/yyyy hh24:mi:ss')),'0') dt_aval_ped
into STRICT 	dt_aval_w,
	dt_aval_ped_w
FROM atendimento_paciente a
LEFT OUTER JOIN aval_nutricao b ON (a.nr_atendimento = b.nr_atendimento)
LEFT OUTER JOIN aval_nutricao_ped c ON (a.nr_atendimento = c.nr_atendimento)
WHERE a.nr_atendimento = nr_atendimento_p;

if (dt_aval_w > dt_aval_ped_w) then

select	max(substr(obter_valor_dominio(4844,ie_aval_nut),1,255)),
	max(to_char(dt_avaliacao,'dd/mm/yyyy hh24:mi:ss')),
	max(substr(obter_nome_pf(cd_profissional),1,255))
into STRICT	ds_aval_nut_w,
	dt_avaliacao_w,
	nm_pf_w
from	aval_nutricao a
where	nr_atendimento = nr_atendimento_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and 	coalesce(dt_inativacao::text, '') = ''
and	a.nr_sequencia = (	SELECT	max(x.nr_sequencia)
			from	aval_nutricao x
			where	x.nr_atendimento	= nr_atendimento_p
			and		(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '')
			and		coalesce(x.dt_inativacao::text, '') = '');

elsif (dt_aval_ped_w > dt_aval_w) then

select	max(substr(obter_valor_dominio(4844,ie_aval_nut),1,255)),
	max(to_char(dt_avaliacao,'dd/mm/yyyy hh24:mi:ss')),
	max(substr(obter_nome_pf(cd_profissional),1,255))
into STRICT	ds_aval_nut_w,
	dt_avaliacao_w,
	nm_pf_w
from	aval_nutricao_ped a
where	nr_atendimento = nr_atendimento_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and 	coalesce(dt_inativacao::text, '') = ''
and	a.nr_sequencia = (	SELECT	max(x.nr_sequencia)
			from	aval_nutricao_ped x
			where	x.nr_atendimento	= nr_atendimento_p
			and		(x.dt_liberacao IS NOT NULL AND x.dt_liberacao::text <> '')
			and		coalesce(x.dt_inativacao::text, '') = '');
end if;

if (ie_opcao_p = 'AV') then
	return	ds_aval_nut_w;
elsif (ie_opcao_p = 'DT') then
	return	dt_avaliacao_w;
elsif (ie_opcao_p = 'NM') then
	return	nm_pf_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_aval_subj_global ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;

