-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_encerrar_exercicio_ifrs ( cd_estabelecimento_p bigint, nr_seq_mes_ref_p bigint, cd_historico_p bigint, nr_seq_conta_result_p bigint, nm_usuario_p text, dt_encerramento_p timestamp) AS $body$
DECLARE


cd_centro_custo_w			centro_custo.cd_centro_custo%type;
cd_classif_debito_w			ctb_plano_conta_ifrs.cd_classificacao%type;
cd_classif_credito_w			ctb_plano_conta_ifrs.cd_classificacao%type;
cd_empresa_w				ctb_sit_especial_empresa.cd_empresa%type;
ie_debito_credito_w			ctb_grupo_conta.ie_debito_credito%type;
ie_debito_credito_w_aux			ctb_grupo_conta.ie_debito_credito%type;
nr_seq_conta_ifrs_w			conta_contabil_ifrs.nr_seq_conta_ifrs%type;
nr_seq_conta_ifrs_ww			conta_contabil_ifrs.cd_conta_contabil%type;
nr_seq_conta_debito_w			conta_contabil_ifrs.cd_conta_contabil%type;
nr_seq_conta_credito_w			conta_contabil_ifrs.cd_conta_contabil%type;
nr_seq_mes_ant_w			ctb_mes_ref.nr_sequencia%type;
nr_seq_movimento_w			ctb_movto_ifrs.nr_sequencia%type;
nr_seq_agrupamento_w			ctb_movto_ifrs.nr_seq_agrupamento%type;
nr_seq_centro_custo_w			ctb_movto_ifrs_cc.nr_sequencia%type;
vl_saldo_ini_w				ctb_movto_ifrs.vl_movimento%type;
vl_saldo_fin_w				ctb_movto_ifrs.vl_movimento%type;
vl_saldo_w				ctb_saldo_ifrs.vl_saldo%type;
nr_lote_contabil_w			lote_contabil.nr_lote_contabil%type;
nr_lote_contabil_existe_w		lote_contabil.nr_lote_contabil%type;
cd_tipo_lote_w				constant tipo_lote_contabil.cd_tipo_lote_contabil%type := 62;
dt_atual_w				constant timestamp := clock_timestamp();
dt_movimento_w				timestamp;
dt_abertura_w				timestamp;
dt_fechamento_w				timestamp;
dt_referencia_w				timestamp;
dt_inicial_w				timestamp;
ds_erro_w				varchar(255);
qt_mes_fim_exerc_w			smallint;

c01 CURSOR FOR
	SELECT	a.nr_seq_conta_ifrs,
		a.cd_centro_custo,
		c.ie_debito_credito,
		sum(a.vl_saldo) vl_saldo
	from	ctb_saldo_ifrs a,
		conta_contabil b,
		ctb_grupo_conta c,
		conta_contabil_ifrs d
	where	a.nr_seq_mes_ref	= nr_seq_mes_ref_p
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.vl_saldo		<> 0
	and	d.nr_seq_conta_ifrs 	= a.nr_seq_conta_ifrs
	and	d.cd_conta_contabil 	= b.cd_conta_contabil
	and	obter_se_periodo_vigente(d.dt_inicio_vigencia, d.dt_fim_vigencia, dt_referencia_w) = 'S'
	and	coalesce(d.ie_situacao, 'I')	= 'A'
	and	b.cd_grupo 		= c.cd_grupo
	and	coalesce(b.ie_tipo, 'A')	= 'A'
	and	c.ie_tipo in ('R','C','D')
	group by a.nr_seq_conta_ifrs, c.ie_debito_credito, a.cd_centro_custo
	order by a.nr_seq_conta_ifrs, c.ie_debito_credito;

