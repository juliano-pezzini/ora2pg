-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_clearence ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_reg_w		smallint;


BEGIN

select 	count(*)
into STRICT	qt_reg_w
from	pac_clereance_creatinina
where	nr_sequencia = nr_sequencia_p;

if (qt_reg_w > 0) then

	update pac_clereance_creatinina
	set    dt_liberacao = clock_timestamp()
	where  nr_sequencia = nr_sequencia_p;
end if;


commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_clearence ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

