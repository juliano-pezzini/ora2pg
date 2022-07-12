-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_ref_exames_relac_js ( ds_coluna_p text, nr_seq_exame_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w	bigint;
ds_dml		varchar(500);
ds_retorno_w	varchar(2000);


BEGIN

ds_dml := ' select '||ds_coluna_p||
	  '  from w_result_exame_grid '||
	  '  where upper(ds_referencia) = upper('||obter_desc_expressao(296208)/*'prescrição'*/||')'||
	  '  and nm_usuario = nm_usuario_p';

nr_prescricao_w := obter_valor_dinamico(ds_dml, nr_prescricao_w);

ds_retorno_w := substr(obter_resultado_microorganismo(nr_prescricao_w, nr_seq_exame_p),1,2000);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_ref_exames_relac_js ( ds_coluna_p text, nr_seq_exame_p bigint, nm_usuario_p text) FROM PUBLIC;