c02 CURSOR FOR
	SELECT  nextval('ctb_movto_ifrs_seq') nr_seq_movto,
		w.vl_movimento vl_saldo,
		w.nr_seq_conta_ifrs,
		w.cd_conta_contabil,
		ctb_obter_situacao_saldo(w.cd_conta_contabil, w.vl_movimento) ie_debito_credito,
		w.cd_centro_custo
	from (
		SELECT	sum(z.vl_movimento) vl_movimento,
			z.nr_seq_conta_ifrs,
			z.cd_conta_contabil,
			z.cd_centro_custo
		from (
			select	sum(x.vl_movimento) vl_movimento, /* SEM Centro de custo */
				to_char(x.cd_conta_contabil) cd_conta_contabil,
				to_char(x.nr_seq_conta_ifrs) nr_seq_conta_ifrs,
				to_char(x.ie_debito_credito) ie_debito_credito,
				(x.cd_centro_custo)::numeric  cd_centro_custo
			from (
				select	CASE WHEN c.ie_debito_credito='D' THEN a.vl_movimento  ELSE -a.vl_movimento END  vl_movimento, /* Movimento de DEBITO SEM centro de custo */
					a.nr_seq_conta_debito nr_seq_conta_ifrs,
					f.cd_conta_contabil,
					c.ie_debito_credito,
					null cd_centro_custo
				from	ctb_grupo_conta c,
					conta_contabil b,
					ctb_movto_ifrs a,
					lote_contabil d,
					estabelecimento e,
					conta_contabil_ifrs f
				where	a.nr_seq_conta_debito		= f.nr_seq_conta_ifrs
				and	f.cd_conta_contabil		= b.cd_conta_contabil
				and	obter_se_periodo_vigente(f.dt_inicio_vigencia, f.dt_fim_vigencia, dt_referencia_w) = 'S'
				and	coalesce(f.ie_situacao, 'I')		= 'A'
				and	b.cd_grupo			= c.cd_grupo
				and	a.nr_lote_contabil		= d.nr_lote_contabil
				and	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) = e.cd_estabelecimento
				and	a.dt_movimento between dt_inicial_w and dt_encerramento_p
				and	obter_empresa_estab(coalesce(a.cd_estabelecimento, d.cd_estabelecimento)) = cd_empresa_w
				and	e.cd_estabelecimento		= coalesce(cd_estabelecimento_p,e.cd_estabelecimento)
				and	coalesce(b.ie_centro_custo,'N') 	= 'N'
				and	c.ie_tipo in ('R','C','D')
				and	coalesce(b.ie_tipo,'A')		= 'A'
				
union all

				select	CASE WHEN c.ie_debito_credito='C' THEN a.vl_movimento  ELSE -a.vl_movimento END  vl_movimento, /* Movimento de CREDITO SEM centro de custo */
					a.nr_seq_conta_credito nr_seq_conta_ifrs,
					f.cd_conta_contabil,
					c.ie_debito_credito,
					null cd_centro_custo
				from	ctb_movto_ifrs a,
					conta_contabil b,
					ctb_grupo_conta c,
					lote_contabil d,
					estabelecimento e,
					conta_contabil_ifrs f
				where	a.nr_seq_conta_credito		= f.nr_seq_conta_ifrs
				and	f.cd_conta_contabil		= b.cd_conta_contabil
				and	obter_se_periodo_vigente(f.dt_inicio_vigencia, f.dt_fim_vigencia, dt_referencia_w) = 'S'
				and	coalesce(f.ie_situacao, 'I')		= 'A'
				and	b.cd_grupo			= c.cd_grupo
				and	a.nr_lote_contabil		= d.nr_lote_contabil
				and	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) = e.cd_estabelecimento
				and	a.dt_movimento between dt_inicial_w and dt_encerramento_p
				and	obter_empresa_estab(coalesce(a.cd_estabelecimento, d.cd_estabelecimento)) = cd_empresa_w
				and	e.cd_estabelecimento		= coalesce(cd_estabelecimento_p,e.cd_estabelecimento)
				and	coalesce(b.ie_centro_custo,'N') 	= 'N'
				and	c.ie_tipo in ('R','C','D')
				and	coalesce(b.ie_tipo,'A')		= 'A'
			) x
			group by
				x.nr_seq_conta_ifrs,
				x.cd_conta_contabil,
				x.ie_debito_credito,
				x.cd_centro_custo
			
