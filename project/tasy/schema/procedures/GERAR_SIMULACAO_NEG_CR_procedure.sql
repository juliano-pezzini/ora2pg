-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_simulacao_neg_cr ( nr_seq_negociacao_p bigint, nm_usuario_p text, ie_forma_pagto_p text, nr_parcelas_p INOUT text, cd_estabelecimento_p bigint, ie_tipo_cartao_p text, nr_seq_forma_pagto_p bigint) AS $body$
DECLARE


nm_usuario_lib_w		varchar(15);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
ie_forma_pagto_w		varchar(5)	:= null;
vl_total_w			double precision;
vl_parcela_w			double precision	:= null;
vl_taxa_w			double precision;
tx_negociacao_w			double precision;
nr_parcelas_regra_w		bigint;
nr_seq_regra_w			bigint;
qt_parcela_w			bigint	:= 0;
nr_seq_regra_anterior_w		bigint;
qt_registro_w			bigint;
nr_seq_regra_resultado_w	bigint;
nr_seq_regra_result_atual_w	bigint;
nr_seq_regra_result_ant_w	bigint;
qt_meses_resultado_w		bigint;
nr_seq_grupo_w			bigint;
nr_seq_grupo_ant_w		bigint;
nr_seq_cobranca_w		bigint;
pr_resultado_w			double precision;
pr_inicial_w			double precision;
pr_final_w			double precision;
pr_taxa_w			double precision;
nr_limite_parcela_w		integer;
nr_parcela_w			integer;
nr_ultima_parcela_lib_w		integer	:= 0;
nr_parcelas_resultado_w		integer	:= null;
dt_liberacao_parcela_w		timestamp;
dt_negociacao_w			timestamp;
dt_liberacao_w			timestamp;
dt_fechamento_w			timestamp;
dt_cancelamento_w		timestamp;
qt_parcela_ww			bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_parcelas
	from	regra_parcela_neg_cr a
	where	vl_total_w between coalesce(a.vl_inicial,0) and coalesce(a.vl_final,9999999999)
	and	dt_negociacao_w between PKG_DATE_UTILS.start_of(a.dt_inicio_vigencia,'dd',0) and coalesce(fim_dia(a.dt_fim_vigencia),dt_negociacao_w)
	and ((a.vl_inicial IS NOT NULL AND a.vl_inicial::text <> '') or (a.vl_final IS NOT NULL AND a.vl_final::text <> ''))
	and (a.nr_seq_grupo_cobr = nr_seq_grupo_w or coalesce(a.nr_seq_grupo_cobr::text, '') = '')
	order by
		coalesce(a.nr_seq_grupo_cobr,0),
		a.nr_parcelas;

C02 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.pr_inicial,
		a.pr_final,
		coalesce(a.qt_meses_resultado,9999)-1
	from	regra_resultado_neg_cr a
	where	dt_negociacao_w between PKG_DATE_UTILS.start_of(a.dt_inicio_vigencia,'dd',0) and coalesce(fim_dia(a.dt_fim_vigencia),dt_negociacao_w)
	order by
		a.qt_parcela;

C03 CURSOR FOR
	SELECT  b.nr_sequencia
	from    cobranca b,
		titulo_rec_negociado a
	where   a.nr_titulo    	 	= b.nr_titulo
	and     a.nr_seq_negociacao 	= nr_seq_negociacao_p;


BEGIN

nr_limite_parcela_w := obter_param_usuario(5514, 18, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, nr_limite_parcela_w);

