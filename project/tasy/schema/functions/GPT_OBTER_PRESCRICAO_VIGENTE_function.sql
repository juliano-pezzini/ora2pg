-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gpt_obter_prescricao_vigente as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION gpt_obter_prescricao_vigente ( nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM gpt_obter_prescricao_vigente_atx ( ' || quote_nullable(nr_sequencia_p) || ',' || quote_nullable(ie_tipo_item_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION gpt_obter_prescricao_vigente_atx ( nr_sequencia_p bigint, ie_tipo_item_p text) RETURNS bigint AS $body$
DECLARE


nr_prescricao_w		prescr_medica.nr_prescricao%type;
BEGIN

	if (ie_tipo_item_p = 'D') then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_dieta a,
				prescr_medica b,
				cpoe_dieta c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_dieta_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_dieta a
			where	a.nr_seq_dieta_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p in ('SNE','S')) then
		
		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_material a,
				prescr_medica b,
				cpoe_dieta c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_dieta_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_material a
			where	a.nr_seq_dieta_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p = 'LD') then
	
		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_leite_deriv a,
				prescr_medica b,
				cpoe_dieta c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_dieta_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_leite_deriv a
			where	a.nr_seq_dieta_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p = 'J') then
	
		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	rep_jejum a,
				prescr_medica b,
				cpoe_dieta c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_dieta_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	rep_jejum a
			where	a.nr_seq_dieta_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p in ('M', 'SOL', 'MAT', 'IA')) then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_material a,
				prescr_medica b,
				cpoe_material c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_mat_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_material a
			where	a.nr_seq_mat_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p in ('P','HM','AP')) then

		if (ie_tipo_item_p = 'P') then

			select	max(b.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_procedimento a,
					prescr_medica b,
					cpoe_procedimento c
			where	a.nr_prescricao = b.nr_prescricao
			and		a.nr_seq_proc_cpoe = c.nr_sequencia
			and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
			and		c.nr_sequencia = nr_sequencia_p;
		
		elsif (ie_tipo_item_p = 'HM') then
		
			select	max(b.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_procedimento a,
					prescr_medica b,
					cpoe_hemoterapia c
			where	a.nr_prescricao = b.nr_prescricao
			and		a.nr_seq_proc_cpoe = c.nr_sequencia
			and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
			and		c.nr_sequencia = nr_sequencia_p;

		elsif (ie_tipo_item_p = 'AP') then

			select	max(b.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_procedimento a,
					prescr_medica b,
					cpoe_anatomia_patologica c
			where	a.nr_prescricao = b.nr_prescricao
			and		a.nr_seq_proc_cpoe = c.nr_sequencia
			and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
			and		c.nr_sequencia = nr_sequencia_p;

		end if;

		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_procedimento a
			where	a.nr_seq_proc_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p = 'O') then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_gasoterapia a,
				prescr_medica b,
				cpoe_gasoterapia c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_gas_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;

		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_gasoterapia a
			where	a.nr_seq_gas_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p = 'R') then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_recomendacao a,
				prescr_medica b,
				cpoe_recomendacao c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_rec_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;
		
		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_recomendacao a
			where	a.nr_seq_rec_cpoe = nr_sequencia_p;	
		end if;

	elsif (ie_tipo_item_p in ('NPTA','NPTI')) then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	nut_pac a,
				prescr_medica b,
				cpoe_dieta c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_npt_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;

		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(nr_prescricao)
			into STRICT	nr_prescricao_w
			from	nut_pac b
			where	b.nr_seq_npt_cpoe = nr_sequencia_p;
		end if;

	elsif (ie_tipo_item_p in ('DI','DP')) then

		select	max(b.nr_prescricao)
		into STRICT	nr_prescricao_w
		from	prescr_solucao a,
				prescr_medica b,
				cpoe_dialise c
		where	a.nr_prescricao = b.nr_prescricao
		and		a.nr_seq_dialise_cpoe = c.nr_sequencia
		and		c.dt_inicio between b.dt_inicio_prescr and b.dt_validade_prescr
		and		c.nr_sequencia = nr_sequencia_p;

		if (coalesce(nr_prescricao_w::text, '') = '') then
			select	max(a.nr_prescricao)
			into STRICT	nr_prescricao_w
			from	prescr_solucao a
			where	a.nr_seq_dialise_cpoe = nr_sequencia_p;
		end if;
		
	end if;

return nr_prescricao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_prescricao_vigente ( nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION gpt_obter_prescricao_vigente_atx ( nr_sequencia_p bigint, ie_tipo_item_p text) FROM PUBLIC;
