-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_lista_equip_vinc ( nr_seq_equip_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
ds_leito_w	varchar(255);

C01 CURSOR FOR
	SELECT 	substr(b.ds_setor_atendimento||' ('||(obter_desc_expressao(292477,'Leito')||': '||a.cd_unidade_basica || ' ' || a.cd_unidade_compl||')'),1,255) ds_leito
	from   	unidade_atend_equip  a,
		setor_atendimento b
	where 	a.cd_setor_atendimento = b.cd_setor_atendimento
	and	cd_equipamento = nr_seq_equip_p
	order by b.ds_setor_atendimento,a.cd_unidade_basica,a.cd_unidade_compl;
	

BEGIN
if (coalesce(nr_seq_equip_p,0) > 0) then
	open C01;
	loop
	fetch C01 into	
		ds_leito_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			if (coalesce(ds_retorno_w::text, '') = '') then
				ds_retorno_w := ds_leito_w;
			else
				ds_retorno_w := substr(ds_retorno_w||', '||ds_leito_w,1,4000);
			end if;
		end;
	end loop;
	close C01;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_lista_equip_vinc ( nr_seq_equip_p bigint) FROM PUBLIC;
