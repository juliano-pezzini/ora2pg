-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_receber ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, cd_condicao_pagamento_p bigint, dt_base_vencimento_p timestamp, dt_emissao_p timestamp, vl_total_conta_p bigint, vl_conta_p bigint, tx_juros_p bigint, cd_tipo_taxa_juro_p bigint, tx_multa_p bigint, cd_tipo_taxa_multa_p bigint, tx_desc_antecip_p bigint, nr_documento_p bigint, nr_guia_p text, nr_sequencia_doc_p bigint, nr_nota_fiscal_p bigint, cd_serie_p text, nm_usuario_p text, nr_seq_nf_saida_p bigint, cd_moeda_p bigint default null, vl_cotacao_p bigint default null) AS $body$
DECLARE

				
ie_geracao_w			ctb_regra_geracao_lote_rec.ie_geracao%type;				
cd_empresa_w			ctb_param_lote_nf.cd_empresa%type;
ie_ctb_online_w			ctb_param_lote_nf.ie_ctb_online%type	:= 'N';
ie_geracao_p			ctb_regra_geracao_lote_rec.ie_geracao%type;
ie_tipo_convenio_w		convenio.ie_tipo_convenio%type;
ie_erro_w			numeric(1)		:= 0;
cont_portador_w			smallint;
ie_forma_pagamento_w		numeric(2)		:= 0;
nr_titulo_w			numeric(10,0)		:= 0;
nr_titul_pagar_w		bigint;
tx_fracao_parcela_w		numeric(15,4)		:= 0;
tx_acrescimo_w			numeric(15,4)		:= 0;
dt_base_w			timestamp			:= clock_timestamp();
vl_total_w			numeric(15,2)		:= 0;
vl_ajuste_w			numeric(15,2)		:= 0;
cd_moeda_padrao_w		numeric(5,0)		:= 0;
cd_tipo_portador_w		numeric(5,0)      	:= 0;
cd_portador_w			numeric(10,0)    	:= 0;
ie_tipo_emissao_titulo_w	numeric(5)      	:= 1;
ie_origem_titulo_w		varchar(10)		:= '2';
ie_tipo_titulo_w		varchar(5);
ie_tipo_inclusao_w		varchar(1)		:= '2';
cd_banco_w			numeric(5,0)     	:= null;
cd_agencia_bancaria_w		varchar(8)		:= null;
nr_bloqueto_w			varchar(20)		:= null;
nr_sequencia_w			numeric(5)		:= 0;
vl_devolucao_w			numeric(13,2)  		:= 0;
dt_liquidacao_w			timestamp;
ie_situacao_w			varchar(1)		:= '1';
cd_condicao_pagamento_w		numeric(10)		:= null;
dt_vencimento_w			timestamp			:= null;
vl_vencimento_w			double precision		:= 0;
ie_acao_venc_nao_util_w		varchar(1)		:= 'M';
nr_seq_Venc_conta_w		bigint;
nr_seq_Venc_Prot_w		bigint;
nr_item_w			bigint		:= 0;
cd_estab_financeiro_w		bigint;
nr_seq_classe_w			bigint		:= null;
cd_convenio_conta_w		bigint		:= null;
ie_gerar_imposto_w		varchar(1);
nr_seq_nf_saida_w		bigint;
nr_seq_trans_fin_contab_w	bigint;
dt_contabil_w			timestamp;
ie_dt_contab_tit_prot_w		varchar(1)		:= 'E';
cd_tributo_w			smallint;
vl_tributo_w			double precision;
tx_tributo_w			double precision;
vl_base_calculo_w		double precision;
vl_trib_nao_retido_w		double precision;
vl_base_nao_retido_w		double precision;
vl_trib_adic_w			double precision;
vl_base_adic_w			double precision;
nr_seq_trans_fin_baixa_w	bigint;
ie_nf_tit_rec_w			varchar(1);
cont_w				integer;
nr_seq_conta_banco_w		bigint;
nr_seq_carteira_cobr_w		bigint;
ie_tipo_acrescimo_w		varchar(1)		:= 'P';
vl_base_juros_w			double precision;
tx_multa_w			double precision;
tx_juros_w			double precision;
vl_trib_titulo_w		double precision;
qt_vencimentos_w		bigint;
ds_vencimentos_w		varchar(2000);
ie_vinc_tit_prot_w		varchar(50);
nr_seq_protocolo_w		bigint;
nr_nota_fiscal_w		varchar(255);
ie_titulo_pagar_w		varchar(1);
cd_estabelecimento_w		smallint;
dt_emissao_w			timestamp;
pr_aliquota_w			double precision;
vl_minimo_base_w		double precision;
vl_minimo_tributo_w		double precision;
ie_acumulativo_w		varchar(10);
vl_teto_base_w			double precision;
vl_desc_dependente_w		double precision;
nr_seq_regra_w			bigint;
cd_cgc_beneficiario_w		varchar(14);
cd_pessoa_fisica_w		varchar(10);
nr_seq_tit_rec_trib_w		bigint;
ie_calcula_venc_aprazo_w	varchar(10);
nr_seq_trans_prov_trib_rec_w	bigint;
ie_dt_contab_tit_prot_estab_w	varchar(1);
nr_seq_trans_tit_conta_w	bigint;
ie_integracao_titulo_w		varchar(15);
ds_erro_w			varchar(2000);
nr_rps_atual_w			bigint;
nr_rps_w			bigint;
nr_seq_agrupamento_w		bigint;
vl_tributo_tit_saldo_w		double precision;
ie_gerar_nota_tit_w		varchar(1);
cd_pessoa_nota_w		nota_fiscal.cd_pessoa_fisica%type;
cd_cgc_nota_w			nota_fiscal.cd_cgc%type;
ie_origem_trib_w			nota_fiscal_trib.ie_origem_trib%type;
nr_seq_trans_fin_bx_classe_w	classe_titulo_receber.nr_seq_trans_fin_baixa%type;
nr_seq_trans_fin_cont_clas_w	classe_titulo_receber.nr_seq_trans_fin_contab%type;
cd_moeda_w			numeric(5,0)		:= 0;
vl_titulo_estrang_w		titulo_receber.vl_titulo_estrang%type;
ie_titulo_lote_w		varchar(1);
qt_regra_comp_w			bigint := 0;

