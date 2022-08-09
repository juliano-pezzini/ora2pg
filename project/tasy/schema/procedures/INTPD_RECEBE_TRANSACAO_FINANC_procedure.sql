-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_transacao_financ ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w				conversao_meio_externo.nr_seq_regra%type;
ie_sistema_externo_w		varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
transacao_financeira_w		transacao_financeira%rowtype;
ds_erro_w					varchar(4000);
qt_reg_w					bigint;

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/FINANCIAL_TRANSACTION' passing xml_p columns
		cd_empresa						smallint		path	'CD_COMPANY',
		cd_transacao					varchar(10)	path	'CD_TRANSACTION',
		ds_transacao					varchar(250)	path	'DS_TRANSACTION',
		nm_usuario						varchar(15)	path	'NM_USER',
		ie_acao							smallint		path	'IE_ACTION',
		ie_autenticar					varchar(1)		path	'IE_AUTHENTICATION',
		ie_banco						varchar(1)		path	'IE_BANK',
		ie_caixa						varchar(1)		path	'IE_CHECKOUT',
		ie_cartao_debito				varchar(1)		path	'IE_DEBIT_CARD',
		ie_cartao_cr					varchar(1)		path	'IE_CREDIT_CARD',
		ie_centro_custo					varchar(1)		path	'IE_COST_CENTER',
		ie_cheque_cr					varchar(1)		path	'IE_RECEIVABLE_CHECK',
		ie_contab_banco					varchar(1)		path	'IE_BANK_ACCOUNT',
		ie_dev_cheque					varchar(1)		path	'IE_CHECK_RETURN',
		ie_especie						varchar(3)		path	'IE_CASH',
		ie_negociacao_cheque_cr			varchar(1)		path	'IE_CHECK_NEGOTIATION',
		ie_saldo_caixa					varchar(1)		path	'IE_CHECKOUT_BALANCE',
		ie_situacao						varchar(1)		path	'IE_STATUS',
		ie_titulo_pagar					varchar(1)		path	'IE_PAYABLE_DOCUMENT',
		ie_variacao_cambial				varchar(3)		path	'IE_EXCHANGE_VARIANCE');

c01_w	c01%rowtype;

BEGIN

/*'Atualiza o status da fila para Em processamento'*/

update	intpd_fila_transmissao
set		ie_status 		= 'R'
where	nr_sequencia 	= nr_sequencia_p;

/*'Realiza o commit para não permite o status de processamento em casa de rollback por existir consistência. Existe tratamento de exceção abaixo para colocar o status de erro em caso de falha'*/

commit;

begin

select	coalesce(max(b.ie_conversao),'I'),
		max(nr_seq_sistema),
		max(nr_seq_projeto_xml),
		max(nr_seq_regra_conv)
into STRICT	ie_conversao_w,
		nr_seq_sistema_w,
		nr_seq_projeto_xml_w,
		nr_seq_regra_w
from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and		a.nr_sequencia 			= nr_sequencia_p;

ie_sistema_externo_w	:=	nr_seq_sistema_w;

