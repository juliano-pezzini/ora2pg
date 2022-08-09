-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_consistir_vinculo_end_ref ( cd_pessoa_fisica_p text, cd_pessoa_end_ref_p text, nr_seq_end_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_registros_w			bigint	:= 0;


BEGIN
if (cd_pessoa_end_ref_p IS NOT NULL AND cd_pessoa_end_ref_p::text <> '') then
	select	count(*)
	into STRICT	qt_registros_w
	from	compl_pessoa_fisica
	where	cd_pessoa_end_ref	= cd_pessoa_fisica_p
	and	nr_seq_end_ref		= nr_seq_end_ref_p;

	if (qt_registros_w > 0) then
		-- Este endereço já está sendo usado como referência e não pode possuir um endereço como referência #@DS_ERRO#@.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(266830, 'DS_ERRO=' || sqlerrm);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_consistir_vinculo_end_ref ( cd_pessoa_fisica_p text, cd_pessoa_end_ref_p text, nr_seq_end_ref_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
