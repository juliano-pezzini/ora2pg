-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aliment_dt_ref_cam_cong () AS $body$
DECLARE


tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_dt_inicio_vig_w	pls_util_cta_pck.t_date_table;
tb_dt_fim_vig_w		pls_util_cta_pck.t_date_table;

C01 CURSOR FOR
	SELECT	nr_sequencia,
		pls_util_pck.obter_dt_vigencia_null( dt_inicio_vigencia, 'I'),
		pls_util_pck.obter_dt_vigencia_null( dt_fim_vigencia, 'F')
	from	pls_congenere_camara
	where	coalesce(dt_inicio_vigencia_ref::text, '') = '';


BEGIN

Open C01;
loop
	fetch C01 bulk collect into tb_nr_sequencia_w, tb_dt_inicio_vig_w, tb_dt_fim_vig_w
	limit 500;

	exit when tb_nr_sequencia_w.count = 0;

	forall i in tb_nr_sequencia_w.first .. tb_nr_sequencia_w.last
		update	pls_congenere_camara
		set	dt_inicio_vigencia_ref = tb_dt_inicio_vig_w(i),
			dt_fim_vigencia_ref = tb_dt_fim_vig_w(i)
		where	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end loop;
close c01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aliment_dt_ref_cam_cong () FROM PUBLIC;