/*'Alimenta as informações iniciais de controle e consistência de cada atributo do XML'*/

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe			:=	'R';
reg_integracao_w.ie_sistema_externo			:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao				:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml			:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao		:=	nr_seq_regra_w;
reg_integracao_w.intpd_log_receb.delete;
reg_integracao_w.qt_reg_log					:=	0;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	reg_integracao_w.nm_tabela			:=	'TRANSACAO_FINANCEIRA';
	reg_integracao_w.nm_elemento		:=	'FINANCIAL_TRANSACTION';
	reg_integracao_w.nr_seq_visao		:=	'';

	select	count(*)
	into STRICT	qt_reg_w
	from	transacao_financeira
	where	upper(ds_transacao) = upper(c01_w.ds_transacao);

	if (qt_reg_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(767146,'ds_transacao='||c01_w.ds_transacao);
	end if;

	if ( upper(c01_w.ie_situacao) not in ('I','A')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(767003,'ie_situacao='||c01_w.ie_situacao);
	else
		c01_w.ie_situacao := upper(c01_w.ie_situacao);
	end if;

	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_EMPRESA', c01_w.cd_empresa, 'S', transacao_financeira_w.cd_empresa) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.cd_empresa := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_TRANSACAO', c01_w.cd_transacao, 'N', transacao_financeira_w.cd_transacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.cd_transacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_TRANSACAO', c01_w.ds_transacao, 'N', transacao_financeira_w.ds_transacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ds_transacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c01_w.nm_usuario, 'N', transacao_financeira_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_ACAO', c01_w.ie_acao, 'S', transacao_financeira_w.ie_acao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_acao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_AUTENTICAR', c01_w.ie_autenticar, 'S', transacao_financeira_w.ie_autenticar) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_autenticar := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_BANCO', c01_w.ie_banco, 'S', transacao_financeira_w.ie_banco) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_banco := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CAIXA', c01_w.ie_caixa, 'S', transacao_financeira_w.ie_caixa) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_caixa := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CARTAO_DEBITO', c01_w.ie_cartao_debito, 'S', transacao_financeira_w.ie_cartao_debito) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_cartao_debito := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CARTAO_CR', c01_w.ie_cartao_cr, 'S', transacao_financeira_w.ie_cartao_cr) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_cartao_cr := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CENTRO_CUSTO', c01_w.ie_centro_custo, 'S', transacao_financeira_w.ie_centro_custo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_centro_custo := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CHEQUE_CR', c01_w.ie_cheque_cr, 'S', transacao_financeira_w.ie_cheque_cr) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_cheque_cr := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CONTAB_BANCO', c01_w.ie_contab_banco, 'S', transacao_financeira_w.ie_contab_banco) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_contab_banco := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_DEV_CHEQUE', c01_w.ie_dev_cheque, 'S', transacao_financeira_w.ie_dev_cheque) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_dev_cheque := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_ESPECIE', c01_w.ie_especie, 'S', transacao_financeira_w.ie_especie) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_especie := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_NEGOCIACAO_CHEQUE_CR', c01_w.ie_negociacao_cheque_cr, 'S', transacao_financeira_w.ie_negociacao_cheque_cr) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_negociacao_cheque_cr := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SALDO_CAIXA', c01_w.ie_saldo_caixa, 'S', transacao_financeira_w.ie_saldo_caixa) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_saldo_caixa := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SITUACAO', c01_w.ie_situacao, 'N', transacao_financeira_w.ie_situacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_situacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_TITULO_PAGAR', c01_w.ie_titulo_pagar, 'S', transacao_financeira_w.ie_titulo_pagar) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_titulo_pagar := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_VARIACAO_CAMBIAL', c01_w.ie_variacao_cambial, 'S', transacao_financeira_w.ie_variacao_cambial) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; transacao_financeira_w.ie_variacao_cambial := _ora2pg_r.ds_valor_retorno_p;

	if (reg_integracao_w.qt_reg_log = 0) then
		begin
		select	nextval('transacao_financeira_seq')
		into STRICT	transacao_financeira_w.nr_sequencia
		;

		transacao_financeira_w.dt_atualizacao := clock_timestamp();
		transacao_financeira_w.ie_extra_caixa := 'N'; --Esse campo não é mais utilizado no Tasy, mas está como obrigatório na tabela.
		insert into transacao_financeira values (transacao_financeira_w.*);
		end;
	end if;

	end;
end loop;
close C01;
exception
when others then
	begin
	/*'Em caso de qualquer falha o sistema captura a mensagem de erro, efetua o rollback, atualiza o status para Erro e registra a falha ocorrida'*/

	ds_erro_w	:=	substr(sqlerrm,1,4000);
	rollback;
	update	intpd_fila_transmissao
	set		ie_status 		= 'E',
			ds_log 			= ds_erro_w
	where	nr_sequencia 	= nr_sequencia_p;
	end;
end;

if (reg_integracao_w.qt_reg_log > 0) then
	begin
	/*'Em caso de qualquer consistência o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistência'*/

	rollback;

	update	intpd_fila_transmissao
	set		ie_status 		= 'E',
			ds_log 			= ds_erro_w
	where	nr_sequencia 	= nr_sequencia_p;

	for i in 0..reg_integracao_w.qt_reg_log-1 loop
		intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_transacao_financ ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;
