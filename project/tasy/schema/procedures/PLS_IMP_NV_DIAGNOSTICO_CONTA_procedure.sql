-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nv_diagnostico_conta ( nr_seq_conta_p pls_conta_imp.nr_sequencia%type, ie_indicacao_acidente_p pls_diagnostico_conta.ie_indicacao_acidente%type, cd_doenca_p pls_diagnostico_conta_imp.cd_doenca%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

-- se for para usar a nova forma de importação XML chama da package, caso contrário chama a rotina antiga
if (pls_imp_xml_cta_pck.usar_nova_imp_xml(cd_estabelecimento_p) = 'S') then

	CALL pls_imp_xml_cta_pck.pls_imp_nv_diagnostico_conta(	nr_seq_conta_p, cd_doenca_p, nm_usuario_p);
else
	-- rotinas da estrutura antiga
	-- com o tempo a mesma deve sair daqui e ficar só o novo método de implementação
	CALL pls_imp_diagnostico_conta(	null, cd_doenca_p,
				null, nr_seq_conta_p,
				null, ie_indicacao_acidente_p,
				null, null,
				nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nv_diagnostico_conta ( nr_seq_conta_p pls_conta_imp.nr_sequencia%type, ie_indicacao_acidente_p pls_diagnostico_conta.ie_indicacao_acidente%type, cd_doenca_p pls_diagnostico_conta_imp.cd_doenca%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

