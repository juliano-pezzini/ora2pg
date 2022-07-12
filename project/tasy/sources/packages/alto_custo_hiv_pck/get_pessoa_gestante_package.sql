-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION alto_custo_hiv_pck.get_pessoa_gestante ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


	ie_sexo_w     pessoa_fisica.ie_sexo%type;
	ds_retorno_w  varchar(255);

	
BEGIN

		begin

		select  pf.ie_sexo
		into STRICT    ie_sexo_w
		from    pessoa_fisica pf
		where   pf.cd_pessoa_fisica = cd_pessoa_fisica_p;

		if (ie_sexo_w = 'M') then
		  ds_retorno_w := '3';

		else
		  select  case
				  when is_between_dt_corte = '1' and ie_gravida = 'N' then '0'
				  when is_between_dt_corte = '1' and ie_gravida = 'S' then '1'
				  when is_between_dt_corte = '0' and ie_gravida = 'S' and is_between_months = '1' then '2'
				  else '0' end ie_pessoa_gestante
		  into STRICT    ds_retorno_w
		  from (
				  SELECT
				  case when dt between alto_custo_pck.get_data_inicio_emissao_guia and alto_custo_pck.get_data_corte then '1'
				  else '0' end is_between_dt_corte,
				  case when dt between add_months(trunc(clock_timestamp()),-6) and trunc(clock_timestamp()) then '1'
				  else '0' end is_between_months,
				  ie_gravida,
				  dt
		  from (
				  SELECT  max(ag.dt_avaliacao) dt,
						  ag.ie_pac_gravida ie_gravida
				  from    atendimento_gravidez ag
				  where   (ag.dt_liberacao IS NOT NULL AND ag.dt_liberacao::text <> '')
				  and     coalesce(ag.dt_inativacao::text, '') = ''
				  and     ag.nr_atendimento in (select nr_atendimento from atendimento_paciente where cd_pessoa_fisica = cd_pessoa_fisica_p)
				  group by ag.ie_pac_gravida
				
union

				  select  max(hsm.dt_registro) dt,
						  hsm.ie_pac_gravida ie_gravida
				  from    historico_saude_mulher hsm
				  where   (hsm.dt_liberacao IS NOT NULL AND hsm.dt_liberacao::text <> '')
				  and     coalesce(hsm.dt_inativacao::text, '') = ''
				  and     hsm.ie_situacao = 'A'
				  and     hsm.cd_pessoa_fisica = cd_pessoa_fisica_p
				  group by hsm.ie_pac_gravida) a
		  order by dt desc) alias13 LIMIT 1;
									
		  end if;
		
		  exception
			when no_data_found then
			  ds_retorno_w := 0;
		  end;

		  return ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION alto_custo_hiv_pck.get_pessoa_gestante ( cd_pessoa_fisica_p text) FROM PUBLIC;