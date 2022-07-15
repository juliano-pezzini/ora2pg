-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_atualizar_processamento (qt_registros_p bigint) AS $body$
DECLARE


ds_procedure_w	intpd_eventos_sistema.ds_procedure%type;
jobno	bigint;
ie_existe_job_w	varchar(1);

c01 CURSOR FOR
SELECT	nr_sequencia,
	nr_seq_evento_sistema
from	intpd_fila_transmissao
where	ie_status 		= 'R'
and	ie_response_procedure	= 'S'
and	ie_envio_recebe		= 'C'
and	(ds_xml_retorno IS NOT NULL AND ds_xml_retorno::text <> '')  LIMIT (qt_registros_p);

c01_w	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	ds_procedure
	into STRICT	ds_procedure_w
	from	intpd_eventos_sistema
	where	nr_sequencia = c01_w.nr_seq_evento_sistema;

	begin
	select	'S'
	into STRICT	ie_existe_job_w
	from	job_v
	where	comando = 'INTPD_PROCESSAR_REGISTRO_FILA('|| to_char(c01_w.nr_sequencia)||');'  LIMIT 1;
	exception
	when others then
		ie_existe_job_w := 'N';
	end;

	if (ie_existe_job_w = 'N') and (ds_procedure_w IS NOT NULL AND ds_procedure_w::text <> '') then
		dbms_job.submit(jobno, 'INTPD_PROCESSAR_REGISTRO_FILA('|| to_char(c01_w.nr_sequencia)||');',clock_timestamp() + interval '60 days'/60/60/24); --agenda para depois de 1m
	end if;

end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_atualizar_processamento (qt_registros_p bigint) FROM PUBLIC;

