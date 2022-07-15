-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE latam_atualizar_aderencia (nr_seq_modulo_p bigint) AS $body$
DECLARE


qt_maximo_pontos_item_w		bigint;
qt_pontos_obtidos_w			bigint;
pr_aderencia_w				double precision;
qt_tempo_horas_w			bigint;
vl_custo_w					double precision;


BEGIN

select	sum(qt_maximo_pontos),
		sum(qt_pontuacao_obtida),
		sum(qt_tempo_horas),
		sum(vl_custo)
into STRICT	qt_maximo_pontos_item_w,
		qt_pontos_obtidos_w,
		qt_tempo_horas_w,
		vl_custo_w
from	latam_requisito
where	nr_seq_modulo	= nr_seq_modulo_p;

pr_aderencia_w	:= qt_pontos_obtidos_w * 100 / qt_maximo_pontos_item_w;

update	latam_modulo
set		qt_pontos_obtidos	= coalesce(qt_pontos_obtidos_w,0),
		qt_maximo_pontos	= coalesce(qt_maximo_pontos_item_w,0),
		pr_aderencia		= pr_aderencia_w,
		qt_tempo_horas		= qt_tempo_horas_w,
		vl_custo			= vl_custo_w
where	nr_sequencia		= nr_seq_modulo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE latam_atualizar_aderencia (nr_seq_modulo_p bigint) FROM PUBLIC;

