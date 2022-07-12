-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_ocor_imp_pck.atualizar_ocorrencia_imp ( tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_ds_observacao_p INOUT pls_util_cta_pck.t_varchar2_table_4000, nr_indice_p INOUT integer, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
-- se tiver registros manda para o banco

if (tb_nr_sequencia_p.count > 0) then
	forall i in tb_nr_sequencia_p.first .. tb_nr_sequencia_p.last
		update	pls_ocorrencia_imp set
			ds_observacao = tb_ds_observacao_p(i),
			ie_situacao = 'A',
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = tb_nr_sequencia_p(i);
	commit;
end if;

tb_nr_sequencia_p.delete;
tb_ds_observacao_p.delete;
nr_indice_p := 0;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ocor_imp_pck.atualizar_ocorrencia_imp ( tb_nr_sequencia_p INOUT pls_util_cta_pck.t_number_table, tb_ds_observacao_p INOUT pls_util_cta_pck.t_varchar2_table_4000, nr_indice_p INOUT integer, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
