-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_lab_importacao_exame ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_tipo_p bigint, nm_usuario_p text) AS $body$
DECLARE



/*
 0 - sem erro
 1 - com erro
*/
BEGIN

if (ie_tipo_p	= 0) then

	update  lab_importacao_exame
	set 	dt_aprovacao = clock_timestamp()
	where 	nr_prescricao = nr_prescricao_p
	and 	nr_seq_prescr = nr_seq_prescr_p;


elsif ( ie_tipo_p = 1) then

update  lab_importacao_exame
	set 	dt_aprovacao = clock_timestamp(),
		dt_erro_aprov	= clock_timestamp()
	where 	nr_prescricao = nr_prescricao_p
	and 	nr_seq_prescr = nr_seq_prescr_p;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_lab_importacao_exame ( nr_prescricao_p bigint, nr_seq_prescr_p bigint, ie_tipo_p bigint, nm_usuario_p text) FROM PUBLIC;

