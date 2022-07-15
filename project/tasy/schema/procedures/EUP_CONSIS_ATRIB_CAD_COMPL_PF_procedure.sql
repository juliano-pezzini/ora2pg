-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE eup_consis_atrib_cad_compl_pf (cd_pessoa_fisica_p text, ie_atrib_obrig_p INOUT text, ds_menssagem_p INOUT text) AS $body$
DECLARE


--Globais
cd_setor_atendimento_w		bigint;
cd_estabelecimento_w		bigint;
cd_perfil_w			bigint;
nm_usuario_w			varchar(20);

ie_obriga_w			varchar(2);
ds_regra_w			varchar(4000);



BEGIN
if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	cd_setor_atendimento_w	:= wheb_usuario_pck.get_cd_setor_atendimento;
	cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
	cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
	nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;

	SELECT * FROM consistir_regra_compl_pf(cd_estabelecimento_w, cd_perfil_w, cd_pessoa_fisica_p, cd_setor_atendimento_w, ie_obriga_w, ds_regra_w, ie_atrib_obrig_p, 'U', 0) INTO STRICT ie_obriga_w, ds_regra_w, ie_atrib_obrig_p;
	ds_menssagem_p := obter_texto_tasy(186881, 0);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE eup_consis_atrib_cad_compl_pf (cd_pessoa_fisica_p text, ie_atrib_obrig_p INOUT text, ds_menssagem_p INOUT text) FROM PUBLIC;

