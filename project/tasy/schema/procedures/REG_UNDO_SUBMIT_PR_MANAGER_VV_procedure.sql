-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_undo_submit_pr_manager_vv ( nr_seq_product_req_p reg_product_requirement.nr_sequencia%TYPE, nm_usuario_p reg_product_requirement.nm_liberou_ger_vv%TYPE ) AS $body$
BEGIN
	UPDATE	reg_product_requirement
	SET	dt_liberou_ger_vv  = NULL,
		nm_liberou_ger_vv  = NULL,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	WHERE	nr_sequencia = nr_seq_product_req_p;

	COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_undo_submit_pr_manager_vv ( nr_seq_product_req_p reg_product_requirement.nr_sequencia%TYPE, nm_usuario_p reg_product_requirement.nm_liberou_ger_vv%TYPE ) FROM PUBLIC;

