-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_alterar_qtd_producao (nr_seq_item_p bigint, qt_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_anterior_w		double precision;
pr_dose_deriv_w		double precision;
nr_seq_deriv_prod_w	bigint;

C01 CURSOR FOR
	SELECT	a.pr_dose,
		a.nr_sequencia
	from	nut_producao_lac_item_adic a
	where	a.nr_Seq_prod_item	= nr_seq_item_p;


BEGIN

select	qt_dose
into STRICT	qt_anterior_w
from	nut_producao_lactario_item
where	nr_sequencia = nr_seq_item_p;

update	nut_producao_lactario_item
set	qt_dose		= qt_novo_p
where	nr_sequencia 	= nr_seq_item_p;

open C01;
loop
fetch C01 into
	pr_dose_deriv_w,
	nr_seq_deriv_prod_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	update	nut_producao_lac_item_adic
	set	qt_dose		= (pr_dose_deriv_w * qt_novo_p)/100
	where	nr_sequencia 	= nr_seq_deriv_prod_w;

	end;
end loop;
close C01;

insert into nut_prod_alt_item(NR_SEQUENCIA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				DT_ATUALIZACAO_NREC,
				NM_USUARIO_NREC,
				DT_ALTERACAO,
				QT_ANTERIOR,
				QT_ATUAL,
				NR_SEQ_NUT_PROD_LAC_ITEM)
			values (nextval('nut_prod_alt_item_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				qt_anterior_w,
				qt_novo_p,
				nr_seq_item_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_alterar_qtd_producao (nr_seq_item_p bigint, qt_novo_p bigint, nm_usuario_p text) FROM PUBLIC;

