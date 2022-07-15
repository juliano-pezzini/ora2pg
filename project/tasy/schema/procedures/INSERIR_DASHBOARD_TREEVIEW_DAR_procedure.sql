-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_dashboard_treeview_dar (CD_ESTABELECIMENTO_P bigint, NM_USUARIO_P text) AS $body$
DECLARE
 root_exst_w bigint;

BEGIN

	SELECT CASE
		WHEN 
			EXISTS (SELECT 1 FROM DAR_TREE_DASHBOARD)
		THEN 1
		ELSE 0
		END INTO STRICT root_exst_w
	;

	IF (root_exst_w = 0) THEN
		INSERT INTO DAR_TREE_DASHBOARD(nr_sequencia, nr_seq_ordem, ds_titulo, cd_estabelecimento, dt_atualizacao, nm_usuario) values (0, 1, 'Shared Visualization', CD_ESTABELECIMENTO_P, clock_timestamp(), NM_USUARIO_P);
		INSERT INTO DAR_TREE_DASHBOARD(nr_sequencia, nr_seq_ordem, ds_titulo, cd_estabelecimento, dt_atualizacao, nm_usuario) values (1, 1, 'Private Visualization', CD_ESTABELECIMENTO_P, clock_timestamp(), NM_USUARIO_P);
	END IF;

    COMMIT;
	
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_dashboard_treeview_dar (CD_ESTABELECIMENTO_P bigint, NM_USUARIO_P text) FROM PUBLIC;

