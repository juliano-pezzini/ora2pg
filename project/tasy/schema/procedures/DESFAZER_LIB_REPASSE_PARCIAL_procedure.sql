-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_lib_repasse_parcial (nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint) AS $body$
DECLARE


nr_seq_material_w			bigint;
nr_seq_procedimento_w		bigint;
vl_original_repasse_w		double precision;

c01 CURSOR FOR
SELECT	a.nr_sequencia
from	procedimento_repasse a
where	a.nr_seq_origem	= nr_seq_proc_repasse_p;

c02 CURSOR FOR
SELECT	b.nr_sequencia
from	material_repasse b
where	b.nr_seq_origem	= nr_seq_mat_repasse_p;


BEGIN

if (coalesce(nr_seq_proc_repasse_p,0) > 0) then

	select	max(a.vl_original_repasse)
	into STRICT	vl_original_repasse_w
	from	procedimento_repasse a
	where	a.nr_sequencia	= nr_seq_proc_repasse_p;

	if (coalesce(vl_original_repasse_w::text, '') = '') then
		--r.aise_application_error(-20011, 'Valor original não encontrado!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266523);
	end if;

	update	procedimento_repasse
	set	ie_status			= 'A',
		vl_repasse		= vl_original_repasse_w,
		vl_liberado		= 0,
		dt_liberacao		 = NULL,
		nr_seq_ret_glosa		 = NULL,
		nr_seq_item_retorno	 = NULL
	where	nr_sequencia		= nr_seq_proc_repasse_p;

	open c01;
	loop
	fetch c01 into
		nr_seq_procedimento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		delete	from procedimento_repasse
		where	nr_sequencia	= nr_seq_procedimento_w;

	end loop;
	close c01;

elsif (coalesce(nr_seq_mat_repasse_p,0) > 0) then

	select	max(a.vl_original_repasse)
	into STRICT	vl_original_repasse_w
	from	material_repasse a
	where	a.nr_sequencia	= nr_seq_mat_repasse_p;

	if (coalesce(vl_original_repasse_w::text, '') = '') then
		--r.aise_application_error(-20011, 'Valor original não encontrado!');
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266523);
	end if;

	update	material_repasse
	set	ie_status			= 'A',
		vl_repasse		= vl_original_repasse_w,
		vl_liberado		= 0,
		dt_liberacao		 = NULL,
		nr_seq_ret_glosa		 = NULL,
		nr_seq_item_retorno	 = NULL
	where	nr_sequencia		= nr_seq_mat_repasse_p;

	open c02;
	loop
	fetch c02 into
		nr_seq_material_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */

		delete	from material_repasse
		where	nr_sequencia	= nr_seq_material_w;

	end loop;
	close c02;

end if;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_lib_repasse_parcial (nr_seq_proc_repasse_p bigint, nr_seq_mat_repasse_p bigint) FROM PUBLIC;

