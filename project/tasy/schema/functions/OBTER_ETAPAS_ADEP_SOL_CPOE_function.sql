-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_etapas_adep_sol_cpoe ( ie_tipo_solucao_p bigint, nr_seq_cpoe_p cpoe_material.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


nr_etapas_w						smallint := 0;
ie_alteracao_w					prescr_solucao_evento.ie_alteracao%type;
ie_alteracao_aux_w				prescr_solucao_evento.ie_alteracao%type;
nr_seq_motivo_w					prescr_solucao_evento.nr_seq_motivo%type;
nr_sequencia_w					prescr_solucao_evento.nr_sequencia%type;
nr_seq_aux_w					prescr_solucao_evento.nr_sequencia%type;
ie_etapa_w						varchar(1);
ie_inst_sol_sem_interromp_w		varchar(1);
nr_atendimento_w				prescr_solucao_evento.nr_atendimento%type;

c01 CURSOR FOR
SELECT	ie_alteracao,
	nr_seq_motivo,
	nr_sequencia,
	nr_atendimento
from	prescr_solucao_evento
where	coalesce(ie_evento_valido,'S') = 'S'
and	((ie_alteracao in (1,2,35)) or
		(ie_inst_sol_sem_interromp_w = 'N' AND ie_alteracao = 35))
and	ie_tipo_solucao = ie_tipo_solucao_p
and	nr_seq_cpoe	= nr_seq_cpoe_p;


BEGIN
if (ie_tipo_solucao_p IS NOT NULL AND ie_tipo_solucao_p::text <> '') and (nr_seq_cpoe_p IS NOT NULL AND nr_seq_cpoe_p::text <> '') then

	ie_inst_sol_sem_interromp_w := Obter_Param_Usuario(1113, 518, Obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_inst_sol_sem_interromp_w);

	if (ie_tipo_solucao_p = 1) then
		open C01;
		loop
		fetch C01 into
			ie_alteracao_w,
			nr_seq_motivo_w,
			nr_sequencia_w,
			nr_atendimento_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			ie_etapa_w	:= 'S';
			if (ie_alteracao_w	= 2) and (coalesce(obter_se_motivo_troca_frasco(nr_seq_motivo_w),'N') <> 'S') then
				ie_etapa_w	:= 'N';
			elsif (ie_alteracao_w = 35) then
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_seq_aux_w
				from	prescr_solucao_evento
				where	coalesce(ie_evento_valido,'S') = 'S'
				and		ie_tipo_solucao	= ie_tipo_solucao_p
				and		nr_sequencia	< nr_sequencia_w
				and		nr_atendimento = nr_atendimento_w
				and		nr_seq_cpoe	= nr_seq_cpoe_p;

				select	coalesce(max(ie_alteracao),0)
				into STRICT	ie_alteracao_aux_w
				from	prescr_solucao_evento
				where	((ie_alteracao	<> 2) or (obter_se_motivo_troca_frasco(nr_seq_motivo) = 'S'))
				and		nr_sequencia	= nr_seq_aux_w;

				if (ie_alteracao_aux_w	in (2, 37)) then
					ie_etapa_w	:= 'N';
				else
					select	coalesce(min(nr_sequencia),0)
					into STRICT	nr_seq_aux_w
					from	prescr_solucao_evento
					where	coalesce(ie_evento_valido,'S') = 'S'
					and		ie_tipo_solucao	= ie_tipo_solucao_p
					and		nr_seq_cpoe	= nr_seq_cpoe_p
					and		nr_atendimento = nr_atendimento_w
					and		nr_sequencia	> nr_sequencia_w;

					select	coalesce(max(ie_alteracao),0)
					into STRICT	ie_alteracao_aux_w
					from	prescr_solucao_evento
					where	((ie_alteracao	<> 2) or (obter_se_motivo_troca_frasco(nr_seq_motivo) = 'S'))
					and		nr_sequencia	= nr_seq_aux_w;

					if (ie_alteracao_aux_w	= 1) then
						ie_etapa_w	:= 'N';

					else

						select	coalesce(max(nr_sequencia),0)
						into STRICT	nr_seq_aux_w
						from	prescr_solucao_evento
						where	coalesce(ie_evento_valido,'S') = 'S'
						and		ie_tipo_solucao	= ie_tipo_solucao_p
						and		nr_seq_cpoe	= nr_seq_cpoe_p
						and		nr_sequencia	< nr_sequencia_w
						and		nr_atendimento = nr_atendimento_w
						and		cd_funcao 		= 88;

						select	coalesce(max(ie_alteracao),0)
						into STRICT	ie_alteracao_aux_w
						from	prescr_solucao_evento
						where	nr_sequencia	= nr_seq_aux_w;

						if (ie_alteracao_aux_w	= 1) then
							ie_etapa_w	:= 'N';
						end if;

					end if;

				end if;

			end if;

			if (ie_etapa_w	= 'S') then
				nr_etapas_w	:= nr_etapas_w + 1;
			end if;

			end;
		end loop;
		close C01;
	end if;
end if;

return nr_etapas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_etapas_adep_sol_cpoe ( ie_tipo_solucao_p bigint, nr_seq_cpoe_p cpoe_material.nr_sequencia%type) FROM PUBLIC;