cd_darf_w			regra_calculo_imposto.cd_darf%type;

C01 CURSOR FOR
	SELECT	/* A Prazo   */
		tx_fracao_parcela,
		coalesce(tx_acrescimo,0),
		Obter_data_vencimento(
					dt_base_w,
				qt_dias_parcela,
				cd_estabelecimento_p,
				ie_corrido_util,
				ie_acao_venc_nao_util_w),
		0
	from 	parcela
	where 	cd_condicao_pagamento 	= cd_condicao_pagamento_w
	and 	ie_forma_pagamento_w	<> 1
	and  	nr_seq_venc_conta_w 	= 0
	and	nr_seq_Venc_Prot_w	= 0
	
union

	SELECT 	100, 0,	/* A Vista   */
		dt_base_w, 0
	
	where 	ie_forma_pagamento_w	= 1
	and  	nr_seq_venc_conta_w 	= 0
	and	nr_seq_Venc_Prot_w	= 0
	
union

	select	/* Vencimentos da conta  */
		pr_vencimento,
		coalesce(pr_acrescimo,0),
		dt_vencimento,
		coalesce(vl_vencimento,0)
	from 	vencimento_titulo
	where 	nr_interno_conta 	= nr_interno_conta_p
	
union

	select 	/* Vencimentos do Protocolo  */
		pr_vencimento,
		coalesce(pr_acrescimo,0),
		dt_vencimento,
		coalesce(vl_vencimento,0)
	from 	vencimento_titulo
	where 	nr_seq_protocolo 	= nr_seq_protocolo_p;

C03 CURSOR FOR
	SELECT	a.cd_tributo,
		a.vl_tributo,
		a.tx_tributo,
		a.vl_base_calculo,
		a.vl_trib_nao_retido,
		a.vl_base_nao_retido,
		a.vl_trib_adic,
		a.vl_base_adic,
		a.ie_origem_trib
	from	nota_fiscal_trib a
	where	a.nr_sequencia	= coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w)

union
	
	SELECT  cd_tributo,
			sum(vl_tributo),
			tx_tributo, /*a taxa do tributo nao pode ser somada, senao ficara uma taxa incorreta no titulo*/
			sum(vl_base_calculo),
			sum(vl_trib_nao_retido),
			sum(vl_base_nao_retido),
			sum(vl_trib_adic),
			sum(vl_base_adic),
            case IE_SALDO_TIT_REC
                when 'S' then 
                    case coalesce(pkg_i18n.get_user_locale,'pt_BR')
                        when 'es_CO' then
                            'CD'
                        else 
                            null
                    end
                else 
                    null 
            end ie_origem_trib
	from ( select	a.cd_tributo,
					a.vl_tributo,
					a.tx_tributo,
					a.vl_base_calculo,
					a.vl_trib_nao_retido,
					a.vl_base_nao_retido,
					a.vl_trib_adic,
					a.vl_base_adic,
                    b.IE_SALDO_TIT_REC
			FROM nota_fiscal_item_trib a
LEFT OUTER JOIN regra_calculo_imposto b ON (a.nr_seq_regra_trib = b.nr_sequencia)
WHERE a.nr_sequencia	= coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w) ) alias9
		group by    cd_tributo,
			  		tx_tributo, 
                    ie_saldo_tit_rec;


BEGIN

select	max(a.cd_estabelecimento),
	max(a.dt_emissao)
into STRICT	cd_estabelecimento_w,
	dt_emissao_w
from	nota_fiscal a
where	a.nr_sequencia	= coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w);

/* ahoffelder - OS 176297 - 10/11/2009 */

ie_tipo_titulo_w		:= Obter_Valor_Param_Usuario(801,77, Obter_perfil_Ativo, nm_usuario_p, 0);
ie_vinc_tit_prot_w		:= Obter_Valor_Param_Usuario(-80,57, Obter_perfil_Ativo, nm_usuario_p, 0);
ie_calcula_venc_aprazo_w	:= Obter_Valor_Param_Usuario(-80,68, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);
ie_gerar_nota_tit_w		:= Obter_Valor_Param_Usuario(-80,5, Obter_perfil_Ativo, nm_usuario_p, cd_estabelecimento_p);		
ie_titulo_lote_w		:= Obter_Valor_Param_Usuario(-80,98,obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);