union all

			select	sum(y.vl_movimento) vl_movimento, /* COM Centro de custo */
				to_char(y.cd_conta_contabil) cd_conta_contabil,
				to_char(y.nr_seq_conta_ifrs) nr_seq_conta_ifrs,
				to_char(y.ie_debito_credito) ie_debito_credito,
				(y.cd_centro_custo)::numeric  cd_centro_custo
			from (
				select	CASE WHEN c.ie_debito_credito='D' THEN f.vl_movimento  ELSE -f.vl_movimento END  vl_movimento, /* Movimento de DEBITO COM centro de custo */
					a.nr_seq_conta_debito nr_seq_conta_ifrs,
					g.cd_conta_contabil,
					c.ie_debito_credito,
					f.cd_centro_custo
				from	ctb_grupo_conta c,
					conta_contabil b,
					ctb_movto_ifrs a,
					lote_contabil d,
					estabelecimento e,
					ctb_movto_ifrs_cc f,
					conta_contabil_ifrs g
				where	a.nr_seq_conta_debito		= g.nr_seq_conta_ifrs
				and	g.cd_conta_contabil		= b.cd_conta_contabil
				and	b.cd_grupo			= c.cd_grupo
				and	obter_se_periodo_vigente(g.dt_inicio_vigencia, g.dt_fim_vigencia, dt_referencia_w) = 'S'
				and	coalesce(g.ie_situacao, 'I')		= 'A'
				and	a.nr_lote_contabil		= d.nr_lote_contabil
				and	a.nr_sequencia			= f.nr_seq_movto_ifrs
				and	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) = e.cd_estabelecimento
				and	a.dt_movimento between dt_inicial_w and dt_encerramento_p
				and	obter_empresa_estab(coalesce(a.cd_estabelecimento, d.cd_estabelecimento)) = cd_empresa_w
				and	e.cd_estabelecimento		= coalesce(cd_estabelecimento_p,e.cd_estabelecimento)
				and	coalesce(b.ie_centro_custo,'N') 	= 'S'
				and	c.ie_tipo in ('R','C','D')
				and	coalesce(b.ie_tipo,'A')		= 'A'
				
union all

				select	CASE WHEN c.ie_debito_credito='C' THEN f.vl_movimento  ELSE -f.vl_movimento END  vl_movimento, /* Movimento de CREDITO COM centro de custo */
					a.nr_seq_conta_credito nr_seq_conta_ifrs,
					g.cd_conta_contabil,
					c.ie_debito_credito,
					f.cd_centro_custo
				from	ctb_grupo_conta c,
					conta_contabil b,
					ctb_movto_ifrs a,
					lote_contabil d,
					estabelecimento e,
					ctb_movto_ifrs_cc f,
					conta_contabil_ifrs g
				where	a.nr_seq_conta_credito		= g.nr_seq_conta_ifrs
				and	g.cd_conta_contabil		= b.cd_conta_contabil
				and	b.cd_grupo			= c.cd_grupo
				and	obter_se_periodo_vigente(g.dt_inicio_vigencia, g.dt_fim_vigencia, dt_referencia_w) = 'S'
				and	coalesce(g.ie_situacao, 'I')		= 'A'
				and	a.nr_lote_contabil		= d.nr_lote_contabil
				and	a.nr_sequencia			= f.nr_seq_movto_ifrs
				and	coalesce(a.cd_estabelecimento, d.cd_estabelecimento) = e.cd_estabelecimento
				and	a.dt_movimento between dt_inicial_w and dt_encerramento_p
				and	obter_empresa_estab(coalesce(a.cd_estabelecimento, d.cd_estabelecimento)) = cd_empresa_w
				and	e.cd_estabelecimento		= coalesce(cd_estabelecimento_p,e.cd_estabelecimento)
				and	coalesce(b.ie_centro_custo,'N') 	= 'S'
				and	c.ie_tipo in ('R','C','D')
				and	coalesce(b.ie_tipo,'A')		= 'A'
			) y
			group by
				y.nr_seq_conta_ifrs,
				y.cd_conta_contabil,
				y.ie_debito_credito,
				y.cd_centro_custo
		) z
		group by
			z.nr_seq_conta_ifrs,
			z.cd_conta_contabil,
			z.cd_centro_custo
	) w
	where	w.vl_movimento <> 0;		

