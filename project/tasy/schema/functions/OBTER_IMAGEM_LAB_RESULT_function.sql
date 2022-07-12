-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_imagem_lab_result (nr_prescricao_p bigint, nr_seq_prescr_p bigint) RETURNS varchar AS $body$
DECLARE


ds_imagem_w	varchar(255);


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

	select coalesce(max(b.ds_imagem),'') ds_imagem
	into STRICT   ds_imagem_w
	from   exame_lab_resultado a,
	       exame_lab_result_imagem b
	where  a.nr_seq_resultado = b.nr_seq_resultado
	and    a.nr_prescricao    = nr_prescricao_p
	and    b.nr_seq_prescr    = nr_seq_prescr_p;

end if;

return	ds_imagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_imagem_lab_result (nr_prescricao_p bigint, nr_seq_prescr_p bigint) FROM PUBLIC;

