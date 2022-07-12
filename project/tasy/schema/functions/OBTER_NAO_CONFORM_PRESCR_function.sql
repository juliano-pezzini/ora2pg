-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nao_conform_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(8000) := '';
ds_orientacao_desc_w		varchar(8000) := '';
ds_erro_compl_desc_w		varchar(8000) := '';
ds_observacao_desc_w		varchar(8000) := '';
ds_justificativa_desc_w 	varchar(8000) := '';

expressao1_w	varchar(255) := obter_desc_expressao_idioma(294894, null, wheb_usuario_pck.get_nr_seq_idioma);--ORIENTAÇÃO
expressao2_w	varchar(255) := obter_desc_expressao_idioma(293915, null, wheb_usuario_pck.get_nr_seq_idioma);--NÃO CONFORMIDADE
expressao3_w	varchar(255) := obter_desc_expressao_idioma(294639, null, wheb_usuario_pck.get_nr_seq_idioma);--OBSERVAÇÃO
expressao4_w	varchar(255) := obter_desc_expressao_idioma(292337, null, wheb_usuario_pck.get_nr_seq_idioma);--JUSTIFICATIVA
C01 CURSOR FOR
SELECT (b.DS_COMPL_ERRO) ds_orientacao_desc,
	coalesce(ds_erro,'') || ' ' || coalesce(ds_compl_erro,'') ds_erro_compl_desc,
	(b.ds_inf_adicional) ds_observacao_desc,
	(a.ds_justificativa) ds_justificativa_desc
from	prescr_material a,
	prescr_medica_erro b
where	a.nr_prescricao = b.nr_prescricao
and	b.nr_seq_medic  = a.nr_sequencia
and	a.nr_prescricao = nr_prescricao_p
and	b.nr_sequencia	= nr_sequencia_p
and	a.ie_agrupador  = 1

union

select (c.ds_orientacao) ds_orientacao_desc,
	obter_descricao_padrao('RISCO_MEDICAMENTO','DS_RISCO',nr_seq_risco) ds_erro_compl_desc,
	(c.ds_observacao) ds_observacao_desc,
	(a.ds_justificativa) ds_justificativa_desc
from	prescr_material a,
	medicamento_risco c
where	a.cd_material = c.cd_material
and	a.nr_prescricao = nr_prescricao_p
and	a.ie_agrupador  = 1
and	a.nr_sequencia	= nr_sequencia_p
and	coalesce(c.ie_nao_conformidade,'N') = 'S'
and	coalesce(c.ie_situacao, 'A') = 'A';



BEGIN

open C01;
loop
fetch C01 into
	ds_orientacao_desc_w,
	ds_erro_compl_desc_w,
	ds_observacao_desc_w,
	ds_justificativa_desc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	if (ds_orientacao_desc_w IS NOT NULL AND ds_orientacao_desc_w::text <> '') then
		ds_retorno_w	:= substr(ds_retorno_w || ' '||upper(expressao1_w)||': ' || ds_orientacao_desc_w ,1,8000);
	end if;

	if (ds_erro_compl_desc_w IS NOT NULL AND ds_erro_compl_desc_w::text <> '') then
		ds_retorno_w	:= substr(ds_retorno_w || ' '||upper(expressao2_w)||': ' || ds_erro_compl_desc_w ,1,8000);
	end if;

	if (ds_observacao_desc_w IS NOT NULL AND ds_observacao_desc_w::text <> '') then
		ds_retorno_w	:= substr(ds_retorno_w || ' '||upper(expressao3_w)||': ' || ds_observacao_desc_w ,1,8000);
	end if;

	if (ds_justificativa_desc_w IS NOT NULL AND ds_justificativa_desc_w::text <> '') then
		ds_retorno_w	:= substr(ds_retorno_w || ' '||upper(expressao4_w)||': ' || ds_justificativa_desc_w ,1,8000);
	end if;
end loop;
close C01;

return substr(ds_retorno_w,1,4000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nao_conform_prescr ( nr_prescricao_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
