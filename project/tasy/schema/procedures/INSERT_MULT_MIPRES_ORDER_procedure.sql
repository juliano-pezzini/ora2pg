-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_mult_mipres_order ( ds_lista_p text, nr_seq_agenda_p bigint, nr_seq_mipres_p controle_mipres_agenda.nr_prescr_mipres%type, dt_validity_mipres_p controle_mipres_agenda.dt_validity%type, nm_usuario_p text, cd_agenda_p agenda.cd_agenda%type default null, nm_tabela_p text default null) AS $body$
DECLARE


ds_lista_w					lista_varchar_pck.tabela_varchar;
nr_pos_virgula_w			bigint;
nr_sequencia_w				varchar(20);
nr_seq_mipres_old_w			controle_mipres_agenda.nr_prescr_mipres%type;
dt_validade_mipres_old_w	controle_mipres_agenda.dt_validity%type;

BEGIN

	if ((nr_seq_mipres_p IS NOT NULL AND nr_seq_mipres_p::text <> '')
		and (dt_validity_mipres_p IS NOT NULL AND dt_validity_mipres_p::text <> '')
		and (nr_seq_agenda_p IS NOT NULL AND nr_seq_agenda_p::text <> '')
		and (ds_lista_p IS NOT NULL AND ds_lista_p::text <> '')) then

		ds_lista_w	:= obter_lista_string2(ds_lista_p,',');

		FOR i IN ds_lista_w.FIRST..ds_lista_w.LAST LOOP
			nr_sequencia_w := ds_lista_w(i);

				if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '')then

					select	max(nr_prescr_mipres),
							max(dt_validity)
					into STRICT	nr_seq_mipres_old_w,
							dt_validade_mipres_old_w
					from	controle_mipres_agenda cma
					where 	cma.nr_sequencia in (SELECT	max(acp.nr_seq_controle_mipres)
												 from 	agenda_consulta_proc acp
												 where 	acp.nr_sequencia = nr_sequencia_w);

					CALL insert_controle_mipres_age(nr_seq_agenda_p,
												nr_sequencia_w,
												nr_seq_mipres_p,
												dt_validity_mipres_p,
												nr_seq_mipres_old_w,
												dt_validade_mipres_old_w,
												nm_usuario_p,
												cd_agenda_p,
												nm_tabela_p);
				end if;

		end loop;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_mult_mipres_order ( ds_lista_p text, nr_seq_agenda_p bigint, nr_seq_mipres_p controle_mipres_agenda.nr_prescr_mipres%type, dt_validity_mipres_p controle_mipres_agenda.dt_validity%type, nm_usuario_p text, cd_agenda_p agenda.cd_agenda%type default null, nm_tabela_p text default null) FROM PUBLIC;

