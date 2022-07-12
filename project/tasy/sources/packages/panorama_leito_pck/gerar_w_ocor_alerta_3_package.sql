-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	/*
	-------------------- Ocorrencias (icones) -------------------------
	*/
	/*XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	----------------------------- 3---------------------------------
	XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX*/
CREATE OR REPLACE PROCEDURE panorama_leito_pck.gerar_w_ocor_alerta_3 ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, pIeConcluido text ) AS $body$
DECLARE


	ds_alerta_w	varchar(10000)	:= null;
        dt_alerta_w	varchar(4000)	:= null;

	c_alerta CURSOR FOR
		SELECT	a.dt_alerta,
				a.ds_alerta
		FROM	atendimento_alerta a,
				atendimento_paciente b
		WHERE	b.cd_pessoa_fisica = cd_pessoa_fisica_p
		AND		a.nr_atendimento = b.nr_atendimento
		AND		a.ie_situacao = 'A'
		and		((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd')))
		
UNION ALL

		SELECT	a.dt_alerta,
				a.ds_alerta
		FROM	Alerta_paciente a
		WHERE	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		AND		a.ie_situacao = 'A'
		and		((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd')))
		ORDER BY 1, 2;

	
BEGIN

	for r_c_alerta in c_alerta loop
		if (coalesce(length(ds_alerta_w),0) < 10000) then
            dt_alerta_w := 'flagStart' || to_char(r_c_alerta.dt_alerta,'dd/mm/yyyy hh24:mi:ss') || 'flagEnd';
			ds_alerta_w	:= 	substr(ds_alerta_w || dt_alerta_w || ' - ' || r_c_alerta.ds_alerta|| '<br>',1,4000);
		end if;
	end loop;

	if (ds_alerta_w IS NOT NULL AND ds_alerta_w::text <> '') then
		CALL panorama_leito_pck.insert_ocorrencia(nr_atendimento_p,
					3,
					'assets/icons/status-and-feedback/alert.svg',
					'assets/icons/status-and-feedback/alert.svg',
					283352, /* Alertas */
					968048,
					317652, /* Visualizar alertas */
					968176,
					ds_alerta_w,
					2,
                    pIeConcluido);
	end if;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE panorama_leito_pck.gerar_w_ocor_alerta_3 ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, pIeConcluido text ) FROM PUBLIC;