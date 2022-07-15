-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_juro_multa_titulo (nr_tit_pagar_p bigint, nr_tit_receber_p bigint, dt_referencia_p timestamp, ie_considera_saldo_p text, ie_venc_original_p text, vl_juros_p INOUT bigint, vl_multa_p INOUT bigint) AS $body$
DECLARE


  /* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  Finalidade: Calcular o valor de juros e multa para o titulo seja a pagar ou a receber conforme
  os tipos de taxa a quantidade de dias que o titulo esta vencido.
  -------------------------------------------------------------------------------------------------------------------

  Locais de chamada direta:
  [ X ]  Objetos do dicionario [ X ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
   ------------------------------------------------------------------------------------------------------------------

  Pontos de atencao:
    - O parametro ie_venc_original_p, que indica se sera usada a data de vencimento
    atual ou a original para a contagem dos dias vencidos; (Funcao Parametros do
    Contas a Receber, pasta Titulo, campo Valores de juros e multa conforme
    vencimento original)
  
    - O valor de multa fixo que ira desconsiderar o calculo feito com base nos
    dias X taxa
  
    - Os valores dispensados de juros e multa para o titulo (somente a receber),
    funcao Manutencao de Titulos a Receber , pasta Disp. Jur/Multa
  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_taxa_w			varchar(255);
tx_juros_w			double precision := 0;
tx_multa_w			double precision := 0;
pr_juros_w			double precision := 0;
pr_multa_w			double precision := 0;
vl_saldo_juros_w		double precision := 0;
vl_saldo_multa_w		double precision := 0;
vl_saldo_titulo_w		double precision := 0;
vl_saldo_juros_inicial_w	double precision := 0;
vl_saldo_multa_inicial_w	double precision := 0;
vl_deducao_juros_w		double precision;
vl_deducao_multa_w		double precision;
vl_multa_fixo_w			double precision;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
qt_dia_venc_w			bigint;
dt_vencimento_atual_w		timestamp;
dt_vencimento_w			timestamp;
dt_venc_original_w		timestamp;
ie_data_juros_multa_w		varchar(50);
ds_vencimento_w			varchar(255);
ie_dt_vencimento_dia_util_w	varchar(1);
cd_estabelecimento_w		titulo_receber.cd_estabelecimento%type;
ie_juros_multa_nao_util_w	parametro_contas_receber.ie_juros_multa_nao_util%type;
dt_vencimento_util_w		timestamp;
vl_multa_ano_w			double precision := 0;
dt_vencimento_antecip_w		timestamp;
qt_alt_w			bigint;


BEGIN

if (coalesce(nr_tit_pagar_p, 0) > 0) then
	select	tx_juros,
		tx_multa,
		cd_tipo_taxa_juro,
		cd_tipo_taxa_multa,
		dt_vencimento_atual,
		dt_vencimento_original,
		vl_saldo_titulo,
		vl_saldo_juros,
		vl_saldo_multa,
		cd_estabelecimento
	into STRICT	tx_juros_w,
		tx_multa_w,
		cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w,
		dt_vencimento_atual_w,
		dt_venc_original_w,
		vl_saldo_titulo_w,
		vl_saldo_juros_inicial_w,
		vl_saldo_multa_inicial_w,
		cd_estabelecimento_w
	from	titulo_pagar
	where	nr_titulo = nr_tit_pagar_p;
elsif (coalesce(nr_tit_receber_p, 0) > 0) then
	select	tx_juros,
		tx_multa,
		cd_tipo_taxa_juro,
		cd_tipo_taxa_multa,
		dt_pagamento_previsto,
		dt_vencimento,
		vl_saldo_titulo,
		vl_saldo_juros,
		vl_saldo_multa,
		vl_multa_fixo,
		coalesce(ie_data_juros_multa, 'DT_VENCIMENTO'),
		cd_estabelecimento
	into STRICT 	tx_juros_w,
		tx_multa_w,
		cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w,
		dt_vencimento_atual_w,
		dt_venc_original_w,
		vl_saldo_titulo_w,
		vl_saldo_juros_inicial_w,
		vl_saldo_multa_inicial_w,
		vl_multa_fixo_w,
		ie_data_juros_multa_w,
		cd_estabelecimento_w
	from	titulo_receber
	where	nr_titulo = nr_tit_receber_p;
end if;

/* Se o parametro ie_venc_original_p estiver como 'S', sera levado em conta a data de vencimento, caso contrario, data de vencimento atual. */

if (ie_venc_original_p = 'S') then
	dt_vencimento_w := dt_venc_original_w;
elsif (ie_venc_original_p = 'N') then
	dt_vencimento_w := dt_vencimento_atual_w;
