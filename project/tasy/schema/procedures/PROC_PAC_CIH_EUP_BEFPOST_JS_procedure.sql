-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proc_pac_cih_eup_befpost_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, cd_doenca_cid_p text, nr_atendimento_p bigint, cd_doenca_cid_primario_p text, ds_msg_erro_proc_p INOUT text, ds_msg_pergunta_proc_p INOUT text, ds_msg_erro_cons_proc_p INOUT text) AS $body$
DECLARE

 
ds_msg_erro_proc_w	varchar(2000);
ds_msg_pergunta_proc_w	varchar(2000);
cd_estabelecimento_w	bigint;
ie_localiza_cid_sencundario_w	varchar(1);
ie_permite_proc_nao_princ_w	varchar(1);
ie_permite_lancar_sus_cih_w	varchar(1);
ie_consiste_reg_proc_cih_w	varchar(1);
ds_msg_erro_cons_proc_w		varchar(2000);
ie_continuar_execucao_w		varchar(1) := 'S';
ie_permite_cid_inativo_w	varchar(1);
ie_situacao_proc_w		varchar(1);
ie_permite_cid_quatro_carac_w	varchar(1);
qt_carac_cid_primario_w		bigint;
					

BEGIN 
 
cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
 
ie_localiza_cid_sencundario_w := Obter_param_Usuario(916, 199, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_localiza_cid_sencundario_w);
ie_permite_lancar_sus_cih_w := Obter_param_Usuario(916, 228, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_lancar_sus_cih_w);
ie_consiste_reg_proc_cih_w := Obter_param_Usuario(916, 230, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_consiste_reg_proc_cih_w);
ie_permite_proc_nao_princ_w := Obter_param_Usuario(916, 264, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_proc_nao_princ_w);
ie_permite_cid_inativo_w := Obter_param_Usuario(916, 594, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_cid_inativo_w);
ie_permite_cid_quatro_carac_w := Obter_param_Usuario(916, 1090, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_permite_cid_quatro_carac_w);
 
 
if (coalesce(cd_procedimento_p,0) > 0) then 
 
	SELECT * FROM consistir_lancamen_proc_eup_js(	cd_procedimento_p, ie_origem_proced_p, ie_permite_proc_nao_princ_w, ie_permite_lancar_sus_cih_w, ie_localiza_cid_sencundario_w, cd_doenca_cid_p, ds_msg_erro_proc_w, ds_msg_pergunta_proc_w) INTO STRICT ds_msg_erro_proc_w, ds_msg_pergunta_proc_w;
	if (ds_msg_erro_proc_w IS NOT NULL AND ds_msg_erro_proc_w::text <> '') then 
		ie_continuar_execucao_w := 'N';
	end if;
	 
	if (ie_consiste_reg_proc_cih_w = 'S') and (coalesce(ie_origem_proced_p,0) = 7) and (ie_continuar_execucao_w = 'S') then 
 
		ds_msg_erro_cons_proc_w := consistir_proced_cih(nr_atendimento_p, cd_procedimento_p, ie_origem_proced_p, ds_msg_erro_cons_proc_w);
		 
		if (ds_msg_erro_cons_proc_w IS NOT NULL AND ds_msg_erro_cons_proc_w::text <> '') then 
			ie_continuar_execucao_w := 'N';
		end if;
	end if;
	 
end if;
 
if (ie_continuar_execucao_w = 'S') and (cd_doenca_cid_primario_p IS NOT NULL AND cd_doenca_cid_primario_p::text <> '') then 
	 
	select 	max(ie_situacao) 
	into STRICT	ie_situacao_proc_w 
	from 	cid_doenca 
	where 	cd_doenca_cid = cd_doenca_cid_primario_p;
	 
	if (ie_permite_cid_inativo_w = 'N') and (ie_situacao_proc_w = 'I') then 
	 
		ds_msg_erro_cons_proc_w := substr(obter_texto_tasy(72200, 1),1,2000);
		ie_continuar_execucao_w := 'N';
	end if;
end if;
 
if (ie_continuar_execucao_w = 'S') and (ie_permite_cid_quatro_carac_w = 'S') then 
		 
	select	coalesce(length(cd_doenca_cid_primario_p),0) 
	into STRICT	qt_carac_cid_primario_w 
	;
		 
	if (qt_carac_cid_primario_w <> 4) then 
		ds_msg_erro_cons_proc_w := substr(obter_texto_tasy(261177, 1),1,2000);
		ie_continuar_execucao_w := 'N';
	end if;
end if;
 
ds_msg_erro_proc_p 	:= ds_msg_erro_proc_w;
ds_msg_pergunta_proc_p := ds_msg_pergunta_proc_w;
ds_msg_erro_cons_proc_p := ds_msg_erro_cons_proc_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proc_pac_cih_eup_befpost_js ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nm_usuario_p text, cd_doenca_cid_p text, nr_atendimento_p bigint, cd_doenca_cid_primario_p text, ds_msg_erro_proc_p INOUT text, ds_msg_pergunta_proc_p INOUT text, ds_msg_erro_cons_proc_p INOUT text) FROM PUBLIC;
