-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_medic_diag_checkup ( nr_sequencia_p bigint, ds_retorno_p INOUT text) AS $body$
DECLARE



ds_receita_w		varchar(2500);
ds_material_w		varchar(255);
ds_via_aplicacao_w	varchar(60);
ds_generico_w		varchar(100);
ds_posologia_w		varchar(2000);



BEGIN


select	ds_material ||' - '||ds_generico,
	ds_via_aplicacao,
	ds_posologia
into STRICT	ds_material_w,
	ds_via_aplicacao_w,
	ds_posologia_w
from	checkup_medic_associado
where	nr_sequencia	= nr_sequencia_p;


if (ds_material_w IS NOT NULL AND ds_material_w::text <> '') then
	ds_receita_w	:= ds_material_w || chr(13);
end if;


if (ds_via_aplicacao_w IS NOT NULL AND ds_via_aplicacao_w::text <> '') then
	ds_receita_w	:= ds_receita_w || ds_via_aplicacao_w || chr(13);
end if;

/*
if 	(ds_generico_w is not null) then
	ds_receita_w	:= ds_receita_w || ds_generico_w || chr(13);
end if;
*/
if (ds_posologia_w IS NOT NULL AND ds_posologia_w::text <> '') then
	ds_receita_w	:= ds_receita_w || ds_posologia_w || chr(10);
end if;


ds_retorno_p	:= ds_receita_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_medic_diag_checkup ( nr_sequencia_p bigint, ds_retorno_p INOUT text) FROM PUBLIC;
