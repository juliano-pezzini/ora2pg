-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_gerar_escore_cliente ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_ponto_w			bigint;
qt_peso_w			bigint;
qt_escore_real_w			bigint;
pr_escore_real_w			bigint;


BEGIN

select	sum(b.qt_peso) qt_peso,
	sum(c.qt_peso) qt_ponto
into STRICT	qt_peso_w,
	qt_ponto_w
from	proj_aval_opcao c,
	proj_avaliacao b,
	proj_avaliacao_quesito a
where	a.nr_seq_escore_item	= nr_seq_item_p
and	a.nr_seq_avaliacao		= b.nr_sequencia
and	b.nr_sequencia		= c.nr_seq_avaliacao
and	c.nr_sequencia		= a.nr_seq_opcao;


if (qt_peso_w >0)  then
	qt_escore_real_w		:= qt_escore_p * (qt_ponto_w / qt_peso_w);
	pr_escore_real_w		:= dividir(qt_escore_real_w * 100, qt_escore_p);
	update	proj_escore_item
	set	qt_nota_maxima	= qt_peso_w,
		qt_nota		= qt_ponto_w,
		qt_escore_real	= qt_escore_real_w,
		pr_escore_real	= pr_escore_real_w
	where	nr_sequencia	= nr_seq_item_p;
end if;

/*Raise_application_error(-20011,'proj_gerar_escore_cliente#@#@');*/

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_gerar_escore_cliente ( nr_seq_item_p bigint, nr_seq_proj_p bigint, qt_escore_p bigint, nm_usuario_p text) FROM PUBLIC;

