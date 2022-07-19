-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_gerar_resp_auditoria_v60 ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


nr_seq_guia_w		pls_guia_plano.nr_sequencia%type;
nr_seq_requisicao_w	pls_requisicao.nr_sequencia%type;
nr_seq_execucao_w	ptu_resposta_auditoria.nr_seq_execucao%type;

C01 CURSOR(nr_seq_resp_aud_pc  	ptu_resposta_auditoria.nr_sequencia%type) FOR
	SELECT	nr_seq_execucao,
		(SELECT	b.nr_seq_pedido_compl
		from	ptu_controle_execucao b
		where	b.nr_sequencia = a.nr_seq_execucao) nr_seq_pedido_compl,
		(select	b.nr_seq_pedido_aut
		from	ptu_controle_execucao b
		where	b.nr_sequencia = a.nr_seq_execucao) nr_seq_pedido_aut
	from	ptu_resposta_auditoria a
	where	a.nr_sequencia =  nr_seq_resp_aud_pc;

BEGIN

--Carrega os dados importados no XML para as tabelas quentes
for c01_w in C01( nr_seq_resp_aud_p ) loop
	--Verificar a origem da resposta de auditoria, se a mesma for gerada para um Pedido de Autorização ou Pedido de Complemento
	if (c01_w.nr_seq_pedido_compl IS NOT NULL AND c01_w.nr_seq_pedido_compl::text <> '') then
		select	nr_seq_guia,
			nr_seq_requisicao
		into STRICT	nr_seq_guia_w,
			nr_seq_requisicao_w
		from	ptu_pedido_compl_aut
		where	nr_sequencia	= c01_w.nr_seq_pedido_compl;
	elsif (c01_w.nr_seq_pedido_aut IS NOT NULL AND c01_w.nr_seq_pedido_aut::text <> '') then
		select	nr_seq_guia,
			nr_seq_requisicao
		into STRICT	nr_seq_guia_w,
			nr_seq_requisicao_w
		from	ptu_pedido_autorizacao
		where	nr_sequencia	= c01_w.nr_seq_pedido_aut;
	elsif ( coalesce(c01_w.nr_seq_execucao::text, '') = '' ) then
		select	nextval('ptu_controle_execucao_seq')
		into STRICT	nr_seq_execucao_w
		;
	end if;

	update	ptu_resposta_auditoria
	set	nr_seq_guia		= nr_seq_guia_w,
		nr_seq_requisicao	= nr_seq_requisicao_w,
		nr_seq_execucao		= coalesce(nr_seq_execucao_w, c01_w.nr_seq_execucao),
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia 		= nr_seq_resp_aud_p;

	commit;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_gerar_resp_auditoria_v60 ( nr_seq_resp_aud_p ptu_resposta_auditoria.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

