-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_submit_customer_req_vv ( nr_seq_customer_requirement_p reg_customer_requirement.nr_sequencia%TYPE, nm_usuario_p reg_customer_requirement.nm_liberacao_vv%TYPE ) AS $body$
BEGIN
	UPDATE	reg_customer_requirement
	SET	nm_liberacao_vv = CASE WHEN nm_liberacao_vv = NULL THEN  nm_usuario_p  ELSE NULL END ,
		nm_usuario = nm_usuario_p,
		dt_liberacao_vv = CASE WHEN dt_liberacao_vv = NULL THEN  clock_timestamp()  ELSE NULL END ,
		dt_atualizacao = clock_timestamp()
	WHERE	nr_sequencia = nr_seq_customer_requirement_p;

	COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_submit_customer_req_vv ( nr_seq_customer_requirement_p reg_customer_requirement.nr_sequencia%TYPE, nm_usuario_p reg_customer_requirement.nm_liberacao_vv%TYPE ) FROM PUBLIC;

