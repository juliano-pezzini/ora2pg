-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_atend_pc ( nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE



dt_inicio_atendimento_w		timestamp;
dt_fim_triagem_w			timestamp;
dt_atend_medico_w  		timestamp;
dt_fim_consulta_w      	    	timestamp;
ds_valor_dominio_w		varchar(255);
ie_agenda_hoje_w			varchar(1) := 'N';
dt_alta_w				timestamp;
ie_evasao_w				varchar(1);

/*	ie_opcao_p		Descrição

	C			Código
	D			Descrição

    DT_INICIO_ATENDIMENTO  -- Data de início do acolhimento
	DT_FIM_TRIAGEM                  --    Data de fim do acolhimento
	DT_ATEND_MEDICO	 --    Data início consulta
	DT_FIM_CONSULTA               --    Data de fim da consulta
*/
BEGIN


Select 	max(dt_inicio_atendimento),
		max(dt_fim_triagem),
		max(dt_atend_medico),
		max(dt_fim_consulta),
		max(dt_alta),
		max(obter_se_motivo_alta_evasao(cd_motivo_alta))
into STRICT	dt_inicio_atendimento_w,
		dt_fim_triagem_w,
		dt_atend_medico_w,
		dt_fim_consulta_w,
		dt_alta_w,
		ie_evasao_w
from	atendimento_paciente
where 	nr_atendimento = nr_atendimento_p;

If (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') and ( ie_evasao_w = 'S')then

	if (ie_opcao_p = 'C')then

		return 'IV'; --Evadido
	elsif (ie_opcao_p = 'D') then

		Select	substr(obter_valor_dominio(8370, 'IV'), 1, 254)
		into STRICT	ds_valor_dominio_w
		;

		return 	ds_valor_dominio_w;
	end if;


elsif (obter_se_pac_reavaliacao(nr_atendimento_p) = 'S') then
	begin
		if (obter_se_pac_obs(nr_atendimento_p) = 'S') then
			if (ie_opcao_p = 'C')then
				return 'EO'; --Em observação.
			elsif (ie_opcao_p = 'D') then

				Select	substr(obter_valor_dominio(8370, 'EO'), 1, 254)
				into STRICT	ds_valor_dominio_w
				;

				return 	ds_valor_dominio_w;
			end if;
		else
			if (ie_opcao_p = 'C')then
				return 'RE'; --Reavaliação.
			elsif (ie_opcao_p = 'D') then

				Select	substr(obter_valor_dominio(8370, 'RE'), 1, 254)
				into STRICT	ds_valor_dominio_w
				;

				return 	ds_valor_dominio_w;
			end if;
		end if;
	end;
elsif (dt_fim_consulta_w IS NOT NULL AND dt_fim_consulta_w::text <> '') then
	begin
		if (ie_opcao_p = 'C')then
			return 'AT'; --Atendido
		elsif (ie_opcao_p = 'D') then

			Select	substr(obter_valor_dominio(8370, 'AT'), 1, 254)
			into STRICT	ds_valor_dominio_w
			;

			return 	ds_valor_dominio_w;
		end if;
	end;
elsif (obter_se_pac_obs(nr_atendimento_p) = 'S') then
	begin
		if (ie_opcao_p = 'C')then
			return 'EO'; --Em observação.
		elsif (ie_opcao_p = 'D') then

			Select	substr(obter_valor_dominio(8370, 'EO'), 1, 254)
			into STRICT	ds_valor_dominio_w
			;

			return 	ds_valor_dominio_w;
		end if;
	end;
elsif (dt_atend_medico_w IS NOT NULL AND dt_atend_medico_w::text <> '') then
	begin
		if (ie_opcao_p = 'C')then
			return 'EC'; --Em consulta
		elsif (ie_opcao_p = 'D') then

			Select	substr(obter_valor_dominio(8370, 'EC'), 1, 254)
			into STRICT	ds_valor_dominio_w
			;

			return 	ds_valor_dominio_w;
		end if;
	end;
elsif (dt_fim_triagem_w IS NOT NULL AND dt_fim_triagem_w::text <> '') then
	begin

		select  coalesce(max('S'),'N')
		into STRICT	ie_agenda_hoje_w
		from 	agenda_consulta
		where 	nr_atendimento   = nr_atendimento_p
		and		dt_agenda  between clock_timestamp() and fim_dia(clock_timestamp());

		if (ie_agenda_hoje_w = 'N') then
			if (ie_opcao_p = 'C')then
				Return 'AF'; --Acolhimento finalizado
			elsif (ie_opcao_p = 'D') then

				Select	substr(obter_valor_dominio(8370, 'AF'), 1, 254)
				into STRICT	ds_valor_dominio_w
				;

				return 	ds_valor_dominio_w;
			end if;
		else
			if (ie_opcao_p = 'C')then
				Return 'AC'; --Aguardando consulta
			elsif (ie_opcao_p = 'D') then

				Select	substr(obter_valor_dominio(8370, 'AC'), 1, 254)
				into STRICT	ds_valor_dominio_w
				;

				return 	ds_valor_dominio_w;
			end if;
		end if;
	end;
elsif (dt_inicio_atendimento_w IS NOT NULL AND dt_inicio_atendimento_w::text <> '') then
	begin
		if (ie_opcao_p = 'C')then
			return 'EA'; --Em acolhimento
		elsif (ie_opcao_p = 'D') then

			Select	substr(obter_valor_dominio(8370, 'EA'), 1, 254)
			into STRICT	ds_valor_dominio_w
			;

			return 	ds_valor_dominio_w;

		end if;
	end;
else
	begin
		if (ie_opcao_p = 'C')then
			return 'AA'; --Aguardando acolhimento
		elsif (ie_opcao_p = 'D') then

			Select	substr(obter_valor_dominio(8370, 'AA'), 1, 254)
			into STRICT	ds_valor_dominio_w
			;

			return 	ds_valor_dominio_w;


		end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_atend_pc ( nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
