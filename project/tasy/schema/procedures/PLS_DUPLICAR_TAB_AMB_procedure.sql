-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE table_preco_amb AS (
	cd_edicao_amb        	pls_util_cta_pck.t_number_table,
        cd_moeda              	pls_util_cta_pck.t_number_table,
        cd_procedimento       	pls_util_cta_pck.t_number_table,
        ds_observacao     	pls_util_cta_pck.t_varchar2_table_4000,
        dt_fim_vigencia_ref   	pls_util_cta_pck.t_date_table,
        dt_final_vigencia     	pls_util_cta_pck.t_date_table,
        dt_inicio_vigencia    	pls_util_cta_pck.t_date_table,
        dt_inicio_vigencia_ref	pls_util_cta_pck.t_date_table,
        ie_origem_proced      	pls_util_cta_pck.t_number_table,
        nr_auxiliares 		pls_util_cta_pck.t_number_table,
        nr_incidencia		pls_util_cta_pck.t_number_table,
        qt_filme         	pls_util_cta_pck.t_number_table,
        qt_porte_anestesico   	pls_util_cta_pck.t_number_table,
        vl_anestesista        	pls_util_cta_pck.t_number_table,
        vl_auxiliares         	pls_util_cta_pck.t_number_table,
        vl_custo_operacional  	pls_util_cta_pck.t_number_table,
        vl_filme           	pls_util_cta_pck.t_number_table,
        vl_medico             	pls_util_cta_pck.t_number_table,
        vl_procedimento       	pls_util_cta_pck.t_number_table
);


