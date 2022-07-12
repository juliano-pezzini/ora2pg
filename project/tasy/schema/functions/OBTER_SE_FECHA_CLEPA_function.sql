-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_fecha_clepa ( nr_seq_atend_chec_p bigint) RETURNS varchar AS $body$
DECLARE

 
qt_total_w	integer;
ds_retorno_w	varchar(255) := 'S';

expressao1_w	varchar(255) := obter_desc_expressao_idioma(774325, null, wheb_usuario_pck.get_nr_seq_idioma);--Não é possível fechar a função, pois é necessário o preenchimento e liberação do check-list 
				

BEGIN 
 
if (nr_seq_atend_chec_p > 0) then 
	select	count(*) 
	into STRICT	qt_total_w 
	from	med_avaliacao_paciente 
	where	nr_seq_atend_checklist = nr_seq_atend_chec_p 
	and 	coalesce(dt_liberacao::text, '') = '';
	 
	if (qt_total_w > 0) then 
 
		ds_retorno_w	:= expressao1_w;
	end if;
end if;
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_fecha_clepa ( nr_seq_atend_chec_p bigint) FROM PUBLIC;
