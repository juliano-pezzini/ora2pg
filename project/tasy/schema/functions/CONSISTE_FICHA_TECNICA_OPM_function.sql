-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_ficha_tecnica_opm ( cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE
													
cd_perfil_w		integer;
nr_ficha_tecnica_w  	bigint;
nr_seq_componente_w	bigint;
cd_pessoa_fisica_w	varchar(10);
ie_permite_w		varchar(1);
ie_permite_ww		varchar(1) := 'S';

C01 CURSOR FOR 
	SELECT		coalesce(ie_visualiza,'S') 
	from		ficha_tecnica_comp_regra 
	where		coalesce(ie_situacao,'A') = 'A' 
	and 		coalesce(cd_estabelecimento,cd_estabelecimento_p) 	= cd_estabelecimento_p	 
	and		coalesce(cd_pessoa_fisica,cd_pessoa_fisica_w) 	= cd_pessoa_fisica_w	 
	and		coalesce(cd_perfil,cd_perfil_w)			= cd_perfil_w 
	and		coalesce(nr_ficha_tecnica,nr_ficha_tecnica_w)	= nr_ficha_tecnica_w 
	and		coalesce(nr_seq_componente,nr_seq_componente_w)	= nr_seq_componente_w 
	order by	coalesce(cd_estabelecimento,0) desc, 
		coalesce(cd_perfil,0) desc,				 
		coalesce(cd_pessoa_fisica,0) desc, 
		coalesce(nr_ficha_tecnica,0) desc, 
		coalesce(nr_seq_componente,0) desc;

 

BEGIN 
cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
cd_pessoa_fisica_w	:= obter_pessoa_fisica_usuario(nm_usuario_p,'C');
 
select 	max(nr_ficha_tecnica), 
	max(nr_seq_componente) 
into STRICT 	 nr_ficha_tecnica_w, 
	 nr_seq_componente_w 
from 	ficha_tecnica_componente 
where 	cd_material = cd_material_p;
 
open C01;
loop 
fetch C01 into	 
ie_permite_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ie_permite_ww := ie_permite_w;
	end;
end loop;
close C01;
 
return ie_permite_ww;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_ficha_tecnica_opm ( cd_material_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

