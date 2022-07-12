-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nqf_pessoa_juridica ( cd_cnpj_p text, dt_inicio_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE

 
			 
cd_tipo_pessoa_w		smallint;
ie_servico_w			varchar(1);
qt_ac_w				double precision;
qt_ac_ww			bigint;
qt_aq_w				double precision;
qt_aq_ww			bigint;
qt_ad_w				double precision;
qt_ad_ww			bigint;
qt_nqf_w			double precision := 0;


BEGIN 
select	cd_tipo_pessoa 
into STRICT	cd_tipo_pessoa_w 
from	pessoa_juridica 
where	cd_cgc = cd_cnpj_p;
 
select	coalesce(max(ie_servico),'N') 
into STRICT	ie_servico_w 
from	tipo_pessoa_juridica 
where	cd_tipo_pessoa	= cd_tipo_pessoa_w;
 
/*select	nvl(sum(vl_media),0) vl_media, 
	count(1) 
into	qt_ac_w, 
	qt_ac_ww 
from	avf_resultado a, 
	avf_tipo_avaliacao b 
where	a.nr_seq_tipo_aval					= b.nr_sequencia 
and	b.ie_situacao						= 'A' 
and	cd_cnpj							= cd_cnpj_p 
and	substr(obter_se_avf_tipo_lib(b.nr_sequencia),1,1)	= 'S' 
and	b.ie_tipo						= 'AC' 
and	((dt_inicio_vigencia is null) or (dt_fim_vigencia is null) or 
	((dt_inicio_vigencia <= dt_inicio_p) and (dt_fim_vigencia >= dt_final_p))); 
 
select	nvl(sum(vl_media),0) vl_media, 
	count(1) 
into	qt_aq_w, 
	qt_aq_ww 
from	avf_resultado		a, 
	avf_tipo_avaliacao	b 
where	a.nr_seq_tipo_aval					= b.nr_sequencia 
and	b.ie_situacao						= 'A' 
and	cd_cnpj							= cd_cnpj_p 
and	substr(obter_se_avf_tipo_lib(b.nr_sequencia),1,1)	= 'S' 
and	b.ie_tipo						= 'AQ' 
and	((dt_inicio_vigencia is null) or (dt_fim_vigencia is null) or 
	((dt_inicio_vigencia <= dt_inicio_p) and (dt_fim_vigencia >= dt_final_p)));*/
 
	 
select	max(coalesce(a.vl_media,0)) vl_media, 
	count(1) 
into STRICT	qt_ac_w, 
	qt_ac_ww 
from	avf_resultado a 
where	a.dt_avaliacao =(SELECT	max(a.dt_avaliacao) 
						from	avf_resultado a, 
							avf_tipo_avaliacao b 
						where	a.nr_seq_tipo_aval = b.nr_sequencia 
						and	b.ie_situacao = 'A' 
						and   substr(obter_se_avf_tipo_lib(b.nr_sequencia),1,1) = 'S' 
						and	((coalesce(dt_inicio_vigencia::text, '') = '') or (coalesce(dt_fim_vigencia::text, '') = '') or 
							(dt_inicio_vigencia <= dt_inicio_p AND dt_fim_vigencia >= dt_final_p )) 
						and 	ie_tipo = 'AC'		 
						and	cd_cnpj = cd_cnpj_p);
						 
select	max(coalesce(a.vl_media,0)) vl_media, 
	count(1) 
into STRICT	qt_aq_w, 
	qt_aq_ww 
from	avf_resultado a 
where	a.dt_avaliacao =(SELECT	max(a.dt_avaliacao) 
						from	avf_resultado a, 
							avf_tipo_avaliacao b 
						where	a.nr_seq_tipo_aval = b.nr_sequencia 
						and	b.ie_situacao = 'A' 
						and   substr(obter_se_avf_tipo_lib(b.nr_sequencia),1,1) = 'S' 
						and	((coalesce(dt_inicio_vigencia::text, '') = '') or (coalesce(dt_fim_vigencia::text, '') = '') or 
							(dt_inicio_vigencia <= dt_inicio_p AND dt_fim_vigencia >= dt_final_p )) 
						and 	ie_tipo = 'AQ'		 
						and	cd_cnpj = cd_cnpj_p);						
 
if (ie_servico_w = 'N') then 
	select	coalesce(obter_result_aval_desempenho(dt_inicio_p, dt_final_p, cd_cnpj_p, cd_estabelecimento_p, 'AD'),0) qt_aval_desempenho, 
		coalesce(obter_result_aval_desempenho(dt_inicio_p, dt_final_p, cd_cnpj_p, cd_estabelecimento_p, 'QA'),0) qt_avaliacao 
	into STRICT	qt_ad_w, 
		qt_ad_ww 
	;
	 
	/*if	(qt_ac_ww = 0) then 
		qt_ac_w	:= 100; 
	end if;*/
 
	 
	if (qt_aq_ww = 0) then 
		qt_aq_w	:= 100;
	end if;
	 
	if (qt_ad_ww = 0) then 
		qt_ad_w	:= 100;
	end if;
 
	/*Essa multiplicação é fixa, a pedido do cliente na OS 351397*/
 
	qt_ac_w	:= qt_ac_w * 3;
	qt_aq_w	:= qt_aq_w * 3;
	qt_ad_w	:= qt_ad_w * 4;
	 
	qt_nqf_w	:= ((qt_ac_w + qt_aq_w + qt_ad_w) / (3 + 3 + 4));
else 
	qt_nqf_w	:= ((qt_ac_w + qt_aq_w) * 50);
end if;	
 
return	qt_nqf_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nqf_pessoa_juridica ( cd_cnpj_p text, dt_inicio_p timestamp, dt_final_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;

