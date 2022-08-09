-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_de_unidade ( cd_setor_atend_orig_p bigint, cd_unid_basica_orig_p text, cd_unid_compl_orig_p text, cd_setor_atend_dest_p bigint, cd_unid_basica_dest_p text, cd_unid_compl_dest_p text, ie_exclui_orig_p text, nm_usuario_p text) AS $body$
DECLARE


nm_tabela_w		varchar(50);
nm_tabela_ant_w		varchar(50);

nm_atributo_w		varchar(50);

ds_comando_w		varchar(255);
ds_campo_set_w		varchar(255);
ds_campo_where_w	varchar(255);
ie_campo_w		integer;

c01 CURSOR FOR
	SELECT a.nm_tabela, b.nm_atributo
	from integridade_atributo b,
	     integridade_referencial a
	where a.nm_tabela = b.nm_tabela
	  and a.nm_integridade_referencial = b.nm_integridade_referencial
	  and a.nm_tabela_referencia 	= 'UNIDADE_ATENDIMENTO'
	order by a.nm_tabela, ie_sequencia_criacao;


BEGIN

nm_tabela_ant_w	:= ' ';

open c01;
loop
	fetch c01 into	nm_tabela_w,
			nm_atributo_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	if (nm_tabela_ant_w <> nm_tabela_w) then
		if (nm_tabela_ant_w <> ' ') then
			RAISE NOTICE '% %%', ds_comando_w, ds_campo_set_w, ds_campo_where_w;
			if (nm_tabela_ant_w = 'ATEND_PACIENTE_UNIDADE') then
				ds_campo_where_w := ds_campo_where_w || ' and dt_saida_unidade is not null';
				lock table atend_paciente_unidade in exclusive mode;
				CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
,'alter trigger atend_paciente_unidade_update disable');
				CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
, ds_comando_w || ds_campo_set_w || ds_campo_where_w);
				CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
,'alter trigger atend_paciente_unidade_update enable');
			else
				CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
, ds_comando_w || ds_campo_set_w || ds_campo_where_w);
			end if;
		end if;
		ds_comando_w	:= 'update ' || nm_tabela_w || ' set ';
		ds_campo_set_w	:= nm_atributo_w || ' = ' || cd_setor_atend_dest_p;
		ds_campo_where_w:= ' where ' || nm_atributo_w || ' = ' || cd_setor_atend_orig_p;
		ie_campo_w	:= 1;
	else
		ie_campo_w	:= ie_campo_w + 1;
		if (ie_campo_w = 2) then
			ds_campo_set_w		:= ds_campo_set_w || ',' || nm_atributo_w || '=' || chr(39) || cd_unid_basica_dest_p || chr(39);
			ds_campo_where_w	:= ds_campo_where_w || ' and ' || nm_atributo_w || '=' || chr(39) || cd_unid_basica_orig_p || chr(39);
		else
			ds_campo_set_w		:= ds_campo_set_w || ',' || nm_atributo_w || '=' || chr(39) || cd_unid_compl_dest_p || chr(39);
			ds_campo_where_w	:= ds_campo_where_w || ' and ' || nm_atributo_w || '=' || chr(39) || cd_unid_compl_orig_p || chr(39);
		end if;
	end if;
	nm_tabela_ant_w := nm_tabela_w;
end loop;
close c01;

RAISE NOTICE '% %%', ds_comando_w, ds_campo_set_w, ds_campo_where_w;
if (nm_tabela_ant_w = 'ATEND_PACIENTE_UNIDADE') then
	ds_campo_where_w := ds_campo_where_w || ' and dt_saida_unidade is not null';
	lock table atend_paciente_unidade in exclusive mode;
	CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
,'alter trigger atend_paciente_unidade_update disable');
	CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
, ds_comando_w || ds_campo_set_w || ds_campo_where_w);
	CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
,'alter trigger atend_paciente_unidade_update enable');
else
	CALL Exec_Sql_Dinamico(obter_desc_expressao(292477)/*'Leito'*/
, ds_comando_w || ds_campo_set_w || ds_campo_where_w);
end if;

/*insert into logxxxx_tasy values (sysdate, nm_usuario_p, 800, 'Origem : Setor=' || cd_setor_atend_orig_p ||
							         ' Basica=' || cd_unid_basica_orig_p ||
								 ' Compl=' || cd_unid_compl_orig_p || chr(10) ||
							 'Destino: Setor=' || cd_setor_atend_dest_p ||
							         ' Basica=' || cd_unid_basica_dest_p ||
								 ' Compl=' || cd_unid_compl_dest_p || chr(10) ||
							 'Exclui:' || ie_exclui_orig_p);*/
if (ie_exclui_orig_p = 'S') then
	delete FROM unidade_atendimento
	where cd_setor_atendimento	= cd_setor_atend_orig_p
	  and cd_unidade_basica		= cd_unid_basica_orig_p
	  and cd_unidade_compl		= cd_unid_compl_orig_p;
end if;
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_de_unidade ( cd_setor_atend_orig_p bigint, cd_unid_basica_orig_p text, cd_unid_compl_orig_p text, cd_setor_atend_dest_p bigint, cd_unid_basica_dest_p text, cd_unid_compl_dest_p text, ie_exclui_orig_p text, nm_usuario_p text) FROM PUBLIC;
