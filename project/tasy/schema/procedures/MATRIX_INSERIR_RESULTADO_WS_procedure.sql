-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE matrix_inserir_resultado_ws ( nr_prescricao_p bigint, nr_seq_prescr_p text, --ds_pdf_serial_p		long,
 nr_sequencia_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_sequencia_pdf_w	bigint;
nr_seq_exame_w		bigint;


BEGIN

/*select	max(a.nr_seq_exame)
into	nr_seq_exame_w
from	lab_exame_equip a,
		equipamento_lab b
where	a.cd_equipamento = b.cd_equipamento
AND		b.ds_sigla = 'MATRIX'
and		a.cd_exame_equip = nr_seq_exame_p;*/
select	max(a.nr_sequencia)
into STRICT	nr_sequencia_w
from	result_laboratorio a
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_seq_prescricao = nr_seq_prescr_p;

if (coalesce(nr_sequencia_w::text, '') = '') then

	select	nextval('result_laboratorio_seq')
	into STRICT	nr_sequencia_w
	;

	begin
	insert into result_laboratorio(	nr_prescricao,
					nr_seq_prescricao,
					ie_cobranca,
					nm_usuario,
					dt_atualizacao,
					ie_formato_texto,
					ds_resultado)
			values (	nr_prescricao_p,
					nr_seq_prescr_p,
					'S',
					'MATRIXWS',
					clock_timestamp(),
					3,
					obter_desc_expressao(292128)||' MATRIXWS');

	exception
	when others then
		ds_erro_p	:= 		substr(wheb_mensagem_pck.get_texto(277391,'NR_PRESCRICAO='||nr_prescricao_p||';NR_SEQ_PRESCR='||nr_seq_prescr_p)||' - '||sqlerrm,1,2000);
	end;
else
	update	result_laboratorio
	set		ds_resultado = obter_desc_expressao(292128)||' MATRIXWS'
	where	nr_sequencia = nr_sequencia_w;
end if;

select	max(a.nr_sequencia)
into STRICT	nr_sequencia_w
from	result_laboratorio a
where	a.nr_prescricao = nr_prescricao_p
and		a.nr_seq_prescricao = nr_seq_prescr_p;

if (coalesce(ds_erro_p::text, '') = '') and (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then

	select	max(a.nr_sequencia)
	into STRICT	nr_sequencia_pdf_w
	from	result_laboratorio_pdf a
	where	a.nr_prescricao = nr_prescricao_p
	and		a.nr_seq_prescricao = nr_seq_prescr_p;

	if (coalesce(nr_sequencia_pdf_w::text, '') = '') then

		select	max(a.nr_seq_exame)
		into STRICT	nr_seq_exame_w
		from	prescr_procedimento a
		where	a.nr_prescricao = nr_prescricao_p
		and		a.nr_sequencia = nr_seq_prescr_p;

		select	nextval('result_laboratorio_pdf_seq')
		into STRICT	nr_sequencia_pdf_w
		;

		begin
		insert into result_laboratorio_pdf(	nr_sequencia,
												nr_prescricao,
												dt_atualizacao,
												nm_usuario,
												dt_atualizacao_nrec,
												nm_usuario_nrec,
												nr_seq_prescricao,
												nr_seq_resultado,
												nr_seq_exame,
												ds_pdf_serial
												)
										values (
												nr_sequencia_pdf_w,
												nr_prescricao_p,
												clock_timestamp(),
												'MATRIXWS',
												clock_timestamp(),
												'MATRIXWS',
												nr_seq_prescr_p,
												nr_sequencia_w,
												nr_seq_exame_w,
												' '--ds_pdf_serial_p
												);
		exception
		when others then
			ds_erro_p	:= substr(wheb_mensagem_pck.get_texto(277401,'NR_PRESCRICAO='||nr_prescricao_p||';NR_SEQ_PRESCR='||nr_seq_prescr_p||';NR_SEQUENCIA='||to_char(nr_sequencia_w))||' - '||sqlerrm,1,2000);
		end;
	end if;
end if;

nr_sequencia_p		:= nr_sequencia_pdf_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE matrix_inserir_resultado_ws ( nr_prescricao_p bigint, nr_seq_prescr_p text,  nr_sequencia_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;
