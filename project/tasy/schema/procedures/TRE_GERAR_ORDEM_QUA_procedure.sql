-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tre_gerar_ordem_qua (cd_pessoa_solicitante_p text, ds_dano_breve_p text, ds_dano_p text, nr_seq_criterio_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;


BEGIN

select	nextval('man_ordem_servico_seq')
into STRICT	nr_sequencia_w
;

insert into man_ordem_servico(nr_sequencia,
				cd_pessoa_solicitante,
				dt_ordem_servico,
				ie_prioridade,
				ie_parado,
				ds_dano_breve,
				dt_atualizacao,
				nm_usuario,
				ds_dano,
				ie_tipo_ordem)
values (nr_sequencia_w,
				cd_pessoa_solicitante_p,
				clock_timestamp(),
				'M',
				'N',
				ds_dano_breve_p,
				clock_timestamp(),
				nm_usuario_p,
				ds_dano_p,
				13);

update 	QMS_TREIN_CLASSIF_CRIT
set	NR_SEQ_ORDEM = 	nr_sequencia_w
where 	nr_sequencia = 	nr_seq_criterio_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tre_gerar_ordem_qua (cd_pessoa_solicitante_p text, ds_dano_breve_p text, ds_dano_p text, nr_seq_criterio_p text, nm_usuario_p text) FROM PUBLIC;
