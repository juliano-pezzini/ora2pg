-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_label_grafico_pepo ( nr_seq_cirur_agente_p bigint ) RETURNS varchar AS $body$
DECLARE



ie_modo_registro_w	varchar(1);
nr_seq_agente_w		bigint;
ie_forma_farmaceutica_w	varchar(10);
ds_retorno_w		varchar(255);
cd_unid_medida_adm_w	varchar(30);
ie_modo_adm_w		varchar(5);
ds_via_aplicacao_w	varchar(100);
ie_unid_med_resumida_w  varchar(1);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(489284, null, wheb_usuario_pck.get_nr_seq_idioma);--% de mistura
expressao2_w	varchar(255) := obter_desc_expressao_idioma(288220, null, wheb_usuario_pck.get_nr_seq_idioma);--Dose
BEGIN

select	max(nr_seq_agente),
	CASE WHEN obter_config_pepo_graf('U')='S' THEN max(cd_unid_medida_adm)  ELSE '' END ,
    CASE WHEN SUBSTR(obter_desc_via(MAX(ie_via_aplicacao)),1,100) IS NULL THEN ''  ELSE MAX(ie_via_aplicacao) ||' \ '||SUBSTR(obter_desc_via(MAX(ie_via_aplicacao)),1,100) END ,
	max(ie_modo_adm)
into STRICT	nr_seq_agente_w,
	cd_unid_medida_adm_w,
	ds_via_aplicacao_w,
	ie_modo_adm_w
from	cirurgia_agente_anestesico
where	nr_sequencia	=	nr_seq_cirur_agente_p
and	coalesce(ie_situacao,'A') = 'A';

SELECT	max(ie_forma_farmaceutica),
	CASE WHEN obter_config_pepo_graf('U')='S' THEN max(ie_unid_med_resumida)  ELSE '' END
INTO STRICT	ie_forma_farmaceutica_w,
	ie_unid_med_resumida_w
FROM	agente_anestesico
WHERE	nr_sequencia	=	nr_seq_agente_w;

if	((ie_modo_adm_w = 'CO') or (ie_modo_adm_w = 'AC')) and (ie_forma_farmaceutica_w = 'LG') then
	begin
	select	max(ie_modo_registro)
	into STRICT	ie_modo_registro_w
	from	cirurgia_agente_anest_ocor a,
		cirurgia_agente_anestesico b
	where	a.nr_seq_cirur_agente = b.nr_sequencia
	and	b.nr_sequencia	=	nr_seq_cirur_agente_p
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	coalesce(b.ie_situacao,'A') = 'A';
	exception
	when others then
		ie_modo_registro_w	:= null;
	end;

	if (coalesce(ie_modo_registro_w::text, '') = '') then
		select	coalesce(ie_modo_registro,'V')
		into STRICT	ie_modo_registro_w
		from	agente_anestesico
		where	nr_sequencia	=	nr_seq_agente_w;
	end if;

	if (ie_modo_registro_w = 'M') then
		ds_retorno_w	:= expressao1_w;
	else
		select	CASE WHEN obter_config_pepo_graf('U')='S' THEN CASE WHEN coalesce(ie_unid_med_resumida_w,'N')='N' THEN obter_valor_dominio(1580,max(ie_tipo_dosagem)) WHEN coalesce(ie_unid_med_resumida_w,'N')='S' THEN max(ie_tipo_dosagem) END   ELSE '' END ||CASE WHEN obter_config_pepo_graf('D')='S' THEN '  '||expressao2_w||' ('|| max(qt_dose)||') '  ELSE '' END
		into STRICT	ds_retorno_w
		from	cirurgia_agente_anestesico
		where	nr_sequencia		= nr_seq_cirur_agente_p
		and	coalesce(ie_situacao,'A') 	= 'A';
	end if;

elsif (ie_modo_adm_w = 'CO') then
	select	CASE WHEN obter_config_pepo_graf('U')='S' THEN CASE WHEN coalesce(ie_unid_med_resumida_w,'N')='N' THEN obter_valor_dominio(1580,max(ie_tipo_dosagem)) WHEN coalesce(ie_unid_med_resumida_w,'N')='S' THEN max(ie_tipo_dosagem) END   ELSE '' END  ||CASE WHEN obter_config_pepo_graf('D')='S' THEN '  '||expressao2_w||' ('|| max(qt_dose)||') '  ELSE '' END
	into STRICT	ds_retorno_w
	from	cirurgia_agente_anestesico
	where	nr_sequencia	=	nr_seq_cirur_agente_p
	and	coalesce(ie_situacao,'A') 	= 'A';
elsif (ie_modo_adm_w = 'IN') then
	select	CASE WHEN coalesce(ie_unid_med_resumida_w,'N')='N' THEN substr(obter_desc_unid_med(max(cd_unid_medida_adm)),1,25) WHEN coalesce(ie_unid_med_resumida_w,'N')='S' THEN max(cd_unid_medida_adm) END ||CASE WHEN obter_config_pepo_graf('D')='S' THEN '  '||expressao2_w||' ('|| max(qt_dose)||') '  ELSE '' END
	into STRICT	ds_retorno_w
	from	cirurgia_agente_anestesico
	where	nr_sequencia	=	nr_seq_cirur_agente_p
	and	coalesce(ie_situacao,'A') 	= 'A';
elsif (ie_modo_adm_w = 'AC') then
	select	CASE WHEN obter_config_pepo_graf('U')='S' THEN coalesce(CASE WHEN coalesce(ie_unid_med_resumida_w,'N')='N' THEN substr(obter_desc_unid_med(max(cd_unid_medida_adm)),1,25) WHEN coalesce(ie_unid_med_resumida_w,'N')='S' THEN max(cd_unid_medida_adm) END ,				CASE WHEN coalesce(ie_unid_med_resumida_w,'N')='N' THEN obter_valor_dominio(1580,max(ie_tipo_dosagem)) WHEN coalesce(ie_unid_med_resumida_w,'N')='S' THEN max(ie_tipo_dosagem) END )  ELSE '' END ||CASE WHEN obter_config_pepo_graf('D')='S' THEN '  '||expressao2_w||' ('|| max(qt_dose)||') '  ELSE '' END
	into STRICT	ds_retorno_w
	from	cirurgia_agente_anestesico
	where	nr_sequencia	=	nr_seq_cirur_agente_p
	and	coalesce(ie_situacao,'A') 	= 'A';
end if;

if (obter_config_pepo_graf('V')  = 'S')then
    if (coalesce(ds_via_aplicacao_w::text, '') = '')  and (coalesce(ds_retorno_w::text, '') = '') then
		RETURN '';
	else
		RETURN '(' || ds_retorno_w || ds_via_aplicacao_w || ')';
	end if;
end if;
return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_label_grafico_pepo ( nr_seq_cirur_agente_p bigint ) FROM PUBLIC;
