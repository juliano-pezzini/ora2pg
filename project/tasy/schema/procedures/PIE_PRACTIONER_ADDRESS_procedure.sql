-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pie_practioner_address ( nr_seq_pie_pract_p pie_practitioner.nr_sequencia%type, dt_address_edit_p pie_pract_address.dt_address_edit%type, ds_australian_locality_p pie_pract_address.ds_australian_locality%type, cd_australian_postal_p pie_pract_address.cd_australian_postal%type, cd_australian_state_p pie_pract_address.cd_australian_state%type, ds_australia_country_p pie_pract_address.ds_australia_country%type, ds_inter_province_p pie_pract_address.ds_inter_province%type, cd_inter_postal_p pie_pract_address.cd_inter_postal%type, ds_inter_country_p pie_pract_address.ds_inter_country%type ) AS $body$
DECLARE

  nr_sequencia_w     pie_pract_address.nr_sequencia%type;

BEGIN
	if (dt_address_edit_p IS NOT NULL AND dt_address_edit_p::text <> '' AND nr_seq_pie_pract_p IS NOT NULL AND nr_seq_pie_pract_p::text <> '') then

	select nextval('pie_pract_address_seq')
	into STRICT   nr_sequencia_w
	;


		insert into pie_pract_address(nr_sequencia,
		dt_address_edit,
		ds_australian_locality,
		cd_australian_postal,
		cd_australian_state,
		ds_australia_country,
		ds_inter_province,
		cd_inter_postal,
		ds_inter_country,
		nr_seq_pie_pract)
		values (nr_sequencia_w,
		dt_address_edit_p,
		ds_australian_locality_p,
		cd_australian_postal_p,
		cd_australian_state_p,
		ds_australia_country_p,
		ds_inter_province_p,
		cd_inter_postal_p,
		ds_inter_country_p,
		nr_seq_pie_pract_p );
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1088701);
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pie_practioner_address ( nr_seq_pie_pract_p pie_practitioner.nr_sequencia%type, dt_address_edit_p pie_pract_address.dt_address_edit%type, ds_australian_locality_p pie_pract_address.ds_australian_locality%type, cd_australian_postal_p pie_pract_address.cd_australian_postal%type, cd_australian_state_p pie_pract_address.cd_australian_state%type, ds_australia_country_p pie_pract_address.ds_australia_country%type, ds_inter_province_p pie_pract_address.ds_inter_province%type, cd_inter_postal_p pie_pract_address.cd_inter_postal%type, ds_inter_country_p pie_pract_address.ds_inter_country%type ) FROM PUBLIC;

