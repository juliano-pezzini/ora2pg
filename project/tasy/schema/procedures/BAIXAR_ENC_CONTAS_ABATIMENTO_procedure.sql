-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_enc_contas_abatimento ( nr_seq_lote_p bigint, dt_baixa_p timestamp, ie_acao_p text, nr_seq_pessoa_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_titulo_pagar_w		bigint;
nr_titulo_receber_w		bigint;
vl_saldo_tit_receb_w		double precision;
vl_saldo_tit_pag_w		double precision;
cd_estabelecimento_pag_w	bigint;
ie_tipo_pagamento_pag_w		varchar(50);
nr_seq_trans_fin_baixa_pag_w	bigint;
cd_estabelecimento_receb_w	bigint;
cd_tipo_recebimento_receb_w	bigint;
nr_seq_trans_fin_baixa_receb_w	bigint;
cd_tipo_baixa_pag_w		parametros_contas_pagar.cd_tipo_baixa_padrao%type;
nr_seq_trans_abat_pag_w		parametros_contas_pagar.nr_seq_trans_fin_abat%type;
nr_seq_trans_financ_receb_w	bigint;
cd_tipo_recebimento_w		tipo_recebimento.cd_tipo_recebimento%type;
nr_seq_trans_fin_receb_w	bigint;
nr_seq_baixa_tit_pag_w		bigint;
nr_seq_liq_rec_w		bigint;
nr_estorno_pag_w		bigint;
nr_estorno_rec_w		bigint;
nr_seq_trans_financ_baixa_cpa   bigint;
nr_seq_trans_financ_baixa_cre   bigint;
ie_trans_fin_baixa_w            varchar(1);
cd_tipo_baixa_param_w           bigint;

cd_pessoa_fisica_w				pessoa_encontro_contas.cd_pessoa_fisica%type;
cd_cgc_w						pessoa_encontro_contas.cd_cgc%type;
ie_tipo_pessoa_w				varchar(255)	:= null;
qt_regra_w						bigint;
cd_tipo_baixa_w					tipo_baixa_cpa.cd_tipo_baixa%type;
cd_tipo_recebimento_par_w		parametro_encontro_contas.cd_tipo_recebimento%type;
cd_tipo_receb_regra_w			regra_receb_enc_contas.cd_tipo_recebimento%type;
cd_tipo_baixa_cpa_regra_w		regra_receb_enc_contas.cd_tipo_baixa_cpa%type;


C01 CURSOR FOR
	SELECT	a.nr_titulo_receber nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.cd_tipo_recebimento cd_tipo_recebimento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_receber b,
		encontro_contas_item a
	where	a.nr_seq_pessoa		= nr_seq_pessoa_p
	and	a.nr_titulo_receber	= b.nr_titulo
	order by nr_titulo;

C02 CURSOR FOR
	SELECT	a.nr_titulo_pagar nr_titulo,
		b.vl_saldo_titulo vl_saldo_titulo,
		b.cd_estabelecimento cd_estabelecimento,
		b.ie_tipo_pagamento ie_tipo_pagamento,
		b.nr_seq_trans_fin_baixa nr_seq_trans_fin_baixa
	from	titulo_pagar b,
		encontro_contas_item a
	where	a.nr_seq_pessoa		= nr_seq_pessoa_p
	and	a.nr_titulo_pagar	= b.nr_titulo
	order by nr_titulo;
C03 CURSOR FOR
	SELECT	a.cd_tipo_recebimento,
			a.cd_tipo_baixa_cpa
	from	regra_receb_enc_contas	a
	where	a.ie_tipo_pessoa	= ie_tipo_pessoa_w
	order by
		a.nr_sequencia desc;

BEGIN

dbms_application_info.SET_ACTION('BAIXAR_ENC_CONTAS_ABATIMENTO');

select a.nr_seq_trans_baixa_cpa,
       a.nr_seq_trans_baixa_cre,
	a.ie_trans_fin_baixa,
	a.cd_tipo_baixa,
    a.cd_tipo_recebimento
into STRICT   nr_seq_trans_financ_baixa_cpa,
       nr_seq_trans_financ_baixa_cre,
       ie_trans_fin_baixa_w,
       cd_tipo_baixa_param_w,
	   cd_tipo_recebimento_par_w
	   from parametro_encontro_contas a
	   where cd_estabelecimento = obter_estabelecimento_ativo;

open C01;
loop
fetch C01 into
	nr_titulo_receber_w,
	vl_saldo_tit_receb_w,
	cd_estabelecimento_receb_w,
	cd_tipo_recebimento_receb_w,
	nr_seq_trans_financ_receb_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(a.cd_pessoa_fisica),
			max(a.cd_cgc)
	into STRICT	cd_pessoa_fisica_w,
			cd_cgc_w
	from	pessoa_encontro_contas a
	where	a.nr_sequencia = nr_seq_pessoa_p;
	/*OS 1326415 - Mesma tratativa que faz na baixar_lote_encontro_contas*/

	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then /* Obter o tipo da pessoa*/
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'CO' END
		into STRICT	ie_tipo_pessoa_w
		from	pls_congenere
		where	cd_cgc	= cd_cgc_w
		and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;

		if (ie_tipo_pessoa_w = 'N') then
			select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END
			into STRICT	ie_tipo_pessoa_w
			from	pls_cooperado
			where	cd_cgc	= cd_cgc_w
			and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;

			if (ie_tipo_pessoa_w = 'N') then
				ie_tipo_pessoa_w	:= 'CL';
			end if;
		end if;
	else
		select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END
		into STRICT	ie_tipo_pessoa_w
		from	pls_cooperado
		where	cd_pessoa_fisica	= cd_pessoa_fisica_w
		and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;

		if (ie_tipo_pessoa_w = 'N') then
			ie_tipo_pessoa_w	:= 'CL';
		end if;
	end if;
	if (ie_tipo_pessoa_w IS NOT NULL AND ie_tipo_pessoa_w::text <> '') then
		select	count(1) /* Obter se existe regra*/
		into STRICT	qt_regra_w
		from	regra_receb_enc_contas
		where	ie_tipo_pessoa	= ie_tipo_pessoa_w  LIMIT 1;
	end if;
	if (qt_regra_w <> 0) then
		open C03;
		loop
		fetch C03 into
			cd_tipo_receb_regra_w,
			cd_tipo_baixa_cpa_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
		end loop;
		close C03;
	end if;
	cd_tipo_recebimento_w		:= coalesce(cd_tipo_receb_regra_w,cd_tipo_recebimento_par_w);
	cd_tipo_baixa_w				:= coalesce(cd_tipo_baixa_cpa_regra_w,cd_tipo_baixa_param_w);

	open C02;
	loop
	fetch C02 into
		nr_titulo_pagar_w,
		vl_saldo_tit_pag_w,
		cd_estabelecimento_pag_w,
		ie_tipo_pagamento_pag_w,
		nr_seq_trans_fin_baixa_pag_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		if (coalesce(vl_saldo_tit_receb_w,0) <> 0) and (coalesce(vl_saldo_tit_pag_w,0) <> 0) and (ie_acao_p = 'B') then

			select	max(a.cd_tipo_baixa_padrao),
				max(a.nr_seq_trans_fin_abat)
			into STRICT	cd_tipo_baixa_pag_w,
				nr_seq_trans_abat_pag_w
			from	parametros_contas_pagar a
			where	a.cd_estabelecimento	= cd_estabelecimento_pag_w;

			select	coalesce(nr_seq_trans_fin_baixa_receb_w,max(a.nr_seq_trans_fin_abat))
			into STRICT	nr_seq_trans_fin_receb_w
			from	parametro_contas_receber a
			where	a.cd_estabelecimento	= cd_estabelecimento_receb_w;

			if (coalesce(cd_tipo_recebimento_w::text, '') = '') then
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(197089);
			end if;

			if (coalesce(vl_saldo_tit_receb_w,0) > coalesce(vl_saldo_tit_pag_w,0))then
				vl_saldo_tit_receb_w := (coalesce(vl_saldo_tit_receb_w,0) - coalesce(vl_saldo_tit_pag_w,0));

				if ((nr_seq_trans_financ_baixa_cpa IS NOT NULL AND nr_seq_trans_financ_baixa_cpa::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
					nr_seq_trans_fin_baixa_pag_w := nr_seq_trans_financ_baixa_cpa;
				end if;

				CALL Baixa_titulo_pagar( cd_estabelecimento_pag_w,
							cd_tipo_baixa_w,
							nr_titulo_pagar_w,
							coalesce(vl_saldo_tit_pag_w,0),
							nm_usuario_p,
							coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
							null,
							null,
							dt_baixa_p,
							null,
							null,
							null,
							null,
							nr_seq_lote_p);

				if ((nr_seq_trans_financ_baixa_cre IS NOT NULL AND nr_seq_trans_financ_baixa_cre::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
				      nr_seq_trans_financ_receb_w := nr_seq_trans_financ_baixa_cre;
				end if;

				CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
							cd_tipo_recebimento_w,
							nr_titulo_receber_w,
							nr_seq_trans_financ_receb_w,
							coalesce(vl_saldo_tit_pag_w,0),
							dt_baixa_p,
							nm_usuario_p,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nr_seq_lote_p);

				vl_saldo_tit_pag_w := 0;

				CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
				CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
				CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_baixa_tit_pag_w
				from	titulo_pagar_baixa a
				where	a.nr_titulo		= nr_titulo_pagar_w;

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_liq_rec_w
				from	titulo_receber_liq a
				where	a.nr_titulo	= nr_titulo_receber_w;

				update	titulo_receber_liq
				set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
					nr_tit_pagar	= nr_titulo_pagar_w,
					ds_observacao	= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_receber_w
				and	nr_sequencia	= nr_seq_liq_rec_w;

				update 	titulo_pagar_baixa
				set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
					nr_tit_receber = nr_titulo_receber_w,
					ds_observacao  = substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_pagar_w
				and	nr_sequencia	= nr_seq_baixa_tit_pag_w;


			elsif (vl_saldo_tit_receb_w = vl_saldo_tit_pag_w) then

				if ((nr_seq_trans_financ_baixa_cpa IS NOT NULL AND nr_seq_trans_financ_baixa_cpa::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
				      nr_seq_trans_fin_baixa_pag_w := nr_seq_trans_financ_baixa_cpa;
				end if;

				CALL Baixa_titulo_pagar(	cd_estabelecimento_pag_w,
							cd_tipo_baixa_w,
							nr_titulo_pagar_w,
							vl_saldo_tit_pag_w,
							nm_usuario_p,
							coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
							null,
							null,
							dt_baixa_p,
							null,
							null,
							null,
							null,
							nr_seq_lote_p);

				vl_saldo_tit_pag_w := 0;

				if ((nr_seq_trans_financ_baixa_cre IS NOT NULL AND nr_seq_trans_financ_baixa_cre::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
				      nr_seq_trans_financ_receb_w := nr_seq_trans_financ_baixa_cre;
				end if;

				CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
							cd_tipo_recebimento_w,
							nr_titulo_receber_w,
							nr_seq_trans_financ_receb_w,
							vl_saldo_tit_receb_w,
							dt_baixa_p,
							nm_usuario_p,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nr_seq_lote_p);

				vl_saldo_tit_receb_w := 0;

				CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
				CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
				CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_baixa_tit_pag_w
				from	titulo_pagar_baixa a
				where	a.nr_titulo		= nr_titulo_pagar_w;

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_liq_rec_w
				from	titulo_receber_liq a
				where	a.nr_titulo	= nr_titulo_receber_w;

				update	titulo_receber_liq
				set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
					nr_tit_pagar	= nr_titulo_pagar_w,
					ds_observacao	= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_receber_w
				and	nr_sequencia	= nr_seq_liq_rec_w;

				update 	titulo_pagar_baixa
				set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
					nr_tit_receber = nr_titulo_receber_w,
					ds_observacao	= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_pagar_w
				and	nr_sequencia	= nr_seq_baixa_tit_pag_w;

			else
				vl_saldo_tit_pag_w := coalesce(vl_saldo_tit_pag_w,0) - coalesce(vl_saldo_tit_receb_w,0);

				if ((nr_seq_trans_financ_baixa_cre IS NOT NULL AND nr_seq_trans_financ_baixa_cre::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
				      nr_seq_trans_financ_receb_w := nr_seq_trans_financ_baixa_cre;
				end if;

				CALL Baixa_Titulo_Receber(	cd_estabelecimento_receb_w,
							cd_tipo_recebimento_w,
							nr_titulo_receber_w,
							nr_seq_trans_financ_receb_w,
							vl_saldo_tit_receb_w,
							dt_baixa_p,
							nm_usuario_p,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							nr_seq_lote_p);

                if ((nr_seq_trans_financ_baixa_cpa IS NOT NULL AND nr_seq_trans_financ_baixa_cpa::text <> '') and (coalesce(ie_trans_fin_baixa_w,'N') = 'S')) then
				      nr_seq_trans_fin_baixa_pag_w := nr_seq_trans_financ_baixa_cpa;
				end if;

				CALL Baixa_titulo_pagar(cd_estabelecimento_pag_w,
						cd_tipo_baixa_w,
						nr_titulo_pagar_w,
						vl_saldo_tit_receb_w,
						nm_usuario_p,
						coalesce(nr_seq_trans_fin_baixa_pag_w, nr_seq_trans_abat_pag_w),
						null,
						null,
						dt_baixa_p,
						null,
						null,
						null,
						null,
						nr_seq_lote_p);

				vl_saldo_tit_receb_w := 0;

				CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
				CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
				CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_baixa_tit_pag_w
				from	titulo_pagar_baixa a
				where	a.nr_titulo		= nr_titulo_pagar_w;

				select	max(a.nr_sequencia)
				into STRICT	nr_seq_liq_rec_w
				from	titulo_receber_liq a
				where	a.nr_titulo	= nr_titulo_receber_w;

				update	titulo_receber_liq
				set	nr_seq_baixa_pagar = nr_seq_baixa_tit_pag_w,
					nr_tit_pagar	= nr_titulo_pagar_w,
					ds_observacao	= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_receber_w
				and	nr_sequencia	= nr_seq_liq_rec_w;

				update 	titulo_pagar_baixa
				set	nr_seq_baixa_rec = nr_seq_liq_rec_w,
					nr_tit_receber = nr_titulo_receber_w,
					ds_observacao	= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255)
				where	nr_titulo = nr_titulo_pagar_w
				and	nr_sequencia	= nr_seq_baixa_tit_pag_w;
			end if;
			commit;
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;


if (ie_acao_p = 'E') then
	open C01;
	loop
	fetch C01 into
		nr_titulo_receber_w,
		vl_saldo_tit_receb_w,
		cd_estabelecimento_receb_w,
		cd_tipo_recebimento_receb_w,
		nr_seq_trans_fin_baixa_receb_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	open C02;
	loop
	fetch C02 into
		nr_titulo_pagar_w,
		vl_saldo_tit_pag_w,
		cd_estabelecimento_pag_w,
		ie_tipo_pagamento_pag_w,
		nr_seq_trans_fin_baixa_pag_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	count(*)
		into STRICT	nr_estorno_pag_w
		from	titulo_pagar_baixa a
		where	a.nr_titulo	= nr_titulo_pagar_w
		and	a.nr_tit_receber = nr_titulo_receber_w;


		if (nr_estorno_pag_w > 0) then

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_baixa_tit_pag_w
			from	titulo_pagar_baixa a
			where	a.nr_titulo		= nr_titulo_pagar_w
			and	a.nr_tit_receber = nr_titulo_receber_w;

			CALL estornar_tit_pagar_baixa(nr_titulo_pagar_w,nr_seq_baixa_tit_pag_w,dt_baixa_p,nm_usuario_p,'S');
			CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
			CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
		end if;

		select	count(*)
		into STRICT	nr_estorno_rec_w
		from	titulo_receber_liq
		where	nr_tit_pagar = nr_titulo_pagar_w
		and	nr_titulo	= nr_titulo_receber_w;


		if (nr_estorno_rec_w > 0) then

			select	max(a.nr_sequencia)
			into STRICT	nr_seq_liq_rec_w
			from	titulo_receber_liq a
			where	a.nr_titulo	= nr_titulo_receber_w
			and	a.nr_tit_pagar = nr_titulo_pagar_w;

			CALL estornar_tit_receber_liq(nr_titulo_receber_w,nr_seq_liq_rec_w,dt_baixa_p,nm_usuario_p,'N',null,'P');
			CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
		end if;
		end;
	end loop;
	close C02;
	end;
end loop;
close C01;
end if;


update	lote_encontro_contas
set		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		dt_baixa	= CASE WHEN ie_acao_p='B' THEN  dt_baixa_p  ELSE null END
where	nr_sequencia	= nr_seq_lote_p;


update	pessoa_encontro_contas
set	dt_baixa	= CASE WHEN ie_acao_p='B' THEN  dt_baixa_p  ELSE null END
where	nr_sequencia	= nr_seq_pessoa_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_enc_contas_abatimento ( nr_seq_lote_p bigint, dt_baixa_p timestamp, ie_acao_p text, nr_seq_pessoa_p bigint, nm_usuario_p text) FROM PUBLIC;

