-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_adiantamento_pago (nr_titulo_p bigint, nr_adiantamento_p bigint, vl_vinculacao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_inclui_exclui_p text) AS $body$
DECLARE



vl_saldo_titulo_w		double precision := 0;
vl_saldo_adiant_w		double precision := 0;
nr_lote_contabil_w		bigint := 0;
nr_sequencia_w			bigint := 0;
vl_vinculacao_ant_w		double precision := 0;
nr_seq_trans_fin_w		bigint;
dt_contabil_w			timestamp;

cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
cd_empresa_w				estabelecimento.cd_empresa%type;
ie_tipo_titulo_cpa_w		titulo_pagar.ie_tipo_titulo%type;
ie_baixa_lote_contab_w		parametros_contas_pagar.ie_baixa_lote_contab%type;
nr_lote_contabil_adiant_w	lote_contabil.nr_lote_contabil%type;
ds_tipo_lote_contabil_w		tipo_lote_contabil.ds_tipo_lote_contabil%type;
qt_registro_w				bigint;

/* Projeto Multimoeda - Variaveis */

vl_adto_estrang_w	double precision;
vl_cotacao_w		cotacao_moeda.vl_cotacao%type;
vl_complemento_w	double precision;
cd_moeda_w			integer;
vl_cambial_ativo_w		titulo_pagar_adiant.vl_cambial_ativo%type;
vl_cambial_passivo_w	titulo_pagar_adiant.vl_cambial_passivo%type;

c01 CURSOR FOR
SELECT	coalesce(vl_adiantamento,0)
from	titulo_pagar_adiant
where	nr_titulo		= nr_titulo_p
and	nr_adiantamento	= nr_adiantamento_p
and	vl_adiantamento	= vl_vinculacao_p * -1;


BEGIN

if (coalesce(nr_adiantamento_p,0) > 0) then
/* obter dados do adiantamento  */
select	coalesce(nr_lote_contabil,0),
	vl_saldo
into STRICT 	nr_lote_contabil_w,
	vl_saldo_adiant_w
from	adiantamento_pago
where	nr_adiantamento	= nr_adiantamento_p;

