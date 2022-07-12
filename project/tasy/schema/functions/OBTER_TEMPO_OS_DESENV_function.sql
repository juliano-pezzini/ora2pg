-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tempo_os_desenv (nr_seq_ordem_p bigint) RETURNS bigint AS $body$
DECLARE


ie_desenv_w		varchar(10);
nr_seq_estagio_w	bigint;
nr_sequencia_w		bigint;
qt_tempo_w		bigint := 0;

BEGIN

select	a.nr_seq_estagio,
	b.ie_desenv
into STRICT	nr_seq_estagio_w,
	ie_desenv_w
from  	MAN_ORDEM_SERVICO a,
	man_estagio_processo b
where 	a.nr_seq_estagio = b.nr_sequencia
and	a.nr_sequencia = nr_seq_ordem_p;

if (ie_desenv_w = 'S') then
	select	max(nr_sequencia)
	into STRICT	nr_sequencia_w
	from	man_ordem_serv_estagio
	where	nr_seq_estagio = nr_seq_estagio_w
	and	nr_seq_ordem = nr_seq_ordem_p;

	begin
	qt_tempo_w := coalesce(man_obter_tempo_estagio(nr_sequencia_w,nr_seq_ordem_p,'M'),0);
	qt_tempo_w := coalesce(round(qt_tempo_w/1440),0);
	exception when others then
		qt_tempo_w	:= 0;
	end;
end if;

return	coalesce(qt_tempo_w,0);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tempo_os_desenv (nr_seq_ordem_p bigint) FROM PUBLIC;

