-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lab_retira_integracao_lote ( nr_seq_lote_p text, cd_equipamento_p text, nm_usuario_p text) AS $body$
DECLARE



C01 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia,
			a.nr_seq_exame
	from	prescr_procedimento a,
			lab_lote_exame_item b
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_sequencia 	= b.nr_seq_prescr
	and		(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and		(a.dt_integracao IS NOT NULL AND a.dt_integracao::text <> '')
	and		((coalesce(cd_equipamento_p::text, '') = '') or ((Obter_Equipamento_Exame(a.nr_seq_exame, cd_equipamento_p,'CI') IS NOT NULL AND (Obter_Equipamento_Exame(a.nr_seq_exame, cd_equipamento_p,'CI'))::text <> '')))
	and		b.nr_seq_lote 	= nr_seq_lote_p
	order by 1,2;

c01_w	C01%rowtype;


C02 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia nr_seq_prescr,
			a.nr_seq_exame,
			c.nr_sequencia
	from	prescr_procedimento a,
			lab_lote_exame_item b,
			prescr_proc_mat_item c
	where	a.nr_prescricao = b.nr_prescricao
	and		a.nr_sequencia 	= b.nr_seq_prescr
	and		a.nr_prescricao = c.nr_prescricao
	and		a.nr_sequencia 	= c.nr_seq_prescr
	and 	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and		(c.dt_integracao IS NOT NULL AND c.dt_integracao::text <> '')
	and		((coalesce(cd_equipamento_p::text, '') = '') or ((Obter_Equipamento_Exame(a.nr_seq_exame, cd_equipamento_p,'CI') IS NOT NULL AND (Obter_Equipamento_Exame(a.nr_seq_exame, cd_equipamento_p,'CI'))::text <> '')))
	and		b.nr_seq_lote 	= nr_seq_lote_p
	order by 1,2;

c02_w	C02%rowtype;


ie_exame_amostra_w		lab_parametro.ie_exame_amostra%type;



BEGIN

select 	coalesce(MAX(a.ie_exame_amostra),'N')
into STRICT	ie_exame_amostra_w
from	lab_parametro a,
		prescr_medica b,
		prescr_procedimento c,
		lab_lote_exame_item d
where   a.cd_estabelecimento = b.cd_estabelecimento
and		b.nr_prescricao = c.nr_prescricao
and		c.nr_prescricao = d.nr_prescricao
and		c.nr_sequencia  = d.nr_seq_prescr
and		d.nr_seq_lote = nr_seq_lote_p;

if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		update prescr_procedimento
		set dt_integracao  = NULL,
			dt_atualizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p
		where nr_prescricao = c01_w.nr_prescricao
		and	  nr_sequencia  = c01_w.nr_sequencia;

		commit;

		end;
	end loop;
	close C01;

	if (ie_exame_amostra_w = 'S') then
		open C02;
		loop
		fetch C02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			update 	prescr_proc_mat_item
			set	dt_integracao  = NULL,
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where	nr_sequencia = c02_w.nr_sequencia;

			update prescr_procedimento
			set dt_integracao  = NULL,
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where nr_prescricao = c02_w.nr_prescricao
			and	  nr_sequencia  = c02_w.nr_seq_prescr;

			commit;

			end;
		end loop;
		close C02;

	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lab_retira_integracao_lote ( nr_seq_lote_p text, cd_equipamento_p text, nm_usuario_p text) FROM PUBLIC;

