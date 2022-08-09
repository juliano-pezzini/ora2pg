-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_cart_conve_eup_js ( ie_clinica_p bigint, ie_tipo_atendimento_p bigint, dt_entrada_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_usuario_convenio_p text, nm_usuario_p text, ds_msg_abort_p INOUT text) AS $body$
DECLARE


nr_digitos_w		varchar(15);
ie_tamanho_w		varchar(1);
ie_rotina_ver_digito_w	varchar(255);
ds_rotina_digito_w	varchar(50);
cd_usuario_convenio_w   varchar(30);

BEGIN
cd_usuario_convenio_w := replace(cd_usuario_convenio_p,'.','');

if (coalesce(cd_convenio_p,0) > 0) then

	select	nr_digitos_codigo,
		ds_rotina_digito
	into STRICT	nr_digitos_w,
		ds_rotina_digito_w
	from	convenio
	where	cd_convenio = cd_convenio_p;

	ie_tamanho_w := consiste_tamanho(cd_usuario_convenio_w, nr_digitos_w);

	if (ie_tamanho_w = 'N') then
		ds_msg_abort_p := substr(obter_texto_tasy(90458, wheb_usuario_pck.get_nr_seq_idioma),1,255);
		if (ds_msg_abort_p IS NOT NULL AND ds_msg_abort_p::text <> '') then
			goto final;
		end if;
	end if;

	ie_rotina_ver_digito_w := obter_rotina_digito_usuario(cd_convenio_p, cd_categoria_p);
	--if	(ie_rotina_ver_digito_w is not null) then
	--end if;
	ds_msg_abort_p := Consiste_Debito_Paciente(cd_pessoa_fisica_p, cd_convenio_p, cd_usuario_convenio_w, ie_tipo_atendimento_p, ie_clinica_p, null, cd_categoria_p, dt_entrada_p, ds_msg_abort_p);
	if (ds_msg_abort_p IS NOT NULL AND ds_msg_abort_p::text <> '') then
		goto final;
	end if;

end if;

<<final>>

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_cart_conve_eup_js ( ie_clinica_p bigint, ie_tipo_atendimento_p bigint, dt_entrada_p timestamp, cd_pessoa_fisica_p text, cd_convenio_p bigint, cd_categoria_p text, cd_usuario_convenio_p text, nm_usuario_p text, ds_msg_abort_p INOUT text) FROM PUBLIC;