c03 CURSOR FOR
	SELECT	nextval('ctb_movto_ifrs_seq') nr_seq_movto,
		z.nr_seq_conta_ifrs nr_seq_conta_ifrs,
		z.cd_centro_custo cd_centro_custo,
		substr(ctb_obter_situacao_saldo(z.cd_conta_contabil, z.vl_saldo),1,1) ie_debito_credito,
		abs(z.vl_saldo) vl_saldo
	from (
		SELECT	f.cd_conta_contabil,
			a.nr_seq_conta_ifrs,
			a.cd_centro_custo,
			sum(a.vl_saldo) vl_saldo
		from	ctb_saldo_ifrs a,
			ctb_mes_ref b,
			conta_contabil c,
			estabelecimento d,
			ctb_grupo_conta e,
			conta_contabil_ifrs f
		where	a.nr_seq_conta_ifrs		= f.nr_seq_conta_ifrs
		and	f.cd_conta_contabil		= c.cd_conta_contabil
		and	obter_se_periodo_vigente(f.dt_inicio_vigencia, f.dt_fim_vigencia, dt_referencia_w) = 'S'
		and	coalesce(f.ie_situacao, 'I')		= 'A'
		and	a.nr_seq_mes_ref		= b.nr_sequencia
		and	d.cd_estabelecimento		= a.cd_estabelecimento
		and	c.ie_tipo			= 'A'
		and	d.cd_empresa			= cd_empresa_w
		and	c.cd_grupo			= e.cd_grupo
		and	d.cd_estabelecimento		= coalesce(cd_estabelecimento_p,d.cd_estabelecimento)
		and	substr(obter_se_conta_vigente(c.cd_conta_contabil, b.dt_referencia), 1, 1) = 'S'
		and	b.nr_sequencia			= nr_seq_mes_ant_w
		and	e.ie_tipo in ('R','C','D')
		and	coalesce(c.ie_tipo,'A')		= 'A'
		and	a.vl_saldo			<> 0
		and	not exists (
			select	1
			FROM conta_contabil_ifrs w, ctb_movto_ifrs x
LEFT OUTER JOIN ctb_movto_ifrs_cc y ON (x.nr_sequencia = y.nr_seq_movto_ifrs)
WHERE w.nr_seq_conta_ifrs		= x.nr_seq_conta_debito and x.nr_seq_conta_debito		= a.nr_seq_conta_ifrs and obter_se_periodo_vigente(w.dt_inicio_vigencia, w.dt_fim_vigencia, dt_referencia_w) = 'S' and coalesce(w.ie_situacao, 'I')		= 'A' and x.nr_seq_mes_ref 		= nr_seq_mes_ref_p and x.dt_movimento between dt_inicial_w and dt_encerramento_p  and coalesce(y.cd_centro_custo,0)	= coalesce(a.cd_centro_custo,0)
			
union all

			select	1
			FROM conta_contabil_ifrs w, ctb_movto_ifrs x
LEFT OUTER JOIN ctb_movto_ifrs_cc y ON (x.nr_sequencia = y.nr_seq_movto_ifrs)
WHERE w.nr_seq_conta_ifrs		= x.nr_seq_conta_credito and x.nr_seq_conta_credito		= a.nr_seq_conta_ifrs and obter_se_periodo_vigente(w.dt_inicio_vigencia, w.dt_fim_vigencia, dt_referencia_w) = 'S' and coalesce(w.ie_situacao, 'I')		= 'A' and x.nr_seq_mes_ref 		= nr_seq_mes_ref_p and x.dt_movimento between dt_inicial_w and dt_encerramento_p  and coalesce(y.cd_centro_custo,0)	= coalesce(a.cd_centro_custo,0)
		 )
        group by
		a.nr_seq_conta_ifrs,
		f.cd_conta_contabil,
		a.cd_centro_custo
	) z;

type ctb_movto_ifrs_w is table of ctb_movto_ifrs%rowtype index by integer;
movimento_w ctb_movto_ifrs_w;

type ctb_movto_ifrs_cc_w is table of ctb_movto_ifrs_cc%rowtype index by integer;
movto_centro_custo_w ctb_movto_ifrs_cc_w;

type c02_type is table of c02%rowtype;
c02_w c02_type;

type c03_type is table of c03%rowtype;
c03_w c03_type;
BEGIN

begin
select	a.dt_referencia,
	a.dt_abertura,
	a.dt_fechamento,
	b.qt_mes_fim_exercicio,
	b.cd_empresa
into STRICT	dt_referencia_w,
	dt_abertura_w,
	dt_fechamento_w,
	qt_mes_fim_exerc_w,
	cd_empresa_w
from	empresa b,
	ctb_mes_ref a
