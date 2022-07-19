-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_processa_pedido_status ( nr_seq_pedido_status_p ptu_pedido_status.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_ped_status_p INOUT ptu_resp_pedido_status.nr_sequencia%type) AS $body$
DECLARE

 
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nr_seq_origem_w		ptu_controle_execucao.nr_sequencia%type;


BEGIN 
 
cd_estabelecimento_w := cd_estabelecimento_p;
 
--Quando as transações são geradas pelo WebService, não existe estabelecimento definido, então é verificado o estabeleicmento do parâmetro 
if ( coalesce(cd_estabelecimento_w::text, '') = ''	) then 
	cd_estabelecimento_w := ptu_obter_estab_padrao;
end if;
 
--Rotina utilizada para encontrar e atualizar a sequencia da Autorização e da Requisição no pedido de status 
CALL ptu_atualizar_pedido_status(nr_seq_pedido_status_p, nm_usuario_p);
 
--Rotina utilizada para gerar a resposta do pedido de status da transação 
nr_seq_origem_w := ptu_gerar_pedido_status(nr_seq_pedido_status_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_origem_w);
 
--Retorna a sequência da resposta de confirmação gerada para o 00311 - Pedido de cancelamento, esta sequência é utilizada pelo WebService para gerar o XML de resposta do pedido 
select	max(a.nr_sequencia) 
into STRICT	nr_seq_resp_ped_status_p 
from	ptu_resp_pedido_status a 
where	a.nr_seq_origem = nr_seq_origem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_processa_pedido_status ( nr_seq_pedido_status_p ptu_pedido_status.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_resp_ped_status_p INOUT ptu_resp_pedido_status.nr_sequencia%type) FROM PUBLIC;

