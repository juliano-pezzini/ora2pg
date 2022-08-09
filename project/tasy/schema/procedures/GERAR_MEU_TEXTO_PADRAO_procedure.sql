-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_meu_texto_padrao ( nm_tabela_p text, nm_atributo_pk_p text, nr_sequencia_p bigint, ds_titulo_p text, nr_seq_item_pep_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nm_atributo_w	varchar(255);
nr_sequencia_w	bigint;


BEGIN 
 
if (nm_tabela_p	= 'EVOLUCAO_PACIENTE') then 
	nm_atributo_w	:= 'DS_EVOLUCAO';
elsif (nm_tabela_p	= 'ANAMNESE_PACIENTE') then 
	nm_atributo_w	:= 'DS_ANAMNESE';
elsif (nm_tabela_p	= 'ATENDIMENTO_ALTA') then 
	nm_atributo_w	:= 'DS_ORIENTACAO';
elsif (nm_tabela_p	= 'ANESTESIA_DESCRICAO') then 
	nm_atributo_w	:= 'DS_ANESTESIA';
elsif (nm_tabela_p	= 'CIRURGIA_DESCRICAO') then 
	nm_atributo_w	:= 'DS_CIRURGIA';
elsif (nm_tabela_p	= 'FA_RECEITA_FARMACIA_ITEM') then 
	nm_atributo_w	:= 'DS_TEXTO_RECEITA';
elsif (nm_tabela_p	= 'MED_RECEITA') then 
	nm_atributo_w	:= 'DS_RECEITA';
end if;
 
if (nm_atributo_w IS NOT NULL AND nm_atributo_w::text <> '') then 
 
	select	nextval('med_texto_padrao_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert into MED_TEXTO_PADRAO(	nr_sequencia, 
					cd_medico, 
					ds_titulo, 
					dt_atualizacao, 
					nm_usuario, 
					DT_ATUALIZACAO_NREC, 
					nm_usuario_nrec, 
					NR_SEQ_ITEM_PRONT) 
			values (	nr_sequencia_w, 
					Obter_Dados_Usuario_Opcao(nm_usuario_p,'C'), 
					ds_titulo_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					nr_seq_item_pep_p);
 
	CALL COPIA_CAMPO_LONG_DE_PARA(nm_tabela_p,nm_atributo_w,' where '||nm_atributo_pk_p || ' = :nr_sequencia ','nr_sequencia='||nr_sequencia_p, 
				'MED_TEXTO_PADRAO','DS_TEXTO', ' where nr_sequencia = :nr_sequencia','nr_sequencia='||nr_sequencia_w);
 
 
 
 
 
	commit;
 
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_meu_texto_padrao ( nm_tabela_p text, nm_atributo_pk_p text, nr_sequencia_p bigint, ds_titulo_p text, nr_seq_item_pep_p bigint, nm_usuario_p text) FROM PUBLIC;
