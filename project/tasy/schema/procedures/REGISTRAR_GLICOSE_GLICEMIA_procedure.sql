-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_glicose_glicemia (nr_seq_cig_p bigint, qt_glicose_adm_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_cig_p IS NOT NULL AND nr_seq_cig_p::text <> '') and (qt_glicose_adm_p IS NOT NULL AND qt_glicose_adm_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	/* atualizar glicose */
 
	update	atendimento_cig 
	set	qt_glicose_adm	= qt_glicose_adm_p, 
		nm_usuario		= nm_usuario_p 
	where	nr_sequencia		= nr_seq_cig_p;
 
	/* gerar evento */
 
	CALL gerar_alteracao_cig(nr_seq_cig_p, 7, ds_observacao_p, nm_usuario_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_glicose_glicemia (nr_seq_cig_p bigint, qt_glicose_adm_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
