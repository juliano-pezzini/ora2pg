-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS alteracao_vencimento_insert ON alteracao_vencimento CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_alteracao_vencimento_insert() RETURNS trigger AS $BODY$
declare

ie_juros_multa_barras_bloq_w	varchar(1);
ie_juros_multa_venc_orig_w	parametro_contas_receber.ie_juros_multa_venc_orig%type;
cd_estabelecimento_w		bigint;

ie_entrada_confirmada_w		titulo_receber.ie_entrada_confirmada%type;	
cd_pessoa_fisica_w			titulo_receber.cd_pessoa_fisica%type;
cd_cgc_w					titulo_receber.cd_cgc%type;
nr_seq_conta_banco_w		titulo_receber.nr_seq_conta_banco%type;	
cd_banco_w					banco_estabelecimento.cd_banco%type;			
cd_agencia_bancaria_w		banco_estabelecimento.cd_agencia_bancaria%type;
nr_conta_w					banco_estabelecimento.cd_conta%type;
ie_digito_conta_w			banco_estabelecimento.ie_digito_conta%type;
cd_camara_compensacao_w		pessoa_fisica_conta.cd_camara_compensacao%type;	
ie_retorno_w				bigint;
ie_tipo_ocorrencia_w		bigint;
vl_desc_previsto_w			titulo_receber.vl_desc_previsto%type;
vl_saldo_titulo_w			titulo_receber.vl_saldo_titulo%type;
cd_moeda_w					titulo_receber.cd_moeda%type;
ie_desc_previsto_w			varchar(1);
nr_seq_motivo_desc_w		titulo_receber_liq_desc.nr_seq_motivo_desc%type;		
cd_centro_custo_desc_w		titulo_receber_liq_desc.cd_centro_custo%type;
ie_juros_multa_w			varchar(1);			

c01 CURSOR FOR
	SELECT	cd_banco,
			cd_agencia_bancaria,
			nr_conta,
			nr_digito_conta,
			cd_camara_compensacao
	from 	pessoa_fisica_conta
	where	cd_pessoa_fisica 	= cd_pessoa_fisica_w
	
union

	SELECT	cd_banco,
			cd_agencia_bancaria,
			nr_conta,
			nr_digito_conta,
			cd_camara_compensacao
	from 	pessoa_juridica_conta
	where	cd_cgc 	= cd_cgc_w;
BEGIN
  BEGIN

if (wheb_usuario_pck.get_ie_executar_trigger = 'S') then
select	max(cd_estabelecimento)
into STRICT	cd_estabelecimento_w
from	titulo_receber
where	nr_titulo	= NEW.nr_titulo;

select	coalesce(max(ie_juros_multa_barras_bloq),'N'),
	coalesce(max(ie_juros_multa_venc_orig),'N')
into STRICT	ie_juros_multa_barras_bloq_w,
	ie_juros_multa_venc_orig_w
from	parametro_contas_receber
where	cd_estabelecimento	= cd_estabelecimento_w;

if (ie_juros_multa_barras_bloq_w <> 'N') and (ie_juros_multa_venc_orig_w = 'S') then
	CALL gerar_bloqueto_tit_rec(NEW.nr_titulo, 'MTR');
end if;


select	max(a.ie_entrada_confirmada),
		max(a.cd_pessoa_fisica),
		max(a.cd_cgc),
		max(a.nr_seq_conta_banco),
		max(a.vl_desc_previsto),
		max(a.vl_saldo_titulo),
		max(a.cd_moeda)
into STRICT	ie_entrada_confirmada_w,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		nr_seq_conta_banco_w,
		vl_desc_previsto_w,
		vl_saldo_titulo_w,
		cd_moeda_w
from	titulo_receber a
where	a.nr_titulo = NEW.nr_titulo;

