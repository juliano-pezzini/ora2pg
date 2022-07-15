-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_inativar_avaliacao (nr_sequencia_p bigint , nm_usuario_inat_p text) AS $body$
BEGIN
 
IF (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') THEN 
 
	UPDATE CIH_CONTATO 
	SET	nm_usuario_inat_aval	= nm_usuario_inat_p, 
	    	dt_inativacao_aval	= clock_timestamp() 
	WHERE  nr_sequencia		= nr_sequencia_p;
 
	if (cih_obter_nr_seq_med_av_result(nr_sequencia_p) <> 0)then 
	 
		UPDATE MED_AVALIACAO_PACIENTE 
		SET	nm_usuario_inativacao	= nm_usuario_inat_p, 
			dt_inativacao		= clock_timestamp() 
		WHERE  nr_seq_contato		= nr_sequencia_p;
		 
	end if;
end if;
 
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_inativar_avaliacao (nr_sequencia_p bigint , nm_usuario_inat_p text) FROM PUBLIC;

