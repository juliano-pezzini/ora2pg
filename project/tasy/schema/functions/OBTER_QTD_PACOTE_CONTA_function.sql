-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtd_pacote_conta (nr_interno_conta_p bigint) RETURNS bigint AS $body$
DECLARE

 
qt_item_w		double precision;
			

BEGIN 
 
select	sum(a.qt_item) 
into STRICT	qt_item_w 
from	conta_paciente_v a 
where	a.nr_interno_conta	= nr_interno_conta_p 
and	coalesce(a.cd_motivo_exc_conta::text, '') = '' 
and	coalesce(a.nr_seq_proc_pacote,a.nr_sequencia) = a.nr_sequencia;
 
return	qt_item_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_pacote_conta (nr_interno_conta_p bigint) FROM PUBLIC;
