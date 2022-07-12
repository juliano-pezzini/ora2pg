-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_ted.gerar_tipo_lote ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, ie_tipo_lote_p pls_ted_conta_lote.ie_tipo_lote%type, dt_competencia_p pls_ted_conta_lote.dt_competencia%type, nr_seq_segurado_p pls_ted_conta_lote.nr_seq_segurado%type, nr_seq_titular_p pls_ted_conta_lote.nr_seq_titular%type, nr_seq_contrato_p pls_ted_conta_lote.nr_seq_contrato%type, nr_seq_contrato_grupo_p pls_ted_conta_lote.nr_seq_contrato_grupo%type, cd_cgc_p pls_ted_conta_lote.cd_cgc%type, nr_seq_tipo_conta_p pls_ted_conta_lote.nr_seq_tipo_conta%type default null, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL) AS $body$
BEGIN

if (ie_tipo_lote_p = '1') then
	CALL pls_gerar_contas_ted.gerar_dados_dep_quimico(	nr_seq_lote_p, dt_competencia_p, nr_seq_segurado_p, nr_seq_titular_p, nr_seq_contrato_p, nr_seq_contrato_grupo_p, cd_cgc_p,nr_seq_tipo_conta_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_tipo_lote_p = '2') then
	CALL pls_gerar_contas_ted.gerar_dados_acid_trabalho(	nr_seq_lote_p, dt_competencia_p, nr_seq_segurado_p, nr_seq_titular_p, nr_seq_contrato_p, nr_seq_contrato_grupo_p, cd_cgc_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_tipo_lote_p = '3') then
	CALL pls_gerar_contas_ted.gerar_dados_med_ocupacional(	nr_seq_lote_p, dt_competencia_p, nr_seq_segurado_p, nr_seq_titular_p, nr_seq_contrato_p, nr_seq_contrato_grupo_p, cd_cgc_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_tipo_lote_p = '4') then
	CALL pls_gerar_contas_ted.gerar_dados_exchep(	nr_seq_lote_p, dt_competencia_p, nr_seq_segurado_p, nr_seq_titular_p, nr_seq_contrato_p, nr_seq_contrato_grupo_p, cd_cgc_p, nm_usuario_p, cd_estabelecimento_p);
end if;

end;





$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_ted.gerar_tipo_lote ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, ie_tipo_lote_p pls_ted_conta_lote.ie_tipo_lote%type, dt_competencia_p pls_ted_conta_lote.dt_competencia%type, nr_seq_segurado_p pls_ted_conta_lote.nr_seq_segurado%type, nr_seq_titular_p pls_ted_conta_lote.nr_seq_titular%type, nr_seq_contrato_p pls_ted_conta_lote.nr_seq_contrato%type, nr_seq_contrato_grupo_p pls_ted_conta_lote.nr_seq_contrato_grupo%type, cd_cgc_p pls_ted_conta_lote.cd_cgc%type, nr_seq_tipo_conta_p pls_ted_conta_lote.nr_seq_tipo_conta%type default null, nm_usuario_p usuario.nm_usuario%type DEFAULT NULL, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type DEFAULT NULL) FROM PUBLIC;