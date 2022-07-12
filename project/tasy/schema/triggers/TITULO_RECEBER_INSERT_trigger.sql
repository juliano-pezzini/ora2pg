-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS titulo_receber_insert ON titulo_receber CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_titulo_receber_insert() RETURNS trigger AS $BODY$
DECLARE

ie_titulo_prot_zerado_w		varchar(20);
ie_historico_w			varchar(2);
nr_sequencia_w			bigint;
cd_convenio_parametro_w		integer;
nr_nivel_anterior_w		integer;
ie_valor_tit_protocolo_w		varchar(2);
cd_convenio_w			integer;
tx_juros_w			double precision;
tx_multa_w			double precision;
ie_dt_contabil_ops_w	varchar(1);
dt_contabil_ops_w		timestamp;
qt_provisorio_w			bigint := 0;

ds_module_log_w conta_paciente_hist.ds_module%type;
ds_call_stack_w conta_paciente_hist.ds_call_stack%type;
BEGIN
  BEGIN

if (coalesce(wheb_usuario_pck.get_ie_executar_trigger,'S')	= 'S')  then

select	max(a.cd_convenio_parametro)
into STRICT	cd_convenio_w
from	conta_paciente a
where	a.nr_interno_conta	= NEW.nr_interno_conta;

if (NEW.vl_outras_despesas = 0) then

	NEW.vl_outras_despesas := OBTER_ACRESC_CR(NEW.cd_estabelecimento, NEW.cd_cgc, NEW.vl_outras_despesas);

end if;

if (cd_convenio_w	is null) then

	select	max(a.cd_convenio)
	into STRICT	cd_convenio_w
	from	protocolo_convenio a
	where	a.nr_seq_protocolo	= NEW.nr_seq_protocolo;

end if;

select	coalesce(max(ie_historico_conta),'N')
into STRICT	ie_historico_w
from	parametro_faturamento
where	cd_estabelecimento	= NEW.cd_estabelecimento;

if (fin_obter_se_mes_aberto(NEW.cd_estabelecimento, NEW.dt_emissao,'CR',null,cd_convenio_w,null,null) = 'N') then
	--O mes/dia financeiro de emissao do titulo ja esta fechado! Nao e possivel incluir novos titulos neste mes.

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222067);
end if;

if (fin_obter_se_mes_aberto(NEW.cd_estabelecimento, coalesce(NEW.dt_contabil,NEW.dt_emissao),'CR',null,cd_convenio_w,null,null) = 'N') then
	--O mes/dia financeiro da data contabil do titulo ja esta fechado! Nao e possivel incluir novos titulos neste mes. Data: #@DT_CONTABIL#@

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222068,'DT_CONTABIL='||coalesce(NEW.dt_contabil,NEW.dt_emissao));
end if;

if (NEW.vl_saldo_titulo < 0) or (NEW.vl_titulo < 0) then
	--O valor do titulo nao pode ser negativo!

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222069);
end if;

select	coalesce(max(ie_titulo_prot_zerado),'N'),
	coalesce(max(ie_valor_tit_protocolo),'S')	
into STRICT	ie_titulo_prot_zerado_w,
	ie_valor_tit_protocolo_w
from	parametro_contas_receber
where	cd_estabelecimento		= NEW.cd_estabelecimento;

-- Edgar 31/01/2008, OS 81434, coloquei consistencia abaixo ate achar o problema de geracao de titulos do protooclo com valor zerado

if (ie_titulo_prot_zerado_w = 'P') and (NEW.vl_titulo = 0)  and (NEW.nr_seq_protocolo is not null) then
	--O valor do titulo de protocolo nao pode ser zero!

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222070);
end if;

if (ie_titulo_prot_zerado_w = 'N') and (NEW.vl_titulo = 0) and (NEW.ie_origem_titulo <> '3')  then
	--O valor do titulo nao pode ser zero!

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222071);
end if;

--lhalves 19/10/2010, OS 259145.

