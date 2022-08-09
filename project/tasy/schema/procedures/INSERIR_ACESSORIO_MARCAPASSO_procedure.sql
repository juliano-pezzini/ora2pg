-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_acessorio_marcapasso ( ds_gerador_p text, qt_freq_magnetica_p bigint, qt_eri_p bigint, ds_eletr_atrial_p text, dt_impl_eletrodo_atrial_p timestamp, ds_eletr_ventricular_p text, dt_impl_eletr_ventricular_p timestamp, cd_profissional_p bigint ) AS $body$
DECLARE

	
nr_sequencia_w	bigint;


BEGIN
	
	select	nextval('cir_marcapasso_seq')
	into STRICT	nr_sequencia_w
	;
	
	insert into cir_marcapasso(
		nr_sequencia,
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_cirurgia, 
		ds_gerador, 
		dt_impl_gerador, 
		qt_freq_magnetica, 
		qt_eri, 
		ds_eletr_atrial, 
		dt_impl_eletrodo_atrial, 
		ds_eletr_ventricular, 
		dt_impl_eletr_ventricular, 
		cd_profissional, 
		ie_situacao
	) values (
		nr_sequencia_w,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		82753,
		ds_gerador_p,
		clock_timestamp(),
		qt_freq_magnetica_p,
		qt_eri_p,
		ds_eletr_atrial_p,
		dt_impl_eletrodo_atrial_p,
		ds_eletr_ventricular_p,
		dt_impl_eletr_ventricular_p,
		cd_profissional_p,
		'A'
	);
	
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_acessorio_marcapasso ( ds_gerador_p text, qt_freq_magnetica_p bigint, qt_eri_p bigint, ds_eletr_atrial_p text, dt_impl_eletrodo_atrial_p timestamp, ds_eletr_ventricular_p text, dt_impl_eletr_ventricular_p timestamp, cd_profissional_p bigint ) FROM PUBLIC;
