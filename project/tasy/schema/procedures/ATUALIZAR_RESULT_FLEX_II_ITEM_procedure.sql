-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_result_flex_ii_item (nr_seq_result_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


NR_SEQ_ESCALA_w	bigint;


BEGIN

if (nr_sequencia_p > 0) then

	UPDATE escala_eif_ii_item
	SET nr_seq_result = nr_seq_result_p,
		nm_usuario =  nm_usuario_p
	WHERE nr_sequencia = nr_sequencia_p;

	select	max(NR_SEQ_ESCALA)
	into STRICT	NR_SEQ_ESCALA_w
	from	escala_eif_ii_item
	where	nr_sequencia	= nr_sequencia_p;

	if (NR_SEQ_ESCALA_w IS NOT NULL AND NR_SEQ_ESCALA_w::text <> '') then
		CALL gerar_resultado_score_flex_2(NR_SEQ_ESCALA_w);
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_result_flex_ii_item (nr_seq_result_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

