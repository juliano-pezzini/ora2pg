-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_atual_result_item_ass_dig ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_assinatura_p bigint, ie_inativacao_p text, nm_usuario_p text ) AS $body$
DECLARE


nr_seq_resultado_w		bigint;



BEGIN

select 	MAX(nr_seq_resultado)
into STRICT	nr_seq_resultado_w
from 	exame_lab_resultado
where 	nr_prescricao = nr_prescricao_p;

if (nr_seq_resultado_w IS NOT NULL AND nr_seq_resultado_w::text <> '') then

	if (ie_inativacao_p = 'S') then
		update   exame_lab_result_item
		set      nr_seq_assinat_inativ  = nr_seq_assinatura_p
		where    nr_sequencia     	=  nr_sequencia_p
		and      nr_seq_resultado   = nr_seq_resultado_w;
	else
		update   exame_lab_result_item
		set      nr_Seq_Assinatura  = nr_seq_assinatura_p
		where    nr_sequencia     	=  nr_sequencia_p
		and      nr_seq_resultado   = nr_seq_resultado_w;
	end if;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_atual_result_item_ass_dig ( nr_prescricao_p bigint, nr_sequencia_p bigint, nr_seq_assinatura_p bigint, ie_inativacao_p text, nm_usuario_p text ) FROM PUBLIC;

