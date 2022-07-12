-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_equip_unidade (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, ds_equipamentos_p text) RETURNS varchar AS $body$
DECLARE


ds_equipamentos_unid_w	varchar(20000);

nr_sequencia_w		unidade_atend_equip.nr_sequencia%type;
ds_equipamentos_param_w	dbms_sql.varchar2_table;
ie_retorno_w		varchar(1);

c01 CURSOR FOR
	SELECT	cd_equipamento
	from	unidade_atend_equip
	where	cd_setor_atendimento = cd_setor_atendimento_p
	and	cd_unidade_basica = cd_unidade_basica_p
	and	cd_unidade_compl = cd_unidade_compl_p;

BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_equipamentos_unid_w := ds_equipamentos_unid_w || nr_sequencia_w || ',';
end loop;
close c01;

ds_equipamentos_param_w := obter_lista_string(ds_equipamentos_p, ',');

for i in ds_equipamentos_param_w.first..ds_equipamentos_param_w.last loop

	if (obter_se_contido_char_separ(ds_equipamentos_param_w(i), ds_equipamentos_unid_w, ',') = 'N') then
		return 'N';
	end if;
end loop;

return	'S';

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_equip_unidade (cd_setor_atendimento_p bigint, cd_unidade_basica_p text, cd_unidade_compl_p text, ds_equipamentos_p text) FROM PUBLIC;
