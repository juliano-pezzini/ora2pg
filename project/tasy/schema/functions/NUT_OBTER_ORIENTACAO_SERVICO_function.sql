-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nut_obter_orientacao_servico (nr_seq_nut_atend_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_orientacao_w			varchar(4000) := '';			
nr_seq_orientacao_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_seq_servico_w			bigint;
dt_servico_w			timestamp;
			

BEGIN 
 
select	obter_pessoa_atendimento(nr_atendimento,'C'), 
	nr_seq_servico, 
	dt_servico 
into STRICT	cd_pessoa_fisica_w, 
	nr_seq_servico_w, 
	dt_servico_w 
from	nut_atend_serv_dia 
where	nr_sequencia = nr_seq_nut_atend_p;
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_orientacao_w 
from	nut_orientacao 
where	cd_pessoa_fisica = cd_pessoa_fisica_w 
and	nr_seq_servico = nr_seq_servico_w 
and	ie_situacao = 'A' 
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
and	((dt_final > dt_servico_w) or (coalesce(dt_final::text, '') = ''));
 
if (nr_seq_orientacao_w > 0) then 
	select	ds_orientacao 
	into STRICT	ds_orientacao_w 
	from	nut_orientacao 
	where	nr_sequencia = nr_seq_orientacao_w;
end if;	
 
return	ds_orientacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nut_obter_orientacao_servico (nr_seq_nut_atend_p bigint) FROM PUBLIC;
