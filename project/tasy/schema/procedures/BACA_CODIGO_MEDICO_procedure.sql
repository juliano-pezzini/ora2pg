-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_codigo_medico () AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_medico_convenio_w	varchar(15);
cd_pessoa_fisica_w	varchar(10);
nr_seq_partic_w		bigint;


c01 CURSOR FOR
	SELECT a.nr_sequencia,
		 b.cd_medico_convenio
	from	 medico_convenio b,
		 procedimento_paciente a
	where	 a.cd_medico_executor	= b.cd_pessoa_fisica
	and	 (a.cd_medico_executor IS NOT NULL AND a.cd_medico_executor::text <> '')
	and	 a.cd_convenio		= b.cd_convenio
	and	 coalesce(a.cd_medico_convenio::text, '') = ''
	and	 (b.cd_medico_convenio IS NOT NULL AND b.cd_medico_convenio::text <> '');


c02 CURSOR FOR
	SELECT a.nr_sequencia,
		 c.nr_seq_partic,
		 b.cd_medico_convenio
	from	 medico_convenio b,
		 procedimento_paciente a,
		 procedimento_participante c
	where	 c.nr_sequencia		= a.nr_sequencia
	and	 c.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	 a.cd_convenio		= b.cd_convenio
	and	 coalesce(c.cd_medico_convenio::text, '') = ''
	and	 (b.cd_medico_convenio IS NOT NULL AND b.cd_medico_convenio::text <> '');



BEGIN

open	c01;
loop
fetch	c01 	into
		nr_sequencia_w,
		cd_medico_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	update procedimento_paciente
	set	 cd_medico_convenio = cd_medico_convenio_w
	where	 nr_sequencia = nr_sequencia_w;

	commit;

	end;
end loop;
close c01;


open	c02;
loop
fetch	c02 	into
		nr_sequencia_w,
		nr_seq_partic_w,
		cd_medico_convenio_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin

	update procedimento_participante
	set	 cd_medico_convenio = cd_medico_convenio_w
	where	 nr_sequencia 	= nr_sequencia_w
	and	 nr_seq_partic	= nr_seq_partic_w;

	commit;

	end;
end loop;
close c02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_codigo_medico () FROM PUBLIC;
