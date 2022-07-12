-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_acao_procedimento_alta ( nr_seq_proc_interno_p bigint, nr_seq_dispositivo_p bigint ) RETURNS varchar AS $body$
DECLARE


ie_acao_w	varchar(15);


BEGIN

if	(nr_seq_proc_interno_p > 0 AND nr_seq_dispositivo_p > 0) then
	begin
	select	max(ie_acao)
	into STRICT	ie_acao_w
	from	dispositivo_proc_interno
	where	nr_seq_proc_interno	=	nr_seq_proc_interno_p
	and	nr_seq_dispositivo	=	nr_seq_dispositivo_p
	and	ie_acao in ('O','A')
	and	ie_situacao = 'A';
	exception
	when others then
		ie_acao_w := null;
	end;
end if;

return	ie_acao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_acao_procedimento_alta ( nr_seq_proc_interno_p bigint, nr_seq_dispositivo_p bigint ) FROM PUBLIC;

