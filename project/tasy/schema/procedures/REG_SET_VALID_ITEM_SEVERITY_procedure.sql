-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_set_valid_item_severity ( nr_seq_item_p reg_validation_pend_item.nr_sequencia%TYPE, ie_severity_p reg_validation_pend_item.ie_severity%TYPE, nm_usuario_p reg_validation_pend_item.nm_usuario%TYPE) AS $body$
BEGIN
	UPDATE	reg_validation_pend_item
	SET	ie_severity = ie_severity_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	WHERE	nr_sequencia = nr_seq_item_p;

	COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_set_valid_item_severity ( nr_seq_item_p reg_validation_pend_item.nr_sequencia%TYPE, ie_severity_p reg_validation_pend_item.ie_severity%TYPE, nm_usuario_p reg_validation_pend_item.nm_usuario%TYPE) FROM PUBLIC;
