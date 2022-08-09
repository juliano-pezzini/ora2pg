-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_classif_risco_escala ( nr_seq_escala_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_atendimento_w		bigint;
qt_pontos_w		bigint;
nr_seq_tipo_escala_w	bigint;
nr_seq_triagem_w		bigint;


BEGIN

if (coalesce(nr_seq_escala_p,0) > 0) then


	select	coalesce(nr_atendimento,0),
		qt_pontos,
		nr_seq_escala
	into STRICT	nr_atendimento_w,
		qt_pontos_w,
		nr_seq_tipo_escala_w
	from	escala_eif_ii
	where	nr_sequencia = nr_seq_escala_p;

	if (qt_pontos_w IS NOT NULL AND qt_pontos_w::text <> '') then

		select 	max(nr_seq_triagem)
		into STRICT	nr_seq_triagem_w
		from   	eif_escala_ii_result
		where   qt_pontos_w between qt_pontos_min and qt_pontos_max
		and	nr_seq_escala = nr_seq_tipo_escala_w;



		if (nr_atendimento_w > 0) and (nr_seq_triagem_w IS NOT NULL AND nr_seq_triagem_w::text <> '') then

			update	atendimento_paciente
			set 	nr_seq_triagem 			= nr_seq_triagem_w
			where	nr_atendimento			= nr_atendimento_w;

		end if;

	end if;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_classif_risco_escala ( nr_seq_escala_p bigint, nm_usuario_p text) FROM PUBLIC;
