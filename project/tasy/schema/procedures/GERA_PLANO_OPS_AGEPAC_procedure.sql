-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gera_plano_ops_agepac (nr_seq_agenda_p bigint) AS $body$
DECLARE


cd_usuario_plano_w	varchar(255);
cd_plano_w			varchar(10);
cd_convenio_w		integer;
cd_categoria_w		varchar(10);


BEGIN

select	cd_convenio,
		cd_categoria,
		cd_usuario_convenio
into STRICT	cd_convenio_w,
		cd_categoria_w,
		cd_usuario_plano_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_p;

select  max(cd_plano_padrao)
into STRICT	cd_plano_w
from	categoria_convenio
where	cd_convenio = cd_convenio_w
and		cd_categoria = cd_categoria_w;

if (cd_plano_w = '') then
	select  obter_plano_cod_usuario_conv(cd_convenio_w, cd_usuario_plano_w)
	into STRICT	cd_plano_w
	;
end if;

if (cd_plano_w <> '') then
	update	agenda_paciente
	set		cd_plano	= cd_plano_w
	where	nr_sequencia	= nr_seq_agenda_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gera_plano_ops_agepac (nr_seq_agenda_p bigint) FROM PUBLIC;

