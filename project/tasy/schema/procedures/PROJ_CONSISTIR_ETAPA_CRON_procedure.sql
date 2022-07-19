-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_consistir_etapa_cron ( nr_seq_cronograma_p bigint, nr_seq_superior_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE


qt_existe_w	bigint;
ds_erro_w	varchar(255) := '';


BEGIN

if (nr_seq_superior_p <> 0) then
	begin
	select	count(*)
	into STRICT	qt_existe_w
	from	proj_cron_etapa
	where	nr_sequencia = nr_seq_superior_p
	and	nr_seq_cronograma = nr_seq_cronograma_p;

	if (qt_existe_w = 0) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(280463,null);
	end if;
	end;
end if;

ds_erro_p := substr(ds_erro_w,1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_consistir_etapa_cron ( nr_seq_cronograma_p bigint, nr_seq_superior_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

