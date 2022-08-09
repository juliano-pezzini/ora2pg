-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nom_rc_prognostico (nr_seq_cabecalho_p bigint, nm_usuario_p text) AS $body$
DECLARE



/* Impresión diagnóstica */

ds_prognostico_w		nom_rc_prognostico.ds_prognostico%type	:= null;
ds_problema_w			varchar(32000);

nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
nr_seq_episodio_w			episodio_paciente.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

c_problema CURSOR FOR
	SELECT	b.ds_prognostico ds_prognostico
	from    lista_problema_pac a,
			lista_problema_pac_prog b
	where 	a.nr_sequencia = b.nr_seq_problema
	and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and		coalesce(a.dt_inativacao::text, '') = ''
	and		a.nr_atendimento in (SELECT		x.nr_atendimento
							from	nom_rc_cabecalho x
							where	x.nr_sequencia = nr_seq_cabecalho_p
							and		(x.nr_atendimento IS NOT NULL AND x.nr_atendimento::text <> '')
							
union

							select	y.nr_atendimento
							from	atendimento_paciente y,
									nom_rc_cabecalho x
							where	x.nr_seq_episodio = y.nr_seq_episodio
							and		x.nr_sequencia = nr_seq_cabecalho_p);
									
BEGIN
delete from nom_rc_prognostico
where nr_seq_cabecalho = nr_seq_cabecalho_p;

select	a.nr_atendimento,
		a.nr_seq_episodio
into STRICT	nr_atendimento_w,
		nr_seq_episodio_w
from	nom_rc_cabecalho a
where	a.nr_sequencia	= nr_seq_cabecalho_p;


if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	null;
elsif (nr_seq_episodio_w IS NOT NULL AND nr_seq_episodio_w::text <> '') then
	select	min(nr_atendimento)
	into STRICT	nr_atendimento_w
	from	atendimento_paciente a
	where	a.nr_seq_episodio = nr_seq_episodio_w;
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	for r_c_problema in c_problema loop
		if (coalesce(ds_problema_w::text, '') = '') then
			ds_problema_w	:= substr(r_c_problema.ds_prognostico,1,32000);
		else
			ds_problema_w	:= substr(ds_problema_w || chr(13) || chr(10) || r_c_problema.ds_prognostico,1,32000);
		end if;
	end loop;
	
	ds_prognostico_w	:= ds_problema_w;

	if (ds_prognostico_w IS NOT NULL AND ds_prognostico_w::text <> '') then
		insert into nom_rc_prognostico(nr_sequencia,
			nm_usuario,
			dt_atualizacao,
			nm_usuario_nrec,
			dt_atualizacao_nrec,
			ds_prognostico,
			nr_seq_cabecalho)
		values (nextval('nom_rc_prognostico_seq'),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			ds_prognostico_w,
			nr_seq_cabecalho_p);
	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nom_rc_prognostico (nr_seq_cabecalho_p bigint, nm_usuario_p text) FROM PUBLIC;
