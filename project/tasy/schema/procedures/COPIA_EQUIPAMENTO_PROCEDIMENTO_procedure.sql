-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_equipamento_procedimento ( cd_procedimento_origem_p bigint, ie_origem_proced_origem_p bigint, cd_procedimento_destino_p bigint, ie_origem_proced_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_equipamento_w	bigint;
qt_existe_w		bigint;

C01 CURSOR FOR
	SELECT	cd_equipamento
	from	procedimento_equip
	where	cd_procedimento = cd_procedimento_origem_p
	and	ie_origem_proced = ie_origem_proced_origem_p;


BEGIN
select	count(*)
into STRICT	qt_existe_w
from	procedimento_equip
where	cd_procedimento = cd_procedimento_destino_p
and	ie_origem_proced = ie_origem_proced_destino_p;

if (qt_existe_w = 0) then
	begin
	open c01;
	loop
	fetch c01 into
		cd_equipamento_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		insert into procedimento_equip(
			nr_sequencia,
			cd_procedimento,
			ie_origem_proced,
			cd_equipamento,
			dt_atualizacao,
			nm_usuario)
		values (	nextval('procedimento_equip_seq'),
			cd_procedimento_destino_p,
			ie_origem_proced_destino_p,
			cd_equipamento_w,
			clock_timestamp(),
			nm_usuario_p);
		end;
	end loop;
	close c01;
	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_equipamento_procedimento ( cd_procedimento_origem_p bigint, ie_origem_proced_origem_p bigint, cd_procedimento_destino_p bigint, ie_origem_proced_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
