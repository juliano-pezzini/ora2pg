-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_soma_qtd_disp ( nr_cirurgia_p bigint, cd_material_p bigint, cd_unidade_medida_p text) RETURNS bigint AS $body$
DECLARE


qt_dispensacao_w	bigint;


BEGIN

select	coalesce(sum(qt_dispensacao),0)
into STRICT	qt_dispensacao_w
from 	cirurgia_agente_disp
where 	nr_cirurgia 		= nr_cirurgia_p
and 	cd_material 		= cd_material_p
and	cd_unidade_medida 	= cd_unidade_medida_p;

return 	qt_dispensacao_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_soma_qtd_disp ( nr_cirurgia_p bigint, cd_material_p bigint, cd_unidade_medida_p text) FROM PUBLIC;

