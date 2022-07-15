-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_imagem_prescricao ( nr_prescricao_p bigint, qt_imagem_prescricao_p INOUT bigint, ds_imagem_prescricao_p INOUT text) AS $body$
DECLARE


qt_imagem_prescricao_w	bigint;
ds_imagem_prescricao_w	varchar(255) := '';


BEGIN

select 	count(*)
into STRICT	qt_imagem_prescricao_w
from 	prescr_medica_imagem
where 	nr_prescricao = nr_prescricao_p;

if (qt_imagem_prescricao_w = 1)then
	begin

	select 	ds_arquivo
	into STRICT	ds_imagem_prescricao_w
	from 	prescr_medica_imagem
	where 	nr_prescricao = nr_prescricao_p;

	end;
end if;

qt_imagem_prescricao_p := qt_imagem_prescricao_w;
ds_imagem_prescricao_p := ds_imagem_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_imagem_prescricao ( nr_prescricao_p bigint, qt_imagem_prescricao_p INOUT bigint, ds_imagem_prescricao_p INOUT text) FROM PUBLIC;

