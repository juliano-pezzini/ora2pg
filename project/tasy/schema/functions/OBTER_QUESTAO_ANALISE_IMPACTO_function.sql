-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_questao_analise_impacto (nr_sequencia_p man_ordem_serv_imp_quest.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_pergunta_w	man_ordem_serv_imp_quest.ds_pergunta%type;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
		select	substr(ds_pergunta, 1, 255)
		into STRICT	ds_pergunta_w
		from	man_ordem_serv_imp_quest
		where	nr_sequencia = nr_sequencia_p;
	end;
end if;

return ds_pergunta_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_questao_analise_impacto (nr_sequencia_p man_ordem_serv_imp_quest.nr_sequencia%type) FROM PUBLIC;

