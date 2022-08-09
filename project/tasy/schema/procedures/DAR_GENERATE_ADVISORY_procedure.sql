-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dar_generate_advisory () AS $body$
DECLARE


c01 CURSOR FOR

SELECT
		c.nr_sequencia,
        p.nr_atendimento,
        p.cd_estabelecimento,
        p.ie_clinica,
		p.nm_usuario,
		p.nm_usuario_nrec
from atendimento_paciente p
inner join dar_census c on c.nr_atendimento = p.nr_atendimento;

c01_w	c01%rowtype;


BEGIN

open c01;
loop
fetch c01 into c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
		insert into dar_advisory(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_atendimento,
			cd_estab_atend,
			nr_seq_census,
			ie_clinica
			)
		values (
		nextval('dar_advisory_seq'),
		clock_timestamp(),
		c01_w.nm_usuario,
		clock_timestamp(),
		c01_w.nm_usuario_nrec,
		c01_w.nr_atendimento,
		c01_w.cd_estabelecimento,
		c01_w.nr_sequencia,
		c01_w.ie_clinica
		);
		
	end;
	
end loop;

close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dar_generate_advisory () FROM PUBLIC;
