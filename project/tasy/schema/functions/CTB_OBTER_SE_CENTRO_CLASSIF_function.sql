-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_centro_classif ( cd_centro_custo_p text, cd_classif_centro_p text) RETURNS varchar AS $body$
DECLARE


cd_classif_ww		varchar(2000);
cd_classif_w		varchar(2000);
ie_pertence_w		varchar(001);
ie_pos_w		bigint;


BEGIN

ie_pertence_w		:= 'N';
if (coalesce(cd_classif_centro_p,'0') <> '0')  then
	begin
	cd_classif_w	:= cd_classif_centro_p;
	cd_classif_w	:= replace(cd_classif_w,'(','');
	cd_classif_w	:= replace(cd_classif_w,')','');
	cd_classif_w	:= replace(cd_classif_w,' ','');
	while(ie_pertence_w = 'N') and (length(cd_classif_w) > 0)  loop
		begin
		ie_pos_w 	:= position(',' in cd_classif_w);
		if (ie_pos_w = 0) then
			cd_classif_ww	:= cd_classif_w;
			cd_classif_w	:= '';
		else
			cd_classif_ww	:= substr(cd_classif_w,1, ie_pos_w - 1);
			cd_classif_w	:= substr(cd_classif_w, ie_pos_w + 1, 255);
		end if;
		select CTB_Obter_Se_Centro_Sup(cd_centro_custo_p, cd_classif_ww)
		into STRICT	ie_pertence_w
		;
		end;
	end loop;
	end;
end if;

return	ie_pertence_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_centro_classif ( cd_centro_custo_p text, cd_classif_centro_p text) FROM PUBLIC;

