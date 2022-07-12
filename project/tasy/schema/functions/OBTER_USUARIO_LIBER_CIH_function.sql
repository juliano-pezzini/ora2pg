-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_liber_cih (nr_prescricao_p bigint, nr_seq_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(15);


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then
	select	max(nm_usuario)
	into STRICT	ds_retorno_w
	from	prescr_material_lib_cih
	where	nr_sequencia = (	SELECT	coalesce(max(nr_sequencia),0)
								from	prescr_material_lib_cih a
								where	a.nr_prescricao 	= nr_prescricao_p
								and		a.nr_seq_material 	= nr_seq_material_p
								and		a.ie_tipo_liberacao	= 'T');

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_liber_cih (nr_prescricao_p bigint, nr_seq_material_p bigint) FROM PUBLIC;

