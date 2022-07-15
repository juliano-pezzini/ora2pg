-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_prescricao_enfemagem ( nr_sequencia_p bigint, nm_usuario_p text) is ie_gerar_equipe_proc_w varchar(1) RETURNS boolean AS $body$
DECLARE


	qt_regra_w	varchar(15);

	
BEGIN
	select	count(*)
	into STRICT	qt_regra_w
	from 	pe_regra_item_escala
	where	ie_escala = ie_escala_p;

	if (qt_regra_w > 0) then
		return true;
	else
		return false;
	end if;
	end;

	function obter_se_existe_regra_sf_ii(nr_sequencia_sae	number) return boolean is

	qt_regra_w	              varchar2(15);
	escala_score_flex_ii_w	  number;

  -- Verifica se existe regra cadastrada pra essa(s) escala(s)
  FC01 CURSOR FOR
    SELECT i.ie_score_flex_ii as escala_score_flex, count(*) as qtd
    from
        pe_prescricao a,
        pe_prescr_item_result b,
        pe_regra_item_escala i
    where	a.nr_sequencia	= nr_sequencia_sae
      and a.nr_sequencia	= b.nr_seq_prescr
      and	b.nr_seq_item	= i.nr_seq_item_sae
      group by i.ie_score_flex_ii;

      fc01_w			            FC01%rowtype;
      flag                    boolean := false;
	begin

      --there may be more than one flex flex score scale, then the loop
      open FC01;
      loop
      fetch FC01 into	
        fc01_w;
      EXIT WHEN NOT FOUND; /* apply on FC01 */
        begin
            if (coalesce(fc01_w.qtd::text, '') = '' or fc01_w.qtd <= 0) then
              flag := false;
              return flag;
            else
              flag := true;
            end if;
        end;
      end loop;
      close FC01;

      return flag;
	end;

begin

ie_gerar_equipe_proc_w := obter_param_usuario(924, 498, Obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_gerar_equipe_proc_w);

select	coalesce(max(ie_rep_cpoe),'N')
into STRICT	ie_rep_cpoe_w
from	parametro_medico
where	cd_estabelecimento	= obter_estabelecimento_ativo;

update	pe_prescricao
set	dt_liberacao = clock_timestamp()
where	nr_sequencia = nr_sequencia_p;

CALL cp_release_care_plan(nr_sequencia_p,nm_usuario_p);

select	max(nr_atendimento),
        max(ie_tipo),
        max(cd_pessoa_fisica)
into STRICT	nr_atendimento_w,
        ie_tipo_w,
        cd_pessoa_fisica_w
from	pe_prescricao
where	nr_sequencia = nr_sequencia_p;

CALL gerar_prescr_sae_hor(nr_sequencia_p, nm_usuario_p); /* Rafael em 06/02/2007 = ADEP */
if (obter_parametro_funcao_padrao(281, 1512, nm_usuario_p) = 'S') then
	CALL adep_checagem_automatica(nr_sequencia_p, nm_usuario_p, obter_perfil_ativo);
end if;

if (ie_gerar_equipe_proc_w = 'S') THEN
	CALL gerar_sp_prescr_proc(null, nr_sequencia_p, nm_usuario_p);
end if;	


begin
	CALL GERAR_EV_LEMBRETE_INTEV(nr_sequencia_p,nm_usuario_p);
exception
when others then
	null;
end;


update 	pe_prescr_proc
set 	ie_confirmada = 'S'
where 	nr_seq_prescr = nr_sequencia_p;

select	count(*)
into STRICT	qt_reg_w
from 	REGRA_LANC_AUTOMATICO
where	NR_SEQ_EVENTO = 532;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')then
	open C01;
	loop
	fetch C01 into	
		nr_seq_prescr_proc_w,
		nr_seq_proc_w,
		nr_seq_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (qt_reg_w	> 0) then
			CALL gerar_lancamento_automatico(nr_atendimento_w,null,532,nm_usuario_p,nr_seq_prescr_proc_w,nr_seq_proc_w,null,null,null,null);
		end if;	

		CALL gerar_evento_interv_sae(nr_atendimento_w,nm_usuario_p,nr_seq_proc_w);

		if (ie_rep_cpoe_w = 'S') then
			CALL cpoe_gerar_registro_sae(nr_seq_prescr_proc_w,nr_atendimento_w,nm_usuario_p,nr_seq_prescr_w);
		end if;

		end;
	end loop;
	close C01;
end if;	

begin
CALL gerar_braden_sae(nr_sequencia_p,nm_usuario_p);
CALL gerar_morse_sae(nr_sequencia_p,nm_usuario_p);
CALL gerar_fugulin_sae(nr_sequencia_p,nm_usuario_p);
CALL gerar_scoreFlex_sae(nr_sequencia_p,nm_usuario_p);

if (obter_se_existe_regra(173)) then
	begin
	CALL gerar_frat_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;	
if (obter_se_existe_regra(79)) then
	begin
	CALL gerar_katz_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;	
if (obter_se_existe_regra(67)) then
	begin
	CALL gerar_bradenq_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;	
if (obter_se_existe_regra(105)) then
	begin
	CALL gerar_toxidade_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;	
if (obter_se_existe_regra(12)) then
	begin
	CALL gerar_tiss28_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra(24)) then
	begin
	CALL gerar_nas_sae(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra(102)) then
	begin
	CALL gerar_asg_ppp(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra(9)) then
	begin
	CALL gerar_escala_nih(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra(179)) then
	begin
	CALL gerar_escala_elpo(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra(75)) then
	begin
	CALL gerar_richmond(nr_sequencia_p,nm_usuario_p);
	end;
end if;
if (obter_se_existe_regra_sf_ii(nr_sequencia_p)) then
	begin
  CALL gerar_score_flex_ii_sae(nr_sequencia_p, nm_usuario_p);
	end;
end if;

CALL cp_generate_education_goal_pep(nr_sequencia_p, nm_usuario_p);

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '')then
	open C02;
	loop
	fetch C02 into	
		nr_seq_diag_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL gerar_lista_problema(nr_atendimento_w,'DE',null,nr_sequencia_p,nr_seq_diag_w,'PE_PRESCRICAO',nm_usuario_p,null);		
		end;
	end loop;
	close C02;
end if;

for prescription in suspend_sae_prescription loop
	CALL suspender_prescricao_sae(prescription.nr_sequencia, null, obter_desc_expressao(953847), nm_usuario_p);
end loop;

exception
	when others then
		null;
	end;


if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

	ie_gerar_evolucao_care_plan_w := obter_param_usuario(281, 1635, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1), ie_gerar_evolucao_care_plan_w);

        if ( ie_gerar_evolucao_care_plan_w = 'S' AND  (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and ie_tipo_w = 'CP' ) then
            cd_evolucao_w := clinical_notes_pck.gerar_soap(nr_atendimento_w, nr_sequencia_p, 'CARE_PLAN', NULL, 'P', 1, cd_evolucao_w, null, cd_pessoa_fisica_w);
            update pe_prescricao
            set cd_evolucao = cd_evolucao_w
            where nr_sequencia = nr_sequencia_p;
		end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_prescricao_enfemagem ( nr_sequencia_p bigint, nm_usuario_p text) is ie_gerar_equipe_proc_w varchar(1) FROM PUBLIC;

