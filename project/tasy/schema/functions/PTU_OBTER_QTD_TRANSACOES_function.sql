-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_qtd_transacoes ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_origem_p bigint, ie_tipo_transacao_p text ) RETURNS bigint AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter a quantidade de transações existentes para a guia/requisição/transação origem/transação execução informadas
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:Performance.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_transacao_w	varchar(10);
qt_registros_w		bigint;
vl_retorno_w		bigint;
ds_comando_w		varchar(4000);
nr_cur_w		integer;
nr_exec_w		integer;


/*	ie_tipo_transacao_p
	AUT 	- Pedido de autorização
	RAUT 	- Resposta de autorização
	COMPL 	- Pedido de complemento
	INS 	- Pedido de insistência
	CANC 	- Pedido de cancelamento
	AUD 	- Resposta de auditoria
	ERR	- Erro inesperado
	CONF	- Confirmação
	ORD	- Requisição de Ordem de serviço
	RORD	- Resposta de ordem de serviço
	AORD	- Autorização de ordem de serviço
	STAT	- Status da transação
	RSTAT	- Resposta do pedido de status
	DECP	- Decurso de prazo
	CONSP	- Consulta de dados do prestador
	CONSB	- Consulta de dados do beneficiário
*/
BEGIN
ds_comando_w	:= 'select count(1) ';

select	CASE WHEN ie_tipo_transacao_p=1 THEN 'AUT' WHEN ie_tipo_transacao_p=2 THEN 'RAUT' WHEN ie_tipo_transacao_p=3 THEN 'COMPL' WHEN ie_tipo_transacao_p=4 THEN 'INS' WHEN ie_tipo_transacao_p=5 THEN 'CANC' WHEN ie_tipo_transacao_p=6 THEN 'AUD' WHEN ie_tipo_transacao_p=7 THEN 'ERR' WHEN ie_tipo_transacao_p=8 THEN 'CONF' WHEN ie_tipo_transacao_p=9 THEN 'ORD' WHEN ie_tipo_transacao_p=10 THEN 'RORD' WHEN ie_tipo_transacao_p=11 THEN 'AORD' WHEN ie_tipo_transacao_p=12 THEN 'STAT' WHEN ie_tipo_transacao_p=13 THEN 'RSTAT' WHEN ie_tipo_transacao_p=14 THEN 'DECP' WHEN ie_tipo_transacao_p=15 THEN 'CONSP' WHEN ie_tipo_transacao_p=16 THEN 'CONSB' END
into STRICT	ie_tipo_transacao_w
;

if (ie_tipo_transacao_w	= 'AUT') then
	ds_comando_w	:= ds_comando_w || 'from ptu_pedido_autorizacao ';
elsif (ie_tipo_transacao_w	= 'RAUT') then
	ds_comando_w	:= ds_comando_w || 'from ptu_resposta_autorizacao ';
elsif (ie_tipo_transacao_w	= 'COMPL') then
	ds_comando_w	:= ds_comando_w || 'from ptu_pedido_compl_aut ';
elsif (ie_tipo_transacao_w	= 'INS') then
	ds_comando_w	:= ds_comando_w || 'from ptu_pedido_insistencia ';
elsif (ie_tipo_transacao_w	= 'CANC') then
	ds_comando_w	:= ds_comando_w || 'from ptu_cancelamento ';
elsif (ie_tipo_transacao_w	= 'AUD') then
	ds_comando_w	:= ds_comando_w || 'from ptu_resposta_auditoria ';
elsif (ie_tipo_transacao_w	= 'ERR') then
	ds_comando_w	:= ds_comando_w || 'from ptu_erro_inesperado ';
elsif (ie_tipo_transacao_w	= 'CONF') then
	ds_comando_w	:= ds_comando_w || 'from ptu_confirmacao ';
elsif (ie_tipo_transacao_w	= 'ORD') then
	ds_comando_w	:= ds_comando_w || 'from ptu_requisicao_ordem_serv ';
elsif (ie_tipo_transacao_w	= 'RORD') then
	ds_comando_w	:= ds_comando_w || 'from ptu_resposta_req_ord_serv ';
elsif (ie_tipo_transacao_w	= 'AORD') then
	ds_comando_w	:= ds_comando_w || 'from ptu_autorizacao_ordem_serv ';
elsif (ie_tipo_transacao_w	= 'STAT') then
	ds_comando_w	:= ds_comando_w || 'from ptu_pedido_status ';
elsif (ie_tipo_transacao_w	= 'RSTAT') then
	ds_comando_w	:= ds_comando_w || 'from ptu_resp_pedido_status ';
elsif (ie_tipo_transacao_w	= 'DECP') then
	ds_comando_w	:= ds_comando_w || 'from ptu_decurso_prazo ';
elsif (ie_tipo_transacao_w	= 'CONSP') then
	ds_comando_w	:= ds_comando_w || 'from ptu_consulta_prestador ';
elsif (ie_tipo_transacao_w	= 'CONSB') then
	ds_comando_w	:= ds_comando_w || 'from ptu_consulta_beneficiario ';
end if;

if (nr_seq_execucao_p IS NOT NULL AND nr_seq_execucao_p::text <> '') then
	if (ie_tipo_transacao_w	= 'STAT') then
		ds_comando_w	:= ds_comando_w || 'where nr_transacao_uni_exec	= :nr_seq_execucao ';
	elsif (ie_tipo_transacao_w	= 'ORD') then
		ds_comando_w	:= ds_comando_w || 'where nr_transacao_solicitante = :nr_seq_execucao ';
	else
		ds_comando_w	:= ds_comando_w || 'where nr_seq_execucao	= :nr_seq_execucao ';
	end if;

	EXECUTE ds_comando_w
	into STRICT 	qt_registros_w
	using 	nr_seq_execucao_p;

	vl_retorno_w	:= qt_registros_w;

elsif (nr_seq_origem_p IS NOT NULL AND nr_seq_origem_p::text <> '') then
	ds_comando_w	:= ds_comando_w || 'where nr_seq_origem	= :nr_seq_origem ';

	EXECUTE ds_comando_w
	into STRICT 	qt_registros_w
	using 	nr_seq_origem_p;

	vl_retorno_w	:= qt_registros_w;

elsif (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then
	ds_comando_w	:= ds_comando_w || 'where nr_seq_guia	= :nr_seq_guia ';

	EXECUTE ds_comando_w
	into STRICT 	qt_registros_w
	using 	nr_seq_guia_p;

	vl_retorno_w	:= qt_registros_w;

elsif (nr_seq_requisicao_p IS NOT NULL AND nr_seq_requisicao_p::text <> '') then
	ds_comando_w	:= ds_comando_w || 'where nr_seq_requisicao	= :nr_seq_requisicao ';

	EXECUTE ds_comando_w
	into STRICT 	qt_registros_w
	using 	nr_seq_requisicao_p;

	vl_retorno_w	:= qt_registros_w;
end if;



return	vl_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_qtd_transacoes ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_execucao_p bigint, nr_seq_origem_p bigint, ie_tipo_transacao_p text ) FROM PUBLIC;

