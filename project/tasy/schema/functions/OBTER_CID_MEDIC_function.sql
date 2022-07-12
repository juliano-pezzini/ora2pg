-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cid_medic ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


/*
R	-> cid - ds_cid

*/
ds_retorno_w		varchar(2000);
cd_doenca_cid_w		varchar(10);
ds_doenca_cid_w		varchar(255);

c01 CURSOR FOR
	SELECT	cd_doenca_cid,
		substr(obter_desc_cid(cd_doenca_cid),1,100)
	from	prescr_material_cid
	where	nr_prescricao		=	nr_prescricao_p
	and	nr_sequencia_medic	=	nr_sequencia_p;


ie_preenchido_w	varchar(1);


BEGIN

OPEN C01;
LOOP
FETCH C01 into
	cd_doenca_cid_w,
	ds_doenca_cid_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (ie_opcao_p = 'R') then
		ds_retorno_w 	:= ds_retorno_w || cd_doenca_cid_w || ' - ' || ds_doenca_cid_w || ' ';
	end if;

	end;
END LOOP;
CLOSE C01;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cid_medic ( nr_prescricao_p bigint, nr_sequencia_p bigint, ie_opcao_p text ) FROM PUBLIC;
