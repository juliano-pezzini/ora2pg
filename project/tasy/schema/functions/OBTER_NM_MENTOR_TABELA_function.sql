-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nm_mentor_tabela (nm_tabela_origem_p text, nr_seq_origem_p bigint default null) RETURNS varchar AS $body$
DECLARE

	nm_campo_mentor_w varchar(100);
	nm_campo_mentor_escala_w varchar(100);


BEGIN
	if (coalesce(nm_tabela_origem_p::text, '') = '') then
		case nr_seq_origem_p
			when 	1	then	nm_campo_mentor_w := obter_desc_expressao(490529);
			when	2	then	nm_campo_mentor_w := obter_desc_expressao(618778);
			when 	3	then	nm_campo_mentor_w := obter_desc_expressao(948116);
			when	4	then	nm_campo_mentor_w := obter_desc_expressao(316083);
			when 	5	then	nm_campo_mentor_w := obter_desc_expressao(490530);	
			when	6	then	nm_campo_mentor_w := obter_desc_expressao(722313);
			when 	7	then	nm_campo_mentor_w := obter_desc_expressao(317505);
			else	nm_campo_mentor_w := null;
		end case;
	else	
		case nm_tabela_origem_p
			when	'ATENDIMENTO_SINAL_VITAL' 	then nm_campo_mentor_w := obter_desc_expressao(844337);
			when	'DIAGNOSTICO_DOENCA'		then nm_campo_mentor_w := obter_desc_expressao(287694);
			when	'QUA_EVENTO_PACIENTE'		then nm_campo_mentor_w := obter_desc_expressao(849599);
			when	'EXAME_LAB_RESULT_ITEM' 	then nm_campo_mentor_w := obter_desc_expressao(323606);
			when	'MAN_CLASSIF_RISCO'			then nm_campo_mentor_w := obter_desc_expressao(628009);
			when	'ESCALA_EIF'				then nm_campo_mentor_w := obter_desc_expressao(820907);
			when	'ESCALA_EIF_II'				then nm_campo_mentor_w := obter_desc_expressao(820909);
			else	
				select DS_INFORMACAO
				into STRICT nm_campo_mentor_escala_w
				from vice_escala 
				where nm_tabela = nm_tabela_origem_p 
				and ie_tipo_atributo = 'NUMBER';
				nm_campo_mentor_w := nm_campo_mentor_escala_w;
		end case;
	end if;	
	return nm_campo_mentor_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nm_mentor_tabela (nm_tabela_origem_p text, nr_seq_origem_p bigint default null) FROM PUBLIC;
