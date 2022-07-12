-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_coparticipacao_pck.get_dt_inicio_fim_regra_incid (dt_inicio_regra_p INOUT timestamp, dt_fim_regra_p INOUT timestamp, pls_regra_copartic_util_p pls_regra_copartic_util) AS $body$
BEGIN
		if (pls_regra_copartic_util_p.ie_tipo_data_consistencia = 'S') then 
			if (pls_regra_copartic_util_p.ie_tipo_periodo_ocor	= 'D') then 
				dt_inicio_regra_p		:= trunc(clock_timestamp(),'dd') - pls_regra_copartic_util_p.qt_periodo_ocorrencia;
			elsif (pls_regra_copartic_util_p.ie_tipo_periodo_ocor = 'M') then 
				dt_inicio_regra_p		:= add_months(trunc(clock_timestamp(),'mm'), - pls_regra_copartic_util_p.qt_periodo_ocorrencia);
			end if;
			 
			dt_fim_regra_p := fim_dia(clock_timestamp());
		elsif (pls_regra_copartic_util_p.ie_tipo_data_consistencia = 'A') then 
			dt_inicio_regra_p := trunc(current_setting('pls_coparticipacao_pck.pls_segurado_w')::pls_segurado%rowtype.dt_contratacao, 'dd');
			dt_fim_regra_p := fim_dia(add_months(current_setting('pls_coparticipacao_pck.pls_segurado_w')::pls_segurado%rowtype.dt_contratacao, 12));
			while(not(get_dt_item between dt_inicio_regra_p and dt_fim_regra_p)) loop 
				dt_inicio_regra_p := dt_fim_regra_p;
				dt_fim_regra_p	 := add_months(dt_fim_regra_p, 12);
			end loop;
		elsif (pls_regra_copartic_util_p.ie_tipo_data_consistencia = 'C') then 
			dt_inicio_regra_p := trunc(get_dt_contrato, 'dd');
			dt_fim_regra_p := fim_dia(add_months(get_dt_contrato, 12));
			while(not(get_dt_item between dt_inicio_regra_p and dt_fim_regra_p)) loop 
				dt_inicio_regra_p := dt_fim_regra_p;
				dt_fim_regra_p	 := add_months(dt_fim_regra_p, 12);
			end loop;
		elsif (pls_regra_copartic_util_p.ie_tipo_data_consistencia = 'L') then 
			dt_inicio_regra_p	:= trunc(to_date('01/01/'||to_char(get_dt_item,'yyyy')),'dd');
			dt_fim_regra_p		:= fim_dia(to_date('31/12/'||to_char(get_dt_item,'yyyy')));
		end if;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_coparticipacao_pck.get_dt_inicio_fim_regra_incid (dt_inicio_regra_p INOUT timestamp, dt_fim_regra_p INOUT timestamp, pls_regra_copartic_util_p pls_regra_copartic_util) FROM PUBLIC;