if (ie_valor_tit_protocolo_w = 'N') and (NEW.nr_seq_protocolo is not null) and (NEW.nr_interno_conta is null) then
	if (NEW.vl_titulo <> obter_total_protocolo(NEW.nr_seq_protocolo)) then
		--O valor do titulo nao pode ser diferente do protocolo!

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(222072);
	end if;
end if;


if (NEW.dt_vencimento < to_date('01/01/1900', 'dd/mm/yyyy')) then
	--Nao e possivel incluir um titulo com vencimento inferior a 01/01/1900!

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222073);
end if;

if	(NEW.cd_cgc is null AND NEW.cd_pessoa_fisica is null)
	or
	(NEW.cd_cgc is not null AND NEW.cd_pessoa_fisica is not null) then
	--O titulo deve ser de uma pessoa fisica ou juridica!

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222074);
end if;

qt_provisorio_w := 0;

if (NEW.nr_seq_protocolo is not null) then
	
	select	count(*)
	into STRICT	qt_provisorio_w
	from	protocolo_convenio x
	where	x.nr_seq_protocolo = NEW.nr_seq_protocolo
	and	x.ie_status_protocolo = 1;

elsif (NEW.nr_seq_lote_prot is not null) then
	
	select	count(*)
	into STRICT	qt_provisorio_w
	from	protocolo_convenio w
	where	w.nr_seq_lote_protocolo = NEW.nr_seq_lote_prot
	and	w.ie_status_protocolo = 1;

end if;

if (qt_provisorio_w > 0) then

	--Nao e permitido gerar o titulo para um protocolo com status Provisorio.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(338789);
end if;

NEW.dt_contabil := coalesce(NEW.dt_contabil, NEW.dt_emissao);

/* Projeto Davita  - Nao deixa gerar movimento contabil apos fechamento  da data */


CALL philips_contabil_pck.valida_se_dia_fechado(OBTER_EMPRESA_ESTAB(NEW.cd_estabelecimento),NEW.dt_contabil);


if (ie_historico_w		= 'S') and ( NEW.NR_INTERNO_CONTA  is not null) then
	BEGIN
	select	nextval('conta_paciente_hist_seq')
	into STRICT	nr_sequencia_w
	;
	
	select	cd_convenio_parametro,
		CASE WHEN nr_seq_protocolo IS NULL THEN 6  ELSE 8 END
	into STRICT	cd_convenio_parametro_w,
		nr_nivel_anterior_w
	from	conta_paciente
	where 	nr_interno_conta	= NEW.NR_INTERNO_CONTA;
	
	select	substr(max(module||' - ' || machine||' - ' || program|| ' - ' || osuser|| ' - ' || terminal),1,255)
	into STRICT	ds_module_log_w
	from	v$session
	where	audsid = (SELECT userenv('sessionid') );
	
	ds_call_stack_w	:= substr(dbms_utility.format_call_stack,1,1800);
	
	insert into conta_paciente_hist(
		nr_sequencia, dt_atualizacao, nm_usuario,
		vl_conta, nr_seq_protocolo, nr_interno_conta,
		nr_nivel_anterior, nr_nivel_atual, dt_referencia,
		nr_atendimento, cd_convenio, dt_conta_protocolo,
		cd_funcao, ds_module, ds_call_stack)
	values (
		nr_sequencia_w, LOCALTIMESTAMP, NEW.nm_usuario,
		obter_valor_conta(NEW.nr_interno_conta,0), null, NEW.nr_interno_conta,
		nr_nivel_anterior_w,
		nr_nivel_anterior_w , LOCALTIMESTAMP,
		obter_atendimento_conta(NEW.nr_interno_conta), 
		cd_convenio_parametro_w, 
		null,
		obter_funcao_Ativa, ds_module_log_w, ds_call_stack_w);
	exception
		when others then
		nr_nivel_anterior_w	:=nr_nivel_anterior_w;
	end;
	
end if;

