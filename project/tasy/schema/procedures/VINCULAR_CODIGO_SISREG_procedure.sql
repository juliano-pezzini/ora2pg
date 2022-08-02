-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_codigo_sisreg ( nr_atendimento_p bigint, cd_regulacao_sus_p text, cd_chave_regulacao_sus_p text, nm_usuario_p text ) AS $body$
DECLARE


ie_possui_w  	varchar(1);

BEGIN

if (coalesce(nr_atendimento_p,0) > 0) and (cd_regulacao_sus_p IS NOT NULL AND cd_regulacao_sus_p::text <> '') then
	begin
	select	'S'
	into STRICT 	ie_possui_w
	from	atend_paciente_sisreg
	where 	nr_atendimento = nr_atendimento_p  LIMIT 1;
	exception
	when others then
		ie_possui_w := 'N';
	end;

	if (coalesce(ie_possui_w,'N') = 'S') then
		update atend_paciente_sisreg
		set 	cd_regulacao_sus 	= cd_regulacao_sus_p,
			cd_chave_regulacao_sus 	= cd_chave_regulacao_sus_p
		where	nr_atendimento 		= nr_atendimento_p;
	else
		insert into atend_paciente_sisreg(
			nr_atendimento,
			cd_regulacao_sus,
			cd_chave_regulacao_sus
		) values (
			nr_atendimento_p,
			cd_regulacao_sus_p,
			cd_chave_regulacao_sus_p
		);
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_codigo_sisreg ( nr_atendimento_p bigint, cd_regulacao_sus_p text, cd_chave_regulacao_sus_p text, nm_usuario_p text ) FROM PUBLIC;

