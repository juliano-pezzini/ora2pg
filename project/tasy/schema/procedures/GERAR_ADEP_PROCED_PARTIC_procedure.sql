-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_adep_proced_partic ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_auxiliares_w		bigint;
nr_sequencia_w		bigint;
nr_seq_temp_w		bigint;
nr_seq_geral_w		bigint;
cd_convenio_w		bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	adep_proced_participante
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_procedimento = nr_seq_procedimento_p
	order by nr_sequencia;


BEGIN

if	(not ((coalesce(nr_prescricao_p,0) = 0) or (coalesce(nr_seq_procedimento_p,0) = 0))) then

	select	count(*)
	into STRICT	qt_auxiliares_w
	from	adep_proced_participante
	where	nr_prescricao = nr_prescricao_p
	and		nr_seq_procedimento = nr_seq_procedimento_p;

	if (qt_auxiliares_w > 0) then
		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	procedimento_paciente
		where	nr_prescricao = nr_prescricao_p
		and		nr_sequencia_prescricao = nr_seq_procedimento_p;

		if (not(coalesce(nr_sequencia_w,0) = 0)) then

			select	coalesce(max(nr_seq_partic),0) + 1
			into STRICT	nr_seq_geral_w
			from	procedimento_participante
			where	nr_sequencia = nr_sequencia_w;

			open C01;
			loop
			fetch C01 into
				nr_seq_temp_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				insert into procedimento_participante(
						nr_sequencia,
						nr_seq_partic,
						cd_cgc,
						cd_especialidade,
						cd_medico_convenio,
						cd_pessoa_fisica,
						dt_atualizacao,
						ie_emite_conta,
						ie_funcao,
						ie_responsavel_credito,
						ie_valor_informado,
						nm_usuario,
						nr_doc_honor_conv,
						pr_faturar,
						pr_procedimento,
						vl_conta,
						vl_participante)
				SELECT	nr_sequencia_w,
						nr_seq_geral_w,
						cd_cgc,
						cd_especialidade,
						cd_medico_convenio,
						cd_pessoa_fisica,
						dt_atualizacao_nrec,
						ie_emite_conta,
						ie_funcao,
						ie_responsavel_credito,
						ie_valor_informado,
						nm_usuario_nrec,
						nr_doc_honor_conv,
						pr_faturar,
						pr_procedimento,
						vl_conta,
						vl_participante
				from	adep_proced_participante
				where	nr_prescricao = nr_prescricao_p
				and		nr_seq_procedimento = nr_seq_procedimento_p
				and		nr_sequencia = nr_seq_temp_w;

				nr_seq_geral_w := nr_seq_geral_w + 1;
				end;
			end loop;
			close C01;
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

			select	max(cd_convenio)
			into STRICT	cd_convenio_w
			from	procedimento_paciente
			where	nr_sequencia = nr_sequencia_w;

			CALL atualiza_preco_procedimento(nr_sequencia_w, cd_convenio_w, nm_usuario_p);
		end if;
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_adep_proced_partic ( nr_prescricao_p bigint, nr_seq_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;
