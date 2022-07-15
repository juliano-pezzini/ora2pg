-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_separa_conta_setor () AS $body$
DECLARE


ie_separa_conta_setor_w		varchar(1);
cd_estabelecimento_w		smallint;

c01 CURSOR FOR
	SELECT 	ie_separa_conta_setor,
		cd_estabelecimento
	from	sus_parametros
	order by 2;


BEGIN

open c01;
loop
fetch c01 into
	ie_separa_conta_setor_w,
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	update	parametro_faturamento
	set	ie_separa_conta_setor 	= ie_separa_conta_setor_w
	where	cd_estabelecimento		= cd_estabelecimento_w;
	end;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_separa_conta_setor () FROM PUBLIC;

