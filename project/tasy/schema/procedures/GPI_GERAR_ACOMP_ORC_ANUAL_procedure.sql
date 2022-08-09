-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gpi_gerar_acomp_orc_anual ( nr_seq_orcamento_p bigint, nr_ano_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_classificacao_w				varchar(40);
cd_classif_conta_w				varchar(40);
cd_classif_conta_mat_w				varchar(40);
cd_material_w				bigint;
ds_conta_w				varchar(80);
ds_estrutura_w				varchar(120);
ds_material_w				varchar(255);
dt_mes_referencia_w			timestamp;
dt_orcamento_w				timestamp;
ie_material_w				varchar(1);
nm_etapa_w				varchar(120);
nr_nivel_conta_w			bigint := 0;
nr_nivel_mat_w				bigint := 0;
nr_seq_conta_w				bigint;
nr_seq_apres_w				bigint;
nr_seq_etapa_w				bigint;
nr_seq_etapa_ww				bigint;
nr_seq_superior_w			bigint;
nr_seq_cronograma_w			bigint;
qt_registro_w				bigint;
qt_nivel_w				bigint;
vl_orcado_w				double precision;
vl_realizado_w				double precision;

c02 CURSOR FOR
SELECT	a.nr_seq_plano nr_seq_conta,
	b.ds_conta,
	coalesce(sum(CASE WHEN b.ie_operacao='S' THEN  a.vl_orcado WHEN b.ie_operacao='D' THEN (a.vl_orcado * -1) END ),0) vl_orcado,
	coalesce(sum(CASE WHEN b.ie_operacao='S' THEN  a.vl_realizado WHEN b.ie_operacao='D' THEN (a.vl_realizado * -1) END ),0) vl_realizado,
	coalesce(a.dt_mes_referencia,dt_orcamento_w) dt_mes_referencia
from	gpi_plano b,
	gpi_orc_item a
where	a.nr_seq_plano		= b.nr_sequencia
and	a.nr_seq_orcamento	= nr_seq_orcamento_p
and	b.ie_tipo			= 'A'
and	b.ie_situacao		= 'A'
and	(to_char(coalesce(a.dt_mes_referencia,dt_orcamento_w),'YYYY'))::numeric  = nr_ano_p
group by	a.nr_seq_plano,
		b.ds_conta,
		coalesce(a.dt_mes_referencia,dt_orcamento_w);

c03 CURSOR FOR
SELECT	nr_seq_etapa,
	gpi_obter_nivel_etapa(nr_seq_etapa),
	gpi_obter_classif_etapa(nr_seq_etapa),
	ds_gerencial
from	w_gpi_acomp_orcamento
where	nr_seq_orcamento	= nr_seq_orcamento_p
and	nm_usuario	= nm_usuario_p
and	coalesce(nr_seq_conta::text, '') = ''
order by 2;

c04 CURSOR FOR
SELECT	a.cd_material,
	substr(obter_desc_material(a.cd_material),1,255) ds_material,
	coalesce(sum(CASE WHEN b.ie_operacao='S' THEN  a.vl_orcado WHEN b.ie_operacao='D' THEN (a.vl_orcado * -1) END ),0) vl_orcado,
	coalesce(sum(CASE WHEN b.ie_operacao='S' THEN  a.vl_realizado WHEN b.ie_operacao='D' THEN (a.vl_realizado * -1) END ),0) vl_realizado
from	gpi_plano b,
	gpi_orc_item a
where	a.nr_seq_plano	= b.nr_sequencia
and	nr_seq_orcamento	= nr_seq_orcamento_p
and	coalesce(a.dt_mes_referencia,dt_orcamento_w) = dt_mes_referencia_w
and	nr_seq_plano	= nr_seq_conta_w
group by a.cd_material
order by 2;


BEGIN

/*limpa a tabela de acompanhamento de orcamento*/

delete from w_gpi_acomp_orcamento
where	nm_usuario	= nm_usuario_p;
commit;

select	a.dt_orcamento
into STRICT	dt_orcamento_w
from	gpi_orcamento a
where	a.nr_sequencia	= nr_seq_orcamento_p;
	
nr_nivel_conta_w	:= 0;
	
	
open c02;
loop
fetch c02 into
	nr_seq_conta_w,
	ds_conta_w,
	vl_orcado_w,
	vl_realizado_w,
	dt_mes_referencia_w;
EXIT WHEN NOT FOUND; /* apply on c02 */

	nr_nivel_conta_w	:= nr_nivel_conta_w + 1;
	cd_classif_conta_w	:= substr('001' || '.' || to_char(nr_nivel_conta_w),1,40);
	
	insert into w_gpi_acomp_orcamento(
		nr_seq_orcamento,
		nr_seq_conta,
		ds_gerencial,
		cd_classificacao,
		vl_orcado,
		dt_atualizacao,
		nm_usuario,
		nr_seq_etapa,
		vl_realizado,
		dt_mes_referencia)
	values (	nr_seq_orcamento_p,
		nr_seq_conta_w,
		substr('          ' || ds_conta_w,1,120),
		cd_classif_conta_w,
		vl_orcado_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_etapa_w,
		vl_realizado_w,
		dt_mes_referencia_w);
	
	
		nr_nivel_mat_w	:= 0;
		open C04;
		loop
		fetch C04 into	
			cd_material_w,
			ds_material_w,
			vl_orcado_w,
			vl_realizado_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			begin
			
			nr_nivel_mat_w	:= nr_nivel_mat_w + 1;
			cd_classif_conta_mat_w	:= substr(cd_classif_conta_w || '.' || to_char(nr_nivel_mat_w),1,40);
			
			insert into w_gpi_acomp_orcamento(
				nr_seq_orcamento,
				nr_seq_conta,
				ds_gerencial,
				cd_classificacao,
				vl_orcado,
				dt_atualizacao,
				nm_usuario,
				nr_seq_etapa,
				vl_realizado,
				cd_material)
			values (	nr_seq_orcamento_p,
				nr_seq_conta_w,
				substr('                ' || ds_material_w,1,120),
				cd_classif_conta_w,
				vl_orcado_w,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_etapa_w,
				vl_realizado_w,
				cd_material_w);
			end;
		end loop;
		close C04;
	
end loop;
close c02;

open c03;
loop
fetch c03 into	
	nr_seq_etapa_w,
	qt_nivel_w,
	cd_classificacao_w,
	nm_etapa_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	begin
	
	ds_estrutura_w	:= substr(lpad(' ',qt_nivel_w * 2) || nm_etapa_w,1,120);
	
	update	w_gpi_acomp_orcamento
	set	ds_gerencial		= ds_estrutura_w
	where	nr_seq_etapa		= nr_seq_etapa_w
	and	cd_classificacao	= cd_classificacao_w
	and	nr_seq_orcamento	= nr_seq_orcamento_p
	and	nm_usuario		= nm_usuario_p
	and	coalesce(nr_seq_conta::text, '') = '';
	
	end;
end loop;
close c03;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gpi_gerar_acomp_orc_anual ( nr_seq_orcamento_p bigint, nr_ano_p bigint, nm_usuario_p text) FROM PUBLIC;
