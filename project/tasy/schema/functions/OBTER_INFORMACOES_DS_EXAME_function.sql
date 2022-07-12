-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacoes_ds_exame (ds_dado_clinico_p text default ' ', ds_resumo_clinico_p text default ' ', ds_exame_fis_achado_cirur_p text default ' ', ds_justificativa_p text default ' ', ds_observacao_p text default ' ', ie_quebra_linha_p text default 'N') RETURNS varchar AS $body$
DECLARE


ds_retorno_w   varchar(12000) := ' ';


BEGIN

if (ds_dado_clinico_p <> ' ') and (ds_dado_clinico_p IS NOT NULL AND ds_dado_clinico_p::text <> '') then
	select  obter_desc_expressao(291307,'Hipótese diagnóstica') ||':'|| CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END  || ds_dado_clinico_p || CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END
	into STRICT	ds_retorno_w
	;
end if;
if (ds_resumo_clinico_p <> ' ') and (ds_resumo_clinico_p IS NOT NULL AND ds_resumo_clinico_p::text <> '') then
	select  ds_retorno_w || obter_desc_expressao(297849,'Resumo clínico') ||':'|| CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END  || ds_resumo_clinico_p || CASE WHEN ie_quebra_linha_p='S' THEN  chr(13) || chr(10)  ELSE ' ' END
	into STRICT	ds_retorno_w
	;
end if;
if (ds_exame_fis_achado_cirur_p <> ' ') and (ds_exame_fis_achado_cirur_p IS NOT NULL AND ds_exame_fis_achado_cirur_p::text <> '') then
	select  ds_retorno_w || obter_desc_expressao(289705,'Exame físico/Achado cirúrgico') ||':'|| CASE WHEN ie_quebra_linha_p='S' THEN  chr(13) || chr(10)  ELSE ' ' END  || ds_exame_fis_achado_cirur_p || CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END
	into STRICT	ds_retorno_w
	;
end if;
if (ds_justificativa_p <> ' ') and (ds_justificativa_p IS NOT NULL AND ds_justificativa_p::text <> '') then
	select  ds_retorno_w || obter_desc_expressao(292337,'Justificativa') ||':'|| CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END  || ds_justificativa_p || CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END
	into STRICT	ds_retorno_w
	;
end if;
if (ds_observacao_p <> ' ') and (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') then
	select  ds_retorno_w || obter_desc_expressao(753406,'Observação') ||':'|| CASE WHEN ie_quebra_linha_p='S' THEN chr(13) || chr(10)  ELSE ' ' END  || ds_observacao_p
	into STRICT	ds_retorno_w
	;
end if;

return trim(both ds_retorno_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacoes_ds_exame (ds_dado_clinico_p text default ' ', ds_resumo_clinico_p text default ' ', ds_exame_fis_achado_cirur_p text default ' ', ds_justificativa_p text default ' ', ds_observacao_p text default ' ', ie_quebra_linha_p text default 'N') FROM PUBLIC;
