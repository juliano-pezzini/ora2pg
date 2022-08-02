-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE unificar_titulos_bloqueto (nr_titulo_p bigint, ds_lista_titulo_p text, nr_bloqueto_p text, nm_usuario_p text, dt_emissao_p timestamp, dt_contabil_p timestamp, dt_vencto_atual_p timestamp, dt_vencto_orig_p timestamp, nr_seq_classe_p bigint, nr_titulo_gerado_p INOUT bigint) AS $body$
DECLARE


nr_titulo_w			bigint;
nr_titulo_dest_w		bigint;
vl_saldo_titulo_w		double precision;
vl_saldo_juros_w		double precision;
vl_saldo_multa_w		double precision;
vl_dia_antecipacao_w		double precision;
nr_seq_trans_financ_w		bigint;
cd_estabelecimento_w		smallint;
vl_total_w			double precision;
vl_total_juros_w		double precision;
vl_total_multa_w		double precision;
vl_total_desconto_w		double precision;
cd_moeda_padrao_w		integer;
cd_tipo_baixa_w			integer;
qt_classe_titulo_w		bigint;
nr_seq_classe_w			bigint;
ie_consiste_classe_w		varchar(1);
ie_origem_tit_pagar_w		varchar(10);
cd_tributo_w			titulo_pagar.cd_tributo%type;
qt_tributo_titulo_w		bigint;
ie_tipo_data_baixa_w	varchar(5);
dt_baixa_tit_unif_w		timestamp;

c01 CURSOR FOR
SELECT	nr_titulo,
	vl_saldo_titulo,
	vl_saldo_juros,
	vl_saldo_multa,
	vl_dia_antecipacao
from	titulo_pagar
where	' ' || ds_lista_titulo_p || ' ' like '% ' || nr_titulo || ',%'
and	(ds_lista_titulo_p IS NOT NULL AND ds_lista_titulo_p::text <> '');


BEGIN