elsif (ie_venc_original_p = 'U') then					
		dt_vencimento_w := Obter_valor_Dinamico_date_bv(	'select ' || ie_data_juros_multa_w ||
					' from titulo_receber where nr_titulo = :nr_titulo', 'nr_titulo=' || nr_tit_receber_p, dt_vencimento_w);				
end if;

/*aamfirmo OS 946604 - Tratamento para verificar se o dia do vencimento e um dia util, se nao for pega o proximo.*/

if (dt_vencimento_w IS NOT NULL AND dt_vencimento_w::text <> '') and (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then
	select	coalesce(max(ie_juros_multa_nao_util), 'N')
	into STRICT	ie_juros_multa_nao_util_w
	from	parametro_contas_receber
	where	cd_estabelecimento = cd_estabelecimento_w;

	if (ie_juros_multa_nao_util_w = 'N') or (obter_proximo_dia_util(cd_estabelecimento_w, dt_venc_original_w) =	dt_referencia_p) then

		select	obter_se_dia_util(dt_vencimento_w, cd_estabelecimento_w)
		into STRICT	ie_dt_vencimento_dia_util_w
		;

		/*Se o dia do vencimento nao for dia util, considera o proximo dia util*/

		if (coalesce(ie_dt_vencimento_dia_util_w, 'S') = 'N') and (trunc(obter_proximo_dia_util(cd_estabelecimento_w,dt_vencimento_w)) = trunc(dt_referencia_p)) then /*OS 1970305 - Se o pagamento ocorrer depois do proximo dia util com base no vencimento, o calculo de juros deve ser com base no vencimento do titulo e nao mais no proximo dia util*/
			dt_vencimento_util_w := obter_proximo_dia_util(cd_estabelecimento_w,dt_vencimento_w);
			dt_vencimento_w      := coalesce(dt_vencimento_util_w, dt_vencimento_w);			
		end if;

	end if;
end if;

qt_dia_venc_w := trunc(dt_referencia_p, 'dd')	-	trunc(dt_vencimento_w, 'dd');

if (qt_dia_venc_w > 0) then
	if (tx_juros_w > 0) then
		select	max(ie_tipo_taxa)
		into STRICT	ie_tipo_taxa_w
		from	tipo_taxa
		where	cd_tipo_taxa = cd_tipo_taxa_juro_w;

		if (ie_tipo_taxa_w = 'A') then
			pr_juros_w := dividir_sem_round((tx_juros_w)::numeric, 365) * qt_dia_venc_w;
		elsif (ie_tipo_taxa_w = 'M') then
			pr_juros_w := dividir_sem_round((tx_juros_w)::numeric, 30) * qt_dia_venc_w;
		elsif (ie_tipo_taxa_w = 'D') then
			pr_juros_w := tx_juros_w * qt_dia_venc_w;
		end if;

		/* Francisco - OS 49496 - Tratamento para valores fixos diarios */

		if (ie_tipo_taxa_w = 'V') then
			vl_saldo_juros_w := tx_juros_w * qt_dia_venc_w;
		else
			vl_saldo_juros_w := vl_saldo_titulo_w *	(dividir_sem_round((pr_juros_w)::numeric, 100));
		end if;
	end if;

	if (tx_multa_w > 0) then
		
		vl_saldo_multa_w	:= vl_saldo_titulo_w * (dividir_sem_round((tx_multa_w)::numeric, 100));
		
		if (coalesce(vl_multa_fixo_w::text, '') = '') and (nr_tit_receber_p IS NOT NULL AND nr_tit_receber_p::text <> '') then
			select	max(ie_tipo_taxa)
			into STRICT	ie_tipo_taxa_w
			from	tipo_taxa
			where	cd_tipo_taxa	=	cd_tipo_taxa_multa_w;

			if (ie_tipo_taxa_w = 'F') then
				vl_saldo_multa_w := tx_multa_w;
			elsif (ie_tipo_taxa_w = 'P') then /*Valor cobrado um vez  apos um ano*/

				  /* 
				  ** A: 	Para considerar a adicao de multa, deve estar vencido a um ano ou mais 
				  ** B: 	Calculo de vencimento e definida no parametro ie_venc_original_p, e usada como base pra calculo dos dias vencidos
				  **	e e definida diretamente no parametro do contas a receber.
				  ** C: 	Verificar alteracao anterior:
				  **		* Caso ja tenha alguma alteracao anterior com calculo de multa e juros, ignorar calculo atual
				  **		* Caso tenha alguma alteracao anterior sem calculo de multa e juros , sera usada a regra ie_venc_original_p 
				  ** D	Parametro Valor de multa fixo deve ser null
				  ** E	Nao ter alteracao de vencimento com calculo de juros anterior
				  */
				
				vl_saldo_multa_w := 0;
				
				--Buscar lancamentos anterior
				select	count(*)
				into STRICT	qt_alt_w
				from	w_alteracao_vencimento
				where	nr_titulo = coalesce(nr_tit_receber_p, nr_tit_pagar_p)
				and	ie_calc_juros_multa = 'S';
				
				--if qt_dia_venc_w >= 365 and qt_alt_w < 1 then
					vl_saldo_multa_w := vl_saldo_titulo_w * (dividir_sem_round((tx_multa_w)::numeric, 100));
				--end if;
			elsif (ie_tipo_taxa_w = 'A') then /*Valor calculaod por ano*/
		
				vl_multa_ano_w := qt_dia_venc_w /365;
				vl_multa_ano_w := trunc(vl_multa_ano_w) + 1;
				vl_saldo_multa_w := vl_saldo_multa_w * vl_multa_ano_w;
				
			end if;
		end if;
		
		
	end if;
end if;

if (vl_multa_fixo_w IS NOT NULL AND vl_multa_fixo_w::text <> '') then
	vl_saldo_multa_w := vl_multa_fixo_w;
end if;

/* Francisco OS 48392 - Somar saldo de juros e multa inicial */

if (ie_considera_saldo_p = 'S') then

	if (coalesce(ie_tipo_taxa_w::text, '') = '') then
		select	max(ie_tipo_taxa)
		into STRICT	ie_tipo_taxa_w
		from	tipo_taxa
		where	cd_tipo_taxa = cd_tipo_taxa_multa_w;
	end if;

	if ((trunc(dt_referencia_p, 'dd') - trunc(dt_vencimento_w, 'dd')) < 0) then
		if (coalesce(nr_tit_receber_p, 0) > 0) then
			select	coalesce(max(VL_JUROS), 0), coalesce(max(VL_MULTA), 0)
			into STRICT	vl_saldo_juros_inicial_w, vl_saldo_multa_inicial_w
			from	w_alteracao_vencimento
			where	nr_titulo = coalesce(nr_tit_receber_p, nr_tit_pagar_p);
		end if;
		vl_saldo_juros_w := vl_saldo_juros_inicial_w + vl_saldo_juros_w;

		if (ie_tipo_taxa_w <> 'P') or
		 (ie_tipo_taxa_w = 'P' AND vl_saldo_multa_w = 0) then
			vl_saldo_multa_w := vl_saldo_multa_inicial_w + vl_saldo_multa_w;
		end if;
	else
		vl_saldo_juros_w := vl_saldo_juros_inicial_w + vl_saldo_juros_w;

		if (ie_tipo_taxa_w <> 'P') or
		 (ie_tipo_taxa_w = 'P' AND vl_saldo_multa_w = 0) then
			vl_saldo_multa_w := vl_saldo_multa_inicial_w + vl_saldo_multa_w;
		end if;
	end if;
end if;

/* Eduardo/Francisco - 03/11/2011 - OS 375180 - Dispensar juros e multa*/

if (nr_tit_receber_p IS NOT NULL AND nr_tit_receber_p::text <> '') then
	select	coalesce(sum(CASE WHEN ie_acao='E' THEN  vl_movimento * -1  ELSE vl_movimento END ),0)
	into STRICT	vl_deducao_juros_w
	from	titulo_juros_multa
	where	nr_titulo = nr_tit_receber_p
	and	ie_juros_multa = 'J'
	and	dt_movimento <= dt_referencia_p;

	select	coalesce(sum(CASE WHEN ie_acao='E' THEN  vl_movimento * -1  ELSE vl_movimento END ),0)
	into STRICT	vl_deducao_multa_w
	from	titulo_juros_multa
	where	nr_titulo = nr_tit_receber_p
	and	ie_juros_multa = 'M'
	and	dt_movimento <= dt_referencia_p;

	if (vl_deducao_juros_w <> 0) then
		vl_saldo_juros_w := abs(vl_saldo_juros_w - vl_deducao_juros_w);
	end if;

	if (vl_deducao_multa_w > 0) then
		vl_saldo_multa_w := abs(vl_saldo_multa_w - vl_deducao_multa_w);
	end if;
end if;

vl_juros_p := vl_saldo_juros_w;
vl_multa_p := vl_saldo_multa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_juro_multa_titulo (nr_tit_pagar_p bigint, nr_tit_receber_p bigint, dt_referencia_p timestamp, ie_considera_saldo_p text, ie_venc_original_p text, vl_juros_p INOUT bigint, vl_multa_p INOUT bigint) FROM PUBLIC;

