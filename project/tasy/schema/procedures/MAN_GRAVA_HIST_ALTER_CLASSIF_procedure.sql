-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_grava_hist_alter_classif ( nr_seq_ordem_p bigint, ie_classificacao_p text, ie_classif_antiga_p text, ds_justificativa_p text, nm_usuario_p text) AS $body$
DECLARE



ds_justificativa_w		varchar(2000);
ds_classificacao_w		varchar(255);
ds_classif_antiga_w		varchar(255);
nr_seq_localizacao_w		man_localizacao.nr_sequencia%type;
cd_cnpj_w			man_localizacao.cd_cnpj%type;
nr_seq_idioma_w			pessoa_juridica.nr_seq_idioma%type;


BEGIN
begin
nr_seq_idioma_w	:= man_obter_idioma_os_local(nr_seq_ordem_p);
exception
when others then
	nr_seq_idioma_w	:= null;
end;

select	substr(obter_valor_dominio_idioma(1149,ie_classificacao_p,nr_seq_idioma_w),1,255),
	substr(obter_valor_dominio_idioma(1149,ie_classif_antiga_p,nr_seq_idioma_w),1,255)
into STRICT	ds_classificacao_w,
	ds_classif_antiga_w
;

ds_justificativa_w	:= substr(obter_texto_dic_objeto(338098, nr_seq_idioma_w, 'CLASSIFICACAO_ANTIGA='|| ds_classif_antiga_w
																						|| ';CLASSIFICACAO_NOVA=' || ds_classificacao_w 
																						|| ';JUSTIFICATIVA=' || ds_justificativa_p),1,255);

insert into man_ordem_serv_tecnico(	nr_sequencia,
		nr_seq_ordem_serv,
		dt_atualizacao,
		nm_usuario,
		ds_relat_tecnico,
		dt_historico,
		dt_liberacao,
		nm_usuario_lib,
		nr_seq_tipo,
		ie_origem)
values (	nextval('man_ordem_serv_tecnico_seq'),
		nr_seq_ordem_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_justificativa_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		148,
		'I');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_grava_hist_alter_classif ( nr_seq_ordem_p bigint, ie_classificacao_p text, ie_classif_antiga_p text, ds_justificativa_p text, nm_usuario_p text) FROM PUBLIC;
