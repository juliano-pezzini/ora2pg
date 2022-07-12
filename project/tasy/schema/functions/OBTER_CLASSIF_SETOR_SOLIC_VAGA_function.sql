-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_setor_solic_vaga (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);
vl_param_w		varchar(255);
nr_sequencia_w	gestao_vaga.nr_sequencia%type;

BEGIN
if (coalesce(nr_atendimento_p,0) > 0) then
	begin
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from 	gestao_vaga
		where	nr_atendimento = nr_atendimento_p
		and		(cd_setor_desejado IS NOT NULL AND cd_setor_desejado::text <> '')
		and		(cd_unidade_basica IS NOT NULL AND cd_unidade_basica::text <> ''); 					

		if (coalesce(nr_sequencia_w,0) > 0) then
			select	max(obter_valor_dominio(1,obter_classif_setor(cd_setor_desejado)))
			into STRICT	ds_retorno_w
			from 	gestao_vaga
			where	nr_sequencia = nr_sequencia_w;
		end if;
	exception
	when others then
		ds_retorno_w := null;
	end;
	
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_setor_solic_vaga (nr_atendimento_p bigint) FROM PUBLIC;
