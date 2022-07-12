-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_mat_lib_farm_cpoe (nr_seq_mat_cpoe_p cpoe_material.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(1);


BEGIN
	begin
		select	CASE WHEN coalesce(dt_liberacao_farm::text, '') = '' THEN  'N'  ELSE 'S' END
		into STRICT	ie_liberado_w
		from	cpoe_material
		where	nr_sequencia = nr_seq_mat_cpoe_p
		and (coalesce(coalesce(dt_lib_suspensao, dt_suspensao)::text, '') = '' or coalesce(dt_lib_suspensao, dt_suspensao) > clock_timestamp());
	exception
		when no_data_found then
			ie_liberado_w := null;
	end;

	return	ie_liberado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_mat_lib_farm_cpoe (nr_seq_mat_cpoe_p cpoe_material.nr_sequencia%type) FROM PUBLIC;
