-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_medico_resp_atend ( nr_atendimento_p bigint, cd_medico_resp_p bigint) AS $body$
BEGIN
 
	IF (nr_atendimento_p > 0 AND cd_medico_resp_p > 0) THEN 
 
		UPDATE atendimento_paciente 
		SET  cd_medico_resp = cd_medico_resp_p	 
		WHERE nr_atendimento = nr_atendimento_p;
		 
		COMMIT;
	END IF;
	 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_medico_resp_atend ( nr_atendimento_p bigint, cd_medico_resp_p bigint) FROM PUBLIC;

