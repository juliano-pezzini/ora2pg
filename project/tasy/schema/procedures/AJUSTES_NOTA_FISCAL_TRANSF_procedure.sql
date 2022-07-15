-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ajustes_nota_fiscal_transf () AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	' alter table NOTA_FISCAL_TRANSFERENCIA drop constraint '||constraint_name ds_comando
	from	user_constraints a
	where	table_name = 'NOTA_FISCAL_TRANSFERENCIA'
	and	constraint_type = 'R';

C02 CURSOR FOR
	SELECT	' drop index '||index_name ds_comando
	from	user_indexes a
	where	table_name = 'NOTA_FISCAL_TRANSFERENCIA'
	and	index_name <> 'NFTRANS_PK';

ds_comando_w varchar(500);


BEGIN

/*
Deletar CONSTRAINTS da tabela 'NOTA_FISCAL_TRANSFERENCIA'
*/
open C01;
loop
fetch C01 into	
	ds_comando_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL exec_sql_dinamico('TasyOS2017526',ds_comando_w);
	end;
end loop;
close C01;

/*
Deletar INDICES da tabela 'NOTA_FISCAL_TRANSFERENCIA'
*/
open C02;
loop
fetch C02 into	
	ds_comando_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	CALL exec_sql_dinamico('TasyOS2017526',ds_comando_w);
	end;
end loop;
close C02;

/*
Deletar CONSTRAINTS da tabela 'NOTA_FISCAL_TRANSFERENCIA' no dicionário
*/
begin

delete from INTEGRIDADE_atributo
where nm_tabela = 'NOTA_FISCAL_TRANSFERENCIA';

delete from INTEGRIDADE_referencial
where nm_tabela = 'NOTA_FISCAL_TRANSFERENCIA';

/*
Deletar INDICES da tabela 'NOTA_FISCAL_TRANSFERENCIA' no dicionário
*/
delete
from indice_atributo
where nm_tabela  = 'NOTA_FISCAL_TRANSFERENCIA'
and nm_indice <> 'NFTRANS_PK';

delete
from indice
where nm_tabela  = 'NOTA_FISCAL_TRANSFERENCIA'
and nm_indice <> 'NFTRANS_PK';

commit;

