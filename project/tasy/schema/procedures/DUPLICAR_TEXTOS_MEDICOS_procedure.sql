-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_textos_medicos (nr_seq_parametro_p bigint, ie_tipo_texto_p bigint, nm_usuario_p text, nr_seq_registro_p INOUT bigint, nr_max_sequencia_p INOUT bigint) AS $body$
DECLARE

nr_seq_parametro_w		bigint;
nr_seq_parametro_w2		bigint;
ds_parametro_w			varchar(4000);
cd_profissional_w		varchar(10);
nr_seq_tipo_evolucao_w		varchar(255);
cd_medico_w	     	varchar(10);
nr_max_sequencia_w		bigint;
nr_seq_laudo_w			bigint;

/* 	1 - Evolução 
	3 - Receita 
	4 - Pedido Exames 
	5 - Outros Exames 
	6 - Texto Adicional 
	8 - Atestado 
	9 - Diagnóstico 
	10 - Parecer Médico 
	11 - Interno*/
 

BEGIN 
if (ie_tipo_texto_p = 1) then 
	begin 
 
	-- Obter o médico para depois obter o valor do parâmetro do mesmo 
	select	a.cd_medico 
	into STRICT	cd_medico_w 
	from	med_evolucao b, 
		med_cliente a 
	where	a.nr_sequencia	= b.nr_seq_cliente 
	and	b.nr_sequencia 	= nr_seq_parametro_p;
 
	-- Parâmetro [90] - Tipo de evolução padrão, se a evolução a ser duplicada não possuir tipo de evolução, sistema seta com o valor do parâmetro 
	nr_seq_tipo_evolucao_w	:= substr(med_obter_valor_parametro(90, cd_medico_w),1,255);
 
	select	nextval('med_evolucao_seq') 
	into STRICT	nr_seq_parametro_w 
	;
 
	select ' ' 
	into STRICT	ds_parametro_w 
	from	med_evolucao 
	where	nr_sequencia 	= nr_seq_parametro_p;
 
	insert into med_evolucao(nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_evolucao, 
		ds_evolucao, 
		nr_seq_cliente, 
		qt_altura_cm, 
		nr_seq_tipo_evolucao) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_seq_cliente, 
		qt_altura_cm, 
		coalesce(nr_seq_tipo_evolucao, nr_seq_tipo_evolucao_w) 
	from	med_evolucao 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_evolucao	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_evolucao, 
		ds_parametro_w, 
		nr_seq_cliente, 
		qt_altura_cm, 
		coalesce(nr_seq_tipo_evolucao, nr_seq_tipo_evolucao_w)		 
	from	med_evolucao 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_evolucao	> clock_timestamp());
 
		CALL copia_campo_long_de_para(	'med_evolucao', 
					'ds_evolucao', 
					' where nr_sequencia = :nr_sequencia ', 
					'nr_sequencia='||nr_seq_parametro_p, 
					'med_evolucao', 
					'ds_evolucao', 
					' where nr_sequencia = :nr_sequencia', 
					'nr_sequencia='||nr_seq_parametro_w);
 
	end;
elsif (ie_tipo_texto_p = 3) then 
	begin 
	select	nextval('med_receita_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select ' ', 
		substr(obter_pessoa_fisica_usuario(nm_usuario_p, 'C'),1,10) 
	into STRICT	ds_parametro_w, 
		cd_profissional_w 
	from	med_receita 
	where	nr_sequencia 	= nr_seq_parametro_p;
	insert into med_receita(nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_receita, 
		ds_receita, 
		nr_atendimento_hosp, 
		nr_seq_cliente, 
		cd_pessoa_fisica, 
		ie_situacao, 
		ie_tipo_receita, 
		cd_medico, 
		ie_data) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_atendimento_hosp, 
		nr_seq_cliente, 
		cd_pessoa_fisica, 
		'A', 
		ie_tipo_receita, 
		cd_profissional_w, 
		'S' 
	from	med_receita 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_receita	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_receita, 
		ds_parametro_w, 
		nr_atendimento_hosp, 
		nr_seq_cliente, 
		cd_pessoa_fisica, 
		'A', 
		ie_tipo_receita, 
		cd_profissional_w, 
		'S' 
	from	med_receita 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_receita	> clock_timestamp());
 
			CALL copia_campo_long_de_para(	'med_receita', 
					'ds_receita', 
					' where nr_sequencia = :nr_sequencia ', 
					'nr_sequencia='||nr_seq_parametro_p, 
					'med_receita', 
					'ds_receita', 
					' where nr_sequencia = :nr_sequencia', 
					'nr_sequencia='||nr_seq_parametro_w);
 
	end;
