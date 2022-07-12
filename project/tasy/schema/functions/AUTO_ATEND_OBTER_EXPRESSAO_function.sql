-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION auto_atend_obter_expressao (cd_exp_p bigint, ds_pais_p text, cd_exp_dic_p bigint default null) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	att_desc_tela_idioma.ds_descricao%type;
nr_seq_desc_tela_w att_descricao_tela.nr_sequencia%type;
ie_dedo_w att_tela_biometria.ie_dedo%type;


BEGIN

  if (cd_exp_dic_p IS NOT NULL AND cd_exp_dic_p::text <> '') then

  	select 	CASE WHEN cd_exp_dic_p=490221 THEN 1 WHEN cd_exp_dic_p=490222 THEN 2 WHEN cd_exp_dic_p=490510 THEN 3 WHEN cd_exp_dic_p=490511 THEN 4 WHEN cd_exp_dic_p=490512 THEN 5 WHEN cd_exp_dic_p=490632 THEN 6 WHEN cd_exp_dic_p=490633 THEN 7 WHEN cd_exp_dic_p=490634 THEN 8 WHEN cd_exp_dic_p=490635 THEN 9 WHEN cd_exp_dic_p=490636 THEN 10  ELSE 0 END 
	into STRICT	ie_dedo_w
	;
	
	if (coalesce(ie_dedo_w,0) > 0) then
	  	select	coalesce(max(DS_DEDO_CLIENTE),obter_desc_expressao(cd_exp_dic_p))
	  	into STRICT	ds_retorno_w
	  	from	ATT_TELA_BIOMETRIA
	  	where	IE_DEDO = ie_dedo_w;		
	else
	 	ds_retorno_w := obter_desc_expressao(cd_exp_dic_p);
	end if;

  if (ds_pais_p IS NOT NULL AND ds_pais_p::text <> '')then 
  
    select max(nr_sequencia)
    into STRICT nr_seq_desc_tela_w
    from att_descricao_tela
    where ds_descricao = ds_retorno_w;

    if (nr_seq_desc_tela_w IS NOT NULL AND nr_seq_desc_tela_w::text <> '') then
    
      select coalesce(max(ds_descricao), ds_retorno_w)
      into STRICT  ds_retorno_w
      from ATT_DESC_TELA_IDIOMA
      where nr_seq_descricao = nr_seq_desc_tela_w;

    end if;

  end if;

  elsif (ds_pais_p IS NOT NULL AND ds_pais_p::text <> '') then
    
    select max(ds_descricao)
    into STRICT  ds_retorno_w
    from  att_desc_tela_idioma
    where nr_seq_descricao = cd_exp_p
    and   ds_idioma = lower(ds_pais_p);

  end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION auto_atend_obter_expressao (cd_exp_p bigint, ds_pais_p text, cd_exp_dic_p bigint default null) FROM PUBLIC;
