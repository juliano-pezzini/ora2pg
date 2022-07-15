-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_ie_horario_susp ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p bigint, nm_tabela_p text) AS $body$
DECLARE


ie_hor_susp_w		char(1);

procedure update_prescr_material(nr_seq_material_p prescr_material.nr_sequencia%type) is
  r_c00_w RECORD;

BEGIN
	select	coalesce(max('S'),'N')
	into STRICT	ie_hor_susp_w
	FROM prescr_mat_hor a
LEFT OUTER JOIN prescr_mat_hor_compl b ON (a.nr_seq_mat_compl = b.nr_sequencia) WHERE a.nr_prescricao	= nr_prescricao_p and a.nr_seq_material	= nr_seq_material_p and (a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') and coalesce(b.ie_susp_duplicidade,'N') <> 'S'  LIMIT 1;

	update	prescr_material
	set		ie_horario_susp	= ie_hor_susp_w
	where	nr_prescricao	= nr_prescricao_p
	and		nr_sequencia	= nr_seq_material_p;	
end;

procedure update_prescr_procedimento(nr_seq_procedimento_p prescr_procedimento.nr_sequencia%type) is
begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_hor_susp_w
	from	prescr_proc_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_procedimento	= nr_seq_procedimento_p
	and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') LIMIT 1;

	update	prescr_procedimento
	set		ie_horario_susp		= ie_hor_susp_w
	where	nr_prescricao		= nr_prescricao_p
	and		nr_sequencia		= nr_seq_procedimento_p;
end;

procedure update_prescr_dieta(nr_seq_dieta_p prescr_dieta.nr_sequencia%type) is
begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_hor_susp_w
	from	prescr_dieta_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_dieta		= nr_seq_dieta_p
	and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') LIMIT 1;

	update	prescr_dieta
	set		ie_horario_susp		= ie_hor_susp_w
	where	nr_prescricao		= nr_prescricao_p
	and		nr_sequencia		= nr_seq_dieta_p;
end;

procedure update_prescr_recomendacao(nr_seq_recomendacao_p prescr_recomendacao.nr_sequencia%type) is
begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_hor_susp_w
	from	prescr_rec_hor where		nr_prescricao		= nr_prescricao_p
	and		nr_seq_recomendacao	= nr_seq_recomendacao_p
	and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') LIMIT 1;

	update	prescr_recomendacao
	set		ie_horario_susp		= ie_hor_susp_w
	where	nr_prescricao		= nr_prescricao_p
	and		nr_sequencia		= nr_seq_recomendacao_p;
end;

procedure update_prescr_solucao(nr_seq_solucao_p prescr_solucao.nr_seq_solucao%type) is
begin
	select	coalesce(max('S'),'N')
	into STRICT	ie_hor_susp_w
	from	prescr_mat_hor where		nr_prescricao	= nr_prescricao_p
	and		nr_seq_solucao	= nr_seq_solucao_p
	and		(dt_suspensao IS NOT NULL AND dt_suspensao::text <> '') LIMIT 1;

	update	prescr_solucao
	set		ie_horario_susp	= ie_hor_susp_w,
			ie_suspenso 	= ie_hor_susp_w
	where	nr_prescricao	= nr_prescricao_p
	and		nr_seq_solucao	= nr_seq_solucao_p;

	update	prescr_material
	set		ie_horario_susp	= ie_hor_susp_w,
			ie_suspenso 	= ie_hor_susp_w
	where	nr_prescricao	= nr_prescricao_p
	and		nr_sequencia_solucao = nr_seq_solucao_p;
end;

begin

if (coalesce(nr_prescricao_p,0) > 0) then

	if (nm_tabela_p	= 'PRESCR_MATERIAL') or (coalesce(nm_tabela_p::text, '') = '') then

		if (coalesce(nr_sequencia_p, 0) > 0) then
			update_prescr_material(nr_sequencia_p);
		else
			for r_c00_w in (
				SELECT	nr_sequencia
				from    prescr_material
				where	nr_prescricao = nr_prescricao_p			
			)
			loop
				update_prescr_material(r_c00_w.nr_sequencia);
			end loop;
		end if;
		
	end if;

	if (nm_tabela_p	= 'PRESCR_PROCEDIMENTO') or (coalesce(nm_tabela_p::text, '') = '') then

		if (coalesce(nr_sequencia_p, 0) > 0) then
			update_prescr_procedimento(nr_sequencia_p);
		else
			for r_c00_w in (
				SELECT	nr_sequencia
				from    prescr_procedimento
				where	nr_prescricao = nr_prescricao_p			
			)
			loop
				update_prescr_procedimento(r_c00_w.nr_sequencia);
			end loop;
		end if;

	end if;

	if (nm_tabela_p	= 'PRESCR_DIETA') or (coalesce(nm_tabela_p::text, '') = '') then

		if (coalesce(nr_sequencia_p, 0) > 0) then
			update_prescr_dieta(nr_sequencia_p);
		else
			for r_c00_w in (
				SELECT	nr_sequencia
				from    prescr_dieta
				where	nr_prescricao = nr_prescricao_p			
			)
			loop
				update_prescr_dieta(r_c00_w.nr_sequencia);
			end loop;
		end if;

	end if;

	if (nm_tabela_p	= 'PRESCR_RECOMENDACAO') or (coalesce(nm_tabela_p::text, '') = '') then

		if (coalesce(nr_sequencia_p, 0) > 0) then
			update_prescr_recomendacao(nr_sequencia_p);
		else
			for r_c00_w in (
				SELECT	nr_sequencia
				from    prescr_dieta
				where	nr_prescricao = nr_prescricao_p			
			)
			loop
				update_prescr_recomendacao(r_c00_w.nr_sequencia);
			end loop;
		end if;

	end if;

	if (nm_tabela_p	= 'PRESCR_SOLUCAO') or (coalesce(nm_tabela_p::text, '') = '') then

		if (coalesce(nr_sequencia_p, 0) > 0) then
			update_prescr_solucao(nr_sequencia_p);
		else
			for r_c00_w in (
				SELECT	nr_sequencia
				from    prescr_dieta
				where	nr_prescricao = nr_prescricao_p			
			)
			loop
				update_prescr_solucao(r_c00_w.nr_sequencia);
			end loop;
		end if;

	end if;

	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_ie_horario_susp ( nr_prescricao_p prescr_medica.nr_prescricao%type, nr_sequencia_p bigint, nm_tabela_p text) FROM PUBLIC;

