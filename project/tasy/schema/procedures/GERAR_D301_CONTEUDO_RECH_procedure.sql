-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_conteudo_rech ( nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_segmento_w		varchar(32767);
ds_segmento_clob_w  	text := '';

/*gerar e armazenar o conteúdo (com separadores) deste dataset no campo ds_conteudo da tabela d301_dataset_conteudo*/

c01 CURSOR FOR
SELECT ('ENT+'||cd_cobranca||'+'||
	vl_cobranca||'+'||
	ds_dt_inicio_cobranca||'+'||
	ds_dt_fim_cobranca||'+'||
	qt_dias_calculo||'+'||
	qt_dias_fora_calculo||'+'||
	ds_dt_cura||chr(39)) ds_segmento
into STRICT  	ds_segmento_w
from 	d301_segmento_ent
where  	nr_seq_dataset  = nr_seq_dataset_p;

c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT ('FAB+'||
	obter_descricao_padrao('C301_6_DEPARTAMENTO','CD_DEPARTAMENTO',nr_seq_301_depart)||chr(39)) ds_segmento
into STRICT  	ds_segmento_w
from 	d301_segmento_fab
where  	nr_seq_dataset  = nr_seq_dataset_p;

c02_w	c02%rowtype;


BEGIN

begin
  --cabecalho
select  'UNH+'||
	lpad(nr_ref_segmento,5,'0')||'+'||
	ie_dataset||':'||
	ie_versao_dataset||':'||
	nr_release_dataset||':'||
	nr_versao_organiz||chr(39)
into STRICT  	ds_segmento_w
from  	d301_segmento_unh
where 	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w,ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

/*  select  'FKT+'||
    nr_seq_301_ident_processo||'+'||
    nr_transacao||'+'||
    nr_ik_origem||'+'||
    nr_ik_destino||chr(39)
  into  ds_segmento_w
  from  d301_segmento_fkt
  where  nr_seq_dataset  = nr_seq_dataset_p;*/
ds_segmento_w  := OBTER_CONTEUDO_SEG_FKT_301( nr_seq_dataset_p, ds_segmento_w );

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

begin
select	'INV+'||
	cd_usuario_convenio||'+'||
	obter_descricao_padrao('C301_12_STATUS_SEGURADO','IE_STATUS',nr_seq_301_status_segurado)||'+'||
	obter_descricao_padrao('C301_12_DOENCA_CRONICA','IE_DOENCA',nr_seq_301_doenca_cronica)||'+'||
	obter_descricao_padrao('C301_12_GRUPO_PESSOA','IE_GRUPO',nr_seq_301_grupo_pessoa)||'+'||
	ds_mesano_validade_cart||'+'||
	nr_interno_segurado||'+'||
	nr_episodio_convenio||'+'||
	nr_arquivo_convenio||'+'||
	ds_dt_inicio_cobert_conv||'+'||
	nr_contrato_conv||chr(39)
into STRICT  	ds_segmento_w
from  	d301_segmento_inv
where  	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  ds_segmento_clob_w
;

begin
select  'NAD+'||
	nm_sobrenome||'+'||
	ds_nome||'+'||
	obter_descricao_padrao('C301_21_SEXO','IE_SEXO',nr_seq_301_sexo)||'+'||
	ds_dt_nascimento||'+'||
	ds_rua_numero||'+'||
	cd_postal||'+'||
	ds_cidade||'+'||
	ds_titulacao||'+'||
	obter_descricao_padrao('C301_7_PAIS','IE_PAIS',nr_seq_301_pais)||'+'||
	ds_sufixo_nome||'+'||
	ds_prefixo_sobrenome||'+'||
	ds_compl_endereco||chr(39)
into STRICT  	ds_segmento_w
from  	d301_segmento_nad
where  	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

begin
select 'CUX+'||
	NR_SEQ_301_MOEDA||chr(39)
into STRICT  	ds_segmento_w
from 	d301_segmento_cux
where  	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

begin
select 'REC+'||nr_ident_conta||'+'||
	ds_dt_conta||'+'||
	nr_seq_301_indic_cobr||'+'||
	nr_seq_301_indic_cobr_ped||'+'||
	ds_dt_admissao||'+'||
	vl_cobranca_conta||'+'||
	nr_conta_banc_hosp||'+'||
	nr_referencia_hosp||'+'||
	nr_ik_cobranca||chr(39)
into STRICT  	ds_segmento_w
from 	d301_segmento_rec
where  	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  ds_segmento_clob_w
;

begin
	select 'ZLG+'||
		VL_COPARTICIPACAO||'+'||
		NR_SEQ_301_INDIC_PAG||chr(39)
	into STRICT  	ds_segmento_w
	from 	d301_segmento_zlg
	where  	nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

--Segmento FAB
open C02;
loop
fetch C02 into
	c02_w;
EXIT WHEN NOT FOUND; /* apply on C02 */

	select	concat(ds_segmento_clob_w, c02_w.ds_segmento)
	into STRICT  	ds_segmento_clob_w
	;

end loop;
close C02;

/*select 	'FAB+'||
	nr_seq_301_depart||chr(39)
into  	ds_segmento_w
from 	d301_segmento_fab
where  	nr_seq_dataset  = nr_seq_dataset_p;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into  	ds_segmento_clob_w
from  	dual;*/
--Segmento ETL
open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	concat(ds_segmento_clob_w, c01_w.ds_segmento)
	into STRICT  	ds_segmento_clob_w
	;

end loop;
close C01;

/*  MOvi para o cursor este select
select 'ENT+'||cd_cobranca||'+'||
          vl_cobranca||'+'||
          ds_dt_inicio_cobranca||'+'||
          ds_dt_fim_cobranca||'+'||
          qt_dias_calculo||'+'||
          qt_dias_fora_calculo||'+'||
          ds_dt_cura||chr(39)
  into  ds_segmento_w
  from d301_segmento_ent
  where  nr_seq_dataset  = nr_seq_dataset_p;*/
  --rodape
begin
select  'UNT+'||
	qt_segmento||'+'||
	lpad(nr_ref_segmento,5,'0')||chr(39)
into STRICT  	ds_segmento_w
from  	d301_segmento_unt
where  nr_seq_dataset  = nr_seq_dataset_p;
exception
when others then
	ds_segmento_w := null;
end;

select  concat(ds_segmento_clob_w, ds_segmento_w)
into STRICT  	ds_segmento_clob_w
;

CALL inserir_d301_dataset_conteudo(nm_usuario_p, nr_seq_dataset_p, ds_segmento_clob_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_conteudo_rech ( nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

