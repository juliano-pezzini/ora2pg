-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_agenda_cirurgica (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
cd_agenda_w bigint;
ds_lista_agenda_w varchar(4000);
ie_param_306_w varchar(1);
ie_param_158_w varchar(1);
ie_param_35_w varchar(1);
ie_param_28_w varchar(1);

C01 CURSOR FOR 
SELECT	cd_agenda cd 
from	agenda 
where	ie_situacao = 'A' 
and	cd_tipo_agenda = 1 
and	((ie_param_306_w = 'S' and ie_param_28_w = 'S' and cd_setor_exclusivo(SELECT cd_setor_atendimento from usuario_Setor_v where nm_usuario = wheb_usuario_pck.get_nm_usuario)) or (ie_param_306_w <> 'S' or ie_param_28_w <> 'S' and coalesce(cd_setor_exclusivo::text, '') = '')) 
and	((ie_param_35_w = 'S' and cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento) or (ie_param_35_w <> 'S' and cd_estabelecimento in (select x.cd_estabelecimento from usuario_estabelecimento_v x where x.nm_usuario_param = wheb_usuario_pck.get_nm_usuario))) 
and (ie_param_158_w <> 'S' or substr(obter_se_perm_agecirur(cd_pessoa_fisica, cd_pessoa_fisica_p,wheb_usuario_pck.get_cd_perfil, cd_agenda), 1, 1) <> 'N') 
order by coalesce(nr_seq_apresent,0), ds_agenda;


BEGIN 
ie_param_306_w := Obter_Valor_Param_Usuario(871,306,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
ie_param_158_w := Obter_Valor_Param_Usuario(871,158,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
ie_param_35_w := Obter_Valor_Param_Usuario(871,35,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
ie_param_28_w := Obter_Valor_Param_Usuario(871,28,wheb_usuario_pck.get_cd_perfil,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
 
open C01;
loop 
fetch C01 into 
	cd_agenda_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
		if (coalesce(ds_lista_agenda_w::text, '') = '') then 
			ds_lista_agenda_w := cd_agenda_w;
		else 
			ds_lista_agenda_w := ds_lista_agenda_w || ',' || cd_agenda_w;
		end if;
	end;
end loop;
close C01;
 
return	ds_lista_agenda_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_agenda_cirurgica (cd_pessoa_fisica_p text) FROM PUBLIC;

