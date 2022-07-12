-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_cabecalho_gpi_v001 ( nr_seq_transacao_p bigint, ie_tipo_transacao_p bigint, ie_campo_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  x ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
Código dos pedidos para saber como montar o cabeçalho

1 - Solicitar Protocolo
2 - Resposta Solicitar Protocolo
3 - Complementar Protocolo
4 - Confirmação
5 - Responder Atendimento
6 - Consulta Status Protocolo
7 - Resposta Consulta Status Protocolo
8 - Consulta Historico
9 - Resposta Consulta Historico
10 - Cancelamento
11 - Erro Inesperado
12 - Encaminhar Execucação

Transações
001 - Solicitar Protocolo
002 - Resposta Solicitar Protocolo
003 - Complementar Protocolo
004 - Confirmação
005 - Responder Atendimento
006 - Consulta Status Protocolo
007 - Resposta Consulta Status Protocolo
008 - Consulta Historico
009 - Resposta Consulta Historico
010 - Cancelamento
011 - Erro Inesperado
012 - Encaminhar Execucação

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w			varchar(255);
cd_transacao_w			varchar(3);
cd_operadora_origem_w		ptu_solicitacao_pa.cd_operadora_origem%type;
cd_operadora_destino_w		ptu_solicitacao_pa.cd_operadora_destino%type;
ie_tipo_cliente_w		varchar(10);
nr_registro_ans_w		ptu_solicitacao_pa.nr_registro_ans%type;


BEGIN

-- 1 - Solicitar Protocolo
if ( ie_tipo_transacao_p = 1  ) then
	select	'001',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_solicitacao_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 2 - Resposta Solicitar Protocolo
elsif ( ie_tipo_transacao_p = 2 ) then
	select	'002',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_resp_solicitacao_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 3 - Complementar Protocolo
elsif ( ie_tipo_transacao_p = 3 ) then
	select	'003',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_complemento_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 4 - Confirmação
elsif ( ie_tipo_transacao_p = 4 ) then
	select	'004',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_confirmacao_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 5 - Responder Atendimento
elsif ( ie_tipo_transacao_p = 5 ) then
	select	'005',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_resp_atendimento_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 6 - Consulta Status Protocolo
elsif ( ie_tipo_transacao_p = 6 ) then
	select	'006',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_consulta_status_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 7 - Resposta Consulta Status Protocolo
elsif ( ie_tipo_transacao_p = 7 ) then
	select	'007',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_resp_cons_status_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 8 - Consulta Histórico
elsif ( ie_tipo_transacao_p = 8 ) then
	select	'008',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_consulta_historico_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 9 - Resposta Consulta Histórico
elsif ( ie_tipo_transacao_p = 9 ) then
	select	'009',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_resp_cons_historico_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 10 - Cancelamento
elsif ( ie_tipo_transacao_p = 10 ) then
	select	'010',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_cancelamento_pa
	where	nr_sequencia = nr_seq_transacao_p;
-- 12 - Encaminhar Execução
elsif ( ie_tipo_transacao_p = 12 ) then
	select	'012',
		cd_operadora_origem,
		cd_operadora_destino,
		CASE WHEN ie_tipo_cliente='P' THEN 'PORTAL' WHEN ie_tipo_cliente='R' THEN 'PRESTADOR'  ELSE 'UNIMED' END  ie_tipo_cliente,
		nr_registro_ans
	into STRICT	cd_transacao_w,
		cd_operadora_origem_w,
		cd_operadora_destino_w,
		ie_tipo_cliente_w,
		nr_registro_ans_w
	from	ptu_encaminhar_execucao_pa
	where	nr_sequencia = nr_seq_transacao_p;
end if;

--Tipo de transação que será gerada no XML
if ( ie_campo_p = 'TT' ) then
	ds_retorno_w := cd_transacao_w;
--Código unimed destino
elsif ( ie_campo_p = 'CD' 	 ) then
	ds_retorno_w := cd_operadora_destino_w;
--Código unimed origem
elsif ( ie_campo_p = 'CO' 	 ) then
	ds_retorno_w := cd_operadora_origem_w;
--Código tipo cliente
elsif ( ie_campo_p = 'TC' 	 ) then
	ds_retorno_w := ie_tipo_cliente_w;
--Número registro ANS
elsif ( ie_campo_p = 'AN' 	 ) then
	ds_retorno_w := nr_registro_ans_w;

end if;


return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_cabecalho_gpi_v001 ( nr_seq_transacao_p bigint, ie_tipo_transacao_p bigint, ie_campo_p text) FROM PUBLIC;

