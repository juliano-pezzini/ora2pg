-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE concil_extrato_redecard_regra (nr_seq_extrato_arq_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*	ie_opcao_p

C	Conciliar
D	Desconciliar

*/
nr_seq_parcela_w		bigint;
nr_seq_grupo_w			bigint;
vl_parcela_saldo_w		double precision;
nr_seq_extrato_parcela_w	bigint;
nr_seq_extrato_parcela_fin_w	bigint;
ie_concil_w			varchar(1);
nr_seq_extrato_w		bigint;
ie_tipo_arquivo_w		varchar(5);
nr_seq_extrato_movto_fin_w	bigint;
nr_resumo_w			varchar(255);
nr_extrato_cr_movto_cred_w	bigint;
ie_concil_fin_w			varchar(255);
nr_seq_movto_concil_w		bigint;
nr_seq_ext_movto_w		bigint;
vl_conciliado_w			double precision;
vl_conciliado_fin_w		double precision;
vl_saldo_concil_fin_w		double precision;
vl_liquido_w			double precision;
vl_conciliar_aut_w		double precision;
qt_movto_cred_concil_w		bigint	:= 0;
qt_movto_fin_concil_w		bigint	:= 0;
nr_parcela_w			bigint;
ie_parcela_superior_w		varchar(1);
cd_estabelecimento_w		smallint;
vl_saldo_concil_final_w		double precision;
vl_min_indevido_w		double precision;
vl_max_indevido_w		double precision;
ie_pagto_indevido_w		varchar(1);
vl_ajuste_w			double precision;
vl_saldo_concil_cred_final_w	double precision;
ie_pagamento_indevido_w		varchar(1);
ie_cv_repetido_w		varchar(1);
ie_parcela_w			varchar(1);
ds_lista_parcela_w		varchar(255);

c01 CURSOR FOR
SELECT	nr_sequencia,
	CASE WHEN coalesce(nr_seq_extrato_parcela::text, '') = '' THEN 'N'  ELSE 'S' END ,
	CASE WHEN vl_saldo_concil_fin=0 THEN 'S'  ELSE 'N' END ,
	vl_saldo_concil_fin,
	vl_liquido,
	nr_resumo,
	nr_parcela,
	vl_saldo_concil_cred
from	extrato_cartao_cr_movto
where	coalesce(ie_pagto_indevido,'N') = 'N'
and	nr_seq_extrato_arq	= nr_seq_extrato_arq_p;

C02 CURSOR FOR
SELECT	distinct
	coalesce(a.nr_sequencia,0),
	a.nr_seq_extrato_parcela
from	movto_cartao_cr e,
	movto_cartao_cr_parcela d,
	extrato_cartao_cr_movto a,
	extrato_cartao_cr_arq b,
	extrato_cartao_cr c
where	coalesce(e.dt_cancelamento::text, '') = ''
and	d.nr_seq_movto		= e.nr_sequencia
and	a.nr_seq_extrato_arq	= b.nr_sequencia
and	b.nr_seq_extrato	= c.nr_sequencia
and	c.nr_seq_grupo      	= nr_seq_grupo_w
and	a.nr_resumo        	= nr_resumo_w
and     b.ie_tipo_arquivo    	= 'C'
and	coalesce(a.vl_saldo_concil_cred,0)	> 0 /*OS 363115 */
and	(a.nr_seq_extrato_parcela IS NOT NULL AND a.nr_seq_extrato_parcela::text <> '')
and	a.nr_seq_extrato_parcela = d.nr_seq_extrato_parcela
and ((obter_numero_parcela_cartao(d.nr_seq_movto,d.nr_sequencia))::numeric  = nr_parcela_w or coalesce(nr_parcela_w,0) = 0)
order by	coalesce(a.nr_sequencia,0);

C03 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_ext_movto,
	vl_conciliado
from	ext_cartao_cr_movto_concil
where	nr_seq_extrato_parcela = nr_seq_extrato_parcela_w
and	nr_seq_ext_movto <> nr_seq_extrato_movto_fin_w
order by nr_sequencia;

C04 CURSOR FOR
SELECT	nr_seq_extrato_parcela,
	vl_conciliado
from	ext_cartao_cr_movto_concil
where	nr_seq_ext_movto = nr_seq_extrato_movto_fin_w;

C05 CURSOR FOR
SELECT	a.nr_sequencia,
	CASE WHEN ie_tipo_arquivo_w='F' THEN a.vl_liquido  ELSE a.vl_parcela END
from	movto_cartao_cr_parcela a,
	movto_cartao_cr b,
	bandeira_cartao_cr c
where	substr(obter_se_contido(a.nr_sequencia,ds_lista_parcela_w),1,1) = 'S'
and	a.vl_saldo_liquido		<> 0
and	coalesce(a.nr_seq_extrato_parcela::text, '') = ''
and	b.nr_sequencia			= a.nr_seq_movto
and	coalesce(b.dt_cancelamento::text, '') = ''
and	c.nr_sequencia			= b.nr_seq_bandeira
and	c.nr_seq_grupo			= nr_seq_grupo_w;

/* pagamentos indevidos */

c06 CURSOR FOR
SELECT	a.nr_sequencia
from	extrato_cartao_cr_movto a
where	not exists (select	1
	from	extrato_cartao_cr_movto x
	where	x.nr_seq_origem	= a.nr_sequencia)
and	coalesce(a.nr_seq_origem::text, '') = ''
and	coalesce(a.ie_pagto_indevido,'N') = 'S'
and	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p
and	ie_opcao_p		= 'D';


BEGIN

select	max(a.nr_seq_extrato),
	max(a.ie_tipo_arquivo),
	max(b.nr_seq_grupo),
	max(b.cd_estabelecimento)
into STRICT	nr_seq_extrato_w,
	ie_tipo_arquivo_w,
	nr_seq_grupo_w,
	cd_estabelecimento_w
from	extrato_cartao_cr b,
	extrato_cartao_cr_arq a
where	a.nr_sequencia		= nr_seq_extrato_arq_p
and	a.nr_seq_extrato	= b.nr_sequencia;

select	max(a.vl_min_indevido),
	max(a.vl_max_indevido)
into STRICT	vl_min_indevido_w,
	vl_max_indevido_w
from	bandeira_cartao_cr_regra a
where	a.nr_seq_grupo	= nr_seq_grupo_w
and	coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
and	clock_timestamp()	between coalesce(a.dt_inicio_vigencia,clock_timestamp()) and coalesce(a.dt_fim_vigencia,clock_timestamp());

ie_parcela_superior_w := obter_param_usuario(3020, 40, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_parcela_superior_w);
ie_pagto_indevido_w := obter_param_usuario(3020, 44, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_pagto_indevido_w);
ie_cv_repetido_w := obter_param_usuario(3020, 46, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_cv_repetido_w);

open c01;
loop
fetch c01 into
	nr_seq_extrato_movto_fin_w,
	ie_concil_w,
	ie_concil_fin_w,
	vl_saldo_concil_fin_w,
	vl_liquido_w,
	nr_resumo_w,
	nr_parcela_w,
	vl_saldo_concil_cred_final_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (ie_tipo_arquivo_w = 'F') then	/* conciliar o arquivo financeiro com o arquivo de crédito */
		if (ie_opcao_p = 'C') and (ie_concil_fin_w = 'N') then	/* conciliar os movimentos não conciliados */
			select	count(*)
			into STRICT	qt_movto_cred_concil_w
			from	movto_cartao_cr e,
				movto_cartao_cr_parcela d,
				extrato_cartao_cr_movto a,
				extrato_cartao_cr_arq b,
				extrato_cartao_cr c
			where	coalesce(e.dt_cancelamento::text, '') = ''
			and	d.nr_seq_movto		= e.nr_sequencia
			and	a.nr_seq_extrato_arq	= b.nr_sequencia
			and	b.nr_seq_extrato	= c.nr_sequencia
			and	c.nr_seq_grupo      	= nr_seq_grupo_w
			and	a.nr_resumo        	= nr_resumo_w
			and     b.ie_tipo_arquivo    	= 'C'
			and	coalesce(a.vl_saldo_concil_cred,0)	> 0
			and	(a.nr_seq_extrato_parcela IS NOT NULL AND a.nr_seq_extrato_parcela::text <> '')
			and	a.nr_seq_extrato_parcela = d.nr_seq_extrato_parcela
			and ((obter_numero_parcela_cartao(d.nr_seq_movto,d.nr_sequencia))::numeric  = nr_parcela_w or coalesce(nr_parcela_w,0) = 0);

			/* se existirem movimentos de crédito já conciliados, concilia com os movimentos de crédito,
			senão realiza o mesmo processo da conciliação do crédito e débito, buscando as parcelas pelo nr_resumo */
			if (qt_movto_cred_concil_w > 0) then

				select	nextval('extrato_cartao_cr_parcela_seq')
				into STRICT	nr_seq_extrato_parcela_w
				;

				insert	into	extrato_cartao_cr_parcela(nr_sequencia,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					dt_atualizacao,
					nm_usuario,
					nr_seq_extrato_arq,
					nr_seq_extrato)
				values (nr_seq_extrato_parcela_w,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_extrato_arq_p,
					nr_seq_extrato_w);

				vl_parcela_saldo_w := vl_saldo_concil_fin_w;

				open C02;
				loop
				fetch C02 into
					nr_extrato_cr_movto_cred_w,
					nr_seq_extrato_parcela_fin_w;
				EXIT WHEN NOT FOUND or vl_parcela_saldo_w <= 0;  /* apply on C02 */

					select	coalesce(sum(vl_saldo_liquido),0)
					into STRICT	vl_conciliar_aut_w
					from	movto_cartao_cr_parcela a
					where	a.nr_seq_extrato_parcela	= nr_seq_extrato_parcela_fin_w
					and ((obter_numero_parcela_cartao(a.nr_seq_movto,a.nr_sequencia))::numeric  = nr_parcela_w or coalesce(nr_parcela_w,0) = 0);

					vl_ajuste_w	:= 0;

					if	((vl_parcela_saldo_w - vl_conciliar_aut_w)	>= coalesce(vl_min_indevido_w,0)) and
						((vl_parcela_saldo_w - vl_conciliar_aut_w)	<= coalesce(vl_max_indevido_w,0)) then

						vl_ajuste_w		:= vl_parcela_saldo_w - vl_conciliar_aut_w;
						vl_conciliar_aut_w	:= vl_parcela_saldo_w;

					end if;

					if (vl_conciliar_aut_w > 0) and
						((vl_conciliar_aut_w <= vl_parcela_saldo_w) or (coalesce(ie_parcela_superior_w,'N') = 'S')) then

						insert	into ext_cartao_cr_movto_concil(
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec,
							nr_seq_ext_movto,
							nr_seq_extrato_parcela,
							nr_sequencia,
							vl_conciliado)
						values (	clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							nr_extrato_cr_movto_cred_w,
							nr_seq_extrato_parcela_w,
							nextval('ext_cartao_cr_movto_concil_seq'),
							vl_conciliar_aut_w);

						update	extrato_cartao_cr_movto
						set	vl_saldo_concil_cred	= vl_saldo_concil_cred - vl_conciliar_aut_w,
							vl_aconciliar 		= vl_aconciliar - vl_conciliar_aut_w
						where	nr_sequencia		= nr_extrato_cr_movto_cred_w;

						insert	into ext_cartao_cr_movto_concil(
							dt_atualizacao,
							dt_atualizacao_nrec,
							nm_usuario,
							nm_usuario_nrec,
							nr_seq_ext_movto,
							nr_seq_extrato_parcela,
							nr_sequencia,
							vl_conciliado)
						values (	clock_timestamp(),
							clock_timestamp(),
							nm_usuario_p,
							nm_usuario_p,
							nr_seq_extrato_movto_fin_w,
							nr_seq_extrato_parcela_w,
							nextval('ext_cartao_cr_movto_concil_seq'),
							vl_conciliar_aut_w);

						vl_parcela_saldo_w		:= vl_parcela_saldo_w - vl_conciliar_aut_w;

						update	extrato_cartao_cr_movto
						set	vl_saldo_concil_fin 	= vl_parcela_saldo_w,
							vl_ajuste		= vl_ajuste_w
						where	nr_sequencia		= nr_seq_extrato_movto_fin_w;

					end if;

				end loop;
				close C02;

				select	max(a.vl_saldo_concil_fin)
				into STRICT	vl_saldo_concil_fin_w
				from	extrato_cartao_cr_movto a
				where	a.nr_sequencia	= nr_seq_extrato_movto_fin_w;

			end if;

		elsif (ie_opcao_p = 'D') and ((ie_concil_fin_w = 'S') or (vl_saldo_concil_fin_w <> vl_liquido_w)) then -- afstringari 02/08/2010
			/* verificar se a conciliação foi pelo arquivo de crédito */

			select	count(*)
			into STRICT	qt_movto_fin_concil_w
			from	ext_cartao_cr_movto_concil
			where	nr_seq_ext_movto = nr_seq_extrato_movto_fin_w;

			if (qt_movto_fin_concil_w > 0) then

				open C04;
				loop
				fetch C04 into
					nr_seq_extrato_parcela_w,
					vl_conciliado_fin_w;
				EXIT WHEN NOT FOUND; /* apply on C04 */

					/* desconciliar movto de credito */

					open C03;
					loop
					fetch C03 into
						nr_seq_movto_concil_w,
						nr_seq_ext_movto_w,
						vl_conciliado_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */

						update	extrato_cartao_cr_movto
						set	vl_aconciliar		= vl_aconciliar + vl_conciliado_w,
							vl_saldo_concil_cred	= vl_saldo_concil_cred + vl_conciliado_w,
							vl_saldo_concil_fin     = 0
						where	nr_sequencia		= nr_seq_ext_movto_w;

						delete	from ext_cartao_cr_movto_concil
						where	nr_sequencia = nr_seq_movto_concil_w;

					end loop;
					close C03;

					delete	from ext_cartao_cr_movto_concil
					where	nr_sequencia = nr_seq_extrato_parcela_w;

					delete	from extrato_cartao_cr_parcela
					where	nr_sequencia = nr_seq_extrato_parcela_w;

					update	extrato_cartao_cr_movto
					set	vl_aconciliar		= 0,
						vl_saldo_concil_cred	= 0,
						vl_saldo_concil_fin     = vl_saldo_concil_fin + vl_conciliado_fin_w,
						ie_pagto_indevido	= 'N',
						vl_ajuste		= 0
					where	nr_sequencia		= nr_seq_extrato_movto_fin_w;

				end loop;
				close C04;

				update	movto_cartao_cr_parcela
				set	nr_seq_extrato_parcela	 = NULL
				where	nr_seq_extrato_parcela in (SELECT	x.nr_sequencia
					from	extrato_cartao_cr_parcela x
					where	x.nr_seq_extrato_arq	= nr_seq_extrato_arq_p
					and	not exists (select	1
						from	ext_cartao_cr_movto_concil y
						where	y.nr_seq_extrato_parcela	= x.nr_sequencia));

				update	extrato_cartao_cr_movto
				set	nr_seq_extrato_parcela	 = NULL,
					vl_aconciliar		= 0,
					vl_saldo_concil_cred	= 0,
					vl_saldo_concil_fin     = vl_liquido
				where	nr_seq_extrato_parcela	in (SELECT	a.nr_sequencia
					from	extrato_cartao_cr_parcela a
					where	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p
					and	not exists (select	1
						from	ext_cartao_cr_movto_concil x
						where	x.nr_seq_extrato_parcela	= a.nr_sequencia));

				delete	from extrato_cartao_cr_parcela a
				where	a.nr_seq_extrato_arq	= nr_seq_extrato_arq_p
				and	not exists (SELECT	1
					from	ext_cartao_cr_movto_concil x
					where	x.nr_seq_extrato_parcela	= a.nr_sequencia);

			end if;

		elsif (ie_opcao_p = 'D') and (ie_concil_fin_w = 'N') then -- afstringari 02/08/2010
			update	extrato_cartao_cr_movto
			set	ie_pagto_indevido	= 'N'
			where	nr_sequencia		= nr_seq_extrato_movto_fin_w;

		end if;

	end if;

	if (ie_opcao_p = 'C') and	/* arquivo de crédito e débito, e conciliação do arquivo financeiro direto com os movtos do Tasy */
		(ie_concil_w = 'N') and
		((coalesce(qt_movto_cred_concil_w,0) = 0) or (coalesce(vl_saldo_concil_fin_w,0) > 0)) then

		SELECT * FROM obter_parcela_regra_cartao(	nr_seq_extrato_movto_fin_w, null, ie_pagto_indevido_w, ie_cv_repetido_w, nm_usuario_p, ie_parcela_w, vl_min_indevido_w, vl_max_indevido_w, ds_lista_parcela_w) INTO STRICT ie_parcela_w, vl_min_indevido_w, vl_max_indevido_w, ds_lista_parcela_w;

		if (coalesce(ie_parcela_w,'N')	= 'S') then

			select	nextval('extrato_cartao_cr_parcela_seq')
			into STRICT	nr_seq_extrato_parcela_w
			;

			insert	into extrato_cartao_cr_parcela(nr_sequencia,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				dt_atualizacao,
				nm_usuario,
				nr_seq_extrato_arq,
				nr_seq_extrato)
			values (nr_seq_extrato_parcela_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_extrato_arq_p,
				nr_seq_extrato_w);

			open C05;
			loop
			fetch C05 into
				nr_seq_parcela_w,
				vl_parcela_saldo_w;
			EXIT WHEN NOT FOUND; /* apply on C05 */

				/* necessário executar esse select aqui porque esses valores são atualizados dentro dos cursores */

				select	max(a.vl_saldo_concil_fin)
				into STRICT	vl_saldo_concil_final_w
				from	extrato_cartao_cr_movto a
				where	a.nr_sequencia	= nr_seq_extrato_movto_fin_w;

				if (ie_tipo_arquivo_w	= 'F') then
					vl_saldo_concil_final_w		:= coalesce(vl_saldo_concil_final_w,0) - coalesce(vl_parcela_saldo_w,0);
					vl_saldo_concil_cred_final_w	:= null;
				else
					vl_saldo_concil_cred_final_w	:= coalesce(vl_saldo_concil_cred_final_w,0) - coalesce(vl_parcela_saldo_w,0);
					vl_saldo_concil_final_w		:= null;
				end if;

				ie_pagamento_indevido_w	:= null;
				vl_ajuste_w		:= 0;

				if (coalesce(coalesce(vl_saldo_concil_final_w,vl_saldo_concil_cred_final_w),0)	>= coalesce(vl_min_indevido_w,0)) and (coalesce(coalesce(vl_saldo_concil_final_w,vl_saldo_concil_cred_final_w),0)	<= coalesce(vl_max_indevido_w,0)) then

					vl_ajuste_w			:= coalesce(vl_saldo_concil_final_w,vl_saldo_concil_cred_final_w);
					vl_saldo_concil_final_w		:= 0;
					ie_pagamento_indevido_w		:= 'N';

				end if;

				update	extrato_cartao_cr_movto
				set	nr_seq_extrato_parcela	= nr_seq_extrato_parcela_w,
					vl_saldo_concil_fin 	= coalesce(vl_saldo_concil_final_w,vl_saldo_concil_fin),
					ie_pagto_indevido	= coalesce(ie_pagamento_indevido_w,ie_pagto_indevido),
					vl_ajuste		= vl_ajuste_w
				where	nr_sequencia		= nr_seq_extrato_movto_fin_w;

				update	movto_cartao_cr_parcela
				set	nr_seq_extrato_parcela	= nr_seq_extrato_parcela_w
				where	nr_sequencia		= nr_seq_parcela_w;

			end loop;
			close C05;

		end if;

	/* Desconciliar tudo */

	elsif (ie_opcao_p = 'D') and (ie_concil_w = 'S') and (coalesce(qt_movto_fin_concil_w,0) = 0) then

		select	max(nr_seq_extrato_parcela)
		into STRICT	nr_seq_extrato_parcela_w
		from	extrato_cartao_cr_movto
		where	nr_sequencia	= nr_seq_extrato_movto_fin_w;

		if (nr_seq_extrato_parcela_w IS NOT NULL AND nr_seq_extrato_parcela_w::text <> '') then

			update	movto_cartao_cr_parcela
			set	nr_seq_extrato_parcela	 = NULL
			where	nr_seq_extrato_parcela	= nr_seq_extrato_parcela_w;

			update	extrato_cartao_cr_movto
			set	nr_seq_extrato_parcela	 = NULL,
				vl_saldo_concil_fin	= vl_parcela,
				vl_ajuste		= 0
			where	nr_seq_extrato_parcela	= nr_seq_extrato_parcela_w;

			delete	from extrato_cartao_cr_parcela
			where	nr_sequencia	= nr_seq_extrato_parcela_w;

		end if;
	end if;

end loop;
close c01;

open	c06;
loop
fetch	c06 into
	nr_seq_extrato_movto_fin_w;
EXIT WHEN NOT FOUND; /* apply on c06 */

	update	extrato_cartao_cr_movto
	set	ie_pagto_indevido	= 'N'
	where	nr_sequencia		= nr_seq_extrato_movto_fin_w;

end	loop;
close	c06;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE concil_extrato_redecard_regra (nr_seq_extrato_arq_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

