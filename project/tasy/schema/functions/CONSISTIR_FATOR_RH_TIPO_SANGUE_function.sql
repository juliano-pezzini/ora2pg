-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consistir_fator_rh_tipo_sangue ( nr_seq_exame_lote_p bigint, nr_seq_exame_p bigint, nr_seq_producao_p bigint, ie_tipo_p text, ie_fator_rh_p text, ie_tipo_sangue_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


-- ie_tipo_p = H - Hemocomponente  E- Exames de bolsa			
			
ds_resul_fator_rh_w		varchar(255);		
ds_resul_tipo_sangue_w		varchar(255);
ds_retorno_w			varchar(1) := 'N';	
nr_seq_exame_rh_param_w 	bigint;
nr_seq_exame_tipo_param_w       bigint;
ie_fator_rh_w			varchar(255);
ie_tipo_sangue_w		varchar(255);


BEGIN

SELECT 	max(nr_seq_exame_RH),
	max(nr_seq_exame_tipo)
into STRICT	nr_seq_exame_rh_param_w,
	nr_seq_exame_tipo_param_w
FROM 	san_parametro
where	cd_estabelecimento = cd_estabelecimento_p;

ie_tipo_sangue_w := ie_tipo_sangue_p;
ie_fator_rh_w	 := ie_fator_rh_p;
ds_resul_fator_rh_w 	:= obter_result_san_exame_real(nr_seq_exame_lote_p,'RH', cd_estabelecimento_p);
ds_resul_tipo_sangue_w 	:= obter_result_san_exame_real(nr_seq_exame_lote_p,'TS', cd_estabelecimento_p);

if (ie_tipo_p = 'H') then -- Hemocomponentes
	if 	(((ds_resul_fator_rh_w = ie_fator_rh_w) or (coalesce(ds_resul_fator_rh_w::text, '') = '')) and
		((ds_resul_tipo_sangue_w = ie_tipo_sangue_w) or (coalesce(ds_resul_tipo_sangue_w::text, '') = ''))) then
		ds_retorno_w := 'S';
	end if;
else -- Exames de bolsa
	select 	max(coalesce(ie_fator_rh,null)),
		max(coalesce(ie_tipo_sangue,null))
	into STRICT	ds_resul_fator_rh_w,
		ds_resul_tipo_sangue_w
	from   	san_producao_inutilizacao_v
	where  	nr_sequencia = nr_seq_producao_p;
	
	if (nr_seq_exame_p = nr_seq_exame_rh_param_w) then --Se alterou fator RH , buscar a informacao do tipo do sangue
		if	((((ds_resul_fator_rh_w = '-') or (upper(substr(ds_resul_fator_rh_w,1,3))	= 'NEG')) and
			((ie_fator_rh_w = '-') or (upper(substr(ie_fator_rh_w,1,3))			= 'NEG'))) or
			(((ds_resul_fator_rh_w= '+') or (upper(substr(ds_resul_fator_rh_w,1,3))		= 'POS')) and
			((ie_fator_rh_w = '+') or (upper(substr(ie_fator_rh_w,1,3))			= 'POS')))) then
			ds_retorno_w := 'S';	
		end if;
	elsif (nr_seq_exame_p = nr_seq_exame_tipo_param_w) then
		if (ds_resul_tipo_sangue_w = ie_tipo_sangue_w) then
				ds_retorno_w := 'S';
		end if;
	else
		ds_retorno_w := 'S';
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consistir_fator_rh_tipo_sangue ( nr_seq_exame_lote_p bigint, nr_seq_exame_p bigint, nr_seq_producao_p bigint, ie_tipo_p text, ie_fator_rh_p text, ie_tipo_sangue_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
