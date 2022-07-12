-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nome_pf_home_care_concat ( nr_seq_p bigint, dt_parametro_ini_p timestamp, dt_parametro_fim_p timestamp) RETURNS varchar AS $body$
DECLARE

				 
ds_retorno_w varchar(4000) := '';
nm_pessoa_w varchar(255);

C01 CURSOR FOR 
SELECT 	distinct 
	obter_nome_pf(x.cd_pessoa_fisica) 
from 	paciente_home_care x, 
	hc_pac_equipamento y 
where 	coalesce(x.dt_final::text, '') = '' 
and 	y.nr_seq_paciente = x.nr_sequencia 
and 	(y.nr_seq_equip_control IS NOT NULL AND y.nr_seq_equip_control::text <> '') 
and 	y.nr_seq_equip_control = nr_seq_p 
and	((dt_parametro_ini_p  between dt_inicio_utilizacao and dt_fim_utilizacao) or (dt_parametro_fim_p  between dt_inicio_utilizacao and dt_fim_utilizacao) or (dt_inicio_utilizacao between dt_parametro_ini_p and dt_parametro_fim_p) or (dt_fim_utilizacao  between dt_parametro_ini_p and dt_parametro_fim_p) or (coalesce(dt_fim_utilizacao::text, '') = '')) 
order by 1;


BEGIN 
 
if (nr_seq_p IS NOT NULL AND nr_seq_p::text <> '') then 
	open C01;
	loop 
	fetch C01 into 
		nm_pessoa_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_retorno_w := ds_retorno_w || nm_pessoa_w || ','|| chr(13) || chr(10);
	end;
	end loop;
	close C01;
end if;
 
if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then 
	ds_retorno_w := substr( ds_retorno_w ,1,length( ds_retorno_w )-1);
end if;
ds_retorno_w:= wheb_mensagem_pck.get_texto(802874) || ' ' || chr(13) || chr(10) || ds_retorno_w;
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_pf_home_care_concat ( nr_seq_p bigint, dt_parametro_ini_p timestamp, dt_parametro_fim_p timestamp) FROM PUBLIC;
