-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_processa_aut_ordem_serv ( nr_seq_aut_ord_serv_p ptu_aut_ordem_serv_servico.nr_sequencia%type, nm_usuario_p ptu_confirmacao.nm_usuario%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type) AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Realizar a validação do arquivo de 00804 - Autorização Ordem de Serviço
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ x] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ x] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: Performace
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_solicitante_w		ptu_autorizacao_ordem_serv.nr_transacao_solicitante%type;
cd_unimed_solicitante_w		ptu_autorizacao_ordem_serv.cd_unimed_solicitante%type;
nr_seq_execucao_w		ptu_autorizacao_ordem_serv.nr_seq_execucao%type;
qt_registros_w			bigint;


BEGIN

select	nr_seq_execucao,
	cd_unimed_solicitante,
	nr_transacao_solicitante
into STRICT	nr_seq_execucao_w,
	cd_unimed_solicitante_w,
	nr_seq_solicitante_w
from	ptu_autorizacao_ordem_serv
where	nr_sequencia = nr_seq_aut_ord_serv_p;

CALL ptu_gestao_envio_confirmacao(nr_seq_execucao_w,null,'AO',nm_usuario_p);

select	count(1)
into STRICT	qt_registros_w
from	ptu_aut_ordem_serv_servico
where	nr_seq_aut_ord_serv	= nr_seq_aut_ord_serv_p
and	ie_autorizado		= 2;

if (qt_registros_w	= 0) then
	-- Se a autorização de ordem de serviço vier totalmente recusada, so estágio da ordem de serviço fica Recusada
	update	ptu_requisicao_ordem_serv
	set	ie_estagio			= 4
	where	nr_transacao_solicitante	= nr_seq_solicitante_w
	and	cd_unimed_solicitante		= cd_unimed_solicitante_w;
else
	-- Se a autorização de ordem de serviço não vier totalmente negada, a ordem de serviço fica Pendente geração guia (triangulação)
	update	ptu_requisicao_ordem_serv
	set	ie_estagio	= 6
	where	nr_transacao_solicitante	= nr_seq_solicitante_w
	and	cd_unimed_solicitante		= cd_unimed_solicitante_w;
end if;

begin

select	nr_sequencia
into STRICT	nr_seq_confirmacao_p
from	ptu_confirmacao
where	nr_seq_execucao = nr_seq_execucao_w;

exception
when others then
	nr_seq_confirmacao_p := 0;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_processa_aut_ordem_serv ( nr_seq_aut_ord_serv_p ptu_aut_ordem_serv_servico.nr_sequencia%type, nm_usuario_p ptu_confirmacao.nm_usuario%type, nr_seq_confirmacao_p INOUT ptu_confirmacao.nr_sequencia%type) FROM PUBLIC;

