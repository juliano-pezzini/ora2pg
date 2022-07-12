-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_away_desc (nr_atendimento_p bigint, ie_only_department_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1000);
ds_department_w		varchar(250);
dt_entrance_w		varchar(100);


BEGIN
	begin
		select	desc_setor,
			dt_entrance
		into STRICT	ds_department_w,
			dt_entrance_w
		from (SELECT distinct OBTER_DESC_SETOR_ATEND(d.CD_SETOR_ATENDIMENTO) desc_setor,
				to_char(c.DT_ENTRADA_UNIDADE, pkg_date_formaters.localize_mask('timestamp', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) dt_entrance
			from 	atend_paciente_unidade a,
				setor_atendimento b,
				atend_paciente_unidade c,
				setor_atendimento d
			where	coalesce(a.dt_saida_unidade::text, '') = ''
			and	b.cd_classif_setor     	in (3, 4)
			and	a.cd_setor_atendimento  = b.cd_setor_atendimento
			and	d.cd_classif_setor not 	in (3, 4)
			and	c.cd_setor_atendimento  = d.cd_setor_atendimento
			and	coalesce(c.dt_saida_unidade::text, '') = ''
			and	c.nr_atendimento        = a.nr_atendimento
			and	a.nr_atendimento        = nr_atendimento_p
			order by 2 desc
			) alias8 LIMIT 1;

		if (ie_only_department_p = 'S') then
			ds_retorno_w := ds_department_w;
		else
			ds_retorno_w := wheb_mensagem_pck.get_texto(1077191, 'DS_DEPARTMENT='||ds_department_w||';DT_ENTRANCE='||dt_entrance_w||'');
		end if;

		exception when others then
		ds_retorno_w := '  ';
	end;

	return  ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_away_desc (nr_atendimento_p bigint, ie_only_department_p text default 'N') FROM PUBLIC;

