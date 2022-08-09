-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_proc_repasse_log () AS $body$
DECLARE


qt_reg_w	bigint := 0;


BEGIN

delete from PROCEDIMENTO_REPASSE_LOG;

qt_reg_w := executar_sql_dinamico('Drop Index PRRELOG_PROPART_FK_I', qt_reg_w);
qt_reg_w := executar_sql_dinamico('Alter Table PROCEDIMENTO_REPASSE_LOG drop constraint PRRELOG_PROPART_FK', qt_reg_w);

select 	count(*)
into STRICT	qt_reg_w
from	user_tab_columns
where	table_name = 'PROCEDIMENTO_REPASSE_LOG'
and	column_name = 'NR_SEQ_PROC_PARTIC';

if (qt_reg_w = 0) then
	begin

	qt_reg_w := executar_sql_dinamico('alter table PROCEDIMENTO_REPASSE_LOG add NR_SEQ_PROC_PARTIC number(10)', qt_reg_w);

	commit;

	end;
end if;

select 	count(*)
into STRICT	qt_reg_w
from	TABELA_ATRIBUTO
where	NM_TABELA = 'PROCEDIMENTO_REPASSE_LOG'
and	NM_ATRIBUTO = 'NR_SEQ_PROC_PARTIC';

if (qt_reg_w = 0) then
	begin
	Insert into TABELA_ATRIBUTO(NM_TABELA,NM_ATRIBUTO,NR_SEQUENCIA_CRIACAO,IE_OBRIGATORIO,IE_TIPO_ATRIBUTO,DT_ATUALIZACAO,NM_USUARIO,QT_TAMANHO,QT_DECIMAIS,
				IE_CRIAR_ALTERAR,DS_ATRIBUTO,IE_SITUACAO,QT_TAMANHO_CALCULO,QT_SEQ_INICIO,QT_SEQ_INCREMENTO,DT_CRIACAO,VL_DEFAULT,
				IE_COMPONENTE,DS_VALORES,CD_DOMINIO,QT_TAM_DELPHI,DS_LABEL,NR_SEQ_APRESENT,DS_LABEL_GRID,NR_SEQ_ORDEM,QT_COLUNA,DS_MASCARA,
				QT_DESLOC_DIREITA,QT_TAM_LABEL,QT_TAM_GRID,IE_READONLY,IE_TABSTOP,NR_SEQ_LOCALIZADOR,QT_ALTURA,IE_CRIAR_DESCRICAO,NM_ATRIBUTO_PAI,
				IE_LOG_EXCLUSAO,NR_SEQ_TABSTOP,NR_SEQ_GRID,NR_SEQ_ORDEM_SERV,DS_FILTER,DS_LABEL_LONGO,IE_CONVERTE_NEGATIVO,QT_CACHE,IE_LOG_UPDATE,
				IE_ATUALIZAR_VERSAO,IE_STATUS,DS_COR,IE_CRIAR_DESC_FK,QT_TAM_FONTE,DS_ESTILO_FONTE,IE_REGRA_UNID_MEDIDA,IE_APLICABILIDADE_ESTILO,
				IE_UNIDADE_MEDIDA,DT_ATUALIZACAO_NREC,NM_USUARIO_NREC,IE_DEFAULT_BANCO,IE_DBL_CLICK_READONLY,IE_TIPO_BOTAO,IE_TOTALIZAR,DS_COMANDO,
				CD_EXP_DESC,CD_EXP_LABEL,CD_EXP_LABEL_GRID,CD_EXP_VALORES,CD_EXP_LABEL_LONGO,IE_INFORMACAO_SENSIVEL,IE_TIPO_DATE,NR_SEQ_DIC_OBJETO)
	values ('PROCEDIMENTO_REPASSE_LOG','NR_SEQ_PROC_PARTIC','27','N','NUMBER',to_date('05/06/17','DD/MM/RR'),'gfsantos','10','0','M','Gerado pelo sistema.','A',null,
	null,null,to_date('05/06/17','DD/MM/RR'),null,null,null,null,null,null,null,null,null,null,null,null,null,null,'N','S',null,null,'N',null,'N',null,null,null,null,
	null,null,null,'N','S',null,null,'S',null,null,null,null,null,null,null,null,null,null,null,null,'557610',null,null,null,null,null,null,null);

	commit;

	end;
end if;

delete from INTEGRIDADE_ATRIBUTO
where nm_integridade_referencial = 'PRRELOG_PROPART_FK';

Insert into INTEGRIDADE_ATRIBUTO(NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,NM_ATRIBUTO,IE_SEQUENCIA_CRIACAO,DT_ATUALIZACAO,NM_USUARIO,NM_ATRIBUTO_REF)
values ('PROCEDIMENTO_REPASSE_LOG','PRRELOG_PROPART_FK','NR_SEQ_PROC_PARTIC','1',to_date('05/06/17','DD/MM/RR'),'gfsantos',null);
Insert into INTEGRIDADE_ATRIBUTO(NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,NM_ATRIBUTO,IE_SEQUENCIA_CRIACAO,DT_ATUALIZACAO,NM_USUARIO,NM_ATRIBUTO_REF)
values ('PROCEDIMENTO_REPASSE_LOG','PRRELOG_PROPART_FK','NR_SEQ_PARTICIPANTE','2',to_date('02/06/17','DD/MM/RR'),'gfsantos',null);

delete from INDICE_ATRIBUTO
where nm_indice = 'PRRELOG_PROPART_FK_I';

Insert into INDICE_ATRIBUTO(NM_TABELA,NM_INDICE,NR_SEQUENCIA,NM_ATRIBUTO,DT_ATUALIZACAO,NM_USUARIO,DS_INDICE_FUNCTION)
values ('PROCEDIMENTO_REPASSE_LOG','PRRELOG_PROPART_FK_I','2','NR_SEQ_PARTICIPANTE',to_date('02/05/17','DD/MM/RR'),'gfsantos',null);
Insert into INDICE_ATRIBUTO(NM_TABELA,NM_INDICE,NR_SEQUENCIA,NM_ATRIBUTO,DT_ATUALIZACAO,NM_USUARIO,DS_INDICE_FUNCTION)
values ('PROCEDIMENTO_REPASSE_LOG','PRRELOG_PROPART_FK_I','1','NR_SEQ_PROC_PARTIC',to_date('05/06/17','DD/MM/RR'),'gfsantos',null);

qt_reg_w := executar_sql_dinamico('Create Index PRRELOG_PROPART_FK_I on PROCEDIMENTO_REPASSE_LOG(NR_SEQ_PROC_PARTIC,NR_SEQ_PARTICIPANTE)', qt_reg_w);

qt_reg_w := executar_sql_dinamico('Alter Table PROCEDIMENTO_REPASSE_LOG add (
			Constraint PRRELOG_PROPART_FK Foreign Key (
				NR_SEQ_PROC_PARTIC,
				NR_SEQ_PARTICIPANTE)
			References PROCEDIMENTO_PARTICIPANTE (
				NR_SEQUENCIA,
				NR_SEQ_PARTIC)
			on delete cascade)', qt_reg_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_proc_repasse_log () FROM PUBLIC;
