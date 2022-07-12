-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ple_obter_se_responsavel ( nm_usuario_resp_p text, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_responsavel_w	varchar(1);
qt_resp_w		integer;


BEGIN 
 
ie_responsavel_w	:= 'N';
 
/*Identifica se o usuario é responsável da ação*/
 
select	count(*) 
into STRICT	qt_resp_w 
from	man_ordem_servico_exec c, 
	man_ordem_servico b, 
	ple_meta a	 
where	b.nr_sequencia = nr_sequencia_p 
and	a.nr_sequencia = b.nr_seq_meta_pe 
and	b.nr_sequencia = c.nr_seq_ordem 
and	c.nm_usuario_exec = nm_usuario_resp_p;
if (qt_resp_w > 0) then 
	ie_responsavel_w	:= 'S';
elsif (qt_resp_w = 0) then 
	/*Identifica se o usuario é responsável pela meta*/
 
	select	count(*) 
	into STRICT	qt_resp_w 
	from	ple_meta b, 
		man_ordem_servico a 
	where	a.nr_sequencia = nr_sequencia_p 
	and	b.nr_sequencia = a.nr_seq_meta_pe 
	and	b.cd_pf_resp = substr(obter_pessoa_fisica_usuario(nm_usuario_resp_p,'C'),1,10);
	if (qt_resp_w > 0) then 
		ie_responsavel_w	:= 'S';
	elsif (qt_resp_w = 0) then 
		/*Identifica se o usuario é responsável pelo objetivo*/
 
		select	count(*) 
		into STRICT	qt_resp_w 
		from	ple_objetivo c, 
			ple_meta b, 
			man_ordem_servico a 
		where	a.nr_sequencia = nr_sequencia_p 
		and	b.nr_sequencia = a.nr_seq_meta_pe 
		and	b.nr_seq_objetivo = c.nr_sequencia 
		and	c.cd_pf_resp = substr(obter_pessoa_fisica_usuario(nm_usuario_resp_p,'C'),1,10);
		if (qt_resp_w > 0) then 
			ie_responsavel_w	:= 'S';
		end if;
	end if;
end if;
 
return ie_responsavel_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ple_obter_se_responsavel ( nm_usuario_resp_p text, nr_sequencia_p bigint) FROM PUBLIC;
