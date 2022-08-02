-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_venc_repasse ( nr_seq_repasse_p bigint, ie_gerar_tributos_p text, nm_usuario_p text) AS $body$
DECLARE


dt_base_w			timestamp;
cd_cond_pagto_w			bigint;
vl_repasse_w			double precision;
cd_estabelecimento_w		bigint;
qt_venc_w			integer;
ds_venc_w			varchar(2000);
vl_parcela_w			double precision;
dt_parcela_w			timestamp;
vl_tot_venc_w			double precision;
nr_seq_vend_venc_w		bigint;
vl_lancamento_w			double precision;

BEGIN

select	coalesce(dt_referencia,clock_timestamp()),
	a.cd_condicao_pagamento,
	pls_obter_valor_repasse(a.nr_sequencia,'R'),
	b.cd_estabelecimento
into STRICT	dt_base_w,
	cd_cond_pagto_w,
	vl_repasse_w,
	cd_estabelecimento_w
from	pls_repasse_vend a,
	pls_vendedor b
where	a.nr_seq_vendedor	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_repasse_p;

if (coalesce(cd_cond_pagto_w::text, '') = '') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(221135, null);
	/* Não foi informada a condição de pagamento do repasse! Favor informá-la no campo "Cond pgto". */

end if;

select	sum(vl_lanc_aplicado)
into STRICT	vl_lancamento_w
from	pls_repasse_lanc
where	nr_seq_repasse = nr_seq_repasse_p
and	ie_tipo_lancamento <> '5';

vl_repasse_w := vl_repasse_w + coalesce(vl_lancamento_w,0);

delete	from pls_repasse_vend_venc
where	nr_seq_repasse	= nr_seq_repasse_p;

SELECT * FROM calcular_vencimento(cd_estabelecimento_w, cd_cond_pagto_w, dt_base_w, qt_venc_w, ds_venc_w) INTO STRICT qt_venc_w, ds_venc_w;

if (qt_venc_w > 0) then
	vl_tot_venc_w		:= 0;
	vl_parcela_w		:= dividir(vl_repasse_w, qt_venc_w);

	for i in 1..qt_venc_w   loop
		dt_parcela_w	:= to_date(substr(ds_venc_w,1,10),'dd/mm/yyyy');
		ds_venc_w	:= substr(ds_venc_w,12,255);
		if (i = qt_venc_w) then
			vl_parcela_w	:= vl_repasse_w - vl_tot_venc_w;
		end if;

		select	nextval('pls_repasse_vend_venc_seq')
		into STRICT	nr_seq_vend_venc_w
		;

		insert	into	pls_repasse_vend_venc(	nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_repasse,
				dt_vencimento,
				vl_vencimento,
				nr_titulo)
			values (	nr_seq_vend_venc_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_repasse_p,
				dt_parcela_w,
				coalesce(vl_parcela_w,0),
				null);

		vl_tot_venc_w	:= vl_tot_venc_w + vl_parcela_w;
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_venc_repasse ( nr_seq_repasse_p bigint, ie_gerar_tributos_p text, nm_usuario_p text) FROM PUBLIC;

