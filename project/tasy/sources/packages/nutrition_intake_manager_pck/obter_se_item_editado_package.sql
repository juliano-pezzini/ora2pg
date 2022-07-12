-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION nutrition_intake_manager_pck.obter_se_item_editado ( nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS varchar AS $body$
DECLARE


	ds_retorno_w  varchar(1) := 'N';

	
BEGIN

		if (ie_tipo_item_p = 'M') or (ie_tipo_item_p = 'S') then

			select  CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT    ds_retorno_w
			from    cpoe_material
			where   nr_sequencia = nr_sequencia_p
			and     coalesce(dt_suspensao::text, '') = ''
			and     exists (	SELECT  1
								from    cpoe_material b
								where   b.nr_seq_cpoe_anterior = nr_sequencia_p);

		else

			select  CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
			into STRICT    ds_retorno_w
			from    cpoe_dieta
			where   nr_sequencia = nr_sequencia_p
			and     coalesce(dt_suspensao::text, '') = ''
			and     exists (	SELECT  1
								from    cpoe_dieta b
								where   b.nr_seq_cpoe_anterior = nr_sequencia_p);

		end if;

		return ds_retorno_w;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION nutrition_intake_manager_pck.obter_se_item_editado ( nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;