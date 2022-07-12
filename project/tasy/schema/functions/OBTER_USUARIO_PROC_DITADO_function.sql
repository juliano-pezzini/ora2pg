-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_proc_ditado (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

nm_usuario_w		varchar(15);
nr_sequencia_w	bigint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescricao_p IS NOT NULL AND nr_seq_prescricao_p::text <> '') then
	begin
    	select  nr_seq_interno
    	into STRICT    nr_sequencia_w
    	from    prescr_procedimento
    	where   nr_prescricao	= nr_prescricao_p
	and	nr_sequencia		= nr_seq_prescricao_p;

	if (coalesce(nr_sequencia_w,0) > 0) then
		begin
		select	nm_usuario
		into STRICT	nm_usuario_w
		from	prescr_proc_ditado
		where	nr_seq_prescr_proc = nr_sequencia_w;
		end;
	end if;
    	end;
end if;
RETURN	nm_usuario_w;
END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_proc_ditado (nr_prescricao_p bigint, nr_seq_prescricao_p bigint) FROM PUBLIC;
