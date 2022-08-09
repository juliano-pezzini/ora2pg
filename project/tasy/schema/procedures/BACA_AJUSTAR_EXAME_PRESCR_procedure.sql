-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_ajustar_exame_prescr () AS $body$
DECLARE


nr_seq_exame_w		bigint;
qt_reg_w		bigint;
nr_prescricao_w		bigint;
nr_seq_prescr_w		integer;

C01 CURSOR FOR
	SELECT	distinct a.nr_prescricao,
		a.nr_sequencia
	from	prescr_procedimento a
	where	coalesce(a.nr_seq_exame::text, '') = ''
	and	(a.cd_material_exame IS NOT NULL AND a.cd_material_exame::text <> '');


BEGIN
qt_reg_w	:= 0;
open C01;
loop
fetch C01 into
	nr_prescricao_w,
	nr_seq_prescr_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(c.nr_seq_exame)
	into STRICT	nr_seq_exame_w
	from 	exame_lab_resultado b, exame_lab_result_item c
	where b.nr_seq_resultado = c.nr_seq_resultado
	and c.nr_seq_prescr = nr_seq_prescr_w
	and b.nr_prescricao = nr_prescricao_w
	and (c.nr_seq_formato IS NOT NULL AND c.nr_seq_formato::text <> '')
	and (c.dt_aprovacao IS NOT NULL AND c.dt_aprovacao::text <> '');

	if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

		begin
			update  prescr_procedimento
			set	nr_seq_exame = nr_seq_exame_w,
				dt_atualizacao = clock_timestamp(),
				nm_usuario = 'OS308753'
			where	nr_prescricao = nr_prescricao_w
			and	nr_sequencia = nr_seq_prescr_w;

			CALL gravar_log_tasy(9001,'baca_ajustar_exame_prescr - update efetuado - prescr: '||nr_prescricao_w||' seq. prescr. '||nr_seq_prescr_w||' nr_seq exame: '||nr_seq_exame_w,'baca_OS308753');

			qt_reg_w	:= qt_reg_w + 1;

			nr_seq_exame_w := null;
		exception
		when others then
		CALL gravar_log_tasy(9002,'exception baca_ajustar_exame_prescr - prescr: '||nr_prescricao_w||' seq. prescr. '||nr_seq_prescr_w||' nr_seq exame: '||nr_seq_exame_w||' erro: '||sqlerrm,'baca_OS308753');
		end;
	end if;

	if (qt_reg_w	= 1000) then
		commit;
		qt_reg_w	:= 0;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_ajustar_exame_prescr () FROM PUBLIC;
