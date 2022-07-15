-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aval_pac_cih_atu_atribfoclost ( cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, nm_usuario_p text, cd_estabelecimento_p bigint, qt_proced_sus_p INOUT bigint, cd_doenca_cid_p INOUT text, cd_cid_secundario_p INOUT text ) AS $body$
DECLARE


ie_situacao_w		varchar(1) := 'N';
qt_proced_sus_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proc_cih_w	varchar(10);
ie_origem_proced_w	bigint;
ie_buscar_cid_w		varchar(1) := 'N';
cd_doenca_cid_w		varchar(10);
cd_cid_secundario_w	varchar(10);


BEGIN

if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin

	select	max(ie_situacao)
	into STRICT	ie_situacao_w
	from	procedimento
	where	cd_procedimento = cd_procedimento_p;


	if (ie_situacao_w = 'I') then
		begin
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(183125);
		end;
	end if;

	ie_origem_proc_cih_w := obter_param_usuario(916, 229, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_origem_proc_cih_w);

	select	count(*)
	into STRICT	qt_proced_sus_w
	from	procedimento
	where	cd_procedimento  =  cd_procedimento_p
	and	ie_origem_proced in ((ie_origem_proc_cih_w)::numeric );


	if (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') and
		((ie_origem_proced_p = 2) or (ie_origem_proced_p = 7)) and (qt_proced_sus_w = 0) then
		begin

		select	max(cd_procedimento_sus),
			max(ie_origem_proced_sus)
		into STRICT	cd_procedimento_w,
			ie_origem_proced_w
		from	procedimento_conv_sus b
		where   b.cd_procedimento = cd_procedimento_p;

		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (cd_procedimento_w <> 0) then
			begin
			cd_procedimento_p 	:= cd_procedimento_w;
			ie_origem_proced_p	:= ie_origem_proced_w;
			end;
		else
			begin

			CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(183139);

			end;
		end if;
		end;
	end if;

	ie_buscar_cid_w := obter_param_usuario(916, 131, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_buscar_cid_w);

	if (ie_buscar_cid_w = 'S') then
		begin

		select	cd_doenca_cid,
			cd_cid_secundario
		into STRICT	cd_doenca_cid_w,
			cd_cid_secundario_w
		from	procedimento
		where	cd_procedimento	= cd_procedimento_p
		and	ie_origem_proced  = (ie_origem_proc_cih_w)::numeric;

		cd_doenca_cid_p     := cd_doenca_cid_w;
		cd_cid_secundario_p := cd_cid_secundario_w;

		end;
	end if;


	end;
end if;

cd_procedimento_p	:= cd_procedimento_w;
ie_origem_proced_p	:= ie_origem_proced_w;
cd_doenca_cid_p		:= cd_doenca_cid_w;
cd_cid_secundario_p	:= cd_cid_secundario_w;
qt_proced_sus_p		:= qt_proced_sus_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aval_pac_cih_atu_atribfoclost ( cd_procedimento_p INOUT bigint, ie_origem_proced_p INOUT bigint, nm_usuario_p text, cd_estabelecimento_p bigint, qt_proced_sus_p INOUT bigint, cd_doenca_cid_p INOUT text, cd_cid_secundario_p INOUT text ) FROM PUBLIC;

