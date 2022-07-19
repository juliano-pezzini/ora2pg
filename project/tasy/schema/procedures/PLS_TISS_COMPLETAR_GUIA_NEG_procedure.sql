-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_tiss_completar_guia_neg ( nr_seq_guia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_guia_w		bigint;
cont_w			bigint := 0;
nr_seq_apresentacao_w	bigint := 0;
nr_seq_apres_partic_w	bigint := 0;
ie_tiss_tipo_guia_w	varchar(2);
ds_material_w		varchar(255);
cd_material_w		bigint;
qt_autorizada_w		double precision;
qt_solicitada_w		double precision;
nr_seq_tiss_opm_w	bigint;
nr_sequencia_autor_w	bigint;

C02 CURSOR FOR
	SELECT	substr(pls_obter_desc_material(a.nr_seq_material),1,255) ds_material,
		coalesce(b.cd_material,b.nr_sequencia),
		a.qt_autorizada,
		a.qt_solicitada
	from	pls_guia_plano_mat a,
		pls_material b,
		pls_guia_plano	c
	where	a.nr_seq_material 	= b.nr_sequencia
	and	c.nr_sequencia		= a.nr_seq_guia
	and	c.nr_sequencia 		= nr_sequencia_autor_w
	and	a.ie_status		in ('M','N','K','L','S','P')
	and	coalesce(a.nr_seq_motivo_exc::text, '') = ''
	order by ds_material;


BEGIN
begin
	select	nr_sequencia_autor,
		nr_sequencia,
		ie_tiss_tipo_guia
	into STRICT	nr_sequencia_autor_w,
		nr_seq_guia_w,
		ie_tiss_tipo_guia_w
	from	w_tiss_guia
	where	nr_sequencia		= nr_seq_guia_p
	and	nm_usuario		= nm_usuario_p;
exception
when others then
ie_tiss_tipo_guia_w	:= '0';
end;

if (ie_tiss_tipo_guia_w	= '2') then
	select 	count(*)
	into STRICT 	cont_w
	from 	pls_guia_plano_mat
	where	nr_seq_guia = nr_sequencia_autor_w;

	nr_seq_apresentacao_w	:= cont_w;
	while(cont_w < 9) loop
		nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
		insert	into w_tiss_opm(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			nr_seq_apresentacao)
		values (nextval('w_tiss_opm_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			nr_seq_apresentacao_w);
		cont_w		:= cont_w + 1;
	end loop;

	nr_seq_apresentacao_w := 0;
	open C02;
	loop
	fetch C02 into
		ds_material_w,
		cd_material_w,
		qt_autorizada_w,
		qt_solicitada_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
		insert	into w_tiss_opm(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			nr_seq_apresentacao,
			ds_opm,
			cd_opm,
			qt_autorizada,
			qt_solicitada)
		values (nextval('w_tiss_opm_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			nr_seq_apresentacao_w,
			ds_material_w,
			cd_material_w,
			qt_autorizada_w,
			qt_solicitada_w);
		end;
	end loop;
	close C02;

	select	count(*)
	into STRICT	cont_w
	from	w_tiss_proc_paciente
	where	nr_seq_guia	= nr_seq_guia_w;

	nr_seq_apresentacao_w	:= cont_w;

	while(cont_w < 5) loop
		cont_w			:= cont_w + 1;
		nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
		insert	into w_tiss_proc_paciente(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia,
			nr_seq_apresentacao)
		values (nextval('w_tiss_proc_paciente_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w,
			nr_seq_apresentacao_w);
	end loop;

	select 	count(*)
		into STRICT 	cont_w
		from 	w_tiss_proc_solic
		where	nr_seq_guia = nr_seq_guia_w;

		nr_seq_apresentacao_w	:= cont_w;

		while(cont_w < 5) loop
			nr_seq_apresentacao_w	:= nr_seq_apresentacao_w + 1;
			insert	into w_tiss_proc_solic(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_guia,
				nr_seq_apresentacao)
			values (nextval('w_tiss_proc_solic_seq'),
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_guia_w,
				nr_seq_apresentacao_w);
			cont_w		:= cont_w + 1;
		end loop;

elsif (ie_tiss_tipo_guia_w = '1') then

	select	count(*)
	into STRICT	cont_w
	from	w_tiss_opm
	where	nr_seq_guia	= nr_seq_guia_w;

	while(cont_w < 5) loop
		insert	into w_tiss_opm(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_seq_guia)
		values (nextval('w_tiss_opm_seq'),
			clock_timestamp(),
			nm_usuario_p,
			nr_seq_guia_w);

		cont_w		:= cont_w + 1;
		end loop;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_tiss_completar_guia_neg ( nr_seq_guia_p bigint, nm_usuario_p text) FROM PUBLIC;

