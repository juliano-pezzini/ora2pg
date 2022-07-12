-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_imp_xml_integracao_ws_pck.pls_imp_encaminhar_exec ( cd_transacao_p ptu_encaminhar_execucao_pa.cd_transacao%type, ie_tipo_cliente_p ptu_encaminhar_execucao_pa.ie_tipo_cliente%type, cd_unimed_origem_p ptu_encaminhar_execucao_pa.cd_operadora_origem%type, cd_unimed_destino_p ptu_encaminhar_execucao_pa.cd_operadora_destino%type, nr_registro_ans_p ptu_encaminhar_execucao_pa.nr_registro_ans%type, nr_trans_inicial_p ptu_encaminhar_execucao_pa.nr_seq_origem%type, nr_trans_origem_p ptu_encaminhar_execucao_pa.nr_seq_execucao%type, dt_geracao_p text, nm_usuario_transacao_p ptu_encaminhar_execucao_pa.nm_usuario_transacao%type, cd_unimed_p ptu_encaminhar_execucao_pa.cd_operadora%type, cd_usuario_plano_p ptu_encaminhar_execucao_pa.cd_usuario_plano%type, nm_benef_p ptu_encaminhar_execucao_pa.nm_beneficiario%type, cd_cpf_p ptu_encaminhar_execucao_pa.cd_cpf%type, cd_ddd_p ptu_encaminhar_execucao_pa.nr_ddd%type, cd_telefone_p ptu_encaminhar_execucao_pa.nr_telefone%type, ds_email_p ptu_encaminhar_execucao_pa.ds_email%type, ie_tipo_manifestacao_p ptu_encaminhar_execucao_pa.ie_tipo_manifestacao%type, ie_tipo_categoria_p ptu_encaminhar_execucao_pa.ie_tipo_categoria%type, ie_tipo_sentimento_p ptu_encaminhar_execucao_pa.ie_tipo_sentimento%type, nr_trans_intercambio_p ptu_encaminhar_execucao_pa.nr_trans_intercambio%type, nr_protocolo_p ptu_encaminhar_execucao_pa.nr_protocolo%type, nr_protocolo_ant_p ptu_encaminhar_execucao_pa.nr_protocolo_referencia%type, ds_mensagem_p ptu_encaminhar_execucao_pa.ds_mensagem_livre%type, nr_versao_p ptu_encaminhar_execucao_pa.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_encaminha_exec_p INOUT ptu_encaminhar_execucao_pa.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gravar nas tabelas de Encaminhamento de Execucao que foi enviado via web service
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[  ]  Objetos do dicionario [ X] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

nr_seq_protocolo_atend_w	pls_protocolo_atendimento.nr_sequencia%type;
nr_protocolo_w			pls_atendimento.nr_protocolo_atendimento%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

BEGIN

if (coalesce(cd_estabelecimento_p,0) > 0) then
	cd_estabelecimento_w := cd_estabelecimento_p;
else
	cd_estabelecimento_w := pls_imp_xml_integracao_ws_pck.obter_estab_padrao_gpi();
end if;

select	max(nr_seq_segurado)
into STRICT	nr_seq_segurado_w
from	pls_segurado_carteira
where	cd_usuario_plano = cd_usuario_plano_p;

SELECT * FROM pls_imp_xml_integracao_ws_pck.gravar_protocolo_atend('6', nr_seq_segurado_w, null, cd_estabelecimento_w, nm_usuario_p, nr_seq_protocolo_atend_w, nr_protocolo_w) INTO STRICT nr_seq_protocolo_atend_w, nr_protocolo_w;

insert into ptu_encaminhar_execucao_pa(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_operadora_origem, cd_operadora_destino, nr_registro_ans,
	nr_seq_origem, nr_seq_execucao, dt_geracao,
	nm_usuario_transacao, cd_operadora, cd_usuario_plano,
	nm_beneficiario, cd_cpf, nr_ddd,
	nr_telefone, ds_email, ie_tipo_manifestacao,
	ie_tipo_categoria, ie_tipo_sentimento, nr_trans_intercambio,
	nr_seq_protocolo, nr_protocolo, nr_protocolo_referencia,
	ds_mensagem_livre, nr_versao, nm_usuario,
	cd_estabelecimento)
values (nextval('ptu_encaminhar_execucao_pa_seq'), cd_transacao_p, ie_tipo_cliente_p,
	cd_unimed_origem_p, cd_unimed_destino_p, nr_registro_ans_p,
	nr_trans_inicial_p, nr_trans_origem_p, dt_geracao_p,
	nm_usuario_transacao_p, cd_unimed_p, cd_usuario_plano_p,
	nm_benef_p, cd_cpf_p, cd_ddd_p,
	cd_telefone_p, ds_email_p, ie_tipo_manifestacao_p,
	ie_tipo_categoria_p, ie_tipo_sentimento_p, nr_trans_intercambio_p,
	nr_seq_protocolo_atend_w, nr_protocolo_p, nr_protocolo_ant_p, 
	ds_mensagem_p, nr_versao_p, nm_usuario_p, 
	cd_estabelecimento_w) returning nr_sequencia into nr_seq_encaminha_exec_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_integracao_ws_pck.pls_imp_encaminhar_exec ( cd_transacao_p ptu_encaminhar_execucao_pa.cd_transacao%type, ie_tipo_cliente_p ptu_encaminhar_execucao_pa.ie_tipo_cliente%type, cd_unimed_origem_p ptu_encaminhar_execucao_pa.cd_operadora_origem%type, cd_unimed_destino_p ptu_encaminhar_execucao_pa.cd_operadora_destino%type, nr_registro_ans_p ptu_encaminhar_execucao_pa.nr_registro_ans%type, nr_trans_inicial_p ptu_encaminhar_execucao_pa.nr_seq_origem%type, nr_trans_origem_p ptu_encaminhar_execucao_pa.nr_seq_execucao%type, dt_geracao_p text, nm_usuario_transacao_p ptu_encaminhar_execucao_pa.nm_usuario_transacao%type, cd_unimed_p ptu_encaminhar_execucao_pa.cd_operadora%type, cd_usuario_plano_p ptu_encaminhar_execucao_pa.cd_usuario_plano%type, nm_benef_p ptu_encaminhar_execucao_pa.nm_beneficiario%type, cd_cpf_p ptu_encaminhar_execucao_pa.cd_cpf%type, cd_ddd_p ptu_encaminhar_execucao_pa.nr_ddd%type, cd_telefone_p ptu_encaminhar_execucao_pa.nr_telefone%type, ds_email_p ptu_encaminhar_execucao_pa.ds_email%type, ie_tipo_manifestacao_p ptu_encaminhar_execucao_pa.ie_tipo_manifestacao%type, ie_tipo_categoria_p ptu_encaminhar_execucao_pa.ie_tipo_categoria%type, ie_tipo_sentimento_p ptu_encaminhar_execucao_pa.ie_tipo_sentimento%type, nr_trans_intercambio_p ptu_encaminhar_execucao_pa.nr_trans_intercambio%type, nr_protocolo_p ptu_encaminhar_execucao_pa.nr_protocolo%type, nr_protocolo_ant_p ptu_encaminhar_execucao_pa.nr_protocolo_referencia%type, ds_mensagem_p ptu_encaminhar_execucao_pa.ds_mensagem_livre%type, nr_versao_p ptu_encaminhar_execucao_pa.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_encaminha_exec_p INOUT ptu_encaminhar_execucao_pa.nr_sequencia%type) FROM PUBLIC;