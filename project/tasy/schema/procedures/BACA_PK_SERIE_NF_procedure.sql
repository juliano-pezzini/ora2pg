-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_pk_serie_nf () AS $body$
DECLARE


ds_retorno_w			varchar(100);


BEGIN
/*----------------Primeira parte------------------*/

/*Dropa as integridades que referenciam a PK*/

/*Tabela COM_PARAMETRO*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX COMPARA_SERNOFI_FK_I', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COM_PARAMETRO DROP CONSTRAINT COMPARA_SERNOFI_FK', ds_retorno_w);


/*Tabela EME_CONTRATO*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX EMECONT_SERNOFI_FK_I', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE EME_CONTRATO DROP CONSTRAINT EMECONT_SERNOFI_FK', ds_retorno_w);


/*Tabela PARAMETRO_COMPRAS*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX PARCOMP_SERNOFI_FK_I', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PARAMETRO_COMPRAS DROP CONSTRAINT PARCOMP_SERNOFI_FK', ds_retorno_w);


/*Tabela PARAMETRO_NFS*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX PARANFS_SERNOFI_FK_I', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PARAMETRO_NFS DROP CONSTRAINT PARANFS_SERNOFI_FK', ds_retorno_w);


/*Tabela PLS_PARAMETROS*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX PLSPAR_SERNOFI_FK_I', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PLS_PARAMETROS DROP CONSTRAINT PLSPAR_SERNOFI_FK', ds_retorno_w);



/*----------------Segunda parte------------------*/

/*Deleta os indices e as integridades do dicionario de dados*/

delete	from INDICE_ATRIBUTO
where	nm_tabela in ('COM_PARAMETRO', 'EME_CONTRATO', 'PARAMETRO_COMPRAS', 'PARAMETRO_NFS', 'PLS_PARAMETROS')
and	nm_indice in ('COMPARA_SERNOFI_FK_I', 'EMECONT_SERNOFI_FK_I', 'PARCOMP_SERNOFI_FK_I', 'PARANFS_SERNOFI_FK_I', 'PLSPAR_SERNOFI_FK_I');

delete	from indice
where	nm_tabela in ('COM_PARAMETRO', 'EME_CONTRATO', 'PARAMETRO_COMPRAS', 'PARAMETRO_NFS', 'PLS_PARAMETROS')
and	nm_indice in ('COMPARA_SERNOFI_FK_I', 'EMECONT_SERNOFI_FK_I', 'PARCOMP_SERNOFI_FK_I', 'PARANFS_SERNOFI_FK_I', 'PLSPAR_SERNOFI_FK_I');



delete	from INTEGRIDADE_ATRIBUTO
where	nm_tabela in ('COM_PARAMETRO', 'EME_CONTRATO', 'PARAMETRO_COMPRAS', 'PARAMETRO_NFS', 'PLS_PARAMETROS')
and	nm_INTEGRIDADE_REFERENCIAL in ('COMPARA_SERNOFI_FK', 'EMECONT_SERNOFI_FK', 'PARCOMP_SERNOFI_FK', 'PARANFS_SERNOFI_FK', 'PLSPAR_SERNOFI_FK');

delete 	from INTEGRIDADE_REFERENCIAL
where	nm_tabela in ('COM_PARAMETRO', 'EME_CONTRATO', 'PARAMETRO_COMPRAS', 'PARAMETRO_NFS', 'PLS_PARAMETROS')
and	nm_INTEGRIDADE_REFERENCIAL in ('COMPARA_SERNOFI_FK', 'EMECONT_SERNOFI_FK', 'PARCOMP_SERNOFI_FK', 'PARANFS_SERNOFI_FK', 'PLSPAR_SERNOFI_FK');



/*----------------Terceira parte------------------*/

/*Dropa a PK da SERIE_NOTA_FISCAL*/

ds_retorno_w := Executar_SQL_Dinamico(' DROP INDEX SERNOFI_PK', ds_retorno_w);
ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE SERIE_NOTA_FISCAL DROP CONSTRAINT SERNOFI_PK', ds_retorno_w);

