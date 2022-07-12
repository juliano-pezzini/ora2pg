-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_programacao_cc_html5 (ie_tipo_retorno_p text, dt_saida_paciente_cc_p timestamp, dt_alta_cc_p timestamp, dt_sala_recuperacao_p timestamp, dt_paciente_termino_p timestamp, dt_chegada_fim_p timestamp, dt_chamada_pre_inducao_p timestamp, dt_paciente_aguardo_p timestamp, dt_chegada_p timestamp, dt_analise_p timestamp ) RETURNS varchar AS $body$
DECLARE

/*
Objetivo da function: Obter descrição e sequência do status da programação cirúrgica do paciente para a função Gestão da Agenda Cirúrgica HTML5

ie_tipo_retorno => Tipo de informação de retorno
	NR : Sequência do status para combinação da legenda do painel
	DS : Descrição do campo a ser exibido com as legendas no grid do painel
ds_atributo_validacao => Nome do atributo a ser validado
*/
ds_programacao_w varchar(255);
nr_seq_programacao_w varchar(15);

BEGIN

ds_programacao_w := '';
nr_seq_programacao_w := '';

	if (dt_saida_paciente_cc_p IS NOT NULL AND dt_saida_paciente_cc_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(745299,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7158';
	end;
	elsif (dt_alta_cc_p IS NOT NULL AND dt_alta_cc_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(745295,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7156';
	end;
	elsif (dt_sala_recuperacao_p IS NOT NULL AND dt_sala_recuperacao_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(321908,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7155';
	end;
	elsif (dt_paciente_termino_p IS NOT NULL AND dt_paciente_termino_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(745289,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7162';
	end;
	elsif (dt_chegada_fim_p IS NOT NULL AND dt_chegada_fim_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(331316,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7154';
	end;
	elsif (dt_chamada_pre_inducao_p IS NOT NULL AND dt_chamada_pre_inducao_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(491382,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7151';
	end;
	elsif (dt_paciente_aguardo_p IS NOT NULL AND dt_paciente_aguardo_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(321914,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7160';
	end;
	elsif (dt_chegada_p IS NOT NULL AND dt_chegada_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(331309,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7153';
	end;
	elsif (dt_analise_p IS NOT NULL AND dt_analise_p::text <> '') then
	begin
		ds_programacao_w := obter_desc_expressao_idioma(318367,null,wheb_usuario_pck.get_nr_seq_idioma);
		nr_seq_programacao_w := '7157';
	end;
	end if;

	if ('NR' = upper(ie_tipo_retorno_p)) then
		return nr_seq_programacao_w;
	elsif ('DS' = upper(ie_tipo_retorno_p)) then
		return ds_programacao_w;
	else 	return null;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_programacao_cc_html5 (ie_tipo_retorno_p text, dt_saida_paciente_cc_p timestamp, dt_alta_cc_p timestamp, dt_sala_recuperacao_p timestamp, dt_paciente_termino_p timestamp, dt_chegada_fim_p timestamp, dt_chamada_pre_inducao_p timestamp, dt_paciente_aguardo_p timestamp, dt_chegada_p timestamp, dt_analise_p timestamp ) FROM PUBLIC;
