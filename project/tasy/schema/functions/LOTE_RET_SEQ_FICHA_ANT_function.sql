-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lote_ret_seq_ficha_ant (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
nr_seq_ficha_lote_ant_w		bigint;
				

BEGIN 
 
select	max(a.nr_seq_ficha_lote_ant) 
into STRICT	nr_seq_ficha_lote_ant_w 
from	atendimento_paciente a 
where	a.nr_atendimento = nr_atendimento_p;
 
return	nr_seq_ficha_lote_ant_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lote_ret_seq_ficha_ant (nr_atendimento_p bigint) FROM PUBLIC;

