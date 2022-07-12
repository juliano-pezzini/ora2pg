-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_paciente_pato_lote (nr_seq_lote_p bigint) RETURNS varchar AS $body$
DECLARE

 
			 
			 
cd_pessoa_fisica_w		varchar(10);

BEGIN
 
 
 
select 	max(a.cd_pessoa_fisica) 
into STRICT	cd_pessoa_fisica_w 
from	atendimento_paciente a, 
	frasco_pato_loc c, 
	prescr_medica b 
where	b.nr_prescricao 	= c.nr_prescricao  			  		 
and	a.nr_atendimento 	= b.nr_atendimento	 
and	c.nr_seq_lote		= nr_seq_lote_p;
 
 
return	cd_pessoa_fisica_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_paciente_pato_lote (nr_seq_lote_p bigint) FROM PUBLIC;
