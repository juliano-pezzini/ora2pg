-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_importa_atestado_tasymed ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_export_p text, nr_atendimento_p bigint default null, nr_seq_pepa_p bigint default null, nr_seq_cliente_p bigint default null) AS $body$
DECLARE


c01 CURSOR FOR
	SELECT	a.cd_medico,
			a.cd_pessoa_fisica,
			b.dt_atestado,
			b.dt_atualizacao,
			b.dt_atualizacao_nrec,
			b.nm_usuario,
			b.nm_usuario_nrec,
			b.nr_sequencia
	from med_cliente a, med_atestado b
	where a.nr_sequencia = b.nr_seq_cliente
	and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and	a.cd_medico = cd_profissional_p
	and  a.nr_sequencia = nr_seq_cliente_p
	and coalesce(b.ie_exportado,'N') = 'N'
	and (coalesce(nr_atendimento_p::text, '') = '' or b.nr_atendimento =  nr_atendimento_p or coalesce(b.nr_atendimento::text, '') = '')
	order by dt_atualizacao;

c01_w c01%rowtype;

nr_sequencia_w atestado_paciente.nr_sequencia%type;



BEGIN

if (coalesce(nr_atendimento_p::text, '') = '' or (nr_seq_pepa_p IS NOT NULL AND nr_seq_pepa_p::text <> '')) then

open C01;
loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

			begin
				select	nextval('atestado_paciente_seq')
				into STRICT	nr_sequencia_w
				;

				insert into atestado_paciente(
					nr_sequencia,
					cd_medico,
					cd_pessoa_fisica,
					dt_atestado,
					dt_atualizacao,
					dt_atualizacao_nrec,
					dt_liberacao,
					ie_nivel_atencao,
					nm_usuario,
					nm_usuario_nrec,
					ie_situacao,
					nr_seq_atend_cons_pepa
					) values (
					nr_sequencia_w,
					c01_w.cd_medico,
					c01_w.cd_pessoa_fisica,
					c01_w.dt_atestado,
					c01_w.dt_atualizacao,
					c01_w.dt_atualizacao_nrec,
					c01_w.dt_atualizacao,
					'S',
					c01_w.nm_usuario,
					c01_w.nm_usuario_nrec,
					'A',
					nr_seq_pepa_p);


					CALL copia_campo_long_de_para_novo(
						'MED_ATESTADO',
						'DS_ATESTADO',
						' where nr_sequencia = :nr_sequencia ',
						'nr_sequencia='||c01_w.nr_sequencia,
						'ATESTADO_PACIENTE',
						'DS_ATESTADO',
						' where nr_sequencia = :nr_sequencia ',
						'nr_sequencia='||nr_sequencia_w,
						'L');

					update med_atestado
						set ie_exportado = 'S',
							dt_exportacao = clock_timestamp(),
							nm_usuario_exportacao = nm_usuario_export_p
					where nr_sequencia = c01_w.nr_sequencia;
					commit;

				exception when others then
					rollback;
				end;

		end;

end loop;
close C01;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_importa_atestado_tasymed ( cd_pessoa_fisica_p text, cd_profissional_p text, nm_usuario_export_p text, nr_atendimento_p bigint default null, nr_seq_pepa_p bigint default null, nr_seq_cliente_p bigint default null) FROM PUBLIC;
