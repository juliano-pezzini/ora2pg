-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vinc_adiant_lote_evento ( nr_seq_lote_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


cd_conta_contabil_w		varchar(20);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);		
ie_insere_w			varchar(1) := 'N';
vl_saldo_w			double precision;
nr_seq_lote_pagamento_w		bigint;	
nr_seq_periodo_w		bigint;				
nr_adiantamento_w		bigint;
nr_seq_evento_w			bigint;
nr_seq_prestador_w		bigint;
nr_seq_classificacao_w		pls_prestador.nr_seq_classificacao%type;
nr_seq_tipo_prestador_w		pls_prestador.nr_seq_tipo_prestador%type;
nr_seq_evento_movto_w		bigint;
qt_adiant_pago_w		integer;
cd_estabelecimento_w		smallint;
dt_competencia_w		timestamp;
dt_adiantamento_w		timestamp;
nr_seq_evento_lote_w		bigint;
nr_seq_tipo_w			bigint;
cd_centro_custo_w		centro_custo.cd_centro_custo%type;
ie_desconto_cobranca_nf_w	pls_evento_regra_adiant.ie_desconto_cobranca_nf%type;
nr_seq_regra_w			pls_evento_regra_adiant.nr_sequencia%type;
nr_seq_nota_w			nota_fiscal.nr_sequencia%type;
	
C01 CURSOR FOR
	SELECT	a.nr_adiantamento,
		a.dt_adiantamento,
		a.vl_saldo,
		a.cd_pessoa_fisica,
		null cd_cgc,
		nr_seq_tipo
	from	adiantamento_pago a
	where	exists (SELECT	1
			from	pls_prestador x
			where	x.cd_pessoa_fisica	= a.cd_pessoa_fisica)
	-- OS 1079251 - Retirada a validacao da competencia, pois temos casos que o prestador demorara para encaminhar para o custo
	and	trunc(a.dt_adiantamento,'mm') <= trunc(dt_competencia_w,'mm')
	and	a.vl_saldo > 0
	
union all

	select	a.nr_adiantamento,
		a.dt_adiantamento,
		a.vl_saldo,
		null cd_pessoa_fisica,
		a.cd_cgc,
		nr_seq_tipo
	from	adiantamento_pago a
	where	exists (select	1
			from	pls_prestador x
			where	x.cd_cgc	= a.cd_cgc)
	-- OS 1079251 - Retirada a validacao da competencia, pois temos casos que o prestador demorara para encaminhar para o custo
	and	trunc(a.dt_adiantamento,'mm') <= trunc(dt_competencia_w,'mm')
	and	a.vl_saldo > 0;
	

BEGIN
select	max(a.dt_competencia),
	max(a.cd_estabelecimento),
	max(a.nr_seq_evento),
	max(a.nr_seq_lote_pagamento)
into STRICT	dt_competencia_w,
	cd_estabelecimento_w,
	nr_seq_evento_lote_w,
	nr_seq_lote_pagamento_w
from	pls_lote_evento a
where	a.nr_sequencia = nr_seq_lote_p;

if (nr_seq_lote_pagamento_w IS NOT NULL AND nr_seq_lote_pagamento_w::text <> '') then
	select	max(a.nr_seq_periodo)
	into STRICT	nr_seq_periodo_w
	from	pls_lote_pagamento	a
	where	a.nr_sequencia	= nr_seq_lote_pagamento_w;
end if;

