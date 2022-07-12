-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_macros_comunic_aval () RETURNS varchar AS $body$
DECLARE


ds_retorno_w            varchar(2000);
ds_enter_w              varchar(10) := chr(13) || chr(10);


BEGIN

ds_retorno_w    :=      '@Paciente 	= Nome do paciente.' 			|| ds_enter_w ||
			'@Idade		= Idade do paciente.' 			|| ds_enter_w ||
			'@Altura		= Altura do paciente.'		|| ds_enter_w ||
			'@Sexo_abrev 	= Abrev. do sexo do paciente.' 		|| ds_enter_w ||
			'@Sexo	 	= Sexo do paciente.' 			|| ds_enter_w ||
			'@Prontuario 	= Prontuário do paciente.' 		|| ds_enter_w ||
			'@Atendimento 	= Número do atendimento.' 		|| ds_enter_w ||
			'@Avaliacao 	= Tipo de avaliação.'	 		|| ds_enter_w ||
			'@Data_atual 	= Data atual.'	 			|| ds_enter_w ||
			'@Data_hr_atual	= Data e hora atual.'			|| ds_enter_w ||
			'@Nascimento 	= Data de nascimento.'	 		|| ds_enter_w ||
			'@Usuario 	= Usuário.'	 			|| ds_enter_w ||
			'@Setor		= Setor.'	 			|| ds_enter_w ||
			'@Pac_setor	= Setor do paciente.'	 		|| ds_enter_w ||
			'@Pac_set_atual	= Setor atual do paciente.'	 		|| ds_enter_w ||
			'@CID 		= CID do atendimento.'			|| ds_enter_w ||
			'@Data_entrada 	= Data entrada.'		 	|| ds_enter_w ||
			'@Data_aval	= Data da avaliação.'		 	|| ds_enter_w ||
			'@Pessoa_lib	= Pessoa que liberou a avaliação.'	|| ds_enter_w ||
			'@Nr_aval	= Número da avaliação.';

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_macros_comunic_aval () FROM PUBLIC;

