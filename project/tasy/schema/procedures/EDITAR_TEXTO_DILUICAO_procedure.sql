-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE editar_texto_diluicao ( nr_prescr_p bigint, nr_seq_p bigint, dilui_p text) AS $body$
BEGIN

if (nr_prescr_p IS NOT NULL AND nr_prescr_p::text <> '') and (nr_seq_p IS NOT NULL AND nr_seq_p::text <> '')then
	begin

	update  prescr_material
	set     ds_diluicao_edit  = dilui_p
	where   nr_prescricao     = nr_prescr_p
	and     nr_sequencia      = nr_seq_p;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE editar_texto_diluicao ( nr_prescr_p bigint, nr_seq_p bigint, dilui_p text) FROM PUBLIC;