if (coalesce(nr_titulo_p, 0) > 0) then

	/* obter dados do titulo  */
	select	vl_saldo_titulo
	into STRICT 	vl_saldo_titulo_w
	from	titulo_pagar
	where	nr_titulo	= nr_titulo_p;
	
	/* Projeto Multimoeda - Busca dados  do adiantamento do titulo a pagar*/

	select max(vl_adto_estrang),
		max(vl_cotacao),
		max(cd_moeda),
		max(vl_cambial_ativo),
		max(vl_cambial_passivo)
	into STRICT vl_adto_estrang_w,
		vl_cotacao_w,
		cd_moeda_w,
		vl_cambial_ativo_w,
		vl_cambial_passivo_w
	from titulo_pagar_adiant
	where nr_titulo = nr_titulo_p
	and nr_sequencia = nr_sequencia_p;
				
	select	max(nr_seq_trans_fin),
		max(dt_contabil)
	into STRICT nr_seq_trans_fin_w,
		dt_contabil_w
	from titulo_pagar_adiant
	where nr_titulo = nr_titulo_p
	and nr_sequencia = nr_sequencia_p;

	if (ie_inclui_exclui_p = 'I') then

		select max(ie_tipo_titulo),
			max(cd_estabelecimento)
		into STRICT ie_tipo_titulo_cpa_w,
			cd_estabelecimento_w
		from titulo_pagar
		where nr_titulo = nr_titulo_p;

		if (cd_estabelecimento_w IS NOT NULL AND cd_estabelecimento_w::text <> '') then

			if (coalesce(fin_obter_se_mes_aberto(cd_estabelecimento_w,dt_contabil_w,'CP',ie_tipo_titulo_cpa_w,null,null,null),'S') = 'N') then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(183663);
			end if;

			CALL philips_contabil_pck.valida_se_dia_fechado(OBTER_EMPRESA_ESTAB(cd_estabelecimento_w),dt_contabil_w);

			select  max(ie_baixa_lote_contab)
			into STRICT  ie_baixa_lote_contab_w
			from  parametros_contas_pagar
			where   cd_estabelecimento  = cd_estabelecimento_w;

			select  max(cd_empresa)
			into STRICT  cd_empresa_w
			from  estabelecimento
			where  cd_estabelecimento = cd_estabelecimento_w;

			if (cd_empresa_w IS NOT NULL AND cd_empresa_w::text <> '') then

				if (ie_baixa_lote_contab_w = 'N') then
					select  count(*)
					into STRICT  qt_registro_w
					from   ctb_mes_ref
					where  cd_empresa = cd_empresa_w
					and  substr(ctb_obter_se_mes_fechado(nr_sequencia,cd_estabelecimento_w),1,1) = 'F'
					and  trunc(dt_referencia,'month') = trunc(dt_contabil_w,'month');

					if (qt_registro_w > 0) then
						/*O mes de referencia na contabilidade para esta data de baixa (#@DT_BAIXA#@) ja foi fechado!*/

						CALL Wheb_mensagem_pck.exibir_mensagem_abort(204540,'DT_BAIXA='||PKG_DATE_FORMATERS.to_varchar(dt_contabil_w, 'shortDate', cd_estabelecimento_w, nm_usuario_p));
					end if;

				elsif (ie_baixa_lote_contab_w = 'L') then

					select  count(*),
						max(a.nr_lote_contabil),
						max(b.ds_tipo_lote_contabil)
					into STRICT  qt_registro_w,
						nr_lote_contabil_adiant_w,
						ds_tipo_lote_contabil_w
					from   tipo_lote_contabil b,
						lote_contabil a
					where  a.cd_tipo_lote_contabil  = b.cd_tipo_lote_contabil
					and  a.cd_estabelecimento = cd_estabelecimento_w
					and  trunc(a.dt_referencia,'dd')  = trunc(dt_contabil_w,'dd')
					and  a.cd_tipo_lote_contabil  = 7
					and  exists (  SELECT  1
						from  movimento_contabil z
						where  z.nr_lote_contabil  = a.nr_lote_contabil);

					if (qt_registro_w > 0) then
						/*Ja foi gerado lote contabil para esta data de baixa.
						Lote: #@NR_LOTE_CONTABIL#@
						Tipo de lote contabil: #@DS_TIPO_LOTE_CONTABIL#@
						Data: #@DT_BAIXA#@*/
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(204541, 'NR_LOTE_CONTABIL='||nr_lote_contabil_adiant_w ||
							';DS_TIPO_LOTE_CONTABIL='||ds_tipo_lote_contabil_w ||
							';DT_BAIXA='||PKG_DATE_FORMATERS.to_varchar(dt_contabil_w, 'shortDate', cd_estabelecimento_w, nm_usuario_p));
					end if;

				elsif (ie_baixa_lote_contab_w = 'M') then

					select  count(*),
						max(a.nr_lote_contabil),
						max(b.ds_tipo_lote_contabil)
					into STRICT  qt_registro_w,
						nr_lote_contabil_adiant_w,
						ds_tipo_lote_contabil_w
					from  tipo_lote_contabil b,
						lote_contabil a
					where  a.cd_tipo_lote_contabil  = b.cd_tipo_lote_contabil
					and  a.cd_estabelecimento = cd_estabelecimento_w
					and  trunc(a.dt_referencia,'dd')  >= trunc(dt_contabil_w,'dd')
					and  trunc(a.dt_referencia,'month')  = trunc(dt_contabil_w,'month')
					and  a.cd_tipo_lote_contabil  = 7
					and  exists (  SELECT  1
						from  movimento_contabil z
						where  z.nr_lote_contabil  = a.nr_lote_contabil);

					if (qt_registro_w > 0) then
						/*Ja foi gerado lote contabil para esta data de baixa.
						Lote: #@NR_LOTE_CONTABIL#@
						Tipo de lote contabil: #@DS_TIPO_LOTE_CONTABIL#@
						Data: #@DT_BAIXA#@*/
						CALL Wheb_mensagem_pck.exibir_mensagem_abort(204541, 'NR_LOTE_CONTABIL='||nr_lote_contabil_adiant_w ||
							';DS_TIPO_LOTE_CONTABIL='||ds_tipo_lote_contabil_w ||
							';DT_BAIXA='||PKG_DATE_FORMATERS.to_varchar(dt_contabil_w, 'shortDate', cd_estabelecimento_w, nm_usuario_p));
					end if;

				elsif (ie_baixa_lote_contab_w = 'F') then

					select  count(*)
					into STRICT  qt_registro_w
					from   ctb_mes_ref
					where  cd_empresa = cd_empresa_w
					and  trunc(dt_referencia,'month') = trunc(dt_contabil_w,'month');

					if (qt_registro_w > 0) then
						/*Ja existe mes de referencia na contabilidade para esta data de baixa (#@DT_BAIXA#@).*/

						CALL Wheb_mensagem_pck.exibir_mensagem_abort(204542,'DT_BAIXA='||PKG_DATE_FORMATERS.to_varchar(dt_contabil_w, 'shortDate', cd_estabelecimento_w, nm_usuario_p));
					end if;

				end if;
			end if;
		end if;

		vl_saldo_titulo_w	:= vl_saldo_titulo_w - vl_vinculacao_p;
		vl_saldo_adiant_w	:= vl_saldo_adiant_w - vl_vinculacao_p;

		/*		Edgar 05/05/2005 Atualizar_Saldo_Tit_Pagar ja atualiza saldo titulo
		if	(vl_saldo_titulo_w = 0) then

			update	titulo_pagar
			set	vl_saldo_titulo	= vl_saldo_titulo_w,
       		 		ie_situacao	= 'L',
				dt_liquidacao	= trunc(sysdate)
			where	nr_titulo	= nr_titulo_p;

		elsif	(vl_saldo_titulo_w <> 0) then

			update	titulo_pagar
			set	vl_saldo_titulo = vl_saldo_titulo_w,
				ie_situacao     = 'A'	
			where	nr_titulo	= nr_titulo_p;

		end if;
		*/
	elsif (ie_inclui_exclui_p = 'E') then

		vl_saldo_titulo_w	:= vl_saldo_titulo_w + vl_vinculacao_p;
		vl_saldo_adiant_w	:= vl_saldo_adiant_w + vl_vinculacao_p;

		open c01;
		loop
		fetch c01 into
			vl_vinculacao_ant_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		end loop;

		if (vl_vinculacao_ant_w = 0) then

			/*	Edgar 05/05/2005 Atualizar_Saldo_Tit_Pagar ja atualiza saldo titulo
			update	titulo_pagar
			set	vl_saldo_titulo	= vl_saldo_titulo_w,
				ie_situacao	= 'A',
				dt_liquidacao	= null
			where	nr_titulo	= nr_titulo_p;
			*/
			if (nr_lote_contabil_w = 0) then

				delete	from titulo_pagar_adiant
				where	nr_titulo	= nr_titulo_p
				and	nr_sequencia	= nr_sequencia_p;

			elsif (nr_lote_contabil_w <> 0) then

				select	max(nr_sequencia) + 1
				into STRICT	nr_sequencia_w
				from	titulo_pagar_adiant
				where	nr_titulo	= nr_titulo_p;
				
				/* Projeto Multimoeda - Verifica se o adiantamento e em moeda estrangeira, caso negativo limpa os campos antes de gravar*/

				if (coalesce(vl_adto_estrang_w,0) <> 0) then
					vl_complemento_w := (vl_vinculacao_p - vl_adto_estrang_w) * -1;
					vl_adto_estrang_w := vl_adto_estrang_w * -1;
					vl_cambial_ativo_w := vl_cambial_ativo_w * -1;
					vl_cambial_passivo_w := vl_cambial_passivo_w * -1;
				else
					vl_adto_estrang_w := null;
					vl_complemento_w := null;
					vl_cotacao_w := null;
					cd_moeda_w := null;
					vl_cambial_ativo_w := null;
					vl_cambial_passivo_w := null;
				end if;
				
				insert	into titulo_pagar_adiant(nr_titulo,
					nr_sequencia, 
					nr_adiantamento,
					vl_adiantamento,
					nm_usuario,
					dt_atualizacao,
					nr_seq_trans_fin,
					dt_contabil,
					vl_adto_estrang,
					vl_complemento,
					vl_cotacao,
					cd_moeda,
					vl_cambial_ativo,
					vl_cambial_passivo)
				values (nr_titulo_p,
					nr_sequencia_w,
					nr_adiantamento_p,
					vl_vinculacao_p * -1,
					nm_usuario_p,
					clock_timestamp(),
					nr_seq_trans_fin_w,
					dt_contabil_w,
					vl_adto_estrang_w,
					vl_complemento_w,
					vl_cotacao_w,
					cd_moeda_w,
					vl_cambial_ativo_w,
					vl_cambial_passivo_w);
			end if;
		end if;
	end if;

	CALL Atualizar_Saldo_Tit_Pagar(nr_titulo_p, nm_usuario_p);
	CALL Gerar_W_Tit_Pag_imposto(nr_titulo_p, nm_usuario_p);

end if;
/* Projeto Multimoeda - Verifica o valor antes de passar o parametro.*/

if (coalesce(vl_cotacao_w,0) = 0) then
	vl_cotacao_w := null;
end if;

CALL ATUALIZAR_SALDO_ADIANT_PAGO(nr_adiantamento_p, nm_usuario_p, vl_cotacao_w);

commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_adiantamento_pago (nr_titulo_p bigint, nr_adiantamento_p bigint, vl_vinculacao_p bigint, nr_sequencia_p bigint, nm_usuario_p text, ie_inclui_exclui_p text) FROM PUBLIC;
