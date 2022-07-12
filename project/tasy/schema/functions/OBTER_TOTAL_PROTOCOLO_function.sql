-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_protocolo (nr_seq_protocolo_p bigint) RETURNS bigint AS $body$
DECLARE



vl_protocolo_w		double precision;
ie_status_protocolo_w	smallint;


BEGIN

/* Ricardo 11/04/2007 - Ninguem altere nada nessa function sem falar comigo por favor
			Causa uma série de transtornos de performance no Protocolo */
if (nr_seq_protocolo_p IS NOT NULL AND nr_seq_protocolo_p::text <> '') then
	begin

	select	sum(vl_conta)
	into STRICT	vl_protocolo_w
	from	conta_paciente
	where	nr_seq_protocolo	= nr_seq_protocolo_p;

	/*select	nvl(sum(nvl(a.vl_item,0)),0) vl_item
	into	vl_protocolo_w
	from	protocolo_convenio_item_v3 a
	where	a.nr_seq_protocolo = nr_seq_protocolo_p
	and 	(nvl(a.nr_seq_proc_pacote,a.nr_sequencia) = a.nr_sequencia); */
	end;
end if;

return vl_protocolo_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_protocolo (nr_seq_protocolo_p bigint) FROM PUBLIC;
