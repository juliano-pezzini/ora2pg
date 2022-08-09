-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_gerar_ordem_servico (nr_prescricao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
nr_seq_localizacao_w		bigint;
nr_seq_equipamento_w		bigint;
nr_seq_estagio_w		bigint;
ds_dano_w			varchar(4000);
ds_recomendacao_w		varchar(4000);
cd_recomendacao_w		bigint;
ds_prescritor_w			varchar(255);
nr_atendimento_w		bigint;
nr_seq_regra_w			bigint;
nm_paciente_w			varchar(255);
ds_unidade_w			varchar(255);
nm_usuario_exec_w		varchar(255);
cd_prescritor_w			varchar(255);
nm_usuario_grupo_trab_w		varchar(255);
nr_seq_tipo_exec_w		bigint;
qt_min_prev_w			bigint;
nr_seq_w			bigint;
nr_grupo_trabalho_w		bigint;
nr_grupo_planej_w		bigint;

c01 CURSOR FOR
SELECT	substr(obter_rec_prescricao(a.nr_sequencia, a.nr_prescricao),1,255),
	a.cd_recomendacao,
	obter_nome_pf(b.cd_prescritor) ds_prescritor,
	b.cd_prescritor,
	b.nr_atendimento,
	obter_nome_pf(b.cd_pessoa_fisica) nm_paciente,
	Obter_Unidade_Atendimento(b.nr_atendimento, 'A','SAU')
from	prescr_medica b,
	prescr_recomendacao a
where	a.nr_prescricao	= b.nr_prescricao
and	a.nr_prescricao	= nr_prescricao_p;

c02 CURSOR FOR
SELECT	nr_seq_localizacao,
	nr_seq_equipamento,
	nr_seq_estagio,
	ds_dano,
	nr_sequencia,
	nr_grupo_trabalho,
	nr_grupo_planej
from	regra_recomendacao_os
where	cd_tipo_recomendacao	= cd_recomendacao_w;

c03 CURSOR FOR
SELECT	nm_usuario_exec,
	nr_seq_tipo_exec,
	qt_min_prev
from	regra_recomendacao_exec
where	nr_seq_regra	= nr_seq_regra_w;

c04 CURSOR FOR
SELECT	nm_usuario_param
from	man_grupo_trab_usuario
where	nr_seq_grupo_trab = nr_grupo_trabalho_w;


BEGIN

open C01;
loop
fetch C01 into
	ds_recomendacao_w,
	cd_recomendacao_w,
	ds_prescritor_w,
	cd_prescritor_w,
	nr_atendimento_w,
	nm_paciente_w,
	ds_unidade_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	open C02;
	loop
	fetch C02 into
		nr_seq_localizacao_w,
		nr_seq_equipamento_w,
		nr_seq_estagio_w,
		ds_dano_w,
		nr_seq_regra_w,
		nr_grupo_trabalho_w,
		nr_grupo_planej_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		select	nextval('man_ordem_servico_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into man_ordem_servico(
			nr_sequencia,
			nr_seq_localizacao,
			nr_seq_equipamento,
			cd_pessoa_solicitante,
			dt_ordem_servico,
			ie_prioridade,
			ie_parado,
			ds_dano_breve,
			dt_atualizacao,
			nm_usuario,
			dt_inicio_desejado,
			dt_conclusao_desejada,
			ds_dano,
			dt_inicio_previsto,
			dt_fim_previsto,
			dt_inicio_real,
			dt_fim_real,
			ie_tipo_ordem,
			ie_status_ordem,
			nr_grupo_planej,
			nr_grupo_trabalho,
			nr_seq_tipo_solucao,
			ds_solucao,
			nm_usuario_exec,
			qt_contador,
			nr_seq_planej,
			nr_seq_tipo_contador,
			nr_seq_estagio,
			cd_projeto,
			nr_seq_etapa_proj,
			dt_reabertura,
			cd_funcao,
			nm_tabela,
			ie_classificacao,
			nr_seq_origem,
			nr_seq_projeto,
			ie_grau_satisfacao,
			nr_seq_indicador,
			nr_seq_causa_dano,
			ie_forma_receb,
			nr_seq_cliente,
			nr_seq_grupo_des,
			nr_seq_grupo_sup,
			nr_seq_superior,
			ie_eficacia,
			dt_prev_eficacia,
			cd_pf_eficacia,
			nr_seq_nao_conform,
			nr_seq_complex,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ie_obriga_news,
			nr_seq_meta_pe,
			nr_seq_classif,
			nr_seq_nivel_valor,
			nm_usuario_lib_news,
			dt_libera_news,
			dt_envio_wheb,
			ds_contato_solicitante,
			ie_prioridade_desen,
			ie_prioridade_sup,
			ie_prioridade_cliente,
			ie_origem_os)
		values(nr_sequencia_w,				-- nr_sequencia,
			nr_seq_localizacao_w,			-- nr_seq_localizacao,
			nr_seq_equipamento_w,			-- nr_seq_equipamento,
			cd_prescritor_w,			-- cd_pessoa_solicitante,
			clock_timestamp(),		-- dt_ordem_servico,
			'A',				-- ie_prioridade,
			'N',				-- ie_parado,
			--substr('Solicitação de  serviço: ' || nr_atendimento_w || ' - ' || nm_paciente_w || ' - ' || ds_recomendacao_w,1,80),		-- ds_dano_breve,
			substr(OBTER_DESC_EXPRESSAO(727818) || nr_atendimento_w || ' - ' || nm_paciente_w || ' - ' || ds_recomendacao_w,1,80),		-- ds_dano_breve,
			clock_timestamp(),					-- dt_atualizacao,
			nm_usuario_p,				-- nm_usuario,
			clock_timestamp(),					-- dt_inicio_desejado,
			(clock_timestamp() + interval '15 days'),				-- dt_conclusao_desejada,
			/*'Paciente: ' || nm_paciente_w || chr(13) ||
			'Leito: ' || ds_unidade_w || chr(13) ||
			'Médico requisitante: ' || ds_prescritor_w || chr(13) ||
			'SERVIÇO PROPOSTO: ' || ds_recomendacao_w || chr(13) ||	ds_dano_w,				-- ds_dano, */
			WHEB_MENSAGEM_PCK.get_texto(456822,
			'nm_paciente_w='|| nm_paciente_w ||
			';ds_unidade_w='|| ds_unidade_w ||
			';ds_prescritor_w='|| ds_prescritor_w ||
			';ds_recomendacao_w='|| ds_recomendacao_w ||
			';ds_dano_w='|| ds_dano_w), 		-- ds_dano,
			clock_timestamp(),					-- dt_inicio_previsto,
			null,					-- dt_fim_previsto,
			clock_timestamp(),					-- dt_inicio_real,
			null,					-- dt_fim_real,
			3,				-- ie_tipo_ordem,
			1,				-- ie_status_ordem,
			nr_grupo_planej_w,		-- nr_grupo_planej,
			nr_grupo_trabalho_w,			-- nr_grupo_trabalho,
			null,					-- nr_seq_tipo_solucao,
			null,					-- ds_solucao,
			nm_usuario_p, 				-- nm_usuario_exec,
			null,					-- qt_contador,
			null,					-- nr_seq_planej,
			null,					-- nr_seq_tipo_contador,
			nr_seq_estagio_w,				-- nr_seq_estagio,
			null,					-- cd_projeto,
			null,					-- nr_seq_etapa_proj,
			null,					-- dt_reabertura,
			null,					-- cd_funcao,
			null,					-- nm_tabela,
			'S',					-- ie_classificacao,
			null,					-- nr_seq_origem,
			null,					-- nr_seq_projeto,
			null,					-- ie_grau_satisfacao,
			null,					-- nr_seq_indicador,
			null,					-- nr_seq_causa_dano,
			null,					-- ie_forma_receb,
			null,					-- nr_seq_cliente,
			null,					-- nr_seq_grupo_des,
			null,					-- nr_seq_grupo_sup,
			null,					-- nr_seq_superior,
			null,					-- ie_eficacia,
			null,					-- dt_prev_eficacia,
			null,					-- cd_pf_eficacia,
			null,					-- nr_seq_nao_conform,
			null,					-- nr_seq_complex,
			null,					-- dt_atualizacao_nrec,
			nm_usuario_p,				-- nm_usuario_nrec,
			null,					-- ie_obriga_news,
			null,					-- nr_seq_meta_pe,
			null,					-- nr_seq_classif,
			null,					-- nr_seq_nivel_valor,
			null,					-- nm_usuario_lib_news,
			null,					-- dt_libera_news,
			null,					-- dt_envio_wheb,
			null,					-- ds_contato_solicitante,
			null,					-- ie_prioridade_desen,
			null,					-- ie_prioridade_sup
			'A',					-- ie_prioridade_cliente
			'4');					-- ie_origem_os
		open C03;
		loop
		fetch C03 into
			nm_usuario_exec_w,
			nr_seq_tipo_exec_w,
			qt_min_prev_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */

			select	nextval('man_ordem_servico_exec_seq')
			into STRICT	nr_seq_w
			;

			insert into man_ordem_servico_exec(nr_sequencia,
				nr_seq_ordem,
				dt_atualizacao,
				nm_usuario,
				nm_usuario_exec,
				qt_min_prev,
				dt_ult_visao,
				dt_recebimento,
				nr_seq_tipo_exec)
			values (nr_seq_w,
				nr_sequencia_w,
				clock_timestamp(),
				nm_usuario_p,
				nm_usuario_exec_w,
				qt_min_prev_w,
				clock_timestamp(),
				clock_timestamp(),
				nr_seq_tipo_exec_w);
		end loop;
		close C03;


		open C04;
		loop
		fetch C04 into
			nm_usuario_grupo_trab_w;
		EXIT WHEN NOT FOUND; /* apply on C04 */
			if (coalesce(nm_usuario_grupo_trab_w,'X') <> 'X') then
				select	nextval('man_ordem_servico_exec_seq')
				into STRICT	nr_seq_w
				;

				insert into man_ordem_servico_exec(nr_sequencia,
					nr_seq_ordem,
					dt_atualizacao,
					nm_usuario,
					nm_usuario_exec,
					qt_min_prev,
					dt_ult_visao,
					dt_recebimento,
					nr_seq_tipo_exec)
				values (nr_seq_w,
					nr_sequencia_w,
					clock_timestamp(),
					nm_usuario_p,
					nm_usuario_grupo_trab_w,
					coalesce(qt_min_prev_w,45),
					clock_timestamp(),
					clock_timestamp(),
					null);
			end if;

		end loop;
		close C04;
	end loop;
	close C02;
end loop;
close C01;

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_gerar_ordem_servico (nr_prescricao_p bigint, nm_usuario_p text) FROM PUBLIC;
