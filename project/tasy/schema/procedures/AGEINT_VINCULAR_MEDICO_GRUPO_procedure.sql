-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_vincular_medico_grupo (nr_seq_agenda_medico_p bigint, nr_seq_medico_regra_p bigint, cd_agenda_p bigint, cd_medico_p text, nm_usuario_p text) AS $body$
DECLARE

hr_inicial_w		ageint_medico_regra.hr_inicial%type;
hr_final_w		ageint_medico_regra.hr_final%type;

BEGIN

update	agenda_medico
set	nr_seq_medico_regra = nr_seq_medico_regra_p,
	nm_usuario = nm_usuario_p,
	dt_atualizacao = clock_timestamp()
where	nr_sequencia = nr_seq_agenda_medico_p;


delete from ageint_turno_medico
where	cd_pessoa_fisica = cd_medico_p
and	coalesce(nr_seq_medico_regra::text, '') = ''
and (cd_agenda = cd_agenda_p or coalesce(cd_agenda::text, '') = '')
and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento or coalesce(cd_estabelecimento::text, '') = '');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_vincular_medico_grupo (nr_seq_agenda_medico_p bigint, nr_seq_medico_regra_p bigint, cd_agenda_p bigint, cd_medico_p text, nm_usuario_p text) FROM PUBLIC;
