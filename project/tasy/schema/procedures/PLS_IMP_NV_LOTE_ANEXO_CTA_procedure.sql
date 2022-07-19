-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_nv_lote_anexo_cta ( nr_seq_conta_p pls_conta_imp.nr_sequencia%type, ie_origem_p pls_lote_anexo_cta_imp.ie_origem%type, cd_guia_prestador_p pls_lote_anexo_cta_imp.cd_guia_prestador%type, cd_guia_operadora_p pls_lote_anexo_cta_imp.cd_guia%type, cd_guia_principal_p pls_lote_anexo_cta_imp.cd_guia_referencia%type, ie_sinais_doenca_periodontal_p pls_lote_anexo_cta_imp.ie_sinais_doenca_periodont%type, ie_alter_tecido_mole_p pls_lote_anexo_cta_imp.ie_alter_tecido_mole%type, ie_tipo_anexo_p pls_lote_anexo_cta_imp.ie_tipo_anexo%type, ds_observacao_p pls_lote_anexo_cta_imp.ds_observacao%type, cd_usuario_plano_p pls_lote_anexo_cta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_lote_anexo_cta_imp.nm_beneficiario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_cta_p INOUT pls_lote_anexo_cta_imp.nr_sequencia%type) AS $body$
BEGIN

-- se for para usar a nova forma de importação XML chama da package, caso contrário chama a rotina antiga
if (pls_imp_xml_cta_pck.usar_nova_imp_xml(cd_estabelecimento_p) = 'S') then

	nr_seq_lote_cta_p := pls_imp_xml_cta_pck.pls_imp_nv_lote_anexo_cta(	nr_seq_conta_p, ie_origem_p, cd_guia_prestador_p, cd_guia_operadora_p, cd_guia_principal_p, ie_sinais_doenca_periodontal_p, ie_alter_tecido_mole_p, ie_tipo_anexo_p, ds_observacao_p, cd_usuario_plano_p, nm_beneficiario_p, nm_usuario_p, nr_seq_lote_cta_p);
else
	select	nextval('pls_lote_anexo_cta_imp_seq')
	into STRICT	nr_seq_lote_cta_p
	;

	-- rotinas da estrutura antiga
	-- com o tempo a mesma deve sair daqui e ficar só o novo método de implementação
	CALL pls_imp_lote_anexo_cta(	nm_usuario_p, cd_guia_operadora_p,
				cd_guia_principal_p, cd_guia_prestador_p,
				cd_usuario_plano_p, nm_beneficiario_p,
				null, ds_observacao_p,
				null, ie_tipo_anexo_p,
				ie_sinais_doenca_periodontal_p, ie_alter_tecido_mole_p,
				ie_origem_p, nr_seq_conta_p,
				nr_seq_lote_cta_p, null);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_nv_lote_anexo_cta ( nr_seq_conta_p pls_conta_imp.nr_sequencia%type, ie_origem_p pls_lote_anexo_cta_imp.ie_origem%type, cd_guia_prestador_p pls_lote_anexo_cta_imp.cd_guia_prestador%type, cd_guia_operadora_p pls_lote_anexo_cta_imp.cd_guia%type, cd_guia_principal_p pls_lote_anexo_cta_imp.cd_guia_referencia%type, ie_sinais_doenca_periodontal_p pls_lote_anexo_cta_imp.ie_sinais_doenca_periodont%type, ie_alter_tecido_mole_p pls_lote_anexo_cta_imp.ie_alter_tecido_mole%type, ie_tipo_anexo_p pls_lote_anexo_cta_imp.ie_tipo_anexo%type, ds_observacao_p pls_lote_anexo_cta_imp.ds_observacao%type, cd_usuario_plano_p pls_lote_anexo_cta_imp.cd_usuario_plano%type, nm_beneficiario_p pls_lote_anexo_cta_imp.nm_beneficiario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_cta_p INOUT pls_lote_anexo_cta_imp.nr_sequencia%type) FROM PUBLIC;

