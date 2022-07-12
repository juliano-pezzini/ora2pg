-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_obter_obs_pcmed ( nr_prescricao_p text, nr_seq_prescr_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);
ds_observacao_w	varchar(4000);

C01 CURSOR FOR
	SELECT a.ds_resultado
	from exame_lab_result_item 	 a,
	     exame_lab_resultado 	 b,
	     exame_laboratorio 	 	 e,
	     prescr_procedimento 	 c,
	     prescr_medica		 d
	where a.nr_seq_resultado = b.nr_seq_resultado
	and   b.nr_prescricao = c.nr_prescricao
	and   c.nr_prescricao = d.nr_prescricao
	and   a.nr_seq_exame  =	e.nr_seq_exame
	and   upper(coalesce(e.cd_exame_integracao, cd_exame)) like '%OBS%'
	and   c.nr_prescricao = nr_prescricao_p
	and   c.nr_sequencia = nr_seq_prescr_p
	order by c.nr_sequencia;

BEGIN
	ds_retorno_w := '';
	open C01;
	loop
	fetch C01 into
		ds_observacao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
			ds_retorno_w := ds_retorno_w||' '||ds_observacao_w;
		end;
	end loop;
	close C01;

ds_retorno_w := replace(ds_retorno_w, chr(13) || chr(10), ' ');

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_obter_obs_pcmed ( nr_prescricao_p text, nr_seq_prescr_p text) FROM PUBLIC;