elsif (ie_tipo_texto_p = 4) then 
	begin 
	select	nextval('med_pedido_exame_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select ' ' 
	into STRICT	ds_parametro_w 
	from	med_pedido_exame 
	where	nr_sequencia 	= nr_seq_parametro_p;
	insert into med_pedido_exame(nr_sequencia, 
		dt_solicitacao, 
		ds_solicitacao, 
		dt_atualizacao, 
		nm_usuario, 
		ds_dados_clinicos, 
		cd_exame, 
		nr_atendimento, 
		nr_seq_cliente, 
		ie_ficha_unimed, 
		ds_cid, 
		ds_diagnostico_cid, 
		ie_carater_solic, 
		ie_data) 
	(SELECT nr_seq_parametro_w, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_dados_clinicos, 
		cd_exame, 
		nr_atendimento, 
		nr_seq_cliente, 
		ie_ficha_unimed, 
		ds_cid, 
		ds_diagnostico_cid, 
		coalesce(ie_carater_solic,'E'), 
		'S' 
	from	med_pedido_exame 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_solicitacao <= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		dt_solicitacao, 
		ds_parametro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		ds_dados_clinicos, 
		cd_exame, 
		nr_atendimento, 
		nr_seq_cliente, 
		ie_ficha_unimed, 
		ds_cid, 
		ds_diagnostico_cid, 
		coalesce(ie_carater_solic,'E'), 
		'S' 
	from	med_pedido_exame 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_solicitacao > clock_timestamp());
 
	insert	into Med_Ped_Exame_Cod(nr_sequencia, 
		nr_seq_pedido, 
		dt_atualizacao, 
		nm_usuario, 
		nr_seq_exame, 
		qt_exame, 
		nr_seq_apresent) 
	(SELECT	nextval('med_ped_exame_cod_seq'), 
		nr_seq_parametro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_exame, 
		qt_exame, 
		nr_seq_apresent 
	from	Med_Ped_Exame_Cod 
	where	nr_seq_pedido	= nr_seq_parametro_p);
 
	CALL copia_campo_long_de_para(	'med_pedido_exame', 
			'ds_solicitacao', 
			' where nr_sequencia = :nr_sequencia ', 
			'nr_sequencia='||nr_seq_parametro_p, 
			'med_pedido_exame', 
			'ds_solicitacao', 
			' where nr_sequencia = :nr_sequencia', 
			'nr_sequencia='||nr_seq_parametro_w);
 
	end;
elsif (ie_tipo_texto_p = 5) then 
	begin 
	select	nextval('med_exame_avaliacao_seq') 
	into STRICT	nr_seq_parametro_w 
	;
 
	select	max(' ') 
	into STRICT	ds_parametro_w 
	from	med_exame_avaliacao 
	where	nr_sequencia 	= nr_seq_parametro_p;
 
	insert into med_exame_avaliacao(nr_sequencia, 
		nr_atendimento, 
		nr_seq_tipo_exame, 
		dt_atualizacao, 
		nm_usuario, 
		dt_exame, 
		nr_seq_cliente) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		nr_seq_tipo_exame, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		nr_seq_cliente 
	from	med_exame_avaliacao 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_exame	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		nr_seq_tipo_exame, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		nr_seq_cliente 
	from	med_exame_avaliacao 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_exame	> clock_timestamp());
 
	update	med_exame_avaliacao 
	set	ds_exame	= ds_parametro_w 
	where	nr_sequencia	= nr_seq_parametro_w;
 
 
	CALL copia_campo_long_de_para(	'med_exame_avaliacao', 
		'ds_exame', 
		' where nr_sequencia = :nr_sequencia ', 
		'nr_sequencia='||nr_seq_parametro_p, 
		'med_exame_avaliacao', 
		'ds_exame', 
		' where nr_sequencia = :nr_sequencia', 
		'nr_sequencia='||nr_seq_parametro_w);
 
	end;
elsif (ie_tipo_texto_p = 6) then 
	begin 
	select	nextval('med_texto_adicional_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select ' ' 
	into STRICT	ds_parametro_w 
	from	med_texto_adicional 
	where	nr_sequencia 	= nr_seq_parametro_p;
	insert into med_texto_adicional(nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_texto, 
		ds_texto, 
		nr_seq_cliente) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_seq_cliente 
	from	med_texto_adicional 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_texto 	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_texto, 
		ds_parametro_w, 
		nr_seq_cliente 
	from	med_texto_adicional 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_texto 	> clock_timestamp());
 
	CALL copia_campo_long_de_para(	'med_texto_adicional', 
		'ds_texto', 
		' where nr_sequencia = :nr_sequencia ', 
		'nr_sequencia='||nr_seq_parametro_p, 
		'med_texto_adicional', 
		'ds_texto', 
		' where nr_sequencia = :nr_sequencia', 
		'nr_sequencia='||nr_seq_parametro_w);
 
	end;
