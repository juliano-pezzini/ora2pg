-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_volume_soluc_etapa ( nr_prescricao_p bigint, nr_Seq_solucao_p bigint) RETURNS varchar AS $body$
DECLARE


cd_unidade_medida_w			varchar(30);
ds_total_w					varchar(60);
ds_bomba_w					varchar(40);
ds_dosagem_w				varchar(60);
ds_solucao_w				varchar(100);
ds_retorno_w				varchar(255);
ie_esquema_alternado_w		varchar(1);
ds_acm_agora_w				varchar(20);
qt_volume_w					double precision;
qt_hora_fase_w				double precision;


BEGIN
if (coalesce(nr_prescricao_p,0) <> 0) then
	begin
	select	qt_volume,
		cd_unidade_medida,
		qt_hora_fase,
		ds_solucao,
		CASE WHEN ie_bomba_infusao='S' THEN  obter_desc_expressao(727792)/*'em bomba infusion'*/ WHEN ie_bomba_infusao='A' THEN obter_desc_expressao(727796)/*'em bomba seringa'*/  ELSE '' END ,
		CASE WHEN upper(ie_tipo_dosagem)='ACM' THEN  '(ACM)'  ELSE qt_dosagem  || CASE WHEN upper(ie_tipo_dosagem)='MGM' THEN 'mcg/m'  ELSE ie_tipo_dosagem END  || CASE WHEN ie_acm='S' THEN  ' ACM'  ELSE '' END  END  || CASE WHEN ie_urgencia='S' THEN obter_desc_expressao(283261)/*' Agora'*/  ELSE '' END ,
		CASE WHEN ie_acm='S' THEN  ' ACM'  ELSE '' END  || CASE WHEN ie_urgencia='S' THEN obter_desc_expressao(283261)/*' Agora'*/  ELSE '' END ,
		ie_esquema_alternado
	into STRICT	qt_volume_w,
		cd_unidade_medida_w,
		qt_hora_fase_w,
		ds_solucao_w,
		ds_bomba_w,
		ds_dosagem_w,
		ds_acm_agora_w,
		ie_esquema_alternado_w
	from 	prescr_solucao
	where	nr_prescricao 	= nr_prescricao_p
	and	nr_seq_solucao	= nr_seq_solucao_p;

	if (coalesce(qt_volume_w, 0) <> 0) then
		ds_total_w	:= 'Vol. ' || qt_volume_w || cd_unidade_medida_w || '/'|| qt_hora_fase_w || 'h';
	else
		ds_total_w	:= '';
	end if;
	if (ie_esquema_alternado_w = 'N') then
		ds_retorno_w	:= ds_total_w || ' a ' || ds_dosagem_w || ' ' || ds_bomba_w;
	else
		ds_retorno_w	:= ds_total_w || obter_desc_expressao(288235)/*' Dose diferenciada '*/
 || ds_acm_agora_w ||' '|| ds_bomba_w;
	end if;
	if (ds_solucao_w IS NOT NULL AND ds_solucao_w::text <> '') then
		ds_retorno_w	:= ds_retorno_w || ' (' || ds_solucao_w || ')';
	end if;
	end;
end if;

RETURN replace(replace(replace(ds_retorno_w,' .',' 0,'),' ,',' 0,'),'/,','/0,');
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_volume_soluc_etapa ( nr_prescricao_p bigint, nr_Seq_solucao_p bigint) FROM PUBLIC;
