-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nom_rc_sintomatologia (nr_seq_cabecalho_p bigint, nm_usuario_p text) AS $body$
DECLARE



/* SintomatologA­a del paciente */

ds_sintomatologia_w		nom_rc_sintomatologia.ds_sintomatologia%type	:= null;
nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;
									

BEGIN
delete from nom_rc_sintomatologia
where nr_seq_cabecalho = nr_seq_cabecalho_p;

select	a.nr_atendimento,
		a.nr_seq_episodio
into STRICT	nr_atendimento_w,
		nr_seq_episodio_w
from	nom_rc_cabecalho a
where	a.nr_sequencia	= nr_seq_cabecalho_p;

select	max(a.ds_sintoma_paciente)
into STRICT	ds_sintomatologia_w
from 	atendimento_paciente a
where 	a.nr_atendimento in (SELECT	x.nr_atendimento
								from	nom_rc_cabecalho x
								where	x.nr_sequencia = nr_seq_cabecalho_p
								and		(x.nr_atendimento IS NOT NULL AND x.nr_atendimento::text <> '')
								
union

								SELECT	y.nr_atendimento
								from	atendimento_paciente y,
								nom_rc_cabecalho x
								where	x.nr_seq_episodio = y.nr_seq_episodio
								and		x.nr_sequencia = nr_seq_cabecalho_p);

if (ds_sintomatologia_w IS NOT NULL AND ds_sintomatologia_w::text <> '') then

	insert into nom_rc_sintomatologia(nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		ds_sintomatologia,
		nr_seq_cabecalho)
	values (nextval('nom_rc_sintomatologia_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ds_sintomatologia_w,
		nr_seq_cabecalho_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nom_rc_sintomatologia (nr_seq_cabecalho_p bigint, nm_usuario_p text) FROM PUBLIC;

