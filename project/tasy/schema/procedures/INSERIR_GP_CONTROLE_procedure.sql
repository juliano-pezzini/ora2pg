-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_gp_controle ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_hora_w	bigint;


BEGIN

select	qt_horas_alerta
into STRICT	qt_hora_w
from	tipo_perda_ganho
where	nr_sequencia	= nr_sequencia_p;

insert into ATEND_PERDA_GANHO_CONTROLE(	nr_sequencia,
						nr_atendimento,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						ie_controla,
						nr_seq_tipo,
						qt_horas_alerta)
			values (	nextval('atend_perda_ganho_controle_seq'),
						nr_atendimento_p,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						'S',
						nr_sequencia_p,
						qt_hora_w);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_gp_controle ( nr_atendimento_p bigint, nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
