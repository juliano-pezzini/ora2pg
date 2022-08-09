-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_resposta_pa ( nr_seq_protocolo_p pls_protocolo_atendimento.nr_sequencia%type, ie_resposta_p ptu_resp_atendimento_pa.ie_resposta%type, ds_mensagem_livre_p ptu_resp_atendimento_pa.ds_mensagem_livre%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resp_atendimento_pa INOUT ptu_resp_atendimento_pa.nr_sequencia%type) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
Gerar a resposta do protocolo de atendimento 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ x] Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
cd_usuario_plano_w		pls_segurado_carteira.cd_usuario_plano%type;
cd_cgc_outorgante_w		pls_outorgante.cd_cgc_outorgante%type;
cd_cooperativa_w			pls_congenere.cd_cooperativa%type;
cd_congenere_w			pls_congenere.cd_cooperativa%type;
cd_operadora_destino_w		pls_protocolo_atendimento.cd_operadora_destino%type;	
cd_operadora_origem_w		pls_protocolo_atendimento.cd_operadora_origem%type;
nr_seq_execucao_w		ptu_resp_solicitacao_pa.nr_seq_execucao%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_seq_requisicao_w		pls_requisicao.nr_sequencia%type;
nr_protocolo_w			pls_protocolo_atendimento.nr_protocolo%type;


BEGIN 
--Obter dados do protocolo 
select	nr_seq_segurado, 
	substr(pls_obter_dados_segurado(nr_seq_segurado, 'C'), 1, 255) cd_usuario_plano, 
	nr_seq_guia, 
	nr_seq_requisicao, 
	cd_operadora_destino, 
	cd_operadora_origem, 
	nr_protocolo, 
	nr_seq_execucao 
into STRICT	nr_seq_segurado_w, 
	cd_usuario_plano_w, 
	nr_seq_guia_w, 
	nr_seq_requisicao_w, 
	cd_operadora_destino_w, 
	cd_operadora_origem_w, 
	nr_protocolo_w, 
	nr_seq_execucao_w 
from 	pls_protocolo_atendimento 
where	nr_sequencia	= nr_seq_protocolo_p;
 
insert into ptu_resp_atendimento_pa( 
	nr_sequencia, 							cd_estabelecimento, 						dt_atualizacao, 
	nm_usuario, 							dt_atualizacao_nrec, 						nm_usuario_nrec, 
	cd_transacao, 							ie_tipo_cliente, 							cd_operadora_origem, 
	cd_operadora_destino, 						nr_registro_ans, 							nr_seq_execucao, 
	dt_geracao, 							cd_operadora, 							cd_usuario_plano, 
	nr_protocolo, 							ie_resposta, 							nr_seq_origem, 
	ds_mensagem_livre, 						nr_versao, 							nr_seq_protocolo, 
	nm_usuario_transacao 						 
	) 
values ( 
	nextval('ptu_resp_atendimento_pa_seq'),				cd_estabelecimento_p,					clock_timestamp(), 
	nm_usuario_p,						clock_timestamp(),							nm_usuario_p, 
	'005',							'U',							cd_operadora_origem_w, 
	cd_operadora_destino_w,					null,							nr_seq_execucao_w, 
	clock_timestamp(),							substr(cd_usuario_plano_w,1,4),				substr(cd_usuario_plano_w,5,13), 
	nr_protocolo_w,						ie_resposta_p,						null, 
	ds_mensagem_livre_p,					'001',							nr_seq_protocolo_p, 
	nm_usuario_p 
	) return;
 
-- Se o status de resposta for Finalizado, finaliza o protocolo de atendimento 
if (ie_resposta_p = 3) then 
	update	pls_protocolo_atendimento 
	set	ie_status	= 3 
	where 	nr_sequencia	= nr_seq_protocolo_p;
end if;	
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_resposta_pa ( nr_seq_protocolo_p pls_protocolo_atendimento.nr_sequencia%type, ie_resposta_p ptu_resp_atendimento_pa.ie_resposta%type, ds_mensagem_livre_p ptu_resp_atendimento_pa.ds_mensagem_livre%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, nr_seq_resp_atendimento_pa INOUT ptu_resp_atendimento_pa.nr_sequencia%type) FROM PUBLIC;
