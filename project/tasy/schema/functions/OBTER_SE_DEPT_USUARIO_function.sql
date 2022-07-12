-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_dept_usuario ( cd_departamento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_departamento_usuario_w		varchar(1) := 'N';
cd_departamento_w				departamento_setor.cd_departamento%type;

c01 CURSOR FOR
	SELECT	cd_departamento
	from	departamento_setor
	where	cd_setor_atendimento = wheb_usuario_pck.get_cd_setor_atendimento;


BEGIN

	open c01;
	loop
	fetch c01 into
		cd_departamento_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
			if (cd_departamento_w = cd_departamento_p) then
				ie_departamento_usuario_w := 'S';
			end if;
		end;
	end loop;
	close c01;

return	ie_departamento_usuario_w;

End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_dept_usuario ( cd_departamento_p bigint, nm_usuario_p text) FROM PUBLIC;