CREATE OR REPLACE PROCEDURE pls_duplicar_tab_amb ( cd_edicao_amb_p edicao_amb.cd_edicao_amb%type, cd_nova_edicao_amb_p edicao_amb.cd_edicao_amb%type, dt_vigencia_p timestamp, ie_apenas_ult_vig_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



tb_preco_amb_w		table_preco_amb;
i			integer := 0;
ie_ja_existe_cod_w	varchar(1) := 'N';
dt_vigencia_w		timestamp;

C01 CURSOR FOR
	SELECT	cd_moeda,
	        cd_procedimento,
	        ds_observacao,
	        dt_fim_vigencia_ref,
	        dt_final_vigencia,
	        dt_inicio_vigencia,
	        dt_inicio_vigencia_ref,
	        ie_origem_proced,
	        nr_auxiliares,
	        nr_incidencia,
	        qt_filme,
	        qt_porte_anestesico,
	        vl_anestesista,
	        vl_auxiliares,
	        vl_custo_operacional,
	        vl_filme,
	        vl_medico,
	        vl_procedimento
	from	preco_amb
	where	cd_edicao_amb = cd_edicao_amb_p;

C02 CURSOR FOR
	SELECT	max(nr_sequencia) 	nr_sequencia,
		max(dt_inicio_vigencia)	dt_inicio_vigencia,
		cd_procedimento,
		ie_origem_proced
	from	preco_amb
	where	cd_edicao_amb = cd_edicao_amb_p
	group by cd_procedimento, ie_origem_proced;

C03 CURSOR(	nr_sequencia_pc	preco_amb.nr_sequencia%type) FOR
		SELECT	cd_moeda,
	        cd_procedimento,
	        ds_observacao,
	        dt_fim_vigencia_ref,
	        dt_final_vigencia,
	        dt_inicio_vigencia,
	        dt_inicio_vigencia_ref,
	        ie_origem_proced,
	        nr_auxiliares,
	        nr_incidencia,
	        qt_filme,
	        qt_porte_anestesico,
	        vl_anestesista,
	        vl_auxiliares,
	        vl_custo_operacional,
	        vl_filme,
	        vl_medico,
	        vl_procedimento
	from	preco_amb
	where	nr_sequencia = nr_sequencia_pc;

procedure inserir_preco_amb(	tb_preco_amb_p in out	table_preco_amb,
				nm_usuario_p		usuario.nm_usuario%type) is;
BEGIN

	if (tb_preco_amb_p.cd_edicao_amb.count > 0) then

		forall i in tb_preco_amb_p.cd_edicao_amb.first..tb_preco_amb_p.cd_edicao_amb.last
			insert into preco_amb(nr_sequencia, dt_atualizacao, nm_usuario,
						cd_edicao_amb, cd_moeda, cd_procedimento,
						ds_observacao, dt_fim_vigencia_ref, dt_final_vigencia,
						dt_inicio_vigencia, dt_inicio_vigencia_ref, ie_origem_proced,
						nr_auxiliares, nr_incidencia, qt_filme,
						qt_porte_anestesico, vl_anestesista, vl_auxiliares,
						vl_custo_operacional, vl_filme, vl_medico,
						vl_procedimento)
				values (	nextval('preco_amb_seq'), clock_timestamp(), nm_usuario_p,
						tb_preco_amb_p.cd_edicao_amb(i), tb_preco_amb_p.cd_moeda(i), tb_preco_amb_p.cd_procedimento(i),
						tb_preco_amb_p.ds_observacao(i), tb_preco_amb_p.dt_fim_vigencia_ref(i), tb_preco_amb_p.dt_final_vigencia(i),
						tb_preco_amb_p.dt_inicio_vigencia(i), tb_preco_amb_p.dt_inicio_vigencia_ref(i), tb_preco_amb_p.ie_origem_proced(i),
						tb_preco_amb_p.nr_auxiliares(i), tb_preco_amb_p.nr_incidencia(i), tb_preco_amb_p.qt_filme(i),
						tb_preco_amb_p.qt_porte_anestesico(i), tb_preco_amb_p.vl_anestesista(i), tb_preco_amb_p.vl_auxiliares(i),
						tb_preco_amb_p.vl_custo_operacional(i), tb_preco_amb_p.vl_filme(i), tb_preco_amb_p.vl_medico(i),
						tb_preco_amb_p.vl_procedimento(i));
			commit;

	end if;

	tb_preco_amb_p.cd_edicao_amb.delete;
	tb_preco_amb_p.cd_moeda.delete;
	tb_preco_amb_p.cd_procedimento.delete;
	tb_preco_amb_p.ds_observacao.delete;
	tb_preco_amb_p.dt_fim_vigencia_ref.delete;
	tb_preco_amb_p.dt_final_vigencia.delete;
	tb_preco_amb_p.dt_inicio_vigencia.delete;
	tb_preco_amb_p.dt_inicio_vigencia_ref.delete;
	tb_preco_amb_p.ie_origem_proced.delete;
	tb_preco_amb_p.nr_auxiliares.delete;
	tb_preco_amb_p.nr_incidencia.delete;
	tb_preco_amb_p.qt_filme.delete;
	tb_preco_amb_p.qt_porte_anestesico.delete;
	tb_preco_amb_p.vl_anestesista.delete;
	tb_preco_amb_p.vl_auxiliares.delete;
	tb_preco_amb_p.vl_custo_operacional.delete;
	tb_preco_amb_p.vl_filme.delete;
	tb_preco_amb_p.vl_medico.delete;
	tb_preco_amb_p.vl_procedimento.delete;

end;

begin

	begin
	if (coalesce(dt_vigencia_p::text, '') = '') then -- HTML5: se o usuário não informar nenhuma data o parâmetro DT_VIGENCIA_P virá nulo
		dt_vigencia_w := null;
	elsif	(dt_vigencia_p < to_date('01/01/1900')) then -- Delphi: Como não dá para passar nulo por parâmetro date pelo Delphi, a data '31/12/1899' é passado pelo Delphi para saber que foi enviada uma data nula ou inválida, e nesse caso, manterá a data de vigência do registro de origem
		dt_vigencia_w := null;
	else
		dt_vigencia_w := dt_vigencia_p;
	end if;
	exception
	when others then
		dt_vigencia_w := dt_vigencia_p; -- HTML5: a exceção apenas acontecerá com o Tasy rodando em HTML5. Isso porque se vier alguma data no parâmetro DT_VIGENCIA_P dará um erro ao passar pela verificação "elsif (dt_vigencia_p < to_date('01/01/1900')) then" e então entrará na exceção
	end;

	if (cd_edicao_amb_p IS NOT NULL AND cd_edicao_amb_p::text <> '') then


		if (cd_nova_edicao_amb_p IS NOT NULL AND cd_nova_edicao_amb_p::text <> '') then

			select	CASE WHEN count(1)=0 THEN  'N'  ELSE 'S' END
			into STRICT	ie_ja_existe_cod_w
			from	edicao_amb
			where	cd_edicao_amb = cd_nova_edicao_amb_p;

		end if;


		if (	ie_ja_existe_cod_w = 'N') then

			insert into edicao_amb(cd_edicao_amb, cd_estabelecimento, ds_edicao_amb,
					       ds_observacao, dt_atualizacao, dt_atualizacao_nrec,
					       dt_negociacao, dt_publicacao, ie_calculo_tuss,
					       ie_gerar_a1200, ie_origem_proced, ie_situacao,
					       ie_tipo_tabela, nm_usuario, nm_usuario_nrec,
					       nr_seq_tiss_tabela)
					(SELECT	cd_nova_edicao_amb_p, cd_estabelecimento, ds_edicao_amb,
						ds_observacao, clock_timestamp(), clock_timestamp(),
						dt_negociacao, dt_publicacao, ie_calculo_tuss,
						ie_gerar_a1200, ie_origem_proced, ie_situacao,
						ie_tipo_tabela, nm_usuario_p, nm_usuario_p,
						nr_seq_tiss_tabela
					from	edicao_amb
					where	cd_edicao_amb		= cd_edicao_amb_p
				);

			--Se retrinfgir apenas
			if (ie_apenas_ult_vig_p = 'N') then
				for r_c01_w in C01 loop

					tb_preco_amb_w.dt_final_vigencia(i)     := r_c01_w.dt_final_vigencia;
					tb_preco_amb_w.dt_inicio_vigencia(i)    := r_c01_w.dt_inicio_vigencia;
					tb_preco_amb_w.dt_inicio_vigencia_ref(i):= r_c01_w.dt_inicio_vigencia_ref;
					tb_preco_amb_w.dt_fim_vigencia_ref(i)	:= r_c01_w.dt_fim_vigencia_ref;
					tb_preco_amb_w.cd_edicao_amb(i)       	:= cd_nova_edicao_amb_p;
					tb_preco_amb_w.cd_moeda(i)              := r_c01_w.cd_moeda;
					tb_preco_amb_w.cd_procedimento(i)       := r_c01_w.cd_procedimento;
					tb_preco_amb_w.ds_observacao(i)     	:= r_c01_w.ds_observacao;
					tb_preco_amb_w.ie_origem_proced(i)      := r_c01_w.ie_origem_proced;
					tb_preco_amb_w.nr_auxiliares(i) 	:= r_c01_w.nr_auxiliares;
					tb_preco_amb_w.nr_incidencia(i)		:= r_c01_w.nr_incidencia;
					tb_preco_amb_w.qt_filme(i)         	:= r_c01_w.qt_filme;
					tb_preco_amb_w.qt_porte_anestesico(i)   := r_c01_w.qt_porte_anestesico;
					tb_preco_amb_w.vl_anestesista(i)        := r_c01_w.vl_anestesista;
					tb_preco_amb_w.vl_auxiliares(i)         := r_c01_w.vl_auxiliares;
					tb_preco_amb_w.vl_custo_operacional(i)  := r_c01_w.vl_custo_operacional;
					tb_preco_amb_w.vl_filme(i)           	:= r_c01_w.vl_filme;
					tb_preco_amb_w.vl_medico(i)            	:= r_c01_w.vl_medico;
					tb_preco_amb_w.vl_procedimento(i)      	:= r_c01_w.vl_procedimento;


					if ( i > pls_util_cta_pck.qt_registro_transacao_w) then

						CALL inserir_preco_amb( tb_preco_amb_w, nm_usuario_p);
						i := 0;
					else
						i := i + 1;

					end if;

				end loop;

			else
				for r_c02_w in C02 loop

					for r_c03_w in C03(r_c02_w.nr_sequencia) loop

						--Se informada data de vigência para a nova tabela, então popula o inicio vigência de todos os itens com essa data
						--e deixa o fim vigência nullo, caso não for informada data vigência, copia exatamente como está na tabela origem
						if (dt_vigencia_w IS NOT NULL AND dt_vigencia_w::text <> '') then

							tb_preco_amb_w.dt_final_vigencia(i)     := null;
							tb_preco_amb_w.dt_fim_vigencia_ref(i)	:= null;
							tb_preco_amb_w.dt_inicio_vigencia(i)    := dt_vigencia_w;
							tb_preco_amb_w.dt_inicio_vigencia_ref(i):= dt_vigencia_w;
						else
							tb_preco_amb_w.dt_final_vigencia(i)     := r_c03_w.dt_final_vigencia;
							tb_preco_amb_w.dt_inicio_vigencia(i)    := r_c03_w.dt_inicio_vigencia;
							tb_preco_amb_w.dt_fim_vigencia_ref(i)	:= r_c03_w.dt_fim_vigencia_ref;
							tb_preco_amb_w.dt_inicio_vigencia_ref(i):= r_c03_w.dt_inicio_vigencia_ref;

						end if;

						tb_preco_amb_w.cd_edicao_amb(i)       	:= cd_nova_edicao_amb_p;
						tb_preco_amb_w.cd_moeda(i)              := r_c03_w.cd_moeda;
						tb_preco_amb_w.cd_procedimento(i)       := r_c03_w.cd_procedimento;
						tb_preco_amb_w.ds_observacao(i)     	:= r_c03_w.ds_observacao;
						tb_preco_amb_w.ie_origem_proced(i)      := r_c03_w.ie_origem_proced;
						tb_preco_amb_w.nr_auxiliares(i) 	:= r_c03_w.nr_auxiliares;
						tb_preco_amb_w.nr_incidencia(i)		:= r_c03_w.nr_incidencia;
						tb_preco_amb_w.qt_filme(i)         	:= r_c03_w.qt_filme;
						tb_preco_amb_w.qt_porte_anestesico(i)   := r_c03_w.qt_porte_anestesico;
						tb_preco_amb_w.vl_anestesista(i)        := r_c03_w.vl_anestesista;
						tb_preco_amb_w.vl_auxiliares(i)         := r_c03_w.vl_auxiliares;
						tb_preco_amb_w.vl_custo_operacional(i)  := r_c03_w.vl_custo_operacional;
						tb_preco_amb_w.vl_filme(i)           	:= r_c03_w.vl_filme;
						tb_preco_amb_w.vl_medico(i)            	:= r_c03_w.vl_medico;
						tb_preco_amb_w.vl_procedimento(i)      	:= r_c03_w.vl_procedimento;


						if ( i > pls_util_cta_pck.qt_registro_transacao_w) then

							CALL inserir_preco_amb( tb_preco_amb_w, nm_usuario_p);
							i := 0;
						else
							i := i + 1;

						end if;

					end loop;

				end loop;

			end if;
			--Se sobraram registros na estrutura, persiste no banco.
			CALL inserir_preco_amb( tb_preco_amb_w, nm_usuario_p);

		else
			CALL wheb_mensagem_pck.exibir_mensagem_abort( 838617,'');
		end if;
	end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_duplicar_tab_amb ( cd_edicao_amb_p edicao_amb.cd_edicao_amb%type, cd_nova_edicao_amb_p edicao_amb.cd_edicao_amb%type, dt_vigencia_p timestamp, ie_apenas_ult_vig_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