delete	from INDICE_ATRIBUTO
where	nm_tabela = 'SERIE_NOTA_FISCAL'
and	nm_indice = 'SERNOFI_PK';

delete	from indice
where	nm_tabela = 'SERIE_NOTA_FISCAL'
and	nm_indice = 'SERNOFI_PK';


delete	from INTEGRIDADE_ATRIBUTO
where	nm_tabela = 'SERIE_NOTA_FISCAL'
and	nm_INTEGRIDADE_REFERENCIAL = 'SERNOFI_PK';

delete 	from INTEGRIDADE_REFERENCIAL
where	nm_tabela = 'SERIE_NOTA_FISCAL'
and	nm_INTEGRIDADE_REFERENCIAL = 'SERNOFI_PK';



/*----------------Quarta parte------------------*/

/*Cria a PK da SERIE_NOTA_FISCAL com o campo CD_ESTABELECIMENTO e insere no dicionario de dados*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE SERIE_NOTA_FISCAL ADD
			( CONSTRAINT SERNOFI_PK   Primary Key  (CD_SERIE_NF, CD_ESTABELECIMENTO)
			USING INDEX   Tablespace TASY_INDEX) ', ds_retorno_w);

insert	into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('SERIE_NOTA_FISCAL',
	'SERNOFI_PK',
	'PK',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('SERIE_NOTA_FISCAL', 'SERNOFI_PK', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('SERIE_NOTA_FISCAL', 'SERNOFI_PK', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');

ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX SERNOFI_PK ON SERIE_NOTA_FISCAL(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);




/*----------------Quinta parte------------------*/

/*Cria as integridades e os indices*/

/*Tabela COM_PARAMETRO*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE COM_PARAMETRO ADD
			(CONSTRAINT COMPARA_SERNOFI_FK FOREIGN KEY (
				CD_SERIE_NF,
				CD_ESTABELECIMENTO)
			REFERENCES SERIE_NOTA_FISCAL(
				CD_SERIE_NF,
				CD_ESTABELECIMENTO))', ds_retorno_w);

ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX COMPARA_SERNOFI_FK_I ON COM_PARAMETRO(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);



/*Tabela EME_CONTRATO*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE EME_CONTRATO ADD
			(CONSTRAINT EMECONT_SERNOFI_FK FOREIGN KEY (
				CD_SERIE_NF,
				CD_ESTABELECIMENTO)
			REFERENCES SERIE_NOTA_FISCAL(
				CD_SERIE_NF,
				CD_ESTABELECIMENTO))', ds_retorno_w);		/**/
ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX EMECONT_SERNOFI_FK_I ON EME_CONTRATO(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);



/*Tabela PARAMETRO_COMPRAS*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PARAMETRO_COMPRAS ADD
			(CONSTRAINT PARCOMP_SERNOFI_FK FOREIGN KEY (
				CD_SERIE_NF,
				CD_ESTABELECIMENTO)
			REFERENCES SERIE_NOTA_FISCAL(
				CD_SERIE_NF,
				CD_ESTABELECIMENTO))', ds_retorno_w);

ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX PARCOMP_SERNOFI_FK_I ON PARAMETRO_COMPRAS(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);



/*Tabela PARAMETRO_NFS*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PARAMETRO_NFS ADD
			(CONSTRAINT PARANFS_SERNOFI_FK FOREIGN KEY (
				CD_SERIE_NF,
				CD_ESTABELECIMENTO)
			REFERENCES SERIE_NOTA_FISCAL(
				CD_SERIE_NF,
				CD_ESTABELECIMENTO))', ds_retorno_w);		/**/
ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX PARANFS_SERNOFI_FK_I ON PARAMETRO_NFS(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);



/*Tabela PLS_PARAMETROS*/

