-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_escore_prazo ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_ponto_w			bigint;
qt_peso_w			bigint;
qt_escore_real_w	bigint;
pr_escore_real_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_peso_w
from	proj_cron_etapa b,
		proj_cronograma a
where	a.nr_seq_proj = nr_seq_proj_p
and		a.nr_sequencia = b.nr_seq_cronograma
and		(b.dt_fim_prev IS NOT NULL AND b.dt_fim_prev::text <> '')
and		(b.nr_seq_etapa IS NOT NULL AND b.nr_seq_etapa::text <> '')
and		coalesce(a.ie_situacao, 'A') = 'A';

select	count(*)
into STRICT	qt_ponto_w
from	proj_cron_etapa b,
		proj_cronograma a
where	a.nr_seq_proj = nr_seq_proj_p
and		a.nr_sequencia = b.nr_seq_cronograma
and		(b.dt_fim_prev IS NOT NULL AND b.dt_fim_prev::text <> '')
and (coalesce(b.dt_fim_real,clock_timestamp()) <= b.dt_fim_prev)
and		(b.nr_seq_etapa IS NOT NULL AND b.nr_seq_etapa::text <> '')
and		coalesce(a.ie_situacao, 'A') = 'A';

if (qt_peso_w >0)  then
	qt_escore_real_w	:= qt_escore_p * (qt_ponto_w / qt_peso_w);
	pr_escore_real_w	:= dividir(qt_escore_real_w * 100, qt_escore_p);
	update	proj_escore_item
	set		qt_nota_maxima	= qt_peso_w,
			qt_nota			= qt_ponto_w,
			qt_escore_real	= qt_escore_real_w,
			pr_escore_real	= pr_escore_real_w
	where	nr_sequencia	= nr_seq_item_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_escore_prazo ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) FROM PUBLIC;
