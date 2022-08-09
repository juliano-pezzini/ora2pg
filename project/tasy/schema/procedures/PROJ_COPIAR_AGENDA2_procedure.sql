-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_copiar_agenda2 ( nr_seq_agenda_origem_p bigint, nr_seq_agenda_selecionada_p text, nm_usuario_p text ) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Objective: Copy the schedule into other selected schedules.
-------------------------------------------------------------------------------------------------------------------
Call: [  ]  Dictionary objects [ X ] Tasy (Delphi/Java/HTML) [  ] Portal [  ]  Reports [ ] Others:
 ------------------------------------------------------------------------------------------------------------------
Attencion points: 
-------------------------------------------------------------------------------------------------------------------
Referencies: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_permite_altera_obs_w varchar(1);

c00 CURSOR FOR
	SELECT	*
	from	proj_agenda pa
	where	pa.nr_sequencia = nr_seq_agenda_origem_p;

c01 CURSOR FOR
	SELECT	pa.nr_sequencia
	from	proj_agenda pa
	where	pa.nr_sequencia in (WITH RECURSIVE cte AS (

						SELECT	regexp_substr(nr_seq_agenda_selecionada_p,'[^,]+', 1, level)
						
						connect	by (regexp_substr(nr_seq_agenda_selecionada_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_agenda_selecionada_p, '[^,]+', 1, level))::text <> '')
					  UNION ALL

						SELECT	regexp_substr(nr_seq_agenda_selecionada_p,'[^,]+', 1, level)
						
						connect	by (regexp_substr(nr_seq_agenda_selecionada_p, '[^,]+', 1, level) IS NOT NULL AND (regexp_substr(nr_seq_agenda_selecionada_p, '[^,]+', 1, level))::text <> '')
					 JOIN cte c ON ()

) SELECT * FROM cte;
);
BEGIN

ie_permite_altera_obs_w := Obter_Param_Usuario(993, 144, wheb_usuario_pck.get_cd_perfil, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_altera_obs_w);

if (phi_is_base_philips = 'S') then
	begin
	
		for	reg00 in c00 loop
		begin
			for reg01 in c01 loop
			begin
			
				update	proj_agenda
				set	nr_seq_motivo		= reg00.nr_seq_motivo,
					nr_seq_cliente		= reg00.nr_seq_cliente,
					nr_seq_proj		= reg00.nr_seq_proj,
					nr_seq_canal		= reg00.nr_seq_canal,
					nm_usuario		= nm_usuario_p,
					ie_status		= reg00.ie_status,
					ie_dia_todo		= reg00.ie_dia_todo,
					ie_agenda_prevista	= reg00.ie_agenda_prevista,
					dt_atualizacao		= clock_timestamp(),
					ds_obs_escritorio	= reg00.ds_obs_escritorio,
					ds_observacao		= CASE WHEN ie_permite_altera_obs_w='S' THEN reg00.ds_observacao  ELSE coalesce(ds_observacao, reg00.ds_observacao) END ,
					ds_nome_curto_cliente	= reg00.ds_nome_curto_cliente,
					cd_hora_inic		= reg00.cd_hora_inic,
					cd_hora_fim		= reg00.cd_hora_fim
				where	nr_sequencia	= reg01.nr_sequencia;
			end;
			end loop;
		end;
		end loop;
		commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_copiar_agenda2 ( nr_seq_agenda_origem_p bigint, nr_seq_agenda_selecionada_p text, nm_usuario_p text ) FROM PUBLIC;
