-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adep_consistir_inicio_sol ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, ie_fator_consiste_p text, ie_sol_ant_pend_p INOUT text) AS $body$
DECLARE


dt_inicio_prescr_w			timestamp;
ie_solucao_pendente_w		varchar(1) := 'N';
nr_seq_ficha_tecnica_w		medic_ficha_tecnica.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	d.nr_seq_ficha_tecnica
	from	material d,
			prescr_material c,
			prescr_medica a
	where	a.nr_prescricao		= nr_prescricao_p
	and	a.nr_prescricao		= c.nr_prescricao
	and	c.nr_sequencia_solucao	= nr_seq_solucao_p
	and	d.cd_material		= c.cd_material
	and	(d.nr_seq_ficha_tecnica IS NOT NULL AND d.nr_seq_ficha_tecnica::text <> '');


BEGIN
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then

	select	max(dt_inicio_prescr)
	into STRICT	dt_inicio_prescr_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p;

	if (ie_fator_consiste_p = 'P') then
		if (ie_tipo_solucao_p = 1) then
			select	coalesce(max('S'),'N')
			into STRICT	ie_solucao_pendente_w
			from	prescr_solucao b,
					prescr_medica a
			where	b.nr_prescricao		= a.nr_prescricao
			and	coalesce(b.ie_hemodialise,'N')	= 'N'
			and	b.ie_status		not in ('N','T','S')
			and	a.nr_atendimento		= nr_atendimento_p
			and	a.nr_prescricao		<> nr_prescricao_p
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	a.dt_validade_prescr	<= dt_inicio_prescr_w
			and	coalesce(a.ie_adep,'S')		= 'S';
		end if;

	elsif (ie_fator_consiste_p = 'FT') then
		open c01;
		loop
		fetch c01 into
			nr_seq_ficha_tecnica_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			select	coalesce(max('S'),'N')
			into STRICT	ie_solucao_pendente_w
			from	material d,
					prescr_solucao b,
					prescr_material c,
					prescr_medica a where	b.nr_prescricao		= a.nr_prescricao
			and	coalesce(b.ie_hemodialise,'N')	= 'N'
			and	b.ie_status		not in ('N','T','S')
			and	a.nr_atendimento	= nr_atendimento_p
			and	c.nr_prescricao		= b.nr_prescricao
			and	c.nr_sequencia_solucao	= b.nr_seq_solucao
			and	d.cd_material		= c.cd_material
			and	a.nr_prescricao		<> nr_prescricao_p
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and	coalesce(a.dt_suspensao::text, '') = ''
			and	coalesce(a.ie_adep,'S')	= 'S'
			and	d.nr_seq_ficha_tecnica	= nr_seq_ficha_tecnica_w LIMIT 1;

			if (ie_solucao_pendente_w = 'S') then
				Exit;
			end if;
			end;
		end loop;
		close c01;
	end if;

end if;

ie_sol_ant_pend_p := ie_solucao_pendente_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_consistir_inicio_sol ( nr_atendimento_p bigint, nr_prescricao_p bigint, nr_seq_solucao_p bigint, ie_tipo_solucao_p bigint, ie_fator_consiste_p text, ie_sol_ant_pend_p INOUT text) FROM PUBLIC;
