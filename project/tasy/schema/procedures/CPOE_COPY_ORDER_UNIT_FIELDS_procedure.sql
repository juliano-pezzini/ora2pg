-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_copy_order_unit_fields ( nr_seq_item_gerado_p bigint, ie_tipo_item_gerado_p text, nr_seq_cpoe_order_unit_p bigint ) AS $body$
DECLARE

	
cd_setor_coleta_w           cpoe_order_unit.cd_setor_coleta%type := null;


BEGIN

if (nr_seq_cpoe_order_unit_p IS NOT NULL AND nr_seq_cpoe_order_unit_p::text <> '') then
	select  cd_setor_coleta
	into STRICT 	cd_setor_coleta_w
	from 	cpoe_order_unit
	where 	nr_sequencia = nr_seq_cpoe_order_unit_p;

    if (ie_tipo_item_gerado_p = 'P') then 
        update  cpoe_procedimento
        set     cd_setor_coleta = cd_setor_coleta_w
        where   nr_sequencia = nr_seq_item_gerado_p;
    end if;

end if;

/* Commit will be on outer procedure */

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_copy_order_unit_fields ( nr_seq_item_gerado_p bigint, ie_tipo_item_gerado_p text, nr_seq_cpoe_order_unit_p bigint ) FROM PUBLIC;

