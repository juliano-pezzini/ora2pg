-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE fleury_ws_suspender_prescr ( nr_ficha_p text, cd_unidade_p text) AS $body$
DECLARE

 
cd_estabelecimento_w	bigint;
ie_agrupa_w		varchar(1);
nr_prescricao_w		bigint := null;					
					 

BEGIN 
 
select	fleury_obter_dados_unidade(cd_unidade_p, 'E'), 
	fleury_obter_dados_unidade(cd_unidade_p, 'AF') 
into STRICT	cd_estabelecimento_w, 
	ie_agrupa_w
;
 
if (ie_agrupa_w = 'S') then 
	select	max(nr_prescricao) 
	into STRICT	nr_prescricao_w 
	from	prescr_procedimento 
	where	nr_controle_ext = nr_ficha_p;
else 
	select	max(nr_prescricao) 
	into STRICT	nr_prescricao_w 
	from	prescr_medica 
	where	nr_controle = nr_ficha_p;
	 
	if (coalesce(nr_prescricao_w::text, '') = '') then 
		select	max(b.nr_prescricao) 
		into STRICT	nr_prescricao_w 
		from	prescr_procedimento a, prescr_medica b 
		where	a.nr_prescricao = b.nr_prescricao 
		and	a.nr_controle_ext = nr_ficha_p 
		and	((b.cd_estabelecimento = cd_estabelecimento_w) or (cd_estabelecimento_w = 0));
	end if;
	 
end if;
 
CALL Suspender_Prescricao(nr_prescricao_w, 0, null, 'FLEURY', 'N');
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fleury_ws_suspender_prescr ( nr_ficha_p text, cd_unidade_p text) FROM PUBLIC;
