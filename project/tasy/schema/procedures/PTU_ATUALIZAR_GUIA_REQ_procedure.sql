-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_atualizar_guia_req ( nr_seq_pedido_aut_p ptu_pedido_autorizacao.nr_sequencia%type, ie_possui_pedido_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE

 
C01 CURSOR(nr_seq_pedido_aut_pc ptu_pedido_autorizacao.nr_sequencia%type) FOR 
	SELECT	a.ds_observacao, 
		a.nr_seq_guia, 
		a.nr_seq_requisicao, 
		a.dt_atendimento, 
		a.cd_unimed_executora, 
		a.ie_alto_custo, 
		(SELECT	b.nr_sequencia 
		from  pls_segurado_carteira c, 
			pls_segurado b 
		where  c.nr_seq_segurado	= b.nr_sequencia 
		and	c.cd_usuario_plano	= lpad(a.cd_unimed,4,0)||a.cd_usuario_plano) nr_seq_segurado, 
		(select	c.nr_sequencia 
		from	ptu_controle_execucao c 
		where	c.nr_seq_pedido_aut = a.nr_sequencia) nr_seq_exec_control, 
		(select	max(nr_sequencia) 
		from	ptu_resposta_autorizacao c 
		where	c.nr_seq_execucao	= a.nr_seq_execucao 
		and	c.cd_unimed_executora	= a.cd_unimed_executora) nr_seq_resp_ped_aut 
	from	ptu_pedido_autorizacao a 
	where	a.nr_sequencia = nr_seq_pedido_aut_pc;

BEGIN 
 
--Carrega os anexos importados no pedido de autorização 
for c01_w in C01( nr_seq_pedido_aut_p ) loop 
 
	-- Se já existia um pedido de autorização na base, o sistema não pode gerar outro 
	if ( ie_possui_pedido_p = 'N' ) then 
		--Realiza a consistência do pedido 
		CALL ptu_atualiza_imp_ped_autor_scs(	c01_w.nr_seq_guia, c01_w.nr_seq_requisicao, c01_w.nr_seq_segurado, 
						null, c01_w.ds_observacao, null, 
						c01_w.ie_alto_custo, c01_w.dt_atendimento, cd_estabelecimento_p, 
						nm_usuario_p, c01_w.cd_unimed_executora, 'A');
	end if;
 
	--Se já existir uma resposta para o pedido de autorização, não é necessário gerar novamente 
	if ( coalesce(c01_w.nr_seq_resp_ped_aut::text, '') = '' ) then 
		--Gera a resposta do pedido de autorização 
		CALL ptu_gestao_env_resp_pedido_aut( c01_w.nr_seq_exec_control, cd_estabelecimento_p, nm_usuario_p);
	end if;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_atualizar_guia_req ( nr_seq_pedido_aut_p ptu_pedido_autorizacao.nr_sequencia%type, ie_possui_pedido_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