elsif (ie_tipo_texto_p = 8) then 
	begin 
	select	nextval('med_atestado_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select ' ' 
	into STRICT	ds_parametro_w 
	from	med_atestado 
	where	nr_sequencia 	= nr_seq_parametro_p;
	 
	insert into med_atestado(nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atestado, 
		ds_atestado, 
		nr_seq_cliente, 
		cd_especialidade, 
		qt_dia, 
		cd_cid_atestado, 
		cd_profissao, 
		cd_setor, 
		dt_final) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_seq_cliente, 
		cd_especialidade, 
		qt_dia, 
		cd_cid_atestado, 
		cd_profissao, 
		cd_setor, 
		dt_final 
	from	med_atestado 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_atestado	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_atestado, 
		ds_parametro_w, 
		nr_seq_cliente, 
		cd_especialidade, 
		qt_dia, 
		cd_cid_atestado, 
		cd_profissao, 
		cd_setor, 
		dt_final 
	from	med_atestado 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_atestado	> clock_timestamp());
 
	CALL copia_campo_long_de_para(	'med_atestado', 
					'ds_atestado', 
					' where nr_sequencia = :nr_sequencia ', 
					'nr_sequencia='||nr_seq_parametro_p, 
					'med_atestado', 
					'ds_atestado', 
					' where nr_sequencia = :nr_sequencia', 
					'nr_sequencia='||nr_seq_parametro_w);
	end;
