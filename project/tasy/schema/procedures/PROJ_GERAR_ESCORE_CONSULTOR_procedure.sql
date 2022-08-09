-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_escore_consultor ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_ponto_w			bigint;
qt_peso_w			bigint;
nr_seq_cliente_w	bigint;
dt_inicio_real_w	timestamp;
dt_fim_real_w		timestamp;
qt_escore_real_w	double precision;
pr_escore_real_w	double precision;


BEGIN

select	nr_seq_cliente,
		coalesce(dt_inicio_real, dt_inicio_prev),
		coalesce(dt_fim_real, clock_timestamp())
into STRICT	nr_seq_cliente_w,
		dt_inicio_real_w,
		dt_fim_real_w
from	proj_projeto
where	nr_sequencia = nr_seq_proj_p;

select	coalesce(sum(c.qt_peso),0) qt_peso,
		coalesce(sum(round(b.qt_ponto/2)),0) qt_ponto
into STRICT	qt_peso_w,
		qt_ponto_w
from	proj_avaliacao c,
		proj_consultor_aval_quesito b,
		proj_consultor_aval a
where	a.nr_seq_cliente = nr_seq_cliente
and		a.nr_sequencia = b.nr_seq_avaliacao
and		b.nr_seq_quesito = c.nr_sequencia
and		a.nr_seq_cliente = nr_seq_cliente_w
and		c.ie_tipo_avaliacao = 2
and		a.dt_avaliacao between dt_inicio_real_w and dt_fim_real_w;

if (qt_peso_w > 0)  then
	qt_escore_real_w := qt_escore_p * (qt_ponto_w / qt_peso_w);
	pr_escore_real_w := dividir(qt_escore_real_w * 100, qt_escore_p);

	update	proj_escore_item
	set		qt_nota_maxima	= qt_peso_w,
			qt_nota			= qt_ponto_w,
			qt_escore_real	= qt_escore_real_w,
			pr_escore_real	= pr_escore_real_w
	where	nr_sequencia	= nr_seq_item_p;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_escore_consultor ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) FROM PUBLIC;
