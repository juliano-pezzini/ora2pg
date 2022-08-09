-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_add_valid_pend_desc ( nr_seq_pendency_p reg_validation_pendencies.nr_sequencia%TYPE, ds_description_p reg_validation_pendencies.ds_detail%TYPE, nm_usuario_p reg_validation_pendencies.nm_usuario%TYPE) AS $body$
BEGIN
	UPDATE	reg_validation_pendencies
	SET	nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		ds_detail	= ds_description_p
	WHERE	nr_sequencia	= nr_seq_pendency_p;

	COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_add_valid_pend_desc ( nr_seq_pendency_p reg_validation_pendencies.nr_sequencia%TYPE, ds_description_p reg_validation_pendencies.ds_detail%TYPE, nm_usuario_p reg_validation_pendencies.nm_usuario%TYPE) FROM PUBLIC;
