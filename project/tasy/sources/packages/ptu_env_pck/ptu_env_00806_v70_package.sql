-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--------------------------------------------------------------------------------00806 Ordem de Servico------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



CREATE OR REPLACE PROCEDURE ptu_env_pck.ptu_env_00806_v70 ( nr_seq_ordem_p ptu_requisicao_ordem_serv.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar a transacao de Ordem de Servico do PTU, via SCS.
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta:
[ X ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atencao:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

C01 CURSOR(	nr_seq_req_ord_pc	ptu_req_ord_serv_servico.nr_seq_req_ord%type) FOR
	SELECT	nr_sequencia
	from	ptu_req_ord_serv_servico
	where	nr_seq_req_ord = nr_seq_req_ord_pc
	order by nr_seq_item;


cd_unimed_beneficiario_w	ptu_requisicao_ordem_serv.cd_unimed_beneficiario%type;
cd_unimed_solicitante_w		ptu_requisicao_ordem_serv.cd_unimed_solicitante%type;
cd_carteirinha_w		pls_segurado_carteira.cd_usuario_plano%type;
nr_seq_controle_exec_w		ptu_controle_execucao.nr_sequencia%type;
qt_ordem_w                	integer;
qt_registro_w			integer := 0;
BEGIN

begin
	select	cd_unimed_beneficiario,
		cd_unimed_solicitante,
		pls_obter_dados_segurado(nr_seq_segurado, 'C')
	into STRICT	cd_unimed_beneficiario_w,
		cd_unimed_solicitante_w,
		cd_carteirinha_w
	from	ptu_requisicao_ordem_serv
	where	nr_sequencia	= nr_seq_ordem_p;
exception
when others then
	cd_unimed_beneficiario_w	:= null;
	cd_unimed_solicitante_w		:= null;
end;

cd_carteirinha_w := Elimina_Caracteres_Especiais(cd_carteirinha_w);

select	count(1)
into STRICT   	qt_ordem_w
from   	ptu_requisicao_ordem_serv
where  	nr_sequencia = nr_seq_ordem_p
and    	(nr_transacao_solicitante IS NOT NULL AND nr_transacao_solicitante::text <> '');

if (qt_ordem_w	= 0) then
	insert	into ptu_controle_execucao(nr_sequencia, dt_atualizacao, nm_usuario,
		 nr_seq_pedido_compl, nr_seq_pedido_aut, nm_usuario_nrec,
		 dt_atualizacao_nrec, nr_seq_ordem_serv)
	values (nextval('ptu_controle_execucao_seq'), clock_timestamp(), nm_usuario_p,
		 null, null, nm_usuario_p,
		 clock_timestamp(), nr_seq_ordem_p) returning nr_sequencia into nr_seq_controle_exec_w;

	-- Se a operadora de origem do beneficiario for igual a operadora solicitante da ordem de servico, e caracterizada uma transacao ponto-a-ponto

	if (cd_unimed_beneficiario_w	= cd_unimed_solicitante_w) then
		update	ptu_requisicao_ordem_serv
		set	nr_transacao_solicitante	= nr_seq_controle_exec_w,
			nr_seq_origem			= nr_seq_controle_exec_w,
			cd_unimed			= substr(cd_carteirinha_w,1,4),
			cd_usuario_plano		= Elimina_Caracteres_Especiais(substr(cd_carteirinha_w,5,17))
		where	nr_sequencia			= nr_seq_ordem_p;
	-- Se a operadora de origem do beneficiario for diferente da operadora solicitante da ordem de servico, e caracterizada uma Triangulacao

	elsif (cd_unimed_beneficiario_w	<> cd_unimed_solicitante_w) then
		update	ptu_requisicao_ordem_serv
		set	nr_transacao_solicitante	= nr_seq_controle_exec_w,
			nr_seq_origem			 = NULL,
			cd_unimed			= substr(cd_carteirinha_w,1,4),
			cd_usuario_plano		= Elimina_Caracteres_Especiais(substr(cd_carteirinha_w,5,17))
		where	nr_sequencia			= nr_seq_ordem_p;
	end if;

	for c01_w in C01(nr_seq_ordem_p) loop
		qt_registro_w := qt_registro_w + 1;
		update	ptu_req_ord_serv_servico
		set	nr_seq_item = qt_registro_w
		where	nr_sequencia = c01_w.nr_sequencia;
	end loop;

end if;

commit;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_env_pck.ptu_env_00806_v70 ( nr_seq_ordem_p ptu_requisicao_ordem_serv.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