/*
Criar CONSTRAINTS da tabela 'NOTA_FISCAL_TRANSFERENCIA' no dicionário
*/
insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('OPERACAO_NOTA','NFTRANS_OPENOTA_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:32:26','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:32:37','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_OPERACAO_NF_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_OPENOTA_FK',TO_DATE('24/10/2019 15:32:55','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NATUREZA_OPERACAO','NFTRANS_NATOPER_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:16:08','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:16:36','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_NATUREZA_OPERACAO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NATOPER_FK',TO_DATE('24/10/2019 15:16:53','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NATUREZA_OPERACAO','NFTRANS_NATOPER_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:31:23','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:31:38','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_NATUREZA_OPERACAO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NATOPER_FK2',TO_DATE('24/10/2019 15:31:55','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('OPERACAO_NOTA','NFTRANS_OPENOTA_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:33:14','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:33:24','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_OPERACAO_NF_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_OPENOTA_FK2',TO_DATE('24/10/2019 15:33:34','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('CONDICAO_PAGAMENTO','NFTRANS_CONPAGA_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:33:43','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:33:56','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CONDICAO_PAGAMENTO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_CONPAGA_FK',TO_DATE('24/10/2019 15:34:07','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('CONDICAO_PAGAMENTO','NFTRANS_CONPAGA_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:34:16','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:34:26','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CONDICAO_PAGAMENTO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_CONPAGA_FK2',TO_DATE('24/10/2019 15:34:35','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('PESSOA_JURIDICA','NFTRANS_PESJURI_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:34:44','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:34:54','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CGC_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_PESJURI_FK',TO_DATE('24/10/2019 15:35:06','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('PESSOA_JURIDICA','NFTRANS_PESJURI_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:35:15','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:35:30','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CGC_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_PESJURI_FK2',TO_DATE('24/10/2019 15:35:39','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('ESTABELECIMENTO','NFTRANS_ESTABEL_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:35:50','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:35:59','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_ESTABELECIMENTO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_ESTABEL_FK',TO_DATE('24/10/2019 15:36:14','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('ESTABELECIMENTO','NFTRANS_ESTABEL_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:36:23','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:36:33','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_ESTABELECIMENTO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_ESTABEL_FK2',TO_DATE('24/10/2019 15:36:42','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NOTA_FISCAL','NFTRANS_NOTFISC_FK','','NO ACTION','I','A',TO_DATE('24/10/2019 15:36:52','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:37:02','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK',TO_DATE('24/10/2019 15:37:12','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NOTA_FISCAL','NFTRANS_NOTFISC_FK2','','NO ACTION','I','A',TO_DATE('24/10/2019 15:37:21','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:37:29','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK2',TO_DATE('24/10/2019 15:37:40','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_REFERENCIAL(NM_TABELA_REFERENCIA,NM_INTEGRIDADE_REFERENCIAL,DS_INTEGRIDADE_REFERENCIAL,IE_REGRA_DELECAO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NOTA_FISCAL','NFTRANS_NOTFISC_FK3','','NO ACTION','I','A',TO_DATE('24/10/2019 15:37:50','dd/mm/yyyy hh24:mi:ss'),'NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:38:00','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INTEGRIDADE_ATRIBUTO(IE_SEQUENCIA_CRIACAO,NM_ATRIBUTO,NM_ATRIBUTO_REF,NM_TABELA,NM_INTEGRIDADE_REFERENCIAL,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_ORIGEM','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK3',TO_DATE('24/10/2019 15:38:09','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

commit;

/*
Criar INDICES da tabela 'NOTA_FISCAL_TRANSFERENCIA' no dicionário
*/
insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_OPENOTA_FK2_I','','I','I','A',TO_DATE('24/10/2019 13:33:52','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 13:33:58','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

 insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_OPERACAO_NF_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_OPENOTA_FK2_I',TO_DATE('24/10/2019 13:35:15','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_NATOPER_FK2_I','','I','I','A',TO_DATE('24/10/2019 15:08:47','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:08:54','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_NATUREZA_OPERACAO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NATOPER_FK2_I',TO_DATE('24/10/2019 15:09:02','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_CONPAGA_FK2_I','','I','I','A',TO_DATE('24/10/2019 15:09:43','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:09:50','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CONDICAO_PAGAMENTO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_CONPAGA_FK2_I',TO_DATE('24/10/2019 15:09:57','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_PESJURI_FK2_I','','I','I','A',TO_DATE('24/10/2019 15:10:35','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:10:41','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CGC_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_PESJURI_FK2_I',TO_DATE('24/10/2019 15:10:53','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_ESTABEL_FK2_I','','I','I','A',TO_DATE('24/10/2019 15:12:51','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:12:56','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_ESTABELECIMENTO_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_ESTABEL_FK2_I',TO_DATE('24/10/2019 15:13:11','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_NOTFISC_FK_I','','I','I','A',TO_DATE('24/10/2019 15:13:35','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:13:51','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK_I',TO_DATE('24/10/2019 15:14:12','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_NOTFISC_FK2_I','','I','I','A',TO_DATE('24/10/2019 15:14:17','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:14:25','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_E','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK2_I',TO_DATE('24/10/2019 15:14:34','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_NOTFISC_FK3_I','','I','I','A',TO_DATE('24/10/2019 15:15:06','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:15:14','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'NR_SEQ_NOTA_FISCAL_ORIGEM','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NOTFISC_FK3_I',TO_DATE('24/10/2019 15:15:23','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO) 
 values ('NFTRANS_NATOPER_FK_I','','I','I','A',TO_DATE('24/10/2019 15:08:07','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:08:23','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_NATUREZA_OPERACAO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_NATOPER_FK_I',TO_DATE('24/10/2019 15:08:39','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_OPENOTA_FK_I','','I','I','A',TO_DATE('24/10/2019 13:33:09','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 13:33:32','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_OPERACAO_NF_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_OPENOTA_FK_I',TO_DATE('24/10/2019 13:33:47','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_CONPAGA_FK_I','','I','I','A',TO_DATE('24/10/2019 15:09:10','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:09:28','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CONDICAO_PAGAMENTO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_CONPAGA_FK_I',TO_DATE('24/10/2019 15:09:39','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_PESJURI_FK_I','','I','I','A',TO_DATE('24/10/2019 15:10:03','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:10:22','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_CGC_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_PESJURI_FK_I',TO_DATE('24/10/2019 15:10:31','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE(NM_INDICE,DS_INDICE,IE_TIPO,IE_CRIAR_ALTERAR,IE_SITUACAO,DT_CRIACAO,IE_IGNORADO_CLIENTE,IE_CLASSIFICACAO,DS_MENSAGEM,NM_TABELA,DT_ATUALIZACAO,NM_USUARIO)
 values ('NFTRANS_ESTABEL_FK_I','','I','I','A',TO_DATE('24/10/2019 15:12:26','dd/mm/yyyy hh24:mi:ss'),'','IR','','NOTA_FISCAL_TRANSFERENCIA',TO_DATE('24/10/2019 15:12:35','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

insert into INDICE_ATRIBUTO(NR_SEQUENCIA,NM_ATRIBUTO,DS_INDICE_FUNCTION,NM_TABELA,NM_INDICE,DT_ATUALIZACAO,NM_USUARIO)
 values (1,'CD_ESTABELECIMENTO_S','','NOTA_FISCAL_TRANSFERENCIA','NFTRANS_ESTABEL_FK_I',TO_DATE('24/10/2019 15:12:47','dd/mm/yyyy hh24:mi:ss'),'esrodrigues');

commit;

exception
when others then
		null;
end;

/*
Criar INDICES e CONSTRAINTS da tabela 'NOTA_FISCAL_TRANSFERENCIA' no banco
*/
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_NATOPER_FK_I on NOTA_FISCAL_TRANSFERENCIA(CD_NATUREZA_OPERACAO_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_OPENOTA_FK_I on NOTA_FISCAL_TRANSFERENCIA(CD_OPERACAO_NF_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_OPENOTA_FK2_I on NOTA_FISCAL_TRANSFERENCIA(CD_OPERACAO_NF_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_NATOPER_FK2_I on NOTA_FISCAL_TRANSFERENCIA(CD_NATUREZA_OPERACAO_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_CONPAGA_FK_I on NOTA_FISCAL_TRANSFERENCIA(CD_CONDICAO_PAGAMENTO_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_CONPAGA_FK2_I on NOTA_FISCAL_TRANSFERENCIA(CD_CONDICAO_PAGAMENTO_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_PESJURI_FK_I on NOTA_FISCAL_TRANSFERENCIA(CD_CGC_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_PESJURI_FK2_I on NOTA_FISCAL_TRANSFERENCIA(CD_CGC_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_ESTABEL_FK_I on NOTA_FISCAL_TRANSFERENCIA(CD_ESTABELECIMENTO_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_ESTABEL_FK2_I on NOTA_FISCAL_TRANSFERENCIA(CD_ESTABELECIMENTO_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_NOTFISC_FK_I on NOTA_FISCAL_TRANSFERENCIA(NR_SEQ_NOTA_FISCAL_S)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_NOTFISC_FK2_I on NOTA_FISCAL_TRANSFERENCIA(NR_SEQ_NOTA_FISCAL_E)');
CALL exec_sql_dinamico('TasyOS2017526', 'Create Index NFTRANS_NOTFISC_FK3_I on NOTA_FISCAL_TRANSFERENCIA(NR_SEQ_NOTA_FISCAL_ORIGEM)');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_OPENOTA_FK Foreign Key (CD_OPERACAO_NF_S) References OPERACAO_NOTA (CD_OPERACAO_NF))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_NATOPER_FK Foreign Key (CD_NATUREZA_OPERACAO_S) References NATUREZA_OPERACAO (CD_NATUREZA_OPERACAO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_NATOPER_FK2 Foreign Key (CD_NATUREZA_OPERACAO_E) References NATUREZA_OPERACAO (CD_NATUREZA_OPERACAO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_OPENOTA_FK2 Foreign Key (CD_OPERACAO_NF_E) References OPERACAO_NOTA (CD_OPERACAO_NF))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_CONPAGA_FK Foreign Key (CD_CONDICAO_PAGAMENTO_S) References CONDICAO_PAGAMENTO (CD_CONDICAO_PAGAMENTO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_CONPAGA_FK2 Foreign Key (CD_CONDICAO_PAGAMENTO_E) References CONDICAO_PAGAMENTO (CD_CONDICAO_PAGAMENTO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_PESJURI_FK Foreign Key (CD_CGC_S) References PESSOA_JURIDICA (CD_CGC))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_PESJURI_FK2 Foreign Key (CD_CGC_E) References PESSOA_JURIDICA (CD_CGC))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_ESTABEL_FK Foreign Key (CD_ESTABELECIMENTO_S) References ESTABELECIMENTO (CD_ESTABELECIMENTO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_ESTABEL_FK2 Foreign Key (CD_ESTABELECIMENTO_E) References ESTABELECIMENTO (CD_ESTABELECIMENTO))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_NOTFISC_FK Foreign Key (NR_SEQ_NOTA_FISCAL_S) References NOTA_FISCAL (NR_SEQUENCIA))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_NOTFISC_FK2 Foreign Key (NR_SEQ_NOTA_FISCAL_E) References NOTA_FISCAL (NR_SEQUENCIA))');
CALL exec_sql_dinamico('TasyOS2017526', 'Alter Table NOTA_FISCAL_TRANSFERENCIA add (Constraint NFTRANS_NOTFISC_FK3 Foreign Key (NR_SEQ_NOTA_FISCAL_ORIGEM) References NOTA_FISCAL (NR_SEQUENCIA))');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ajustes_nota_fiscal_transf () FROM PUBLIC;

