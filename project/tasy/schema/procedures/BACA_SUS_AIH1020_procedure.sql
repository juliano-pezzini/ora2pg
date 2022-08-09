-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_sus_aih1020 () AS $body$
DECLARE


qt_erro_w			smallint;
nr_sequencia_w		bigint;


BEGIN

/* incluir Tipo de Servico 21 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (807, '21', 'Analgesia Obstétrica Pessoa Física ', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;


/* incluir Tipo de Servico 22 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (807, '22', 'Analgesia Obstétrica Pessoa Jurídica', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;

/* incluir Tipo de Servico 23 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (807, '23', 'Pediatra 1a Consulta Pessoa Fisica', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;


/* incluir Tipo de Servico 24 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (807, '24', 'Pediatra 1a Consulta Pessoa Jurídica', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;


/* incluir Tipo de Ato 35 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (808, '35', 'Analgesia Obstétrica', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;

/* incluir Tipo de Ato 36 */

begin
insert into valor_dominio(CD_DOMINIO, VL_DOMINIO, DS_VALOR_DOMINIO, DT_ATUALIZACAO,NM_USUARIO, IE_SITUACAO)
values (808, '36', 'Pediatra Primeira Consulta', clock_timestamp() ,'Tasy','A');
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;


/* incluir Sus_Proced_tipo_Ato */

select nextval('sus_proced_tipo_ato_seq')
into STRICT nr_sequencia_w
;
begin
insert into Sus_Proced_tipo_Ato(NR_SEQUENCIA, CD_PROCEDIMENTO, IE_ORIGEM_PROCED, DT_ATUALIZACAO,
	NM_USUARIO, IE_TIPO_SERVICO_SUS, IE_TIPO_ATO_SUS)
values (nr_sequencia_w, 95004017, 2, clock_timestamp() , 'Tasy', 23, 36);
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;

/* incluir Sus_Proced_tipo_Ato */

select nextval('sus_proced_tipo_ato_seq')
into STRICT nr_sequencia_w
;
begin
insert into Sus_Proced_tipo_Ato(NR_SEQUENCIA, CD_PROCEDIMENTO, IE_ORIGEM_PROCED, DT_ATUALIZACAO,
	NM_USUARIO, IE_TIPO_SERVICO_SUS, IE_TIPO_ATO_SUS)
values (nr_sequencia_w, 95003010, 2, clock_timestamp() , 'Tasy', 21, 35);
exception
	when others then
	     	qt_erro_w  := qt_erro_w + 1;
end;



COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_sus_aih1020 () FROM PUBLIC;
