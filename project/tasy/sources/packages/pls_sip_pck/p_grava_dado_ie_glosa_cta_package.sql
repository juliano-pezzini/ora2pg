-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.p_grava_dado_ie_glosa_cta ( tb_rowid_p INOUT pls_util_cta_pck.t_rowid, tb_ie_glosa_conta_p INOUT pls_util_cta_pck.t_varchar2_table_1, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

-- se tiver algo para atualizar

if (tb_rowid_p.count > 0) then

	-- atualiza os dados no banco

	forall i in tb_rowid_p.first..tb_rowid_p.last
		update	sip_nv_dados set
			ie_glosa_conta = tb_ie_glosa_conta_p(i),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	rowid = tb_rowid_p(i);
		commit;
	
	-- limpa as variaveis

	tb_rowid_p.delete;
	tb_ie_glosa_conta_p.delete;
end if;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.p_grava_dado_ie_glosa_cta ( tb_rowid_p INOUT pls_util_cta_pck.t_rowid, tb_ie_glosa_conta_p INOUT pls_util_cta_pck.t_varchar2_table_1, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