if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (ds_lista_titulo_p IS NOT NULL AND ds_lista_titulo_p::text <> '') then
	
	ie_consiste_classe_w	:= obter_valor_param_usuario(851, 179, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);

	if (ie_consiste_classe_w = 'S') then
		select	max(nr_seq_classe),
			count(distinct coalesce(nr_seq_classe,0))
		into STRICT	nr_seq_classe_w,
			qt_classe_titulo_w
		from	titulo_pagar
		where	' ' || ds_lista_titulo_p || ' ' like '% ' || nr_titulo || ',%';

		if (qt_classe_titulo_w > 1) then
			CALL Wheb_mensagem_pck.exibir_mensagem_abort(209914);
		end if;
	end if;
	

	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	titulo_pagar
	where	nr_titulo	= nr_titulo_p;

	select	max(nr_seq_trans_fin_transf),
		max(cd_moeda_padrao)
	into STRICT	nr_seq_trans_financ_w,
		cd_moeda_padrao_w
	from	parametros_contas_pagar
	where	cd_estabelecimento	= cd_estabelecimento_w;

	select	coalesce(sum(vl_saldo_titulo),0),
		coalesce(sum(vl_saldo_juros),0),
		coalesce(sum(vl_saldo_multa),0),
		coalesce(sum(coalesce(vl_dia_antecipacao,0)),0),
		max(cd_tributo)
	into STRICT	vl_total_w,
		vl_total_juros_w,
		vl_total_multa_w,
		vl_total_desconto_w,
		cd_tributo_w
	from	titulo_pagar
	where	' ' || ds_lista_titulo_p || ' ' like '% ' || nr_titulo || ',%'
	and	(ds_lista_titulo_p IS NOT NULL AND ds_lista_titulo_p::text <> '');

	cd_tipo_baixa_w	:= obter_valor_param_usuario(851, 101, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);

	if (coalesce(cd_tipo_baixa_w,0) = 0) then
		cd_tipo_baixa_w	:= 4;
	end if;
	
	ie_tipo_data_baixa_w := obter_param_usuario(851, 263, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_tipo_data_baixa_w);
	if (ie_tipo_data_baixa_w = 'DA') then
		dt_baixa_tit_unif_w := clock_timestamp();
	elsif (ie_tipo_data_baixa_w = 'DE')  then
		dt_baixa_tit_unif_w := dt_emissao_p;
	elsif (ie_tipo_data_baixa_w = 'DC')  then
		dt_baixa_tit_unif_w := dt_contabil_p;
	elsif (ie_tipo_data_baixa_w = 'DVO')  then
		dt_baixa_tit_unif_w := dt_vencto_orig_p;
	elsif (ie_tipo_data_baixa_w = 'DVA')  then
		dt_baixa_tit_unif_w := dt_vencto_atual_p;
	end if;

	open c01;
	loop
	fetch c01 into
		nr_titulo_w,	
		vl_saldo_titulo_w,
		vl_saldo_juros_w,
		vl_saldo_multa_w,
		vl_dia_antecipacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	
		update	titulo_pagar
		set	ie_tipo_titulo		= 1,
			nr_bloqueto		= nr_bloqueto_p,
			nr_seq_trans_fin_baixa	= nr_seq_trans_financ_w
		where	nr_titulo		= nr_titulo_w;

		CALL baixa_titulo_pagar(cd_estabelecimento_w,
				cd_tipo_baixa_w,
				nr_titulo_w,
				vl_saldo_titulo_w,
				nm_usuario_p,
				nr_seq_trans_financ_w,
				null,
				null,
				dt_baixa_tit_unif_w,
				null);

		CALL atualizar_saldo_tit_pagar(nr_titulo_w,nm_usuario_p);
		CALL Gerar_W_Tit_Pag_imposto(nr_titulo_w, nm_usuario_p);
	
	end loop;
	close c01;

	if (vl_total_w > 0) then	
	
		select count(*)
		into STRICT qt_tributo_titulo_w
		from (
			SELECT 	distinct cd_tributo
			from 	titulo_pagar
			where	' ' || ds_lista_titulo_p || ' ' like '% ' || nr_titulo || ',%'
			and	(ds_lista_titulo_p IS NOT NULL AND ds_lista_titulo_p::text <> '')		
			) alias3;
			
		-- Se haver tributos diferentes nos titulos unificados nao leva pro novo titulo
		if (qt_tributo_titulo_w > 1) and (cd_tributo_w IS NOT NULL AND cd_tributo_w::text <> '') then
			cd_tributo_w := null;
		end if;	
	
		ie_origem_tit_pagar_w := obter_valor_param_usuario(851, 183, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w);
		
		select	nextval('titulo_pagar_seq')
		into STRICT	nr_titulo_dest_w
		;

		insert	into	titulo_pagar(nr_titulo,
			nm_usuario,
			dt_atualizacao,
			ie_situacao,
			ie_origem_titulo,
			ie_tipo_titulo,
			cd_estabelecimento,
			cd_tipo_taxa_multa,
			cd_tipo_taxa_juro,
			cd_tipo_taxa_antecipacao,
			tx_multa,
			tx_juros,
			cd_moeda,
			vl_titulo,
			vl_saldo_titulo,
			dt_emissao,
			dt_contabil,
			dt_vencimento_original,
			dt_vencimento_atual,
			cd_pessoa_fisica,
			cd_cgc,
			nr_bloqueto,
			vl_saldo_juros,
			vl_saldo_multa,
			vl_dia_antecipacao,
			ds_observacao_titulo,
			cd_estab_financeiro,
			nr_seq_classe,
			cd_tributo)
		SELECT	nr_titulo_dest_w,
			nm_usuario_p,
			clock_timestamp(),
			'A',
			ie_origem_tit_pagar_w,
			1,
			cd_estabelecimento,
			1,
			1,
			1,
			0,
			0,
			cd_moeda_padrao_w,
			vl_total_w,
			vl_total_w,
			coalesce(dt_emissao_p, dt_emissao),
			trunc(coalesce(dt_contabil_p, clock_timestamp()),'dd'),
			coalesce(dt_vencto_orig_p, dt_vencimento_original),
			coalesce(dt_vencto_atual_p, dt_vencimento_atual),
			cd_pessoa_fisica,
			cd_cgc,
			nr_bloqueto_p,
			vl_total_juros_w,
			vl_total_multa_w,
			vl_total_desconto_w,
			--'Unificacao dos titulos: ' || ds_lista_titulo_p,
			wheb_mensagem_pck.get_texto(303988,'DS_LISTA_TITULO_P='||ds_lista_titulo_p),
			cd_estab_financeiro,
			coalesce(nr_seq_classe_p, nr_seq_classe_w),
			cd_tributo_w
		from	titulo_pagar
		where	nr_titulo	= nr_titulo_p;
		
		CALL ATUALIZAR_INCLUSAO_TIT_PAGAR(nr_titulo_dest_w, nm_usuario_p);
		CALL gerar_titulo_pagar_classif(ds_lista_titulo_p,nr_titulo_dest_w,nm_usuario_p);

	end if;

	nr_titulo_gerado_p	:= nr_titulo_w;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE unificar_titulos_bloqueto (nr_titulo_p bigint, ds_lista_titulo_p text, nr_bloqueto_p text, nm_usuario_p text, dt_emissao_p timestamp, dt_contabil_p timestamp, dt_vencto_atual_p timestamp, dt_vencto_orig_p timestamp, nr_seq_classe_p bigint, nr_titulo_gerado_p INOUT bigint) FROM PUBLIC;

