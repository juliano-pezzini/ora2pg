-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_valores_a550 ( nr_seq_lote_contest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção: 		CUIDADO
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/ie_classif_cobranca_w		varchar(1);
cd_unimed_destino_w		varchar(4);
cd_cooperativa_w		varchar(4);
nr_seq_conta_proc_w		bigint;
nr_seq_conta_mat_w		bigint;
nr_seq_ptu_fatura_w		bigint;
nr_seq_ptu_camara_contest_w	bigint;
nr_seq_pls_fatura_w		bigint;
nr_seq_fatura_proc_w		bigint;
nr_seq_fatura_mat_w		bigint;
nr_titulo_w			bigint;
nr_titulo_ndc_w			bigint;
nr_seq_congenere_w		bigint;
qt_camara_w			bigint := 0;
vl_glosa_proc_fatura_w		double precision := 0;
vl_glosa_proc_ndc_w		double precision := 0;
vl_glosa_mat_fatura_w		double precision := 0;
vl_glosa_mat_ndc_w		double precision := 0;
vl_total_fatura_w		double precision := 0;
vl_total_ndc_w			double precision := 0;
vl_glosa_fatura_w		double precision := 0;
vl_glosa_ndc_w			double precision := 0;
vl_total_pago_w			double precision := 0;
vl_total_pago_ndc_w		double precision := 0;
vl_total_acordo_w		double precision := 0;
vl_glosa_tit_w			double precision := 0;
vl_glosa_tit_ndc_w		double precision := 0;
vl_total_contest_w		double precision := 0;
vl_total_contest_ndc_w		double precision := 0;
qt_registro_w			integer;

C01 CURSOR FOR
	SELECT	b.nr_seq_conta_proc,
		null
	from	pls_contestacao_proc 	b,
		pls_contestacao 	a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p
	
union all

	SELECT	null,
		b.nr_seq_conta_mat
	from	pls_contestacao_mat 	b,
		pls_contestacao 	a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p;

C02 CURSOR FOR
	SELECT	b.nr_seq_fatura_proc,
		null
	from	pls_contestacao_proc 	b,
		pls_contestacao 	a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p
	
union all

	SELECT	null,
		b.nr_seq_fatura_mat
	from	pls_contestacao_mat 	b,
		pls_contestacao 	a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p;


BEGIN
select	max(nr_seq_ptu_fatura),
	max(nr_seq_pls_fatura),
	coalesce(max(vl_contestado_fatura),0),
	coalesce(max(vl_contestado_ndc),0),
	coalesce(max(vl_pago_fatura),0),
	coalesce(max(vl_pago_ndc),0)
into STRICT	nr_seq_ptu_fatura_w,
	nr_seq_pls_fatura_w,
	vl_total_contest_w,
	vl_total_contest_ndc_w,
	vl_total_pago_w,
	vl_total_pago_ndc_w
from	pls_lote_contestacao
where	nr_sequencia = nr_seq_lote_contest_p;

select	max(nr_sequencia),
	max(cd_unimed_destino)
into STRICT	nr_seq_ptu_camara_contest_w,
	cd_unimed_destino_w
from	ptu_camara_contestacao
where	nr_seq_lote_contest = nr_seq_lote_contest_p;

select	count(1)
into STRICT	qt_registro_w
from	ptu_questionamento
where	nr_seq_contestacao	= nr_seq_ptu_camara_contest_w  LIMIT 1;

if (cd_unimed_destino_w IS NOT NULL AND cd_unimed_destino_w::text <> '') then
	cd_cooperativa_w := lpad(cd_unimed_destino_w, 4, '0');

	select	max(nr_sequencia)
	into STRICT	nr_seq_congenere_w
	from	pls_congenere
	where	cd_cooperativa	= cd_cooperativa_w;

	select	count(1)
	into STRICT	qt_camara_w
	from	pls_camara_compensacao	x,
		pls_congenere_camara	w
	where	x.nr_sequencia		= w.nr_seq_camara
	and	w.nr_seq_congenere	= nr_seq_congenere_w  LIMIT 1;
end if;

-- APENAS PARA PTU FATURA - A500 (PAGAMENTO)
if (nr_seq_ptu_fatura_w IS NOT NULL AND nr_seq_ptu_fatura_w::text <> '') then
	select	max(coalesce(vl_total_fatura,0)),
		max(coalesce(vl_total_ndc,0)),
		max(ie_classif_cobranca),
		max(nr_titulo),
		max(nr_titulo_ndc)
	into STRICT	vl_total_fatura_w,
		vl_total_ndc_w,
		ie_classif_cobranca_w,
		nr_titulo_w,
		nr_titulo_ndc_w
	from	ptu_fatura
	where	nr_sequencia = nr_seq_ptu_fatura_w;

	select	coalesce(sum(coalesce(b.vl_contestado,0)),0)
	into STRICT	vl_glosa_fatura_w
	from	pls_contestacao_proc b,
		pls_contestacao a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p;

	select	coalesce(sum(coalesce(b.vl_contestado,0)),0)
	into STRICT	vl_glosa_ndc_w
	from	pls_contestacao_mat b,
		pls_contestacao a
	where	a.nr_sequencia	= b.nr_seq_contestacao
	and	a.nr_seq_lote	= nr_seq_lote_contest_p;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then -- FATURA
		select	coalesce(sum(coalesce(w.vl_glosa,0)),0)
		into STRICT	vl_glosa_tit_w
		from	titulo_pagar		x,
			titulo_pagar_baixa	w
		where	w.nr_titulo	= x.nr_titulo
		and	x.nr_titulo	= nr_titulo_w;
	end if;

	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then -- NDR
		select	coalesce(sum(coalesce(w.vl_glosa,0)),0)
		into STRICT	vl_glosa_tit_ndc_w
		from	titulo_pagar		x,
			titulo_pagar_baixa	w
		where	w.nr_titulo	= x.nr_titulo
		and	x.nr_titulo	= nr_titulo_ndc_w;
	end if;

	if (ie_classif_cobranca_w = '1') then -- NDR (Reembolso de Custo Assistencial)
		vl_glosa_ndc_w := vl_glosa_ndc_w + vl_glosa_fatura_w;
		vl_total_contest_ndc_w := vl_total_contest_ndc_w + vl_total_contest_w;
		vl_total_ndc_w := vl_total_ndc_w + vl_total_fatura_w;
		vl_total_pago_ndc_w := vl_total_pago_ndc_w + vl_total_pago_w;

		vl_glosa_fatura_w := 0;
		vl_total_fatura_w := 0;
		vl_total_pago_w := 0;
		vl_total_contest_w := 0;

		if (vl_glosa_tit_ndc_w <= 0) and (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
			vl_glosa_ndc_w := 0;
		end if;

	elsif (ie_classif_cobranca_w = '2') then -- Fatura
		vl_glosa_fatura_w := vl_glosa_fatura_w + vl_glosa_ndc_w;
		vl_total_contest_w := vl_total_contest_w + vl_total_contest_ndc_w;
		vl_total_fatura_w := vl_total_fatura_w + vl_total_ndc_w;
		vl_total_pago_w := vl_total_pago_w + vl_total_pago_ndc_w;

		vl_glosa_ndc_w := 0;
		vl_total_ndc_w := 0;
		vl_total_pago_ndc_w := 0;
		vl_total_contest_ndc_w := 0;

		if (vl_glosa_tit_w <= 0) and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
			vl_glosa_fatura_w := 0;
		end if;

	elsif (ie_classif_cobranca_w = '3') then -- Fatura + NDR (Reembolso de Custo Assistencial)
		if (vl_glosa_tit_w <= 0) and (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
			vl_glosa_fatura_w := 0;
		end if;

		if (vl_glosa_tit_ndc_w <= 0) and (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
			vl_glosa_ndc_w := 0;
		end if;
	end if;

	if (qt_registro_w > 0) then
		select	coalesce(sum(coalesce(a.vl_acordo,0)),0)
		into STRICT	vl_total_acordo_w
		from	ptu_questionamento a,
			ptu_camara_contestacao b
		where	a.nr_seq_contestacao	= b.nr_sequencia
		and	b.nr_sequencia		= nr_seq_ptu_camara_contest_w
		and	exists (SELECT	d.cd_motivo
				from	ptu_motivo_questionamento d,
					ptu_questionamento_codigo c
				where	c.nr_seq_registro		= a.nr_sequencia
				and	c.nr_seq_mot_questionamento	= d.nr_sequencia);
	else
		select	coalesce(sum(coalesce(c.vl_acordo_serv,0)),0)
		into STRICT	vl_total_acordo_w
		from	ptu_quest_serv_rrs c,
			ptu_questionamento_rrs a,
			ptu_camara_contestacao b
		where	a.nr_seq_contestacao	= b.nr_sequencia
		and	a.nr_sequencia		= c.nr_seq_quest_rrs
		and	b.nr_sequencia		= nr_seq_ptu_camara_contest_w
		and	exists (SELECT	d.cd_motivo
				from	ptu_motivo_questionamento d,
					ptu_questionamento_codigo c
				where	c.nr_seq_registro		= a.nr_sequencia
				and	c.nr_seq_mot_questionamento	= d.nr_sequencia);
	end if;

	-- CASO A UNIMED NÃO SEJA DE CÂMARA
	if (qt_camara_w = 0) then
		update	ptu_camara_contestacao
		set	vl_total_pago		= vl_total_pago_w,
			vl_total_pago_ndc	= vl_total_pago_ndc_w,
			vl_total_contestacao	= vl_total_contest_w,
			vl_total_contest_ndc	= vl_total_contest_ndc_w,
			vl_total_fatura		= vl_total_fatura_w,
			vl_total_ndc_a500	= vl_total_ndc_w,
			vl_total_acordo		= vl_total_acordo_w
		where	nr_sequencia		= nr_seq_ptu_camara_contest_w;
	end if;

	-- SEMPRE QUE A UNIMED FOR DE CÂMARA O PAGAMENTO É O VALOR DA FATURA - OS 617263
	if (qt_camara_w > 0) then
		update	ptu_camara_contestacao
		set	vl_total_pago		= vl_total_pago_w,
			vl_total_pago_ndc	= vl_total_pago_ndc_w,
			vl_total_contestacao	= vl_total_contest_w,
			vl_total_contest_ndc	= vl_total_contest_ndc_w,
			vl_total_fatura		= vl_total_fatura_w,
			vl_total_ndc_a500	= vl_total_ndc_w,
			vl_total_acordo		= vl_total_acordo_w
		where	nr_sequencia		= nr_seq_ptu_camara_contest_w;
	end if;
end if;

-- APENAS PARA PLS FATURA - FATURAMENTO
if (nr_seq_pls_fatura_w IS NOT NULL AND nr_seq_pls_fatura_w::text <> '') then
	select	max(nr_titulo),
		max(nr_titulo_ndc)
	into STRICT	nr_titulo_w,
		nr_titulo_ndc_w
	from	pls_fatura
	where	nr_sequencia = nr_seq_pls_fatura_w;

	open C02;
	loop
	fetch C02 into
		nr_seq_fatura_proc_w,
		nr_seq_fatura_mat_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		vl_glosa_proc_ndc_w := 0;
		vl_glosa_proc_fatura_w := 0;
		vl_glosa_mat_ndc_w := 0;
		vl_glosa_mat_fatura_w := 0;

		if (nr_seq_fatura_proc_w IS NOT NULL AND nr_seq_fatura_proc_w::text <> '') then
			select	coalesce(vl_faturado,0),
				coalesce(vl_faturado_ndc,0)
			into STRICT	vl_glosa_proc_fatura_w,
				vl_glosa_proc_ndc_w
			from	pls_fatura_proc
			where	nr_sequencia = nr_seq_fatura_proc_w;
		end if;

		if (nr_seq_fatura_mat_w IS NOT NULL AND nr_seq_fatura_mat_w::text <> '') then
			select	coalesce(vl_faturado,0),
				coalesce(vl_faturado_ndc,0)
			into STRICT	vl_glosa_mat_fatura_w,
				vl_glosa_mat_ndc_w
			from	pls_fatura_mat
			where	nr_sequencia = nr_seq_fatura_mat_w;
		end if;

		vl_total_contest_w := coalesce(vl_total_contest_w,0) + coalesce(vl_glosa_proc_fatura_w,0) + coalesce(vl_glosa_mat_fatura_w,0);
		vl_total_contest_ndc_w := coalesce(vl_total_contest_ndc_w,0) + coalesce(vl_glosa_proc_ndc_w,0) + coalesce(vl_glosa_mat_ndc_w,0);

		nr_seq_fatura_proc_w := null;
		nr_seq_fatura_mat_w := null;
		end;
	end loop;
	close C02;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		select	coalesce(vl_titulo,0)
		into STRICT	vl_total_fatura_w
		from	titulo_receber
		where	nr_titulo = nr_titulo_w;
	end if;

	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		select	coalesce(vl_titulo,0)
		into STRICT	vl_total_ndc_w
		from	titulo_receber
		where	nr_titulo = nr_titulo_ndc_w;
	end if;

	if (nr_titulo_w IS NOT NULL AND nr_titulo_w::text <> '') then
		select	coalesce(sum(w.vl_recebido),0)
		into STRICT	vl_total_pago_w
		from	titulo_receber		x,
			titulo_receber_liq	w
		where	w.nr_titulo	= x.nr_titulo
		and	x.nr_titulo	= nr_titulo_w;
	end if;

	if (nr_titulo_ndc_w IS NOT NULL AND nr_titulo_ndc_w::text <> '') then
		select	coalesce(sum(w.vl_recebido),0)
		into STRICT	vl_total_pago_ndc_w
		from	titulo_receber		x,
			titulo_receber_liq	w
		where	w.nr_titulo	= x.nr_titulo
		and	x.nr_titulo	= nr_titulo_ndc_w;
	end if;

	if (qt_registro_w > 0) then
		select	coalesce(sum(coalesce(a.vl_acordo,0)),0)
		into STRICT	vl_total_acordo_w
		from	ptu_questionamento a,
			ptu_camara_contestacao b
		where	a.nr_seq_contestacao	= b.nr_sequencia
		and	b.nr_sequencia		= nr_seq_ptu_camara_contest_w
		and	exists (SELECT	d.cd_motivo
				from	ptu_motivo_questionamento d,
					ptu_questionamento_codigo c
				where	c.nr_seq_registro		= a.nr_sequencia
				and	c.nr_seq_mot_questionamento	= d.nr_sequencia);
	else
		select	coalesce(sum(coalesce(c.vl_acordo_serv,0)),0)
		into STRICT	vl_total_acordo_w
		from	ptu_quest_serv_rrs c,
			ptu_questionamento_rrs a,
			ptu_camara_contestacao b
		where	a.nr_seq_contestacao	= b.nr_sequencia
		and	a.nr_sequencia		= c.nr_seq_quest_rrs
		and	b.nr_sequencia		= nr_seq_ptu_camara_contest_w
		and	exists (SELECT	d.cd_motivo
				from	ptu_motivo_questionamento d,
					ptu_questionamento_codigo c
				where	c.nr_seq_registro		= a.nr_sequencia
				and	c.nr_seq_mot_questionamento	= d.nr_sequencia);
	end if;

	-- Atualizar os valores
	update	ptu_camara_contestacao
	set	vl_total_pago		= vl_total_pago_w,
		vl_total_pago_ndc	= vl_total_pago_ndc_w,
		vl_total_contestacao	= vl_total_contest_w,
		vl_total_contest_ndc	= vl_total_contest_ndc_w,
		vl_total_fatura		= vl_total_fatura_w,
		vl_total_ndc_a500	= vl_total_ndc_w,
		vl_total_acordo		= vl_total_acordo_w
	where	nr_sequencia		= nr_seq_ptu_camara_contest_w;
end if;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_valores_a550 ( nr_seq_lote_contest_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
