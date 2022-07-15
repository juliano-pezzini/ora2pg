-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_comp_lote_prod_barra ( cd_material_p bigint, nr_lote_producao_p bigint, qt_material_p bigint, nm_usuario_p text, nr_seq_lote_fornec_p bigint) AS $body$
DECLARE



nr_sequencia_w		bigint;
cd_unidade_medida_w	varchar(30);
cd_local_estoque_w	smallint;
nr_seq_lote_fornec_w	bigint;
qt_existe_w		bigint;
qt_total_mat_w		double precision;
nr_seq_mat_qtde_w	bigint;
dt_validade_w		timestamp;


BEGIN

if (coalesce(nr_seq_lote_fornec_p,0) > 0) then
	nr_seq_lote_fornec_w	:= nr_seq_lote_fornec_p;
	
	select	to_date(substr(obter_dados_lote_fornec(nr_seq_lote_fornec_w,'V'),1,10),'DD/MM/YYYY')
	into STRICT	dt_validade_w
	;
	
end if;

select	count(*),
	sum(qt_prevista)
into STRICT	qt_existe_w,
	qt_total_mat_w
from	lote_producao_comp
where	nr_lote_producao	 	= nr_lote_producao_p
and	cd_material	   	= cd_material_p;

if (qt_existe_w > 0) then
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_mat_qtde_w
	from	lote_producao_comp
	where	nr_lote_producao 		= nr_lote_producao_p
	and	cd_material	   	= cd_material_p
	and	qt_prevista		= qt_material_p
	and	coalesce(nr_seq_lote_fornec::text, '') = '';
	
	if (coalesce(nr_seq_mat_qtde_w,0) > 0) then
		update	lote_producao_comp
		set	nr_seq_lote_fornec	 	= nr_seq_lote_fornec_w,
			dt_validade		= dt_validade_w
		where	nr_lote_producao 		= nr_lote_producao_p
		and	nr_sequencia		= nr_seq_mat_qtde_w
		and	coalesce(nr_seq_lote_fornec::text, '') = '';
	elsif (qt_material_p < qt_total_mat_w) and (coalesce(nr_seq_lote_fornec_w,0) > 0) then
		/*se bipei quantidade menor mas com lote fornecedor, desdobra o material*/

		select	max(cd_unidade_medida),
			max(cd_local_estoque)
		into STRICT	cd_unidade_medida_w,
			cd_local_estoque_w
		from	lote_producao_comp
		where	nr_lote_producao	 	= nr_lote_producao_p
		and	cd_material		= cd_material_p;

		update	lote_producao_comp
		set	qt_prevista		= (coalesce(qt_total_mat_w,0) - coalesce(qt_material_p,0))
		where	nr_lote_producao 		= nr_lote_producao_p
		and	cd_material	   	= cd_material_p
		and	coalesce(nr_seq_lote_fornec::text, '') = '';
		
		select	coalesce(max(nr_sequencia),0) + 1
		into STRICT	nr_sequencia_w
		from	lote_producao_comp
		where	nr_lote_producao = nr_lote_producao_p;
		
		/*gera um novo componente com a quantidade restante*/

		insert into lote_producao_comp(
				nr_lote_producao,
				nr_sequencia,
				cd_material,
				cd_unidade_medida,
				cd_local_estoque,
				dt_atualizacao,
				nm_usuario,
				qt_prevista,
				dt_validade,
				nr_seq_lote_fornec,
				qt_prevista_etq)
			values (	nr_lote_producao_p,
				nr_sequencia_w,
				cd_material_p,
				cd_unidade_medida_w,
				cd_local_estoque_w,
				clock_timestamp(),
				nm_usuario_p,
				qt_material_p,
				dt_validade_w,
				nr_seq_lote_fornec_w,
				qt_material_p);
	end if;
	end;
end if;

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_comp_lote_prod_barra ( cd_material_p bigint, nr_lote_producao_p bigint, qt_material_p bigint, nm_usuario_p text, nr_seq_lote_fornec_p bigint) FROM PUBLIC;