if (nr_seq_negociacao_p IS NOT NULL AND nr_seq_negociacao_p::text <> '') then
	/* Obter dados */

	select	a.dt_negociacao,
		obter_valores_negociacao_cr(a.nr_sequencia,'VT'),
		a.dt_liberacao,
		a.dt_fechamento,
		a.dt_cancelamento,
		a.nr_seq_regra_parcela,
		a.nr_seq_regra_resultado,
		a.cd_pessoa_fisica,
		a.cd_cgc,
		coalesce(tx_negociacao,0)
	into STRICT	dt_negociacao_w,
		vl_total_w,
		dt_liberacao_w,
		dt_fechamento_w,
		dt_cancelamento_w,
		nr_seq_regra_anterior_w,
		nr_seq_regra_result_ant_w,
		cd_pessoa_fisica_w,
		cd_cgc_w,
		tx_negociacao_w
	from	negociacao_cr a
	where	a.nr_sequencia	= nr_seq_negociacao_p;
	
	/* Consistencias */

	if (dt_liberacao_w IS NOT NULL AND dt_liberacao_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(176449);
	elsif (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(176451);
	elsif (dt_cancelamento_w IS NOT NULL AND dt_cancelamento_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(176454);
	end if;
	
	CALL consistir_negociacao_cr(nr_seq_negociacao_p,cd_estabelecimento_p,dt_negociacao_w,nm_usuario_p);
	
	open C03;
	loop
	fetch C03 into
		nr_seq_cobranca_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin
		nr_seq_grupo_w		:= obter_grupo_cobr_cobranca(nr_seq_cobranca_w);
		if (nr_seq_grupo_ant_w <> nr_seq_grupo_w) then
			nr_seq_grupo_w := null;
			exit;
		end if;
		
		nr_seq_grupo_ant_w 	:= nr_seq_grupo_w;
		end;
	end loop;
	close C03;
	
	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w,
		nr_parcelas_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		null;
		end;
	end loop;
	close C01;
	
	open C02;
	loop
	fetch C02 into
		nr_seq_regra_resultado_w,
		pr_inicial_w,
		pr_final_w,
		qt_meses_resultado_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin	
		select	avg(pr_result)
		into STRICT	pr_resultado_w
		from (
			SELECT	dividir_sem_round(sum(coalesce(CASE WHEN ie_tipo_valor=1 THEN 0  ELSE vl_resultado END ,0)),sum(coalesce(CASE WHEN ie_tipo_valor=1 THEN vl_resultado  ELSE 0 END ,0))) * 100 pr_result
			from	pls_resultado b,
				pls_contrato_pagador a
			where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
			and	a.nr_sequencia		= b.nr_seq_pagador
			and	(cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '')
			and	b.dt_mes_referencia >= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0),qt_meses_resultado_w * -1, 0)
			group by a.nr_sequencia
			
union all

			SELECT	dividir_sem_round(sum(coalesce(CASE WHEN ie_tipo_valor=1 THEN 0  ELSE vl_resultado END ,0)),sum(coalesce(CASE WHEN ie_tipo_valor=1 THEN vl_resultado  ELSE 0 END ,0))) * 100 pr_result
			from	pls_resultado b,
				pls_contrato_pagador a
			where	a.cd_cgc	= cd_cgc_w
			and	a.nr_sequencia		= b.nr_seq_pagador
			and	(cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '')
			and	b.dt_mes_referencia >= PKG_DATE_UTILS.ADD_MONTH(PKG_DATE_UTILS.start_of(clock_timestamp(),'month',0),qt_meses_resultado_w * -1, 0)
			group by a.nr_sequencia) alias19;
		
		if (pr_resultado_w between
			coalesce(pr_inicial_w,-9999999999) and
			coalesce(pr_final_w,9999999999)) then
			select	max(qt_parcela),
				max(nr_sequencia)
			into STRICT	nr_parcelas_resultado_w,
				nr_seq_regra_result_atual_w
			from	regra_resultado_neg_cr
			where	nr_sequencia	= nr_seq_regra_resultado_w;
			
			exit;
		end if;
		end;
	end loop;
	close C02;
	
	/* Parcelas do resultado sao mais restritivas */

	if (nr_parcelas_resultado_w < nr_parcelas_regra_w) or (coalesce(nr_parcelas_regra_w::text, '') = '') then
		nr_parcelas_regra_w	:= nr_parcelas_resultado_w;
	end if;
	
	/* Limpar e gerar parcelas */

	nr_parcela_w	:= 1;
	
	/* Se a regra anterior e igual a nova regra, nao deve limpar as parcelas liberadas manualmente */
	if (nr_seq_regra_anterior_w = nr_seq_regra_w) and (coalesce(nr_seq_regra_result_ant_w,0) = coalesce(nr_seq_regra_result_atual_w,0)) then
		select	max(a.nr_parcela)
		into STRICT	nr_ultima_parcela_lib_w
		from	negociacao_cr_parcela a
		where	a.nr_seq_negociacao	= nr_seq_negociacao_p
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');
		
		/* Se o numero de parcelas solicitadas e inferior ao liberado */

		if (nr_parcelas_p > coalesce(nr_ultima_parcela_lib_w,nr_limite_parcela_w)) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(176456);
		end if;
		
		update	negociacao_cr_parcela
		set	ie_forma_pagto	 = NULL,
			vl_parcela	 = NULL,
			dt_vencimento	 = NULL,
			pr_parcela	 = NULL,
			nm_usuario	= nm_usuario_p,
			dt_atualizacao	= clock_timestamp()
		where	nr_seq_negociacao	= nr_seq_negociacao_p;
	else
		delete from negociacao_cr_parcela
		where	nr_seq_negociacao	= nr_seq_negociacao_p;
	end if;
	
	if (coalesce(nr_ultima_parcela_lib_w::text, '') = '') then
		nr_ultima_parcela_lib_w	:= nr_parcelas_regra_w;
	end if;
	
	while(nr_parcela_w	<= coalesce(nr_limite_parcela_w,12) ) loop -- fiz o NVL com 12 pois esse era o numero limite desde que a rotina foi criada
		dt_liberacao_parcela_w	:= null;
		nm_usuario_lib_w	:= null;
		
		if (nr_parcela_w <= nr_parcelas_regra_w) or (coalesce(nr_parcelas_regra_w::text, '') = '') then
			dt_liberacao_parcela_w		:= clock_timestamp();
			nm_usuario_lib_w		:= nm_usuario_p;
			qt_parcela_w			:= qt_parcela_w + 1;
		end if;
		
		/* Se esta dentro das parcelas solicitadas  deve jogar valor zero pra tratar na recalcular_valores*/

		if (nr_parcela_w <= coalesce(nr_parcelas_p,nr_parcelas_regra_w)) then
			vl_parcela_w		:= 0;
			ie_forma_pagto_w	:= ie_forma_pagto_p;
		else
			vl_parcela_w		:= null;
			ie_forma_pagto_w	:= null;
		end if;
		
		select	count(*)
		into STRICT	qt_registro_w
		from	negociacao_cr_parcela a
		where	a.nr_seq_negociacao	= nr_seq_negociacao_p
		and	a.nr_parcela		= nr_parcela_w;
		
		/*if	(nr_parcela_w <= nr_parcelas_regra_w) or
			(nr_parcela_w > nr_ultima_parcela_lib_w) then*/
		if (qt_registro_w = 0) then
			insert into negociacao_cr_parcela(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				nr_seq_negociacao,
				nr_parcela,
				dt_liberacao,
				nm_usuario_lib,
				ie_tipo_liberacao,
				vl_parcela,
				ie_forma_pagto,
				ie_tipo_cartao,
				nr_seq_forma_pagto)
			values (nextval('negociacao_cr_parcela_seq'),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nr_seq_negociacao_p,
				nr_parcela_w,
				dt_liberacao_parcela_w,
				nm_usuario_lib_w,
				'A',
				vl_parcela_w,
				ie_forma_pagto_w,
				ie_tipo_cartao_p,
				nr_seq_forma_pagto_p);
		else
			update	negociacao_cr_parcela
			set	vl_parcela	= vl_parcela_w,
				ie_forma_pagto	= ie_forma_pagto_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp(),
				ie_tipo_cartao	= ie_tipo_cartao_p
			where	nr_seq_negociacao	= nr_seq_negociacao_p
			and	nr_parcela		= nr_parcela_w;
		end if;
		
		nr_parcela_w	:= nr_parcela_w + 1;
	end loop;
	
	if (nr_seq_regra_result_atual_w IS NOT NULL AND nr_seq_regra_result_atual_w::text <> '') then
		select	coalesce(max(tx_juros),0)
		into STRICT	pr_taxa_w
		from	regra_resultado_neg_cr
		where	nr_sequencia	= nr_seq_regra_result_atual_w;
		
		if (pr_taxa_w > 0) then
			vl_taxa_w	:=	(vl_total_w - tx_negociacao_w) * (pr_taxa_w / 100);
		else
			vl_taxa_w	:= vl_taxa_w;
		end if;
		
		update	negociacao_cr
		set	tx_negociacao	= coalesce(vl_taxa_w,0)
		where	nr_sequencia	= nr_seq_negociacao_p;
	end if;
	
	CALL recalcular_valores_neg_cr(nr_seq_negociacao_p,null,null,nm_usuario_p);
	
	update	negociacao_cr
	set	nr_seq_regra_parcela	= nr_seq_regra_w,
		nr_seq_regra_resultado	= nr_seq_regra_result_atual_w,
		ie_status		= 'ES',
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp(),
		pr_resultado		= coalesce(pr_resultado_w,0)
	where	nr_sequencia		= nr_seq_negociacao_p;

	select	count(1)
	into STRICT	qt_parcela_ww
	from	negociacao_cr_parcela
	where	nr_seq_negociacao = nr_seq_negociacao_p
	and	vl_parcela > 0;
	
	pls_fiscal_dados_dmed_pck.gerar_itens_mens_negociacao(nr_seq_negociacao_p, 'N', nm_usuario_p);
	
	pls_gerar_itens_mens_negoc(nr_seq_negociacao_p, qt_parcela_ww, nm_usuario_p);
	
	nr_parcelas_p	:= qt_parcela_w;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_simulacao_neg_cr ( nr_seq_negociacao_p bigint, nm_usuario_p text, ie_forma_pagto_p text, nr_parcelas_p INOUT text, cd_estabelecimento_p bigint, ie_tipo_cartao_p text, nr_seq_forma_pagto_p bigint) FROM PUBLIC;