if (coalesce(ie_gerar_nota_tit_w,'N') = 'S') then
	if (coalesce(cd_pessoa_fisica_p,'X') = 'X' and
		coalesce(cd_cgc_p,'X') = 'X') then
		begin
		select	max(cd_pessoa_fisica),
			max(cd_cgc)
		into STRICT	cd_pessoa_nota_w,
			cd_cgc_nota_w
		from	nota_fiscal
		where	nr_sequencia = nr_seq_nf_saida_p;
		end;
	end if;
end if;
		
if (coalesce(ie_tipo_titulo_w::text, '') = '') then
	ie_tipo_titulo_w	:= '1';
end if;

cd_convenio_conta_w	:= null;

if (coalesce(nr_interno_conta_p, 0) > 0) then
	select	max(cd_convenio_parametro)
	into STRICT	cd_convenio_conta_w
	from	conta_paciente
	where	nr_interno_conta	= nr_interno_conta_p;
elsif (coalesce(nr_seq_protocolo_p, 0) > 0) then
	select	max(cd_convenio)
	into STRICT	cd_convenio_conta_w
	from	protocolo_convenio
	where	nr_seq_protocolo	= nr_seq_protocolo_p;
	
	select	coalesce(max(ie_tipo_titulo_rec),'1') --OS 2416460, Tipo de titulo do cadastro de convenio. Nvl com 1 pois se nao tiver nada no cadastro do convenio, precisa manter o que tem tratado logo acima.
	into STRICT	ie_tipo_titulo_w
	from	convenio_estabelecimento
	where	cd_convenio = cd_convenio_conta_w;
	
end if;

select 	coalesce(max(nr_sequencia),0)
into STRICT 	nr_seq_Venc_conta_w
from 	vencimento_titulo
where	nr_interno_conta = nr_interno_conta_p;

select 	coalesce(max(nr_sequencia),0)
into STRICT 	nr_seq_Venc_prot_w
from 	vencimento_titulo
where 	nr_seq_protocolo = nr_seq_protocolo_p;

select 	max(nr_seq_trans_fin_contab)
into STRICT 	nr_seq_trans_fin_contab_w
from 	parametro_contas_receber
where	cd_estabelecimento  = cd_estabelecimento_p;

/* verifica validacao */

if (vl_conta_p = 0) then
   	begin
   	dt_liquidacao_w 	:= clock_timestamp();
   	ie_situacao_w   	:= '2';
   	end;
end if;

ie_erro_w 			:= 0;

if (cd_condicao_pagamento_p > 0) then
   	cd_condicao_pagamento_w := cd_condicao_pagamento_p;
else
  	begin
   	select 	cd_condicao_pagamento
   	into STRICT 	cd_condicao_pagamento_w
   	from 	nota_fiscal
   	where 	nr_interno_conta = nr_interno_conta_p;
   	end;
end if;

/* verifica se nota possui condicao de pagamento - erro(2)*/

if (ie_erro_w 		= 0) and (cd_condicao_pagamento_w = 0) then
     	ie_erro_w 		:= 2;
end if;

/* seleciona dados do parametro_contas_receber erro(1)*/

if    	ie_erro_w = 0 then
	select 	coalesce(max(cd_moeda_padrao),1),
		coalesce(max(ie_gerar_imposto_tit_rec),'N'),
		coalesce(nr_seq_trans_fin_contab_w,max(nr_seq_trans_fin_nf)),
		max(nr_seq_trans_fin_baixa),
		max(ie_integracao_titulo)
 	into STRICT 	cd_moeda_padrao_w,
		ie_gerar_imposto_w,
		nr_seq_trans_fin_contab_w,
		nr_seq_trans_fin_baixa_w,
		ie_integracao_titulo_w
 	from 	parametro_contas_receber
 	where	cd_estabelecimento  = cd_estabelecimento_p;
end if;

/* seleciona dados da condicao de pagamento - erro(3)*/

if    	ie_erro_w = 0 then
	select 	coalesce(max(ie_forma_pagamento),3),
		coalesce(max(ie_acao_nao_util),'M'),
		coalesce(max(ie_tipo_acrescimo),'P')
	into STRICT 	ie_forma_pagamento_w,
		ie_acao_venc_nao_util_w,
		ie_tipo_acrescimo_w
 	from 	condicao_pagamento
	where 	cd_condicao_pagamento = cd_condicao_pagamento_w
	and 	ie_situacao           = 'A';
end if;

/* parametro faturamento */

select	coalesce(max(ie_dt_contab_tit_prot),'E')
into STRICT	ie_dt_contab_tit_prot_w
from	parametro_faturamento
where	cd_estabelecimento	= cd_estabelecimento_p;

/*Convenio Estabelecimento*/

if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	select	coalesce(max(a.nr_seq_trans_tit_prot),nr_seq_trans_fin_contab_w)
	into STRICT	nr_seq_trans_fin_contab_w
	from	convenio_estabelecimento a
	where	a.cd_convenio		= cd_convenio_conta_w
	and	a.cd_estabelecimento	= cd_estabelecimento_p;
end if;

/*lhalves OS381574 em 24/11/2011*/

if (coalesce(nr_interno_conta_p, 0) > 0) then
	select	max(nr_seq_trans_tit_conta)
	into STRICT	nr_seq_trans_tit_conta_w
	from	convenio_estabelecimento a
	where	a.cd_convenio		= cd_convenio_conta_w
	and	a.cd_estabelecimento	= cd_estabelecimento_p;	
	
	nr_seq_trans_fin_baixa_w	:= coalesce(nr_seq_trans_tit_conta_w,nr_seq_trans_fin_baixa_w);