if (Obter_Valor_Param_Usuario(85,89,obter_Perfil_Ativo,NEW.nm_usuario,0)	='S') and (NEW.nr_seq_protocolo is not null) then
	update	protocolo_convenio a
	set	a.dt_vencimento		= NEW.dt_vencimento
	where	nr_seq_protocolo	= NEW.nr_seq_protocolo;
end if;

if (trunc(NEW.dt_pagamento_previsto, 'dd') < trunc(NEW.dt_emissao, 'dd')) then
	--A data de vencimento nao pode ser menor que a data de emissao do titulo!

	--Dt emissao: #@DT_EMISSAO#@

	--Dt vencimento: #@DT_VENCIMENTO#@

	--Seq protocolo: #@NR_SEQ_PROTOCOLO#@

	--Pessoa: #@DS_PESSOA#@

	CALL Wheb_mensagem_pck.exibir_mensagem_abort(222075,	'DT_EMISSAO='||NEW.dt_emissao||
							';DT_VENCIMENTO='||trunc(NEW.dt_pagamento_previsto, 'dd')||
							';NR_SEQ_PROTOCOLO='||NEW.nr_seq_protocolo||
							';DS_PESSOA='||obter_nome_pf_pj(NEW.cd_pessoa_fisica, NEW.cd_cgc));
end if;

SELECT * FROM obter_tx_juros_multa_cre(NEW.cd_estabelecimento, NEW.ie_origem_titulo, NEW.ie_tipo_titulo, tx_juros_w, tx_multa_w) INTO STRICT tx_juros_w, tx_multa_w;

if (tx_juros_w is not null) then
	NEW.tx_juros	:= tx_juros_w;
end if;

if (tx_multa_w is not null) then
	NEW.tx_multa	:= tx_multa_w;
end if;

/*AAMFIRMO OS 925991 - Para titulos originados de OPS Mensalidade(3)  e OPS Faturamento(13), a data contabil do titulo deve ser a data contabil no OPS*/


ie_dt_contabil_ops_w := Obter_Param_Usuario(801, 204, obter_perfil_ativo, NEW.nm_usuario, NEW.cd_estabelecimento, ie_dt_contabil_ops_w);

if ( coalesce(ie_dt_contabil_ops_w,'N') = 'S' ) and ( NEW.ie_origem_titulo = '3' ) then /*Aqui somente titulo com origem OPS - Mensalidade. Para origem OPS Faturamento foi tratado na proc pls_gerar_titulos_fatura*/

	
	/*Esse select para buscar a data e o mesmo utilizado na funcao Titulo_receber, na function que busca o valor para o campo  DT_MENSALIDADE no titulo*/


	BEGIN

	select 	substr(pls_obter_dados_mensalidade(NEW.nr_seq_mensalidade,'D'),1,10)
	into STRICT	dt_contabil_ops_w
	;
	if (dt_contabil_ops_w is null) then
	
		select 	max(x.dt_mes_competencia)
		into STRICT	dt_contabil_ops_w
		from 	pls_fatura  x
		where 	x.nr_titulo = NEW.nr_titulo;

		if (dt_contabil_ops_w is null) then
		
			select 	max(x.dt_mes_competencia)
			into STRICT	dt_contabil_ops_w
			from 	pls_fatura  x
			where  	x.nr_titulo_ndc = NEW.nr_titulo;

		end if;
	
	end if;	

	if (dt_contabil_ops_w is not null) then
		NEW.dt_contabil := coalesce(dt_contabil_ops_w,coalesce(NEW.dt_contabil, NEW.dt_emissao));
	end if;
	exception when others then
		NEW.dt_contabil := coalesce(NEW.dt_contabil, NEW.dt_emissao);
	end;

end if;
/*AAMFIRMO Fim tratativa OS 925991*/


NEW.DS_STACK := substr('CallStack Insert: ' || substr(dbms_utility.format_call_stack,1,3980),1,4000);
end if;

  END;
RETURN NEW;
END;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_titulo_receber_insert() FROM PUBLIC;

CREATE TRIGGER titulo_receber_insert
	BEFORE INSERT ON titulo_receber FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_titulo_receber_insert();
