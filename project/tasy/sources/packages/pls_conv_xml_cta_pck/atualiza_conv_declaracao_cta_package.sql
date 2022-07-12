-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.atualiza_conv_declaracao_cta ( tb_nr_seq_decl_conta_p INOUT pls_util_cta_pck.t_number_table, tb_cd_doenca_obito_p INOUT pls_util_cta_pck.t_varchar2_table_10) AS $body$
BEGIN
-- Verifica se tem algo para atualizar

if (tb_nr_seq_decl_conta_p.count > 0) then
	-- se tiver atualiza

	forall i in tb_nr_seq_decl_conta_p.first..tb_nr_seq_decl_conta_p.last
		update  pls_decl_conta_obito_imp
		set	cd_doenca_obito_conv = tb_cd_doenca_obito_p(i)
		where	nr_sequencia = tb_nr_seq_decl_conta_p(i);
		
	commit;
end if;

--Limpa as vari_veis

tb_nr_seq_decl_conta_p.delete;
tb_cd_doenca_obito_p.delete;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.atualiza_conv_declaracao_cta ( tb_nr_seq_decl_conta_p INOUT pls_util_cta_pck.t_number_table, tb_cd_doenca_obito_p INOUT pls_util_cta_pck.t_varchar2_table_10) FROM PUBLIC;
