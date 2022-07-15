-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_obter_relatorio_visualizar ( cd_medico_p text, ie_local_relatorio_p text, cd_convenio_p bigint, cd_relatorio_p INOUT text, ds_classif_relat_p INOUT text) AS $body$
DECLARE

 
nr_seq_relatorio_w	bigint;
nr_seq_relat_w		bigint	:= 0;
cd_relatorio_w		varchar(200);
ds_classif_relat_w	varchar(200);

c01 CURSOR FOR 
	SELECT	nr_seq_relatorio	 
	from	med_relatorio 
	where	cd_medico		= cd_medico_p 
	and	ie_local_relatorio	= ie_local_relatorio_p 
	and	((cd_convenio		= cd_convenio_p) or (cd_convenio_p = 0)) 
	order by	coalesce(ie_padrao,1) desc;


BEGIN 
 
if (cd_medico_p IS NOT NULL AND cd_medico_p::text <> '') and (ie_local_relatorio_p IS NOT NULL AND ie_local_relatorio_p::text <> '') then 
	begin 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_relatorio_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin		 
		nr_seq_relat_w	:= nr_seq_relatorio_w;		
		end;
	end loop;
	close C01;
	 
	if (nr_seq_relat_w > 0) then 
		begin 
		 
		cd_relatorio_w		:= substr(obter_classif_Relatorio(nr_seq_relat_w, 'C'),1,200);
		ds_classif_relat_w	:= substr(Obter_classif_Relatorio(nr_seq_relat_w, 'CL'),1,200);
		 
		end;
	end if;
	 
	end;
end if;
	 
cd_relatorio_p		:= cd_relatorio_w;
ds_classif_relat_p	:= ds_classif_relat_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_obter_relatorio_visualizar ( cd_medico_p text, ie_local_relatorio_p text, cd_convenio_p bigint, cd_relatorio_p INOUT text, ds_classif_relat_p INOUT text) FROM PUBLIC;