if (ie_entrada_confirmada_w = 'C') then
	/*Tipo de Ocorrencia igual a 6 pois 6 e para Alteracao de Vencimento*/


	ie_tipo_ocorrencia_w := 6;
	
	BEGIN
	select	a.cd_banco,
			a.cd_agencia_bancaria,
			a.cd_conta,
			a.ie_digito_conta
	into STRICT	cd_banco_w,
			cd_agencia_bancaria_w,
			nr_conta_w,
			ie_digito_conta_w
	from	banco_estabelecimento a
	where	a.nr_sequencia = nr_seq_conta_banco_w;
	exception when others then
			ie_retorno_w	:= 0;
	end;
	
	if (ie_retorno_w = 0) then
		open c01;
		loop
		fetch c01 into
			cd_banco_w,
			cd_agencia_bancaria_w,
			nr_conta_w,
			ie_digito_conta_w,
			cd_camara_compensacao_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			cd_banco_w	:= cd_banco_w;
		end loop;
		close c01;
	end if;
	
	ie_desc_previsto_w := obter_param_usuario(815, 9, obter_perfil_ativo, NEW.nm_usuario, obter_estabelecimento_ativo, ie_desc_previsto_w);
	ie_juros_multa_w := obter_param_usuario(815, 16, obter_perfil_ativo, NEW.nm_usuario, obter_estabelecimento_ativo, ie_juros_multa_w);
	
	select	max(a.cd_centro_custo),
			max(a.nr_seq_motivo_desc)
	into STRICT	cd_centro_custo_desc_w,
			nr_seq_motivo_desc_w
	from	titulo_receber_liq_desc a
	where	a.nr_titulo		= NEW.nr_titulo
	and		a.nr_bordero	is null
	and		a.nr_seq_liq	is null;
	
	insert into titulo_receber_instr(	nr_seq_cobranca,
										nr_titulo,
										vl_cobranca,
										dt_atualizacao,
										nm_usuario,
										cd_banco,
										cd_agencia_bancaria,
										nr_conta,
										cd_moeda,
										ie_digito_conta,
										cd_camara_compensacao,
										vl_desconto,
										vl_desc_previsto,
										vl_acrescimo,
										nr_sequencia,
										vl_despesa_bancaria,
										vl_saldo_inclusao,
										qt_dias_instrucao,
										cd_ocorrencia,
										ie_instrucao_enviada,
										nr_seq_motivo_desc,
										cd_centro_custo_desc,
										vl_juros,
										vl_multa,
										ie_selecionado)
							values (	null,
										NEW.nr_titulo,
										vl_saldo_titulo_w,
										LOCALTIMESTAMP,
										NEW.nm_usuario,
										cd_banco_w,
										cd_agencia_bancaria_w,
										nr_conta_w,
										cd_moeda_w,
										ie_digito_conta_w,
										cd_camara_compensacao_w,
										CASE WHEN ie_desc_previsto_w='S' THEN  coalesce(vl_desc_previsto_w,0) END  + coalesce((obter_dados_titulo_receber(NEW.nr_titulo,'VNC'))::numeric ,0),
										CASE WHEN ie_desc_previsto_w='S' THEN  coalesce(vl_desc_previsto_w,0)  ELSE 0 END ,
										0,
										nextval('titulo_receber_instr_seq'),
										0,
										vl_saldo_titulo_w,
										null,
										substr(obter_ocorrencia_envio_cre(ie_tipo_ocorrencia_w,cd_banco_w),1,3),
										'N',
										nr_seq_motivo_desc_w,
										cd_centro_custo_desc_w,
										CASE WHEN ie_juros_multa_w='S' THEN (obter_juros_multa_titulo(NEW.nr_titulo,LOCALTIMESTAMP,'R','J'))::numeric   ELSE null END ,
										CASE WHEN ie_juros_multa_w='S' THEN (obter_juros_multa_titulo(NEW.nr_titulo,LOCALTIMESTAMP,'R','M'))::numeric   ELSE null END ,
										'N');											
end if;

end if;
  END;
RETURN NEW;
end;
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_alteracao_vencimento_insert() FROM PUBLIC;

CREATE TRIGGER alteracao_vencimento_insert
	AFTER INSERT ON alteracao_vencimento FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_alteracao_vencimento_insert();

