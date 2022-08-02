-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_dados_sht (dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


    nr_sequencia_w              san_lote_item.nr_sequencia%type;
	nr_seq_reserva_w			san_transfusao.nr_seq_reserva%type;
	cd_motivo_inutilizacao_w	san_motivo_inutil.cd_externo%type;
	nr_sec_saude_w				san_producao.nr_sec_saude%type;
	ds_lista_anticorpos_w		san_anticorpos.ds_anticorpos%type;
	nr_seq_transfusao_w			san_producao.nr_seq_transfusao%type;
	nr_seq_derivado_w			san_producao.nr_seq_derivado%type;
	cd_agencia_w				san_parametro.cd_regional%type;
	nm_pessoa_fisica_w			pessoa_fisica.nm_pessoa_fisica%type;
	cd_pessoa_mae_w				pessoa_fisica.cd_pessoa_mae%type;
	nm_mae_w					pessoa_fisica.nm_pessoa_fisica%type;
	ie_sexo_w					pessoa_fisica.ie_sexo%type;
	dt_nascimento_w				pessoa_fisica.dt_nascimento%type;
    ie_pediatrico_w             varchar(1);
	nr_cpf_w					pessoa_fisica.nr_cpf%type;
	nr_cartao_nac_sus_w			pessoa_fisica.nr_cartao_nac_sus%type;
	ie_tipo_fator_sangue_w		varchar(10);	
	lista_codigos_reacao_w		san_lote_item.cd_tipo_reacao%type;
	cd_seq_derivado_w			san_derivado.cd_externo%type;
	dt_fim_lote_w				timestamp;
	qtd_ie_tipo_sangue_w        bigint;
    qtd_ie_fator_rh_w       bigint;

    c_dados_destino CURSOR FOR
        /* Transfusoes */

		SELECT  a.dt_transfusao dt_destino,
				1 tipo_receptor,
				a.cd_pessoa_fisica, 
				obter_se_houve_reacao(b.nr_seq_transfusao, b.nr_sequencia) ie_reacao,
				san_exame_pai_positivo(a.nr_seq_reserva) ie_pai_positivo,
				a.nr_seq_reserva, 		
				CASE WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=1 THEN 3 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=2 THEN 2 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=3 THEN 1 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=4 THEN 3 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=5 THEN 3 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=6 THEN 3 WHEN obter_dados_atendimento(a.nr_atendimento,'TC')=7 THEN 3  ELSE 0 END  vinculo_paciente,  
				'' cd_motivo_inutilizacao,
				'' cd_entidade, 
				'' uf_entidade, 
				'' ds_entidade,
				'N' ie_exsanguineo,		
				b.ie_aliquotado,		
				b.ie_pool,
				b.nr_sec_saude,
				b.ie_irradiado,
				b.ie_filtrado,
				b.ie_lavado,
				'N' ie_rejuvenescido,
				b.nr_seq_transfusao,        
				b.nr_sequencia nr_seq_producao,
				0 nr_seq_emp,
				coalesce(b.nr_seq_inutil, 0) nr_seq_inutil,
				b.nr_seq_derivado
		from	san_transfusao a,
				san_producao b		
		where 	dt_transfusao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		and		b.nr_seq_transfusao = a.nr_sequencia
		and		a.ie_status = 'F' 
		and		coalesce(b.nr_seq_inutil::text, '') = ''
		
Union

		/* Inutilizacoes */

		SELECT  b.dt_inutilizacao dt_destino,
				2 tipo_receptor,
				'' cd_pessoa_fisica, 
				'' ie_reacao,
				'' ie_pai_positivo,
				b.nr_seq_reserva, 		
				0 vinculo_paciente,  
				'' cd_motivo_inutilizacao,
				'' cd_entidade, 
				'' uf_entidade, 
				'' ds_entidade,
				'N' ie_exsanguineo,		
				b.ie_aliquotado,		
				b.ie_pool,
				b.nr_sec_saude,
				b.ie_irradiado,
				b.ie_filtrado,
				b.ie_lavado,
				'N' ie_rejuvenescido,
				b.nr_seq_transfusao,        
				b.nr_sequencia nr_seq_producao,
				0 nr_seq_emp,
				coalesce(b.nr_seq_inutil, 0) nr_seq_inutil,
				b.nr_seq_derivado
		from	san_producao b
		where 	b.dt_inutilizacao between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		and		(b.nr_seq_inutil IS NOT NULL AND b.nr_seq_inutil::text <> '')  
		
Union

		/* Cedencias */

		select  a.dt_emprestimo dt_destino,
				CASE WHEN substr(obter_uf_pj(c.cd_cgc),1,2)='PR' THEN  CASE WHEN c.ie_tipo_entidade='A' THEN  4 WHEN c.ie_tipo_entidade='B' THEN  3  ELSE 5 END   ELSE 6 END  tipo_receptor,
				a.cd_pf_realizou cd_pessoa_fisica, 
				'' ie_reacao,
				san_exame_pai_positivo(b.nr_seq_reserva) ie_pai_positivo,
				b.nr_seq_reserva, 		
				0 vinculo_paciente,  
				'' cd_motivo_inutilizacao,
				c.cd_externo cd_entidade, 
				substr(obter_uf_pj(c.cd_cgc),1,2) uf_entidade,
				c.ds_entidade ds_entidade,
				'N' ie_exsanguineo,		
				b.ie_aliquotado,		
				b.ie_pool,
				b.nr_sec_saude,
				b.ie_irradiado,
				b.ie_filtrado,
				b.ie_lavado,
				'N' ie_rejuvenescido,
				b.nr_seq_transfusao,        
				b.nr_sequencia nr_seq_producao,
				a.nr_sequencia nr_seq_emp,
				coalesce(b.nr_seq_inutil, 0) nr_seq_inutil,
				b.nr_seq_derivado
		from	san_producao b,
				san_emprestimo a,
				san_entidade c
		where 	a.nr_sequencia = b.nr_seq_emp_saida
		and		a.nr_seq_entidade = c.nr_sequencia
		and 	a.dt_emprestimo between inicio_dia(dt_inicio_p) and fim_dia(dt_fim_p)
		and		coalesce(b.nr_seq_inutil::text, '') = '';


	c_reacoes CURSOR(nr_seq_transfusao_p bigint) FOR
		SELECT	x.cd_reacao_externa cd_reacao
		from 	san_transfusao a,
				san_producao b,
				san_trans_reacao c,
				san_tipo_reacao x
		where 	x.nr_sequencia = c.nr_seq_reacao
		and		b.nr_seq_transfusao = a.nr_sequencia
		and		b.nr_sequencia = c.nr_seq_producao
		and		a.nr_sequencia = nr_seq_transfusao_p;

	c_anticorpos CURSOR(nr_seq_reserva_p bigint) FOR
		SELECT a.ds_anticorpos
		from  san_anticorpos a,
		san_exame_anticorpos b,
		san_exame_lote c,
		san_exame_realizado d
		where a.nr_sequencia = b.nr_seq_anticorpo
		and   b.nr_seq_exame = d.nr_seq_exame
		and   d.nr_seq_exame_lote = c.nr_sequencia 	
		and   b.nr_seq_exame_lote = c.nr_sequencia
		and   c.nr_seq_reserva = nr_seq_reserva_p;
BEGIN

	for reg_c_dados_destino in c_dados_destino loop
	begin

		/* cod_Agencia - todas as categorias: Transfusoes, Inutilizacoes, Cedencias) */

		select	max(cd_regional)
		into STRICT	cd_agencia_w
		from 	san_parametro
		where 	cd_estabelecimento = cd_estabelecimento_p;

		nr_seq_transfusao_w 	:= reg_c_dados_destino.nr_seq_transfusao;
		nr_seq_reserva_w		:= reg_c_dados_destino.nr_seq_reserva;
		nr_seq_derivado_w		:= reg_c_dados_destino.nr_seq_derivado;
		cd_motivo_inutilizacao_w := reg_c_dados_destino.cd_motivo_inutilizacao;		
		nr_sec_saude_w			:= reg_c_dados_destino.nr_sec_saude;
		lista_codigos_reacao_w  := '';
		
		/* Receptor */
		if (reg_c_dados_destino.tipo_receptor = 1) then
		begin                                                                       
			Select  nm_pessoa_fisica,
					coalesce(cd_pessoa_mae, '0') cd_pessoa_mae,
					coalesce(obter_nome_pf(cd_pessoa_mae),'') nm_mae_w,
					coalesce(ie_sexo,'') ie_sexo,
					coalesce(dt_nascimento, to_date('01-01-0001', 'DD-MM-YYYY')) dt_nascimento,
					coalesce(nr_cpf, '0') nr_cpf,
					coalesce(nr_cartao_nac_sus, '0') nr_cartao_nac_sus 
			into STRICT	nm_pessoa_fisica_w,
					cd_pessoa_mae_w,
					nm_mae_w,
					ie_sexo_w,
					dt_nascimento_w,
					nr_cpf_w,
					nr_cartao_nac_sus_w
			from	pessoa_fisica
			where	cd_pessoa_fisica = reg_c_dados_destino.cd_pessoa_fisica;

            select count(a.ie_tipo_sangue), count(a.ie_fator_rh)
            into STRICT qtd_ie_tipo_sangue_w, qtd_ie_fator_rh_w
            from pessoa_fisica a,
                 san_integracao_sangue b
            where a.ie_tipo_sangue = b.ie_tipo_sangue
            and a.ie_fator_rh = b.ie_fator_rh
            and a.cd_pessoa_fisica = reg_c_dados_destino.cd_pessoa_fisica
            and b.cd_estabelecimento = cd_estabelecimento_p;
			
            if (qtd_ie_tipo_sangue_w > 0 and qtd_ie_fator_rh_w > 0) then
                Select coalesce(b.cd_externo, '') cd_externo
                into STRICT ie_tipo_fator_sangue_w
                from pessoa_fisica a,
                     san_integracao_sangue b
                where a.ie_tipo_sangue = b.ie_tipo_sangue
                and a.ie_fator_rh = b.ie_fator_rh
                and a.cd_pessoa_fisica = reg_c_dados_destino.cd_pessoa_fisica
                and b.cd_estabelecimento = cd_estabelecimento_p
				and b.ie_tipo_integracao = 7;
            else
                ie_tipo_fator_sangue_w := '';
            end if;

            Select case when floor(clock_timestamp() - add_months(dt_nascimento_w, 144)) >= 0 then 'N' else 'S' end ie_pediatrico
            into STRICT ie_pediatrico_w
;
		end;
		end if;
		
		if (reg_c_dados_destino.tipo_receptor = 2) then
		begin
			Select c.cd_externo
			into STRICT cd_motivo_inutilizacao_w
			from san_producao a, san_inutilizacao b, san_motivo_inutil c
			where a.nr_seq_inutil = b.nr_sequencia
			and c.nr_sequencia = b.nr_seq_motivo_inutil
			and a.nr_sequencia = reg_c_dados_destino.nr_seq_producao;

		end;
		end if;

		/* Transfusions reactions */

		for reg_c_reacao in c_reacoes(nr_seq_transfusao_w) loop
			if (coalesce(reg_c_reacao.cd_reacao, 0) > 0) then
                if (lista_codigos_reacao_w <> '') then
                    lista_codigos_reacao_w  := lista_codigos_reacao_w || ','|| to_char(reg_c_reacao.cd_reacao);
                else
                    lista_codigos_reacao_w := to_char(reg_c_reacao.cd_reacao);
                end if;
			end if;
		end loop;


		/* Antibodies */

		if (nr_seq_reserva_w IS NOT NULL AND nr_seq_reserva_w::text <> '') then
			for reg_c_anticorpos in c_anticorpos(nr_seq_reserva_w) loop
				ds_lista_anticorpos_w  := reg_c_anticorpos.ds_anticorpos || ','||ds_lista_anticorpos_w;
			end loop;
		end if;

		/* codigo hemoderivado */

		Select coalesce(cd_externo, '')
		into STRICT cd_seq_derivado_w
		from san_derivado
		where nr_sequencia = nr_seq_derivado_w;

		
		select nextval('san_lote_item_seq')
		into STRICT nr_sequencia_w 
		;
		
		Insert into san_lote_item(nr_sequencia,
								nr_seq_lote,
								dt_atualizacao,
								nm_usuario,								  
								dt_atualizacao_nrec,
								nm_usuario_nrec,
								nr_seq_trans,
								nr_seq_producao,
								nr_seq_emp,
								nr_seq_inutil,
								/* DESTINO */

								dt_destino,
								cd_destino,
								cd_agencia,
								/* RECEPTOR */

								cd_pessoa_mae, 
								nm_mae, 
								cd_pessoa_fisica, 
								nm_pessoa_fisica, 
								ie_sexo, 
								dt_nascimento, 
								nr_cpf, 
								nr_cartao_nac_sus,
								ie_tipo_fator_sangue,
								/* REACOES */

								ie_houve_reacao, 
								cd_tipo_reacao,								  
								ie_houve_pai_positivo,
								/* ANTICORPOS */

								ds_lista_anticorpos,								  
								ie_tipo_convenio,
								cd_motivo_inutilizacao,
								cd_entidade,
								uf_entidade,
								ds_entidade,								  
								ie_exsanguineo,
								ie_aliquotado,
								ie_pediatrico, 
								ie_pool, 
								/* BOLSA */

								nr_sec_saude, 
								cd_seq_derivado, 
								ie_lavado, 
								ie_filtrado, 
								ie_irradiado, 
								ie_rejuvenescido
								,ds_mensagem_retorno, 
								cd_receptor_externo)
		VALUES (nr_sequencia_w, 
				nr_seq_lote_p,
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p,
				nr_seq_transfusao_w,
				reg_c_dados_destino.nr_seq_producao, 
				reg_c_dados_destino.nr_seq_emp, 
				reg_c_dados_destino.nr_seq_inutil,
			    /* DESTINO */

				reg_c_dados_destino.dt_destino,
				reg_c_dados_destino.tipo_receptor,
				cd_agencia_w,
			    /* RECEPTOR */

				cd_pessoa_mae_w,
				nm_mae_w, 
				reg_c_dados_destino.cd_pessoa_fisica, 
				nm_pessoa_fisica_w, 
				ie_sexo_w, 
				dt_nascimento_w, 
				nr_cpf_w, 
				nr_cartao_nac_sus_w, 
				ie_tipo_fator_sangue_w,
				/* REACOES */

				reg_c_dados_destino.ie_reacao, 
				lista_codigos_reacao_w,						
				reg_c_dados_destino.ie_pai_positivo,
				/* ANTICORPOS */

				ds_lista_anticorpos_w,
				reg_c_dados_destino.vinculo_paciente,
				cd_motivo_inutilizacao_w, 
				reg_c_dados_destino.cd_entidade, 
				reg_c_dados_destino.uf_entidade, 
				reg_c_dados_destino.ds_entidade,
				reg_c_dados_destino.ie_exsanguineo,
				reg_c_dados_destino.ie_aliquotado, 
				ie_pediatrico_w, 
				reg_c_dados_destino.ie_pool, 
				/* BOLSA */

				nr_sec_saude_w, 
				cd_seq_derivado_w, 
				reg_c_dados_destino.ie_lavado, 
				reg_c_dados_destino.ie_filtrado, 
				reg_c_dados_destino.ie_irradiado,
				reg_c_dados_destino.ie_rejuvenescido,
			   '',
			   '');			
	end;
	end loop;
	
	if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
        update  san_lote_integracao
        set     dt_liberacao = clock_timestamp(),
				nm_usuario_liberacao = nm_usuario_p
        where   nr_sequencia = nr_seq_lote_p;
    end if;
	
	commit;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_dados_sht (dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_lote_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

