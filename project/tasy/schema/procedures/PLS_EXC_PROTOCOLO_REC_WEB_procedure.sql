-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_exc_protocolo_rec_web ( nr_seq_protocolo_rec_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ds_retorno_w	varchar(3) := 'OK';
qt_registros_w	bigint;


BEGIN

select	count(1)
into STRICT	qt_registros_w
from	pls_rec_glosa_conta
where	nr_seq_protocolo = nr_seq_protocolo_rec_p;

if (qt_registros_w = 0) then

	delete	FROM pls_rec_glosa_protocolo
	where	nr_sequencia	= nr_seq_protocolo_rec_p;

else
	ds_retorno_w := 'ERR';
end if;

ds_retorno_p := ds_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_exc_protocolo_rec_web ( nr_seq_protocolo_rec_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
