-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_reuniao ( nr_seq_reuniao_p bigint, nr_seq_classif_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text, dt_reuniao_p timestamp, nr_seq_nova_reuniao_p INOUT bigint) AS $body$
DECLARE


nr_seq_reuniao_w	bigint;
cd_estabelecimento_w	bigint;
ds_assunto_w		varchar(500);
ds_observacao_w		varchar(4000);
cd_pessoa_responsavel_w	varchar(10);
nr_seq_ordem_serv_w	bigint;


BEGIN

select	nextval('ata_reuniao_seq')
into STRICT	nr_seq_reuniao_w
;


select	cd_estabelecimento,
	ds_assunto,
	ds_observacao,
	cd_pessoa_responsavel,
	nr_seq_ordem_serv
into STRICT	cd_estabelecimento_w,
	ds_assunto_w,
	ds_observacao_w,
	cd_pessoa_responsavel_w,
	nr_seq_ordem_serv_w
from	ata_reuniao
where	nr_sequencia = nr_seq_reuniao_p;


insert into ata_reuniao(nr_sequencia,
			 dt_reuniao,
			 cd_estabelecimento,
			 ds_assunto,
			 dt_atualizacao,
			 nm_usuario,
			 dt_atualizacao_nrec,
			 nm_usuario_nrec,
			 ds_observacao,
			 cd_pessoa_responsavel,
			 nr_seq_classif_reuniao,
			 nr_seq_ordem_serv,
			 nr_seq_tipo_reuniao)
values (nr_seq_reuniao_w,
			 dt_reuniao_p,
			 cd_estabelecimento_w,
			 ds_assunto_w,
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 ds_observacao_w,
			 cd_pessoa_responsavel_w,
			 nr_seq_classif_p,
			 nr_seq_ordem_serv_w,
			 nr_seq_tipo_p);

insert into ata_participante(nr_sequencia,
			      nr_seq_reuniao,
			      ie_faltou,
			      nm_pessoa_participante,
			      ds_Setor,
			      dt_atualizacao,
			      nm_usuario,
			      dt_atualizacao_nrec,
			      nm_usuario_nrec,
			      cd_setor_atendimento,
			      cd_pessoa_participante,
			      dt_ciente_ata)
			      (SELECT
				nextval('ata_participante_seq'),
				nr_seq_reuniao_w,
				'N',
				nm_pessoa_participante,
				ds_Setor,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				cd_setor_atendimento,
				cd_pessoa_participante,
				dt_ciente_ata
			      from ata_participante
			      where nr_seq_reuniao = nr_seq_reuniao_p);

insert into ata_reuniao_pauta(nr_sequencia,
				 dt_atualizacao,
				 nm_usuario,
				 dt_atualizacao_nrec,
				 nm_usuario_nrec,
				 nr_seq_reuniao,
				 ds_pauta,
				 ds_conteudo,
				 cd_pessoa_resp)
				(SELECT
				  nextval('ata_reuniao_pauta_seq'),
				  clock_timestamp(),
				  nm_usuario_p,
				  clock_timestamp(),
				  nm_usuario_p,
				  nr_seq_reuniao_w,
				  ds_pauta,
				  ds_conteudo,
				  cd_pessoa_resp
				from ata_reuniao_pauta
				where nr_seq_reuniao = nr_seq_reuniao_p);

nr_seq_nova_reuniao_p := nr_seq_reuniao_w;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_reuniao ( nr_seq_reuniao_p bigint, nr_seq_classif_p bigint, nr_seq_tipo_p bigint, nm_usuario_p text, dt_reuniao_p timestamp, nr_seq_nova_reuniao_p INOUT bigint) FROM PUBLIC;
