-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	----------------------------- 8 ---------------------------------
	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
CREATE OR REPLACE PROCEDURE panorama_leito_pck.gerar_w_ocor_teste_bac_8 ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, pIeConcluido text) AS $body$
DECLARE


	ds_alerta_w	varchar(10000)	:= null;
	ie_pac_mr_w			varchar(5);
	ie_pac_isol_w		varchar(5);

	
BEGIN

	ie_pac_mr_w		:=	Obter_se_paciente_MR(nr_atendimento_p);
	ie_pac_isol_w	:=	obter_se_pac_isolamento(nr_atendimento_p);

	if	(ie_pac_mr_w = 'S' AND ie_pac_isol_w = 'N') or
		(ie_pac_mr_w = 'N' AND ie_pac_isol_w = 'S')then

		if (ie_pac_mr_w = 'S') then
			ds_alerta_w := '795077';
		else
			ds_alerta_w := '795078';
		end if;
	end if;

	if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') then

		CALL panorama_leito_pck.insert_ocorrencia(nr_atendimento_p,
						8,
						'assets/icons/status-and-feedback/bacteria-clock.svg',
						'assets/icons/status-and-feedback/bacteria-clock.svg',
						654180, /* Teste bacteria*/
						967496,
						null,
						988847,
						ds_alerta_w,
						3,
                        pIeConcluido);
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE panorama_leito_pck.gerar_w_ocor_teste_bac_8 ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, pIeConcluido text) FROM PUBLIC;
