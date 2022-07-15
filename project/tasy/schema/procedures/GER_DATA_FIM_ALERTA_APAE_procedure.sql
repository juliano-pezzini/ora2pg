-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ger_data_fim_alerta_apae (nr_sequencia_p bigint, dt_fim_date_p timestamp) AS $body$
BEGIN
IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')THEN	
	IF (dt_fim_date_p IS NOT NULL AND dt_fim_date_p::text <> '') THEN
		UPDATE 	ALERTA_ANESTESIA_APAE
		SET 	dt_fim_alerta = dt_fim_date_p,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = wheb_usuario_pck.get_nm_usuario		
		WHERE 	nr_sequencia = nr_sequencia_p;	
	END IF;
END IF;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_data_fim_alerta_apae (nr_sequencia_p bigint, dt_fim_date_p timestamp) FROM PUBLIC;

