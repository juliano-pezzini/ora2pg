-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_baca_gerar_mat_uni_val () AS $body$
DECLARE


tb_nm_usuario_w			pls_util_cta_pck.t_varchar2_table_20;
tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
tb_vl_max_consumidor_w		pls_util_cta_pck.t_number_table;
tb_dt_inicio_vigencia_val_w	pls_util_cta_pck.t_date_table;

C01 CURSOR FOR
	SELECT	m.nm_usuario,
		m.nr_sequencia,
		m.vl_max_consumidor,
		m.dt_inicio_vigencia_val
	from	pls_material_unimed m
	where	(m.dt_inicio_vigencia_val IS NOT NULL AND m.dt_inicio_vigencia_val::text <> '')
	and	m.vl_max_consumidor > 0
	and	not exists (	SELECT	1
				from	pls_material_uni_val x
				where	x.nr_seq_mat_unimed = m.nr_sequencia);


BEGIN

open C01;
loop
fetch C01 bulk collect into tb_nm_usuario_w, tb_nr_sequencia_w, tb_vl_max_consumidor_w, tb_dt_inicio_vigencia_val_w
limit pls_util_pck.qt_registro_transacao_w;
exit when tb_nr_sequencia_w.count = 0;

	forall  i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		insert into pls_material_uni_val(nr_sequencia,				dt_atualizacao,		nm_usuario,
			dt_atualizacao_nrec,			nm_usuario_nrec,	nr_seq_mat_unimed,
			vl_max_consumidor,			dt_inicio_vigencia)
		values (nextval('pls_material_uni_val_seq'),	clock_timestamp(),		tb_nm_usuario_w(i),
			clock_timestamp(),				tb_nm_usuario_w(i),	tb_nr_sequencia_w(i),
			tb_vl_max_consumidor_w(i),		tb_dt_inicio_vigencia_val_w(i));
		commit;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_baca_gerar_mat_uni_val () FROM PUBLIC;

