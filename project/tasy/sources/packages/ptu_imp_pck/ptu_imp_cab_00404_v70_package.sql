-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00404 Resposta de Auditoria-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_imp_pck.ptu_imp_cab_00404_v70 ( cd_transacao_p ptu_resposta_auditoria.cd_transacao%type, cd_unimed_beneficiario_p ptu_resposta_auditoria.cd_unimed_beneficiario%type, cd_unimed_executora_p ptu_resposta_auditoria.cd_unimed_executora%type, ds_observacao_p ptu_resposta_auditoria.ds_observacao%type, dt_validade_p text, ie_tipo_autorizacao_p ptu_resposta_auditoria.ie_tipo_autorizacao%type, ie_tipo_cliente_p ptu_resposta_auditoria.ie_tipo_cliente%type, nr_seq_execucao_p ptu_resposta_auditoria.nr_seq_execucao%type, nr_seq_origem_p ptu_resposta_auditoria.nr_seq_origem%type, nr_versao_p ptu_resposta_auditoria.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resp_aud_p INOUT ptu_resposta_auditoria.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a importacao do arquivo de 00404 - Resposta de Auditoria
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [ x] Tasy (Delphi/Java) [  x] Portal [  ]  Relatorios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


ie_tipo_cliente_w	ptu_resposta_auditoria.ie_tipo_cliente%type;
dt_validade_w		ptu_resposta_auditoria.dt_validade%type;


BEGIN

if (coalesce(dt_validade_p,'X')	<> 'X') then
	begin
		dt_validade_w	:= to_date(dt_validade_p, 'dd/mm/rrrr');
	exception
	when others then
		dt_validade_w	:= clock_timestamp();
	end;
end if;

-- Validacao e necessario converter os dados para  somente uma letra

ie_tipo_cliente_w := ptu_converter_tipo_cliente(ie_tipo_cliente_p);

insert	into ptu_resposta_auditoria(nr_sequencia, cd_transacao, ie_tipo_cliente,
	cd_unimed_executora, cd_unimed_beneficiario, nr_seq_execucao,
	nr_seq_origem, dt_atualizacao, nm_usuario,
	dt_validade, nr_versao, ds_observacao,
	ie_tipo_autorizacao, nm_usuario_nrec, dt_atualizacao_nrec)
values (nextval('ptu_resposta_auditoria_seq'), cd_transacao_p, ie_tipo_cliente_w,
	cd_unimed_executora_p, cd_unimed_beneficiario_p, nr_seq_execucao_p,
	nr_seq_origem_p, clock_timestamp(), nm_usuario_p,
	dt_validade_w, nr_versao_p, ds_observacao_p,
	ie_tipo_autorizacao_p, nm_usuario_p, clock_timestamp()) returning nr_sequencia into nr_seq_resp_aud_p;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_pck.ptu_imp_cab_00404_v70 ( cd_transacao_p ptu_resposta_auditoria.cd_transacao%type, cd_unimed_beneficiario_p ptu_resposta_auditoria.cd_unimed_beneficiario%type, cd_unimed_executora_p ptu_resposta_auditoria.cd_unimed_executora%type, ds_observacao_p ptu_resposta_auditoria.ds_observacao%type, dt_validade_p text, ie_tipo_autorizacao_p ptu_resposta_auditoria.ie_tipo_autorizacao%type, ie_tipo_cliente_p ptu_resposta_auditoria.ie_tipo_cliente%type, nr_seq_execucao_p ptu_resposta_auditoria.nr_seq_execucao%type, nr_seq_origem_p ptu_resposta_auditoria.nr_seq_origem%type, nr_versao_p ptu_resposta_auditoria.nr_versao%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resp_aud_p INOUT ptu_resposta_auditoria.nr_sequencia%type) FROM PUBLIC;
