-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aplicar_reajuste_regra_pagto ( cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_contrato_w		bigint;
nr_seq_regra_pagto_w		bigint;
ie_periodo_reajuste_w		varchar(15);
dt_final_vigencia_w		timestamp;
dt_inicio_vigencia_w		timestamp;
vl_pagto_w			double precision;
vl_pagto_reajustado_w		double precision;
qt_indice_reajuste_w		double precision;


c01 CURSOR FOR
SELECT	nr_sequencia
from	contrato
where	ie_situacao = 'A'
and	PKG_DATE_UTILS.start_of(coalesce(dt_fim,clock_timestamp()), 'dd', 0) >= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)
and	cd_estabelecimento = cd_estabelecimento_p;

c02 CURSOR FOR
SELECT	nr_sequencia,
	ie_periodo_reajuste,
	dt_final_vigencia,
	vl_pagto,
	qt_indice_reajuste
from	contrato_regra_pagto
where	nr_seq_contrato = nr_seq_contrato_w
and	coalesce(vl_pagto,0) > 0
and	coalesce(qt_indice_reajuste,0) > 0
and	coalesce(dt_final_vigencia::text, '') = ''
and	dt_inicio_vigencia = PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0);


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_contrato_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	open c02;
	loop
	fetch c02 into
		nr_seq_regra_pagto_w,
		ie_periodo_reajuste_w,
		dt_final_vigencia_w,
		vl_pagto_w,
		qt_indice_reajuste_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin

		vl_pagto_reajustado_w	:= vl_pagto_w + ((vl_pagto_w * qt_indice_reajuste_w)/100);

		insert into contrato_regra_hist(
			nr_sequencia,
			nr_seq_regra,
			dt_atualizacao,
			nm_usuario,
			ie_forma,
			dt_primeiro_vencto,
			ie_tipo_valor,
			vl_pagto,
			cd_moeda,
			cd_indice_reajuste,
			ie_periodo_reajuste,
			dt_historico,
			dt_inicio_vigencia,
			dt_final_vigencia,
			ds_observacao,
			qt_indice_reajuste,
			ds_ref_indice_reajuste,
			ds_regra_vencimento)
		SELECT	nextval('contrato_regra_hist_seq'),
			nr_seq_regra_pagto_w,
			clock_timestamp(),
			nm_usuario_p,
			ie_forma,
			dt_primeiro_vencto,
			ie_tipo_valor,
			vl_pagto,
			cd_moeda,
			cd_indice_reajuste,
			ie_periodo_reajuste,
			clock_timestamp(),
			dt_inicio_vigencia,
			dt_final_vigencia,
			wheb_mensagem_pck.get_texto(310350),
			qt_indice_reajuste,
			ds_ref_indice_reajuste,
			ds_regra_vencimento
		from	contrato_regra_pagto
		where	nr_sequencia = nr_seq_regra_pagto_w;

		if (ie_periodo_reajuste_w = 'A') then
			dt_inicio_vigencia_w	:= PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(), 12, 0);
		elsif (ie_periodo_reajuste_w = 'T') then
			dt_inicio_vigencia_w	:= PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(), 3, 0);
		elsif (ie_periodo_reajuste_w = 'M') then
			dt_inicio_vigencia_w	:= PKG_DATE_UTILS.ADD_MONTH(clock_timestamp(), 1, 0);
		end if;

		update	contrato_regra_pagto
		set	dt_inicio_vigencia	= dt_inicio_vigencia_w,
			vl_pagto		= vl_pagto_reajustado_w
		where	nr_sequencia	= nr_seq_regra_pagto_w;

		end;
	end loop;
	close c02;

	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aplicar_reajuste_regra_pagto ( cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

