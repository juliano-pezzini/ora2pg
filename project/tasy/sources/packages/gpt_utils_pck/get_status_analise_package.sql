-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gpt_utils_pck.get_status_analise (ie_param_1_p text, dt_inicio_analise_enf_p timestamp, dt_fim_analise_enf_p timestamp, nm_compl_resp_analise_enf_p text, dt_inicio_analise_farm_p timestamp, dt_fim_analise_farm_p timestamp, nm_compl_resp_analise_farm_p text, ie_opcao_p integer default 1) RETURNS varchar AS $body$
DECLARE


	/*
	ie_opcao_p = 1: Retorna ordenacao (1-Pendente, 2-Em analise, 3-Finalizada)
	ie_opcao_p = 2: Retorna descricao (Pendente, Em analise, Finalizada)
	*/


	ie_status_w		varchar(150);

	
BEGIN

	if (ie_param_1_p = 'E') then

		if (dt_inicio_analise_enf_p IS NOT NULL AND dt_inicio_analise_enf_p::text <> '') and (coalesce(dt_fim_analise_enf_p::text, '') = '') and (nm_compl_resp_analise_enf_p IS NOT NULL AND nm_compl_resp_analise_enf_p::text <> '') then

				if (ie_opcao_p = 1) then
					ie_status_w	:=	2;
				else
					ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1199197), 1, 150);
				end if;

		elsif (dt_fim_analise_enf_p IS NOT NULL AND dt_fim_analise_enf_p::text <> '') and (nm_compl_resp_analise_enf_p IS NOT NULL AND nm_compl_resp_analise_enf_p::text <> '') then

					if (ie_opcao_p = 1) then
						ie_status_w	:=	3;
					else
						ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1199198), 1, 150);
					end if;

		else

			if (ie_opcao_p = 1) then
				ie_status_w	:=	1;
			else
				ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1139207), 1, 150);
			end if;

		end if;

	elsif (ie_param_1_p = 'F') then

		if (dt_inicio_analise_farm_p IS NOT NULL AND dt_inicio_analise_farm_p::text <> '') and (coalesce(dt_fim_analise_farm_p::text, '') = '') and (nm_compl_resp_analise_farm_p IS NOT NULL AND nm_compl_resp_analise_farm_p::text <> '') then

				if (ie_opcao_p = 1) then
					ie_status_w	:=	2;
				else
					ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1199197),1 ,150);
				end if;

		elsif (dt_fim_analise_farm_p IS NOT NULL AND dt_fim_analise_farm_p::text <> '') and (nm_compl_resp_analise_farm_p IS NOT NULL AND nm_compl_resp_analise_farm_p::text <> '') then

					if (ie_opcao_p = 1) then
						ie_status_w	:=	3;
					else
						ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1199198),1 ,150);
					end if;

		else

			if (ie_opcao_p = 1) then
				ie_status_w	:=	1;
			else
				ie_status_w	:=	substr(wheb_mensagem_pck.get_texto(1139207),1 ,150);
			end if;

		end if;

	end if;

	return	ie_status_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gpt_utils_pck.get_status_analise (ie_param_1_p text, dt_inicio_analise_enf_p timestamp, dt_fim_analise_enf_p timestamp, nm_compl_resp_analise_enf_p text, dt_inicio_analise_farm_p timestamp, dt_fim_analise_farm_p timestamp, nm_compl_resp_analise_farm_p text, ie_opcao_p integer default 1) FROM PUBLIC;
