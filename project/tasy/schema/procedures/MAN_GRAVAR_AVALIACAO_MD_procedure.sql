-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gravar_avaliacao_md ( nr_seq_ordem_serv_p bigint, nr_customer_requirement_p bigint, ie_potential_harmed_p text, ds_potential_harmed_p text, ie_potencial_safety_p text, ds_potencial_safety_p text, ie_severity_harm_p text, ie_probability_harm_p text, nm_user_safety_p text, nm_usuario_p text) AS $body$
DECLARE


	alterou_info_w 		varchar(1);

BEGIN

if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') then
	
	select 	coalesce(max('N'), 'S') alterou_info
	into STRICT 	alterou_info_w
	from 	man_ordem_servico
	where 	nr_sequencia = nr_seq_ordem_serv_p
	and 	coalesce(nr_customer_requirement, 0) 	= coalesce(nr_customer_requirement_p, 0)
	and 	coalesce(ie_potential_harmed, 'X') 		= coalesce(ie_potential_harmed_p, 'X')
	and 	coalesce(ds_potential_harmed, 'X') 		= coalesce(ds_potential_harmed_p, 'X')
	and 	coalesce(ie_potencial_safety, 'X') 		= coalesce(ie_potencial_safety_p, 'X')
	and 	coalesce(ds_potencial_safety, 'X') 		= coalesce(ds_potencial_safety_p, 'X')
	and 	coalesce(ie_severity_harm, 'X') 		= coalesce(ie_severity_harm_p, 'X')
	and 	coalesce(ie_probability_harm, 'X') 		= coalesce(ie_probability_harm_p, 'X');
	
	if (alterou_info_w = 'S') then
		
		update 	man_ordem_servico
		set 	nr_customer_requirement 	= nr_customer_requirement_p,
			ie_potential_harmed 	= ie_potential_harmed_p,
			ds_potential_harmed 	= ds_potential_harmed_p,
			ie_potencial_safety 		= ie_potencial_safety_p,
			ds_potencial_safety 	= ds_potencial_safety_p,
			ie_severity_harm 		= ie_severity_harm_p,
			ie_probability_harm 		= ie_probability_harm_p,
			nm_user_safety 		= nm_user_safety_p,
			dt_release_safety 		= case when (nm_user_safety_p IS NOT NULL AND nm_user_safety_p::text <> '') then clock_timestamp() else null end
		where 	nr_sequencia 		= nr_seq_ordem_serv_p;
		
		commit;
		
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gravar_avaliacao_md ( nr_seq_ordem_serv_p bigint, nr_customer_requirement_p bigint, ie_potential_harmed_p text, ds_potential_harmed_p text, ie_potencial_safety_p text, ds_potencial_safety_p text, ie_severity_harm_p text, ie_probability_harm_p text, nm_user_safety_p text, nm_usuario_p text) FROM PUBLIC;

