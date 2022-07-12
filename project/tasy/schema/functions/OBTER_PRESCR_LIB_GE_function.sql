-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_lib_ge (nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
-- Function utilizada na Gestão de exames Swing.
BEGIN

ds_retorno_w := obter_se_prescricao_liberada(nr_prescricao_p, 'M');

if (ds_retorno_w <> 'S') then

	ds_retorno_w := obter_se_prescricao_liberada(nr_prescricao_p, 'E');

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_lib_ge (nr_prescricao_p bigint) FROM PUBLIC;
