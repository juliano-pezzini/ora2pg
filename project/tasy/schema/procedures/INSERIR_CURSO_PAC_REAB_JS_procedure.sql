-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_curso_pac_reab_js ( cd_pessoa_fisica_p text, nr_seq_curso_p bigint, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE


ie_existe_pac_w		varchar(15);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '')then
	begin

	ie_existe_pac_w	:= rp_obter_seq_paciente_reab(cd_pessoa_fisica_p, cd_estabelecimento_p);

	if (ie_existe_pac_w IS NOT NULL AND ie_existe_pac_w::text <> '')then
		begin

		CALL rp_inserir_curso(nr_seq_curso_p, (ie_existe_pac_w)::numeric , cd_pessoa_fisica_p, nm_usuario_p);

		end;
	else
		begin

		CALL Wheb_mensagem_pck.exibir_mensagem_abort(279322);

		end;
	end if;

	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_curso_pac_reab_js ( cd_pessoa_fisica_p text, nr_seq_curso_p bigint, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;
