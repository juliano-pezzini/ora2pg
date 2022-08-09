-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE modificar_interv_medicao_cig (nr_seq_cig_p bigint, qt_min_interv_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_cig_p IS NOT NULL AND nr_seq_cig_p::text <> '') and (qt_min_interv_p IS NOT NULL AND qt_min_interv_p::text <> '') and (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then 
	/* atualizar data proximo controle */
 
	update	atendimento_cig 
	set	dt_proximo_controle	= dt_controle + qt_min_interv_p / 1440, 
		qt_min_interv_fut	= qt_min_interv_p 
	where	nr_sequencia		= nr_seq_cig_p;
 
	/* gerar evento */
 
	CALL gerar_alteracao_cig(nr_seq_cig_p, 8, ds_observacao_p, nm_usuario_p);
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE modificar_interv_medicao_cig (nr_seq_cig_p bigint, qt_min_interv_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
