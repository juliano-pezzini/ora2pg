-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_todos_alertas_js ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
ds_alerta_w				varchar(2000);
dt_alerta_w				timestamp;
ds_retorno_w			varchar(10000);
ie_allow_free_text_w	tipo_alerta_atend.ie_allow_free_text%type;
nr_seq_alerta_w			atendimento_alerta.nr_seq_alerta%type;
nr_seq_tipo_alerta_w	atendimento_alerta.nr_seq_tipo_alerta%type;

c01 CURSOR FOR 
SELECT	a.dt_alerta, 
		a.ds_alerta, 
		a.nr_seq_alerta, 
		a.nr_seq_tipo_alerta 
from	atendimento_alerta a, 
		atendimento_paciente b 
where	b.cd_pessoa_fisica = cd_pessoa_fisica_p 
and		a.nr_atendimento = b.nr_atendimento 
and		a.ie_situacao = 'A' 
and		((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd'))) 
and		obter_se_tipo_alerta_lib(a.nr_seq_tipo_alerta,wheb_usuario_pck.get_nm_usuario)	= 'S' 

union all
 
SELECT	a.dt_alerta, 
		a.ds_alerta, 
		a.nr_seq_alerta, 
		a.nr_seq_tipo_alerta 
from	alerta_paciente a 
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
and		a.ie_situacao = 'A' 
and		((coalesce(a.dt_fim_alerta::text, '') = '') or (a.dt_fim_alerta >= trunc(clock_timestamp(),'dd'))) 
and		obter_se_tipo_alerta_lib(a.nr_seq_tipo_alerta,wheb_usuario_pck.get_nm_usuario)	= 'S' 
order by 1, 2;


BEGIN 
ds_retorno_w := '';
 
open c01;
loop 
fetch 	c01 into 
		dt_alerta_w, 
		ds_alerta_w, 
		nr_seq_alerta_w, 
		nr_seq_tipo_alerta_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	if (nr_seq_tipo_alerta_w IS NOT NULL AND nr_seq_tipo_alerta_w::text <> '') and (nr_seq_alerta_w IS NOT NULL AND nr_seq_alerta_w::text <> '') then 
		begin 
		select 	coalesce(max(ie_allow_free_text),'Y') 
		into STRICT	ie_allow_free_text_w 
		from	tipo_alerta_atend 
		where	nr_sequencia = nr_seq_tipo_alerta_w;
		 
		if (ie_allow_free_text_w = 'N') then 
			begin 
			select 	max(ds_alert) 
			into STRICT 	ds_alerta_w 
			from 	tipo_alerta_atend_option 
			where 	nr_sequencia = nr_seq_alerta_w;
			end;
		end if;
		end;
	end if;
	ds_retorno_w := ds_retorno_w || pkg_date_formaters.to_varchar(dt_alerta_w, 'timestamp', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) || ' - ' || ds_alerta_w || '#@#@';
end loop;
close c01;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_todos_alertas_js ( cd_pessoa_fisica_p text) FROM PUBLIC;
