-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE campos AS (	vl_orc	double precision);


CREATE OR REPLACE PROCEDURE ctb_gerar_cen_forecast ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nr_seq_mes_ref_p bigint, nm_usuario_p text, ie_regra_ticket_p text, ie_regra_valor_p text) AS $body$
DECLARE

type reg_campos is table of campos index by integer;

cd_conta_contabil_w			varchar(20);
cd_empresa_w				bigint;
dt_inicial_w				timestamp;
dt_final_w				timestamp;
dt_referencia_w				timestamp;
dt_ref_valor_w				timestamp;
ie_orc_real_w				varchar(1);
nr_mes_w				bigint;
nr_seq_mes_ref_w			bigint;
nr_sequencia_w				bigint;
qt_registro_w				bigint;
valor_w					reg_campos;
vl_orcado_w				double precision;

c01 CURSOR FOR
SELECT	y.nr_mes,
	y.nr_sequencia,
	y.dt_referencia
from (
	SELECT	a.nr_sequencia,
		a.dt_referencia,
		somente_numero(to_char(a.dt_referencia, 'mm')) nr_mes
	from	ctb_mes_ref a
	where	a.cd_empresa	= cd_empresa_w
	and	a.dt_referencia between dt_inicial_w and dt_final_w
	order by 2) y
where	1 = 1
order by nr_mes;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_conta_contabil
from	ctb_orc_cen_valor_linear a
where	a.nr_seq_cenario		= nr_seq_cenario_p
and	a.cd_estabelecimento		= cd_estabelecimento_p
and	a.cd_centro_custo		= cd_centro_custo_p
and (coalesce(ie_regra_ticket_p,'N') = 'S' and not exists ( select 1
						  from 	ctb_regra_ticket_medio x
						  where	nr_seq_cenario = nr_seq_cenario_p
						  and	x.cd_conta_contabil = a.cd_conta_contabil) or (ie_regra_ticket_p = 'N'))
and (coalesce(ie_regra_valor_p,'N') = 'S' and not exists ( select 1
						  from 	ctb_orc_cen_regra x
						  where	x.nr_seq_cenario = nr_seq_cenario_p
						  and	x.cd_conta_contabil = a.cd_conta_contabil
						  and   coalesce(x.cd_centro_custo::text, '') = '') or (ie_regra_valor_p = 'N'));


BEGIN

select	dt_referencia,
	cd_empresa
into STRICT	dt_ref_valor_w,
	cd_empresa_w
from	ctb_mes_ref
where	nr_sequencia	= nr_seq_mes_ref_p;

select	ctb_obter_mes_ref(nr_seq_mes_inicio),
	ctb_obter_mes_ref(nr_seq_mes_fim)
into STRICT	dt_inicial_w,
	dt_final_w
from	ctb_orc_cenario
where	nr_sequencia	= nr_seq_cenario_p;

dt_inicial_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_inicial_w, -12, 0);
dt_final_w	:= PKG_DATE_UTILS.ADD_MONTH(dt_final_w, -12, 0);

select	count(*)
into STRICT	qt_registro_w
from	ctb_orc_cen_valor_linear
where	nr_seq_cenario		= nr_seq_cenario_p
and	cd_estabelecimento	= cd_estabelecimento_p
and	cd_centro_custo		= cd_centro_custo_p;

if (qt_registro_w = 0) then
	CALL ctb_gerar_contas_cen_linear(nr_seq_cenario_p, cd_estabelecimento_p, cd_centro_custo_p, nm_usuario_p);
end if;

open C02;
loop
fetch C02 into
	nr_sequencia_w,
	cd_conta_contabil_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin

	for nr_mes_w in 1..12 loop
		begin
		valor_w[nr_mes_w].vl_orc	:= 0;
		end;
	end loop;

	vl_orcado_w	:= 0;
	open C01;
	loop
	fetch C01 into
		nr_mes_w,
		nr_seq_mes_ref_w,
		dt_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ie_orc_real_w	:= 'R';

		if (dt_referencia_w > dt_ref_valor_w) then
			ie_orc_real_w	:= 'O';
		end if;

		select	coalesce(max(CASE WHEN ie_orc_real_w='O' THEN a.vl_orcado WHEN ie_orc_real_w='R' THEN  a.vl_realizado END ),0)
		into STRICT	vl_orcado_w
		from	ctb_orcamento a
		where	cd_estabelecimento	= cd_estabelecimento_p
		and	nr_seq_mes_ref		= nr_seq_mes_ref_w
		and	cd_centro_custo		= cd_centro_custo_p
		and	cd_conta_contabil	= cd_conta_contabil_w;

		valor_w[nr_mes_w].vl_orc	:= vl_orcado_w;
		end;
	end loop;
	close C01;

	update	ctb_orc_cen_valor_linear
	set	vl_orcado_1	= valor_w[01].vl_orc,
		vl_orcado_2	= valor_w[02].vl_orc,
		vl_orcado_3	= valor_w[03].vl_orc,
		vl_orcado_4	= valor_w[04].vl_orc,
		vl_orcado_5	= valor_w[05].vl_orc,
		vl_orcado_6	= valor_w[06].vl_orc,
		vl_orcado_7	= valor_w[07].vl_orc,
		vl_orcado_8	= valor_w[08].vl_orc,
		vl_orcado_9	= valor_w[09].vl_orc,
		vl_orcado_10	= valor_w[10].vl_orc,
		vl_orcado_11	= valor_w[11].vl_orc,
		vl_orcado_12	= valor_w[12].vl_orc,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_sequencia	= nr_sequencia_w;

	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_cen_forecast ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, nr_seq_mes_ref_p bigint, nm_usuario_p text, ie_regra_ticket_p text, ie_regra_valor_p text) FROM PUBLIC;
