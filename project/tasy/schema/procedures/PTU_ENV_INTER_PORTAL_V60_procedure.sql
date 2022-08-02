-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_env_inter_portal_v60 ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_req_p pls_requisicao.nr_sequencia%type, ds_transacao_p text, ds_observacao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_execucao_p INOUT ptu_cancelamento.nr_seq_execucao%type) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Gerar guia de intercambio no portal web
----------------------------------------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[  ]  Objetos do dicionario [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatorios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
*/cd_usuario_plano_w		varchar(255);
cd_cooperativa_w		varchar(255) := '';
cd_operadora_usuario_w		varchar(10);
nr_seq_emissor_w		pls_parametros.nr_seq_emissor%type;
nr_seq_origem_w			ptu_resposta_auditoria.nr_seq_origem%type;
nr_seq_segurado_w		pls_requisicao.nr_seq_segurado%type;
nr_seq_intercambio_w		pls_segurado.nr_seq_intercambio%type;
ie_tipo_segurado_w		pls_segurado.ie_tipo_segurado%type;
ie_tipo_contrato_w		pls_intercambio.ie_tipo_contrato%type;
nr_seq_guia_w			pls_guia_plano.nr_sequencia%type;
nr_versao_w			varchar(20);


BEGIN

nr_versao_w := pls_obter_versao_scs;

if (nr_seq_req_p IS NOT NULL AND nr_seq_req_p::text <> '') then
	
	nr_seq_guia_w := null;
	
	CALL pls_finalizar_requisicao_web(nr_seq_req_p, nm_usuario_p);
	
	select	substr(pls_obter_dados_segurado(nr_seq_segurado,'CR'),1,255),
		nr_seq_segurado		
	into STRICT	cd_usuario_plano_w,
		nr_seq_segurado_w		
	from	pls_requisicao
	where	nr_sequencia = nr_seq_req_p;
	
	select	nr_seq_intercambio,
		ie_tipo_segurado
	into STRICT	nr_seq_intercambio_w,
		ie_tipo_segurado_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
	
elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then

	nr_seq_guia_w := nr_seq_guia_p;
	
	select	substr(pls_obter_dados_segurado(nr_seq_segurado,'CR'),1,255),
		nr_seq_segurado
	into STRICT	cd_usuario_plano_w,
		nr_seq_segurado_w
	from	pls_guia_plano
	where	nr_sequencia = nr_seq_guia_w;

	select	nr_seq_intercambio,
		ie_tipo_segurado
	into STRICT	nr_seq_intercambio_w,
		ie_tipo_segurado_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
end if;

if (cd_usuario_plano_w IS NOT NULL AND cd_usuario_plano_w::text <> '') then	
	select	max(nr_seq_emissor)
	into STRICT	nr_seq_emissor_w
	from	pls_parametros
	where	cd_estabelecimento	= cd_estabelecimento_p;
	
	select	pls_obter_campos_carteira(cd_usuario_plano_w,nr_seq_emissor_w,'CM')
	into STRICT	cd_cooperativa_w
	;

	cd_operadora_usuario_w := coalesce(pls_obter_unimed_estab(cd_estabelecimento_p), '0');	
	
	-- tratar para quando for Fundacao
	if (ie_tipo_segurado_w = 'T') then
		begin
			select  ie_tipo_contrato
			into STRICT    ie_tipo_contrato_w
			from    pls_intercambio
			where   nr_sequencia    = nr_seq_intercambio_w;
			exception
		when others then
			ie_tipo_contrato_w  := null;
		end;
	end if;	
	
	if ((cd_operadora_usuario_w)::numeric  <> (cd_cooperativa_w)::numeric
		or (ie_tipo_contrato_w = 'F')) then
		/*  Pedido audotiracao 00600
		     Cancelamento 00311
		      Pedido de Complemento de Autorizacao  00605
		      Pedido de insistencia 00302
		*/
	
		if (ds_transacao_p = '00600' ) then
			if (nr_versao_w = '060') then
				nr_seq_execucao_p := ptu_envio_ped_autorizacao_v60(nr_seq_guia_w, nr_seq_req_p, nr_versao_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			elsif (nr_versao_w in ('070','080','090')) then
				nr_seq_execucao_p := ptu_env_pck.ptu_env_00600_v70(nr_seq_guia_w, nr_seq_req_p, nr_versao_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			end if;
		elsif (ds_transacao_p = '00311' ) then
			if (nr_versao_w = '060') then
				nr_seq_execucao_p := ptu_env_cancelamento_v60(nr_seq_guia_w, nr_seq_req_p, ds_observacao_p, nr_versao_w, nm_usuario_p, nr_seq_execucao_p);
			elsif (nr_versao_w in ('070','080','090')) then
				nr_seq_execucao_p := ptu_env_pck.ptu_env_00311_v70(nr_seq_guia_w, nr_seq_req_p, ds_observacao_p, nr_versao_w, nm_usuario_p, nr_seq_execucao_p);
			end if;			
		elsif (ds_transacao_p = '00605' ) then
			if (nr_versao_w = '060') then
				nr_seq_execucao_p := ptu_envio_ped_compl_aut_v60(nr_seq_guia_w, nr_seq_req_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			elsif (nr_versao_w in ('070','080','090')) then
				nr_seq_execucao_p := ptu_env_pck.ptu_env_00605_v70(nr_seq_guia_w, nr_seq_req_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			end if;
		elsif (ds_transacao_p = '00302' ) then
			if (nr_versao_w = '060') then
				nr_seq_execucao_p := ptu_env_ped_insistencia_v60(nr_seq_req_p, nr_seq_guia_w, ds_observacao_p, nr_versao_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			elsif (nr_versao_w in ('070','080','090')) then
				nr_seq_execucao_p := ptu_env_pck.ptu_env_00302_v70(nr_seq_req_p, nr_seq_guia_w, ds_observacao_p, nr_versao_w, cd_estabelecimento_p, nm_usuario_p, nr_seq_execucao_p);
			end if;
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_inter_portal_v60 ( nr_seq_guia_p pls_guia_plano.nr_sequencia%type, nr_seq_req_p pls_requisicao.nr_sequencia%type, ds_transacao_p text, ds_observacao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_execucao_p INOUT ptu_cancelamento.nr_seq_execucao%type) FROM PUBLIC;

