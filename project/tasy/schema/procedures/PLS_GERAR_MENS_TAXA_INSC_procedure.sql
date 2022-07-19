-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_mens_taxa_insc ( nr_seq_mensalidade_seg_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_segurado_w		bigint;
nr_seq_contrato_w		bigint;
nr_parcela_segurado_w		integer;
dt_mesano_referencia_w		timestamp;
ie_taxa_inscricao_w		varchar(1);
vl_inscricao_w			double precision;
tx_inscricao_w			double precision;
dt_rescisao_w			timestamp;
nr_seq_plano_w			bigint;
nr_seq_subestipulante_w		bigint;
nr_seq_subestipulante_ww	bigint;
nr_seq_regra_w			bigint;
ie_acao_contrato_w		varchar(2);
qt_taxa_inscricao_w		bigint;
qt_registros_w			bigint;
nr_seq_intercambio_w		bigint;
nr_seq_pagador_w		bigint;
qt_pagador_princ_w		bigint;
nr_seq_item_mensalidade_w	pls_mensalidade_seg_item.nr_sequencia%type;


BEGIN

nr_seq_segurado_w		:= pls_store_data_mens_pck.get_nr_seq_segurado;
nr_seq_contrato_w		:= pls_store_data_mens_pck.get_nr_seq_contrato;
nr_parcela_segurado_w		:= pls_store_data_mens_pck.get_nr_parcela;
dt_mesano_referencia_w		:= pls_store_data_mens_pck.get_dt_mesano_referencia;
ie_taxa_inscricao_w		:= pls_store_data_mens_pck.get_ie_taxa_inscricao;
dt_rescisao_w			:= pls_store_data_mens_pck.get_dt_rescisao;
nr_seq_plano_w			:= pls_store_data_mens_pck.get_nr_seq_plano;
nr_seq_subestipulante_w		:= pls_store_data_mens_pck.get_nr_seq_subestipulante;
ie_acao_contrato_w		:= pls_store_data_mens_pck.get_ie_acao_contrato;
nr_seq_intercambio_w		:= pls_store_data_mens_pck.get_nr_seq_intercambio;
nr_seq_pagador_w		:= pls_store_data_mens_pck.get_nr_seq_pagador;

select	count(*)
into STRICT	qt_pagador_princ_w
from	pls_contrato_pagador
where	nr_seq_pagador_compl = nr_seq_pagador_w;

if (qt_pagador_princ_w = 0) then
	select	count(*)
	into STRICT	qt_registros_w
	from	pls_mensalidade_seg_item	a,
		pls_mensalidade_segurado	b,
		pls_mensalidade			c
	where	a.nr_seq_mensalidade_seg	= b.nr_sequencia
	and	b.nr_seq_mensalidade		= c.nr_sequencia
	and	coalesce(c.ie_cancelamento::text, '') = ''
	and	a.ie_tipo_item	= '2'
	and	b.nr_seq_segurado		= nr_seq_segurado_w
	and	b.dt_mesano_referencia	= dt_mesano_referencia_w;


	if (qt_registros_w	= 0) then
		SELECT * FROM pls_obter_taxa_inscricao(nr_seq_segurado_w, nr_seq_contrato_w, nr_seq_intercambio_w, nr_seq_plano_w, null, nr_parcela_segurado_w, dt_mesano_referencia_w, nr_seq_subestipulante_w, ie_acao_contrato_w, nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w) INTO STRICT nr_seq_regra_w, vl_inscricao_w, tx_inscricao_w;

		/*open c01;
		loop
		fetch c01 into
			nr_seq_regra_w,
			vl_inscricao_w,
			tx_inscricao_w,
			nr_seq_subestipulante_ww;
		exit when c01%notfound;
		end loop;
		close c01;*/
		if (coalesce(tx_inscricao_w,0) > 0) then
			select	coalesce(sum(vl_item),0)
			into STRICT	vl_inscricao_w
			from	pls_mensalidade_seg_item
			where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_p
			and	ie_tipo_item		in ('1','25');

			vl_inscricao_w	:= dividir_sem_round((vl_inscricao_w * tx_inscricao_w)::numeric,100);
		end if;

		select	count(*)
		into STRICT	qt_taxa_inscricao_w
		from	pls_mensalidade_seg_item
		where	nr_seq_mensalidade_seg	= nr_seq_mensalidade_seg_p
		and	ie_tipo_item	= '2';

		if (coalesce(vl_inscricao_w,0) > 0) and
			((trunc(dt_mesano_referencia_w,'dd') < trunc(dt_rescisao_w,'dd')) or (coalesce(dt_rescisao_w::text, '') = '')) and (coalesce(qt_taxa_inscricao_w,0) = 0) then

			nr_seq_item_mensalidade_w := null;

			nr_seq_item_mensalidade_w := pls_insert_mens_seg_item('2', nm_usuario_p, null, null, null, null, null, null, null, 'N', null, null, null, null, null, null, null, nr_seq_mensalidade_seg_p, null, null, null, null, null, null, null, null, null, null, null, null, null, vl_inscricao_w, nr_seq_item_mensalidade_w);
		end if;
	end if;
end if;
/* Não pode dar commit */

--commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_mens_taxa_insc ( nr_seq_mensalidade_seg_p bigint, nm_usuario_p text) FROM PUBLIC;