elsif (ie_tipo_texto_p = 9) then 
	begin 
	select	nextval('med_pac_diagnostico_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select ds_diagnostico 
	into STRICT	ds_parametro_w 
	from	med_pac_diagnostico 
	where	nr_sequencia 	= nr_seq_parametro_p;
	insert into med_pac_diagnostico(nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_diagnostico, 
		ds_diagnostico, 
		nr_seq_cliente) 
	(SELECT nr_seq_parametro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_seq_cliente 
	from	med_pac_diagnostico 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_diagnostico	<= clock_timestamp() 
	
union
 
	SELECT 	nr_seq_parametro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_diagnostico, 
		ds_parametro_w, 
		nr_seq_cliente 
	from	med_pac_diagnostico 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_diagnostico	> clock_timestamp());
	end;
elsif (ie_tipo_texto_p = 10) then 
	begin 
	select	nextval('med_parecer_medico_seq') 
	into STRICT	nr_seq_parametro_w 
	;
	select  ' ' 
	into STRICT	ds_parametro_w 
	from	med_parecer_medico 
	where	nr_sequencia 	= nr_seq_parametro_p;
	insert into med_parecer_medico(nr_sequencia, 
		nr_atendimento, 
		dt_atualizacao, 
		nm_usuario, 
		dt_parecer, 
		ds_parecer, 
		nr_seq_cliente, 
		cd_medico) 
	(SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		trunc(clock_timestamp()), 
		ds_parametro_w, 
		nr_seq_cliente, 
		cd_medico 
	from	med_parecer_medico 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_parecer	<= clock_timestamp() 
	
union
 
	SELECT nr_seq_parametro_w, 
		nr_atendimento, 
		clock_timestamp(), 
		nm_usuario_p, 
		dt_parecer, 
		ds_parametro_w, 
		nr_seq_cliente, 
		cd_medico 
	from	med_parecer_medico 
	where 	nr_sequencia	= nr_seq_parametro_p 
	and	dt_parecer	> clock_timestamp());
 
 
	CALL copia_campo_long_de_para(	'med_parecer_medico', 
				'ds_parecer', 
				' where nr_sequencia = :nr_sequencia ', 
				'nr_sequencia='||nr_seq_parametro_p, 
				'med_parecer_medico', 
				'ds_parecer', 
				' where nr_sequencia = :nr_sequencia', 
				'nr_sequencia='||nr_seq_parametro_w);
	end;
elsif (ie_tipo_texto_p = 11) then 
	begin 
	select	nextval('laudo_paciente_seq') 
	into STRICT	nr_seq_parametro_w 
	;	
 
	insert into laudo_paciente( 
			nr_sequencia, 
			cd_anestesista, 
			cd_laudo_externo, 
			cd_laudo_padrao, 
			cd_medico_aux, 
			cd_medico_resp, 
			cd_pessoa_fisica, 
			cd_projeto, 
			cd_protocolo, 
			cd_residente, 
			cd_setor_atendimento, 
			cd_setor_usuario, 
			cd_tecnico_resp, 
			ds_arquivo, 
			ds_indicacao_clinica_laudo, 
			--ds_laudo, 
			ds_observacao_preparo, 
			ds_titulo_laudo, 
			dt_atualizacao, 
			dt_conferencia, 
			dt_entrada_unidade, 
			dt_exame, 
			dt_integracao, 
			dt_laudo, 
			dt_liberacao, 
			ie_birads, 
			ie_cd_laudo, 
			ie_formato, 
			ie_formato_texto, 
			ie_gerar_comunic, 
			ie_midia_entregue, 
			ie_normal, 
			ie_status_laudo, 
			ie_tipo_medida, 
			ie_tumor, 
			nm_medico_solicitante, 
			nm_usuario, 
			nm_usuario_aprovacao, 
			nm_usuario_liberacao, 
			nr_agrupamento, 
			nr_atendimento, 
			nr_controle, 
			nr_exame, 
			nr_laudo, 
			nr_prescricao, 
			nr_qualidade_preparo, 
			nr_seq_grupo_medida, 
			nr_seq_motivo_canc, 
			nr_seq_motivo_desap, 
			nr_seq_motivo_parada, 
			nr_seq_pac_prot_ext, 
			nr_seq_pagina, 
			nr_seq_prescricao, 
			nr_seq_proc, 
			nr_seq_resultado_padrao, 
			nr_seq_superior, 
			qt_audio, 
			qt_caracteres, 
			qt_imagem) 
	SELECT 	nr_seq_parametro_w, 
			cd_anestesista, 
			cd_laudo_externo, 
			cd_laudo_padrao, 
			cd_medico_aux, 
			cd_medico_resp, 
			cd_pessoa_fisica, 
			cd_projeto, 
			cd_protocolo, 
			cd_residente, 
			cd_setor_atendimento, 
			cd_setor_usuario, 
			cd_tecnico_resp, 
			ds_arquivo, 
			ds_indicacao_clinica_laudo, 
			--ds_laudo, 
			ds_observacao_preparo, 
			ds_titulo_laudo, 
			clock_timestamp(), 
			dt_conferencia, 
			dt_entrada_unidade, 
			clock_timestamp(), 
			dt_integracao, 
			clock_timestamp(), 
			clock_timestamp(), 
			ie_birads, 
			ie_cd_laudo, 
			ie_formato, 
			ie_formato_texto, 
			ie_gerar_comunic, 
			ie_midia_entregue, 
			ie_normal, 
			ie_status_laudo, 
			ie_tipo_medida, 
			ie_tumor, 
			nm_medico_solicitante, 
			nm_usuario_p, 
			nm_usuario_aprovacao, 
			nm_usuario_p, 
			nr_agrupamento, 
			nr_atendimento, 
			nr_controle, 
			nr_exame, 
			nr_laudo, 
			nr_prescricao, 
			nr_qualidade_preparo, 
			nr_seq_grupo_medida, 
			nr_seq_motivo_canc, 
			nr_seq_motivo_desap, 
			nr_seq_motivo_parada, 
			nr_seq_pac_prot_ext, 
			nr_seq_pagina, 
			nr_seq_prescricao, 
			nr_seq_proc, 
			nr_seq_resultado_padrao, 
			nr_seq_superior, 
			qt_audio, 
			qt_caracteres, 
			qt_imagem 
	from	laudo_paciente 
	where 	nr_sequencia	= nr_seq_parametro_p;
	commit;
	select	nextval('med_laudo_cdi_seq') 
	into STRICT	nr_seq_laudo_w 
	;	
	 
	insert into med_laudo_cdi( 
			nr_sequencia, 
			cd_medico, 
			ds_laudo, 
			dt_atualizacao, 
			dt_atualizacao_nrec, 
			nm_usuario, 
			nm_usuario_nrec, 
			nr_seq_classif, 
			nr_seq_laudo) 
	SELECT nr_seq_laudo_w, 
			cd_medico, 
			ds_laudo, 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario, 
			nm_usuario_nrec, 
			nr_seq_classif, 
			nr_seq_parametro_w 
	from	med_laudo_cdi 
	where	nr_seq_laudo = nr_seq_parametro_p;
	 
	CALL copia_campo_long_de_para(	'laudo_paciente', 
			'ds_laudo', 
			' where nr_sequencia = :nr_sequencia ', 
			'nr_sequencia='||nr_seq_parametro_p, 
			'laudo_paciente', 
			'ds_laudo', 
			' where nr_sequencia = :nr_sequencia', 
			'nr_sequencia='||nr_seq_parametro_w);
			 
	end;
end if;
 
commit;
 
select	max(nr_sequencia) 
into STRICT	nr_max_sequencia_w 
from	med_pedido_exame;
 
nr_seq_registro_p := nr_seq_parametro_w;
nr_max_sequencia_p := nr_max_sequencia_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_textos_medicos (nr_seq_parametro_p bigint, ie_tipo_texto_p bigint, nm_usuario_p text, nr_seq_registro_p INOUT bigint, nr_max_sequencia_p INOUT bigint) FROM PUBLIC;
