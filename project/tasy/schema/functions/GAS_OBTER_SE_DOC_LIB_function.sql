-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gas_obter_se_doc_lib ( nr_seq_documento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


cd_perfil_w		perfil.cd_perfil%type;
ds_retorno_w		varchar(1) := 'S';
qt_doc_liberados_w	bigint;



BEGIN
cd_perfil_w	:= obter_perfil_ativo;

if (nr_seq_documento_p > 0) then
	select	count(*)
	into STRICT	qt_doc_liberados_w
	from	gas_doc_lib
	where	nr_seq_documento = nr_seq_documento_p;


	if (qt_doc_liberados_w > 0) then
		begin
		select	'S'
		into STRICT	ds_retorno_w
		from	gas_doc_lib
		where	nr_seq_documento = nr_seq_documento_p
		and	cd_perfil = cd_perfil_w  LIMIT 1;
		exception
		when others then
			ds_retorno_w := 'N';
		end;
	end if;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gas_obter_se_doc_lib ( nr_seq_documento_p bigint, nm_usuario_p text) FROM PUBLIC;

