-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_modo_registro_agente ( nr_seq_cirur_agente_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_modo_registro_w	varchar(1);


BEGIN

begin
select	max(ie_modo_registro)
into STRICT	ie_modo_registro_w
from	cirurgia_agente_anest_ocor
where	coalesce(ie_situacao,'A') = 'A'
and	nr_sequencia	=	(	SELECT	max(nr_sequencia)
					from	cirurgia_agente_anest_ocor
					where	nr_seq_cirur_agente	=	nr_seq_cirur_agente_p
					and	coalesce(ie_situacao,'A') = 'A');
exception
when others then
	ie_modo_registro_w	:= null;
end;

if (coalesce(ie_modo_registro_w::text, '') = '') then
	begin
	select	ie_modo_registro
	into STRICT	ie_modo_registro_w
	from	agente_anestesico
	where	nr_sequencia	=	(	SELECT	nr_seq_agente
						from	cirurgia_agente_anestesico
						where	nr_sequencia	=	nr_seq_cirur_agente_p);
	exception
	when others then
		ie_modo_registro_w	:= 'V';
	end;
end if;

return coalesce(ie_modo_registro_w,'V');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_modo_registro_agente ( nr_seq_cirur_agente_p bigint ) FROM PUBLIC;

