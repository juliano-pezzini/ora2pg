-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_venc_comissao ( nr_seq_lote_p bigint, nr_seq_comissao_p bigint default null, nm_usuario_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, ie_commit_p text DEFAULT NULL, qt_sem_regra_parcelamento_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE

 
dt_base_w			timestamp;
cd_cond_pagto_w			bigint;
vl_repasse_w			double precision;
qt_venc_w			integer;
ds_venc_w			varchar(2000);
vl_parcela_w			double precision;
dt_parcela_w			timestamp;
vl_tot_venc_w			double precision;
nr_seq_canal_venda_w		bigint;
nm_canal_venda_w		varchar(255);
nr_seq_comissao_w		pls_comissao.nr_sequencia%type;
ie_possui_regra_parcelam_w 	varchar(1);
qt_sem_regra_parc_w 		integer;
ie_forma_pagamento_w		pls_vendedor.ie_forma_pagamento%type;
vl_comissao_canal_w		pls_comissao.vl_comissao_canal%type;
vl_titulo_w			pls_comissao.vl_titulo%type;
vl_folha_pag_w			pls_comissao.vl_folha_pag%type;

C01 CURSOR FOR 
	SELECT	a.nr_sequencia nr_seq_comissao, 
		coalesce(b.dt_referencia,clock_timestamp()), 
		a.vl_comissao_canal, 
		a.nr_seq_canal_venda, 
		substr(pls_obter_dados_vendedor(a.nr_seq_canal_venda, 'N'),1,255) nm_canal_venda 
	from	pls_comissao		a, 
		pls_lote_comissao	b 
	where	a.nr_seq_lote	 = b.nr_sequencia 
	and	((b.nr_sequencia = nr_seq_lote_p and coalesce(nr_seq_comissao_p::text, '') = '') or (a.nr_sequencia = nr_seq_comissao_p)) 
	and	vl_comissao_canal > 0;

BEGIN 
 
if (nr_seq_comissao_p IS NOT NULL AND nr_seq_comissao_p::text <> '') then 
	delete	from pls_comissao_titulo 
	where	nr_seq_comissao = nr_seq_comissao_p;
end if;
 
qt_sem_regra_parc_w := 0;
 
open C01;
loop 
fetch C01 into	 
	nr_seq_comissao_w, 
	dt_base_w, 
	vl_repasse_w, 
	nr_seq_canal_venda_w, 
	nm_canal_venda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	select	coalesce(ie_forma_pagamento,'T') 
	into STRICT	ie_forma_pagamento_w 
	from	pls_vendedor 
	where	nr_sequencia = nr_seq_canal_venda_w;
	 
	if (ie_forma_pagamento_w = 'T') then -- Título a pagar 
		select	max(cd_condicao_pagamento) 
		into STRICT	cd_cond_pagto_w 
		from	pls_vendedor_regra_pag 
		where	nr_seq_vendedor	= nr_seq_canal_venda_w 
		and	vl_repasse_w between coalesce(vl_comissao_inicial,vl_repasse_w) and coalesce(vl_comissao_final,vl_repasse_w);
		 
		ie_possui_regra_parcelam_w := 'S';
		 
		if (coalesce(cd_cond_pagto_w::text, '') = '') then		 
			ie_possui_regra_parcelam_w := 'N';
			qt_sem_regra_parc_w := qt_sem_regra_parc_w + 1;
 
			update	pls_comissao 
			set	ie_regra_parcelamento = 'N' 
			where	nr_sequencia = nr_seq_comissao_w;
		end if;	
		 
		if (ie_possui_regra_parcelam_w = 'S') then	 
			delete from pls_comissao_titulo 
			where  nr_seq_comissao	= nr_seq_comissao_w;
			 
			SELECT * FROM calcular_vencimento(cd_estabelecimento_p, cd_cond_pagto_w, dt_base_w, qt_venc_w, ds_venc_w) INTO STRICT qt_venc_w, ds_venc_w;
			 
			if (qt_venc_w > 0) then 
				vl_tot_venc_w      := 0;
				vl_parcela_w      := dividir(vl_repasse_w, qt_venc_w);
					 
				for i in 1..qt_venc_w  loop 
					dt_parcela_w  := to_date(substr(ds_venc_w,1,10),'dd/mm/yyyy');
					ds_venc_w        := substr(ds_venc_w,12,255);
					if (i = qt_venc_w) then 
						vl_parcela_w  := vl_repasse_w - vl_tot_venc_w;
					end if;
						 
					insert	into	pls_comissao_titulo(	nr_sequencia, 
							dt_atualizacao, 
							nm_usuario, 
							dt_atualizacao_nrec, 
							nm_usuario_nrec, 
							cd_estabelecimento, 
							nr_seq_comissao, 
							dt_vencimento, 
							vl_titulo) 
						values (	nextval('pls_comissao_titulo_seq'), 
							clock_timestamp(), 
							nm_usuario_p, 
							clock_timestamp(), 
							nm_usuario_p, 
							cd_estabelecimento_p, 
							nr_seq_comissao_w, 
							dt_parcela_w, 
							coalesce(vl_parcela_w,0));
							 
					vl_tot_venc_w	:= vl_tot_venc_w + vl_parcela_w;
				end loop;
			end if;
		end if;
	elsif (ie_forma_pagamento_w = 'F') then -- Folha de pagamento 
		insert	into	pls_comissao_titulo(	nr_sequencia, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_estabelecimento, 
				nr_seq_comissao, 
				vl_folha_pag) 
			values (	nextval('pls_comissao_titulo_seq'), 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_estabelecimento_p, 
				nr_seq_comissao_w, 
				vl_repasse_w);	
	end if;
	 
	CALL pls_gerar_totais_comissao(nr_seq_comissao_w);	
	end;
end loop;
close C01;
 
qt_sem_regra_parcelamento_p := qt_sem_regra_parc_w;
 
select	sum(vl_comissao_canal), 
	sum(vl_titulo), 
	sum(vl_folha_pag) 
into STRICT	vl_comissao_canal_w, 
	vl_titulo_w, 
	vl_folha_pag_w 
from	pls_comissao 
where	nr_seq_lote = nr_seq_lote_p;
 
update	pls_lote_comissao 
set	dt_geracao 	= clock_timestamp(), 
	vl_comissao	= coalesce(vl_comissao_canal_w,0), 
	vl_titulo	= coalesce(vl_titulo_w,0), 
	vl_folha_pag	= coalesce(vl_folha_pag_w,0) 
where	nr_sequencia = nr_seq_lote_p;
 
if (ie_commit_p = 'S') then	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_venc_comissao ( nr_seq_lote_p bigint, nr_seq_comissao_p bigint default null, nm_usuario_p text DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, ie_commit_p text DEFAULT NULL, qt_sem_regra_parcelamento_p INOUT bigint DEFAULT NULL) FROM PUBLIC;

