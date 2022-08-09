-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bpoc_preparar_adm_html ( nr_seq_lote_p bigint, cd_mensagem_p INOUT text) AS $body$
DECLARE

 
/* 
This procedure was created to replace part of the JAVA code lines 
from doAdministrarAction method, that exists in the Bar Code Point-of-Care module. 
Class: AtePac_AO\src\br\com\AtePac_AO\AtePac_AO.java 
*/
 
 
nm_usuario_w		usuario.nm_usuario%type;
cd_perfil_w		perfil.cd_perfil%type;
cd_setor_atendimento_w	setor_atendimento.cd_setor_atendimento%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
cd_mensagem_w		bigint	:= 0;
ie_exige_conf_w		varchar(1);
ie_permite_adm_w	varchar(1);
ie_conferido_w		varchar(1);


BEGIN 
nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;
cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
cd_setor_atendimento_w	:= wheb_usuario_pck.get_cd_setor_atendimento;
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
 
 
ie_exige_conf_w := Obter_Param_Usuario(1110, 3, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_exige_conf_w);
 
if (ie_exige_conf_w = 'S') then 
	begin 
	 
	select	substr(OBTER_SE_STATUS_BEIRA_LEITO(nr_seq_lote_p),1,1) 
	into STRICT	ie_conferido_w 
	;
 
	if (ie_conferido_w = 'N') then 
		cd_mensagem_w	:= 216663;
	end if;
 
	end;
else 
	begin 
 
	select	substr(OBTER_SE_PERMITE_ADM_ITEM('M',cd_perfil_w,cd_setor_atendimento_w,nm_usuario_w,'N',0,0,0),1,1) 
	into STRICT	ie_permite_adm_w 
	;
 
	if (ie_permite_adm_w = 'N') then 
		cd_mensagem_w	:= 200039;
	end if;
 
	end;
end if;
 
cd_mensagem_p	:= cd_mensagem_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bpoc_preparar_adm_html ( nr_seq_lote_p bigint, cd_mensagem_p INOUT text) FROM PUBLIC;
