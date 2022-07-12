-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.man_obter_dono_estouro_sla ( ie_estouro_p text, ie_dono_estouro_p text, nr_seq_grupo_sup_p bigint, nr_seq_grupo_des_p bigint ) RETURNS varchar AS $body$
DECLARE


ds_dono_estouro_w	varchar(255);
	

BEGIN

if (ie_estouro_p = 'Y' and ie_dono_estouro_p in ('DES','TEC') and (nr_seq_grupo_des_p IS NOT NULL AND nr_seq_grupo_des_p::text <> '')) then
	select  max(obter_desc_expressao_idioma(a2.cd_exp_gerencia,a2.ds_gerencia,5)) || ' | ' || max(obter_desc_expressao_idioma(a1.cd_exp_grupo,a1.ds_grupo,5))
	into STRICT	ds_dono_estouro_w
	from    grupo_desenvolvimento a1,
		gerencia_wheb a2
	where  a2.nr_sequencia = a1.nr_seq_gerencia
	and    a1.nr_sequencia = nr_seq_grupo_des_p;
	
elsif (ie_estouro_p = 'Y' and ie_dono_estouro_p = 'SUP' and (nr_seq_grupo_sup_p IS NOT NULL AND nr_seq_grupo_sup_p::text <> '')) then
	select  max(obter_desc_expressao_idioma(a2.cd_exp_gerencia,a2.ds_gerencia,5)) || ' | ' || max(obter_desc_expressao_idioma(a1.cd_exp_grupo,a1.ds_grupo,5))
	into STRICT	ds_dono_estouro_w
	from    grupo_suporte a1,
		gerencia_wheb a2
	where   a2.nr_sequencia = a1.nr_seq_gerencia_sup
	and     a1.nr_sequencia = nr_seq_grupo_sup_p;
	
elsif (ie_estouro_p = 'Y' and coalesce(ie_dono_estouro_p::text, '') = '') or (ie_estouro_p = 'Y' and coalesce(nr_seq_grupo_sup_p::text, '') = '' and coalesce(nr_seq_grupo_des_p::text, '') = '') then
	select	max(obter_desc_expressao_idioma(342888,'Undefined group',5))
	into STRICT	ds_dono_estouro_w
	;
end if;

return ds_dono_estouro_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.man_obter_dono_estouro_sla ( ie_estouro_p text, ie_dono_estouro_p text, nr_seq_grupo_sup_p bigint, nr_seq_grupo_des_p bigint ) FROM PUBLIC;