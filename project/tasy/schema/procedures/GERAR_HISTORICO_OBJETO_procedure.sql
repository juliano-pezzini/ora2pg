-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_historico_objeto ( nr_seq_objeto_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	objeto_sistema_hist.nr_sequencia%type;


BEGIN

select	nextval('objeto_sistema_hist_seq')
into STRICT	nr_sequencia_w
;

insert into objeto_sistema_hist(
	nr_sequencia,
	nm_objeto,
	dt_atualizacao,
	nm_usuario,
	ds_script_criacao,
	ie_banco,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_ordem_servico,
	nr_build,
	nr_build_exec_tasy,
	dt_versao)
SELECT	nr_sequencia_w,
	nm_objeto,
	clock_timestamp(),
	nm_usuario_p,
	null,
	'Oracle',
	clock_timestamp(),
	nm_usuario_p,
	nr_ordem_servico,
	0,
	0,
	null
from	objeto_sistema
where	nr_sequencia = nr_seq_objeto_p;

commit;

CALL copia_campo_long_de_para(	'OBJETO_SISTEMA',	'DS_SCRIPT_CRIACAO','where nr_sequencia = :NR_SEQUENCIA','NR_SEQUENCIA='||to_char(nr_seq_objeto_p),
				'OBJETO_SISTEMA_HIST',	'DS_SCRIPT_CRIACAO','where nr_sequencia = :NR_SEQUENCIA','NR_SEQUENCIA='||to_char(nr_sequencia_w));



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_historico_objeto ( nr_seq_objeto_p bigint, nm_usuario_p text) FROM PUBLIC;

