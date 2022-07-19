-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ptu_imp_camara ( ds_conteudo_p text, nm_usuario_p text) AS $body$
DECLARE

/*601*/

nr_seq_camara_w			bigint;
dt_camara_w			timestamp;
dt_geracao_w			timestamp;
cd_unimed_origem_w		smallint;
cd_unimed_destino_w		smallint;
ie_tipo_camara_w		smallint;
nr_versao_transacao_w		smallint;

/*602*/

cd_unimed_credora_w		smallint;
cd_unimed_devedora_w		smallint;
nr_fatura_w			bigint;
ie_tipo_fatura_w		smallint;
vl_total_fatura_w		double precision;


BEGIN
if (substr(ds_conteudo_p,9,3) = '601') then
	select	nextval('ptu_camara_compensacao_seq')
	into STRICT	nr_seq_camara_w
	;

	cd_unimed_origem_w	:= (substr(ds_conteudo_p,16,4))::numeric;
	cd_unimed_destino_w	:= (substr(ds_conteudo_p,12,4))::numeric;
	dt_geracao_w		:= to_date(substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4),'dd/mm/yyyy');
	dt_camara_w		:= to_date(substr(ds_conteudo_p,34,2)||substr(ds_conteudo_p,32,2)||substr(ds_conteudo_p,28,4),'dd/mm/yyyy');
	ie_tipo_camara_w	:= (substr(ds_conteudo_p,36,1))::numeric;
	nr_versao_transacao_w	:= (substr(ds_conteudo_p,37,2))::numeric;

	insert into ptu_camara_compensacao(nr_sequencia, cd_unimed_destino, cd_unimed_origem,
		dt_geracao, dt_camara, ie_tipo_camara,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
		nm_usuario_nrec, nr_versao_transacao)
	values (nr_seq_camara_w, cd_unimed_origem_w, cd_unimed_destino_w,
		dt_geracao_w, dt_camara_w, ie_tipo_camara_w,
		clock_timestamp(), nm_usuario_p, clock_timestamp(),
		nm_usuario_p, nr_versao_transacao_w);
end if;

if (substr(ds_conteudo_p,9,3) = '602') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_camara_w
	from	ptu_camara_compensacao;

	cd_unimed_credora_w	:= (substr(ds_conteudo_p,12,4))::numeric;
	cd_unimed_devedora_w	:= (substr(ds_conteudo_p,16,4))::numeric;
	nr_fatura_w		:= (substr(ds_conteudo_p,20,11))::numeric;
	ie_tipo_fatura_w	:= (substr(ds_conteudo_p,31,1))::numeric;
	vl_total_fatura_w	:= (substr(ds_conteudo_p,32,14))::numeric;

	insert into ptu_camara_fatura(nr_sequencia, nr_seq_camara, cd_unimed_credora,
		cd_unimed_devedora, nr_fatura, ie_tipo_fatura,
		vl_total_fatura, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec)
	values (nextval('ptu_camara_fatura_seq'), nr_seq_camara_w, cd_unimed_credora_w,
		cd_unimed_devedora_w, nr_fatura_w, ie_tipo_fatura_w,
		vl_total_fatura_w, clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p);

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ptu_imp_camara ( ds_conteudo_p text, nm_usuario_p text) FROM PUBLIC;

