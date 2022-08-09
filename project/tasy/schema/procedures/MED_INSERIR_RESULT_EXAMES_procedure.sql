-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_inserir_result_exames (cd_medico_p text, nr_ficha_p text, dt_resultado_p timestamp, vl_col_p bigint, vl_hdl_p bigint, vl_ldl_p bigint, vl_trigl_p bigint, vl_gli_p bigint, vl_ac_utico_p bigint, vl_creat_p bigint, vl_k_p bigint, vl_na_p bigint, vl_ca_p bigint, vl_mg_p bigint, vl_t3_p bigint, vl_t4_p bigint, vl_tsh_p bigint, vl_cpk_p bigint, vl_cpkmb_p bigint, vl_tgo_p bigint, vl_dlh_p bigint, vl_gv_p bigint, vl_hb_p bigint, vl_ht_p bigint, vl_gb_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_exame_w		bigint;
nr_seq_resultado_w	bigint;
nr_seq_cliente_w	bigint;


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_cliente_w
from	med_cliente
where	cd_medico		= cd_medico_p
and	cd_pessoa_sist_orig	= nr_ficha_p;


if (vl_col_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'COL', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_col_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_hdl_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'HDL', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_hdl_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_ldl_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'LDL', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_ldl_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_trigl_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'TRIGL', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_trigl_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;


if (vl_gli_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'GLI', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_gli_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_ac_utico_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'AC UTICO', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_ac_utico_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_creat_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'CREAT', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_creat_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_k_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'K', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_k_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_na_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'NA', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_na_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;


if (vl_ca_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'CA', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_ca_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_mg_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'MG', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_mg_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_t3_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'T3', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_t3_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_t4_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'T4', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_t4_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;


if (vl_tsh_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'TSH', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;


		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_tsh_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_cpk_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'CPK', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_cpk_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_cpkmb_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'CPKMB', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_cpkmb_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_tgo_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'TGO', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin


		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_tgo_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_gv_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'GV', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_gv_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_dlh_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'DLH', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_dlh_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_hb_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'HB', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_hb_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;


if (vl_ht_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'HT', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_ht_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

if (vl_gb_p	<> 0) then
	begin

	nr_seq_exame_w := Med_Incluir_Exame_Padrao(cd_medico_p, 'GB', nm_usuario_p, nr_seq_exame_w);


	if (nr_seq_exame_w <> 0) then
		begin

		delete	from med_result_exame
		where	nr_seq_exame	= nr_seq_exame_w
		and	nr_seq_cliente	= nr_seq_cliente_w
		and	dt_exame	= dt_resultado_p;

		select	nextval('med_result_exame_seq')
		into STRICT	nr_seq_resultado_w
		;

		insert	into med_result_exame(nr_sequencia,
			nr_seq_exame,
			dt_exame,
			dt_atualizacao,
			nm_usuario,
			vl_exame,
			nr_seq_cliente)
		values (nr_seq_resultado_w,
			nr_seq_exame_w,
			dt_resultado_p,
			clock_timestamp(),
			nm_usuario_p,
			vl_gb_p,
			nr_seq_cliente_w);

		end;
	end if;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_inserir_result_exames (cd_medico_p text, nr_ficha_p text, dt_resultado_p timestamp, vl_col_p bigint, vl_hdl_p bigint, vl_ldl_p bigint, vl_trigl_p bigint, vl_gli_p bigint, vl_ac_utico_p bigint, vl_creat_p bigint, vl_k_p bigint, vl_na_p bigint, vl_ca_p bigint, vl_mg_p bigint, vl_t3_p bigint, vl_t4_p bigint, vl_tsh_p bigint, vl_cpk_p bigint, vl_cpkmb_p bigint, vl_tgo_p bigint, vl_dlh_p bigint, vl_gv_p bigint, vl_hb_p bigint, vl_ht_p bigint, vl_gb_p bigint, nm_usuario_p text) FROM PUBLIC;
