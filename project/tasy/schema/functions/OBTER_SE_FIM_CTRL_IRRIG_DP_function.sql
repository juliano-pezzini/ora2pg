-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_fim_ctrl_irrig_dp (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_encerrar_w		varchar(1) := 'N';
nr_etapas_w		bigint;
nr_etapas_adep_w	bigint;
nr_seq_dialise_w	prescr_solucao.nr_seq_dialise%type;
ie_gera_ciclo_w		varchar(1);
nr_etapas_total_w   bigint;
nr_etapas_iniciadas_w prescr_mat_hor.nr_etapa_sol%type;
nr_etapas_realizadas_w bigint;


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (nr_seq_solucao_p IS NOT NULL AND nr_seq_solucao_p::text <> '') then
    begin
		select	nr_etapas,
			obter_etapas_adep_dp(nr_prescricao,nr_seq_solucao, nm_usuario_p, cd_perfil_p) nr_etapas_adep,
			coalesce(nr_seq_dialise,0)
		into STRICT	nr_etapas_w,
			nr_etapas_adep_w,
			nr_seq_dialise_w
		from	prescr_solucao
		where	nr_prescricao	= nr_prescricao_p
		and	nr_seq_solucao	= nr_seq_solucao_p;
	
		--Caso for dialise obtem o nr. de etapas de outra forma
		if (nr_seq_dialise_w > 0) then
	
			ie_gera_ciclo_w := obter_param_usuario(1113, 465, cd_perfil_p, nm_usuario_p, obter_estabelecimento_ativo, ie_gera_ciclo_w);
	
			if (ie_gera_ciclo_w <> 'I') then
				select	coalesce(obter_etapa_sol_dialise(nr_prescricao,nr_seq_solucao),0),
					substr(obter_etapa_atual_HM(nr_prescricao, nr_seq_solucao),1,10)
				into STRICT	nr_etapas_w,
					nr_etapas_adep_w
				from	prescr_solucao
				where	nr_prescricao = nr_prescricao_p
				and	nr_seq_solucao = nr_seq_solucao_p;
			else
                select  count(nr_sequencia)
                into STRICT    nr_etapas_w
                from    hd_prescricao_evento
                where   nr_prescricao = nr_prescricao_p
                and	    nr_seq_solucao = nr_seq_solucao_p
                and     coalesce(ie_evento_valido, 'S') <> 'N'
                and	    ie_evento = 'DT';

                select  substr(obter_etapa_sol_dialise(nr_prescricao, nr_seq_solucao),1,10),
                        CASE WHEN nr_etapas_w=0 THEN  coalesce(obter_etapa_atual_di(nr_prescricao,nr_seq_solucao), 0)  ELSE nr_etapas_w END 
                into STRICT	nr_etapas_adep_w,
                        nr_etapas_w
                from    prescr_solucao
                where   nr_prescricao = nr_prescricao_p
                and	    nr_seq_solucao = nr_seq_solucao_p;

                select  coalesce(max(a.nr_etapa_sol),0)
                into STRICT    nr_etapas_iniciadas_w
                from    prescr_mat_hor a
                where   a.nr_seq_solucao = nr_seq_solucao_p
                and     a.nr_prescricao = nr_prescricao_p
                and     (a.dt_inicio_horario IS NOT NULL AND a.dt_inicio_horario::text <> '')
                and     a.ie_agrupador = 13
                and     obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

                if (nr_etapas_iniciadas_w = 0) then
                    select  count(1)
                    into STRICT    nr_etapas_total_w
                    from (  SELECT  distinct a.nr_etapa_sol
                            from    prescr_mat_hor a
                            where   nr_prescricao = nr_prescricao_p
                            and     nr_seq_solucao = nr_seq_solucao_p
                            and	    obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S') alias3;


                    select  count(1)
                    into STRICT    nr_etapas_realizadas_w
                    from (  SELECT  distinct a.nr_etapa_sol
                            from    prescr_mat_hor a
                            where   a.nr_prescricao = nr_prescricao_p
                            and     a.nr_seq_solucao = nr_seq_solucao_p
                            and ((a.dt_suspensao IS NOT NULL AND a.dt_suspensao::text <> '') or (a.dt_fim_horario IS NOT NULL AND a.dt_fim_horario::text <> ''))
                            and     obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S') alias5;
                end if;
			end if;
	
		end if;
	
		if	((nr_etapas_iniciadas_w = 0 and nr_etapas_realizadas_w = nr_etapas_total_w) or (nr_etapas_iniciadas_w <> 0 and nr_etapas_w = nr_etapas_adep_w)) then
			ie_encerrar_w := 'S';
		else
			ie_encerrar_w := 'N';
		end if;
	exception
		when others then
		ie_encerrar_w := 'N';
	end;
end if;

return ie_encerrar_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_fim_ctrl_irrig_dp (nr_prescricao_p bigint, nr_seq_solucao_p bigint, nm_usuario_p text, cd_perfil_p bigint) FROM PUBLIC;