open C01;
loop
fetch C01 into	
	nr_adiantamento_w,
	dt_adiantamento_w,
	vl_saldo_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_tipo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	SELECT * FROM pls_obter_regra_adiant_pago(	nr_adiantamento_w, dt_competencia_w, nr_seq_tipo_w, ie_insere_w, nr_seq_evento_w, nr_seq_prestador_w, cd_centro_custo_w, ie_desconto_cobranca_nf_w, nr_seq_regra_w) INTO STRICT ie_insere_w, nr_seq_evento_w, nr_seq_prestador_w, cd_centro_custo_w, ie_desconto_cobranca_nf_w, nr_seq_regra_w;
	
	if (ie_insere_w = 'S') and (nr_seq_periodo_w IS NOT NULL AND nr_seq_periodo_w::text <> '') then
		ie_insere_w := pls_obter_se_evento_inside_per(nr_seq_periodo_w, nr_seq_evento_w, nr_seq_prestador_w, dt_competencia_w, dt_competencia_w);
	end if;
	
	if (ie_insere_w = 'S') and
		((coalesce(nr_seq_evento_lote_w::text, '') = '') or (nr_seq_evento_lote_w = nr_seq_evento_w)) then
		select	count(1)
		into STRICT	qt_adiant_pago_w
		from	pls_evento_movimento
		where	nr_adiant_pago = nr_adiantamento_w
		and	coalesce(ie_cancelamento::text, '') = ''  LIMIT 1;
		
		if (coalesce(nr_seq_prestador_w::text, '') = '') then
			if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_prestador_w
				from	pls_prestador a
				where	a.cd_pessoa_fisica	= cd_pessoa_fisica_w
				and	a.cd_estabelecimento	= cd_estabelecimento_w
				and	a.ie_situacao		= 'A'
				and (coalesce(a.dt_exclusao::text, '') = '' or a.dt_exclusao > dt_competencia_w);
			elsif (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_prestador_w
				from	pls_prestador a
				where	a.cd_cgc	= cd_cgc_w
				and	a.cd_estabelecimento	= cd_estabelecimento_w
				and	a.ie_situacao		= 'A'
				and (coalesce(a.dt_exclusao::text, '') = '' or a.dt_exclusao > dt_competencia_w);
			end if;
		end if;	
		
		select	max(a.nr_seq_classificacao),
			max(a.nr_seq_tipo_prestador)
		into STRICT	nr_seq_classificacao_w,
			nr_seq_tipo_prestador_w
		from	pls_prestador a
		where	nr_sequencia	= nr_seq_prestador_w;

		-- Edgar 26/05/2014, OS 740405, se o lote de pagamento for complementar, verificar se o evento esta cadastrado no mesmo
		if (ie_insere_w = 'S') and (pls_obter_se_lote_pgto_compl(nr_seq_lote_pagamento_w) = 'S') then
			ie_insere_w 	:= pls_obter_se_entra_pgto_compl(nr_seq_lote_pagamento_w, nr_seq_evento_w, nr_seq_prestador_w, nr_seq_tipo_prestador_w, nr_seq_classificacao_w);
		end if;
		
		if (coalesce(ie_desconto_cobranca_nf_w,'N') = 'OPM') then
						
			select	max(n.nr_sequencia)
			into STRICT	nr_seq_nota_w
			from	nota_fiscal_adiant_pago	y,
				nota_fiscal		n,
				pls_conta_medica_resumo	x,
				pls_conta_mat		d
			where	d.nr_sequencia		= x.nr_seq_conta_mat
			and	n.nr_sequencia		= d.nr_seq_nota_fiscal
			and	n.nr_sequencia		= y.nr_sequencia_nf
			and	x.nr_seq_prestador_pgto	= nr_seq_prestador_w
			and	y.nr_adiantamento	= nr_adiantamento_w
			and	coalesce(x.nr_seq_lote_pgto::text, '') = ''
			and	(n.nr_nota_fiscal IS NOT NULL AND n.nr_nota_fiscal::text <> '')
			and	not exists (	SELECT 	1
						from	pls_evento_movimento w
						where	w.nr_adiant_pago	= y.nr_adiantamento
						and	w.nr_seq_prestador	= x.nr_seq_prestador_pgto);
			
			--So vai buscar a nf pelos procedimentos caso nao ter encontrado na busca anterior.
			if (coalesce(nr_seq_nota_w::text, '') = '') then
				select	max(n.nr_sequencia)
				into STRICT	nr_seq_nota_w
				from	nota_fiscal_adiant_pago	y,
					nota_fiscal		n,
					pls_conta_medica_resumo	x,
					pls_conta_proc		d
				where	d.nr_sequencia		= x.nr_seq_conta_proc
				and	n.nr_sequencia		= d.nr_seq_nota_fiscal
				and	n.nr_sequencia		= y.nr_sequencia_nf
				and	x.nr_seq_prestador_pgto	= nr_seq_prestador_w
				and	y.nr_adiantamento	= nr_adiantamento_w
				and	coalesce(x.nr_seq_lote_pgto::text, '') = ''
				and	(n.nr_nota_fiscal IS NOT NULL AND n.nr_nota_fiscal::text <> '')
				and	not exists (	SELECT 	1
							from	pls_evento_movimento w
							where	w.nr_adiant_pago	= y.nr_adiantamento
							and	w.nr_seq_prestador	= x.nr_seq_prestador_pgto);
			end if;
			
			if (nr_seq_nota_w IS NOT NULL AND nr_seq_nota_w::text <> '') then
				
				select	coalesce(max(vl_total_nota),0)
				into STRICT	vl_saldo_w
				from	nota_fiscal
				where	nr_sequencia = nr_seq_nota_w;		
			end if;		
		end if;

		if (ie_insere_w = 'S') and (vl_saldo_w > 0) and (qt_adiant_pago_w = 0) and (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
			select	nextval('pls_evento_movimento_seq')
			into STRICT	nr_seq_evento_movto_w
			;
			
			insert into pls_evento_movimento(nr_sequencia,
				nm_usuario,
				dt_atualizacao,
				nm_usuario_nrec,
				dt_atualizacao_nrec,
				dt_movimento,
				nr_seq_evento,
				nr_seq_lote,
				nr_seq_prestador,
				nr_adiant_pago,
				vl_movimento,
				ie_forma_pagto,
				cd_centro_custo)
			values (nr_seq_evento_movto_w,
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				dt_adiantamento_w,
				nr_seq_evento_w,
				nr_seq_lote_p,
				nr_seq_prestador_w,
				nr_adiantamento_w,
				vl_saldo_w * -1,
				'P',
				cd_centro_custo_w);
				
			cd_conta_contabil_w := pls_obter_conta_contab_eve_fin(nr_seq_evento_movto_w, cd_conta_contabil_w);
			
			update	pls_evento_movimento
			set	cd_conta_contabil	= cd_conta_contabil_w
			where	nr_sequencia		= nr_seq_evento_movto_w;
		end if;	
	end if;
	end;
end loop;
close C01;

if (coalesce(ie_commit_p,'S') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vinc_adiant_lote_evento ( nr_seq_lote_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