ds_retorno_w := Executar_SQL_Dinamico(' ALTER TABLE PLS_PARAMETROS ADD
			(CONSTRAINT PLSPAR_SERNOFI_FK FOREIGN KEY (
				CD_SERIE_NF,
				CD_ESTABELECIMENTO)
			REFERENCES SERIE_NOTA_FISCAL(
				CD_SERIE_NF,
				CD_ESTABELECIMENTO))', ds_retorno_w);

ds_retorno_w := Executar_SQL_Dinamico(' CREATE INDEX PLSPAR_SERNOFI_FK_I ON PLS_PARAMETROS(CD_SERIE_NF,CD_ESTABELECIMENTO)', ds_retorno_w);




/*----------------Sexta parte------------------*/

/*Insere os indices no dicionario de dados*/

/*Tabela COM_PARAMETRO*/

insert	into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('COM_PARAMETRO',
	'COMPARA_SERNOFI_FK_I',
	'I',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('COM_PARAMETRO', 'COMPARA_SERNOFI_FK_I', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('COM_PARAMETRO', 'COMPARA_SERNOFI_FK_I', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');



/*Tabela EME_CONTRATO*/

insert into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('EME_CONTRATO',
	'EMECONT_SERNOFI_FK_I',
	'I',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('EME_CONTRATO', 'EMECONT_SERNOFI_FK_I', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('EME_CONTRATO', 'EMECONT_SERNOFI_FK_I', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');



/*Tabela PARAMETRO_COMPRAS*/

insert into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PARAMETRO_COMPRAS',
	'PARCOMP_SERNOFI_FK_I',
	'I',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PARAMETRO_COMPRAS', 'PARCOMP_SERNOFI_FK_I', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PARAMETRO_COMPRAS', 'PARCOMP_SERNOFI_FK_I', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');



/*Tabela PARAMETRO_NFS*/

insert into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PARAMETRO_NFS',
	'PARANFS_SERNOFI_FK_I',
	'I',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PARAMETRO_NFS', 'PARANFS_SERNOFI_FK_I', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PARAMETRO_NFS', 'PARANFS_SERNOFI_FK_I', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');



/*Tabela PLS_PARAMETROS*/

insert into INDICE(
	nm_tabela,
	nm_indice,
	ie_tipo,
	dt_atualizacao,
	nm_usuario,
	ds_indice,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PLS_PARAMETROS',
	'PLSPAR_SERNOFI_FK_I',
	'I',
	clock_timestamp(),
	'Tasy',
	'',
	'I',
	'A',
	clock_timestamp());


insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PLS_PARAMETROS', 'PLSPAR_SERNOFI_FK_I', 1, 'CD_SERIE_NF', clock_timestamp(), 'Tasy');

insert	into INDICE_ATRIBUTO(nm_tabela, nm_indice, nr_sequencia, nm_atributo, dt_atualizacao, nm_usuario)
values ('PLS_PARAMETROS', 'PLSPAR_SERNOFI_FK_I', 2, 'CD_ESTABELECIMENTO', clock_timestamp(), 'Tasy');



/*----------------Sétima parte------------------*/

/*Insere as integridades no dicionario de dados*/

/*Tabela COM_PARAMETRO*/

insert	into INTEGRIDADE_REFERENCIAL(
	nm_tabela,
	nm_integridade_referencial,
	nm_tabela_referencia,
	dt_atualizacao,
	nm_usuario,
	ie_regra_delecao,
	ds_integridade_referencial,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('COM_PARAMETRO',
	'COMPARA_SERNOFI_FK',
	'SERIE_NOTA_FISCAL',
	clock_timestamp(),
	'Tasy',
	'NO ACTION',
	'',
	'I',
	'A',
	clock_timestamp());

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('COM_PARAMETRO', 'COMPARA_SERNOFI_FK', 'CD_SERIE_NF', 1, clock_timestamp(), 'Tasy');

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('COM_PARAMETRO', 'COMPARA_SERNOFI_FK', 'CD_ESTABELECIMENTO', 2, clock_timestamp(), 'Tasy');



/*Tabela EME_CONTRATO*/

insert	into INTEGRIDADE_REFERENCIAL(
	nm_tabela,
	nm_integridade_referencial,
	nm_tabela_referencia,
	dt_atualizacao,
	nm_usuario,
	ie_regra_delecao,
	ds_integridade_referencial,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('EME_CONTRATO',
	'EMECONT_SERNOFI_FK',
	'SERIE_NOTA_FISCAL',
	clock_timestamp(),
	'Tasy',
	'NO ACTION',
	'',
	'I',
	'A',
	clock_timestamp());

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('EME_CONTRATO', 'EMECONT_SERNOFI_FK', 'CD_SERIE_NF', 1, clock_timestamp(), 'Tasy');

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('EME_CONTRATO', 'EMECONT_SERNOFI_FK', 'CD_ESTABELECIMENTO', 2, clock_timestamp(), 'Tasy');



/*Tabela PARAMETRO_COMPRAS*/

insert	into INTEGRIDADE_REFERENCIAL(
	nm_tabela,
	nm_integridade_referencial,
	nm_tabela_referencia,
	dt_atualizacao,
	nm_usuario,
	ie_regra_delecao,
	ds_integridade_referencial,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PARAMETRO_COMPRAS',
	'PARCOMP_SERNOFI_FK',
	'SERIE_NOTA_FISCAL',
	clock_timestamp(),
	'Tasy',
	'NO ACTION',
	'',
	'I',
	'A',
	clock_timestamp());

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PARAMETRO_COMPRAS', 'PARCOMP_SERNOFI_FK', 'CD_SERIE_NF', 1, clock_timestamp(), 'Tasy');

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PARAMETRO_COMPRAS', 'PARCOMP_SERNOFI_FK', 'CD_ESTABELECIMENTO', 2, clock_timestamp(), 'Tasy');



/*Tabela PARAMETRO_NFS*/

insert	into INTEGRIDADE_REFERENCIAL(
	nm_tabela,
	nm_integridade_referencial,
	nm_tabela_referencia,
	dt_atualizacao,
	nm_usuario,
	ie_regra_delecao,
	ds_integridade_referencial,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PARAMETRO_NFS',
	'PARANFS_SERNOFI_FK',
	'SERIE_NOTA_FISCAL',
	clock_timestamp(),
	'Tasy',
	'NO ACTION',
	'',
	'I',
	'A',
	clock_timestamp());

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PARAMETRO_NFS', 'PARANFS_SERNOFI_FK', 'CD_SERIE_NF', 1, clock_timestamp(), 'Tasy');

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PARAMETRO_NFS', 'PARANFS_SERNOFI_FK', 'CD_ESTABELECIMENTO', 2, clock_timestamp(), 'Tasy');



/*Tabela PLS_PARAMETROS*/

insert	into INTEGRIDADE_REFERENCIAL(
	nm_tabela,
	nm_integridade_referencial,
	nm_tabela_referencia,
	dt_atualizacao,
	nm_usuario,
	ie_regra_delecao,
	ds_integridade_referencial,
	ie_criar_alterar,
	ie_situacao,
	dt_criacao)
values ('PLS_PARAMETROS',
	'PLSPAR_SERNOFI_FK',
	'SERIE_NOTA_FISCAL',
	clock_timestamp(),
	'Tasy',
	'NO ACTION',
	'',
	'I',
	'A',
	clock_timestamp());

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PLS_PARAMETROS', 'PLSPAR_SERNOFI_FK', 'CD_SERIE_NF', 1, clock_timestamp(), 'Tasy');

insert into INTEGRIDADE_ATRIBUTO(
	nm_tabela, nm_integridade_referencial, nm_atributo, ie_sequencia_criacao, dt_atualizacao, nm_usuario)
values ('PLS_PARAMETROS', 'PLSPAR_SERNOFI_FK', 'CD_ESTABELECIMENTO', 2, clock_timestamp(), 'Tasy');


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_pk_serie_nf () FROM PUBLIC;
