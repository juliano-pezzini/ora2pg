-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_atualiza_dt_ficha_cih () AS $body$
DECLARE


qt_registros_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_registros_w
from	cih_ficha_ocorrencia
where	coalesce(dt_ficha::text, '') = '';


WHILE 	qt_registros_w > 0 LOOP
	update	cih_ficha_ocorrencia a
	set	a.dt_ficha = (	SELECT	coalesce(b.dt_alta,a.dt_atualizacao)
				from	atendimento_paciente b
				where	a.nr_atendimento = b.nr_atendimento)
	where	coalesce(dt_ficha::text, '') = ''  LIMIT 1000;

	qt_registros_w := qt_registros_w - 500;
	commit;
END LOOP;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_atualiza_dt_ficha_cih () FROM PUBLIC;
