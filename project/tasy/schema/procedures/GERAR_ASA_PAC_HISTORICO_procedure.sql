-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_asa_pac_historico (cd_pessoa_fisica_p bigint, ds_asa_p text, nr_seq_agenda_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_sequencia_w		bigint;
ds_historico_w		varchar(4000);

BEGIN
 
 
ds_historico_w	:= wheb_mensagem_pck.get_texto(300461, 'DT_SYSDATE=' || to_char(clock_timestamp(),'dd/mm/yyyy') || 
					';NM_USUARIO_P=' || substr(OBTER_PESSOA_FISICA_USUARIO(nm_usuario_p, ''), 1, 255) || 
					';DS_ASA_P=' || ds_asa_p || ';CD_PESSOA_FISICA_P=' || substr(obter_nome_pf(cd_pessoa_fisica_p),1,255));
 
select	nextval('agenda_pac_hist_seq') 
into STRICT	nr_sequencia_w
;
 
insert into agenda_pac_hist(nr_sequencia, 
	nr_seq_agenda, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_setor_atend_usuario, 
	dt_historico, 
	cd_pessoa_fisica, 
	nr_seq_tipo, 
	ds_historico) 
values (nr_sequencia_w, 
	nr_seq_agenda_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	null, 
	clock_timestamp(), 
	substr(OBTER_PESSOA_FISICA_USUARIO(nm_usuario_p,'C'),1,255), 
	null, 
	ds_historico_w);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_asa_pac_historico (cd_pessoa_fisica_p bigint, ds_asa_p text, nr_seq_agenda_p bigint, nm_usuario_p text) FROM PUBLIC;