end if;

select	max(nr_rps_atual)
into STRICT	nr_rps_atual_w
from	parametro_tesouraria
where	cd_estabelecimento	= cd_estabelecimento_p;

nr_rps_w	:= null;


select	max(ie_dt_conta_tit_prot)
into STRICT	ie_dt_contab_tit_prot_estab_w
from	convenio_estabelecimento
where	cd_convenio		= cd_convenio_conta_w
and	cd_estabelecimento	= cd_estabelecimento_p;

dt_base_w	:= dt_base_vencimento_p;

/* define data base para condicao pagamento */

if    	ie_erro_w = 0            then
	Select coalesce(Obter_Data_Base_Venc(dt_base_w, ie_forma_pagamento_w), dt_base_w)
	into STRICT  dt_base_w
	;
end if;

select	count(*)
into STRICT	cont_portador_w
from	portador
where	cd_portador = 0
and	cd_tipo_portador = 0;
if (cont_portador_w = 0) then
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(186194);
end if;

select	coalesce(cd_estab_financeiro, cd_estabelecimento)
into STRICT	cd_estab_financeiro_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;


/* gravar Titulo */

if (ie_erro_w = 0)         then
      	begin
	nr_item_w	:= nr_sequencia_doc_p;

	SELECT * FROM OBTER_PORTADOR_PF_PJ(cd_estabelecimento_p, coalesce(cd_pessoa_fisica_p,cd_pessoa_nota_w), coalesce(cd_cgc_p,cd_cgc_nota_w), cd_portador_w, cd_tipo_portador_w) INTO STRICT cd_portador_w, cd_tipo_portador_w;

	/* Francisco - OS 106247 - 19/03/2009 - Calcular juros pela base */

	if (ie_tipo_acrescimo_w = 'B') then
		vl_base_juros_w	:= obter_base_acresc_cond_pagto(cd_condicao_pagamento_w,vl_conta_p);
	end if;

	if (cd_condicao_pagamento_w IS NOT NULL AND cd_condicao_pagamento_w::text <> '') and
		((ie_forma_pagamento_w not in (1,2,12,10)) or (ie_forma_pagamento_w = 2 and (coalesce(ie_calcula_venc_aprazo_w,'N') = 'S'))) then
		SELECT * FROM Calcular_Vencimento(
			cd_estabelecimento_p, cd_condicao_pagamento_w, dt_base_w, qt_vencimentos_w, ds_vencimentos_w) INTO STRICT qt_vencimentos_w, ds_vencimentos_w;
	end if;

      	OPEN  C01;
      	LOOP
	FETCH c01 into
            	tx_fracao_parcela_w,
            	tx_acrescimo_w,
		dt_vencimento_w,
		vl_vencimento_w;
      	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		/* Francisco - 07/05/2009 - OS 139276 - Tratar outros tipos de vencimento */

		if	((ie_forma_pagamento_w not in (1,2,12,10)) or (ie_forma_pagamento_w = 2 and (coalesce(ie_calcula_venc_aprazo_w,'N') = 'S'))) then
			dt_vencimento_w		:= To_Date(substr(ds_vencimentos_w,1,10),'dd/mm/yyyy');
			ds_vencimentos_w	:= substr(ds_vencimentos_w,12, length(ds_vencimentos_w));
		end if;

		if (vl_vencimento_w = 0) then
			begin
			if (coalesce(tx_fracao_parcela_w,0) > 0) then
            			vl_vencimento_w 	:= ((vl_conta_p * tx_fracao_parcela_w) / 100);
			end if;
               		vl_total_w   		:= vl_total_w + vl_vencimento_w;
			end;
       		end if;
       		if (tx_acrescimo_w <> 0) then

			if (coalesce(ie_tipo_acrescimo_w,'P') = 'P') then
              			vl_vencimento_w 	:= vl_vencimento_w + ((vl_vencimento_w * tx_acrescimo_w) / 100);
			elsif (coalesce(ie_tipo_acrescimo_w,'B') = 'B') then
				vl_vencimento_w 	:= vl_vencimento_w + ((vl_base_juros_w * tx_acrescimo_w) / 100);
			end if;
      		end if;

		if (coalesce(nr_nota_fiscal_p,0) > 0) and (coalesce(nr_interno_conta_p,0) > 0) then
			select	coalesce(max(nr_sequencia), null)
			into STRICT	nr_seq_nf_saida_w
			from	nota_fiscal
			where	nr_interno_conta	= nr_interno_conta_p
			and	nr_nota_fiscal		= nr_nota_fiscal_p;
		end if;
		/* Matheus - OS97866 13-08-2008 Forma de pagamento 12 */

		if (ie_forma_pagamento_w = 12) then
			begin
			if ((to_char(dt_emissao_p,'dd'))::numeric  <= 15) then
				dt_vencimento_w	:= to_date('15/' || to_char(PKG_DATE_UTILS.ADD_MONTH(dt_emissao_p,1,0),'mm/yyyy'));
			else
				dt_vencimento_w	:= PKG_DATE_UTILS.END_OF(PKG_DATE_UTILS.ADD_MONTH(dt_emissao_p,1,0), 'MONTH', 0);
			end if;
			end;
		end if;

		/* Francisco - 12/02/2008 - OS 75548 */

		dt_contabil_w		:= dt_emissao_p;
		
		ie_dt_contab_tit_prot_w	:= coalesce(ie_dt_contab_tit_prot_estab_w,ie_dt_contab_tit_prot_w);
		
		if (ie_dt_contab_tit_prot_w = 'R') then
			if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
				select	max(dt_mesano_referencia)
				into STRICT	dt_contabil_w
				from	protocolo_convenio
				where	nr_seq_protocolo	= nr_seq_protocolo_p;
			elsif (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
				select	coalesce(max(dt_mesano_referencia), dt_contabil_w)
				into STRICT	dt_contabil_w
				from	conta_paciente
				where	nr_interno_conta	= nr_interno_conta_p;
			end if;
		end if;		

		/* Francisco - 16/02/2009 - OS 120076 - Gravar carteira de cobranca */

		tx_juros_w		:= null;
		tx_multa_w		:= null;
		SELECT * FROM obter_carteira_cobranca(cd_estabelecimento_p, cd_convenio_conta_w, vl_vencimento_w, dt_emissao_p, nr_seq_conta_banco_w, nr_seq_carteira_cobr_w, tx_juros_w, tx_multa_w) INTO STRICT nr_seq_conta_banco_w, nr_seq_carteira_cobr_w, tx_juros_w, tx_multa_w;
		/* Fim Francisco - 16/02/2009 */

		nr_seq_protocolo_w		:= nr_seq_protocolo_p;

		if	((coalesce(ie_vinc_tit_prot_w, 'S') = 'N') and (coalesce(nr_interno_conta_p, 0) > 0) and (coalesce(nr_seq_protocolo_w,0) > 0)) then
			nr_seq_protocolo_w	:= null;
		end if;

		select	nextval('titulo_seq')
			into STRICT  nr_titulo_w
		;

		if (coalesce(nr_nota_fiscal_p,0) = 0) then	/* ahoffelder - OS 277926 - 08/02/2011 - nao carregar 0 (zero) no campo NR_NOTA_FISCAL */
			nr_nota_fiscal_w	:= null;
		else
			nr_nota_fiscal_w	:= nr_nota_fiscal_p;
		end if;

		/* Se o titulo e proveniente de um protocolo */

		if (coalesce(nr_interno_conta_p::text, '') = '') and (nr_seq_protocolo_w IS NOT NULL AND nr_seq_protocolo_w::text <> '') then

			ie_origem_titulo_w	:= '16';

		end if;

		if (vl_cotacao_p > 0) then
			vl_titulo_estrang_w	:= (vl_vencimento_w/vl_cotacao_p);
		end if;
		
		select	obter_agrupamento_setor(obter_setor_atendimento(nr_atendimento_p))
		into STRICT	nr_seq_agrupamento_w
		;
		
		if (coalesce(cd_moeda_p,0) > 0) then
			cd_moeda_w	:= cd_moeda_p;
		else
			cd_moeda_w	:= cd_moeda_padrao_w;			
		end if;
		
            	insert	into titulo_receber(
          		nr_titulo,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_emissao,
			dt_vencimento,
			dt_pagamento_previsto,
			vl_titulo,
			vl_saldo_titulo,
			vl_saldo_juros,
			vl_saldo_multa,
			cd_moeda,
			cd_portador,
			cd_tipo_portador,
			ie_situacao,
			ie_tipo_emissao_titulo,
			ie_origem_titulo,
			ie_tipo_titulo,
			ie_tipo_inclusao,
			cd_pessoa_fisica,
			cd_cgc,
			nr_interno_conta,
			nr_atendimento,
			cd_serie,
			nr_documento,
			nr_sequencia_doc,
			cd_banco,
			cd_agencia_bancaria,
			nr_bloqueto,
			dt_liquidacao,
			nr_lote_contabil,
			ds_observacao_titulo,
			dt_contabil,
             		nr_seq_protocolo,
			tx_juros,
			cd_tipo_taxa_juro,
			tx_multa,
			cd_tipo_taxa_multa,
			tx_desc_antecipacao,
			nr_seq_classe,
			nr_guia,
			nr_nota_fiscal,
			nr_seq_nf_saida,
			cd_estab_financeiro,
			cd_convenio_conta,
			nr_seq_trans_fin_contab,
			nr_seq_trans_fin_baixa,
			nr_seq_conta_banco,
			nr_seq_carteira_cobr,
			nm_usuario_orig,
			dt_inclusao,
			nr_rps,
			nr_seq_agrupamento,
			vl_cotacao,
			vl_titulo_estrang)
     		values (nr_titulo_w,
			cd_estabelecimento_p,
			clock_timestamp(),
			nm_usuario_p,
	 		dt_emissao_p,
			dt_vencimento_w,
			dt_vencimento_w,
			vl_vencimento_w,
			vl_vencimento_w,
	 		0,
			0,
			cd_moeda_w,
			cd_portador_w,
			cd_tipo_portador_w,
	 		ie_situacao_w,
			ie_tipo_emissao_titulo_w,
	 		ie_origem_titulo_w,
			ie_tipo_titulo_w,
			ie_tipo_inclusao_w,
	 		coalesce(cd_pessoa_fisica_p,cd_pessoa_nota_w),
			coalesce(cd_cgc_p,cd_cgc_nota_w),
			nr_interno_conta_p,
            		nr_atendimento_p,
			cd_serie_p,
			nr_documento_p,
			nr_item_w,
	 		cd_banco_w,
			cd_agencia_bancaria_w,
			nr_bloqueto_w,
	 		dt_liquidacao_w,
			null,
			null,
			dt_contabil_w,
			nr_seq_protocolo_w,
			coalesce(tx_juros_w, tx_juros_p),
			cd_tipo_taxa_juro_p,
			coalesce(tx_multa_w, tx_multa_p),
			cd_tipo_taxa_multa_p,
			tx_desc_antecip_p,
			nr_seq_classe_w,
			nr_guia_p,
			nr_nota_fiscal_w,
			nr_seq_nf_saida_p,
			cd_estab_financeiro_w,
			cd_convenio_conta_w,
			nr_seq_trans_fin_contab_w,
			nr_seq_trans_fin_baixa_w,
			nr_seq_conta_banco_w,
			nr_seq_carteira_cobr_w,
			nm_usuario_p,
			clock_timestamp(),
			nr_rps_w,
			nr_seq_agrupamento_w,
			vl_cotacao_p,
			coalesce(vl_titulo_estrang_w,0));
			
		/* Obtem a classe do Titulo */

		select	obter_classe_titulo_receber(nr_interno_conta_p, nr_seq_protocolo_p, nr_titulo_w)
		into STRICT	nr_seq_classe_w
		;
		/*AAMFIRMO OS 884850. Obter tf fin e tf baixa da classe para apresentar no titulo*/

		if (nr_seq_classe_w IS NOT NULL AND nr_seq_classe_w::text <> '') then
			
			select	max(a.nr_seq_trans_fin_baixa),
					max(a.nr_seq_trans_fin_contab)
			into STRICT	nr_seq_trans_fin_bx_classe_w,
					nr_seq_trans_fin_cont_clas_w
			from	classe_titulo_receber a
			where	a.nr_sequencia = nr_seq_classe_w;
		
		end if;
		
		update	titulo_receber
		set		nr_seq_classe				= nr_seq_classe_w,
				nr_seq_trans_fin_contab		= CASE WHEN nr_seq_trans_fin_cont_clas_w = NULL THEN nr_seq_trans_fin_contab  ELSE nr_seq_trans_fin_cont_clas_w END , /*AAMFIRMO OS 884850. Obter tf fin e tf baixa da classe para apresentar no titulo*/
				nr_seq_trans_fin_baixa		= CASE WHEN nr_seq_trans_fin_bx_classe_w = NULL THEN nr_seq_trans_fin_baixa  ELSE nr_seq_trans_fin_bx_classe_w END   /*AAMFIRMO OS 884850. Obter tf fin e tf baixa da classe para apresentar no titulo*/
		where	nr_titulo	= nr_titulo_w;
		
		nr_item_w	:= nr_item_w + 1;
		if (ie_gerar_imposto_w = 'S') and
			((coalesce(nr_interno_conta_p,0) <> 0) or (coalesce(nr_seq_protocolo_p,0) <> 0))then
			CALL Gerar_Imposto_Tit_Rec(nr_titulo_w, nm_usuario_p);
		end if;

		/* Francisco - 23/02/2008 - OS 80151 - Gravar tributo da nota no titulo tambem */

		if ((coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w) IS NOT NULL AND (coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w))::text <> '')) then
			open C03;
			loop
			fetch C03 into
				cd_tributo_w,
				vl_tributo_w,
				tx_tributo_w,
				vl_base_calculo_w,
				vl_trib_nao_retido_w,
				vl_base_nao_retido_w,
				vl_trib_adic_w,
				vl_base_adic_w,
				ie_origem_trib_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */

				select	coalesce(max(ie_nf_tit_rec),'N'),
					max(nr_seq_trans_prov_trib_rec)
				into STRICT	ie_nf_tit_rec_w,
					nr_seq_trans_prov_trib_rec_w
				from	tributo
				where	cd_tributo	= cd_tributo_w;

				select	count(*)
				into STRICT	cont_w
				from	titulo_receber_trib
				where	nr_titulo	= nr_titulo_w
				and	cd_tributo	= cd_tributo_w;

				if	(ie_nf_tit_rec_w = 'S' AND cont_w = 0) or (ie_nf_tit_rec_w = 'U') then
					if (cont_w > 0) then
						delete from titulo_receber_trib
						where nr_titulo	= nr_titulo_w
						and cd_tributo	= cd_tributo_w;
					end if;

					select	nextval('titulo_receber_trib_seq')
					into STRICT	nr_seq_tit_rec_trib_w
					;
					insert	into titulo_receber_trib(nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						nr_titulo,
						cd_tributo,
						vl_tributo,
						tx_tributo,
						vl_base_calculo,
						vl_trib_nao_retido,
						vl_base_nao_retido,
						vl_trib_adic,
						vl_base_adic,
						vl_saldo,
						nr_seq_nota_fiscal,
						ie_origem_tributo,
						nr_seq_trans_financ)
					SELECT	nr_seq_tit_rec_trib_w,
						clock_timestamp(),
						nm_usuario_p,
						nr_titulo_w,
						cd_tributo_w,
						vl_tributo_w,
						tx_tributo_w,
						vl_base_calculo_w,
						vl_trib_nao_retido_w,
						vl_base_nao_retido_w,
						vl_trib_adic_w,
						vl_base_adic_w,
						vl_tributo_w,
						nr_seq_nf_saida_w,
						coalesce(ie_origem_trib_w,'C'),
						nr_seq_trans_prov_trib_rec_w
					;

					SELECT * FROM obter_dados_trib_tit_rec(cd_tributo_w, cd_estabelecimento_w, cd_convenio_conta_w, dt_emissao_w, 'N', pr_aliquota_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, coalesce(cd_pessoa_fisica_p,cd_pessoa_nota_w), coalesce(cd_cgc_p,cd_cgc_nota_w), null, ie_origem_titulo_w, 0, nr_seq_regra_w, cd_darf_w) INTO STRICT pr_aliquota_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, nr_seq_regra_w, cd_darf_w;

					select	max(a.ie_titulo_pagar),
						max(a.cd_cgc_beneficiario)
					into STRICT	ie_titulo_pagar_w,
						cd_cgc_beneficiario_w
					from	regra_calculo_imposto a
					where	a.nr_sequencia	= nr_seq_regra_w;
					
					select	count(*)
					into STRICT	cont_w
					from	titulo_pagar
					where	nr_seq_nota_fiscal	= coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w);
				
					if	((ie_titulo_pagar_w	= 'S') and
						((ie_titulo_lote_w = 'S') or (ie_titulo_lote_w = 'N' AND cont_w = 0))) then
						
						if (coalesce(cd_cgc_beneficiario_w::text, '') = '') then
							cd_pessoa_fisica_w	:= coalesce(cd_pessoa_fisica_p,cd_pessoa_nota_w);
						else
							cd_pessoa_fisica_w	:= null;
						end if;

						select	nextval('titulo_pagar_seq')
						into STRICT	nr_titul_pagar_w
						;

						insert	into titulo_pagar(cd_cgc,
							cd_estabelecimento,
							cd_estab_financeiro,
							cd_moeda,
							cd_pessoa_fisica,
							cd_tipo_taxa_juro,
							cd_tipo_taxa_multa,
							dt_atualizacao,
							dt_emissao,
							dt_vencimento_atual,
							dt_vencimento_original,
							ie_origem_titulo,
							ie_situacao,
							ie_tipo_titulo,
							nm_usuario,
							nr_seq_tit_rec_trib,
							nr_titulo,
							tx_juros,
							tx_multa,
							vl_saldo_juros,
							vl_saldo_multa,
							vl_saldo_titulo,
							vl_titulo,
							nr_lote_contabil,
							nr_seq_nota_fiscal)
						values (coalesce(cd_cgc_beneficiario_w,coalesce(cd_cgc_p,cd_cgc_nota_w)),
							cd_estabelecimento_w,
							cd_estab_financeiro_w,
							cd_moeda_padrao_w,
							cd_pessoa_fisica_w,
							cd_tipo_taxa_juro_p,
							cd_tipo_taxa_multa_p,
							clock_timestamp(),
							dt_emissao_w,
							dt_vencimento_w,
							dt_vencimento_w,
							'4',
							'A',
							'4',
							nm_usuario_p,
							nr_seq_tit_rec_trib_w,
							nr_titul_pagar_w,
							tx_juros_p,
							tx_multa_p,
							0,
							0,
							vl_tributo_w,
							vl_tributo_w,
							0,
							coalesce(nr_seq_nf_saida_p,nr_seq_nf_saida_w));
						CALL ATUALIZAR_INCLUSAO_TIT_PAGAR(nr_titul_pagar_w, nm_usuario_p);
					end if;
				end if;
			end loop;
			close C03;
		end if;
		end;

		select	coalesce(sum(CASE WHEN a.ie_soma_diminui='D' THEN (coalesce(b.vl_tributo,0) * - 1) WHEN a.ie_soma_diminui='S' THEN  coalesce(b.vl_tributo,0)  ELSE 0 END ),0)
		into STRICT	vl_trib_titulo_w
		from	tributo a,
			titulo_receber_trib b
		where	coalesce(a.ie_incide_conta,'N')	= 'S'
		and	a.cd_tributo		= b.cd_tributo
		and	b.nr_titulo		= nr_titulo_w;
		
		/*lhalves OS 609175 em 19/07/2013 - Buscar valores de tributo do titulo que estao como ''Calculado e dimuni saldo''
		Sem este tratamento, o sistema gerava o tributo no titulo, mas nao deduzia o saldo, apresentando um saldo ireal para o titulo
		*/
		select	coalesce(sum(VL_TRIBUTO),0) * -1
		into STRICT	vl_tributo_tit_saldo_w
		from	titulo_receber_trib
		where	nr_titulo			= nr_titulo_w
		and	coalesce(ie_origem_tributo, 'C') 	= 'CD';

		update	titulo_receber
		set	vl_titulo		= coalesce(vl_titulo,0) + coalesce(vl_trib_titulo_w,0),
			vl_saldo_titulo		= coalesce(vl_saldo_titulo,0) + coalesce(vl_trib_titulo_w,0) + vl_tributo_tit_saldo_w
		where	nr_titulo		= nr_titulo_w;

	end loop;
      	close c01;
	
	
	if (coalesce(nr_titulo_w,0) = 0) and (coalesce(ie_forma_pagamento_w,0) = 11) then
		select   count(*)
		into STRICT 	nr_item_w
		from     condicao_pagamento c,
			parcela p
		where 	c.cd_condicao_pagamento = p.cd_condicao_pagamento
		and 	c.cd_condicao_pagamento = cd_condicao_pagamento_w
		and 	c.ie_forma_pagamento = '11';
		
		if (coalesce(nr_item_w,0) = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(836854);
		end if;
	end if;
	
	if (vl_total_w > 0)  and (vl_total_w <> vl_conta_p)    then
		begin
		vl_ajuste_w 	:= (vl_conta_p - vl_total_w);
		
		update titulo_receber
		set 	vl_titulo	= vl_titulo + vl_ajuste_w,
		 	vl_saldo_titulo	= vl_saldo_titulo + vl_ajuste_w
		where	nr_titulo	= nr_titulo_w;
		end;
	end if;
	
	if (ie_integracao_titulo_w = 'P') then
	
		delete from erros_integracao_piramide
		where	cd_Estabelecimento = cd_estabelecimento_w
		and	nm_usuario = nm_usuario_p
		and	ie_funcao in ('TI','CLI');
				
		/*exec_sql_dinamico('Tasy','begin pir _importar _titulo _receber(' 	
				|| nvl(nr_interno_conta_p,0) || ','
				|| nvl(nr_seq_protocolo_p,0) || ','
				|| cd_estabelecimento_w || ','
				|| nr_titulo_w || ','
				|| chr(39) || vl_vencimento_w || chr(39) || ','
				|| chr(39) || dt_emissao_p || chr(39) || ','
				|| chr(39) || dt_vencimento_w || chr(39) || ','
				|| chr(39) || nvl(cd_pessoa_fisica_p,'X')  || chr(39) || ','
				|| chr(39) || nvl(cd_cgc_p,'X') || chr(39) || ','
				|| chr(39) || ie_tipo_titulo_w || chr(39) || ','
				|| chr(39) || ie_situacao_w || chr(39) || ','
				|| chr(39) || nr_nota_fiscal_p || chr(39) || ','
				|| chr(39) || nm_usuario_p || chr(39) || '); end;');*/
	
		select	max(ds_erro)
		into STRICT	ds_erro_w
		from	erros_integracao_piramide
		where	cd_Estabelecimento = cd_estabelecimento_w
		and	nm_usuario = nm_usuario_p
		and	ie_funcao in ('TI','CLI');

		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(186197,'DS_ERRO_P='||ds_erro_w);
		end if;
	end if;
		
	if	((coalesce(nr_titulo_w,0) > 0) and (nr_seq_protocolo_p > 0)) then
		begin

		select	count(1)
		into STRICT	qt_regra_comp_w
		from	regra_tit_rec_complementar
		where	coalesce(ie_situacao,'I') = 'A';
		
		CALL gerar_titulo_rec_complementar(nr_titulo_w,nr_seq_protocolo_p,nm_usuario_p);
		
		end;
	end if;
	
      	end;
end if;

/* Chamada Contabilizacao Lote Receita */

cd_empresa_w	:= obter_empresa_estab(cd_estabelecimento_p);	
ie_ctb_online_w := ctb_online_pck.get_modo_lote(  6, cd_estabelecimento_p, cd_empresa_w);

select  Obter_Tipo_Convenio(cd_convenio_conta_w)
into STRICT    ie_tipo_convenio_w
;		

ie_geracao_w	:= ctb_online_pck.get_geracao_lote_receita( cd_convenio_conta_w,
							cd_estabelecimento_p,							
							nm_usuario_p,
                                                        ie_tipo_convenio_w);													
if (ie_ctb_online_w = 'S' and ie_geracao_w = 'ETR') then
	begin
        CALL ctb_contab_onl_lote_receita(nr_seq_protocolo_p  =>  nr_seq_protocolo_p,
                                    nr_interno_conta_p  =>  nr_interno_conta_p,
                                    nm_usuario_p        =>  nm_usuario_p,
                                    dt_referencia_p     =>  dt_emissao_p);
	end;
end if;

ie_ctb_online_w := ctb_online_pck.get_modo_lote(  14, cd_estabelecimento_p, cd_empresa_w);		
if (ie_ctb_online_w = 'S' and ie_geracao_w = 'ETR') then
	CALL ctb_contab_onl_repasse( nr_seq_protocolo_p, nr_interno_conta_p, null, nm_usuario_p);	
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_receber ( cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_atendimento_p bigint, nr_interno_conta_p bigint, nr_seq_protocolo_p bigint, cd_condicao_pagamento_p bigint, dt_base_vencimento_p timestamp, dt_emissao_p timestamp, vl_total_conta_p bigint, vl_conta_p bigint, tx_juros_p bigint, cd_tipo_taxa_juro_p bigint, tx_multa_p bigint, cd_tipo_taxa_multa_p bigint, tx_desc_antecip_p bigint, nr_documento_p bigint, nr_guia_p text, nr_sequencia_doc_p bigint, nr_nota_fiscal_p bigint, cd_serie_p text, nm_usuario_p text, nr_seq_nf_saida_p bigint, cd_moeda_p bigint default null, vl_cotacao_p bigint default null) FROM PUBLIC;