where	a.nr_sequencia	= nr_seq_mes_ref_p
and	a.cd_empresa	= b.cd_empresa;
exception
when no_data_found then
	dt_referencia_w		:= null;
	dt_abertura_w		:= null;
	dt_fechamento_w		:= null;
	qt_mes_fim_exerc_w	:= null;
	cd_empresa_w		:= null;
end;

dt_inicial_w		:= trunc(dt_referencia_w);
nr_seq_agrupamento_w	:= somente_numero(to_char(dt_inicial_w, 'mmyyyy'));
dt_movimento_w		:= trunc(last_day(dt_referencia_w),'dd');

if (coalesce(dt_abertura_w::text, '') = '' or (dt_fechamento_w IS NOT NULL AND dt_fechamento_w::text <> '')) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(282424);
end if;

if (coalesce(dt_encerramento_p::text, '') = '') then
	if (qt_mes_fim_exerc_w > 0) then
		if (campo_numerico(to_char(dt_referencia_w,'mm')) <> qt_mes_fim_exerc_w) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(282425);
		end if;
	elsif (mod((to_char(dt_inicial_w, 'mm'))::numeric , abs(qt_mes_fim_exerc_w)) <> 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(282425);
	end if;	
end if;

select	coalesce(max(nr_lote_contabil), 0)
into STRICT	nr_lote_contabil_existe_w
from	lote_contabil
where	nr_seq_mes_ref 		= nr_seq_mes_ref_p
and	ie_encerramento		= 'S'
and	cd_tipo_lote_contabil 	= cd_tipo_lote_w
and	cd_estabelecimento 	= cd_estabelecimento_p;

if (nr_lote_contabil_existe_w <> 0) then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(325070, 'NR_LOTE_CONTABIL_EXISTE='||nr_lote_contabil_existe_w );
end if;

select	coalesce(max(nr_lote_contabil),0) + 1
into STRICT	nr_lote_contabil_w
from	lote_contabil;

insert into lote_contabil(
	nr_lote_contabil,
	dt_referencia, 
	cd_tipo_lote_contabil,
	dt_atualizacao,
	nm_usuario, 
	cd_estabelecimento,
	ie_situacao, 
	vl_debito,
	vl_credito,
	dt_integracao,
	dt_atualizacao_saldo,
	dt_consistencia,
	nm_usuario_original,
	nr_seq_mes_ref,
	ie_encerramento)
values (	nr_lote_contabil_w,
	coalesce(dt_encerramento_p,dt_movimento_w),
	cd_tipo_lote_w,
	dt_atual_w,
	nm_usuario_p,
	cd_estabelecimento_p,
	'A',
	0,
	0,
	null,
	null,
	null,
	nm_usuario_p,
	nr_seq_mes_ref_p,
	'S');
	
if (coalesce(dt_encerramento_p::text, '') = '') then
	open c01;
	loop
	fetch c01 into
		nr_seq_conta_ifrs_w,
		cd_centro_custo_w,
		ie_debito_credito_w,
		vl_saldo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
		nr_seq_conta_debito_w		:= null;
		nr_seq_conta_credito_w		:= null;
		cd_classif_debito_w		:= null;
		cd_classif_credito_w		:= null;
		if (ie_debito_credito_w = 'C') then
			nr_seq_conta_debito_w		:= nr_seq_conta_ifrs_w;
			nr_seq_conta_credito_w		:= nr_seq_conta_result_p;
		else
			nr_seq_conta_credito_w		:= nr_seq_conta_ifrs_w;
			nr_seq_conta_debito_w		:= nr_seq_conta_result_p;
		end if;

		if (vl_saldo_w < 0) then
			vl_saldo_w			:= vl_saldo_w * -1;
			nr_seq_conta_ifrs_ww		:= nr_seq_conta_debito_w;
			nr_seq_conta_debito_w		:= nr_seq_conta_credito_w;
			nr_seq_conta_credito_w		:= nr_seq_conta_ifrs_ww;
		end if;

		cd_classif_debito_w		:= ctb_obter_classif_conta_ifrs(nr_seq_conta_debito_w);
		cd_classif_credito_w		:= ctb_obter_classif_conta_ifrs(nr_seq_conta_credito_w);
		
		if (vl_saldo_w <> 0) then
			select	nextval('ctb_movto_ifrs_seq')
			into STRICT	nr_seq_movimento_w
			;

			insert into ctb_movto_ifrs(
				nr_sequencia,
				nr_lote_contabil,
				nr_seq_mes_ref,
				dt_movimento,
				vl_movimento,
				dt_atualizacao,
				nm_usuario,
				cd_historico,
				nr_seq_conta_debito,
				nr_seq_conta_credito,
				cd_classif_debito,
				cd_classif_credito,
				nr_seq_agrupamento,
				cd_estabelecimento)
			values (	nr_seq_movimento_w,
				nr_lote_contabil_w,
				nr_seq_mes_ref_p,
				dt_movimento_w,
				vl_saldo_w,
				dt_atual_w,
				nm_usuario_p,
				cd_historico_p,
				nr_seq_conta_debito_w,
				nr_seq_conta_credito_w,
				cd_classif_debito_w,
				cd_classif_credito_w,
				nr_seq_agrupamento_w,
				cd_estabelecimento_p);

			if (cd_centro_custo_w IS NOT NULL AND cd_centro_custo_w::text <> '') then
				begin
				insert into ctb_movto_ifrs_cc(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nr_seq_movto_ifrs,
					cd_centro_custo,
					vl_movimento,
					pr_rateio)
				values (	nextval('ctb_movto_ifrs_cc_seq'),
					nm_usuario_p,
					dt_atual_w,
					nr_seq_movimento_w,
					cd_centro_custo_w,
					vl_saldo_w,
					100);
				end;
			end if;
		end if;
	end;
	end loop;
	close c01;
else
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_mes_ant_w
	from	ctb_mes_ref
	where	cd_empresa	= cd_empresa_w
	and	dt_referencia	= pkg_date_utils.start_of(pkg_date_utils.add_month(dt_inicial_w,-1,0),'month',0);

	open c02;
	loop
	fetch c02 bulk collect into c02_w limit 1000;
		for i in 1 .. c02_w.count loop
		begin
			nr_seq_conta_debito_w	:= null;
			nr_seq_conta_credito_w	:= null;
			cd_classif_debito_w	:= null;
			cd_classif_credito_w	:= null;

			if (c02_w[i].ie_debito_credito = 'C') then
				nr_seq_conta_debito_w		:= c02_w[i].nr_seq_conta_ifrs;
				nr_seq_conta_credito_w		:= nr_seq_conta_result_p;
			else
				nr_seq_conta_credito_w		:= c02_w[i].nr_seq_conta_ifrs;
				nr_seq_conta_debito_w		:= nr_seq_conta_result_p;
			end if;

			select	coalesce(sum(a.vl_saldo),0)
			into STRICT	vl_saldo_ini_w -- Saldo do mes anterior
			from	ctb_saldo_ifrs a
			where	a.nr_seq_mes_ref		= nr_seq_mes_ant_w
			and	obter_empresa_estab(a.cd_estabelecimento) = cd_empresa_w
			and	a.cd_estabelecimento 		= coalesce(cd_estabelecimento_p,a.cd_estabelecimento)
			and	a.nr_seq_conta_ifrs		= c02_w[i].nr_seq_conta_ifrs
			and	coalesce(a.cd_centro_custo,0)	= coalesce(c02_w[i].cd_centro_custo,0);

			vl_saldo_fin_w                  := vl_saldo_ini_w + c02_w[i].vl_saldo;
			vl_saldo_ini_w                  := abs(vl_saldo_ini_w);
			ie_debito_credito_w_aux         := ctb_obter_situacao_saldo(c02_w[i].cd_conta_contabil, vl_saldo_fin_w);

			if (ie_debito_credito_w_aux <> c02_w[i].ie_debito_credito) then
				c02_w[i].ie_debito_credito	:= ie_debito_credito_w_aux;

				if (c02_w[i].ie_debito_credito = 'C') then
					nr_seq_conta_debito_w	:= c02_w[i].nr_seq_conta_ifrs;
					nr_seq_conta_credito_w	:= nr_seq_conta_result_p;
				else
					nr_seq_conta_credito_w	:= c02_w[i].nr_seq_conta_ifrs;
					nr_seq_conta_debito_w	:= nr_seq_conta_result_p;
				end if;
			end if;

			vl_saldo_fin_w		:= abs(vl_saldo_fin_w);
			c02_w[i].vl_saldo	:= vl_saldo_fin_w;

			cd_classif_debito_w	:= ctb_obter_classif_conta_ifrs(nr_seq_conta_debito_w);
			cd_classif_credito_w	:= ctb_obter_classif_conta_ifrs(nr_seq_conta_credito_w);

			if (vl_saldo_fin_w > 0) then
				movimento_w[movimento_w.count + 1].nr_sequencia		:= c02_w[i].nr_seq_movto;
				movimento_w[movimento_w.count].nr_lote_contabil		:= nr_lote_contabil_w;
				movimento_w[movimento_w.count].nr_seq_mes_ref		:= nr_seq_mes_ref_p;
				movimento_w[movimento_w.count].dt_movimento		:= dt_encerramento_p;
				movimento_w[movimento_w.count].vl_movimento		:= vl_saldo_fin_w;
				movimento_w[movimento_w.count].dt_atualizacao		:= dt_atual_w;
				movimento_w[movimento_w.count].nm_usuario		:= nm_usuario_p;
				movimento_w[movimento_w.count].cd_historico		:= cd_historico_p;
				movimento_w[movimento_w.count].nr_seq_conta_debito	:= nr_seq_conta_debito_w;
				movimento_w[movimento_w.count].nr_seq_conta_credito	:= nr_seq_conta_credito_w;
				movimento_w[movimento_w.count].cd_classif_debito	:= cd_classif_debito_w;
				movimento_w[movimento_w.count].cd_classif_credito	:= cd_classif_credito_w;
				movimento_w[movimento_w.count].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
				movimento_w[movimento_w.count].cd_estabelecimento	:= cd_estabelecimento_p;
			end if;
		end;
		end loop;
	
		forall i in movimento_w.first .. movimento_w.last
		insert into ctb_movto_ifrs values movimento_w(i);
		commit;
		movimento_w.delete;
		
		for m in 1 .. c02_w.count loop
		begin
			if (c02_w[m](.cd_centro_custo IS NOT NULL AND .cd_centro_custo::text <> '')) then
				begin
				select	nextval('ctb_movto_ifrs_cc_seq')
				into STRICT	nr_seq_centro_custo_w
				;

				movto_centro_custo_w[movto_centro_custo_w.count + 1].nr_sequencia	:= nr_seq_centro_custo_w;
				movto_centro_custo_w[movto_centro_custo_w.count].nm_usuario		:= nm_usuario_p;
				movto_centro_custo_w[movto_centro_custo_w.count].dt_atualizacao		:= dt_atual_w;
				movto_centro_custo_w[movto_centro_custo_w.count].nr_seq_movto_ifrs	:= c02_w[m].nr_seq_movto;
				movto_centro_custo_w[movto_centro_custo_w.count].cd_centro_custo	:= c02_w[m].cd_centro_custo;
				movto_centro_custo_w[movto_centro_custo_w.count].vl_movimento		:= c02_w[m].vl_saldo;
				movto_centro_custo_w[movto_centro_custo_w.count].pr_rateio		:= 100;
				end;
			end if;
		end;
		end loop;
		
		forall m in movto_centro_custo_w.first .. movto_centro_custo_w.last
		insert into ctb_movto_ifrs_cc values movto_centro_custo_w(m);
		commit;
		movto_centro_custo_w.delete;
	EXIT WHEN NOT FOUND; /* apply on c02 */
	end loop;
	close c02;

	open c03;
	loop
	fetch c03 bulk collect into c03_w limit 1000;
		for y in 1 .. c03_w.count loop
		begin
			nr_seq_conta_debito_w	:= null;
			nr_seq_conta_credito_w	:= null;
			cd_classif_debito_w	:= null;
			cd_classif_credito_w	:= null;

			if (c03_w[y].ie_debito_credito = 'C') then
				nr_seq_conta_debito_w		:= c03_w[y].nr_seq_conta_ifrs;
				nr_seq_conta_credito_w		:= nr_seq_conta_result_p;
			else
				nr_seq_conta_credito_w		:= c03_w[y].nr_seq_conta_ifrs;
				nr_seq_conta_debito_w		:= nr_seq_conta_result_p;
			end if;

			if (c03_w[y].vl_saldo < 0) then
				c03_w[y].vl_saldo		:= c03_w[y].vl_saldo * -1;
			end if;
				
			cd_classif_debito_w	:= ctb_obter_classif_conta_ifrs(nr_seq_conta_debito_w);
			cd_classif_credito_w	:= ctb_obter_classif_conta_ifrs(nr_seq_conta_credito_w);
			vl_saldo_fin_w		:= c03_w[y].vl_saldo;

			movimento_w[y].nr_sequencia		:= c03_w[y].nr_seq_movto;
			movimento_w[y].nr_lote_contabil		:= nr_lote_contabil_w;
			movimento_w[y].nr_seq_mes_ref		:= nr_seq_mes_ref_p;
			movimento_w[y].dt_movimento		:= dt_encerramento_p;
			movimento_w[y].vl_movimento		:= vl_saldo_fin_w;
			movimento_w[y].dt_atualizacao		:= dt_atual_w;
			movimento_w[y].nm_usuario		:= nm_usuario_p;
			movimento_w[y].cd_historico		:= cd_historico_p;
			movimento_w[y].nr_seq_conta_debito	:= nr_seq_conta_debito_w;
			movimento_w[y].nr_seq_conta_credito	:= nr_seq_conta_credito_w;
			movimento_w[y].cd_classif_debito	:= cd_classif_debito_w;
			movimento_w[y].cd_classif_credito	:= cd_classif_credito_w;
			movimento_w[y].nr_seq_agrupamento	:= nr_seq_agrupamento_w;
			movimento_w[y].cd_estabelecimento	:= cd_estabelecimento_p;
		end;
		end loop;
		
		forall y in movimento_w.first .. movimento_w.last
		insert into ctb_movto_ifrs values movimento_w(y);
		commit;
		movimento_w.delete;
		
		for c in 1 .. c03_w.count loop
		begin
			if (c03_w[c](.cd_centro_custo IS NOT NULL AND .cd_centro_custo::text <> '')) then
				begin
				select	nextval('ctb_movto_ifrs_cc_seq')
				into STRICT	nr_seq_centro_custo_w
				;

				movto_centro_custo_w[movto_centro_custo_w.count + 1].nr_sequencia	:= nr_seq_centro_custo_w;
				movto_centro_custo_w[movto_centro_custo_w.count].nm_usuario 		:= nm_usuario_p;
				movto_centro_custo_w[movto_centro_custo_w.count].dt_atualizacao 	:= dt_atual_w;
				movto_centro_custo_w[movto_centro_custo_w.count].nr_seq_movto_ifrs 	:= c03_w[c].nr_seq_movto;
				movto_centro_custo_w[movto_centro_custo_w.count].cd_centro_custo 	:= c03_w[c].cd_centro_custo;
				movto_centro_custo_w[movto_centro_custo_w.count].vl_movimento 		:= c03_w[c].vl_saldo;
				movto_centro_custo_w[movto_centro_custo_w.count].pr_rateio 		:= 100;
				end;
			end if;
		end;
		end loop;
		
		forall c in movto_centro_custo_w.first .. movto_centro_custo_w.last
		insert into ctb_movto_ifrs_cc values movto_centro_custo_w(c);
		commit;
		movto_centro_custo_w.delete;
	EXIT WHEN NOT FOUND; /* apply on c03 */
	end loop;
	close c03;
end if;	

if (coalesce(nr_lote_contabil_w,0) <> 0) then
	update	lote_contabil
	set	ds_observacao = substr(wheb_mensagem_pck.get_texto(799265) || ' ' || nr_seq_conta_result_p || wheb_mensagem_pck.get_texto(799268) || ' ' || cd_historico_p,1,2000)
	where	nr_lote_contabil = nr_lote_contabil_w;
end if;
	
commit;

ds_erro_w := ctb_consistir_lote_ifrs(nr_lote_contabil_w, ds_erro_w, nm_usuario_p);

if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(278178, 'DS_ERRO=' || ds_erro_w );
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_encerrar_exercicio_ifrs ( cd_estabelecimento_p bigint, nr_seq_mes_ref_p bigint, cd_historico_p bigint, nr_seq_conta_result_p bigint, nm_usuario_p text, dt_encerramento_p timestamp) FROM PUBLIC;

