-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proced_realizado (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_proced_w	PROCEDIMENTO.DS_PROCEDIMENTO%type;
ds_retorno_w	varchar(2000);

c01 CURSOR FOR
	SELECT	substr(obter_descricao_procedimento(a.cd_procedimento,

a.ie_origem_proced),1,255) ds_proced
	from	agenda_consulta_proc a
	where	a.nr_seq_agenda = nr_sequencia_p
	order by ds_proced;


BEGIN

OPEN	C01;
LOOP
FETCH	C01	into
	ds_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if	length(ds_retorno_w || ds_proced_w) < 2001 then
		ds_retorno_w	:= ds_retorno_w || ds_proced_w || ', ';

	end if;
END LOOP;
CLOSE C01;

RETURN	ds_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proced_realizado (nr_sequencia_p bigint) FROM PUBLIC;

